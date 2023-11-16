import scipy.sparse as sp
from .Config import Config
from .Init import *
import tensorflow as tf
import numpy as np
import math
import warnings

warnings.filterwarnings(action='ignore')


def dot(x, y, sparse=False):
    """Wrapper for tf.matmul(sparse vs dense)."""
    if sparse:
        res = tf.sparse_tensor_dense_matmul(x, y)
    else:
        res = tf.matmul(x, y)
    return res


def func(KG):
    head = {}
    cnt = {}
    for tri in KG:
        if tri[1] not in cnt:
            cnt[tri[1]] = 1
            head[tri[1]] = {tri[0]}
        else:
            cnt[tri[1]] += 1
            head[tri[1]].add(tri[0])
    r2f = {}
    for r in cnt:
        r2f[r] = len(head[r]) / cnt[r]
    return r2f


def ifunc(KG):
    tail = {}
    cnt = {}
    for tri in KG:
        if tri[1] not in cnt:
            cnt[tri[1]] = 1
            tail[tri[1]] = {tri[2]}
        else:
            cnt[tri[1]] += 1
            tail[tri[1]].add(tri[2])
    r2if = {}
    for r in cnt:
        r2if[r] = len(tail[r]) / cnt[r]
    return r2if


def rfunc(KG, e):
    head = {}
    tail = {}
    cnt = {}
    # head[rel] = {.., .., ..}
    # tail[rel] = {.., .., ..}
    for tri in KG:
        if tri[1] not in cnt:
            cnt[tri[1]] = 1
            head[tri[1]] = set([tri[0]])
            tail[tri[1]] = set([tri[2]])
        else:
            cnt[tri[1]] += 1
            head[tri[1]].add(tri[0])
            tail[tri[1]].add(tri[2])
    r_num = len(head)
    head_r = np.zeros((e, r_num))
    tail_r = np.zeros((e, r_num))
    for tri in KG:
        head_r[tri[0]][tri[1]] = 1
        tail_r[tri[2]][tri[1]] = 1

    return head, tail, head_r, tail_r


def preprocess_adj(adj):
    """Preprocessing of adjacency matrix for simple GCN model and conversion to tuple representation."""
    adj_normalized = normalize_adj(adj)   # + sp.eye(adj.shape[0]))
    return sparse_to_tuple(adj_normalized)


def normalize_adj(adj):
    """Symmetrically normalize adjacency matrix."""
    adj = sp.coo_matrix(adj)
    rowsum = np.array(adj.sum(1))
    d_inv_sqrt = np.power(rowsum, -0.5).flatten()
    d_inv_sqrt[np.isinf(d_inv_sqrt)] = 0.
    d_mat_inv_sqrt = sp.diags(d_inv_sqrt)
    return adj.dot(d_mat_inv_sqrt).transpose().dot(d_mat_inv_sqrt).tocoo()


def sparse_to_tuple(sparse_mx):
    """Convert sparse matrix to tuple representation."""

    def to_tuple(mx):
        if not sp.isspmatrix_coo(mx):
            mx = mx.tocoo()
        coords = np.vstack((mx.row, mx.col)).transpose()
        values = mx.data
        shape = mx.shape
        return coords, values, shape

    if isinstance(sparse_mx, list):
        for i in range(len(sparse_mx)):
            sparse_mx[i] = to_tuple(sparse_mx[i])
    else:
        sparse_mx = to_tuple(sparse_mx)

    return sparse_mx


def get_mat(e, KG):
    r2f = func(KG)
    r2if = ifunc(KG)
    du = [1] * e
    for tri in KG:
        if tri[0] != tri[2]:
            du[tri[0]] += 1
            du[tri[2]] += 1
    M = {}
    for tri in KG:
        if tri[0] == tri[2]:
            continue
        if (tri[0], tri[2]) not in M:
            M[(tri[0], tri[2])] = math.sqrt(math.sqrt(r2if[tri[1]]))
        else:
            M[(tri[0], tri[2])] += math.sqrt(math.sqrt(r2if[tri[1]]))
        if (tri[2], tri[0]) not in M:
            M[(tri[2], tri[0])] = math.sqrt(math.sqrt(r2f[tri[1]]))
        else:
            M[(tri[2], tri[0])] += math.sqrt(math.sqrt(r2f[tri[1]]))

        # if (tri[0], tri[2]) not in M:
        #     M[(tri[0], tri[2])] = 1
        # else:
        #     M[(tri[0], tri[2])] += 1
        # if (tri[2], tri[0]) not in M:
        #     M[(tri[2], tri[0])] = 1
        # else:
        #     M[(tri[2], tri[0])] += 1

    # \hat{A} = A + I
    for i in range(e):
        M[(i, i)] = 1
    return M, du


