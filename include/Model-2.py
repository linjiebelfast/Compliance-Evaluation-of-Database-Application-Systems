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

    return head_r, tail_r


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
        ## GCN-Align(fun/ifun)
        if (tri[0], tri[2]) not in M:
            M[(tri[0], tri[2])] = math.sqrt(math.sqrt(r2if[tri[1]]))
        else:
            M[(tri[0], tri[2])] += math.sqrt(math.sqrt(r2if[tri[1]]))
        if (tri[2], tri[0]) not in M:
            M[(tri[2], tri[0])] = math.sqrt(math.sqrt(r2f[tri[1]]))
        else:
            M[(tri[2], tri[0])] += math.sqrt(math.sqrt(r2f[tri[1]]))

    # \hat{A} = A + I
    for i in range(e):
        M[(i, i)] = 1
    return M, du


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


# re input layer  
def get_re_input_layer(tri, dimension):
    print('adding the re input layer...')  
    rel_embeddings = tf.Variable(tf.truncated_normal([tri, dimension], stddev=1.0 / math.sqrt(tri)))
    return tf.nn.l2_normalize(rel_embeddings, 1)


# get loss node
def get_loss_pre(outlayer, ILL, gamma, k, neg_left, neg_right, neg2_left, neg2_right):
    print('getting pre-loss...')
    left = ILL[:, 0]
    right = ILL[:, 1]
    left_x = tf.nn.embedding_lookup(outlayer, left)  
    right_x = tf.nn.embedding_lookup(outlayer, right)  
    A = tf.reduce_sum(tf.abs(left_x - right_x), 1)  
    neg_l_x = tf.nn.embedding_lookup(outlayer, neg_left)  
    neg_r_x = tf.nn.embedding_lookup(outlayer, neg_right)  
    B = tf.reduce_sum(tf.abs(neg_l_x - neg_r_x), 1)  
    C = - tf.reshape(B, [-1, k])  
    D = A + gamma
    L1 = tf.nn.relu(tf.add(C, tf.reshape(D, [-1, 1])))  
    neg_l_x = tf.nn.embedding_lookup(outlayer, neg_left)
    neg_r_x = tf.nn.embedding_lookup(outlayer, neg_right)
    B = tf.reduce_sum(tf.abs(neg_l_x - neg_r_x), 1)
    C = - tf.reshape(B, [-1, k])
    L2 = tf.nn.relu(tf.add(C, tf.reshape(D, [-1, 1])))
    return (tf.reduce_sum(L1) + tf.reduce_sum(L2)) / 2.0


def get_loss_transe(output_h, output_r, head, rel, tail, r1_ebd, tri_idx):
    h_ebd = tf.nn.embedding_lookup(output_h, head)    
    t_ebd = tf.nn.embedding_lookup(output_h, tail)

    # r_ebd = tf.nn.embedding_lookup(output_r, rel)
    r2_ebd = tf.nn.embedding_lookup(output_r, rel)
    r_ebd = tf.add(r1_ebd, r2_ebd)
    
    loss = tf.reduce_mean(tf.reduce_sum(tf.abs(h_ebd + r_ebd - t_ebd), 1))
    return loss


def highway(layer1, layer2, dimension):
    kernel_gate = glorot([dimension,dimension])
    bias_gate = zeros([dimension])
    transform_gate = tf.matmul(layer1, kernel_gate) + bias_gate
    transform_gate = tf.nn.sigmoid(transform_gate)
    carry_gate = 1.0 - transform_gate
    return transform_gate * layer2 + carry_gate * layer1


