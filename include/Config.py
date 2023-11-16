import tensorflow as tf


class Config:
	# zh_en | ja_en | fr_en | en_fr_15k_V1 | en_de_15k_V1 | dbp_wd_15k_V1 | dbp_yg_15k_V1 | fb_dbp
	language = 'zh_en'  # 'dbp_yg_15k_V1'
	e1 = 'data/' + language + '/ent_ids_1'
	e2 = 'data/' + language + '/ent_ids_2'
	r1 = 'data/' + language + '/rel_ids_1'
	r2 = 'data/' + language + '/rel_ids_2'
	a1 = 'data/' + language + '/training_attrs_1'
	a2 = 'data/' + language + '/training_attrs_2'
	ill = 'data/' + language + '/ref_ent_ids'
	kg1 = 'data/' + language + '/triples_1'
	kg2 = 'data/' + language + '/triples_2'
	epochs_se = 300  
	epochs_ae = 300
	se_dim = 300
	ae_dim = 100
	act_func = tf.nn.relu
	seed = 3  # 30% of seeds

	# # count
	# num_specific = 1000   # RE(n-hot)
	# nhot_dim = 100
	# gamma = 3  # margin based loss, 3.0
	# k = 25  # number of negative samples for each positive one
	# beta = 0.9  # weight of SE

	# trans
	lr = 0.001
	save_suffix = language
	dim = 300
	gamma = 1.0
	k = 125
	epochs = 70
	pre_epochs = 50
	train_batchnum = 20