# get a sparse tensor based on relational triples
def get_sparse_tensor(e, KG):
    print('getting a sparse tensor...')
    
    M, du = get_mat(e, KG)  
    ind = []
    val = []
    for fir, sec in M:
        ind.append((sec, fir))  
        val.append(M[(fir, sec)] / math.sqrt(du[fir]) / math.sqrt(du[sec]))  
    M = tf.SparseTensor(indices=ind, values=val, dense_shape=[e, e])
    # r2f = func(KG)
    # r2if = ifunc(KG)
    # M = {}
    # for tri in KG:
    #     if tri[0] == tri[2]:
    #         continue
    #     if (tri[0], tri[2]) not in M:
    #         M[(tri[0], tri[2])] = max(r2if[tri[1]], 0.3)
    #     else:
    #         M[(tri[0], tri[2])] += max(r2if[tri[1]], 0.3)
    #     if (tri[2], tri[0]) not in M:
    #         M[(tri[2], tri[0])] = max(r2f[tri[1]], 0.3)
    #     else:
    #         M[(tri[2], tri[0])] += max(r2f[tri[1]], 0.3)
    # for i in range(e):
    #     M[(i, i)] = 1

    # row = []
    # col = []
    # data = []
    # for key in M:
    #     row.append(key[1])
    #     col.append(key[0])
    #     data.append(M[key])
    # M = sp.coo_matrix((data, (row, col)), shape=(e, e))
    # M = preprocess_adj(M)  
    # M = tf.cast(tf.SparseTensor(indices=M[0], values=M[1], dense_shape=M[2]), tf.float32)
    return M


def get_relational_sparse_tensor(e, KG, rels):
    print('getting a sparse tensor list...')
    adjs = []
    for r in rels:
        M = {}
        for tri in KG:
            if tri[1] != r:
                continue
            else:
                if tri[0] == tri[2]:
                    continue
                if (tri[0], tri[2]) not in M:
                    M[(tri[0], tri[2])] = 1
                else:
                    M[(tri[0], tri[2])] += 1
                if (tri[2], tri[0]) not in M:
                    M[(tri[2], tri[0])] = 1
                else:
                    M[(tri[2], tri[0])] += 1
        for i in range(e):
            M[(i, i)] = 1

        row = []
        col = []
        data = []
        for key in M:
            row.append(key[1])
            col.append(key[0])
            data.append(M[key])
        M = sp.coo_matrix((data, (row, col)), shape=(e, e))
        M = preprocess_adj(M)
        M = tf.cast(tf.SparseTensor(indices=M[0], values=M[1], dense_shape=M[2]), tf.float32)

        adjs.append(M)
    return adjs


def update_coo_matrix(e, KG, new_rels, specific_rels, M_s):  
    for rel_idx in range(len(new_rels)):
        r = new_rels[rel_idx]
        du = [1] * e
        M = {}
        for tri in KG:
            if tri[1] != r:
                continue
            else:
                if tri[0] != tri[2]:
                    du[tri[0]] += 1
                    du[tri[2]] += 1
                if tri[0] == tri[2]:
                    continue
                if (tri[0], tri[2]) not in M:
                    M[(tri[0], tri[2])] = 1
                else:
                    M[(tri[0], tri[2])] += 1
                if (tri[2], tri[0]) not in M:
                    M[(tri[2], tri[0])] = 1
                else:
                    M[(tri[2], tri[0])] += 1
        for i in range(e):
            M[(i, i)] = 1

        row = []
        col = []
        data = []
        for key in M:
            row.append(key[1])
            col.append(key[0])
            data.append(M[key] / math.sqrt(du[key[0]]) / math.sqrt(du[key[1]]))   
        M = sp.coo_matrix((data, (row, col)), shape=(e, e))
        M_s[len(specific_rels) + rel_idx] = M  
    return M_s