def build_Multi_SE(dimension, act_func, gamma, k, e, KG):
    tf.reset_default_graph()
    M = get_sparse_tensor(e, KG)  
    head_r, tail_r = rfunc(KG, e)

    # SE
    print('calculate KG structure embedding')
    se_input_layer = get_se_input_layer(e, dimension)  
    se_gcn_layer1 = add_diag_layer(se_layer, dimension, M, act_func, dropout=0.0)
    se_gcn_layer1 = highway(se_input_layer, gcn_layer_1, dimension)
    se_gcn_layer2 = add_diag_layer(gcn_layer_1, dimension, M, None, dropout=0.0)
    output_h =  highway(se_gcn_layer1, se_gcn_layer2, dimension)

    # RE
    re_input_layer = get_re_input_layer(len(KG), dimension)  # rel embedding (for each triple)

    print('calculate relation representations')
    output_r, output_r_w = compute_r(output_h, head_r, tail_r, dimension)

    ILL = tf.placeholder(tf.int32, [None,2], 'ILL')

    print("calculate pre-loss")
    neg_left = tf.placeholder(tf.int32, [None], "neg_left") 
    neg_right = tf.placeholder(tf.int32, [None], "neg_right")
    neg2_left = tf.placeholder(tf.int32, [None], "neg2_left")
    neg2_right = tf.placeholder(tf.int32, [None], "neg2_right")
    
    loss_align = get_loss_pre(output_h, ILL, gamma, k, neg_left, neg_right, neg2_left, neg2_right)

    print('calculate all-loss')
    tri_idx = tf.placeholder(tf.int32, [None], 'tri_idx')  
    head = tf.placeholder(tf.int32, [None], 'head')  
    rel = tf.placeholder(tf.int32, [None], 'rel')    
    tail = tf.placeholder(tf.int32, [None], 'tail')  

    head_ebd = tf.nn.embedding_lookup(output_h, head)    
    tail_ebd = tf.nn.embedding_lookup(output_h, tail)    
    specific_r = tf.concat([head_ebd, tail_ebd], axis=-1)  
    w_1 = glorot([dimension*2, dimension])    
    w_h_t = tf.sigmoid(tf.matmul(specific_r, w_r1))     
    rel_ebd = tf.nn.embedding_lookup(re_input_layer, tri_idx)  
    r1 = rel_ebd - tf.matmul(tf.matmul(w_h_t, tf.transpose(rel_ebd), w_h_t))

    loss_transe = get_loss_transe(output_h, output_r_w, head, rel, tail, r1, tri_idx)
    loss_all = loss_align + 0.001*loss_transe

    return output_h, output_r, loss_align, loss_all


def build_AE(attr, dimension, act_func, gamma, k, e, ILL, KG):
    tf.reset_default_graph()
    input_layer = get_ae_input_layer(attr)
    M = get_sparse_tensor(e, KG)
    hidden_layer = add_full_layer(input_layer, attr.shape[1], dimension, M, act_func, dropout=0.0)
    output_layer = add_diag_layer(hidden_layer, dimension, M, None, dropout=0.0)
    loss = get_loss(output_layer, ILL, gamma, k)
    return output_layer, loss


def get_hits(vec, test_pair, sim_e, top_k=(1,10)):
    ref = set()
    for pair in ref_data:
        ref.add((pair[0], pair[1]))

    L = np.array([e1 for e1, e2 in test_pair])
    R = np.array([e2 for e1, e2 in test_pair])
    Lvec = vec[L]
    Rvec = vec[R]

    sim = scipy.spatial.distance.cdist(Lvec, Rvec, metric='cityblock')

    mrr_l = []
    mrr_r = []
    
    top_lr = [0] * len(top_k)
    for i in range(Lvec.shape[0]):
        rank = sim[i, :].argsort()
        rank_index = np.where(rank == i)[0][0]
        mrr_l.append(1.0 / (rank_index+1))
        for j in range(len(top_k)):
            if rank_index < top_k[j]:
                top_lr[j] += 1

    top_rl = [0] * len(top_k)
    for i in range(Rvec.shape[0]):
        rank = sim[:, i].argsort()
        rank_index = np.where(rank == i)[0][0]
        mrr_r.append(1.0 / (rank_index+1))
        for j in range(len(top_k)):
            if rank_index < top_k[j]:
                top_rl[j] += 1

    print('Entity Alignment (left):')
    for i in range(len(top_lr)):
        print('Hits@%d: %.2f%%' % (top_k[i], top_lr[i] / len(test_pair) * 100))
    print('MRR: %.2f' % (np.mean(mrr_l)))
    
    print('Entity Alignment (right):')
    for i in range(len(top_rl)):
        print('Hits@%d: %.2f%%' % (top_k[i], top_rl[i] / len(test_pair) * 100))
    print('MRR: %.2f' % (np.mean(mrr_r)))
    
    return sim


def compute_r(inlayer, head_r, tail_r, dimension):
    head_l = tf.transpose(tf.constant(head_r, dtype=tf.float32))
    tail_l = tf.transpose(tf.constant(tail_r, dtype=tf.float32))
    L=tf.matmul(head_l,inlayer)/tf.expand_dims(tf.reduce_sum(head_l,axis=-1),-1)
    R=tf.matmul(tail_l,inlayer)/tf.expand_dims(tf.reduce_sum(tail_l,axis=-1),-1)

    r_forward = tf.concat([L,R], axis=-1)
    r_reverse = tf.concat([-L,-R], axis=-1)
    r_embeddings=tf.concat([r_forward,r_reverse],axis=0)

    w_r = glorot([dimension*2, dimension])
    r_embeddings_new = tf.matmul(r_embeddings, w_r)

    return r_embeddings, r_embeddings_new


