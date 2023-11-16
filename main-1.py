from include.Config import Config
import tensorflow as tf
from include.Model_nhot import build_SE, build_RGCN_SE, training, getsim_se_matrix_cosine, build_Multi_SE
import time
from include.Load import *
import json
import scipy
from scipy import spatial
import copy
from collections import defaultdict

import os
os.environ["CUDA_VISIBLE_DEVICES"] = "0"

seed = 12306
np.random.seed(seed)
tf.set_random_seed(seed)


def make_print_to_file(fileName, path='./'):
    import sys
    import os
    import sys
    import datetime

    class Logger(object):
        def __init__(self, filename="Default.log", path="./"):
            self.terminal = sys.stdout
            self.log = open(os.path.join(path, filename), "a", encoding='utf8', )

        def write(self, message):
            self.terminal.write(message)
            self.log.write(message)

        def flush(self):
            pass

    sys.stdout = Logger(fileName + '.log', path=path)
    print(fileName.center(60, '*'))


def getsim_matrix_cosine(se_vec, test_pair):
    Lvec = tf.placeholder(tf.float32, [None, se_vec.shape[1]])
    Rvec = tf.placeholder(tf.float32, [None, se_vec.shape[1]])
    he = tf.nn.l2_normalize(Lvec, dim=-1)
    norm_e_em = tf.nn.l2_normalize(Rvec, dim=-1)
    aep = tf.matmul(he, tf.transpose(norm_e_em))

    sess = tf.Session()
    Lv = np.array([se_vec[e1] for e1, e2 in test_pair])   
    Lid_record = np.array([e1 for e1, e2 in test_pair])  
    Rv = np.array([se_vec[e2] for e1, e2 in test_pair])   
    Rid_record = np.array([e2 for e1, e2 in test_pair])  

    aep = sess.run(aep, feed_dict={Lvec: Lv, Rvec: Rv})   
    aep = 1 - aep
    return aep


def get_hits(vec, test_pair, top_k=(1, 10, 50, 100)):
    Lvec = np.array([vec[e1] for e1, e2 in test_pair])
    Rvec = np.array([vec[e2] for e1, e2 in test_pair])
    sim = scipy.spatial.distance.cdist(Lvec, Rvec, metric='cosine')
    top_lr = [0] * len(top_k)
    mrr_sum_l = 0
    for i in range(Lvec.shape[0]):
        rank = sim[i, :].argsort()
        rank_index = np.where(rank == i)[0][0]
        mrr_sum_l = mrr_sum_l + 1.0 / (rank_index + 1)
        for j in range(len(top_k)):
            if rank_index < top_k[j]:
                top_lr[j] += 1
    print('For each left:')
    for i in range(len(top_lr)):
        print('Hits@%d: %.2f%%' % (top_k[i], top_lr[i] / len(test_pair) * 100))
    print("MRR: " + str(mrr_sum_l / len(test_pair)))


def get_hits_ma(sim, test_pair, top_k=(1, 10)):
    top_lr = [0] * len(top_k)    
    mrr_sum_l = 0   
    test_pair_sim = []    
    for i in range(sim.shape[0]):
        rank = sim[i, :].argsort()  
        rank_index = np.where(rank == i)[0][0]  
        mrr_sum_l = mrr_sum_l + 1.0 / (rank_index + 1)
        for j in range(len(top_k)):
            if rank_index < top_k[j]:
                top_lr[j] += 1
        if rank_index < 1:  
            test_pair_sim.append(1-sim[i, i])
    test_pair_sim.sort()
    print('test_pair_sim_for_Hits@1: ', test_pair_sim)
    msg = 'Hits@1:%.3f, Hits@10:%.3f, MRR:%.3f\n' % (
        top_lr[0] / len(test_pair), top_lr[1] / len(test_pair), mrr_sum_l / len(test_pair))
    print(msg)


def male_without_match(matches, males):
    for male in males:
        if male not in matches:
            return male


def deferred_acceptance(male_prefs, female_prefs):
    female_queue = defaultdict(int)
    males = list(male_prefs.keys())
    matches = {}
    while True:
        male = male_without_match(matches, males)
        # print(male)
        if male is None:
            break
        female_index = female_queue[male]
        female_queue[male] += 1
        # print(female_index)

        try:
            female = male_prefs[male][female_index]
        except IndexError:
            matches[male] = male
            continue
        # print('Trying %s with %s... ' % (male, female), end='')
        prev_male = matches.get(female, None)
        if not prev_male:
            matches[male] = female
            matches[female] = male
            # print('auto')
        elif female_prefs[female].index(male) < \
                female_prefs[female].index(prev_male):
            matches[male] = female
            matches[female] = male
            del matches[prev_male]
            # print('matched')
        # else:
        # print('rejected')
    return {male: matches[male] for male in male_prefs.keys()}


if __name__ == '__main__':
    make_print_to_file(Config.language, path='./logs/')
    t = time.time()

    e = len(set(loadfile(Config.e1, 1)) | set(loadfile(Config.e2, 1)))  
    r = list(set(loadRel(Config.kg1)) | set(loadRel(Config.kg2)))  

    ent2id = get_ent2id([Config.e1, Config.e2])  
    attr = loadattr([Config.a1, Config.a2], e, ent2id)

    ILL = loadfile(Config.ill, 2)  
    illL = len(ILL)

    test = ILL[:10500]  
    train = np.array(ILL[10500:])  
    KG1 = loadfile(Config.kg1, 3) 
    KG2 = loadfile(Config.kg2, 3)  

    ILL_2_rels = loadILLrels(ILL, KG1, KG2)

    # ---GCN---
    output_layer, loss = build_SE(Config.se_dim, Config.act_func, Config.gamma, Config.k, e, train, KG1 + KG2, attr, False)

    # ---Multi---
    # output_layer, loss = build_Multi_SE(False, Config.se_dim, Config.num_bases, Config.num_specific, Config.act_func,
    #                                     Config.gamma, Config.k, e, r, train, KG1 + KG2, attr)

    se_vec = training(False, output_layer, loss, KG1+KG2, se_sim, ILL_2_rels, 25, Config.epochs_se, train, e, Config.k)

    get_hits(se_vec, test)

    aep = getsim_matrix_cosine(se_vec, test)
    print(aep)

    print('stable matching...') 
    string_mat = 1 - aep_fuse
    scale = string_mat.shape[0]
    # store preferences
    MALE_PREFS = {}
    FEMALE_PREFS = {}
    
    pref = np.argsort(-string_mat[:scale, :scale], axis=1)
    pref_col = np.argsort(-string_mat[:scale, :scale], axis=0)
    
    for i in range(scale):
        # print(i)
        lis = pref[i]
        newlis = []
        for item in lis:
            newlis.append(item + 10500)
        MALE_PREFS[i] = newlis
    
    for i in range(scale):
        FEMALE_PREFS[i + 10500] = pref_col[:, i].tolist()
    
    matches = deferred_acceptance(MALE_PREFS, FEMALE_PREFS)
    
    # print(matches)
    trueC = 0
    for match in matches:
        if match + 10500 == matches[match]:
            trueC += 1
    print('accuracy： ' + str(float(trueC) / 10500))
    
    print("total time elapsed: {:.4f} s".format(time.time() - t))