# add a layer
def add_diag_layer(inlayer, dimension, M, act_func, dropout=0.0, init=ones):
    inlayer = tf.nn.dropout(inlayer, 1 - dropout) 
    print('adding a layer...')
    w0 = init([1, dimension])  
    tosum = tf.sparse_tensor_dense_matmul(M, tf.multiply(inlayer, w0))  
    if act_func is None:
        return tosum
    else:
        return act_func(tosum)


def add_rgcn_layer(inlayer, dimension_in, dimension_out, num_bases, num_rel, M_s, act_func, bias=True, dropout=0.0):
    inlayer = tf.nn.dropout(inlayer, 1 - dropout)  
    print('adding a layer...')

    if num_bases > 0:  
        w_bases = glorot([num_bases, dimension_in, dimension_out])
        w_rel = glorot([num_rel, num_bases])
        w = tf.einsum("rb, bio -> rio", w_rel, w_bases)
    else:
        w = glorot([num_rel, dimension_in, dimension_out])
    if bias:
        bias = tf.Variable(tf.zeros([dimension_out]), name='biases')  # (dimension_out,)

    supports = list()
    for i in range(num_rel):
        if inlayer is not None:
            pre_sup = dot(inlayer, w[i])  
        else:
            pre_sup = w[i]  
        support = dot(tf.cast(M_s[i], tf.float32), pre_sup, sparse=True)  
        supports.append(support)  
    out = tf.add_n(supports)  

    if bias:
        out += tf.expand_dims(bias, 0)
    if act_func is None:
        return out
    else:
        return act_func(out)


def add_full_layer(inlayer, dimension_in, dimension_out, M, act_func, dropout=0.0, init=glorot):  
    inlayer = tf.nn.dropout(inlayer, 1 - dropout)
    print('adding a layer...')
    w0 = init([dimension_in, dimension_out])
    tosum = tf.sparse_tensor_dense_matmul(M, tf.matmul(inlayer, w0))
    if act_func is None:
        return tosum
    else:
        return act_func(tosum)


# se input layer
def get_se_input_layer(e, dimension):
    print('adding the se input layer...')
    ent_embeddings = tf.Variable(tf.truncated_normal([e, dimension], stddev=1.0 / math.sqrt(e)))
    return tf.nn.l2_normalize(ent_embeddings, 1)


# ae input layer
def get_ae_input_layer(attr):
    print('adding the ae input layer...')
    return tf.constant(attr)


def get_loss(outlayer, ILL, gamma, k):
    print('getting loss...')
    left = ILL[:, 0]
    right = ILL[:, 1]
    t = len(ILL)
    left_x = tf.nn.embedding_lookup(outlayer, left)  
    right_x = tf.nn.embedding_lookup(outlayer, right)  
    A = tf.reduce_sum(tf.abs(left_x - right_x), 1)  
    neg_left = tf.placeholder(tf.int32, [t * k], "neg_left")  
    neg_right = tf.placeholder(tf.int32, [t * k], "neg_right")  
    neg_l_x = tf.nn.embedding_lookup(outlayer, neg_left)  
    neg_r_x = tf.nn.embedding_lookup(outlayer, neg_right)  
    B = tf.reduce_sum(tf.abs(neg_l_x - neg_r_x), 1)  
    C = - tf.reshape(B, [t, k])  
    D = A + gamma
    L1 = tf.nn.relu(tf.add(C, tf.reshape(D, [t, 1])))  

    neg_left = tf.placeholder(tf.int32, [t * k], "neg2_left")
    neg_right = tf.placeholder(tf.int32, [t * k], "neg2_right")
    neg_l_x = tf.nn.embedding_lookup(outlayer, neg_left)
    neg_r_x = tf.nn.embedding_lookup(outlayer, neg_right)
    B = tf.reduce_sum(tf.abs(neg_l_x - neg_r_x), 1)
    C = - tf.reshape(B, [t, k])
    L2 = tf.nn.relu(tf.add(C, tf.reshape(D, [t, 1])))

    return (tf.reduce_sum(L1) + tf.reduce_sum(L2)) / (2.0 * k * t)


def build_SE(dimension, act_func, gamma, k, e, ILL, KG, attr):
    tf.reset_default_graph()
    M = get_sparse_tensor(e, KG)  
    se_layer = get_se_input_layer(e, dimension)  
    se_hidden = add_diag_layer(se_layer, dimension, M, act_func, dropout=0.0)
    output_layer = add_diag_layer(se_hidden, dimension, M, None, dropout=0.0)
    loss = get_loss(output_layer, ILL, gamma, k)
    return output_layer, loss