def get_neg(ILL, output_layer, k, batchnum):
    neg = []
    t = len(ILL)
    ILL_vec = np.array([output_layer[e1] for e1 in ILL])
    KG_vec = np.array(output_layer)
    for p in range(batchnum):
        head = int(t / batchnum * p)
        if p==batchnum-1:
            tail=t
        else:
            tail = int(t / batchnum * (p + 1))
        sim = scipy.spatial.distance.cdist(
            ILL_vec[head:tail], KG_vec, metric='cityblock')
        for i in range(tail - head):
            rank = sim[i, :].argsort()
            neg.append(rank[0: k])

    neg = np.array(neg)
    neg = neg.reshape((t * k,))

    return neg


def training(output_h, loss_pre, loss_all, learning_rate, epochs, pre_epochs, ILL, e, k, 
    train_batchnum, test, KG):  
    train_step = tf.train.AdamOptimizer(learning_rate).minimize(loss_pre)
    train_all = tf.train.AdamOptimizer(learning_rate).minimize(loss_all)
    
    print('initializing...')
    saver = tf.train.Saver()
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

    kg_tri = []
    for tri in KG:
        kg_tri.append([tri[0], tri[1], tri[2]])
    tri_num = len(kg_tri)
    kg_tri = np.array(kg_tri)

    if not os.path.exists('Trans_model/'):
        os.makedirs('Trans_model/')

    if os.path.exists('Trans_model/save_' + Config.save_suffix + '.ckpt.meta'):
        saver.restore(sess, 'Trans_model/save_' + save_suffix + '.ckpt')
        start_epoch = pre_epochs
    else:
        start_epoch = 0

    for i in range(start_epoch, epochs):
        if i % pre_epochs == 0:
            out = sess.run(output_h)
            print('data preparation')
            neg2_left = get_neg(ILL[:, 1], out, k, train_batchnum)
            neg_right = get_neg(ILL[:, 0], out, k, train_batchnum)

        for j in range(train_batchnum):
            beg = int(t / train_batchnum * j)
            if j == train_batchnum-1:
                end = t
            else:
                end = int(t / train_batchnum * (j + 1))

            feed_dict = {}
            feed_dict["ILL:0"] = ILL[beg:end]
                feed_dict["neg_left:0"] = neg_left.reshape(
                    (t, k))[beg:end].reshape((-1,))
                feed_dict["neg_right:0"] = neg_right.reshape(
                    (t, k))[beg:end].reshape((-1,))
                feed_dict["neg2_left:0"] = neg2_left.reshape(
                    (t, k))[beg:end].reshape((-1,))
                feed_dict["neg2_right:0"] = neg2_right.reshape(
                    (t, k))[beg:end].reshape((-1,))

            if i < pre_epochs:
                _ = sess.run([train_step], feed_dict=feed_dict)
            else:
                beg = int(tri_num / train_batchnum * j)
                    if j == train_batchnum-1:
                        end = tri_num
                    else:
                        end = int(tri_num / train_batchnum * (j + 1))
                    
                    feed_dict["tri_idx:0"] = np.arange(begin,end)
                    feed_dict["head:0"] = kg_tri[beg:end, 0]
                    feed_dict["rel:0"] = kg_tri[beg:end, 1]
                    feed_dict["tail:0"] = kg_tri[beg:end, 2]
                    
                    _ = sess.run([train_all], feed_dict=feed_dict)
        if (i+1) % 10 == 0 or i == 0:
                print('%d/%d' % (i + 1, epochs), 'epochs...')

            if i == pre_epochs - 1:
                save_path = saver.save(sess, dn + '_' + "model/save_"+save_suffix+".ckpt")
                print("Save to path: ", save_path)

        if i == epochs - 1:
            print('Testing')
            iters = 3
            outvec, outvec_r = sess.run([output_h, output_r])
            print('iter: 1')

            sim_e = get_hits(outvec, ILL, test, None)
            for t in range(iters):
                print('iter: '+str(t+2))
                sim_e = get_hits(outvec, ILL, test, sim_e)
    
    sess.close()
    return outvec, sim_e

























