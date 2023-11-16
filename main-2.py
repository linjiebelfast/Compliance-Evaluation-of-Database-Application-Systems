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
    e = len(set(loadfile(Config.e1, 1)) | set(loadfile(Config.e2, 1)))  
    r = list(set(loadRel(Config.kg1)) | set(loadRel(Config.kg2)))  

    # Attr
    # ent2id = get_ent2id([Config.e1, Config.e2])  # attr
    # attr = loadattr([Config.a1, Config.a2], e, ent2id)

    ILL = loadfile(Config.ill, 2) 
    illL = len(ILL)
    # random
    np.random.shuffle(ILL)
    train = np.array(ILL[:illL // 10 * Config.seed])
    test = ILL[illL // 10 * Config.seed:]

    KG1 = loadfile(Config.kg1, 3) 
    KG2 = loadfile(Config.kg2, 3)  

    r_kg_1, r_kg = set(), set()

    for tri in KG1:
        r_kg_1.add(tri[1])
        r_kg.add(tri[1])

    for tri in KG2:
        r_kg.add(tri[1])


    output_h, output_r, loss_align, loss_all = build_Multi_SE(Config.dim, Config.act_func,
                                                        Config.gamma, Config.k, e, KG1+KG2)

    outvec, sim_e = training(output_h, loss_align, loss_all, Config.lr, Config.epochs, Config.pre_epochs, 
                                train, e, Config.k, Config.train_batchnum, test, KG1+KG2)


    print('stable matching...')  
    string_mat = 1 - sim_e
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