def build_RGCN_SE(dimension_in, dimension_hidden, dimension_out, num_bases, num_rel, act_func, gamma, k, e, rels, ILL,
                  KG):
    tf.reset_default_graph()
    input_layer = get_se_input_layer(e, dimension_in) 
    M_s = get_relational_sparse_tensor(e, KG, rels)  
    hidden_layer = add_rgcn_layer(input_layer, dimension_in, dimension_hidden, num_bases, num_rel, M_s, act_func,
                                  bias=False, dropout=0.0)  
    output_layer = add_rgcn_layer(hidden_layer, dimension_hidden, dimension_out, num_bases, num_rel, M_s, None,
                                  bias=False, dropout=0.0)  
    loss = get_loss(output_layer, ILL, gamma, k)
    return output_layer, loss


def highway(layer1, layer2, dimension):
    kernel_gate = glorot([dimension,dimension])
    bias_gate = zeros([dimension])
    transform_gate = tf.matmul(layer1, kernel_gate) + bias_gate
    transform_gate = tf.nn.sigmoid(transform_gate)
    carry_gate = 1.0 - transform_gate
    return transform_gate * layer2 + carry_gate * layer1


def build_Multi_SE(with_nhot, dimension, num_bases, act_func, gamma, k, e, rels, ILL, KG, attr):
    tf.reset_default_graph()
    M = get_sparse_tensor(e, KG, with_fun=False)  

    print('calculate KG structure embedding')
    se_input_layer = get_se_input_layer(e, dimension)  
    se_gcn_layer1 = add_diag_layer(se_input_layer, dimension, M, act_func, dropout=0.0)
    se_gcn_layer1 = highway(se_input_layer, gcn_layer_1, dimension)
    se_gcn_layer2 = add_diag_layer(gcn_layer_1, dimension, M, None, dropout=0.0)
    output_layer =  highway(se_gcn_layer1, se_gcn_layer2, dimension)

    if with_nhot:
        print('calculate n-hot rel representations')
        nhot_input_layer = tf.placeholder(tf.float32, shape=[e, Config.num_specific], name="nhot_vec")
        gcn_layer_1 = add_full_layer(nhot_layer, Config.num_specific, Config.nhot_dim, M, act_func, dropout=0.0)
        gcn_layer_1 = highway(nhot_input_layer, gcn_layer_1, Config.nhot_dim)
        gcn_layer_2 = add_diag_layer(gcn_layer_1, Config.nhot_dim, M, None, dropout=0.0)
        nhot_output = highway(gcn_layer_1, gcn_layer_2, Config.nhot_dim)
        output_layer = tf.concat([output_layer, nhot_output], 1)

    loss = get_loss(output_layer, ILL, gamma, k)
    return output_layer, loss


def build_AE(attr, dimension, act_func, gamma, k, e, ILL, KG):
    tf.reset_default_graph()
    input_layer = get_ae_input_layer(attr)
    M = get_sparse_tensor(e, KG)
    hidden_layer = add_full_layer(input_layer, attr.shape[1], dimension, M, act_func, dropout=0.0)
    output_layer = add_diag_layer(hidden_layer, dimension, M, None, dropout=0.0)
    loss = get_loss(output_layer, ILL, gamma, k)
    return output_layer, loss


def getsim_se_matrix_cosine(se_vec, train_pair):
    Lvec = tf.placeholder(tf.float32, [None, se_vec.shape[1]], "Lvec")
    Rvec = tf.placeholder(tf.float32, [None, se_vec.shape[1]], "Rvec")
    he = tf.nn.l2_normalize(Lvec, dim=-1)
    norm_e_em = tf.nn.l2_normalize(Rvec, dim=-1)
    aep = tf.matmul(he, tf.transpose(norm_e_em))
    aep = 1 - aep
    return aep


