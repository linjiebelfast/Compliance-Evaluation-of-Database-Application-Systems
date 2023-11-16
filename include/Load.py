import numpy as np
from .Config import Config
import json
import sys
import matplotlib.pyplot as plt
import matplotlib


def loadfile(fn, num=1):
    print('loading a file...' + fn)
    ret = []
    with open(fn, encoding='utf-8') as f:
        for line in f:
            th = line[:-1].split('\t')
            x = []
            for i in range(num):
                x.append(int(th[i]))
            ret.append(tuple(x))
    return ret


def loadRel(fn):
    print('loading rel info from a file...' + fn)
    ret = []
    with open(fn, encoding='utf-8') as f:
        for line in f:
            th = line[:-1].split('\t')
            rel = th[1]
            ret.append(int(rel))
    return ret


def loadILLrels(ILL, KG1, KG2):
    e_2_rels = {}  # key: entity  val: neighbor relations
    for KG in [KG1, KG2]:
        for tri in KG:
            if tri[0] not in e_2_rels:
                e_2_rels[tri[0]] = []     
            if tri[2] not in e_2_rels:
                e_2_rels[tri[2]] = []
            e_2_rels[tri[0]].append(tri[1])
            e_2_rels[tri[2]].append(tri[1])
    ILL_2_rels = {}
    for pair in ILL:
        ILL_2_rels[pair[0]] = e_2_rels[pair[0]]
        ILL_2_rels[pair[1]] = e_2_rels[pair[1]]
    return ILL_2_rels


def getCooccurInfo(e, KG, rels):
    print('getting co-occur info from KG1+KG2...')
    f = open('logs/' + Config.language + '_rel_info.txt', 'w')

    rel2occur = {}
    threshold = 2  

    for r in rels:
        M = {}
        for tri in KG:
            if tri[1] == r:
                M[(tri[0], tri[2])] = 1
        total_cnt = len(M)

        M_copy = M.copy()
        for tri in KG:
            if tri[1] != r and (tri[0], tri[2]) in M_copy:
                M_copy[(tri[0], tri[2])] += 1
        cooccur_cnt = 0
        for k, v in M_copy.items():
            if v >= threshold:
                cooccur_cnt += 1

        print('Relation {} | cooccur_cnt: {}  total_cnt: {}  cooccur_freq: {}'.format(r, cooccur_cnt, total_cnt,
                                                                                      round(cooccur_cnt / total_cnt,
                                                                                            2)))
        f.write('Relation {} | cooccur_cnt: {}  total_cnt: {}  cooccur_freq: {}\n'.format(r, cooccur_cnt, total_cnt,
                                                                                          round(cooccur_cnt / total_cnt,
                                                                                                2)))

        rel2occur[r] = [total_cnt, cooccur_cnt]

    matplotlib.rcParams['font.sans-serif'] = ['Menlo']
    matplotlib.rcParams['axes.unicode_minus'] = False  
    rel_id = [key for key, lval in rel2occur.items()]
    data = [val[1] for key, val in rel2occur.items()]
    plt.bar(rel_id, data)
    plt.xlabel("rel_id")
    plt.ylabel("freq")
    plt.title("Co-occurrence frequency")
    plt.savefig('logs/' + Config.language + '_rel_info.png')
    plt.show()

    freq = [val[1] for key, val in rel2occur.items() if val[1] <= 1000]  # 只统计<=1000的频次(每个关系出现的频次)
    plt.hist(freq, bins=100, density=True, facecolor="blue", edgecolor="black", alpha=0.7)
    plt.xlabel("freq")
    plt.ylabel("freq_percent")
    plt.title("Frequency distribution histogram")
    plt.savefig('logs/' + Config.language + '_freq_info.png')
    plt.show()

    freq_cnt = 0  
    freq_thre = 50
    for key, val in rel2occur.items():
        if val[1] >= freq_thre:
            freq_cnt += 1
    print('\nThe count of co-occur freq exceed `{}` of relation: {}/{}\n'.format(freq_thre, freq_cnt, len(rels)))

    prop_cnt = 0  
    prop_thre = 0.3
    total_thre = 50
    for key, val in rel2occur.items():
        if val[1] / val[0] >= prop_thre and val[0] >= total_thre:
            prop_cnt += 1
            print('cooccur_cnt: {}  total_cnt: {}  cooccur_prop: {}'.format(val[1], val[0], round(val[1] / val[0], 2)))
    print('\nThe count of co-occur prop exceed `{}` of relation: {}/{}\n'.format(prop_thre, prop_cnt, len(rels)))

    k = 1000

    rel2occur_sort1 = sorted(rel2occur.items(), key=lambda x: x[1][0], reverse=True)
    print(rel2occur_sort1)
    top_k_in_rel2occur_sort1 = [x[0] for x in rel2occur_sort1[:k]]
    rel2occur_sort2 = sorted(rel2occur.items(), key=lambda x: x[1][1], reverse=True)
    print(rel2occur_sort2)
    top_k_in_rel2occur_sort2 = [x[0] for x in rel2occur_sort2[:k]]

    unique_len = len(set(top_k_in_rel2occur_sort1+top_k_in_rel2occur_sort2))
    total_len = len(top_k_in_rel2occur_sort1) + len(top_k_in_rel2occur_sort2)
    repeat_len = total_len - unique_len
    repeat_rate = repeat_len/len(top_k_in_rel2occur_sort1)
    print(repeat_rate)


def loadNe(path): 
    language = path.split('/')[2]
    print(language)

    if language not in ['fr_en', 'ja_en', 'zh_en']:
        f1 = open(path)
        vectors = []
        for i, line in enumerate(f1):
            id, word, vect = line.rstrip().split('\t', 2)
            vect = np.fromstring(vect, sep=' ')
            vectors.append(vect)
        embeddings = np.vstack(vectors)
        return embeddings
    else:
        with open(file='./data/' + Config.language + '/' + Config.language.split('_')[0] + '_vectorList.json',
                  mode='r', encoding='utf-8') as f:
            embedding_list = json.load(f)
            print(len(embedding_list), 'rows,', len(embedding_list[0]), 'columns.')
            ne_vec = np.array(embedding_list)
        return ne_vec


def get_ent2id(fns):
    ent2id = {}
    for fn in fns:
        with open(fn, 'r', encoding='utf-8') as f:
            for line in f:
                th = line[:-1].split('\t')
                ent2id[th[1]] = int(th[0])
    return ent2id


def loadattr(fns, e, ent2id):
    cnt = {}
    for fn in fns:
        with open(fn, 'r', encoding='utf-8') as f:
            for line in f:
                th = line[:-1].split('\t')
                if th[0] not in ent2id:
                    continue
                for i in range(1, len(th)):
                    if th[i] not in cnt:
                        cnt[th[i]] = 1
                    else:
                        cnt[th[i]] += 1
    fre = [(k, cnt[k]) for k in sorted(cnt, key=cnt.get, reverse=True)]
    attr2id = {}

    at = 1000

    if len(cnt) < at:
        at = len(cnt)

    for i in range(at):
        attr2id[fre[i][0]] = i
    attr = np.zeros((e, at), dtype=np.float32)
    for fn in fns:
        with open(fn, 'r', encoding='utf-8') as f:
            for line in f:
                th = line[:-1].split('\t')
                if th[0] in ent2id:
                    for i in range(1, len(th)):
                        if th[i] in attr2id:
                            attr[ent2id[th[0]]][attr2id[th[i]]] = 1.0
    return attr