def get_hits_for_train(sim, train_pair, ILL_2_rels, specific_relations, new_rels_cnt, top_k=1):
    top_lr = 0
    error_rels_cnt = {}
    for i in range(sim.shape[0]):
        rank = sim[i, :].argsort()
        rank_index = np.where(rank == i)[0][0]
        if rank_index < top_k:
            top_lr += 1
        else:
            error_e_rels = ILL_2_rels[train_pair[i][0]] + ILL_2_rels[train_pair[i][1]]
            for rel in error_e_rels:
                if rel not in error_rels_cnt:
                    error_rels_cnt[rel] = 0
                error_rels_cnt[rel] += 1
    print("Hits for training set: {}/{}".format(top_lr, len(train_pair)))
    print("Hits@{}:{:.3f}".format(top_k, top_lr / len(train_pair)))
    error_rels_cnt = sorted(error_rels_cnt.items(), key=lambda x: x[1], reverse=True)

    new_rels = []
    for rel_cnt in error_rels_cnt:
        if (len(new_rels) < new_rels_cnt) and (rel_cnt[0] not in specific_relations):
            new_rels.append(rel_cnt[0])
    return new_rels


def training(with_nhot, output_layer, loss, KG, se_sim, ILL_2_rels, learning_rate, epochs, ILL, e,
             k):  
    # train_step = tf.train.AdamOptimizer(learning_rate).minimize(loss)
    train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(loss)  
    print('initializing...')
    init = tf.global_variables_initializer()
    sess = tf.Session()
    sess.run(init)
    print('running...')
    J = []
    t = len(ILL)  
    ILL = np.array(ILL)  
    L = np.ones((t, k)) * (ILL[:, 0].reshape((t, 1)))  
    neg_left = L.reshape((t * k,))  
    L = np.ones((t, k)) * (ILL[:, 1].reshape((t, 1)))  
    neg2_right = L.reshape((t * k,))  

    if with_nhot:
        initial_flag = False  
        total_specific_rels = Config.num_specific
        specific_rels = []
        nhot_vec = np.zeros([e, total_specific_rels])

    for i in range(epochs):
        print('epoch {}..'
              '.'.format(i))
        if i % 10 == 0:
            neg2_left = np.random.choice(e, t * k)
            neg_right = np.random.choice(e, t * k)

        if with_nhot and not initial_flag:
            for entity_idx in range(e):
                if entity_idx not in ILL_2_rels:
                    continue
                e_rels = ILL_2_rels[entity_idx]  
                for rel in e_rels:
                    if rel in specific_rels:
                        nhot_vec[entity_idx][specific_rels.index(rel)] += 1
            if len(specific_rels) == total_specific_rels:
                initial_flag = True
                # print('n-hot rels: ', specific_rels)

        feed_dict = {"neg_left:0": neg_left,
                     "neg_right:0": neg_right,
                     "neg2_left:0": neg2_left,
                     "neg2_right:0": neg2_right
                     }
        if with_nhot:
            feed_dict.update({"nhot_vec:0": nhot_vec})
        sess.run(train_step, feed_dict=feed_dict)

        if (i + 1) % 20 == 0:
            feed_dict = {"neg_left:0": neg_left,
                         "neg_right:0": neg_right,
                         "neg2_left:0": neg2_left,
                         "neg2_right:0": neg2_right}
            if with_nhot:
                feed_dict.update({"nhot_vec:0": nhot_vec})
            th = sess.run(loss, feed_dict=feed_dict)
            # J.append(th)  
            print('{}/{} epochs | loss: {}'.format((i + 1), epochs, th))

            if with_nhot and len(specific_rels) < total_specific_rels:
                # print('Test for training set...')
                feed_dict = dict()
                feed_dict.update({"nhot_vec:0": nhot_vec})
                se_vec = sess.run(output_layer, feed_dict=feed_dict)

                Lv = np.array([se_vec[e1] for e1, e2 in ILL])
                Rv = np.array([se_vec[e2] for e1, e2 in ILL])
                aep = sess.run(se_sim, feed_dict={"Lvec:0": Lv, "Rvec:0": Rv})

                if (i + 1) == 20:
                    new_rels = get_hits_for_train(aep, ILL, ILL_2_rels, specific_rels, new_rels_cnt=0.5*Config.num_specific, top_k=1)
                    specific_rels = specific_rels + new_rels
                else:
                    new_rels = get_hits_for_train(aep, ILL, ILL_2_rels, specific_rels, new_rels_cnt=0.05*Config.num_specific, top_k=1)
                    specific_rels = specific_rels + new_rels

    if with_nhot:
        feed_dict = dict()
        feed_dict.update({"nhot_vec:0": nhot_vec})
        outvec = sess.run(output_layer, feed_dict=feed_dict)
    else:
        outvec = sess.run(output_layer)
    sess.close()
    return outvec
