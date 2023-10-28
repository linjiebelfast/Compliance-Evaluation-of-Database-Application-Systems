/*
 Navicat Premium Data Transfer

 Source Server         : 54 pg
 Source Server Type    : PostgreSQL
 Source Server Version : 130010
 Source Host           : 192.168.2.54:5432
 Source Catalog        : qianwei-test
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 130010
 File Encoding         : 65001

 Date: 27/10/2023 10:05:51
*/


-- ----------------------------
-- Sequence structure for act_evt_log_log_nr__seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."act_evt_log_log_nr__seq";
CREATE SEQUENCE "public"."act_evt_log_log_nr__seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for act_hi_tsk_log_id__seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."act_hi_tsk_log_id__seq";
CREATE SEQUENCE "public"."act_hi_tsk_log_id__seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for undo_log_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."undo_log_id_seq";
CREATE SEQUENCE "public"."undo_log_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 999999999
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for user_id_quence
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."user_id_quence";
CREATE SEQUENCE "public"."user_id_quence" 
INCREMENT 1
MINVALUE  1001
MAXVALUE 99999999
START 1001
CACHE 1
CYCLE ;

-- ----------------------------
-- Table structure for Access
-- ----------------------------
DROP TABLE IF EXISTS "public"."Access";
CREATE TABLE "public"."Access" (
  "id" int8 NOT NULL,
  "debug" int4 NOT NULL DEFAULT 0,
  "name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL DEFAULT '实际表名，例如 apijson_user'::character varying,
  "alias" text COLLATE "pg_catalog"."default",
  "get" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '["neglected"]'::text,
  "head" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '["neglected"]'::text,
  "gets" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '["neglected"]'::text,
  "heads" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '["neglected"]'::text,
  "post" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '["neglected"]'::text,
  "put" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '["neglected"]'::text,
  "delete" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT '["neglected"]'::text,
  "date" text COLLATE "pg_catalog"."default" NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "hasDeptId" int4 DEFAULT 0,
  "logically" int4 DEFAULT 1
)
;
COMMENT ON COLUMN "public"."Access"."id" IS '唯一标识';
COMMENT ON COLUMN "public"."Access"."debug" IS '是否为调试表，只允许在开发环境使用，测试和线上环境禁用';
COMMENT ON COLUMN "public"."Access"."alias" IS '外部调用的表别名，例如 User';
COMMENT ON COLUMN "public"."Access"."get" IS '允许 get 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN "public"."Access"."head" IS '允许 head 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN "public"."Access"."gets" IS '允许 gets 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN "public"."Access"."heads" IS '允许 heads 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN "public"."Access"."post" IS '允许 post 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN "public"."Access"."put" IS '允许 put 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN "public"."Access"."delete" IS '允许 delete 的角色列表，例如 ["LOGIN", "CONTACT", "CIRCLE", "OWNER"]';
COMMENT ON COLUMN "public"."Access"."date" IS '创建时间';
COMMENT ON COLUMN "public"."Access"."hasDeptId" IS '是否需要进行数据权限过滤';
COMMENT ON COLUMN "public"."Access"."logically" IS '是否逻辑删除 0-否 1-是 ';
COMMENT ON TABLE "public"."Access" IS '权限注册';

-- ----------------------------
-- Table structure for Document
-- ----------------------------
DROP TABLE IF EXISTS "public"."Document";
CREATE TABLE "public"."Document" (
  "id" int8 NOT NULL,
  "userId" int8 NOT NULL,
  "version" int2 NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "url" varchar(250) COLLATE "pg_catalog"."default" NOT NULL,
  "request" text COLLATE "pg_catalog"."default" NOT NULL,
  "response" text COLLATE "pg_catalog"."default",
  "header" text COLLATE "pg_catalog"."default",
  "date" timestamp(6)
)
;
COMMENT ON COLUMN "public"."Document"."id" IS '唯一标识';
COMMENT ON COLUMN "public"."Document"."userId" IS '用户id
		应该用adminId，只有当登录账户是管理员时才能操作文档。
		需要先建Admin表，新增登录等相关接口。';
COMMENT ON COLUMN "public"."Document"."version" IS '接口版本号
		<=0 - 不限制版本，任意版本都可用这个接口
		>0 - 在这个版本添加的接口';
COMMENT ON COLUMN "public"."Document"."name" IS '接口名称';
COMMENT ON COLUMN "public"."Document"."url" IS '请求地址';
COMMENT ON COLUMN "public"."Document"."request" IS '请求
		用json格式会导致强制排序，而请求中引用赋值只能引用上面的字段，必须有序。';
COMMENT ON COLUMN "public"."Document"."response" IS '标准返回结果JSON
		用json格式会导致强制排序，而请求中引用赋值只能引用上面的字段，必须有序。';
COMMENT ON COLUMN "public"."Document"."header" IS '请求头 Request Header：
		key: value //注释';
COMMENT ON COLUMN "public"."Document"."date" IS '创建时间';

-- ----------------------------
-- Table structure for Function
-- ----------------------------
DROP TABLE IF EXISTS "public"."Function";
CREATE TABLE "public"."Function" (
  "id" int8 NOT NULL,
  "name" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "arguments" varchar(100) COLLATE "pg_catalog"."default",
  "demo" text COLLATE "pg_catalog"."default" NOT NULL,
  "detail" varchar(1000) COLLATE "pg_catalog"."default",
  "date" timestamp(6) NOT NULL,
  "back" varchar(45) COLLATE "pg_catalog"."default",
  "requestlist" varchar(45) COLLATE "pg_catalog"."default",
  "userId" int8 DEFAULT 0,
  "type" varchar(45) COLLATE "pg_catalog"."default" DEFAULT 'Object'::character varying
)
;
COMMENT ON COLUMN "public"."Function"."name" IS '方法名';
COMMENT ON COLUMN "public"."Function"."arguments" IS '参数列表，每个参数的类型都是 String。
用 , 分割的字符串 比 [JSONArray] 更好，例如 array,item ，更直观，还方便拼接函数。';
COMMENT ON COLUMN "public"."Function"."demo" IS '可用的示例。';
COMMENT ON COLUMN "public"."Function"."detail" IS '详细描述';
COMMENT ON COLUMN "public"."Function"."date" IS '创建时间';
COMMENT ON COLUMN "public"."Function"."back" IS '返回类型';
COMMENT ON COLUMN "public"."Function"."requestlist" IS 'Request 的 id 列表';
COMMENT ON COLUMN "public"."Function"."userId" IS '用户id';
COMMENT ON COLUMN "public"."Function"."type" IS '返回类型';

-- ----------------------------
-- Table structure for Request
-- ----------------------------
DROP TABLE IF EXISTS "public"."Request";
CREATE TABLE "public"."Request" (
  "id" int8 NOT NULL,
  "version" int2 NOT NULL,
  "method" varchar(100) COLLATE "pg_catalog"."default",
  "tag" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "structure" jsonb NOT NULL,
  "detail" varchar(10000) COLLATE "pg_catalog"."default",
  "date" timestamp(6) DEFAULT now()
)
;
COMMENT ON COLUMN "public"."Request"."id" IS '唯一标识';
COMMENT ON COLUMN "public"."Request"."version" IS 'GET,HEAD可用任意结构访问任意开放内容，不需要这个字段。
其它的操作因为写入了结构和内容，所以都需要，按照不同的version选择对应的structure。

自动化版本管理：
Request JSON最外层可以传 "version":Integer 。
1.未传或 <= 0，用最新版。 "@order":"version-"
2.已传且 > 0，用version以上的可用版本的最低版本。 "@order":"version+", "version{}":">={version}"';
COMMENT ON COLUMN "public"."Request"."method" IS '只限于GET,HEAD外的操作方法。';
COMMENT ON COLUMN "public"."Request"."tag" IS '标签';
COMMENT ON COLUMN "public"."Request"."structure" IS '结构';
COMMENT ON COLUMN "public"."Request"."detail" IS '详细说明';
COMMENT ON COLUMN "public"."Request"."date" IS '创建时间';

-- ----------------------------
-- Table structure for Response
-- ----------------------------
DROP TABLE IF EXISTS "public"."Response";
CREATE TABLE "public"."Response" (
  "id" int8 NOT NULL,
  "method" varchar(10) COLLATE "pg_catalog"."default",
  "model" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "structure" text COLLATE "pg_catalog"."default" NOT NULL,
  "detail" varchar(10000) COLLATE "pg_catalog"."default",
  "date" timestamp(6)
)
;
COMMENT ON COLUMN "public"."Response"."id" IS '唯一标识';
COMMENT ON COLUMN "public"."Response"."method" IS '方法';
COMMENT ON COLUMN "public"."Response"."model" IS '表名，table是SQL关键词不能用';
COMMENT ON COLUMN "public"."Response"."structure" IS '结构';
COMMENT ON COLUMN "public"."Response"."detail" IS '详细说明';
COMMENT ON COLUMN "public"."Response"."date" IS '创建日期';

-- ----------------------------
-- Table structure for TestRecord
-- ----------------------------
DROP TABLE IF EXISTS "public"."TestRecord";
CREATE TABLE "public"."TestRecord" (
  "id" int8 NOT NULL,
  "userId" int8 NOT NULL,
  "documentId" int8 NOT NULL,
  "response" text COLLATE "pg_catalog"."default" NOT NULL,
  "date" timestamp(6) NOT NULL,
  "compare" text COLLATE "pg_catalog"."default",
  "standard" text COLLATE "pg_catalog"."default",
  "randomId" int8 DEFAULT 0,
  "duration" varchar(255) COLLATE "pg_catalog"."default",
  "minDuration" varchar(255) COLLATE "pg_catalog"."default",
  "maxDuration" varchar(255) COLLATE "pg_catalog"."default",
  "host" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."TestRecord"."id" IS '唯一标识';
COMMENT ON COLUMN "public"."TestRecord"."userId" IS '用户id';
COMMENT ON COLUMN "public"."TestRecord"."documentId" IS '测试用例文档id';
COMMENT ON COLUMN "public"."TestRecord"."response" IS '接口返回结果JSON';
COMMENT ON COLUMN "public"."TestRecord"."date" IS '创建日期';
COMMENT ON COLUMN "public"."TestRecord"."compare" IS '对比结果';
COMMENT ON COLUMN "public"."TestRecord"."standard" IS 'response 的校验标准，是一个 JSON 格式的 AST ，描述了正确 Response 的结构、里面的字段名称、类型、长度、取值范围 等属性。';
COMMENT ON COLUMN "public"."TestRecord"."randomId" IS '随机配置 id';

-- ----------------------------
-- Table structure for Verify
-- ----------------------------
DROP TABLE IF EXISTS "public"."Verify";
CREATE TABLE "public"."Verify" (
  "id" int8 NOT NULL,
  "type" int4 NOT NULL,
  "phone" varchar(11) COLLATE "pg_catalog"."default" NOT NULL,
  "verify" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "date" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
COMMENT ON COLUMN "public"."Verify"."id" IS '唯一标识';
COMMENT ON COLUMN "public"."Verify"."type" IS '类型：
0-登录
1-注册
2-修改登录密码
3-修改支付密码';
COMMENT ON COLUMN "public"."Verify"."phone" IS '手机号';
COMMENT ON COLUMN "public"."Verify"."verify" IS '验证码';
COMMENT ON COLUMN "public"."Verify"."date" IS '创建时间';

-- ----------------------------
-- Table structure for _Visit
-- ----------------------------
DROP TABLE IF EXISTS "public"."_Visit";
CREATE TABLE "public"."_Visit" (
  "model" varchar(15) COLLATE "pg_catalog"."default" NOT NULL,
  "id" int8 NOT NULL,
  "operate" int2 NOT NULL,
  "date" timestamp(6) NOT NULL
)
;
COMMENT ON COLUMN "public"."_Visit"."operate" IS '1-增
2-删
3-改
4-查';

-- ----------------------------
-- Table structure for act_evt_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_evt_log";
CREATE TABLE "public"."act_evt_log" (
  "log_nr_" int4 NOT NULL DEFAULT nextval('act_evt_log_log_nr__seq'::regclass),
  "type_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "time_stamp_" timestamp(6) NOT NULL,
  "user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "data_" bytea,
  "lock_owner_" varchar(255) COLLATE "pg_catalog"."default",
  "lock_time_" timestamp(6),
  "is_processed_" int2 DEFAULT 0
)
;

-- ----------------------------
-- Table structure for act_ge_bytearray
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ge_bytearray";
CREATE TABLE "public"."act_ge_bytearray" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "deployment_id_" varchar(64) COLLATE "pg_catalog"."default",
  "bytes_" bytea,
  "generated_" bool
)
;

-- ----------------------------
-- Table structure for act_ge_property
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ge_property";
CREATE TABLE "public"."act_ge_property" (
  "name_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "value_" varchar(300) COLLATE "pg_catalog"."default",
  "rev_" int4
)
;

-- ----------------------------
-- Table structure for act_hi_actinst
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_actinst";
CREATE TABLE "public"."act_hi_actinst" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4 DEFAULT 1,
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "act_id_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "call_proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "act_name_" varchar(255) COLLATE "pg_catalog"."default",
  "act_type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "assignee_" varchar(255) COLLATE "pg_catalog"."default",
  "start_time_" timestamp(6) NOT NULL,
  "end_time_" timestamp(6),
  "transaction_order_" int4,
  "duration_" int8,
  "delete_reason_" varchar(4000) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_hi_attachment
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_attachment";
CREATE TABLE "public"."act_hi_attachment" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "description_" varchar(4000) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "url_" varchar(4000) COLLATE "pg_catalog"."default",
  "content_id_" varchar(64) COLLATE "pg_catalog"."default",
  "time_" timestamp(6)
)
;

-- ----------------------------
-- Table structure for act_hi_comment
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_comment";
CREATE TABLE "public"."act_hi_comment" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "type_" varchar(255) COLLATE "pg_catalog"."default",
  "time_" timestamp(6) NOT NULL,
  "user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "action_" varchar(255) COLLATE "pg_catalog"."default",
  "message_" varchar(4000) COLLATE "pg_catalog"."default",
  "full_msg_" bytea
)
;

-- ----------------------------
-- Table structure for act_hi_detail
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_detail";
CREATE TABLE "public"."act_hi_detail" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "act_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "name_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "var_type_" varchar(64) COLLATE "pg_catalog"."default",
  "rev_" int4,
  "time_" timestamp(6) NOT NULL,
  "bytearray_id_" varchar(64) COLLATE "pg_catalog"."default",
  "double_" float8,
  "long_" int8,
  "text_" varchar(4000) COLLATE "pg_catalog"."default",
  "text2_" varchar(4000) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_hi_entitylink
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_entitylink";
CREATE TABLE "public"."act_hi_entitylink" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "link_type_" varchar(255) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "parent_element_id_" varchar(255) COLLATE "pg_catalog"."default",
  "ref_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "ref_scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "ref_scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "root_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "root_scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "hierarchy_type_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_hi_identitylink
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_identitylink";
CREATE TABLE "public"."act_hi_identitylink" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "group_id_" varchar(255) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default",
  "user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_hi_procinst
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_procinst";
CREATE TABLE "public"."act_hi_procinst" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4 DEFAULT 1,
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "business_key_" varchar(255) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "start_time_" timestamp(6) NOT NULL,
  "end_time_" timestamp(6),
  "duration_" int8,
  "start_user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "start_act_id_" varchar(255) COLLATE "pg_catalog"."default",
  "end_act_id_" varchar(255) COLLATE "pg_catalog"."default",
  "super_process_instance_id_" varchar(64) COLLATE "pg_catalog"."default",
  "delete_reason_" varchar(4000) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "callback_id_" varchar(255) COLLATE "pg_catalog"."default",
  "callback_type_" varchar(255) COLLATE "pg_catalog"."default",
  "reference_id_" varchar(255) COLLATE "pg_catalog"."default",
  "reference_type_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_hi_taskinst
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_taskinst";
CREATE TABLE "public"."act_hi_taskinst" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4 DEFAULT 1,
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "task_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "task_def_key_" varchar(255) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "propagated_stage_inst_id_" varchar(255) COLLATE "pg_catalog"."default",
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "parent_task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "description_" varchar(4000) COLLATE "pg_catalog"."default",
  "owner_" varchar(255) COLLATE "pg_catalog"."default",
  "assignee_" varchar(255) COLLATE "pg_catalog"."default",
  "start_time_" timestamp(6) NOT NULL,
  "claim_time_" timestamp(6),
  "end_time_" timestamp(6),
  "duration_" int8,
  "delete_reason_" varchar(4000) COLLATE "pg_catalog"."default",
  "priority_" int4,
  "due_date_" timestamp(6),
  "form_key_" varchar(255) COLLATE "pg_catalog"."default",
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "last_updated_time_" timestamp(6)
)
;

-- ----------------------------
-- Table structure for act_hi_tsk_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_tsk_log";
CREATE TABLE "public"."act_hi_tsk_log" (
  "id_" int4 NOT NULL DEFAULT nextval('act_hi_tsk_log_id__seq'::regclass),
  "type_" varchar(64) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "time_stamp_" timestamp(6) NOT NULL,
  "user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "data_" varchar(4000) COLLATE "pg_catalog"."default",
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_hi_varinst
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_hi_varinst";
CREATE TABLE "public"."act_hi_varinst" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4 DEFAULT 1,
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "name_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "var_type_" varchar(100) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "bytearray_id_" varchar(64) COLLATE "pg_catalog"."default",
  "double_" float8,
  "long_" int8,
  "text_" varchar(4000) COLLATE "pg_catalog"."default",
  "text2_" varchar(4000) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "last_updated_time_" timestamp(6)
)
;

-- ----------------------------
-- Table structure for act_id_bytearray
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_bytearray";
CREATE TABLE "public"."act_id_bytearray" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "bytes_" bytea
)
;

-- ----------------------------
-- Table structure for act_id_group
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_group";
CREATE TABLE "public"."act_id_group" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_id_info
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_info";
CREATE TABLE "public"."act_id_info" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "user_id_" varchar(64) COLLATE "pg_catalog"."default",
  "type_" varchar(64) COLLATE "pg_catalog"."default",
  "key_" varchar(255) COLLATE "pg_catalog"."default",
  "value_" varchar(255) COLLATE "pg_catalog"."default",
  "password_" bytea,
  "parent_id_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_id_membership
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_membership";
CREATE TABLE "public"."act_id_membership" (
  "user_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "group_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for act_id_priv
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_priv";
CREATE TABLE "public"."act_id_priv" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "name_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Table structure for act_id_priv_mapping
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_priv_mapping";
CREATE TABLE "public"."act_id_priv_mapping" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "priv_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "group_id_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_id_property
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_property";
CREATE TABLE "public"."act_id_property" (
  "name_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "value_" varchar(300) COLLATE "pg_catalog"."default",
  "rev_" int4
)
;

-- ----------------------------
-- Table structure for act_id_token
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_token";
CREATE TABLE "public"."act_id_token" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "token_value_" varchar(255) COLLATE "pg_catalog"."default",
  "token_date_" timestamp(6),
  "ip_address_" varchar(255) COLLATE "pg_catalog"."default",
  "user_agent_" varchar(255) COLLATE "pg_catalog"."default",
  "user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "token_data_" varchar(2000) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_id_user
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_id_user";
CREATE TABLE "public"."act_id_user" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "first_" varchar(255) COLLATE "pg_catalog"."default",
  "last_" varchar(255) COLLATE "pg_catalog"."default",
  "display_name_" varchar(255) COLLATE "pg_catalog"."default",
  "email_" varchar(255) COLLATE "pg_catalog"."default",
  "pwd_" varchar(255) COLLATE "pg_catalog"."default",
  "picture_id_" varchar(64) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_procdef_info
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_procdef_info";
CREATE TABLE "public"."act_procdef_info" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "info_json_id_" varchar(64) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_re_deployment
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_re_deployment";
CREATE TABLE "public"."act_re_deployment" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "key_" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "deploy_time_" timestamp(6),
  "derived_from_" varchar(64) COLLATE "pg_catalog"."default",
  "derived_from_root_" varchar(64) COLLATE "pg_catalog"."default",
  "parent_deployment_id_" varchar(255) COLLATE "pg_catalog"."default",
  "engine_version_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_re_model
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_re_model";
CREATE TABLE "public"."act_re_model" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "key_" varchar(255) COLLATE "pg_catalog"."default",
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "last_update_time_" timestamp(6),
  "version_" int4,
  "meta_info_" varchar(4000) COLLATE "pg_catalog"."default",
  "deployment_id_" varchar(64) COLLATE "pg_catalog"."default",
  "editor_source_value_id_" varchar(64) COLLATE "pg_catalog"."default",
  "editor_source_extra_value_id_" varchar(64) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_re_procdef
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_re_procdef";
CREATE TABLE "public"."act_re_procdef" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "key_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "version_" int4 NOT NULL,
  "deployment_id_" varchar(64) COLLATE "pg_catalog"."default",
  "resource_name_" varchar(4000) COLLATE "pg_catalog"."default",
  "dgrm_resource_name_" varchar(4000) COLLATE "pg_catalog"."default",
  "description_" varchar(4000) COLLATE "pg_catalog"."default",
  "has_start_form_key_" bool,
  "has_graphical_notation_" bool,
  "suspension_state_" int4,
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "derived_from_" varchar(64) COLLATE "pg_catalog"."default",
  "derived_from_root_" varchar(64) COLLATE "pg_catalog"."default",
  "derived_version_" int4 NOT NULL DEFAULT 0,
  "engine_version_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_ru_actinst
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_actinst";
CREATE TABLE "public"."act_ru_actinst" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4 DEFAULT 1,
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "act_id_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "call_proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "act_name_" varchar(255) COLLATE "pg_catalog"."default",
  "act_type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "assignee_" varchar(255) COLLATE "pg_catalog"."default",
  "start_time_" timestamp(6) NOT NULL,
  "end_time_" timestamp(6),
  "duration_" int8,
  "transaction_order_" int4,
  "delete_reason_" varchar(4000) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_ru_deadletter_job
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_deadletter_job";
CREATE TABLE "public"."act_ru_deadletter_job" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "exclusive_" bool,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "process_instance_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "element_id_" varchar(255) COLLATE "pg_catalog"."default",
  "element_name_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "correlation_id_" varchar(255) COLLATE "pg_catalog"."default",
  "exception_stack_id_" varchar(64) COLLATE "pg_catalog"."default",
  "exception_msg_" varchar(4000) COLLATE "pg_catalog"."default",
  "duedate_" timestamp(6),
  "repeat_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_type_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_cfg_" varchar(4000) COLLATE "pg_catalog"."default",
  "custom_values_id_" varchar(64) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_ru_entitylink
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_entitylink";
CREATE TABLE "public"."act_ru_entitylink" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "create_time_" timestamp(6),
  "link_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "parent_element_id_" varchar(255) COLLATE "pg_catalog"."default",
  "ref_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "ref_scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "ref_scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "root_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "root_scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "hierarchy_type_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_ru_event_subscr
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_event_subscr";
CREATE TABLE "public"."act_ru_event_subscr" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "event_type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "event_name_" varchar(255) COLLATE "pg_catalog"."default",
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "activity_id_" varchar(64) COLLATE "pg_catalog"."default",
  "configuration_" varchar(255) COLLATE "pg_catalog"."default",
  "created_" timestamp(6) NOT NULL,
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(64) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_ru_execution
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_execution";
CREATE TABLE "public"."act_ru_execution" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "business_key_" varchar(255) COLLATE "pg_catalog"."default",
  "parent_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "super_exec_" varchar(64) COLLATE "pg_catalog"."default",
  "root_proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "act_id_" varchar(255) COLLATE "pg_catalog"."default",
  "is_active_" bool,
  "is_concurrent_" bool,
  "is_scope_" bool,
  "is_event_scope_" bool,
  "is_mi_root_" bool,
  "suspension_state_" int4,
  "cached_ent_state_" int4,
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "start_act_id_" varchar(255) COLLATE "pg_catalog"."default",
  "start_time_" timestamp(6),
  "start_user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "lock_time_" timestamp(6),
  "lock_owner_" varchar(255) COLLATE "pg_catalog"."default",
  "is_count_enabled_" bool,
  "evt_subscr_count_" int4,
  "task_count_" int4,
  "job_count_" int4,
  "timer_job_count_" int4,
  "susp_job_count_" int4,
  "deadletter_job_count_" int4,
  "external_worker_job_count_" int4,
  "var_count_" int4,
  "id_link_count_" int4,
  "callback_id_" varchar(255) COLLATE "pg_catalog"."default",
  "callback_type_" varchar(255) COLLATE "pg_catalog"."default",
  "reference_id_" varchar(255) COLLATE "pg_catalog"."default",
  "reference_type_" varchar(255) COLLATE "pg_catalog"."default",
  "propagated_stage_inst_id_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_ru_external_job
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_external_job";
CREATE TABLE "public"."act_ru_external_job" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "lock_exp_time_" timestamp(6),
  "lock_owner_" varchar(255) COLLATE "pg_catalog"."default",
  "exclusive_" bool,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "process_instance_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "element_id_" varchar(255) COLLATE "pg_catalog"."default",
  "element_name_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "correlation_id_" varchar(255) COLLATE "pg_catalog"."default",
  "retries_" int4,
  "exception_stack_id_" varchar(64) COLLATE "pg_catalog"."default",
  "exception_msg_" varchar(4000) COLLATE "pg_catalog"."default",
  "duedate_" timestamp(6),
  "repeat_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_type_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_cfg_" varchar(4000) COLLATE "pg_catalog"."default",
  "custom_values_id_" varchar(64) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_ru_history_job
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_history_job";
CREATE TABLE "public"."act_ru_history_job" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "lock_exp_time_" timestamp(6),
  "lock_owner_" varchar(255) COLLATE "pg_catalog"."default",
  "retries_" int4,
  "exception_stack_id_" varchar(64) COLLATE "pg_catalog"."default",
  "exception_msg_" varchar(4000) COLLATE "pg_catalog"."default",
  "handler_type_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_cfg_" varchar(4000) COLLATE "pg_catalog"."default",
  "custom_values_id_" varchar(64) COLLATE "pg_catalog"."default",
  "adv_handler_cfg_id_" varchar(64) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_ru_identitylink
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_identitylink";
CREATE TABLE "public"."act_ru_identitylink" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "group_id_" varchar(255) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default",
  "user_id_" varchar(255) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for act_ru_job
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_job";
CREATE TABLE "public"."act_ru_job" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "lock_exp_time_" timestamp(6),
  "lock_owner_" varchar(255) COLLATE "pg_catalog"."default",
  "exclusive_" bool,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "process_instance_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "element_id_" varchar(255) COLLATE "pg_catalog"."default",
  "element_name_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "correlation_id_" varchar(255) COLLATE "pg_catalog"."default",
  "retries_" int4,
  "exception_stack_id_" varchar(64) COLLATE "pg_catalog"."default",
  "exception_msg_" varchar(4000) COLLATE "pg_catalog"."default",
  "duedate_" timestamp(6),
  "repeat_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_type_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_cfg_" varchar(4000) COLLATE "pg_catalog"."default",
  "custom_values_id_" varchar(64) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_ru_suspended_job
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_suspended_job";
CREATE TABLE "public"."act_ru_suspended_job" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "exclusive_" bool,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "process_instance_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "element_id_" varchar(255) COLLATE "pg_catalog"."default",
  "element_name_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "correlation_id_" varchar(255) COLLATE "pg_catalog"."default",
  "retries_" int4,
  "exception_stack_id_" varchar(64) COLLATE "pg_catalog"."default",
  "exception_msg_" varchar(4000) COLLATE "pg_catalog"."default",
  "duedate_" timestamp(6),
  "repeat_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_type_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_cfg_" varchar(4000) COLLATE "pg_catalog"."default",
  "custom_values_id_" varchar(64) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_ru_task
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_task";
CREATE TABLE "public"."act_ru_task" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "task_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "propagated_stage_inst_id_" varchar(255) COLLATE "pg_catalog"."default",
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "parent_task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "description_" varchar(4000) COLLATE "pg_catalog"."default",
  "task_def_key_" varchar(255) COLLATE "pg_catalog"."default",
  "owner_" varchar(255) COLLATE "pg_catalog"."default",
  "assignee_" varchar(255) COLLATE "pg_catalog"."default",
  "delegation_" varchar(64) COLLATE "pg_catalog"."default",
  "priority_" int4,
  "create_time_" timestamp(6),
  "due_date_" timestamp(6),
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "suspension_state_" int4,
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "form_key_" varchar(255) COLLATE "pg_catalog"."default",
  "claim_time_" timestamp(6),
  "is_count_enabled_" bool,
  "var_count_" int4,
  "id_link_count_" int4,
  "sub_task_count_" int4
)
;

-- ----------------------------
-- Table structure for act_ru_timer_job
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_timer_job";
CREATE TABLE "public"."act_ru_timer_job" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "lock_exp_time_" timestamp(6),
  "lock_owner_" varchar(255) COLLATE "pg_catalog"."default",
  "exclusive_" bool,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "process_instance_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_def_id_" varchar(64) COLLATE "pg_catalog"."default",
  "element_id_" varchar(255) COLLATE "pg_catalog"."default",
  "element_name_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_definition_id_" varchar(255) COLLATE "pg_catalog"."default",
  "correlation_id_" varchar(255) COLLATE "pg_catalog"."default",
  "retries_" int4,
  "exception_stack_id_" varchar(64) COLLATE "pg_catalog"."default",
  "exception_msg_" varchar(4000) COLLATE "pg_catalog"."default",
  "duedate_" timestamp(6),
  "repeat_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_type_" varchar(255) COLLATE "pg_catalog"."default",
  "handler_cfg_" varchar(4000) COLLATE "pg_catalog"."default",
  "custom_values_id_" varchar(64) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6),
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for act_ru_variable
-- ----------------------------
DROP TABLE IF EXISTS "public"."act_ru_variable";
CREATE TABLE "public"."act_ru_variable" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "type_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "execution_id_" varchar(64) COLLATE "pg_catalog"."default",
  "proc_inst_id_" varchar(64) COLLATE "pg_catalog"."default",
  "task_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(255) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(255) COLLATE "pg_catalog"."default",
  "bytearray_id_" varchar(64) COLLATE "pg_catalog"."default",
  "double_" float8,
  "long_" int8,
  "text_" varchar(4000) COLLATE "pg_catalog"."default",
  "text2_" varchar(4000) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for apijson_privacy
-- ----------------------------
DROP TABLE IF EXISTS "public"."apijson_privacy";
CREATE TABLE "public"."apijson_privacy" (
  "id" int8 NOT NULL,
  "certified" int2 NOT NULL,
  "phone" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "balance" numeric(10,2) NOT NULL,
  "_password" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "_payPassword" varchar(32) COLLATE "pg_catalog"."default" NOT NULL
)
;
COMMENT ON COLUMN "public"."apijson_privacy"."id" IS '唯一标识';
COMMENT ON COLUMN "public"."apijson_privacy"."certified" IS '已认证';
COMMENT ON COLUMN "public"."apijson_privacy"."phone" IS '手机号，仅支持 11 位数的。不支持 +86 这种国家地区开头的。如果要支持就改为 VARCHAR(14)';
COMMENT ON COLUMN "public"."apijson_privacy"."balance" IS '余额';
COMMENT ON COLUMN "public"."apijson_privacy"."_password" IS '登录密码';
COMMENT ON COLUMN "public"."apijson_privacy"."_payPassword" IS '支付密码';

-- ----------------------------
-- Table structure for apijson_user
-- ----------------------------
DROP TABLE IF EXISTS "public"."apijson_user";
CREATE TABLE "public"."apijson_user" (
  "id" int8 NOT NULL,
  "sex" int2 NOT NULL,
  "name" varchar(20) COLLATE "pg_catalog"."default",
  "tag" varchar(45) COLLATE "pg_catalog"."default",
  "head" varchar(300) COLLATE "pg_catalog"."default",
  "contactIdList" jsonb,
  "pictureList" jsonb,
  "date" timestamp(6)
)
;
COMMENT ON COLUMN "public"."apijson_user"."id" IS '唯一标识';
COMMENT ON COLUMN "public"."apijson_user"."sex" IS '性别：
0-男
1-女';
COMMENT ON COLUMN "public"."apijson_user"."name" IS '名称';
COMMENT ON COLUMN "public"."apijson_user"."tag" IS '标签';
COMMENT ON COLUMN "public"."apijson_user"."head" IS '头像url';
COMMENT ON COLUMN "public"."apijson_user"."contactIdList" IS '联系人id列表';
COMMENT ON COLUMN "public"."apijson_user"."pictureList" IS '照片列表';
COMMENT ON COLUMN "public"."apijson_user"."date" IS '创建日期';

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS "public"."department";
CREATE TABLE "public"."department" (
  "id" int8 NOT NULL,
  "create_by" varchar(100) COLLATE "pg_catalog"."default",
  "update_by" varchar(100) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "dept_name" varchar(20) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "company_code" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."department"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."department"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."department"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."department"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."department"."dept_name" IS '部门名称';
COMMENT ON COLUMN "public"."department"."del_flag" IS '逻辑删除，0正常/1删除';
COMMENT ON COLUMN "public"."department"."remark" IS '备注';
COMMENT ON COLUMN "public"."department"."company_code" IS '公司编码';
COMMENT ON TABLE "public"."department" IS '组织表(部门表)';

-- ----------------------------
-- Table structure for flw_channel_definition
-- ----------------------------
DROP TABLE IF EXISTS "public"."flw_channel_definition";
CREATE TABLE "public"."flw_channel_definition" (
  "id_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "version_" int4,
  "key_" varchar(255) COLLATE "pg_catalog"."default",
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "deployment_id_" varchar(255) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(3),
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default",
  "resource_name_" varchar(255) COLLATE "pg_catalog"."default",
  "description_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for flw_ev_databasechangelog
-- ----------------------------
DROP TABLE IF EXISTS "public"."flw_ev_databasechangelog";
CREATE TABLE "public"."flw_ev_databasechangelog" (
  "id" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "author" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "filename" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "dateexecuted" timestamp(6) NOT NULL,
  "orderexecuted" int4 NOT NULL,
  "exectype" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "md5sum" varchar(35) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "comments" varchar(255) COLLATE "pg_catalog"."default",
  "tag" varchar(255) COLLATE "pg_catalog"."default",
  "liquibase" varchar(20) COLLATE "pg_catalog"."default",
  "contexts" varchar(255) COLLATE "pg_catalog"."default",
  "labels" varchar(255) COLLATE "pg_catalog"."default",
  "deployment_id" varchar(10) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for flw_ev_databasechangeloglock
-- ----------------------------
DROP TABLE IF EXISTS "public"."flw_ev_databasechangeloglock";
CREATE TABLE "public"."flw_ev_databasechangeloglock" (
  "id" int4 NOT NULL,
  "locked" bool NOT NULL,
  "lockgranted" timestamp(6),
  "lockedby" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for flw_event_definition
-- ----------------------------
DROP TABLE IF EXISTS "public"."flw_event_definition";
CREATE TABLE "public"."flw_event_definition" (
  "id_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "version_" int4,
  "key_" varchar(255) COLLATE "pg_catalog"."default",
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "deployment_id_" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default",
  "resource_name_" varchar(255) COLLATE "pg_catalog"."default",
  "description_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for flw_event_deployment
-- ----------------------------
DROP TABLE IF EXISTS "public"."flw_event_deployment";
CREATE TABLE "public"."flw_event_deployment" (
  "id_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "category_" varchar(255) COLLATE "pg_catalog"."default",
  "deploy_time_" timestamp(3),
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default",
  "parent_deployment_id_" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for flw_event_resource
-- ----------------------------
DROP TABLE IF EXISTS "public"."flw_event_resource";
CREATE TABLE "public"."flw_event_resource" (
  "id_" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "name_" varchar(255) COLLATE "pg_catalog"."default",
  "deployment_id_" varchar(255) COLLATE "pg_catalog"."default",
  "resource_bytes_" bytea
)
;

-- ----------------------------
-- Table structure for flw_ru_batch
-- ----------------------------
DROP TABLE IF EXISTS "public"."flw_ru_batch";
CREATE TABLE "public"."flw_ru_batch" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "type_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "search_key_" varchar(255) COLLATE "pg_catalog"."default",
  "search_key2_" varchar(255) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6) NOT NULL,
  "complete_time_" timestamp(6),
  "status_" varchar(255) COLLATE "pg_catalog"."default",
  "batch_doc_id_" varchar(64) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for flw_ru_batch_part
-- ----------------------------
DROP TABLE IF EXISTS "public"."flw_ru_batch_part";
CREATE TABLE "public"."flw_ru_batch_part" (
  "id_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "rev_" int4,
  "batch_id_" varchar(64) COLLATE "pg_catalog"."default",
  "type_" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "scope_id_" varchar(64) COLLATE "pg_catalog"."default",
  "sub_scope_id_" varchar(64) COLLATE "pg_catalog"."default",
  "scope_type_" varchar(64) COLLATE "pg_catalog"."default",
  "search_key_" varchar(255) COLLATE "pg_catalog"."default",
  "search_key2_" varchar(255) COLLATE "pg_catalog"."default",
  "create_time_" timestamp(6) NOT NULL,
  "complete_time_" timestamp(6),
  "status_" varchar(255) COLLATE "pg_catalog"."default",
  "result_doc_id_" varchar(64) COLLATE "pg_catalog"."default",
  "tenant_id_" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying
)
;

-- ----------------------------
-- Table structure for member_notice
-- ----------------------------
DROP TABLE IF EXISTS "public"."member_notice";
CREATE TABLE "public"."member_notice" (
  "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "user_id" varchar(64) COLLATE "pg_catalog"."default",
  "title" varchar(255) COLLATE "pg_catalog"."default",
  "content" varchar(255) COLLATE "pg_catalog"."default",
  "is_read" char(1) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "receive_time" timestamp(6),
  "del_flag" char(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."member_notice"."id" IS 'id';
COMMENT ON COLUMN "public"."member_notice"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."member_notice"."user_id" IS '接收者';
COMMENT ON COLUMN "public"."member_notice"."title" IS '标题';
COMMENT ON COLUMN "public"."member_notice"."content" IS '内容';
COMMENT ON COLUMN "public"."member_notice"."is_read" IS '是否阅读 0是1否';
COMMENT ON COLUMN "public"."member_notice"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."member_notice"."receive_time" IS '阅读时间';
COMMENT ON COLUMN "public"."member_notice"."del_flag" IS '删除标识0正常1删除';

-- ----------------------------
-- Table structure for rep_demo_dxtj
-- ----------------------------
DROP TABLE IF EXISTS "public"."rep_demo_dxtj";
CREATE TABLE "public"."rep_demo_dxtj" (
  "id" varchar(36) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(50) COLLATE "pg_catalog"."default",
  "gtime" timestamp(6),
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "jphone" varchar(125) COLLATE "pg_catalog"."default",
  "birth" timestamp(6),
  "hukou" varchar(32) COLLATE "pg_catalog"."default",
  "laddress" varchar(125) COLLATE "pg_catalog"."default",
  "jperson" varchar(32) COLLATE "pg_catalog"."default",
  "sex" varchar(32) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."rep_demo_dxtj"."id" IS '主键';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."name" IS '姓名';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."gtime" IS '雇佣日期';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."update_by" IS '职务';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."jphone" IS '家庭电话';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."birth" IS '出生日期';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."hukou" IS '户口所在地';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."laddress" IS '联系地址';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."jperson" IS '紧急联系人';
COMMENT ON COLUMN "public"."rep_demo_dxtj"."sex" IS 'xingbie';

-- ----------------------------
-- Table structure for rep_demo_employee
-- ----------------------------
DROP TABLE IF EXISTS "public"."rep_demo_employee";
CREATE TABLE "public"."rep_demo_employee" (
  "id" varchar(10) COLLATE "pg_catalog"."default" NOT NULL,
  "num" varchar(50) COLLATE "pg_catalog"."default",
  "name" varchar(100) COLLATE "pg_catalog"."default",
  "sex" varchar(10) COLLATE "pg_catalog"."default",
  "birthday" timestamp(6),
  "nation" varchar(30) COLLATE "pg_catalog"."default",
  "political" varchar(30) COLLATE "pg_catalog"."default",
  "native_place" varchar(30) COLLATE "pg_catalog"."default",
  "height" varchar(30) COLLATE "pg_catalog"."default",
  "weight" varchar(30) COLLATE "pg_catalog"."default",
  "health" varchar(30) COLLATE "pg_catalog"."default",
  "id_card" varchar(80) COLLATE "pg_catalog"."default",
  "education" varchar(30) COLLATE "pg_catalog"."default",
  "school" varchar(80) COLLATE "pg_catalog"."default",
  "major" varchar(80) COLLATE "pg_catalog"."default",
  "address" varchar(100) COLLATE "pg_catalog"."default",
  "zip_code" varchar(30) COLLATE "pg_catalog"."default",
  "email" varchar(30) COLLATE "pg_catalog"."default",
  "phone" varchar(30) COLLATE "pg_catalog"."default",
  "foreign_language" varchar(30) COLLATE "pg_catalog"."default",
  "foreign_language_level" varchar(30) COLLATE "pg_catalog"."default",
  "computer_level" varchar(30) COLLATE "pg_catalog"."default",
  "graduation_time" timestamp(6),
  "arrival_time" timestamp(6),
  "positional_titles" varchar(30) COLLATE "pg_catalog"."default",
  "education_experience" text COLLATE "pg_catalog"."default",
  "work_experience" text COLLATE "pg_catalog"."default",
  "create_by" varchar(32) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(32) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "del_flag" int2
)
;
COMMENT ON COLUMN "public"."rep_demo_employee"."id" IS '主键';
COMMENT ON COLUMN "public"."rep_demo_employee"."num" IS '编号';
COMMENT ON COLUMN "public"."rep_demo_employee"."name" IS '姓名';
COMMENT ON COLUMN "public"."rep_demo_employee"."sex" IS '性别';
COMMENT ON COLUMN "public"."rep_demo_employee"."birthday" IS '出生日期';
COMMENT ON COLUMN "public"."rep_demo_employee"."nation" IS '民族';
COMMENT ON COLUMN "public"."rep_demo_employee"."political" IS '政治面貌';
COMMENT ON COLUMN "public"."rep_demo_employee"."native_place" IS '籍贯';
COMMENT ON COLUMN "public"."rep_demo_employee"."height" IS '身高';
COMMENT ON COLUMN "public"."rep_demo_employee"."weight" IS '体重';
COMMENT ON COLUMN "public"."rep_demo_employee"."health" IS '健康状况';
COMMENT ON COLUMN "public"."rep_demo_employee"."id_card" IS '身份证号';
COMMENT ON COLUMN "public"."rep_demo_employee"."education" IS '学历';
COMMENT ON COLUMN "public"."rep_demo_employee"."school" IS '毕业学校';
COMMENT ON COLUMN "public"."rep_demo_employee"."major" IS '专业';
COMMENT ON COLUMN "public"."rep_demo_employee"."address" IS '联系地址';
COMMENT ON COLUMN "public"."rep_demo_employee"."zip_code" IS '邮编';
COMMENT ON COLUMN "public"."rep_demo_employee"."email" IS 'Email';
COMMENT ON COLUMN "public"."rep_demo_employee"."phone" IS '手机号';
COMMENT ON COLUMN "public"."rep_demo_employee"."foreign_language" IS '外语语种';
COMMENT ON COLUMN "public"."rep_demo_employee"."foreign_language_level" IS '外语水平';
COMMENT ON COLUMN "public"."rep_demo_employee"."computer_level" IS '计算机水平';
COMMENT ON COLUMN "public"."rep_demo_employee"."graduation_time" IS '毕业时间';
COMMENT ON COLUMN "public"."rep_demo_employee"."arrival_time" IS '到职时间';
COMMENT ON COLUMN "public"."rep_demo_employee"."positional_titles" IS '职称';
COMMENT ON COLUMN "public"."rep_demo_employee"."education_experience" IS '教育经历';
COMMENT ON COLUMN "public"."rep_demo_employee"."work_experience" IS '工作经历';
COMMENT ON COLUMN "public"."rep_demo_employee"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."rep_demo_employee"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."rep_demo_employee"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."rep_demo_employee"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."rep_demo_employee"."del_flag" IS '删除标识0-正常,1-已删除';

-- ----------------------------
-- Table structure for rep_demo_gongsi
-- ----------------------------
DROP TABLE IF EXISTS "public"."rep_demo_gongsi";
CREATE TABLE "public"."rep_demo_gongsi" (
  "id" int4 NOT NULL,
  "gname" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "gdata" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "tdata" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "didian" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "zhaiyao" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "num" varchar(255) COLLATE "pg_catalog"."default" NOT NULL
)
;
COMMENT ON COLUMN "public"."rep_demo_gongsi"."gname" IS '货品名称';
COMMENT ON COLUMN "public"."rep_demo_gongsi"."gdata" IS '返利';
COMMENT ON COLUMN "public"."rep_demo_gongsi"."tdata" IS '备注';

-- ----------------------------
-- Table structure for rep_demo_jianpiao
-- ----------------------------
DROP TABLE IF EXISTS "public"."rep_demo_jianpiao";
CREATE TABLE "public"."rep_demo_jianpiao" (
  "id" int4 NOT NULL,
  "bnum" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "ftime" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "sfkong" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "kaishi" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "jieshu" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "hezairen" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "jpnum" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "shihelv" varchar(125) COLLATE "pg_catalog"."default" NOT NULL,
  "s_id" int4 NOT NULL
)
;

-- ----------------------------
-- Table structure for rule
-- ----------------------------
DROP TABLE IF EXISTS "public"."rule";
CREATE TABLE "public"."rule" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "name" varchar(50) COLLATE "pg_catalog"."default",
  "description" varchar(50) COLLATE "pg_catalog"."default",
  "priority" int4,
  "composite_type" int4,
  "state" int4,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(32) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."rule"."id" IS 'id';
COMMENT ON COLUMN "public"."rule"."name" IS '规则名称';
COMMENT ON COLUMN "public"."rule"."description" IS '规则描述';
COMMENT ON COLUMN "public"."rule"."priority" IS '权重  数字越小  越高';
COMMENT ON COLUMN "public"."rule"."composite_type" IS '组合类型 1-and 2-or 3-all';
COMMENT ON COLUMN "public"."rule"."state" IS '数据状态 0-启用 1-不启用';
COMMENT ON COLUMN "public"."rule"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."rule"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."rule"."create_by" IS '创建者';

-- ----------------------------
-- Table structure for rule_compose
-- ----------------------------
DROP TABLE IF EXISTS "public"."rule_compose";
CREATE TABLE "public"."rule_compose" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "rule_id" varchar(32) COLLATE "pg_catalog"."default",
  "name" varchar(50) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "condition" varchar(255) COLLATE "pg_catalog"."default",
  "actions" varchar(255) COLLATE "pg_catalog"."default",
  "priority" int4,
  "state" int4,
  "create_by" varchar(32) COLLATE "pg_catalog"."default",
  "create_time" date,
  "update_time" date
)
;
COMMENT ON COLUMN "public"."rule_compose"."id" IS 'id';
COMMENT ON COLUMN "public"."rule_compose"."rule_id" IS '规则ID';
COMMENT ON COLUMN "public"."rule_compose"."name" IS '规则名称';
COMMENT ON COLUMN "public"."rule_compose"."description" IS '规则描述';
COMMENT ON COLUMN "public"."rule_compose"."condition" IS '规则条件';
COMMENT ON COLUMN "public"."rule_compose"."actions" IS '执行动作';
COMMENT ON COLUMN "public"."rule_compose"."priority" IS '规则权重';
COMMENT ON COLUMN "public"."rule_compose"."state" IS '数据状态 0-启用 1-不启用';
COMMENT ON COLUMN "public"."rule_compose"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."rule_compose"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."rule_compose"."update_time" IS '更新时间';

-- ----------------------------
-- Table structure for sms_reach
-- ----------------------------
DROP TABLE IF EXISTS "public"."sms_reach";
CREATE TABLE "public"."sms_reach" (
  "id" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "context" varchar(255) COLLATE "pg_catalog"."default",
  "message_code" varchar(255) COLLATE "pg_catalog"."default",
  "create_user_id" varchar(32) COLLATE "pg_catalog"."default",
  "sign_name" varchar(255) COLLATE "pg_catalog"."default",
  "sms_name" varchar(255) COLLATE "pg_catalog"."default",
  "sms_range" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "mobile" varchar(1024) COLLATE "pg_catalog"."default",
  "del_flag" char(1) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."sms_reach"."id" IS 'id';
COMMENT ON COLUMN "public"."sms_reach"."context" IS '消息内容';
COMMENT ON COLUMN "public"."sms_reach"."message_code" IS '消息CODE';
COMMENT ON COLUMN "public"."sms_reach"."create_user_id" IS '预计发送条数';
COMMENT ON COLUMN "public"."sms_reach"."sign_name" IS '签名名称';
COMMENT ON COLUMN "public"."sms_reach"."sms_name" IS '模板名称';
COMMENT ON COLUMN "public"."sms_reach"."sms_range" IS '接收人';
COMMENT ON COLUMN "public"."sms_reach"."create_time" IS '创建时间';

-- ----------------------------
-- Table structure for sys_area
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_area";
CREATE TABLE "public"."sys_area" (
  "area_id" int8 NOT NULL,
  "parent_id" int8,
  "ancestors" varchar(50) COLLATE "pg_catalog"."default",
  "area_name" varchar(30) COLLATE "pg_catalog"."default",
  "area_code" varchar(50) COLLATE "pg_catalog"."default",
  "center" varchar(50) COLLATE "pg_catalog"."default",
  "order_num" int4,
  "del_flag" char(1) COLLATE "pg_catalog"."default",
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_area"."area_id" IS '地区id';
COMMENT ON COLUMN "public"."sys_area"."parent_id" IS '父部门id';
COMMENT ON COLUMN "public"."sys_area"."ancestors" IS '祖级列表';
COMMENT ON COLUMN "public"."sys_area"."area_name" IS '地区名称';
COMMENT ON COLUMN "public"."sys_area"."area_code" IS '地区编码';
COMMENT ON COLUMN "public"."sys_area"."center" IS '经度,纬度';
COMMENT ON COLUMN "public"."sys_area"."order_num" IS '显示顺序';
COMMENT ON COLUMN "public"."sys_area"."del_flag" IS '删除标志（0代表存在 2代表删除）';
COMMENT ON COLUMN "public"."sys_area"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_area"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_area"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_area"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_area"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_area" IS '地区表';

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_config";
CREATE TABLE "public"."sys_config" (
  "config_id" int8 NOT NULL,
  "config_name" varchar(100) COLLATE "pg_catalog"."default",
  "config_key" varchar(100) COLLATE "pg_catalog"."default",
  "config_value" varchar(500) COLLATE "pg_catalog"."default",
  "config_type" char(1) COLLATE "pg_catalog"."default",
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "remark" varchar(500) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_config"."config_id" IS '参数主键';
COMMENT ON COLUMN "public"."sys_config"."config_name" IS '参数名称';
COMMENT ON COLUMN "public"."sys_config"."config_key" IS '参数键名';
COMMENT ON COLUMN "public"."sys_config"."config_value" IS '参数键值';
COMMENT ON COLUMN "public"."sys_config"."config_type" IS '系统内置（Y是 N否）';
COMMENT ON COLUMN "public"."sys_config"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_config"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_config"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_config"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_config"."remark" IS '备注';
COMMENT ON COLUMN "public"."sys_config"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_config" IS '参数配置表';

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_dept";
CREATE TABLE "public"."sys_dept" (
  "dept_id" int8 NOT NULL,
  "parent_id" int8 DEFAULT 0,
  "ancestors" varchar(50) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "dept_name" varchar(30) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "order_num" int4 DEFAULT 0,
  "leader" varchar(20) COLLATE "pg_catalog"."default",
  "phone" varchar(11) COLLATE "pg_catalog"."default",
  "email" varchar(50) COLLATE "pg_catalog"."default",
  "status" char(1) COLLATE "pg_catalog"."default" DEFAULT '0'::bpchar,
  "del_flag" char(1) COLLATE "pg_catalog"."default" DEFAULT '0'::bpchar,
  "create_by" varchar(64) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "update_time" timestamp(6),
  "dept_code" varchar(20) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_dept"."dept_id" IS '部门id';
COMMENT ON COLUMN "public"."sys_dept"."parent_id" IS '父部门id';
COMMENT ON COLUMN "public"."sys_dept"."ancestors" IS '祖级列表';
COMMENT ON COLUMN "public"."sys_dept"."dept_name" IS '部门名称';
COMMENT ON COLUMN "public"."sys_dept"."order_num" IS '显示顺序';
COMMENT ON COLUMN "public"."sys_dept"."leader" IS '负责人';
COMMENT ON COLUMN "public"."sys_dept"."phone" IS '联系电话';
COMMENT ON COLUMN "public"."sys_dept"."email" IS '邮箱';
COMMENT ON COLUMN "public"."sys_dept"."status" IS '部门状态（0正常 1停用）';
COMMENT ON COLUMN "public"."sys_dept"."del_flag" IS '删除标志（0代表存在 2代表删除）';
COMMENT ON COLUMN "public"."sys_dept"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_dept"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_dept"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_dept"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_dept"."dept_code" IS '部门编码';
COMMENT ON COLUMN "public"."sys_dept"."tenant_id" IS '租户id';
COMMENT ON TABLE "public"."sys_dept" IS '部门表';

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_dict";
CREATE TABLE "public"."sys_dict" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "dict_name" varchar(100) COLLATE "pg_catalog"."default",
  "dict_code" varchar(100) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "del_flag" int4,
  "create_by" varchar(32) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(32) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "type" int4
)
;
COMMENT ON COLUMN "public"."sys_dict"."dict_name" IS '字典名称';
COMMENT ON COLUMN "public"."sys_dict"."dict_code" IS '字典编码';
COMMENT ON COLUMN "public"."sys_dict"."description" IS '描述';
COMMENT ON COLUMN "public"."sys_dict"."del_flag" IS '删除状态';
COMMENT ON COLUMN "public"."sys_dict"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."sys_dict"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_dict"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."sys_dict"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_dict"."type" IS '字典类型0为string,1为number';

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_dict_data";
CREATE TABLE "public"."sys_dict_data" (
  "dict_code" int8 NOT NULL,
  "dict_sort" int4,
  "dict_label" varchar(100) COLLATE "pg_catalog"."default",
  "dict_value" varchar(100) COLLATE "pg_catalog"."default",
  "dict_type" varchar(100) COLLATE "pg_catalog"."default",
  "css_class" varchar(100) COLLATE "pg_catalog"."default",
  "list_class" varchar(100) COLLATE "pg_catalog"."default",
  "is_default" char(1) COLLATE "pg_catalog"."default",
  "status" char(1) COLLATE "pg_catalog"."default",
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "remark" varchar(500) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_dict_data"."dict_code" IS '字典编码';
COMMENT ON COLUMN "public"."sys_dict_data"."dict_sort" IS '字典排序';
COMMENT ON COLUMN "public"."sys_dict_data"."dict_label" IS '字典标签';
COMMENT ON COLUMN "public"."sys_dict_data"."dict_value" IS '字典键值';
COMMENT ON COLUMN "public"."sys_dict_data"."dict_type" IS '字典类型';
COMMENT ON COLUMN "public"."sys_dict_data"."css_class" IS '样式属性（其他样式扩展）';
COMMENT ON COLUMN "public"."sys_dict_data"."list_class" IS '表格回显样式';
COMMENT ON COLUMN "public"."sys_dict_data"."is_default" IS '是否默认（Y是 N否）';
COMMENT ON COLUMN "public"."sys_dict_data"."status" IS '状态（0正常 1停用）';
COMMENT ON COLUMN "public"."sys_dict_data"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_dict_data"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_dict_data"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_dict_data"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_dict_data"."remark" IS '备注';
COMMENT ON COLUMN "public"."sys_dict_data"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_dict_data" IS '字典数据表';

-- ----------------------------
-- Table structure for sys_dict_item
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_dict_item";
CREATE TABLE "public"."sys_dict_item" (
  "id" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "dict_id" varchar(32) COLLATE "pg_catalog"."default",
  "item_text" varchar(100) COLLATE "pg_catalog"."default",
  "item_value" varchar(100) COLLATE "pg_catalog"."default",
  "description" varchar(255) COLLATE "pg_catalog"."default",
  "sort_order" int4,
  "status" int4,
  "create_by" varchar(32) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(32) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."sys_dict_item"."dict_id" IS '字典id';
COMMENT ON COLUMN "public"."sys_dict_item"."item_text" IS '字典项文本';
COMMENT ON COLUMN "public"."sys_dict_item"."item_value" IS '字典项值';
COMMENT ON COLUMN "public"."sys_dict_item"."description" IS '描述';
COMMENT ON COLUMN "public"."sys_dict_item"."sort_order" IS '排序';
COMMENT ON COLUMN "public"."sys_dict_item"."status" IS '状态（1启用 0不启用）';

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_dict_type";
CREATE TABLE "public"."sys_dict_type" (
  "dict_id" int8 NOT NULL,
  "dict_name" varchar(100) COLLATE "pg_catalog"."default",
  "dict_type" varchar(100) COLLATE "pg_catalog"."default",
  "status" char(1) COLLATE "pg_catalog"."default",
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "remark" varchar(500) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_dict_type"."dict_id" IS '字典主键';
COMMENT ON COLUMN "public"."sys_dict_type"."dict_name" IS '字典名称';
COMMENT ON COLUMN "public"."sys_dict_type"."dict_type" IS '字典类型';
COMMENT ON COLUMN "public"."sys_dict_type"."status" IS '状态（0正常 1停用）';
COMMENT ON COLUMN "public"."sys_dict_type"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_dict_type"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_dict_type"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_dict_type"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_dict_type"."remark" IS '备注';
COMMENT ON COLUMN "public"."sys_dict_type"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_dict_type" IS '字典类型表';

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_job";
CREATE TABLE "public"."sys_job" (
  "job_id" int8 NOT NULL,
  "job_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "job_group" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "invoke_target" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "cron_expression" varchar(255) COLLATE "pg_catalog"."default",
  "misfire_policy" varchar(20) COLLATE "pg_catalog"."default",
  "concurrent" char(1) COLLATE "pg_catalog"."default",
  "status" char(1) COLLATE "pg_catalog"."default",
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "remark" varchar(500) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_job"."job_id" IS '任务ID';
COMMENT ON COLUMN "public"."sys_job"."job_name" IS '任务名称';
COMMENT ON COLUMN "public"."sys_job"."job_group" IS '任务组名';
COMMENT ON COLUMN "public"."sys_job"."invoke_target" IS '调用目标字符串';
COMMENT ON COLUMN "public"."sys_job"."cron_expression" IS 'cron执行表达式';
COMMENT ON COLUMN "public"."sys_job"."misfire_policy" IS '计划执行错误策略（1立即执行 2执行一次 3放弃执行）';
COMMENT ON COLUMN "public"."sys_job"."concurrent" IS '是否并发执行（0允许 1禁止）';
COMMENT ON COLUMN "public"."sys_job"."status" IS '状态（0正常 1暂停）';
COMMENT ON COLUMN "public"."sys_job"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_job"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_job"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_job"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_job"."remark" IS '备注信息';
COMMENT ON COLUMN "public"."sys_job"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_job" IS '定时任务调度表';

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_job_log";
CREATE TABLE "public"."sys_job_log" (
  "job_log_id" int8 NOT NULL,
  "job_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "job_group" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "invoke_target" varchar(500) COLLATE "pg_catalog"."default" NOT NULL,
  "job_message" varchar(500) COLLATE "pg_catalog"."default",
  "status" char(1) COLLATE "pg_catalog"."default",
  "exception_info" varchar(2000) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_job_log"."job_log_id" IS '任务日志ID';
COMMENT ON COLUMN "public"."sys_job_log"."job_name" IS '任务名称';
COMMENT ON COLUMN "public"."sys_job_log"."job_group" IS '任务组名';
COMMENT ON COLUMN "public"."sys_job_log"."invoke_target" IS '调用目标字符串';
COMMENT ON COLUMN "public"."sys_job_log"."job_message" IS '日志信息';
COMMENT ON COLUMN "public"."sys_job_log"."status" IS '执行状态（0正常 1失败）';
COMMENT ON COLUMN "public"."sys_job_log"."exception_info" IS '异常信息';
COMMENT ON COLUMN "public"."sys_job_log"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_job_log"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_job_log" IS '定时任务调度日志表';

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_logininfor";
CREATE TABLE "public"."sys_logininfor" (
  "info_id" int8 NOT NULL,
  "user_name" varchar(50) COLLATE "pg_catalog"."default",
  "ipaddr" varchar(128) COLLATE "pg_catalog"."default",
  "status" char(1) COLLATE "pg_catalog"."default",
  "msg" varchar(255) COLLATE "pg_catalog"."default",
  "access_time" timestamp(6),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_logininfor"."info_id" IS '访问ID';
COMMENT ON COLUMN "public"."sys_logininfor"."user_name" IS '用户账号';
COMMENT ON COLUMN "public"."sys_logininfor"."ipaddr" IS '登录IP地址';
COMMENT ON COLUMN "public"."sys_logininfor"."status" IS '登录状态（0成功 1失败）';
COMMENT ON COLUMN "public"."sys_logininfor"."msg" IS '提示信息';
COMMENT ON COLUMN "public"."sys_logininfor"."access_time" IS '访问时间';
COMMENT ON COLUMN "public"."sys_logininfor"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_logininfor" IS '系统访问记录';

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_menu";
CREATE TABLE "public"."sys_menu" (
  "menu_id" int8 NOT NULL,
  "menu_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "parent_id" int8 DEFAULT 0,
  "order_num" int4 DEFAULT 0,
  "path" varchar(200) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "component" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "query" varchar(255) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "is_frame" int4 DEFAULT 1,
  "is_cache" int4 DEFAULT 0,
  "menu_type" char(1) COLLATE "pg_catalog"."default" DEFAULT ''::bpchar,
  "visible" char(1) COLLATE "pg_catalog"."default" DEFAULT '0'::bpchar,
  "status" char(1) COLLATE "pg_catalog"."default" DEFAULT '0'::bpchar,
  "perms" varchar(100) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "icon" varchar(100) COLLATE "pg_catalog"."default" DEFAULT '#'::character varying,
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "update_time" timestamp(6),
  "remark" varchar(500) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "system_name" varchar(20) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_menu"."menu_id" IS '菜单ID';
COMMENT ON COLUMN "public"."sys_menu"."menu_name" IS '菜单名称';
COMMENT ON COLUMN "public"."sys_menu"."parent_id" IS '父菜单ID';
COMMENT ON COLUMN "public"."sys_menu"."order_num" IS '显示顺序';
COMMENT ON COLUMN "public"."sys_menu"."path" IS '路由地址';
COMMENT ON COLUMN "public"."sys_menu"."component" IS '组件路径';
COMMENT ON COLUMN "public"."sys_menu"."is_frame" IS '是否为外链（0是 1否）';
COMMENT ON COLUMN "public"."sys_menu"."is_cache" IS '是否缓存（0缓存 1不缓存）';
COMMENT ON COLUMN "public"."sys_menu"."menu_type" IS '菜单类型（M目录 C菜单 F按钮）';
COMMENT ON COLUMN "public"."sys_menu"."visible" IS '菜单状态（0显示 1隐藏）';
COMMENT ON COLUMN "public"."sys_menu"."status" IS '菜单状态（0正常 1停用）';
COMMENT ON COLUMN "public"."sys_menu"."perms" IS '权限标识';
COMMENT ON COLUMN "public"."sys_menu"."icon" IS '菜单图标';
COMMENT ON COLUMN "public"."sys_menu"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_menu"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_menu"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_menu"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_menu"."remark" IS '备注';
COMMENT ON COLUMN "public"."sys_menu"."system_name" IS '前端系统名称';
COMMENT ON COLUMN "public"."sys_menu"."tenant_id" IS '租户id';
COMMENT ON TABLE "public"."sys_menu" IS '菜单权限表';

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_notice";
CREATE TABLE "public"."sys_notice" (
  "notice_id" int8 NOT NULL,
  "notice_title" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "notice_type" char(1) COLLATE "pg_catalog"."default" NOT NULL,
  "notice_content" bytea,
  "status" char(1) COLLATE "pg_catalog"."default",
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_notice"."notice_id" IS '公告ID';
COMMENT ON COLUMN "public"."sys_notice"."notice_title" IS '公告标题';
COMMENT ON COLUMN "public"."sys_notice"."notice_type" IS '公告类型（1通知 2公告）';
COMMENT ON COLUMN "public"."sys_notice"."notice_content" IS '公告内容';
COMMENT ON COLUMN "public"."sys_notice"."status" IS '公告状态（0正常 1关闭）';
COMMENT ON COLUMN "public"."sys_notice"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_notice"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_notice"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_notice"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_notice"."remark" IS '备注';
COMMENT ON COLUMN "public"."sys_notice"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_notice" IS '通知公告表';

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_oper_log";
CREATE TABLE "public"."sys_oper_log" (
  "oper_id" int8 NOT NULL,
  "title" varchar(50) COLLATE "pg_catalog"."default",
  "business_type" int4,
  "method" varchar(100) COLLATE "pg_catalog"."default",
  "request_method" varchar(10) COLLATE "pg_catalog"."default",
  "operator_type" int4,
  "oper_name" varchar(50) COLLATE "pg_catalog"."default",
  "dept_name" varchar(50) COLLATE "pg_catalog"."default",
  "oper_url" varchar(255) COLLATE "pg_catalog"."default",
  "oper_ip" varchar(128) COLLATE "pg_catalog"."default",
  "oper_location" varchar(255) COLLATE "pg_catalog"."default",
  "oper_param" varchar(2000) COLLATE "pg_catalog"."default",
  "json_result" varchar(2000) COLLATE "pg_catalog"."default",
  "status" int4,
  "error_msg" varchar(2000) COLLATE "pg_catalog"."default",
  "oper_time" timestamp(6),
  "code" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_oper_log"."oper_id" IS '日志主键';
COMMENT ON COLUMN "public"."sys_oper_log"."title" IS '模块标题';
COMMENT ON COLUMN "public"."sys_oper_log"."business_type" IS '业务类型（0其它 1新增 2修改 3删除）';
COMMENT ON COLUMN "public"."sys_oper_log"."method" IS '方法名称';
COMMENT ON COLUMN "public"."sys_oper_log"."request_method" IS '请求方式';
COMMENT ON COLUMN "public"."sys_oper_log"."operator_type" IS '操作类别（0其它 1后台用户 2手机端用户）';
COMMENT ON COLUMN "public"."sys_oper_log"."oper_name" IS '操作人员';
COMMENT ON COLUMN "public"."sys_oper_log"."dept_name" IS '部门名称';
COMMENT ON COLUMN "public"."sys_oper_log"."oper_url" IS '请求URL';
COMMENT ON COLUMN "public"."sys_oper_log"."oper_ip" IS '主机地址';
COMMENT ON COLUMN "public"."sys_oper_log"."oper_location" IS '操作地点';
COMMENT ON COLUMN "public"."sys_oper_log"."oper_param" IS '请求参数';
COMMENT ON COLUMN "public"."sys_oper_log"."json_result" IS '返回参数';
COMMENT ON COLUMN "public"."sys_oper_log"."status" IS '操作状态（0正常 1异常）';
COMMENT ON COLUMN "public"."sys_oper_log"."error_msg" IS '错误消息';
COMMENT ON COLUMN "public"."sys_oper_log"."oper_time" IS '操作时间';
COMMENT ON COLUMN "public"."sys_oper_log"."code" IS '自定义业务接口编码';
COMMENT ON COLUMN "public"."sys_oper_log"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."sys_oper_log" IS '操作日志记录';

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_post";
CREATE TABLE "public"."sys_post" (
  "post_id" int8 NOT NULL,
  "post_code" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "post_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "post_sort" int4 NOT NULL,
  "status" char(1) COLLATE "pg_catalog"."default" NOT NULL,
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "remark" varchar(500) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_post"."post_id" IS '岗位ID';
COMMENT ON COLUMN "public"."sys_post"."post_code" IS '岗位编码';
COMMENT ON COLUMN "public"."sys_post"."post_name" IS '岗位名称';
COMMENT ON COLUMN "public"."sys_post"."post_sort" IS '显示顺序';
COMMENT ON COLUMN "public"."sys_post"."status" IS '状态（0正常 1停用）';
COMMENT ON COLUMN "public"."sys_post"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_post"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_post"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_post"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_post"."remark" IS '备注';
COMMENT ON COLUMN "public"."sys_post"."tenant_id" IS '租户id';
COMMENT ON TABLE "public"."sys_post" IS '岗位信息表';

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_role";
CREATE TABLE "public"."sys_role" (
  "role_id" int8 NOT NULL,
  "role_name" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "role_key" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "role_sort" int4 NOT NULL,
  "data_scope" char(1) COLLATE "pg_catalog"."default",
  "menu_check_strictly" bool NOT NULL,
  "dept_check_strictly" bool NOT NULL,
  "status" char(1) COLLATE "pg_catalog"."default" NOT NULL,
  "del_flag" char(1) COLLATE "pg_catalog"."default" DEFAULT 0,
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "remark" varchar(500) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."sys_role"."role_id" IS '角色ID';
COMMENT ON COLUMN "public"."sys_role"."role_name" IS '角色名称';
COMMENT ON COLUMN "public"."sys_role"."role_key" IS '角色权限字符串';
COMMENT ON COLUMN "public"."sys_role"."role_sort" IS '显示顺序';
COMMENT ON COLUMN "public"."sys_role"."data_scope" IS '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）';
COMMENT ON COLUMN "public"."sys_role"."menu_check_strictly" IS '菜单树选择项是否关联显示';
COMMENT ON COLUMN "public"."sys_role"."dept_check_strictly" IS '部门树选择项是否关联显示';
COMMENT ON COLUMN "public"."sys_role"."status" IS '角色状态（0正常 1停用）';
COMMENT ON COLUMN "public"."sys_role"."del_flag" IS '删除标志（0代表存在 2代表删除）';
COMMENT ON COLUMN "public"."sys_role"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_role"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_role"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_role"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_role"."remark" IS '备注';
COMMENT ON COLUMN "public"."sys_role"."tenant_id" IS '租户id';
COMMENT ON TABLE "public"."sys_role" IS '角色信息表';

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_role_dept";
CREATE TABLE "public"."sys_role_dept" (
  "role_id" int8 NOT NULL,
  "dept_id" int8 NOT NULL
)
;
COMMENT ON COLUMN "public"."sys_role_dept"."role_id" IS '角色ID';
COMMENT ON COLUMN "public"."sys_role_dept"."dept_id" IS '部门ID';
COMMENT ON TABLE "public"."sys_role_dept" IS '角色和部门关联表';

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_role_menu";
CREATE TABLE "public"."sys_role_menu" (
  "role_id" int8 NOT NULL,
  "menu_id" int8 NOT NULL
)
;
COMMENT ON COLUMN "public"."sys_role_menu"."role_id" IS '角色ID';
COMMENT ON COLUMN "public"."sys_role_menu"."menu_id" IS '菜单ID';
COMMENT ON TABLE "public"."sys_role_menu" IS '角色和菜单关联表';

-- ----------------------------
-- Table structure for sys_tenant
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_tenant";
CREATE TABLE "public"."sys_tenant" (
  "tenant_id" int8 NOT NULL,
  "tenant_name" varchar(50) COLLATE "pg_catalog"."default",
  "ancestors" varchar(255) COLLATE "pg_catalog"."default",
  "order_num" int4,
  "leader" varchar(50) COLLATE "pg_catalog"."default",
  "phone" varchar(15) COLLATE "pg_catalog"."default",
  "email" varchar(50) COLLATE "pg_catalog"."default",
  "status" char(1) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "tenant_code" varchar(50) COLLATE "pg_catalog"."default",
  "xzqhdm" varchar(30) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."sys_tenant"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."sys_tenant"."tenant_name" IS '租户名称';
COMMENT ON COLUMN "public"."sys_tenant"."ancestors" IS '祖级列表';
COMMENT ON COLUMN "public"."sys_tenant"."order_num" IS '显示顺序';
COMMENT ON COLUMN "public"."sys_tenant"."leader" IS '负责人';
COMMENT ON COLUMN "public"."sys_tenant"."phone" IS '联系电话';
COMMENT ON COLUMN "public"."sys_tenant"."email" IS '邮箱';
COMMENT ON COLUMN "public"."sys_tenant"."status" IS '租户状态（0正常 1停用）';
COMMENT ON COLUMN "public"."sys_tenant"."del_flag" IS '删除标志（0代表存在 2代表删除）';
COMMENT ON COLUMN "public"."sys_tenant"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_tenant"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_tenant"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_tenant"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_tenant"."tenant_code" IS '租户编码';
COMMENT ON COLUMN "public"."sys_tenant"."xzqhdm" IS '行政区划代码';
COMMENT ON TABLE "public"."sys_tenant" IS '维修资金系统租户表';

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_user";
CREATE TABLE "public"."sys_user" (
  "user_id" int8 NOT NULL,
  "dept_id" int8,
  "user_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "nick_name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "user_type" varchar(2) COLLATE "pg_catalog"."default" DEFAULT '00'::character varying,
  "email" varchar(50) COLLATE "pg_catalog"."default",
  "phonenumber" varchar(11) COLLATE "pg_catalog"."default",
  "sex" char(1) COLLATE "pg_catalog"."default",
  "avatar" varchar(100) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "password" varchar(100) COLLATE "pg_catalog"."default",
  "status" char(1) COLLATE "pg_catalog"."default" DEFAULT 0,
  "del_flag" char(1) COLLATE "pg_catalog"."default" DEFAULT '0'::bpchar,
  "login_ip" varchar(128) COLLATE "pg_catalog"."default",
  "login_date" timestamp(6),
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "remark" varchar(500) COLLATE "pg_catalog"."default",
  "jgxx_id" int8,
  "jglx" int2,
  "jgmc" varchar(100) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "sign_img" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."sys_user"."user_id" IS '用户ID';
COMMENT ON COLUMN "public"."sys_user"."dept_id" IS '部门ID';
COMMENT ON COLUMN "public"."sys_user"."user_name" IS '用户账号';
COMMENT ON COLUMN "public"."sys_user"."nick_name" IS '用户昵称';
COMMENT ON COLUMN "public"."sys_user"."user_type" IS '用户类型（00系统用户）';
COMMENT ON COLUMN "public"."sys_user"."email" IS '用户邮箱';
COMMENT ON COLUMN "public"."sys_user"."phonenumber" IS '手机号码';
COMMENT ON COLUMN "public"."sys_user"."sex" IS '用户性别（0男 1女 2未知）';
COMMENT ON COLUMN "public"."sys_user"."avatar" IS '头像地址';
COMMENT ON COLUMN "public"."sys_user"."password" IS '密码';
COMMENT ON COLUMN "public"."sys_user"."status" IS '帐号状态（0正常 1停用）';
COMMENT ON COLUMN "public"."sys_user"."del_flag" IS '删除标志（0代表存在 2代表删除）';
COMMENT ON COLUMN "public"."sys_user"."login_ip" IS '最后登录IP';
COMMENT ON COLUMN "public"."sys_user"."login_date" IS '最后登录时间';
COMMENT ON COLUMN "public"."sys_user"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."sys_user"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."sys_user"."update_by" IS '更新者';
COMMENT ON COLUMN "public"."sys_user"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."sys_user"."remark" IS '备注';
COMMENT ON COLUMN "public"."sys_user"."jgxx_id" IS '机构信息id';
COMMENT ON COLUMN "public"."sys_user"."jglx" IS '机构类型(0-开发建设单位、1-物业服务企业 2-施工单位、3-审价单位、4-业主委员会 5-街道办(乡镇政府)、6-居委会 7-代管机构 8-专户银行)';
COMMENT ON COLUMN "public"."sys_user"."jgmc" IS '机构名称';
COMMENT ON COLUMN "public"."sys_user"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."sys_user"."sign_img" IS '手写签名';
COMMENT ON TABLE "public"."sys_user" IS '用户信息表';

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_user_post";
CREATE TABLE "public"."sys_user_post" (
  "user_id" int8 NOT NULL,
  "post_id" int8 NOT NULL
)
;
COMMENT ON COLUMN "public"."sys_user_post"."user_id" IS '用户ID';
COMMENT ON COLUMN "public"."sys_user_post"."post_id" IS '岗位ID';
COMMENT ON TABLE "public"."sys_user_post" IS '用户与岗位关联表';

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS "public"."sys_user_role";
CREATE TABLE "public"."sys_user_role" (
  "user_id" int8 NOT NULL,
  "role_id" int8 NOT NULL
)
;
COMMENT ON COLUMN "public"."sys_user_role"."user_id" IS '用户ID';
COMMENT ON COLUMN "public"."sys_user_role"."role_id" IS '角色ID';
COMMENT ON TABLE "public"."sys_user_role" IS '用户和角色关联表';

-- ----------------------------
-- Table structure for t_account
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_account";
CREATE TABLE "public"."t_account" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) NOT NULL DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "zhmc" varchar(30) COLLATE "pg_catalog"."default",
  "zh" varchar(20) COLLATE "pg_catalog"."default",
  "yhmc" varchar(60) COLLATE "pg_catalog"."default",
  "hh" varchar(60) COLLATE "pg_catalog"."default",
  "bz" bool,
  "lx" int2,
  "zt" bool,
  "ye" numeric(18,2) DEFAULT 0,
  "xzqydm" varchar(32) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_account"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_account"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_account"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_account"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_account"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_account"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_account"."zhmc" IS '账户户名';
COMMENT ON COLUMN "public"."t_account"."zh" IS '账号';
COMMENT ON COLUMN "public"."t_account"."yhmc" IS '银行名称';
COMMENT ON COLUMN "public"."t_account"."hh" IS '行号';
COMMENT ON COLUMN "public"."t_account"."bz" IS '本他行标识(是否)';
COMMENT ON COLUMN "public"."t_account"."lx" IS '账户类型(1:归集户,2:备用金户,3:增值账户)';
COMMENT ON COLUMN "public"."t_account"."zt" IS '启用状态(1:启用,2:关闭)';
COMMENT ON COLUMN "public"."t_account"."ye" IS '余额';
COMMENT ON COLUMN "public"."t_account"."xzqydm" IS '备用金账户所属行政区域';
COMMENT ON TABLE "public"."t_account" IS '账户管理';

-- ----------------------------
-- Table structure for t_account_balance
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_account_balance";
CREATE TABLE "public"."t_account_balance" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(20) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(50) COLLATE "pg_catalog"."default",
  "xxdz" varchar(200) COLLATE "pg_catalog"."default",
  "account_id" varchar(26) COLLATE "pg_catalog"."default",
  "jfbz" varchar(30) COLLATE "pg_catalog"."default",
  "yebdrq" varchar(255) COLLATE "pg_catalog"."default",
  "bdje" numeric(10,2),
  "lx" int2,
  "ye" numeric(10,2)
)
;
COMMENT ON COLUMN "public"."t_account_balance"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_account_balance"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_account_balance"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_account_balance"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_account_balance"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_account_balance"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_account_balance"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_account_balance"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_account_balance"."xxdz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_account_balance"."account_id" IS '分户信息Id';
COMMENT ON COLUMN "public"."t_account_balance"."jfbz" IS '缴费标准(应交金额)';
COMMENT ON COLUMN "public"."t_account_balance"."yebdrq" IS '余额变动日期';
COMMENT ON COLUMN "public"."t_account_balance"."bdje" IS '变动金额';
COMMENT ON COLUMN "public"."t_account_balance"."lx" IS '余额变动类型(1:支出,2:收入)';
COMMENT ON COLUMN "public"."t_account_balance"."ye" IS '余额';
COMMENT ON TABLE "public"."t_account_balance" IS '分户账户余额监控';

-- ----------------------------
-- Table structure for t_account_flow_information
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_account_flow_information";
CREATE TABLE "public"."t_account_flow_information" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(50) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "wyqydz" varchar(255) COLLATE "pg_catalog"."default",
  "fhdm" varchar(26) COLLATE "pg_catalog"."default",
  "lzdm" varchar(18) COLLATE "pg_catalog"."default",
  "lzmc" varchar(50) COLLATE "pg_catalog"."default",
  "dymc" varchar(20) COLLATE "pg_catalog"."default",
  "myc" int4,
  "sjc" int4,
  "sh" varchar(20) COLLATE "pg_catalog"."default",
  "jzmj" numeric(10,2),
  "xxdz" varchar(255) COLLATE "pg_catalog"."default",
  "je" numeric(10,2),
  "jfbz" numeric(10,2),
  "jklx" varchar(64) COLLATE "pg_catalog"."default",
  "jksj" timestamp(6),
  "wyqysylx" varchar(20) COLLATE "pg_catalog"."default",
  "ywbh" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "xzqhdm" varchar(12) COLLATE "pg_catalog"."default",
  "lslx" varchar(12) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_account_flow_information"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_account_flow_information"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_account_flow_information"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_account_flow_information"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_account_flow_information"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_account_flow_information"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_account_flow_information"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_account_flow_information"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_account_flow_information"."wyqydz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_account_flow_information"."fhdm" IS '分户代码';
COMMENT ON COLUMN "public"."t_account_flow_information"."lzdm" IS '楼幢代码';
COMMENT ON COLUMN "public"."t_account_flow_information"."lzmc" IS '楼幢名称';
COMMENT ON COLUMN "public"."t_account_flow_information"."dymc" IS '单元名称';
COMMENT ON COLUMN "public"."t_account_flow_information"."myc" IS '名义楼层';
COMMENT ON COLUMN "public"."t_account_flow_information"."sjc" IS '实际层';
COMMENT ON COLUMN "public"."t_account_flow_information"."sh" IS '室号';
COMMENT ON COLUMN "public"."t_account_flow_information"."jzmj" IS '建筑面积';
COMMENT ON COLUMN "public"."t_account_flow_information"."xxdz" IS '房屋详细地址';
COMMENT ON COLUMN "public"."t_account_flow_information"."je" IS '交易金额';
COMMENT ON COLUMN "public"."t_account_flow_information"."jfbz" IS '缴费标准';
COMMENT ON COLUMN "public"."t_account_flow_information"."jklx" IS '交款类型';
COMMENT ON COLUMN "public"."t_account_flow_information"."jksj" IS '交易时间YYYY-MM-DD hh:mm:ss';
COMMENT ON COLUMN "public"."t_account_flow_information"."wyqysylx" IS '物业区域使用类型(1.商品房,2.公有售房,3.新居工程,4.拆迁安置房,5.单一产权人,6.统规自建房,7.征地拆迁房,8.商业非住宅,9.其他非住宅,10.保障性住房,11.全额集资建房,12.农村集中居住区,13.其他)';
COMMENT ON COLUMN "public"."t_account_flow_information"."ywbh" IS '对应交款记录业务编号、退款记录业务编号、使用记录业务编号';
COMMENT ON COLUMN "public"."t_account_flow_information"."xzqhdm" IS '所属行政区划代码';
COMMENT ON COLUMN "public"."t_account_flow_information"."lslx" IS '分户流水类型 1-交存 2-退款 3-使用 4-利息分摊';
COMMENT ON TABLE "public"."t_account_flow_information" IS '单户账户流水信息表';

-- ----------------------------
-- Table structure for t_account_remind
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_account_remind";
CREATE TABLE "public"."t_account_remind" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "ywbh" varchar(32) COLLATE "pg_catalog"."default",
  "xzqhdm" varchar(12) COLLATE "pg_catalog"."default",
  "yebzhs" varchar(10) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_account_remind"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_account_remind"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_account_remind"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_account_remind"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_account_remind"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_account_remind"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_account_remind"."ywbh" IS '业务编号，业务系统唯一标识';
COMMENT ON COLUMN "public"."t_account_remind"."xzqhdm" IS '所属行政区划代码';
COMMENT ON COLUMN "public"."t_account_remind"."yebzhs" IS '余额不足户数';
COMMENT ON TABLE "public"."t_account_remind" IS '单户余额不足提醒消息';

-- ----------------------------
-- Table structure for t_account_result
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_account_result";
CREATE TABLE "public"."t_account_result" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "je" numeric(10,2),
  "tzdbh" varchar(100) COLLATE "pg_catalog"."default",
  "zy" varchar(255) COLLATE "pg_catalog"."default",
  "yhlsh" varchar(64) COLLATE "pg_catalog"."default",
  "dzlx" int2,
  "ppzt" int2,
  "jzrq" timestamp(6),
  "jyfx" varchar(100) COLLATE "pg_catalog"."default",
  "jysj" timestamp(6),
  "yhqrsj" timestamp(6),
  "lsppzt" varchar(10) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_account_result"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_account_result"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_account_result"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_account_result"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_account_result"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_account_result"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_account_result"."je" IS '金额';
COMMENT ON COLUMN "public"."t_account_result"."tzdbh" IS '通知单编号';
COMMENT ON COLUMN "public"."t_account_result"."zy" IS '摘要';
COMMENT ON COLUMN "public"."t_account_result"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."t_account_result"."dzlx" IS '对账类型(1.自动,2.手动)';
COMMENT ON COLUMN "public"."t_account_result"."ppzt" IS '匹配状态(1:已匹配,2未匹配)';
COMMENT ON COLUMN "public"."t_account_result"."jzrq" IS '记账日期';
COMMENT ON COLUMN "public"."t_account_result"."jyfx" IS '交易方向(1:支出,2:收入)';
COMMENT ON COLUMN "public"."t_account_result"."jysj" IS '交易时间';
COMMENT ON COLUMN "public"."t_account_result"."yhqrsj" IS '银行确认时间';
COMMENT ON COLUMN "public"."t_account_result"."lsppzt" IS '流水匹配状态(人工匹配/未匹配)';
COMMENT ON TABLE "public"."t_account_result" IS '对账结果';

-- ----------------------------
-- Table structure for t_batch_payment
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_batch_payment";
CREATE TABLE "public"."t_batch_payment" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(20) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "wyqydz" varchar(200) COLLATE "pg_catalog"."default",
  "jsdwjgmc" varchar(100) COLLATE "pg_catalog"."default",
  "jsdwjgshxydm" varchar(18) COLLATE "pg_catalog"."default",
  "jsdwjgshxydmyxq" timestamp(6),
  "jsdwlxr" varchar(20) COLLATE "pg_catalog"."default",
  "jsdwlxdh" varchar(20) COLLATE "pg_catalog"."default",
  "fhxx" json,
  "jkyh" varchar(100) COLLATE "pg_catalog"."default",
  "jkyhzhmc" varchar(200) COLLATE "pg_catalog"."default",
  "jkyhzh" varchar(64) COLLATE "pg_catalog"."default",
  "jkje" numeric(18,2),
  "yhlsh" varchar(64) COLLATE "pg_catalog"."default",
  "jkfs" varchar(20) COLLATE "pg_catalog"."default",
  "ywbh" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "xzqhdm" varchar(26) COLLATE "pg_catalog"."default",
  "jsdwfddbr" varchar(100) COLLATE "pg_catalog"."default",
  "jsdwfrsjh" varchar(20) COLLATE "pg_catalog"."default",
  "jklx" varchar(200) COLLATE "pg_catalog"."default",
  "jksj" timestamp(6),
  "sfycl" int2
)
;
COMMENT ON COLUMN "public"."t_batch_payment"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_batch_payment"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_batch_payment"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_batch_payment"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_batch_payment"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_batch_payment"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_batch_payment"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_batch_payment"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_batch_payment"."wyqydz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_batch_payment"."jsdwjgmc" IS '机构名称';
COMMENT ON COLUMN "public"."t_batch_payment"."jsdwjgshxydm" IS '社会信用代码';
COMMENT ON COLUMN "public"."t_batch_payment"."jsdwjgshxydmyxq" IS '社会信用代码有效期';
COMMENT ON COLUMN "public"."t_batch_payment"."jsdwlxr" IS '联系人';
COMMENT ON COLUMN "public"."t_batch_payment"."jsdwlxdh" IS '联系人电话';
COMMENT ON COLUMN "public"."t_batch_payment"."fhxx" IS '分户账户信息(lzdm:楼幢代码,dymc:单元名称,lzmc:楼幢名称,myc:名义层,
sjc:实际层
,sh:室号,
jzmj:建筑面积,
xxdz:房屋详细地址,
fhjkje:分户交款金额,
fhjklx:分户交款类型)';
COMMENT ON COLUMN "public"."t_batch_payment"."jkyh" IS '交款银行名称';
COMMENT ON COLUMN "public"."t_batch_payment"."jkyhzhmc" IS '交款银行账户名称';
COMMENT ON COLUMN "public"."t_batch_payment"."jkyhzh" IS '交款银行账号';
COMMENT ON COLUMN "public"."t_batch_payment"."jkje" IS '交款金额';
COMMENT ON COLUMN "public"."t_batch_payment"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."t_batch_payment"."jkfs" IS '交款方式(1.现金,2.支票,3.托收,4.网银,5.其他)';
COMMENT ON COLUMN "public"."t_batch_payment"."ywbh" IS '业务编号，业务系统数据唯一标识';
COMMENT ON COLUMN "public"."t_batch_payment"."xzqhdm" IS '行政区划代码';
COMMENT ON COLUMN "public"."t_batch_payment"."jsdwfddbr" IS '建设单位法人姓名';
COMMENT ON COLUMN "public"."t_batch_payment"."jsdwfrsjh" IS '建设单位法人手机号码';
COMMENT ON COLUMN "public"."t_batch_payment"."jklx" IS '交款类型';
COMMENT ON COLUMN "public"."t_batch_payment"."jksj" IS '交款时间';
COMMENT ON COLUMN "public"."t_batch_payment"."sfycl" IS '是否已处理，标记是否完成分户数据的批量拆分处理';
COMMENT ON TABLE "public"."t_batch_payment" IS '批量交款信息';

-- ----------------------------
-- Table structure for t_batch_refund
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_batch_refund";
CREATE TABLE "public"."t_batch_refund" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(20) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "xxdz" varchar(200) COLLATE "pg_catalog"."default",
  "tkyy" varchar(200) COLLATE "pg_catalog"."default",
  "zkzh" varchar(64) COLLATE "pg_catalog"."default",
  "tkzje" numeric(10,2),
  "yhlsh" varchar(20) COLLATE "pg_catalog"."default",
  "zksj" timestamp(6),
  "fhxx" json,
  "ywbh" varchar(32) COLLATE "pg_catalog"."default",
  "xzqhdm" varchar(12) COLLATE "pg_catalog"."default",
  "wyqydz" varchar(200) COLLATE "pg_catalog"."default",
  "sfycl" int2
)
;
COMMENT ON COLUMN "public"."t_batch_refund"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_batch_refund"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_batch_refund"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_batch_refund"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_batch_refund"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_batch_refund"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_batch_refund"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_batch_refund"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_batch_refund"."xxdz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_batch_refund"."tkyy" IS '退款原因';
COMMENT ON COLUMN "public"."t_batch_refund"."zkzh" IS '支款账户';
COMMENT ON COLUMN "public"."t_batch_refund"."tkzje" IS '退款总金额';
COMMENT ON COLUMN "public"."t_batch_refund"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."t_batch_refund"."zksj" IS '支款日期';
COMMENT ON COLUMN "public"."t_batch_refund"."fhxx" IS '分户账户信息(zdm:楼幢代码,dymc:单元名称,lzmc:楼幢名称,myc:名义层,
sjc:实际层
,sh:室号,
jzmj:建筑面积,
xxdz:房屋详细地址,
fhtkje:分户退款金额)';
COMMENT ON COLUMN "public"."t_batch_refund"."ywbh" IS '业务编号，业务系统唯一标识';
COMMENT ON COLUMN "public"."t_batch_refund"."xzqhdm" IS '行政区划代码';
COMMENT ON COLUMN "public"."t_batch_refund"."wyqydz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_batch_refund"."sfycl" IS '是否已处理，标记是否完成分户数据的批量拆分处理';
COMMENT ON TABLE "public"."t_batch_refund" IS '批量退款信息';

-- ----------------------------
-- Table structure for t_bill
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_bill";
CREATE TABLE "public"."t_bill" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) NOT NULL DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "zdmc" varchar(255) COLLATE "pg_catalog"."default",
  "dzzt" int2 NOT NULL DEFAULT 0
)
;
COMMENT ON COLUMN "public"."t_bill"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_bill"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_bill"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_bill"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_bill"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_bill"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_bill"."zdmc" IS '账单名称';
COMMENT ON COLUMN "public"."t_bill"."dzzt" IS '对账状态(1:已对账,0:未对账)';
COMMENT ON TABLE "public"."t_bill" IS '每日账单列表';

-- ----------------------------
-- Table structure for t_buildup
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_buildup";
CREATE TABLE "public"."t_buildup" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "del_flag" int2,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "js" numeric,
  "yhzh" varchar(30) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_buildup"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_buildup"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_buildup"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_buildup"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_buildup"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_buildup"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_buildup"."js" IS '积数';
COMMENT ON COLUMN "public"."t_buildup"."yhzh" IS '银行账户';
COMMENT ON TABLE "public"."t_buildup" IS '积数统计表';

-- ----------------------------
-- Table structure for t_collective_balance
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_collective_balance";
CREATE TABLE "public"."t_collective_balance" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "gjzhmc" varchar(50) COLLATE "pg_catalog"."default",
  "gjzhkhh" varchar(50) COLLATE "pg_catalog"."default",
  "gjzhzh" varchar(20) COLLATE "pg_catalog"."default",
  "ye" numeric(10,2),
  "yebdrq" timestamp(6),
  "yebdje" numeric(10,2),
  "lx" int2,
  "xzqydm" varchar(30) COLLATE "pg_catalog"."default",
  "xzqymc" varchar(100) COLLATE "pg_catalog"."default",
  "wyqysl" int8,
  "lzsl" int8,
  "fwsl" int8,
  "zjzmj" numeric(10,2),
  "zyjk" numeric(10,2),
  "zjk" numeric(10,2),
  "zsye" numeric(10,2),
  "zsyed" numeric(10,2),
  "ztke" numeric(10,2),
  "zhlx" int2
)
;
COMMENT ON COLUMN "public"."t_collective_balance"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_collective_balance"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_collective_balance"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_collective_balance"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_collective_balance"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_collective_balance"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_collective_balance"."gjzhmc" IS '归集账户名称';
COMMENT ON COLUMN "public"."t_collective_balance"."gjzhkhh" IS '归集账户开户行';
COMMENT ON COLUMN "public"."t_collective_balance"."gjzhzh" IS '归集账户';
COMMENT ON COLUMN "public"."t_collective_balance"."ye" IS '余额';
COMMENT ON COLUMN "public"."t_collective_balance"."yebdrq" IS '余额变动日期';
COMMENT ON COLUMN "public"."t_collective_balance"."yebdje" IS '余额变动金额';
COMMENT ON COLUMN "public"."t_collective_balance"."lx" IS '余额变动类型(1:支出,2:收入)';
COMMENT ON COLUMN "public"."t_collective_balance"."xzqydm" IS '行政区域代码';
COMMENT ON COLUMN "public"."t_collective_balance"."xzqymc" IS '行政区域名称';
COMMENT ON COLUMN "public"."t_collective_balance"."wyqysl" IS '物业区域数量';
COMMENT ON COLUMN "public"."t_collective_balance"."lzsl" IS '楼幢数量';
COMMENT ON COLUMN "public"."t_collective_balance"."fwsl" IS '房屋数量';
COMMENT ON COLUMN "public"."t_collective_balance"."zjzmj" IS '总建筑面积';
COMMENT ON COLUMN "public"."t_collective_balance"."zyjk" IS '总应交款';
COMMENT ON COLUMN "public"."t_collective_balance"."zjk" IS '总交款';
COMMENT ON COLUMN "public"."t_collective_balance"."zsye" IS '总使用额';
COMMENT ON COLUMN "public"."t_collective_balance"."zsyed" IS '总使用额';
COMMENT ON COLUMN "public"."t_collective_balance"."ztke" IS '总退款额';
COMMENT ON COLUMN "public"."t_collective_balance"."zhlx" IS '账户类型(1:归集户,2:备用金)';
COMMENT ON TABLE "public"."t_collective_balance" IS '归集户余额监控与备用金账户余额';

-- ----------------------------
-- Table structure for t_current_bill
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_current_bill";
CREATE TABLE "public"."t_current_bill" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "jskssj" timestamp(6),
  "jsjssj" timestamp(6),
  "jxkssj" timestamp(6),
  "jxjssj" timestamp(6),
  "yjjx" numeric(30,2),
  "jsjzll" varchar(20) COLLATE "pg_catalog"."default",
  "zxll" varchar(20) COLLATE "pg_catalog"."default",
  "sjjx" numeric(10,2),
  "sjjzll" varchar(20) COLLATE "pg_catalog"."default",
  "sjll" varchar(20) COLLATE "pg_catalog"."default",
  "ce" numeric(30,2),
  "major_bill_id" int8,
  "yhzh" varchar(30) COLLATE "pg_catalog"."default",
  "xdlcje" numeric(30),
  "xdll" numeric(30)
)
;
COMMENT ON COLUMN "public"."t_current_bill"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_current_bill"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_current_bill"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_current_bill"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_current_bill"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_current_bill"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_current_bill"."jskssj" IS '结算周期开始时间';
COMMENT ON COLUMN "public"."t_current_bill"."jsjssj" IS '结算结束时间';
COMMENT ON COLUMN "public"."t_current_bill"."jxkssj" IS '结息开始时间';
COMMENT ON COLUMN "public"."t_current_bill"."jxjssj" IS '解析结束时间';
COMMENT ON COLUMN "public"."t_current_bill"."yjjx" IS '预计结息';
COMMENT ON COLUMN "public"."t_current_bill"."jsjzll" IS '计算基准利率';
COMMENT ON COLUMN "public"."t_current_bill"."zxll" IS '执行利率';
COMMENT ON COLUMN "public"."t_current_bill"."sjjx" IS '实际结息';
COMMENT ON COLUMN "public"."t_current_bill"."sjjzll" IS '实际基准利率';
COMMENT ON COLUMN "public"."t_current_bill"."sjll" IS '实际利率';
COMMENT ON COLUMN "public"."t_current_bill"."ce" IS '差额';
COMMENT ON COLUMN "public"."t_current_bill"."major_bill_id" IS 'majorBill 外键关联id';
COMMENT ON COLUMN "public"."t_current_bill"."yhzh" IS '银行账号';
COMMENT ON COLUMN "public"."t_current_bill"."xdlcje" IS '协定金额';
COMMENT ON COLUMN "public"."t_current_bill"."xdll" IS '协定利率';
COMMENT ON TABLE "public"."t_current_bill" IS '活期对账';

-- ----------------------------
-- Table structure for t_everyday_account_allbal
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_everyday_account_allbal";
CREATE TABLE "public"."t_everyday_account_allbal" (
  "id" int8 NOT NULL,
  "zh" varchar(20) COLLATE "pg_catalog"."default",
  "zhmc" varchar(30) COLLATE "pg_catalog"."default",
  "yhmc" varchar(60) COLLATE "pg_catalog"."default",
  "ye" numeric(18,2),
  "create_time" timestamp(6) NOT NULL DEFAULT now(),
  "update_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_everyday_account_allbal"."zh" IS '账户账号';
COMMENT ON COLUMN "public"."t_everyday_account_allbal"."zhmc" IS '账户名称';
COMMENT ON COLUMN "public"."t_everyday_account_allbal"."yhmc" IS '银行名称';
COMMENT ON COLUMN "public"."t_everyday_account_allbal"."ye" IS '余额  以元为单位';
COMMENT ON COLUMN "public"."t_everyday_account_allbal"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_everyday_account_allbal"."update_time" IS '更新时间';
COMMENT ON TABLE "public"."t_everyday_account_allbal" IS '账户每日余额';

-- ----------------------------
-- Table structure for t_everyday_bank_bill
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_everyday_bank_bill";
CREATE TABLE "public"."t_everyday_bank_bill" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 DEFAULT 0,
  "dept_id" int8 DEFAULT 0,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "jyrq" timestamp(6),
  "jyqd" varchar(100) COLLATE "pg_catalog"."default",
  "xzbz" int2,
  "lsh" varchar(30) COLLATE "pg_catalog"."default",
  "jyje" numeric(10,2),
  "jdfx" int2,
  "ye" numeric(30,2),
  "dfzh" varchar(50) COLLATE "pg_catalog"."default",
  "dfhm" varchar(50) COLLATE "pg_catalog"."default",
  "zy" varchar(255) COLLATE "pg_catalog"."default",
  "zt" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."jyrq" IS '交易日期';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."jyqd" IS '交易渠道';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."xzbz" IS '现转标志(1:现金,2:转帐)';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."lsh" IS '流水号';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."jyje" IS '交易金额';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."jdfx" IS '借贷方向(1.收入 2.支出)';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."ye" IS '余额';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."dfzh" IS '对方账号';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."dfhm" IS '对方户名';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."zy" IS '摘要';
COMMENT ON COLUMN "public"."t_everyday_bank_bill"."zt" IS '状态(0:未核对,1:已核对)';
COMMENT ON TABLE "public"."t_everyday_bank_bill" IS '每日对账(银行账单)';

-- ----------------------------
-- Table structure for t_everyday_platform_bill
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_everyday_platform_bill";
CREATE TABLE "public"."t_everyday_platform_bill" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "ywzt" int2,
  "zy" varchar(200) COLLATE "pg_catalog"."default",
  "je" numeric(10,2),
  "tzdzt" varchar(30) COLLATE "pg_catalog"."default",
  "tzlx" int2,
  "tzdrq" timestamp(6),
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "xzqymc" varchar(100) COLLATE "pg_catalog"."default",
  "yhqrrq" timestamp(6),
  "tzdbh" varchar(30) COLLATE "pg_catalog"."default",
  "ppzt" varchar(2) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."ywzt" IS '业务状态';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."zy" IS '业务摘要';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."je" IS '业务金额';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."tzdzt" IS '业务通知单状态';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."tzlx" IS '业务通知类型';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."tzdrq" IS '通知单发送时间';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."xzqymc" IS '行政区域名称';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."yhqrrq" IS '银行确认时间';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."tzdbh" IS '通知单编号';
COMMENT ON COLUMN "public"."t_everyday_platform_bill"."ppzt" IS '匹配状态';
COMMENT ON TABLE "public"."t_everyday_platform_bill" IS '每日对账(平台账单)';

-- ----------------------------
-- Table structure for t_major_bill
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_major_bill";
CREATE TABLE "public"."t_major_bill" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "dzmc" varchar(100) COLLATE "pg_catalog"."default",
  "sjjxje" numeric(30,2),
  "jxksrq" timestamp(6),
  "jxjsrq" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_major_bill"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_major_bill"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_major_bill"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_major_bill"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_major_bill"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_major_bill"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_major_bill"."dzmc" IS '对账表名称';
COMMENT ON COLUMN "public"."t_major_bill"."sjjxje" IS '本期实际解析金额';
COMMENT ON COLUMN "public"."t_major_bill"."jxksrq" IS '结息开始日期';
COMMENT ON COLUMN "public"."t_major_bill"."jxjsrq" IS '结息结束日期';
COMMENT ON TABLE "public"."t_major_bill" IS '活期对账主表';

-- ----------------------------
-- Table structure for t_major_capital
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_major_capital";
CREATE TABLE "public"."t_major_capital" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "jylsh" varchar(20) COLLATE "pg_catalog"."default",
  "zy" varchar(200) COLLATE "pg_catalog"."default",
  "fkzhzh" varchar(64) COLLATE "pg_catalog"."default",
  "fkzhhm" varchar(100) COLLATE "pg_catalog"."default",
  "zzbj" numeric(10,2),
  "ksrq" timestamp(6),
  "zzlx" varchar(20) COLLATE "pg_catalog"."default",
  "cq" numeric(10,2),
  "zzzhzh" varchar(64) COLLATE "pg_catalog"."default",
  "zzzzhm" varchar(50) COLLATE "pg_catalog"."default",
  "pcbh" varchar(64) COLLATE "pg_catalog"."default",
  "zdzc" varchar(10) COLLATE "pg_catalog"."default" DEFAULT false,
  "fhll" varchar(20) COLLATE "pg_catalog"."default",
  "yqlx" numeric(10),
  "jzrq" timestamp(6),
  "lx" varchar(50) COLLATE "pg_catalog"."default",
  "fhbj" numeric(10,2),
  "fhlx" numeric(10,2),
  "fhrq" timestamp(6),
  "zzhzlsh" varchar(30) COLLATE "pg_catalog"."default",
  "zzzt" varchar(20) COLLATE "pg_catalog"."default",
  "ll" numeric(18,4),
  "sjll" numeric(18,4),
  "ywbh" varchar(20) COLLATE "pg_catalog"."default",
  "rate_id" int8,
  "yhmc" varchar(30) COLLATE "pg_catalog"."default",
  "dqrq" timestamp(6),
  "glfhfs" int2
)
;
COMMENT ON COLUMN "public"."t_major_capital"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_major_capital"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_major_capital"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_major_capital"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_major_capital"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_major_capital"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_major_capital"."jylsh" IS '交易流水号';
COMMENT ON COLUMN "public"."t_major_capital"."zy" IS '摘要';
COMMENT ON COLUMN "public"."t_major_capital"."fkzhzh" IS '付款账户账号';
COMMENT ON COLUMN "public"."t_major_capital"."fkzhhm" IS '付款账户户名';
COMMENT ON COLUMN "public"."t_major_capital"."zzbj" IS '增值本金';
COMMENT ON COLUMN "public"."t_major_capital"."ksrq" IS '开始日期';
COMMENT ON COLUMN "public"."t_major_capital"."zzlx" IS '增值类型(1.定期,2.国债,3.其他)';
COMMENT ON COLUMN "public"."t_major_capital"."cq" IS '存期';
COMMENT ON COLUMN "public"."t_major_capital"."zzzhzh" IS '增值账户账号';
COMMENT ON COLUMN "public"."t_major_capital"."zzzzhm" IS '增值账户户名';
COMMENT ON COLUMN "public"."t_major_capital"."pcbh" IS '批次编号';
COMMENT ON COLUMN "public"."t_major_capital"."zdzc" IS '自动转存';
COMMENT ON COLUMN "public"."t_major_capital"."fhll" IS '返还利率';
COMMENT ON COLUMN "public"."t_major_capital"."yqlx" IS '预期利息';
COMMENT ON COLUMN "public"."t_major_capital"."jzrq" IS '记账日期';
COMMENT ON COLUMN "public"."t_major_capital"."lx" IS '类型(1.专户行资金增值划拨确认,2.专户行资金增值返还确认)';
COMMENT ON COLUMN "public"."t_major_capital"."fhbj" IS '返还本金';
COMMENT ON COLUMN "public"."t_major_capital"."fhlx" IS '返还利息';
COMMENT ON COLUMN "public"."t_major_capital"."fhrq" IS '返还日期';
COMMENT ON COLUMN "public"."t_major_capital"."zzhzlsh" IS '增值划转流水号';
COMMENT ON COLUMN "public"."t_major_capital"."zzzt" IS '增值状态(1:未到期 2:已到期。3:待执行)';
COMMENT ON COLUMN "public"."t_major_capital"."ll" IS '预期利率';
COMMENT ON COLUMN "public"."t_major_capital"."sjll" IS '实际利率';
COMMENT ON COLUMN "public"."t_major_capital"."ywbh" IS '业务编号';
COMMENT ON COLUMN "public"."t_major_capital"."rate_id" IS '利息Id';
COMMENT ON COLUMN "public"."t_major_capital"."yhmc" IS '银行名称';
COMMENT ON COLUMN "public"."t_major_capital"."dqrq" IS '到期日期';
COMMENT ON COLUMN "public"."t_major_capital"."glfhfs" IS '关联分户方式 1-当前全部小区 2-银行关联小区 3-自管小区';
COMMENT ON TABLE "public"."t_major_capital" IS '专户行资金增值(划拨/返还)确认,增值管理的所有数据';

-- ----------------------------
-- Table structure for t_notice
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_notice";
CREATE TABLE "public"."t_notice" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "xzqhdm" varchar(50) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(20) COLLATE "pg_catalog"."default",
  "tzdlx" varchar(64) COLLATE "pg_catalog"."default",
  "tzdzt" varchar(50) COLLATE "pg_catalog"."default",
  "tzdbh" varchar(20) COLLATE "pg_catalog"."default",
  "zy" varchar(2550) COLLATE "pg_catalog"."default",
  "jyje" numeric(10,2),
  "fssj" timestamp(6),
  "yhqrsj" timestamp(6),
  "zbyh" varchar(200) COLLATE "pg_catalog"."default",
  "yhzh" varchar(30) COLLATE "pg_catalog"."default",
  "pjbh" varchar(30) COLLATE "pg_catalog"."default",
  "ppzt" int2 DEFAULT 1
)
;
COMMENT ON COLUMN "public"."t_notice"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_notice"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_notice"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_notice"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_notice"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_notice"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_notice"."xzqhdm" IS '行政区域';
COMMENT ON COLUMN "public"."t_notice"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_notice"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_notice"."tzdlx" IS '通知单类型';
COMMENT ON COLUMN "public"."t_notice"."tzdzt" IS '通知单状态(1:新通知单,2:已确认)';
COMMENT ON COLUMN "public"."t_notice"."tzdbh" IS '通知单编号';
COMMENT ON COLUMN "public"."t_notice"."zy" IS '摘要';
COMMENT ON COLUMN "public"."t_notice"."jyje" IS '交易金额';
COMMENT ON COLUMN "public"."t_notice"."fssj" IS '通知单发送日期';
COMMENT ON COLUMN "public"."t_notice"."yhqrsj" IS '银行确认时间';
COMMENT ON COLUMN "public"."t_notice"."zbyh" IS '主办银行';
COMMENT ON COLUMN "public"."t_notice"."yhzh" IS '银行账户';
COMMENT ON COLUMN "public"."t_notice"."pjbh" IS '票据编号';
COMMENT ON COLUMN "public"."t_notice"."ppzt" IS '匹配状态(标记新通知单已经匹配：1:未匹配，2：已匹配)';
COMMENT ON TABLE "public"."t_notice" IS '业务通知单';

-- ----------------------------
-- Table structure for t_profit_payment
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_profit_payment";
CREATE TABLE "public"."t_profit_payment" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(20) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "wyqydz" varchar(200) COLLATE "pg_catalog"."default",
  "jkje" numeric(18,2),
  "sylx" varchar(20) COLLATE "pg_catalog"."default",
  "jkyh" varchar(50) COLLATE "pg_catalog"."default",
  "jkyhzhmc" varchar(200) COLLATE "pg_catalog"."default",
  "jkyhzh" varchar(64) COLLATE "pg_catalog"."default",
  "yhlsh" varchar(20) COLLATE "pg_catalog"."default",
  "jksj" timestamp(6),
  "jkfs" varchar(20) COLLATE "pg_catalog"."default",
  "ywhjgmc" varchar(100) COLLATE "pg_catalog"."default",
  "ywhrqqssj" timestamp(6),
  "ywhrqjssj" timestamp(6),
  "zrwyxm" varchar(60) COLLATE "pg_catalog"."default",
  "ywhjs" varchar(20) COLLATE "pg_catalog"."default",
  "ywbh" varchar(32) COLLATE "pg_catalog"."default",
  "wyjgmc" varchar(200) COLLATE "pg_catalog"."default",
  "wyshxydm" varchar(18) COLLATE "pg_catalog"."default",
  "wyshxydmyxq" varchar(20) COLLATE "pg_catalog"."default",
  "wylxr" varchar(20) COLLATE "pg_catalog"."default",
  "wylxdh" varchar(20) COLLATE "pg_catalog"."default",
  "xzqhdm" varchar(12) COLLATE "pg_catalog"."default",
  "ywhlxr" varchar(20) COLLATE "pg_catalog"."default",
  "ywhlxdh" varchar(20) COLLATE "pg_catalog"."default",
  "skyh" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzhmc" varchar(100) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(64) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_profit_payment"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_profit_payment"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_profit_payment"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_profit_payment"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_profit_payment"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_profit_payment"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_profit_payment"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_profit_payment"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_profit_payment"."wyqydz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_profit_payment"."jkje" IS '交款金额（综合收益';
COMMENT ON COLUMN "public"."t_profit_payment"."sylx" IS '收益类型';
COMMENT ON COLUMN "public"."t_profit_payment"."jkyh" IS '交款银行';
COMMENT ON COLUMN "public"."t_profit_payment"."jkyhzhmc" IS '交款银行账号名称';
COMMENT ON COLUMN "public"."t_profit_payment"."jkyhzh" IS '交款银行账号';
COMMENT ON COLUMN "public"."t_profit_payment"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."t_profit_payment"."jksj" IS '交款时间';
COMMENT ON COLUMN "public"."t_profit_payment"."jkfs" IS '交款方式(1.现金,2.支票,3.托收,4.网银,5.其他)';
COMMENT ON COLUMN "public"."t_profit_payment"."ywhjgmc" IS '业主机构名称';
COMMENT ON COLUMN "public"."t_profit_payment"."ywhrqqssj" IS '业主委员回任期开始时间';
COMMENT ON COLUMN "public"."t_profit_payment"."ywhrqjssj" IS '业主委员回任期结束时间';
COMMENT ON COLUMN "public"."t_profit_payment"."zrwyxm" IS '主任委员姓名';
COMMENT ON COLUMN "public"."t_profit_payment"."ywhjs" IS '业委会届数';
COMMENT ON COLUMN "public"."t_profit_payment"."ywbh" IS '业务编号，业务系统唯一标识';
COMMENT ON COLUMN "public"."t_profit_payment"."wyjgmc" IS '物业机构名称';
COMMENT ON COLUMN "public"."t_profit_payment"."wyshxydm" IS '物业统一社会信用代码';
COMMENT ON COLUMN "public"."t_profit_payment"."wyshxydmyxq" IS '物业社会信用代码有效期';
COMMENT ON COLUMN "public"."t_profit_payment"."wylxr" IS '物业联系人';
COMMENT ON COLUMN "public"."t_profit_payment"."wylxdh" IS '物业联系人电话';
COMMENT ON COLUMN "public"."t_profit_payment"."xzqhdm" IS '行政区划代码';
COMMENT ON COLUMN "public"."t_profit_payment"."ywhlxr" IS '业务会联系人';
COMMENT ON COLUMN "public"."t_profit_payment"."ywhlxdh" IS '业务会联系电话';
COMMENT ON COLUMN "public"."t_profit_payment"."skyh" IS '收款银行';
COMMENT ON COLUMN "public"."t_profit_payment"."skyhzhmc" IS '收款银行账号名称';
COMMENT ON COLUMN "public"."t_profit_payment"."skyhzh" IS '收款银行账号';
COMMENT ON TABLE "public"."t_profit_payment" IS '收益交款信息';

-- ----------------------------
-- Table structure for t_rate
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_rate";
CREATE TABLE "public"."t_rate" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "lxlx" int2,
  "yhzhlx" varchar(60) COLLATE "pg_catalog"."default",
  "yhzhmc" varchar(60) COLLATE "pg_catalog"."default",
  "zhkhhmc" varchar(100) COLLATE "pg_catalog"."default",
  "yhzh" varchar(30) COLLATE "pg_catalog"."default",
  "jcll" numeric(10,2),
  "sfll" numeric(10,2),
  "qs" int2,
  "zxzqjsrq" timestamp(6),
  "zxll" numeric(10,2),
  "lxsl" numeric(10,2),
  "btbs" int2,
  "zt" int2 DEFAULT 0,
  "account_id" int8,
  "zxksrq" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_rate"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_rate"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_rate"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_rate"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_rate"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_rate"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_rate"."lxlx" IS '利息类型(活期,定期)';
COMMENT ON COLUMN "public"."t_rate"."yhzhlx" IS '账户类型';
COMMENT ON COLUMN "public"."t_rate"."yhzhmc" IS '银行账户名称';
COMMENT ON COLUMN "public"."t_rate"."zhkhhmc" IS '账户开户行名称';
COMMENT ON COLUMN "public"."t_rate"."yhzh" IS '银行账号';
COMMENT ON COLUMN "public"."t_rate"."jcll" IS '基准利率';
COMMENT ON COLUMN "public"."t_rate"."sfll" IS '上浮利率';
COMMENT ON COLUMN "public"."t_rate"."qs" IS '期数';
COMMENT ON COLUMN "public"."t_rate"."zxzqjsrq" IS '执行周期结束日期';
COMMENT ON COLUMN "public"."t_rate"."zxll" IS '执行利率';
COMMENT ON COLUMN "public"."t_rate"."lxsl" IS '利息税率';
COMMENT ON COLUMN "public"."t_rate"."btbs" IS '本他行标识';
COMMENT ON COLUMN "public"."t_rate"."zt" IS '状态';
COMMENT ON COLUMN "public"."t_rate"."account_id" IS '账户Id';
COMMENT ON COLUMN "public"."t_rate"."zxksrq" IS '执行周期开始时间';
COMMENT ON TABLE "public"."t_rate" IS '利息维护';

-- ----------------------------
-- Table structure for t_repair_capital
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_repair_capital";
CREATE TABLE "public"."t_repair_capital" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(20) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "xxdz" varchar(200) COLLATE "pg_catalog"."default",
  "wyjgmc" varchar(100) COLLATE "pg_catalog"."default",
  "wyshxydm" varchar(18) COLLATE "pg_catalog"."default",
  "wyshxydmyxq" timestamp(6),
  "wylxr" varchar(20) COLLATE "pg_catalog"."default",
  "wylxdh" varchar(20) COLLATE "pg_catalog"."default",
  "ywhjgmc" varchar(100) COLLATE "pg_catalog"."default",
  "ywhrqqssj" timestamp(6),
  "ywhrqjssj" timestamp(6),
  "zrwyxm" varchar(20) COLLATE "pg_catalog"."default",
  "ywhlxr" varchar(20) COLLATE "pg_catalog"."default",
  "ywhlxdh" varchar(20) COLLATE "pg_catalog"."default",
  "wxfa" varchar(255) COLLATE "pg_catalog"."default",
  "sssbdm" varchar(2000) COLLATE "pg_catalog"."default",
  "zjzmj" numeric(10,2),
  "zyzs" int4,
  "xmgldw" json,
  "ysje" numeric(10,2),
  "zkje" numeric(10,2),
  "ftje" numeric(10,2),
  "zkyh" varchar(20) COLLATE "pg_catalog"."default",
  "zkyhzhmc" varchar(100) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(64) COLLATE "pg_catalog"."default",
  "zksj" timestamp(6),
  "yhlsh" varchar(64) COLLATE "pg_catalog"."default",
  "skyhzhmc" varchar(20) COLLATE "pg_catalog"."default",
  "skyh" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(64) COLLATE "pg_catalog"."default",
  "zcjmj" numeric(10,2),
  "zcjyzs" int4,
  "tpjg" bool,
  "ysftje" numeric(10,2),
  "bffs" varchar(16) COLLATE "pg_catalog"."default",
  "fpbh" varchar(30) COLLATE "pg_catalog"."default",
  "mhftje" numeric(10,2),
  "ywbh" varchar(32) COLLATE "pg_catalog"."default",
  "xzqhdm" varchar(12) COLLATE "pg_catalog"."default",
  "wyqydz" varchar(200) COLLATE "pg_catalog"."default",
  "ywhjs" varchar(10) COLLATE "pg_catalog"."default",
  "fhxx" json,
  "sbsj" timestamp(6),
  "sfjjwx" bool,
  "smdm" varchar(20) COLLATE "pg_catalog"."default",
  "bjtyjzmj" numeric(10,2),
  "bjtyzyzs" int4,
  "wxkm" varchar(200) COLLATE "pg_catalog"."default",
  "xmmc" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_repair_capital"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_repair_capital"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_repair_capital"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_repair_capital"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_repair_capital"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_repair_capital"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_repair_capital"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_repair_capital"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_repair_capital"."xxdz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_repair_capital"."wyjgmc" IS '物业机构名称';
COMMENT ON COLUMN "public"."t_repair_capital"."wyshxydm" IS '物业统一社会信用代码';
COMMENT ON COLUMN "public"."t_repair_capital"."wyshxydmyxq" IS '物业信用代码有效期';
COMMENT ON COLUMN "public"."t_repair_capital"."wylxr" IS '物业联系人';
COMMENT ON COLUMN "public"."t_repair_capital"."wylxdh" IS '物业联系人电话';
COMMENT ON COLUMN "public"."t_repair_capital"."ywhjgmc" IS '业委会机构名称';
COMMENT ON COLUMN "public"."t_repair_capital"."ywhrqqssj" IS '业委会任期起始时间';
COMMENT ON COLUMN "public"."t_repair_capital"."ywhrqjssj" IS '业委会任期结束时间';
COMMENT ON COLUMN "public"."t_repair_capital"."zrwyxm" IS '业委会主任姓名';
COMMENT ON COLUMN "public"."t_repair_capital"."ywhlxr" IS '业委会联系人';
COMMENT ON COLUMN "public"."t_repair_capital"."ywhlxdh" IS '业委会联系电话';
COMMENT ON COLUMN "public"."t_repair_capital"."wxfa" IS '维修方案';
COMMENT ON COLUMN "public"."t_repair_capital"."sssbdm" IS '设施设备代码';
COMMENT ON COLUMN "public"."t_repair_capital"."zjzmj" IS '总建筑面积';
COMMENT ON COLUMN "public"."t_repair_capital"."zyzs" IS '总业主数';
COMMENT ON COLUMN "public"."t_repair_capital"."xmgldw" IS '项目关联机构';
COMMENT ON COLUMN "public"."t_repair_capital"."ysje" IS '预算金额';
COMMENT ON COLUMN "public"."t_repair_capital"."zkje" IS '支款金额';
COMMENT ON COLUMN "public"."t_repair_capital"."ftje" IS '分摊金额';
COMMENT ON COLUMN "public"."t_repair_capital"."zkyh" IS '支款银行';
COMMENT ON COLUMN "public"."t_repair_capital"."zkyhzhmc" IS '支款银行账号名称';
COMMENT ON COLUMN "public"."t_repair_capital"."zkyhzh" IS '支款银行账号';
COMMENT ON COLUMN "public"."t_repair_capital"."zksj" IS '支款时间';
COMMENT ON COLUMN "public"."t_repair_capital"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."t_repair_capital"."skyhzhmc" IS '收款银行账户名称';
COMMENT ON COLUMN "public"."t_repair_capital"."skyh" IS '收款银行名称';
COMMENT ON COLUMN "public"."t_repair_capital"."skyhzh" IS '收款账户账号';
COMMENT ON COLUMN "public"."t_repair_capital"."zcjmj" IS '总参加面积';
COMMENT ON COLUMN "public"."t_repair_capital"."zcjyzs" IS '总参加业主数';
COMMENT ON COLUMN "public"."t_repair_capital"."tpjg" IS '投票结果(Y表示通过,N表示未通过)';
COMMENT ON COLUMN "public"."t_repair_capital"."ysftje" IS '预算分摊金额';
COMMENT ON COLUMN "public"."t_repair_capital"."bffs" IS '拨付方式(1.支票,2.网银,3.其他)';
COMMENT ON COLUMN "public"."t_repair_capital"."fpbh" IS '放票编号';
COMMENT ON COLUMN "public"."t_repair_capital"."mhftje" IS '每户分摊金额';
COMMENT ON COLUMN "public"."t_repair_capital"."ywbh" IS '业务编号，业务系统唯一';
COMMENT ON COLUMN "public"."t_repair_capital"."xzqhdm" IS '行政区划代码';
COMMENT ON COLUMN "public"."t_repair_capital"."wyqydz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_repair_capital"."ywhjs" IS '业委会届数';
COMMENT ON COLUMN "public"."t_repair_capital"."fhxx" IS '分户数据';
COMMENT ON COLUMN "public"."t_repair_capital"."sbsj" IS '申报时间';
COMMENT ON COLUMN "public"."t_repair_capital"."sfjjwx" IS '项目是否紧急维修';
COMMENT ON COLUMN "public"."t_repair_capital"."smdm" IS '项目代码';
COMMENT ON COLUMN "public"."t_repair_capital"."bjtyjzmj" IS '表决同意建筑面积';
COMMENT ON COLUMN "public"."t_repair_capital"."bjtyzyzs" IS '表决同意业主数';
COMMENT ON COLUMN "public"."t_repair_capital"."wxkm" IS '维修科目';
COMMENT ON COLUMN "public"."t_repair_capital"."xmmc" IS '维修项目名称';
COMMENT ON TABLE "public"."t_repair_capital" IS '维修资金使用信息';

-- ----------------------------
-- Table structure for t_revolving_fund
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_revolving_fund";
CREATE TABLE "public"."t_revolving_fund" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "kssj" timestamp(6),
  "jssj" timestamp(6),
  "sjjx" numeric(10,2),
  "sjjzll" numeric(10,2),
  "sjll" numeric(10,2),
  "js" numeric(10,2),
  "ljjs" numeric(10,2),
  "jsrq" timestamp(6)
)
;
COMMENT ON COLUMN "public"."t_revolving_fund"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_revolving_fund"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_revolving_fund"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_revolving_fund"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_revolving_fund"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_revolving_fund"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_revolving_fund"."kssj" IS '开始时间';
COMMENT ON COLUMN "public"."t_revolving_fund"."jssj" IS '结束时间';
COMMENT ON COLUMN "public"."t_revolving_fund"."sjjx" IS '实际结息';
COMMENT ON COLUMN "public"."t_revolving_fund"."sjjzll" IS '实际基准利率';
COMMENT ON COLUMN "public"."t_revolving_fund"."sjll" IS '实际利率';
COMMENT ON COLUMN "public"."t_revolving_fund"."js" IS '积数';
COMMENT ON COLUMN "public"."t_revolving_fund"."ljjs" IS '累计积数';
COMMENT ON COLUMN "public"."t_revolving_fund"."jsrq" IS '积数日期';
COMMENT ON TABLE "public"."t_revolving_fund" IS '备用金年底交存';

-- ----------------------------
-- Table structure for t_rule
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_rule";
CREATE TABLE "public"."t_rule" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "gzmc" varchar(200) COLLATE "pg_catalog"."default",
  "cftj" json,
  "gzlx" int2,
  "zhyhzh" varchar(20) COLLATE "pg_catalog"."default",
  "tzdx" json,
  "zt" bool
)
;
COMMENT ON COLUMN "public"."t_rule"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_rule"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_rule"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_rule"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_rule"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_rule"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_rule"."gzmc" IS '规则名称';
COMMENT ON COLUMN "public"."t_rule"."cftj" IS '触发条件';
COMMENT ON COLUMN "public"."t_rule"."gzlx" IS '规则类型(1.增值计划到期提醒规则,2.年底利息缴存提醒规则,3.增值划转提醒规则,4.分户账户余额不足提醒规则)';
COMMENT ON COLUMN "public"."t_rule"."zhyhzh" IS '专户银行账号(外键)';
COMMENT ON COLUMN "public"."t_rule"."tzdx" IS '通知对象';
COMMENT ON COLUMN "public"."t_rule"."zt" IS '状态(true:启动,false:关闭)';
COMMENT ON TABLE "public"."t_rule" IS '规则管理';

-- ----------------------------
-- Table structure for t_settlement_interest
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_settlement_interest";
CREATE TABLE "public"."t_settlement_interest" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "kssj" timestamp(6),
  "jssj" timestamp(6),
  "jyrq" timestamp(6),
  "zh" varchar(20) COLLATE "pg_catalog"."default",
  "lv" numeric(16,6),
  "lvbhksrq" timestamp(6),
  "lvbhjsrq" timestamp(6),
  "js" numeric(17),
  "ljjs" numeric(17),
  "jsrq" timestamp(6),
  "xdlcje" numeric(17),
  "xdlv" numeric(16,6),
  "xdjs" varchar(17) COLLATE "pg_catalog"."default",
  "interest" numeric(17,4)
)
;
COMMENT ON COLUMN "public"."t_settlement_interest"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_settlement_interest"."kssj" IS '开始日期： 当季度结息开始时间';
COMMENT ON COLUMN "public"."t_settlement_interest"."jssj" IS '结束时间';
COMMENT ON COLUMN "public"."t_settlement_interest"."jyrq" IS '交易日期';
COMMENT ON COLUMN "public"."t_settlement_interest"."zh" IS '账号';
COMMENT ON COLUMN "public"."t_settlement_interest"."lv" IS '利率  带6位小数';
COMMENT ON COLUMN "public"."t_settlement_interest"."lvbhksrq" IS '利率变化开始日期: 如果在结息周期内利率变化，则为结息周期的开始日期';
COMMENT ON COLUMN "public"."t_settlement_interest"."lvbhjsrq" IS '利率变化结束日期: 如果在结息周期内利率变化，则为结息周期的结束日期';
COMMENT ON COLUMN "public"."t_settlement_interest"."js" IS '积数  单位：分';
COMMENT ON COLUMN "public"."t_settlement_interest"."ljjs" IS '累计积数  单位：分     
到查询当天的累计计息余额';
COMMENT ON COLUMN "public"."t_settlement_interest"."jsrq" IS '积数日期：当前未结息的利息积数的开始日期';
COMMENT ON COLUMN "public"."t_settlement_interest"."xdlcje" IS '协定留存金额 单位：分';
COMMENT ON COLUMN "public"."t_settlement_interest"."xdlv" IS '协定实际利率  带6位小数';
COMMENT ON COLUMN "public"."t_settlement_interest"."xdjs" IS '超过协定留存金额部分的积数  单位：分';
COMMENT ON COLUMN "public"."t_settlement_interest"."interest" IS '利息  单位：分';
COMMENT ON TABLE "public"."t_settlement_interest" IS '归集户结息数据表';

-- ----------------------------
-- Table structure for t_shutcut_menu
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_shutcut_menu";
CREATE TABLE "public"."t_shutcut_menu" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "create_by" varchar(20) COLLATE "pg_catalog"."default",
  "update_time" timestamp(6),
  "update_by" varchar(20) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "dept_id" int8,
  "user_id" int8,
  "menu_id" int8,
  "icon" varchar(255) COLLATE "pg_catalog"."default",
  "type" varchar(2) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_shutcut_menu"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_shutcut_menu"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_shutcut_menu"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_shutcut_menu"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_shutcut_menu"."del_flag" IS '逻辑删除标记';
COMMENT ON COLUMN "public"."t_shutcut_menu"."dept_id" IS '部门id';
COMMENT ON COLUMN "public"."t_shutcut_menu"."user_id" IS '用户id';
COMMENT ON COLUMN "public"."t_shutcut_menu"."menu_id" IS '菜单id';
COMMENT ON COLUMN "public"."t_shutcut_menu"."icon" IS '快捷菜单图标';
COMMENT ON COLUMN "public"."t_shutcut_menu"."type" IS '类型 1-可选快捷菜单 2-用户快捷菜单';

-- ----------------------------
-- Table structure for t_single_payment
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_single_payment";
CREATE TABLE "public"."t_single_payment" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(50) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "wyqydz" varchar(255) COLLATE "pg_catalog"."default",
  "fhdm" varchar(26) COLLATE "pg_catalog"."default",
  "lzdm" varchar(18) COLLATE "pg_catalog"."default",
  "lzmc" varchar(50) COLLATE "pg_catalog"."default",
  "dymc" varchar(20) COLLATE "pg_catalog"."default",
  "myc" varchar(20) COLLATE "pg_catalog"."default",
  "sjc" int4,
  "sh" varchar(20) COLLATE "pg_catalog"."default",
  "jzmj" numeric(10,2),
  "xxdz" varchar(255) COLLATE "pg_catalog"."default",
  "jkje" numeric(10,2),
  "jfbz" numeric(10,2),
  "jkyh" varchar(120) COLLATE "pg_catalog"."default",
  "jkyhzhmc" varchar(255) COLLATE "pg_catalog"."default",
  "jkyhzh" varchar(64) COLLATE "pg_catalog"."default",
  "jklx" varchar(64) COLLATE "pg_catalog"."default",
  "yhlsh" varchar(64) COLLATE "pg_catalog"."default",
  "jksj" timestamp(6),
  "wyqysylx" varchar(20) COLLATE "pg_catalog"."default",
  "jkfs" varchar(16) COLLATE "pg_catalog"."default",
  "ywbh" varchar(32) COLLATE "pg_catalog"."default" NOT NULL,
  "xzqhdm" varchar(12) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_single_payment"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_single_payment"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_single_payment"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_single_payment"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_single_payment"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_single_payment"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_single_payment"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_single_payment"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_single_payment"."wyqydz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_single_payment"."fhdm" IS '分户代码';
COMMENT ON COLUMN "public"."t_single_payment"."lzdm" IS '楼幢代码';
COMMENT ON COLUMN "public"."t_single_payment"."lzmc" IS '楼幢名称';
COMMENT ON COLUMN "public"."t_single_payment"."dymc" IS '单元名称';
COMMENT ON COLUMN "public"."t_single_payment"."myc" IS '名义楼层';
COMMENT ON COLUMN "public"."t_single_payment"."sjc" IS '实际层';
COMMENT ON COLUMN "public"."t_single_payment"."sh" IS '室号';
COMMENT ON COLUMN "public"."t_single_payment"."jzmj" IS '建筑面积';
COMMENT ON COLUMN "public"."t_single_payment"."xxdz" IS '房屋详细地址';
COMMENT ON COLUMN "public"."t_single_payment"."jkje" IS '交款金额';
COMMENT ON COLUMN "public"."t_single_payment"."jfbz" IS '缴费标准（应交金额）';
COMMENT ON COLUMN "public"."t_single_payment"."jkyh" IS '交款银行名称';
COMMENT ON COLUMN "public"."t_single_payment"."jkyhzhmc" IS '银行账号名称';
COMMENT ON COLUMN "public"."t_single_payment"."jkyhzh" IS '银行账号';
COMMENT ON COLUMN "public"."t_single_payment"."jklx" IS '交款类型';
COMMENT ON COLUMN "public"."t_single_payment"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."t_single_payment"."jksj" IS '交款时间YYYYMMDDhhmmss';
COMMENT ON COLUMN "public"."t_single_payment"."wyqysylx" IS '物业区域使用类型(1.商品房,2.公有售房,3.新居工程,4.拆迁安置房,5.单一产权人,6.统规自建房,7.征地拆迁房,8.商业非住宅,9.其他非住宅,10.保障性住房,11.全额集资建房,12.农村集中居住区,13.其他)';
COMMENT ON COLUMN "public"."t_single_payment"."jkfs" IS '交款方式(1.现金,2.支票,3.托收,4.网银,5.其他)';
COMMENT ON COLUMN "public"."t_single_payment"."ywbh" IS '业务编号，业务系统唯一标识';
COMMENT ON COLUMN "public"."t_single_payment"."xzqhdm" IS '所属行政区划代码';
COMMENT ON TABLE "public"."t_single_payment" IS '单笔交款信息';

-- ----------------------------
-- Table structure for t_single_refund
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_single_refund";
CREATE TABLE "public"."t_single_refund" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(20) COLLATE "pg_catalog"."default",
  "wyqymc" varchar(200) COLLATE "pg_catalog"."default",
  "wyqydz" varchar(200) COLLATE "pg_catalog"."default",
  "fhdm" varchar(26) COLLATE "pg_catalog"."default",
  "lzdm" varchar(18) COLLATE "pg_catalog"."default",
  "lzmc" varchar(50) COLLATE "pg_catalog"."default",
  "dymc" varchar(18) COLLATE "pg_catalog"."default",
  "myc" varchar(20) COLLATE "pg_catalog"."default",
  "sjc" int4,
  "sh" varchar(18) COLLATE "pg_catalog"."default",
  "jzmj" numeric(10,2),
  "xxdz" varchar(200) COLLATE "pg_catalog"."default",
  "tkyy" varchar(50) COLLATE "pg_catalog"."default",
  "tkje" numeric(10,2),
  "skyhzhmc" varchar(50) COLLATE "pg_catalog"."default",
  "skyh" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(64) COLLATE "pg_catalog"."default",
  "yhlsh" varchar(64) COLLATE "pg_catalog"."default",
  "zksj" timestamp(6),
  "xzqhdm" varchar(12) COLLATE "pg_catalog"."default",
  "ywbh" varchar(32) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_single_refund"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_single_refund"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_single_refund"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_single_refund"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_single_refund"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_single_refund"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_single_refund"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."t_single_refund"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."t_single_refund"."wyqydz" IS '物业区域地址';
COMMENT ON COLUMN "public"."t_single_refund"."fhdm" IS '分户代码';
COMMENT ON COLUMN "public"."t_single_refund"."lzdm" IS '楼幢代码';
COMMENT ON COLUMN "public"."t_single_refund"."lzmc" IS '楼幢名称';
COMMENT ON COLUMN "public"."t_single_refund"."dymc" IS '单元名称';
COMMENT ON COLUMN "public"."t_single_refund"."myc" IS '名义层';
COMMENT ON COLUMN "public"."t_single_refund"."sjc" IS '实际层';
COMMENT ON COLUMN "public"."t_single_refund"."sh" IS '室号';
COMMENT ON COLUMN "public"."t_single_refund"."jzmj" IS '建筑面积';
COMMENT ON COLUMN "public"."t_single_refund"."xxdz" IS '房屋详细地址';
COMMENT ON COLUMN "public"."t_single_refund"."tkyy" IS '退款原因';
COMMENT ON COLUMN "public"."t_single_refund"."tkje" IS '退款金额';
COMMENT ON COLUMN "public"."t_single_refund"."skyhzhmc" IS '收款账户户名';
COMMENT ON COLUMN "public"."t_single_refund"."skyh" IS '收款账户开户行';
COMMENT ON COLUMN "public"."t_single_refund"."skyhzh" IS '收款账户账号';
COMMENT ON COLUMN "public"."t_single_refund"."yhlsh" IS '流水号';
COMMENT ON COLUMN "public"."t_single_refund"."zksj" IS '支款时间';
COMMENT ON COLUMN "public"."t_single_refund"."xzqhdm" IS '行政区划代码';
COMMENT ON COLUMN "public"."t_single_refund"."ywbh" IS '物业编号，业务系统唯一标识';
COMMENT ON TABLE "public"."t_single_refund" IS '单笔退款信息';

-- ----------------------------
-- Table structure for t_tp
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_tp";
CREATE TABLE "public"."t_tp" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "del_flag" int2 DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar COLLATE "pg_catalog"."default",
  "spbh" varchar(255) COLLATE "pg_catalog"."default",
  "fqsj" timestamp(6),
  "fqr" int8,
  "sxmc" varchar(255) COLLATE "pg_catalog"."default",
  "spzt" int2,
  "sxzw" text COLLATE "pg_catalog"."default",
  "fkyh_id" int8,
  "khzzje" numeric(16,2)
)
;
COMMENT ON COLUMN "public"."t_tp"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_tp"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_tp"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_tp"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_tp"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_tp"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_tp"."spbh" IS '审批编号';
COMMENT ON COLUMN "public"."t_tp"."fqsj" IS '发起时间';
COMMENT ON COLUMN "public"."t_tp"."fqr" IS '发起人';
COMMENT ON COLUMN "public"."t_tp"."sxmc" IS '事项名称';
COMMENT ON COLUMN "public"."t_tp"."spzt" IS '审批状态(0:审批中,1:已通过,-1已撤销,2:已驳回)';
COMMENT ON COLUMN "public"."t_tp"."sxzw" IS '事项正文';
COMMENT ON COLUMN "public"."t_tp"."fkyh_id" IS '付款银行账户id';
COMMENT ON COLUMN "public"."t_tp"."khzzje" IS '可划转总金额（万元）';
COMMENT ON TABLE "public"."t_tp" IS '调配划拨';

-- ----------------------------
-- Table structure for t_tpdoc
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_tpdoc";
CREATE TABLE "public"."t_tpdoc" (
  "id" int8 NOT NULL,
  "tp_id" int8,
  "tplx" int2,
  "skyh_id" int8,
  "tpje" numeric(16,2),
  "ywdh" varchar(50) COLLATE "pg_catalog"."default",
  "yhlsh" varchar(50) COLLATE "pg_catalog"."default",
  "hbsj" timestamp(6),
  "file_url" varchar(255) COLLATE "pg_catalog"."default",
  "file_name" varchar(255) COLLATE "pg_catalog"."default",
  "zt" int2
)
;
COMMENT ON COLUMN "public"."t_tpdoc"."tp_id" IS '调配id';
COMMENT ON COLUMN "public"."t_tpdoc"."tplx" IS '调配类型';
COMMENT ON COLUMN "public"."t_tpdoc"."skyh_id" IS '收款专户银行账户id';
COMMENT ON COLUMN "public"."t_tpdoc"."tpje" IS '调配金额（万元）';
COMMENT ON COLUMN "public"."t_tpdoc"."ywdh" IS '业务单号';
COMMENT ON COLUMN "public"."t_tpdoc"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."t_tpdoc"."hbsj" IS '划拨时间';
COMMENT ON COLUMN "public"."t_tpdoc"."file_url" IS '回执附件';
COMMENT ON COLUMN "public"."t_tpdoc"."file_name" IS '文件名称';
COMMENT ON COLUMN "public"."t_tpdoc"."zt" IS '状态 1-未划拨 2-已划拨';
COMMENT ON TABLE "public"."t_tpdoc" IS '调配划拨';

-- ----------------------------
-- Table structure for t_transfer
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_transfer";
CREATE TABLE "public"."t_transfer" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "spbh" varchar(30) COLLATE "pg_catalog"."default",
  "fqsj" timestamp(6),
  "fqr" varchar(20) COLLATE "pg_catalog"."default",
  "sxmc" varchar(100) COLLATE "pg_catalog"."default",
  "spzt" int2 DEFAULT 0,
  "spyj" varchar(255) COLLATE "pg_catalog"."default",
  "sxzw" text COLLATE "pg_catalog"."default",
  "zje" numeric(10,2),
  "fkzhzh" varchar(255) COLLATE "pg_catalog"."default",
  "fkzhhm" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."t_transfer"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_transfer"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_transfer"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_transfer"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_transfer"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_transfer"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_transfer"."spbh" IS '审批编号';
COMMENT ON COLUMN "public"."t_transfer"."fqsj" IS '发起时间';
COMMENT ON COLUMN "public"."t_transfer"."fqr" IS '发起人';
COMMENT ON COLUMN "public"."t_transfer"."sxmc" IS '事项名称';
COMMENT ON COLUMN "public"."t_transfer"."spzt" IS '审批状态(0:审批中,1:已通过,-1已撤销,2:已驳回)';
COMMENT ON COLUMN "public"."t_transfer"."spyj" IS '审批意见';
COMMENT ON COLUMN "public"."t_transfer"."sxzw" IS '事项正文';
COMMENT ON COLUMN "public"."t_transfer"."zje" IS '划转总金额';
COMMENT ON COLUMN "public"."t_transfer"."fkzhzh" IS '付款账户账号';
COMMENT ON COLUMN "public"."t_transfer"."fkzhhm" IS '付款账户户名';
COMMENT ON TABLE "public"."t_transfer" IS '划拨管理';

-- ----------------------------
-- Table structure for t_transferdoc
-- ----------------------------
DROP TABLE IF EXISTS "public"."t_transferdoc";
CREATE TABLE "public"."t_transferdoc" (
  "id" int8 NOT NULL,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "del_flag" int2 NOT NULL DEFAULT 0,
  "dept_id" int8,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "rate_id" int8,
  "transfer_id" int8,
  "je" numeric(10,2),
  "zdzc" varchar(6) COLLATE "pg_catalog"."default",
  "glfhfs" int2
)
;
COMMENT ON COLUMN "public"."t_transferdoc"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."t_transferdoc"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."t_transferdoc"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."t_transferdoc"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."t_transferdoc"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."t_transferdoc"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."t_transferdoc"."rate_id" IS '利息id';
COMMENT ON COLUMN "public"."t_transferdoc"."transfer_id" IS '划拨Id';
COMMENT ON COLUMN "public"."t_transferdoc"."je" IS '划拨金额';
COMMENT ON COLUMN "public"."t_transferdoc"."zdzc" IS '自动转存';
COMMENT ON COLUMN "public"."t_transferdoc"."glfhfs" IS '关联分户方式 1代管 2银行关联 3自管';
COMMENT ON TABLE "public"."t_transferdoc" IS '划拨正文利息子表';

-- ----------------------------
-- Table structure for tmp_report_data_1
-- ----------------------------
DROP TABLE IF EXISTS "public"."tmp_report_data_1";
CREATE TABLE "public"."tmp_report_data_1" (
  "monty" varchar(255) COLLATE "pg_catalog"."default",
  "main_income" numeric(10,2),
  "total" numeric(10,2),
  "his_lowest" numeric(10,2),
  "his_average" numeric(10,2),
  "his_highest" numeric(10,2)
)
;
COMMENT ON COLUMN "public"."tmp_report_data_1"."monty" IS '月份';

-- ----------------------------
-- Table structure for tmp_report_data_income
-- ----------------------------
DROP TABLE IF EXISTS "public"."tmp_report_data_income";
CREATE TABLE "public"."tmp_report_data_income" (
  "biz_income" varchar(100) COLLATE "pg_catalog"."default",
  "bx_jj_yongjin" numeric(10,2),
  "bx_zx_money" numeric(10,2),
  "chengbao_gz_money" numeric(10,2),
  "bx_gg_moeny" numeric(10,2),
  "tb_zx_money" numeric(10,2),
  "neikong_zx_money" numeric(10,2),
  "total" numeric(10,2)
)
;

-- ----------------------------
-- Table structure for undo_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."undo_log";
CREATE TABLE "public"."undo_log" (
  "branch_id" int8 NOT NULL,
  "xid" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "context" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "rollback_info" bytea NOT NULL,
  "log_status" int4 NOT NULL,
  "log_created" timestamp(6) NOT NULL,
  "log_modified" timestamp(6) NOT NULL,
  "id" int8
)
;
COMMENT ON COLUMN "public"."undo_log"."branch_id" IS 'branch transaction id';
COMMENT ON COLUMN "public"."undo_log"."xid" IS 'global transaction id';
COMMENT ON COLUMN "public"."undo_log"."context" IS 'undo_log context,such as serialization';
COMMENT ON COLUMN "public"."undo_log"."rollback_info" IS 'rollback info';
COMMENT ON COLUMN "public"."undo_log"."log_status" IS '0:normal status,1:defense status';
COMMENT ON COLUMN "public"."undo_log"."log_created" IS 'create datetime';
COMMENT ON COLUMN "public"."undo_log"."log_modified" IS 'modify datetime';
COMMENT ON TABLE "public"."undo_log" IS 'AT transaction mode undo table';

-- ----------------------------
-- Table structure for wxzj_bg_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_bg_log";
CREATE TABLE "public"."wxzj_bg_log" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "bgjl" varchar(255) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_bg_log"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_bg_log"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_bg_log"."bgjl" IS '变更记录';
COMMENT ON COLUMN "public"."wxzj_bg_log"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_bg_log"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_bg_log"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_bg_log"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_bg_log"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_bg_log"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_bg_log"."tenant_id" IS '租户';
COMMENT ON TABLE "public"."wxzj_bg_log" IS '账户变更日志';

-- ----------------------------
-- Table structure for wxzj_clearing_entry
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_clearing_entry";
CREATE TABLE "public"."wxzj_clearing_entry" (
  "id" int8 NOT NULL,
  "urlnumbering" int8,
  "routingAddress" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_clearing_entry"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_clearing_entry"."urlnumbering" IS '路由编号';
COMMENT ON COLUMN "public"."wxzj_clearing_entry"."routingAddress" IS '路由地址';
COMMENT ON TABLE "public"."wxzj_clearing_entry" IS '清算路由地址';

-- ----------------------------
-- Table structure for wxzj_dahsj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dahsj";
CREATE TABLE "public"."wxzj_dahsj" (
  "id" int8 NOT NULL,
  "hdm" varchar(20) COLLATE "pg_catalog"."default",
  "hh" varchar(50) COLLATE "pg_catalog"."default",
  "lxdm" varchar(20) COLLATE "pg_catalog"."default",
  "cjrq" date,
  "gdrq" date,
  "zt" int2,
  "zdkw" varchar(50) COLLATE "pg_catalog"."default",
  "ssqx" varchar(9) COLLATE "pg_catalog"."default",
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "del_flag" int2,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_dahsj"."id" IS '档案盒数据id';
COMMENT ON COLUMN "public"."wxzj_dahsj"."hdm" IS '盒代码';
COMMENT ON COLUMN "public"."wxzj_dahsj"."hh" IS '盒号';
COMMENT ON COLUMN "public"."wxzj_dahsj"."lxdm" IS '类型代码(和“档案类型数据”关联)';
COMMENT ON COLUMN "public"."wxzj_dahsj"."cjrq" IS '创建日期';
COMMENT ON COLUMN "public"."wxzj_dahsj"."gdrq" IS '归档日期';
COMMENT ON COLUMN "public"."wxzj_dahsj"."zt" IS '状态';
COMMENT ON COLUMN "public"."wxzj_dahsj"."zdkw" IS '纸档库位';
COMMENT ON COLUMN "public"."wxzj_dahsj"."ssqx" IS '盒所属的区县(和“行政区划数据关联”)';
COMMENT ON COLUMN "public"."wxzj_dahsj"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_dahsj"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dahsj"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_dahsj"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dahsj"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_dahsj"."del_flag" IS '逻辑删除,0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_dahsj"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_dahsj" IS '档案盒数据应符合表';

-- ----------------------------
-- Table structure for wxzj_dajc
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dajc";
CREATE TABLE "public"."wxzj_dajc" (
  "id" int8 NOT NULL,
  "lsh" varchar(20) COLLATE "pg_catalog"."default",
  "hdm" varchar(20) COLLATE "pg_catalog"."default",
  "jcrq" timestamp(6),
  "ghrq" timestamp(6),
  "sfgh" int2,
  "jydw" varchar(50) COLLATE "pg_catalog"."default",
  "jcyy" varchar(100) COLLATE "pg_catalog"."default",
  "jdry" varchar(50) COLLATE "pg_catalog"."default",
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "del_flag" int2,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_dajc"."id" IS '档案借出表主键id';
COMMENT ON COLUMN "public"."wxzj_dajc"."lsh" IS '流水号';
COMMENT ON COLUMN "public"."wxzj_dajc"."hdm" IS '盒代码';
COMMENT ON COLUMN "public"."wxzj_dajc"."jcrq" IS '借出日期';
COMMENT ON COLUMN "public"."wxzj_dajc"."ghrq" IS '归还日期';
COMMENT ON COLUMN "public"."wxzj_dajc"."sfgh" IS '是否归还';
COMMENT ON COLUMN "public"."wxzj_dajc"."jydw" IS '借阅单位';
COMMENT ON COLUMN "public"."wxzj_dajc"."jcyy" IS '借出原因';
COMMENT ON COLUMN "public"."wxzj_dajc"."jdry" IS '接档人员';
COMMENT ON COLUMN "public"."wxzj_dajc"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_dajc"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dajc"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_dajc"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dajc"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_dajc"."del_flag" IS '逻辑删除，0正常-1删除';
COMMENT ON COLUMN "public"."wxzj_dajc"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_dajc" IS '档案借出表';

-- ----------------------------
-- Table structure for wxzj_dalxsj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dalxsj";
CREATE TABLE "public"."wxzj_dalxsj" (
  "id" int8 NOT NULL,
  "lxdm" varchar(20) COLLATE "pg_catalog"."default",
  "lxmc" varchar(50) COLLATE "pg_catalog"."default",
  "flxdm" varchar(20) COLLATE "pg_catalog"."default",
  "bcnx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "del_flag" int2,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_dalxsj"."id" IS '档案类型主键id';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."lxdm" IS '类型代码';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."lxmc" IS '类型名称';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."flxdm" IS '父类型代码';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."bcnx" IS '保存年限';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."del_flag" IS '逻辑删除,0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_dalxsj"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_dalxsj" IS '档案类型数据';

-- ----------------------------
-- Table structure for wxzj_dawjsj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dawjsj";
CREATE TABLE "public"."wxzj_dawjsj" (
  "id" int8 NOT NULL,
  "wjdm" varchar(20) COLLATE "pg_catalog"."default",
  "hdm" varchar(20) COLLATE "pg_catalog"."default",
  "ajh" varchar(50) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(15) COLLATE "pg_catalog"."default",
  "ljr" varchar(50) COLLATE "pg_catalog"."default",
  "dacssj" timestamp(6),
  "dazys" int2,
  "tpys" int2,
  "gdrq" date,
  "zt" int2,
  "ywdm" varchar(16) COLLATE "pg_catalog"."default",
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "del_flag" int2,
  "xh" varchar(50) COLLATE "pg_catalog"."default",
  "qzh" varchar(50) COLLATE "pg_catalog"."default",
  "zyh" varchar(50) COLLATE "pg_catalog"."default",
  "mlh" varchar(50) COLLATE "pg_catalog"."default",
  "damc" varchar(50) COLLATE "pg_catalog"."default",
  "dabh" varchar(255) COLLATE "pg_catalog"."default",
  "bcqx" int2,
  "wyqy_id" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_dawjsj"."id" IS '档案文件数据主键id';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."wjdm" IS '文件代码';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."hdm" IS '盒代码，和“档案盒数据”关联';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."ajh" IS '案卷号';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."wyqydm" IS '物业区域代码';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."ljr" IS '立卷人';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."dacssj" IS '档案生产时间';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."dazys" IS '档案总页数';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."tpys" IS '图片页数';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."gdrq" IS '归档日期';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."zt" IS '状态';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."ywdm" IS '业务代码';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."del_flag" IS '逻辑删除,0正常-1删除';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."xh" IS '序号';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."qzh" IS '全宗号';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."zyh" IS '张页号';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."mlh" IS '目录号';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."damc" IS '档案名称';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."dabh" IS '档案编号';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."bcqx" IS '保存期限';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."wyqy_id" IS '物业区域主键id';
COMMENT ON COLUMN "public"."wxzj_dawjsj"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_dawjsj" IS '档案文件数据表';

-- ----------------------------
-- Table structure for wxzj_dd
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dd";
CREATE TABLE "public"."wxzj_dd" (
  "id" int8 NOT NULL,
  "tzd_id" int8,
  "ddzt" int2,
  "ddyxq" int4,
  "ddzfsj" timestamp(6),
  "ddgxsj" timestamp(6),
  "ddcssj" timestamp(6),
  "qr_code" varchar(200) COLLATE "pg_catalog"."default",
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_dd"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_dd"."tzd_id" IS '通知单';
COMMENT ON COLUMN "public"."wxzj_dd"."ddzt" IS '订单状态 0-待支付 1-已支付 3-已超时 4-已关闭 5-支付失败';
COMMENT ON COLUMN "public"."wxzj_dd"."ddyxq" IS '订单有效期';
COMMENT ON COLUMN "public"."wxzj_dd"."ddzfsj" IS '订单支付时间';
COMMENT ON COLUMN "public"."wxzj_dd"."ddgxsj" IS '订单关闭时间';
COMMENT ON COLUMN "public"."wxzj_dd"."ddcssj" IS '订单超时时间';
COMMENT ON COLUMN "public"."wxzj_dd"."qr_code" IS '支付二维码';
COMMENT ON COLUMN "public"."wxzj_dd"."qr_order_no" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_dd"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_dd"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_dd"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_dd"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dd"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_dd"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dd"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_dd"."tenant_id" IS '租户';
COMMENT ON TABLE "public"."wxzj_dd" IS '订单信息表';

-- ----------------------------
-- Table structure for wxzj_dp_cxcs
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dp_cxcs";
CREATE TABLE "public"."wxzj_dp_cxcs" (
  "id" int8 NOT NULL,
  "query_num" int8,
  "uptime" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "creat_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "del_flag" int2 DEFAULT 0,
  "data_type" int2 DEFAULT 1
)
;
COMMENT ON COLUMN "public"."wxzj_dp_cxcs"."query_num" IS '维修资金查询次数';
COMMENT ON COLUMN "public"."wxzj_dp_cxcs"."uptime" IS '系统上线时间';
COMMENT ON COLUMN "public"."wxzj_dp_cxcs"."creat_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dp_cxcs"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_dp_cxcs"."del_flag" IS '删除标志：0正常，1删除';
COMMENT ON TABLE "public"."wxzj_dp_cxcs" IS '维修资金查询次数及系统上线时间';

-- ----------------------------
-- Table structure for wxzj_dy
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dy";
CREATE TABLE "public"."wxzj_dy" (
  "id" int8 NOT NULL,
  "dymc" varchar(200) COLLATE "pg_catalog"."default",
  "dydm" varchar(25) COLLATE "pg_catalog"."default",
  "wyfwqdm" varchar(15) COLLATE "pg_catalog"."default",
  "ld_id" int8,
  "fws" int4,
  "zddm" varchar(50) COLLATE "pg_catalog"."default",
  "dtsl" int4,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "dys" int8,
  "bz" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_dy"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_dy"."dymc" IS '单元名称';
COMMENT ON COLUMN "public"."wxzj_dy"."dydm" IS '单元代码 总长度应为20位 楼幢代码为18位，序列代码为2位，在楼幢内根据实际情况和需要，按楼幢范围内顺序的阿拉伯数字进行编码，不足位前面补0';
COMMENT ON COLUMN "public"."wxzj_dy"."wyfwqdm" IS '物业服务区域代码';
COMMENT ON COLUMN "public"."wxzj_dy"."ld_id" IS '楼幢id';
COMMENT ON COLUMN "public"."wxzj_dy"."fws" IS '房屋数';
COMMENT ON COLUMN "public"."wxzj_dy"."zddm" IS '宗地代码';
COMMENT ON COLUMN "public"."wxzj_dy"."dtsl" IS '电梯数量';
COMMENT ON COLUMN "public"."wxzj_dy"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_dy"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_dy"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dy"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_dy"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dy"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_dy"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_dy"."dys" IS '单元数';
COMMENT ON COLUMN "public"."wxzj_dy"."bz" IS '备注';
COMMENT ON TABLE "public"."wxzj_dy" IS '单元表';

-- ----------------------------
-- Table structure for wxzj_dzcy
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dzcy";
CREATE TABLE "public"."wxzj_dzcy" (
  "id" int8 NOT NULL,
  "yhlsh" varchar(50) COLLATE "pg_catalog"."default",
  "cylx" int2,
  "cllx" int2,
  "clcs" int2,
  "dzcwxx" varchar(2000) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "dzywlx" int2,
  "sjly" int2,
  "hdzt" int2 DEFAULT 1,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_dzcy"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_dzcy"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_dzcy"."cylx" IS '差异类型（枚举），0-长款、1-短款、2-金额不一致';
COMMENT ON COLUMN "public"."wxzj_dzcy"."cllx" IS '差异处理类型，0-人工、1-自动';
COMMENT ON COLUMN "public"."wxzj_dzcy"."clcs" IS '差异处理次数';
COMMENT ON COLUMN "public"."wxzj_dzcy"."dzcwxx" IS '对账错误信息（对账时产生的错误）';
COMMENT ON COLUMN "public"."wxzj_dzcy"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dzcy"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_dzcy"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dzcy"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_dzcy"."del_flag" IS '逻辑删除，0-正常、1-删除';
COMMENT ON COLUMN "public"."wxzj_dzcy"."dzywlx" IS '对账业务类型，1-资金交存、2-资金退款、3-资金增值、4-资金使用';
COMMENT ON COLUMN "public"."wxzj_dzcy"."sjly" IS '数据来源，1-业务系统、2-银行账单';
COMMENT ON COLUMN "public"."wxzj_dzcy"."hdzt" IS '核对状态(1-未核对 2-核对未匹配 3-核对已匹配)';
COMMENT ON COLUMN "public"."wxzj_dzcy"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_dzcy" IS '对账差异表';

-- ----------------------------
-- Table structure for wxzj_dzhd_bank
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dzhd_bank";
CREATE TABLE "public"."wxzj_dzhd_bank" (
  "id" int8 NOT NULL,
  "yhzd_id" int8,
  "dzr" date,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_dzhd_bank"."id" IS '银行记账id';
COMMENT ON COLUMN "public"."wxzj_dzhd_bank"."yhzd_id" IS '银行账单id';
COMMENT ON COLUMN "public"."wxzj_dzhd_bank"."dzr" IS '对账日';
COMMENT ON COLUMN "public"."wxzj_dzhd_bank"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dzhd_bank"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_dzhd_bank"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dzhd_bank"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_dzhd_bank"."del_flag" IS '逻辑删除，0—正常、1—删除';
COMMENT ON TABLE "public"."wxzj_dzhd_bank" IS '银行流水每日记账核对记录表';

-- ----------------------------
-- Table structure for wxzj_dzhd_business
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_dzhd_business";
CREATE TABLE "public"."wxzj_dzhd_business" (
  "id" int8 NOT NULL,
  "tzd_id" int8,
  "ywlx" varchar(50) COLLATE "pg_catalog"."default",
  "dzr" date,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."id" IS '业务记账id';
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."tzd_id" IS '业务通知单id';
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."ywlx" IS '业务类型';
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."dzr" IS '对账日';
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_dzhd_business"."del_flag" IS '逻辑删除，0—正常、1—删除';
COMMENT ON TABLE "public"."wxzj_dzhd_business" IS '业务通知单每日记账核对记录表';

-- ----------------------------
-- Table structure for wxzj_fh_ls_01
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_01";
CREATE TABLE "public"."wxzj_fh_ls_01" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_02
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_02";
CREATE TABLE "public"."wxzj_fh_ls_02" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_03
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_03";
CREATE TABLE "public"."wxzj_fh_ls_03" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_04
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_04";
CREATE TABLE "public"."wxzj_fh_ls_04" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_05
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_05";
CREATE TABLE "public"."wxzj_fh_ls_05" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_06
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_06";
CREATE TABLE "public"."wxzj_fh_ls_06" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_07
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_07";
CREATE TABLE "public"."wxzj_fh_ls_07" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_08
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_08";
CREATE TABLE "public"."wxzj_fh_ls_08" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_09
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_09";
CREATE TABLE "public"."wxzj_fh_ls_09" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_10
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_10";
CREATE TABLE "public"."wxzj_fh_ls_10" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_11
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_11";
CREATE TABLE "public"."wxzj_fh_ls_11" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_12
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_12";
CREATE TABLE "public"."wxzj_fh_ls_12" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;

-- ----------------------------
-- Table structure for wxzj_fh_ls_import
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls_import";
CREATE TABLE "public"."wxzj_fh_ls_import" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."fsje" IS '发生金额';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."bgsj" IS '变更时间';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."skr" IS '收款人';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."skyhzh" IS '收款银行账户';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."zkyhzh" IS '支款银行账户';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."bglx" IS '变更类型  1-交存 2-使用 3-增值 4-退款 ';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."fh_id" IS '分户id';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."tzd_id" IS '通知单id';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."fhye" IS '分户余额';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."qr_order_no" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."order_id" IS '订单id';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."batch_no" IS '定向定期批次号';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."month" IS '分表按月份';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."check_booking" IS '是否对账 0-否 1-是';
COMMENT ON COLUMN "public"."wxzj_fh_ls_import"."jctk_id" IS '交存退款业务id';
COMMENT ON TABLE "public"."wxzj_fh_ls_import" IS '分户流水表主表';

-- ----------------------------
-- Table structure for wxzj_fhzh
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh";
CREATE TABLE "public"."wxzj_fhzh" (
  "id" int8 NOT NULL,
  "yz" varchar(50) COLLATE "pg_catalog"."default",
  "zjlx" int2,
  "zjhm" varchar(20) COLLATE "pg_catalog"."default",
  "sjhm" varchar(20) COLLATE "pg_catalog"."default",
  "jczj" numeric(18,2) DEFAULT 0,
  "syzj" numeric(18,2) DEFAULT 0,
  "zhye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "bz" varchar(225) COLLATE "pg_catalog"."default",
  "djje" numeric(18,2) DEFAULT 0,
  "yhzh_id" int8,
  "fhzh" varchar(25) COLLATE "pg_catalog"."default",
  "fw_id" int8,
  "zhzt" int2 DEFAULT 1,
  "jclx" int2,
  "zhyh" varchar(20) COLLATE "pg_catalog"."default",
  "jcje" numeric(18,2) DEFAULT 0,
  "skyh" varchar(50) COLLATE "pg_catalog"."default",
  "skzh" varchar(50) COLLATE "pg_catalog"."default",
  "zzzj" numeric(18,2) DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_fhzh"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_fhzh"."yz" IS '业主';
COMMENT ON COLUMN "public"."wxzj_fhzh"."zjlx" IS '证件类型 111-居民身份证 112 -临时居民身份证  335-机动车驾驶证 336-机动车临时驾驶许可证 414-普通护照 511-台湾居民来往大陆通行证（多次有效） 512-台湾居民来往大陆通行证（一次有效） 516-港澳居民来来往内地通行证 552-台湾居民定居证 553-外国人永久居留证 554-外国人居留证或居留许可 555-外国人临时居留证';
COMMENT ON COLUMN "public"."wxzj_fhzh"."zjhm" IS '证件号码';
COMMENT ON COLUMN "public"."wxzj_fhzh"."sjhm" IS '手机号码';
COMMENT ON COLUMN "public"."wxzj_fhzh"."jczj" IS '交存总计';
COMMENT ON COLUMN "public"."wxzj_fhzh"."syzj" IS '使用总计';
COMMENT ON COLUMN "public"."wxzj_fhzh"."zhye" IS '账户余额';
COMMENT ON COLUMN "public"."wxzj_fhzh"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_fhzh"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_fhzh"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_fhzh"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_fhzh"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_fhzh"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_fhzh"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_fhzh"."djje" IS '冻结金额（使用 定向增值）';
COMMENT ON COLUMN "public"."wxzj_fhzh"."yhzh_id" IS '银行账户id';
COMMENT ON COLUMN "public"."wxzj_fhzh"."fhzh" IS '分户账号';
COMMENT ON COLUMN "public"."wxzj_fhzh"."fw_id" IS '房屋id';
COMMENT ON COLUMN "public"."wxzj_fhzh"."zhzt" IS '账户状态 1-未交 2-正常  3-余额不足';
COMMENT ON COLUMN "public"."wxzj_fhzh"."jclx" IS '交存类型  1-首交  2-补交 3-续交';
COMMENT ON COLUMN "public"."wxzj_fhzh"."zhyh" IS '专户银行（弃用）';
COMMENT ON COLUMN "public"."wxzj_fhzh"."jcje" IS '交存金额（弃用）';
COMMENT ON COLUMN "public"."wxzj_fhzh"."skyh" IS '收款银行（弃用）';
COMMENT ON COLUMN "public"."wxzj_fhzh"."skzh" IS '收款账户（弃用）';
COMMENT ON COLUMN "public"."wxzj_fhzh"."zzzj" IS '增值总计';
COMMENT ON TABLE "public"."wxzj_fhzh" IS '房屋分户账户表';

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_01
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_01";
CREATE TABLE "public"."wxzj_fhzh_ye_01" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_02
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_02";
CREATE TABLE "public"."wxzj_fhzh_ye_02" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_03
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_03";
CREATE TABLE "public"."wxzj_fhzh_ye_03" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_04
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_04";
CREATE TABLE "public"."wxzj_fhzh_ye_04" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_05
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_05";
CREATE TABLE "public"."wxzj_fhzh_ye_05" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_06
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_06";
CREATE TABLE "public"."wxzj_fhzh_ye_06" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_07
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_07";
CREATE TABLE "public"."wxzj_fhzh_ye_07" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_08
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_08";
CREATE TABLE "public"."wxzj_fhzh_ye_08" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_09
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_09";
CREATE TABLE "public"."wxzj_fhzh_ye_09" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_10
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_10";
CREATE TABLE "public"."wxzj_fhzh_ye_10" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_11
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_11";
CREATE TABLE "public"."wxzj_fhzh_ye_11" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_ye_12
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye_12";
CREATE TABLE "public"."wxzj_fhzh_ye_12" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_fhzh_zzdj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_zzdj";
CREATE TABLE "public"."wxzj_fhzh_zzdj" (
  "id" int8 NOT NULL,
  "batch_no" int8,
  "djje" numeric(18,2),
  "fhzh_id" int8,
  "djksrq" date,
  "djjsrq" date,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."batch_no" IS '增值批次号';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."djje" IS '冻结金额';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."fhzh_id" IS '分户账户的id';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."djksrq" IS '冻结开始日期';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."djjsrq" IS '冻结结束日期';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_fhzh_zzdj"."tenant_id" IS '租户';
COMMENT ON TABLE "public"."wxzj_fhzh_zzdj" IS '分户增值冻结表';

-- ----------------------------
-- Table structure for wxzj_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_file";
CREATE TABLE "public"."wxzj_file" (
  "id" int8 NOT NULL,
  "tenant_id" int8,
  "file_name" varchar(100) COLLATE "pg_catalog"."default",
  "file_url" varchar(255) COLLATE "pg_catalog"."default",
  "content_type" varchar(50) COLLATE "pg_catalog"."default",
  "file_size" varchar(50) COLLATE "pg_catalog"."default",
  "business_type" varchar(16) COLLATE "pg_catalog"."default",
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "create_by" varchar(20) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "file_no" varchar COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_file"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_file"."file_name" IS '附件文件名称';
COMMENT ON COLUMN "public"."wxzj_file"."file_url" IS '附件文件地址';
COMMENT ON COLUMN "public"."wxzj_file"."content_type" IS 'mime类型';
COMMENT ON COLUMN "public"."wxzj_file"."file_size" IS '文件大小';
COMMENT ON COLUMN "public"."wxzj_file"."business_type" IS '业务类型 来自于哪种业务的附件';
COMMENT ON COLUMN "public"."wxzj_file"."remark" IS '备注';
COMMENT ON COLUMN "public"."wxzj_file"."file_no" IS '文档编号';
COMMENT ON TABLE "public"."wxzj_file" IS '资金使用附件表';

-- ----------------------------
-- Table structure for wxzj_fw
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fw";
CREATE TABLE "public"."wxzj_fw" (
  "id" int8 NOT NULL,
  "fhdm" varchar(26) COLLATE "pg_catalog"."default",
  "myc" varchar(50) COLLATE "pg_catalog"."default",
  "sjc" varchar(50) COLLATE "pg_catalog"."default",
  "sh" varchar(50) COLLATE "pg_catalog"."default",
  "jzmj" numeric(15,2),
  "fwlx" int2 DEFAULT 0,
  "fwyt" int2,
  "wxzjyjk" numeric(18,2) DEFAULT 0,
  "gfje" numeric(18,2) DEFAULT 0,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "fwmc" varchar(200) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(15) COLLATE "pg_catalog"."default",
  "dy_id" int8,
  "zbxx" varchar(200) COLLATE "pg_catalog"."default",
  "hxjg" int2,
  "xxdz" varchar(200) COLLATE "pg_catalog"."default",
  "fwjzdm" varchar(18) COLLATE "pg_catalog"."default",
  "wqbm" varchar(26) COLLATE "pg_catalog"."default",
  "bdcdybm" varchar(50) COLLATE "pg_catalog"."default",
  "yczjmj" numeric(15,2) DEFAULT 0,
  "yctnjzmj" numeric(15,2) DEFAULT 0,
  "ycftjzmj" numeric(15,2) DEFAULT 0,
  "scjzmj" numeric(15,2) DEFAULT 0,
  "sctnjzmj" numeric(15,2) DEFAULT 0,
  "scftjzmj" numeric(15,2) DEFAULT 0,
  "wyqylx" int2,
  "jcbz" numeric(15,2) DEFAULT 0,
  "jzny" int2,
  "xkny" int2,
  "fwdm" varchar(26) COLLATE "pg_catalog"."default",
  "lzdm" varchar(30) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_fw"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_fw"."fhdm" IS '分户代码 房屋代码26位，物业楼幢代码18位，单元代码默认2位0，序列化代码5位，最后应为校验码';
COMMENT ON COLUMN "public"."wxzj_fw"."myc" IS '名义层';
COMMENT ON COLUMN "public"."wxzj_fw"."sjc" IS '实际层 地面以上从1开始编号，地面以下从-1开始';
COMMENT ON COLUMN "public"."wxzj_fw"."sh" IS '室号';
COMMENT ON COLUMN "public"."wxzj_fw"."jzmj" IS '建筑面积';
COMMENT ON COLUMN "public"."wxzj_fw"."fwlx" IS '房屋类型 0-住宅无电梯 1-住宅有电梯 2-非住宅有电梯 3-非住宅无电梯 ，9其他';
COMMENT ON COLUMN "public"."wxzj_fw"."fwyt" IS '房屋用途 1-住宅
    2-工业、交通、仓储
    3-商业、金融、信息
    4-教育、医疗、卫生、科研
    5-文化、娱乐、体育
    6-办公
    7-军事 
    8-其他';
COMMENT ON COLUMN "public"."wxzj_fw"."wxzjyjk" IS '维修资金应交款';
COMMENT ON COLUMN "public"."wxzj_fw"."gfje" IS '购房金额';
COMMENT ON COLUMN "public"."wxzj_fw"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_fw"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_fw"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_fw"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_fw"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_fw"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_fw"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_fw"."fwmc" IS '房屋名称';
COMMENT ON COLUMN "public"."wxzj_fw"."wyqydm" IS '物业服务区域代码';
COMMENT ON COLUMN "public"."wxzj_fw"."dy_id" IS '单元id';
COMMENT ON COLUMN "public"."wxzj_fw"."zbxx" IS '坐标信息';
COMMENT ON COLUMN "public"."wxzj_fw"."hxjg" IS '户型结构 1-平层  2-错层  3-复式楼  4-跃层  5-其他';
COMMENT ON COLUMN "public"."wxzj_fw"."xxdz" IS '详细地址';
COMMENT ON COLUMN "public"."wxzj_fw"."fwjzdm" IS '房屋建筑代码 (房屋建筑统一编码与基本属性数据标准)';
COMMENT ON COLUMN "public"."wxzj_fw"."wqbm" IS '网签编码 (全国房屋网签备案业务数据标准)';
COMMENT ON COLUMN "public"."wxzj_fw"."bdcdybm" IS '不动产单元代码';
COMMENT ON COLUMN "public"."wxzj_fw"."yczjmj" IS '预测建筑面积';
COMMENT ON COLUMN "public"."wxzj_fw"."yctnjzmj" IS '预测套内建筑面积';
COMMENT ON COLUMN "public"."wxzj_fw"."ycftjzmj" IS '预测分摊建筑面积';
COMMENT ON COLUMN "public"."wxzj_fw"."scjzmj" IS '实测建筑面积';
COMMENT ON COLUMN "public"."wxzj_fw"."sctnjzmj" IS '实测套内建筑面积';
COMMENT ON COLUMN "public"."wxzj_fw"."scftjzmj" IS '实测分摊建筑面积';
COMMENT ON COLUMN "public"."wxzj_fw"."wyqylx" IS '物业区域类型';
COMMENT ON COLUMN "public"."wxzj_fw"."jcbz" IS '交存标准';
COMMENT ON COLUMN "public"."wxzj_fw"."jzny" IS '建筑年月(生成建筑代码的第七位)';
COMMENT ON COLUMN "public"."wxzj_fw"."xkny" IS '许可年月(生成建筑代码的第8到13位)';
COMMENT ON COLUMN "public"."wxzj_fw"."fwdm" IS '房屋代码';
COMMENT ON COLUMN "public"."wxzj_fw"."lzdm" IS '楼幢代码';
COMMENT ON TABLE "public"."wxzj_fw" IS '房屋信息表';

-- ----------------------------
-- Table structure for wxzj_fzhs
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fzhs";
CREATE TABLE "public"."wxzj_fzhs" (
  "id" int8 NOT NULL,
  "fzhszl" varchar(100) COLLATE "pg_catalog"."default",
  "zt" int2 DEFAULT 1,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "cteate_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "tenant_id" int8,
  "lx" int2,
  "ckzlbm" varchar(16) COLLATE "pg_catalog"."default",
  "ckzlmc" int2,
  "ckqx" int2,
  "zdsc" int2 DEFAULT 1,
  "kjzt_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_fzhs"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_fzhs"."fzhszl" IS '辅助核算种类';
COMMENT ON COLUMN "public"."wxzj_fzhs"."zt" IS '状态(0-停用 1-启用)';
COMMENT ON COLUMN "public"."wxzj_fzhs"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_fzhs"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_fzhs"."cteate_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_fzhs"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_fzhs"."del_flag" IS '逻辑删除，0-正常、1-删除';
COMMENT ON COLUMN "public"."wxzj_fzhs"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_fzhs"."lx" IS '辅助核算类型(1-房屋分户，2-存款种类)';
COMMENT ON COLUMN "public"."wxzj_fzhs"."ckzlbm" IS '存款种类编码';
COMMENT ON COLUMN "public"."wxzj_fzhs"."ckzlmc" IS '存款种类名称类型（1-活期存款 2-协定存款 3-通知存款 4-定期存款）';
COMMENT ON COLUMN "public"."wxzj_fzhs"."ckqx" IS '存款期限（1-活期 2-三月期 3-六月期 4-一年期 5-二年期 6-三年期 7-五年期  8-九月期  9-一月期）';
COMMENT ON COLUMN "public"."wxzj_fzhs"."zdsc" IS '自动生成(0-默认类型  1-新增类型)';
COMMENT ON COLUMN "public"."wxzj_fzhs"."kjzt_id" IS '会计账套id';
COMMENT ON TABLE "public"."wxzj_fzhs" IS '辅助核算';

-- ----------------------------
-- Table structure for wxzj_fzhs_kjpz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fzhs_kjpz";
CREATE TABLE "public"."wxzj_fzhs_kjpz" (
  "id" int8 NOT NULL,
  "kjpz_kjkm_id" int8,
  "fh_id" int8,
  "fpje" numeric(15,2),
  "ywlx" int2,
  "batch_no" int8,
  "fzhs_id" int8,
  "jz_batch" int8
)
;
COMMENT ON COLUMN "public"."wxzj_fzhs_kjpz"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_fzhs_kjpz"."kjpz_kjkm_id" IS '分录id';
COMMENT ON COLUMN "public"."wxzj_fzhs_kjpz"."fh_id" IS '分户id';
COMMENT ON COLUMN "public"."wxzj_fzhs_kjpz"."fpje" IS '分配金额';
COMMENT ON COLUMN "public"."wxzj_fzhs_kjpz"."ywlx" IS '业务类型(1-交存 2-使用 3-增值 4-退款 5-划给业委会)';
COMMENT ON COLUMN "public"."wxzj_fzhs_kjpz"."batch_no" IS '批次号';
COMMENT ON COLUMN "public"."wxzj_fzhs_kjpz"."fzhs_id" IS '辅助核算id';
COMMENT ON COLUMN "public"."wxzj_fzhs_kjpz"."jz_batch" IS '期末结转分录id';
COMMENT ON TABLE "public"."wxzj_fzhs_kjpz" IS '分录下辅助核算的分户记录';

-- ----------------------------
-- Table structure for wxzj_gsxx_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_gsxx_file";
CREATE TABLE "public"."wxzj_gsxx_file" (
  "id" int8 NOT NULL,
  "file_id" int8,
  "gsxx_id" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_gsxx_file"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_gsxx_file"."file_id" IS '文件id';
COMMENT ON COLUMN "public"."wxzj_gsxx_file"."gsxx_id" IS '公示信息id';
COMMENT ON COLUMN "public"."wxzj_gsxx_file"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_hqdz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_hqdz";
CREATE TABLE "public"."wxzj_hqdz" (
  "id" int8 NOT NULL,
  "create_time" date,
  "sjjxje" numeric(255),
  "ce" numeric(255),
  "qsjxrq" date,
  "jzjxrq" date,
  "yhzh_id" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_hqdz"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_hqdz"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_hqdz"."sjjxje" IS '实际结息金额';
COMMENT ON COLUMN "public"."wxzj_hqdz"."ce" IS '差额';
COMMENT ON COLUMN "public"."wxzj_hqdz"."qsjxrq" IS '起始结息日期';
COMMENT ON COLUMN "public"."wxzj_hqdz"."jzjxrq" IS '截止结息日期';
COMMENT ON COLUMN "public"."wxzj_hqdz"."yhzh_id" IS '专户银行id';
COMMENT ON COLUMN "public"."wxzj_hqdz"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_information
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_information";
CREATE TABLE "public"."wxzj_information" (
  "id" int8 NOT NULL,
  "jcje" numeric(18,2),
  "jclx" int2,
  "zhyh" varchar(20) COLLATE "pg_catalog"."default",
  "tzdlx" int2,
  "bz" varchar(255) COLLATE "pg_catalog"."default",
  "fhzhid" int8,
  "tkje" numeric(18,2),
  "tkyy" int2,
  "yz" varchar(25) COLLATE "pg_catalog"."default",
  "zjlx" int2,
  "zjhm" varchar(25) COLLATE "pg_catalog"."default",
  "sjhm" varchar(20) COLLATE "pg_catalog"."default",
  "skzhkhh" varchar(50) COLLATE "pg_catalog"."default",
  "skzhzh" varchar(50) COLLATE "pg_catalog"."default",
  "skzhhm" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_information"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_information"."jcje" IS '交存金额';
COMMENT ON COLUMN "public"."wxzj_information"."jclx" IS '交存类型';
COMMENT ON COLUMN "public"."wxzj_information"."zhyh" IS '专户银行';
COMMENT ON COLUMN "public"."wxzj_information"."tzdlx" IS '通知单类型 1-交存 2-退款';
COMMENT ON COLUMN "public"."wxzj_information"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_information"."fhzhid" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_information"."tkje" IS '退款金额';
COMMENT ON COLUMN "public"."wxzj_information"."tkyy" IS '退款原因';
COMMENT ON COLUMN "public"."wxzj_information"."yz" IS '业主';
COMMENT ON COLUMN "public"."wxzj_information"."zjlx" IS '证件类型';
COMMENT ON COLUMN "public"."wxzj_information"."zjhm" IS '证件号码';
COMMENT ON COLUMN "public"."wxzj_information"."sjhm" IS '手机号';
COMMENT ON COLUMN "public"."wxzj_information"."skzhkhh" IS '收款账户开户行';
COMMENT ON COLUMN "public"."wxzj_information"."skzhzh" IS '收款账户账号';
COMMENT ON COLUMN "public"."wxzj_information"."skzhhm" IS '收款账户户名';
COMMENT ON COLUMN "public"."wxzj_information"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_jcls
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_jcls";
CREATE TABLE "public"."wxzj_jcls" (
  "id" int8 NOT NULL,
  "tzd_id" int8,
  "dd_id" varchar(64) COLLATE "pg_catalog"."default",
  "fsje" numeric(18,2),
  "jcyh" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "rzsj" date,
  "qr_order_no" varchar(50) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "batch_no" int8,
  "jcfs" int2,
  "jyqd" int2,
  "jcr" varchar(200) COLLATE "pg_catalog"."default",
  "dzzt" int2 DEFAULT 3,
  "bd" int2,
  "yhmc" varchar(25) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "dept" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_jcls"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_jcls"."tzd_id" IS ' 通知单id';
COMMENT ON COLUMN "public"."wxzj_jcls"."dd_id" IS '订单_id/票据编号';
COMMENT ON COLUMN "public"."wxzj_jcls"."fsje" IS '发生金额';
COMMENT ON COLUMN "public"."wxzj_jcls"."jcyh" IS '交存银行账号';
COMMENT ON COLUMN "public"."wxzj_jcls"."rzsj" IS '交易时间';
COMMENT ON COLUMN "public"."wxzj_jcls"."qr_order_no" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_jcls"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_jcls"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_jcls"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_jcls"."batch_no" IS '批次号';
COMMENT ON COLUMN "public"."wxzj_jcls"."jcfs" IS '交存方式 1-线上  2-线下';
COMMENT ON COLUMN "public"."wxzj_jcls"."jyqd" IS '交易渠道  1-微信 2-支付宝 3-POS机 4-现金 5-转账';
COMMENT ON COLUMN "public"."wxzj_jcls"."jcr" IS '交存人';
COMMENT ON COLUMN "public"."wxzj_jcls"."dzzt" IS '对账状态，1—已对账（对账成功）、2—未对账（对账失败）、3—银行没账单数据';
COMMENT ON COLUMN "public"."wxzj_jcls"."bd" IS '补单1-补单';
COMMENT ON COLUMN "public"."wxzj_jcls"."yhmc" IS '银行名称';
COMMENT ON COLUMN "public"."wxzj_jcls"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_jcls" IS '交存流水表（不使用）';

-- ----------------------------
-- Table structure for wxzj_jcls_batch
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_jcls_batch";
CREATE TABLE "public"."wxzj_jcls_batch" (
  "id" int8 NOT NULL,
  "jcls_id" int8,
  "fhzh_id" int8,
  "fsje" numeric(15,2),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_jcls_batch"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_jcls_batch"."jcls_id" IS '流水id';
COMMENT ON COLUMN "public"."wxzj_jcls_batch"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_jcls_batch"."fsje" IS '发生金额';
COMMENT ON COLUMN "public"."wxzj_jcls_batch"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_jctzd
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_jctzd";
CREATE TABLE "public"."wxzj_jctzd" (
  "id" int8 NOT NULL,
  "zhdbh" varchar(50) COLLATE "pg_catalog"."default",
  "tzdlx" int2,
  "fw_id" int8,
  "jcje" numeric(18,2) DEFAULT 0,
  "yhzh_id" int8,
  "jcfw" varchar(255) COLLATE "pg_catalog"."default",
  "wyqy_id" int8,
  "fwhj" int8 DEFAULT 0,
  "mjhj" numeric(15,2) DEFAULT 0,
  "sjhj" numeric(18,2) DEFAULT 0,
  "tzdzt" int2 DEFAULT 1,
  "jclx" int2,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "bz" varchar(255) COLLATE "pg_catalog"."default",
  "zy" varchar(50) COLLATE "pg_catalog"."default",
  "yhqr_time" date,
  "fhzh_id" int8,
  "del_flag" int2 DEFAULT 0,
  "jyqd" int2 DEFAULT 5,
  "qrCode" varchar(255) COLLATE "pg_catalog"."default",
  "yhzh" varchar(50) COLLATE "pg_catalog"."default",
  "yhlsh" varchar(50) COLLATE "pg_catalog"."default",
  "jkzhzh" varchar(50) COLLATE "pg_catalog"."default",
  "jyrq" timestamp(6),
  "dept" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "overpaid" int2 DEFAULT 0,
  "bj" int2 DEFAULT 0,
  "qt" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_jctzd"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_jctzd"."zhdbh" IS '通知单编号';
COMMENT ON COLUMN "public"."wxzj_jctzd"."tzdlx" IS '通知单类型  1-单户交存  2-批量交存 ';
COMMENT ON COLUMN "public"."wxzj_jctzd"."fw_id" IS '房屋id';
COMMENT ON COLUMN "public"."wxzj_jctzd"."jcje" IS '交存金额';
COMMENT ON COLUMN "public"."wxzj_jctzd"."yhzh_id" IS '银行账户id';
COMMENT ON COLUMN "public"."wxzj_jctzd"."jcfw" IS '交存范围(楼幢id)';
COMMENT ON COLUMN "public"."wxzj_jctzd"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_jctzd"."fwhj" IS '房屋合计';
COMMENT ON COLUMN "public"."wxzj_jctzd"."mjhj" IS '面积合计';
COMMENT ON COLUMN "public"."wxzj_jctzd"."sjhj" IS '实际合交';
COMMENT ON COLUMN "public"."wxzj_jctzd"."tzdzt" IS '通知单状态  1-新增通知单 2-已复核 3-已撤销 4-已打印凭证';
COMMENT ON COLUMN "public"."wxzj_jctzd"."jclx" IS '交存类型  1-首交  2-补交 3-续交';
COMMENT ON COLUMN "public"."wxzj_jctzd"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_jctzd"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_jctzd"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_jctzd"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_jctzd"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_jctzd"."zy" IS '摘要';
COMMENT ON COLUMN "public"."wxzj_jctzd"."yhqr_time" IS '银行确认时间';
COMMENT ON COLUMN "public"."wxzj_jctzd"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_jctzd"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_jctzd"."jyqd" IS '交易渠道 1-微信 2-支付宝 3-POS机 4-现金 5-转账';
COMMENT ON COLUMN "public"."wxzj_jctzd"."qrCode" IS '二维码url';
COMMENT ON COLUMN "public"."wxzj_jctzd"."yhzh" IS '银行账户';
COMMENT ON COLUMN "public"."wxzj_jctzd"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_jctzd"."jkzhzh" IS '交款账户账号';
COMMENT ON COLUMN "public"."wxzj_jctzd"."jyrq" IS '交易日期';
COMMENT ON COLUMN "public"."wxzj_jctzd"."dept" IS '部门';
COMMENT ON COLUMN "public"."wxzj_jctzd"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_jctzd"."overpaid" IS '0-未多交  1-多交';
COMMENT ON COLUMN "public"."wxzj_jctzd"."bj" IS '标记 0-未标记(默认) 1--已标记';
COMMENT ON COLUMN "public"."wxzj_jctzd"."qt" IS '是否全退(0-否 1-是)';
COMMENT ON TABLE "public"."wxzj_jctzd" IS '交存通知单';

-- ----------------------------
-- Table structure for wxzj_jctzd_batch
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_jctzd_batch";
CREATE TABLE "public"."wxzj_jctzd_batch" (
  "id" int8 NOT NULL,
  "jczhd_id" int8,
  "fw_id" int8,
  "yjje" numeric(18,2) DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "bz" varchar(255) COLLATE "pg_catalog"."default",
  "jcje" numeric(18,2) DEFAULT 0,
  "fhzh_id" int8,
  "del_flag" int2 DEFAULT 0,
  "jclx" int2,
  "zhyh" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "dept" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."jczhd_id" IS '交存通知单id';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."fw_id" IS '房屋id';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."yjje" IS '应交金额';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."jcje" IS '交存金额';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."jclx" IS '交存类型';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."zhyh" IS '专户银行';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_jctzd_batch"."dept" IS '部门';
COMMENT ON TABLE "public"."wxzj_jctzd_batch" IS '批量交存通知单子表';

-- ----------------------------
-- Table structure for wxzj_jgxx
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_jgxx";
CREATE TABLE "public"."wxzj_jgxx" (
  "id" int8 NOT NULL,
  "xzqh_id" int8,
  "jgmc" varchar(100) COLLATE "pg_catalog"."default",
  "tyshxydm" varchar(30) COLLATE "pg_catalog"."default",
  "clsj" date,
  "zt" int2 DEFAULT 0,
  "zjzyxq" int2,
  "fddbr" varchar(30) COLLATE "pg_catalog"."default",
  "zjlx" int2,
  "zjhm" varchar(30) COLLATE "pg_catalog"."default",
  "frsjhm" varchar(20) COLLATE "pg_catalog"."default",
  "lxr" varchar(20) COLLATE "pg_catalog"."default",
  "lxdh" varchar(20) COLLATE "pg_catalog"."default",
  "cz" varchar(20) COLLATE "pg_catalog"."default",
  "dzyx" varchar(100) COLLATE "pg_catalog"."default",
  "zcdz" varchar(200) COLLATE "pg_catalog"."default",
  "txdz" varchar(200) COLLATE "pg_catalog"."default",
  "zjxx" varchar(255) COLLATE "pg_catalog"."default",
  "jglx" int2,
  "tjsj" date,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "yhzh_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_jgxx"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_jgxx"."xzqh_id" IS '行政区划id
';
COMMENT ON COLUMN "public"."wxzj_jgxx"."jgmc" IS '机构名称';
COMMENT ON COLUMN "public"."wxzj_jgxx"."tyshxydm" IS '统一社会信用代码';
COMMENT ON COLUMN "public"."wxzj_jgxx"."clsj" IS '成立时间';
COMMENT ON COLUMN "public"."wxzj_jgxx"."zt" IS '状态（0-待审核，1-审核通过，2-审核拒绝）';
COMMENT ON COLUMN "public"."wxzj_jgxx"."zjzyxq" IS '证件照有效期(0-长期，1-短期，2-临时证件)';
COMMENT ON COLUMN "public"."wxzj_jgxx"."fddbr" IS '法定代表人';
COMMENT ON COLUMN "public"."wxzj_jgxx"."zjlx" IS '证件类型 111-居民身份证
112 -临时居民身份证 
335-机动车驾驶证
336-机动车临时驾驶许可证
414-普通护照
511-台湾居民来往大陆通行证（多次有效）
512-台湾居民来往大陆通行证（一次有效）
516-港澳居民来来往内地通行证
552-台湾居民定居证
553-外国人永久居留证
554-外国人居留证或居留许可
555-外国人临时居留证';
COMMENT ON COLUMN "public"."wxzj_jgxx"."zjhm" IS '证件号码';
COMMENT ON COLUMN "public"."wxzj_jgxx"."frsjhm" IS '法人手机号码';
COMMENT ON COLUMN "public"."wxzj_jgxx"."lxr" IS '联系人';
COMMENT ON COLUMN "public"."wxzj_jgxx"."lxdh" IS '联系电话';
COMMENT ON COLUMN "public"."wxzj_jgxx"."cz" IS '传真';
COMMENT ON COLUMN "public"."wxzj_jgxx"."dzyx" IS '电子邮箱';
COMMENT ON COLUMN "public"."wxzj_jgxx"."zcdz" IS '注册地址';
COMMENT ON COLUMN "public"."wxzj_jgxx"."txdz" IS '通讯地址';
COMMENT ON COLUMN "public"."wxzj_jgxx"."zjxx" IS '证件信息';
COMMENT ON COLUMN "public"."wxzj_jgxx"."jglx" IS '机构类型(0-开发建设单位、1-物业服务企业 2-施工单位、3-审价单位、5-街道办(乡镇政府)、6-居委会)';
COMMENT ON COLUMN "public"."wxzj_jgxx"."tjsj" IS '提交时间';
COMMENT ON COLUMN "public"."wxzj_jgxx"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_jgxx"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_jgxx"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_jgxx"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_jgxx"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_jgxx"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_jgxx"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_jgxx"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_jgxx"."yhzh_id" IS '银行账户id';
COMMENT ON TABLE "public"."wxzj_jgxx" IS '机构信息';

-- ----------------------------
-- Table structure for wxzj_jgxx_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_jgxx_file";
CREATE TABLE "public"."wxzj_jgxx_file" (
  "id" int8 NOT NULL,
  "file_id" int8,
  "jgxx_id" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_jgxx_file"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_jgxx_file"."file_id" IS '文件id';
COMMENT ON COLUMN "public"."wxzj_jgxx_file"."jgxx_id" IS '机构信息id';
COMMENT ON COLUMN "public"."wxzj_jgxx_file"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_jgxx_file" IS '机构信息关联文件表';

-- ----------------------------
-- Table structure for wxzj_jgxx_ysb
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_jgxx_ysb";
CREATE TABLE "public"."wxzj_jgxx_ysb" (
  "id" int8 NOT NULL,
  "jg_id" int8,
  "ys_id" int8,
  "type" int2,
  "name" varchar(255) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Table structure for wxzj_jsxm
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_jsxm";
CREATE TABLE "public"."wxzj_jsxm" (
  "id" int8 NOT NULL,
  "wyqy_id" int8,
  "jggl_id" int8,
  "jgrq" date,
  "zjzmj" numeric(15),
  "xpfs" int2,
  "sfwqx" date,
  "efwqx" date,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "xmmc" varchar(255) COLLATE "pg_catalog"."default",
  "xmbh" varchar(30) COLLATE "pg_catalog"."default",
  "ghxkzny" timestamp(6),
  "sgxkzny" timestamp(6),
  "zddm" varchar(20) COLLATE "pg_catalog"."default",
  "fwnr" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_jsxm"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_jsxm"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_jsxm"."jggl_id" IS '机构管理id';
COMMENT ON COLUMN "public"."wxzj_jsxm"."jgrq" IS '竣工日期';
COMMENT ON COLUMN "public"."wxzj_jsxm"."zjzmj" IS '总建筑面积';
COMMENT ON COLUMN "public"."wxzj_jsxm"."xpfs" IS '选聘方式（1.公开招投标 2.邀请招标 3.协议选定）';
COMMENT ON COLUMN "public"."wxzj_jsxm"."sfwqx" IS '服务期限（起）';
COMMENT ON COLUMN "public"."wxzj_jsxm"."efwqx" IS '服务期限（止）';
COMMENT ON COLUMN "public"."wxzj_jsxm"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_jsxm"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_jsxm"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_jsxm"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_jsxm"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_jsxm"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_jsxm"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_jsxm"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_jsxm"."xmmc" IS '项目名称';
COMMENT ON COLUMN "public"."wxzj_jsxm"."xmbh" IS '项目编号';
COMMENT ON COLUMN "public"."wxzj_jsxm"."ghxkzny" IS '规划许可证年月';
COMMENT ON COLUMN "public"."wxzj_jsxm"."sgxkzny" IS '施工许可证年月';
COMMENT ON COLUMN "public"."wxzj_jsxm"."zddm" IS '宗地代码';
COMMENT ON COLUMN "public"."wxzj_jsxm"."fwnr" IS '服务内容';
COMMENT ON TABLE "public"."wxzj_jsxm" IS '建设项目表';

-- ----------------------------
-- Table structure for wxzj_kjkm
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjkm";
CREATE TABLE "public"."wxzj_kjkm" (
  "id" int8 NOT NULL,
  "kmdm" varchar(30) COLLATE "pg_catalog"."default",
  "kmmc" varchar(100) COLLATE "pg_catalog"."default",
  "kmjc" varchar(30) COLLATE "pg_catalog"."default",
  "kmlx" int2,
  "fzhs_id" int8 DEFAULT 0,
  "yefx" int2,
  "pid" int8 DEFAULT 0,
  "zt" int2,
  "qcye" numeric(15,2) DEFAULT 0,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "kjzt_id" int8,
  "zhyh_id" int8,
  "jckm" int2 DEFAULT 1,
  "zdkm" int2 DEFAULT 1,
  "gdqc" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_kjkm"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_kjkm"."kmdm" IS '科目代码';
COMMENT ON COLUMN "public"."wxzj_kjkm"."kmmc" IS '科目名称';
COMMENT ON COLUMN "public"."wxzj_kjkm"."kmjc" IS '科目级次';
COMMENT ON COLUMN "public"."wxzj_kjkm"."kmlx" IS '科目类型 (1-资产类  2-负债类 3-净资产类 4-收入类 5-支出类)';
COMMENT ON COLUMN "public"."wxzj_kjkm"."fzhs_id" IS '辅助核算';
COMMENT ON COLUMN "public"."wxzj_kjkm"."yefx" IS '余额方向(1-借方   2-贷方)';
COMMENT ON COLUMN "public"."wxzj_kjkm"."pid" IS '父级id';
COMMENT ON COLUMN "public"."wxzj_kjkm"."zt" IS '状态 (0-启用  1-禁用)';
COMMENT ON COLUMN "public"."wxzj_kjkm"."qcye" IS '期初余额';
COMMENT ON COLUMN "public"."wxzj_kjkm"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_kjkm"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_kjkm"."del_flag" IS '逻辑删除(0-正常 1-删除)';
COMMENT ON COLUMN "public"."wxzj_kjkm"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_kjkm"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_kjkm"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_kjkm"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_kjkm"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_kjkm"."kjzt_id" IS '会计账套id';
COMMENT ON COLUMN "public"."wxzj_kjkm"."zhyh_id" IS '专户银行id';
COMMENT ON COLUMN "public"."wxzj_kjkm"."jckm" IS '基础科目(0-是 1- 否 )';
COMMENT ON COLUMN "public"."wxzj_kjkm"."zdkm" IS '自动生成的科目(0-自动生成 1-手动添加)';
COMMENT ON COLUMN "public"."wxzj_kjkm"."gdqc" IS '固定期初';
COMMENT ON TABLE "public"."wxzj_kjkm" IS '维修资金会计科目表';

-- ----------------------------
-- Table structure for wxzj_kjkm_fzhs
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjkm_fzhs";
CREATE TABLE "public"."wxzj_kjkm_fzhs" (
  "id" int8 NOT NULL,
  "kjkm_id" int8,
  "lx" int8
)
;
COMMENT ON COLUMN "public"."wxzj_kjkm_fzhs"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_kjkm_fzhs"."kjkm_id" IS '会计科目id';
COMMENT ON COLUMN "public"."wxzj_kjkm_fzhs"."lx" IS '辅助核算类型';

-- ----------------------------
-- Table structure for wxzj_kjkm_je
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjkm_je";
CREATE TABLE "public"."wxzj_kjkm_je" (
  "id" int8 NOT NULL,
  "jfqcye" numeric(15,2) DEFAULT 0,
  "jfbylj" numeric(15,2) DEFAULT 0,
  "jfbnlj" numeric(15,2) DEFAULT 0,
  "kjkm_id" int8,
  "kjqj" date,
  "dfqcye" numeric(15,2) DEFAULT 0,
  "dfbylj" numeric(15,2) DEFAULT 0,
  "dfbnlj" numeric(15,2) DEFAULT 0,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "ye" numeric(255)
)
;
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."jfqcye" IS '借方期初余额';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."jfbylj" IS '借方本月累计';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."jfbnlj" IS '借方本年累计(弃用)';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."kjkm_id" IS '会计科目id';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."kjqj" IS '会计期间';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."dfqcye" IS '贷方期初余额';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."dfbylj" IS '贷方本月累计';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."dfbnlj" IS '贷方本年累计(弃用)';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_kjkm_je"."ye" IS '余额';
COMMENT ON TABLE "public"."wxzj_kjkm_je" IS '维修资金会计科目金额表';

-- ----------------------------
-- Table structure for wxzj_kjkm_jz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjkm_jz";
CREATE TABLE "public"."wxzj_kjkm_jz" (
  "id" int8 NOT NULL,
  "jzmc" varchar(255) COLLATE "pg_catalog"."default",
  "kjzt_id" int8,
  "kjqj" date
)
;
COMMENT ON COLUMN "public"."wxzj_kjkm_jz"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_kjkm_jz"."jzmc" IS '结账名称';
COMMENT ON COLUMN "public"."wxzj_kjkm_jz"."kjzt_id" IS '会计账套id';
COMMENT ON COLUMN "public"."wxzj_kjkm_jz"."kjqj" IS '会计期间';
COMMENT ON TABLE "public"."wxzj_kjkm_jz" IS '维修资金会计科目结账';

-- ----------------------------
-- Table structure for wxzj_kjkm_qmjz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjkm_qmjz";
CREATE TABLE "public"."wxzj_kjkm_qmjz" (
  "id" int8 NOT NULL,
  "kjkm_id" int8,
  "kjqj" date,
  "jzje" numeric(16,2),
  "kjpz_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_kjkm_qmjz"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_kjkm_qmjz"."kjkm_id" IS '会计科目id';
COMMENT ON COLUMN "public"."wxzj_kjkm_qmjz"."kjqj" IS '会计期间';
COMMENT ON COLUMN "public"."wxzj_kjkm_qmjz"."jzje" IS '结转金额';
COMMENT ON COLUMN "public"."wxzj_kjkm_qmjz"."kjpz_id" IS '会计凭证id';
COMMENT ON TABLE "public"."wxzj_kjkm_qmjz" IS '维修资金会计科目期末结转';

-- ----------------------------
-- Table structure for wxzj_kjpz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjpz";
CREATE TABLE "public"."wxzj_kjpz" (
  "id" int8 NOT NULL,
  "pzbh" varchar(50) COLLATE "pg_catalog"."default",
  "pzrq" date,
  "zy" varchar(100) COLLATE "pg_catalog"."default",
  "kjkm_id" int8,
  "jzr" varchar(50) COLLATE "pg_catalog"."default",
  "fhr" varchar(50) COLLATE "pg_catalog"."default",
  "zdr" varchar(50) COLLATE "pg_catalog"."default",
  "jzsj" timestamp(6),
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "cteate_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "jfje" numeric(18,2) DEFAULT 0,
  "dfje" numeric(18,2) DEFAULT 0,
  "shzt" int2 DEFAULT 1,
  "hjje" numeric(18,2) DEFAULT 0,
  "fdsl" int2,
  "mblx" int2,
  "tenant_id" int8,
  "lsh" varchar(30) COLLATE "pg_catalog"."default",
  "pzlx" int2 DEFAULT 1,
  "qmjz" int2 DEFAULT 1,
  "kjzt_id" int8,
  "lssj" int2
)
;
COMMENT ON COLUMN "public"."wxzj_kjpz"."id" IS '凭证主键id';
COMMENT ON COLUMN "public"."wxzj_kjpz"."pzbh" IS '凭证编号';
COMMENT ON COLUMN "public"."wxzj_kjpz"."pzrq" IS '凭证日期';
COMMENT ON COLUMN "public"."wxzj_kjpz"."zy" IS '摘要（弃用）';
COMMENT ON COLUMN "public"."wxzj_kjpz"."kjkm_id" IS '会计科目主键id（弃用）';
COMMENT ON COLUMN "public"."wxzj_kjpz"."jzr" IS '记账人';
COMMENT ON COLUMN "public"."wxzj_kjpz"."fhr" IS '复核人';
COMMENT ON COLUMN "public"."wxzj_kjpz"."zdr" IS '制单人';
COMMENT ON COLUMN "public"."wxzj_kjpz"."jzsj" IS '记账时间';
COMMENT ON COLUMN "public"."wxzj_kjpz"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_kjpz"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_kjpz"."cteate_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_kjpz"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_kjpz"."del_flag" IS '逻辑删除，0-正常、1-删除';
COMMENT ON COLUMN "public"."wxzj_kjpz"."jfje" IS '借方金额';
COMMENT ON COLUMN "public"."wxzj_kjpz"."dfje" IS '贷方金额';
COMMENT ON COLUMN "public"."wxzj_kjpz"."shzt" IS '审核状态(枚举)1-待审核、2-待记账、3-已记账、4-草稿、5-已作废';
COMMENT ON COLUMN "public"."wxzj_kjpz"."hjje" IS '合计金额';
COMMENT ON COLUMN "public"."wxzj_kjpz"."fdsl" IS '附件数量,附单据XX张，系统根据单据张数自动生成，不可修改';
COMMENT ON COLUMN "public"."wxzj_kjpz"."mblx" IS '模板类型，可以根据内置模版进行选择后简易编辑，常见的如交存、使用、增值都有模版';
COMMENT ON COLUMN "public"."wxzj_kjpz"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_kjpz"."lsh" IS '流水号(弃用)';
COMMENT ON COLUMN "public"."wxzj_kjpz"."pzlx" IS '凭证类型(1-自动 2-手动  )';
COMMENT ON COLUMN "public"."wxzj_kjpz"."qmjz" IS '期末结转(0-是 1-否)';
COMMENT ON COLUMN "public"."wxzj_kjpz"."kjzt_id" IS '账套id';
COMMENT ON COLUMN "public"."wxzj_kjpz"."lssj" IS '历史数据 （1-历史数据）';
COMMENT ON TABLE "public"."wxzj_kjpz" IS '会计凭证表';

-- ----------------------------
-- Table structure for wxzj_kjpz_auto
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjpz_auto";
CREATE TABLE "public"."wxzj_kjpz_auto" (
  "id" int8 NOT NULL,
  "kjpz_id" int8,
  "tzd_id" int8,
  "yhlsh" varchar(30) COLLATE "pg_catalog"."default",
  "ywlx" int2
)
;
COMMENT ON COLUMN "public"."wxzj_kjpz_auto"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_kjpz_auto"."kjpz_id" IS '会计凭证id';
COMMENT ON COLUMN "public"."wxzj_kjpz_auto"."tzd_id" IS '通知单id';
COMMENT ON COLUMN "public"."wxzj_kjpz_auto"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_kjpz_auto"."ywlx" IS '业务类型(1-交存 2-使用 3-增值 4-退款)';

-- ----------------------------
-- Table structure for wxzj_kjpz_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjpz_file";
CREATE TABLE "public"."wxzj_kjpz_file" (
  "id" int8 NOT NULL,
  "file_id" int8,
  "kjpz_id" int8,
  "auto_id" int8,
  "fjmc" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_kjpz_file"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_kjpz_file"."file_id" IS '文件id';
COMMENT ON COLUMN "public"."wxzj_kjpz_file"."kjpz_id" IS '会计凭证id';
COMMENT ON COLUMN "public"."wxzj_kjpz_file"."auto_id" IS '凭证自动id';
COMMENT ON COLUMN "public"."wxzj_kjpz_file"."fjmc" IS '附件名称';

-- ----------------------------
-- Table structure for wxzj_kjpz_kjkm
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjpz_kjkm";
CREATE TABLE "public"."wxzj_kjpz_kjkm" (
  "id" int8 NOT NULL,
  "kjkm_id" int8,
  "kjpz_id" int8,
  "zy" varchar(255) COLLATE "pg_catalog"."default",
  "je" numeric(15,2) DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "cteate_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "yefx" int2,
  "tenant_id" int8,
  "kmye" numeric(15,2),
  "batch_no" int8,
  "fzhs_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."kjkm_id" IS '会计科目id';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."kjpz_id" IS '会计凭证id';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."zy" IS '摘要';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."je" IS '金额';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."cteate_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."del_flag" IS '逻辑删除，0-正常、1-删除';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."yefx" IS '余额方向(1-借方 ，2-贷方)';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."kmye" IS '科目余额';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."batch_no" IS '批次号';
COMMENT ON COLUMN "public"."wxzj_kjpz_kjkm"."fzhs_id" IS '辅助核算id';
COMMENT ON TABLE "public"."wxzj_kjpz_kjkm" IS '会计科目-会计凭证中间表';

-- ----------------------------
-- Table structure for wxzj_kjzt
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjzt";
CREATE TABLE "public"."wxzj_kjzt" (
  "id" int8 NOT NULL,
  "ztmc" varchar(50) COLLATE "pg_catalog"."default",
  "jgmc" varchar(100) COLLATE "pg_catalog"."default",
  "kjzd" varchar(50) COLLATE "pg_catalog"."default",
  "jzbwb" varchar(30) COLLATE "pg_catalog"."default",
  "xzqh_id" int8,
  "yjkmdmcd" int2,
  "ejkmdmcd" int2,
  "sjkmdmcd" int2,
  "sijkmdmcd" int2,
  "wjkmdmcd" int2,
  "ztqyrq" date,
  "zt" int2 DEFAULT 1,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "fc" int2 DEFAULT 0,
  "xzzt" int2 DEFAULT 0,
  "zghdg" int2 DEFAULT 2,
  "fwlx" int2 DEFAULT 1,
  "wyqy_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_kjzt"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_kjzt"."ztmc" IS '账套名称';
COMMENT ON COLUMN "public"."wxzj_kjzt"."jgmc" IS '机构名称';
COMMENT ON COLUMN "public"."wxzj_kjzt"."kjzd" IS '会计制度';
COMMENT ON COLUMN "public"."wxzj_kjzt"."jzbwb" IS '记账本位币';
COMMENT ON COLUMN "public"."wxzj_kjzt"."xzqh_id" IS '行政区划id';
COMMENT ON COLUMN "public"."wxzj_kjzt"."yjkmdmcd" IS '一级科目代码长度';
COMMENT ON COLUMN "public"."wxzj_kjzt"."ejkmdmcd" IS '二级科目代码长度';
COMMENT ON COLUMN "public"."wxzj_kjzt"."sjkmdmcd" IS '三级科目代码长度';
COMMENT ON COLUMN "public"."wxzj_kjzt"."sijkmdmcd" IS '四级科目代码长度';
COMMENT ON COLUMN "public"."wxzj_kjzt"."wjkmdmcd" IS '五级科目代码长度';
COMMENT ON COLUMN "public"."wxzj_kjzt"."ztqyrq" IS '账套启用日期';
COMMENT ON COLUMN "public"."wxzj_kjzt"."zt" IS '状态(0-启用 1-停用,2-启用后停用)';
COMMENT ON COLUMN "public"."wxzj_kjzt"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_kjzt"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_kjzt"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_kjzt"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_kjzt"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_kjzt"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_kjzt"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_kjzt"."fc" IS '是否为第一次选择(默认状态为0表示该账套没有被选择，第一次被选择后改为1)';
COMMENT ON COLUMN "public"."wxzj_kjzt"."xzzt" IS '选择状态(0-未选择 1-选中)';
COMMENT ON COLUMN "public"."wxzj_kjzt"."zghdg" IS '管理方式(1-自管 2-代管)';
COMMENT ON COLUMN "public"."wxzj_kjzt"."fwlx" IS '类型(01-商品房 
02-公有售房 )';
COMMENT ON COLUMN "public"."wxzj_kjzt"."wyqy_id" IS '物业区域id';
COMMENT ON TABLE "public"."wxzj_kjzt" IS '会计账套';

-- ----------------------------
-- Table structure for wxzj_kjzt_dept
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_kjzt_dept";
CREATE TABLE "public"."wxzj_kjzt_dept" (
  "id" int8 NOT NULL,
  "kjzt_id" int8,
  "dept_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_kjzt_dept"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_kjzt_dept"."kjzt_id" IS '会计账套id';
COMMENT ON COLUMN "public"."wxzj_kjzt_dept"."dept_id" IS '部门id';
COMMENT ON TABLE "public"."wxzj_kjzt_dept" IS '会计账套和部门的中间表';

-- ----------------------------
-- Table structure for wxzj_ld
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_ld";
CREATE TABLE "public"."wxzj_ld" (
  "id" int8 NOT NULL,
  "lzdm" varchar(18) COLLATE "pg_catalog"."default",
  "lzmc" varchar(50) COLLATE "pg_catalog"."default",
  "lzytlx" int2 DEFAULT 1,
  "zjzmj" numeric(15,2),
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "zhyh_id" int8,
  "wyfwqu" varchar(15) COLLATE "pg_catalog"."default",
  "zbxx" varchar(50) COLLATE "pg_catalog"."default",
  "lcs" int4,
  "ldgd" numeric(15,2),
  "jkcmj" numeric(15,2),
  "bwcjzmj" numeric(15,2),
  "jgrq" date,
  "ldgghzh" int8,
  "ldsyzh" int8,
  "fwjzdm" varchar(18) COLLATE "pg_catalog"."default",
  "zddm" varchar(50) COLLATE "pg_catalog"."default",
  "jzjg" int2,
  "jsxm_id" int8,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "jzgd" numeric(15,2),
  "wyqy_id" int8,
  "dxzlc" int2,
  "dszlc" int2,
  "gjyh_id" int8,
  "lzjzlx" int2,
  "bxsj" int2
)
;
COMMENT ON COLUMN "public"."wxzj_ld"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_ld"."lzdm" IS '楼幢代码  楼幢代码18位，物业区域代码15位，序列化代码3位。';
COMMENT ON COLUMN "public"."wxzj_ld"."lzmc" IS '楼幢名称';
COMMENT ON COLUMN "public"."wxzj_ld"."lzytlx" IS '楼幢用途类型 1-住宅 2-非住宅
3-商住综合';
COMMENT ON COLUMN "public"."wxzj_ld"."zjzmj" IS '建筑面积';
COMMENT ON COLUMN "public"."wxzj_ld"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_ld"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_ld"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_ld"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_ld"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_ld"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_ld"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_ld"."zhyh_id" IS '专户银行';
COMMENT ON COLUMN "public"."wxzj_ld"."wyfwqu" IS '物业服务区域代码';
COMMENT ON COLUMN "public"."wxzj_ld"."zbxx" IS '坐标信息';
COMMENT ON COLUMN "public"."wxzj_ld"."lcs" IS '楼层数';
COMMENT ON COLUMN "public"."wxzj_ld"."ldgd" IS '楼幢高度';
COMMENT ON COLUMN "public"."wxzj_ld"."jkcmj" IS '架空层面积';
COMMENT ON COLUMN "public"."wxzj_ld"."bwcjzmj" IS '保温层建筑面积';
COMMENT ON COLUMN "public"."wxzj_ld"."jgrq" IS '竣工日期';
COMMENT ON COLUMN "public"."wxzj_ld"."ldgghzh" IS '楼幢公共
户账号';
COMMENT ON COLUMN "public"."wxzj_ld"."ldsyzh" IS '楼幢收益
账号';
COMMENT ON COLUMN "public"."wxzj_ld"."fwjzdm" IS '房屋建筑代码  (房屋建筑统一编码与基本属性数据标准)';
COMMENT ON COLUMN "public"."wxzj_ld"."zddm" IS '宗地代码 (与不动产登记)';
COMMENT ON COLUMN "public"."wxzj_ld"."jzjg" IS '建筑结构  0-钢结构  1-钢、钢筋混凝土结构  2-钢筋混凝土结构  3-砖木结构  4-混合结构  5-其它结构';
COMMENT ON COLUMN "public"."wxzj_ld"."jsxm_id" IS '项目id';
COMMENT ON COLUMN "public"."wxzj_ld"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_ld"."jzgd" IS '建筑高度';
COMMENT ON COLUMN "public"."wxzj_ld"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_ld"."dxzlc" IS '地下总楼层';
COMMENT ON COLUMN "public"."wxzj_ld"."dszlc" IS '地上总楼层';
COMMENT ON COLUMN "public"."wxzj_ld"."gjyh_id" IS '归集银行id';
COMMENT ON COLUMN "public"."wxzj_ld"."lzjzlx" IS '楼幢建筑类型1-多层、2-高层、3-电梯、4-非电梯、5-其他';
COMMENT ON COLUMN "public"."wxzj_ld"."bxsj" IS '保修时间';
COMMENT ON TABLE "public"."wxzj_ld" IS '楼幢表';

-- ----------------------------
-- Table structure for wxzj_mrjz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_mrjz";
CREATE TABLE "public"."wxzj_mrjz" (
  "id" int8 NOT NULL,
  "jzrq" date,
  "jzbmc" varchar(50) COLLATE "pg_catalog"."default",
  "jzzt" int2,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_mrjz"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_mrjz"."jzrq" IS '记账日期';
COMMENT ON COLUMN "public"."wxzj_mrjz"."jzbmc" IS '记账表名称';
COMMENT ON COLUMN "public"."wxzj_mrjz"."jzzt" IS '记账状态(1-未记账 2-已记账)';
COMMENT ON COLUMN "public"."wxzj_mrjz"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_mrjz" IS '维修资金每日记账表';

-- ----------------------------
-- Table structure for wxzj_order_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_order_log";
CREATE TABLE "public"."wxzj_order_log" (
  "id" int8 NOT NULL,
  "merOrderNo" varchar COLLATE "pg_catalog"."default",
  "tranAmt" numeric(18,2) NOT NULL,
  "orderDesc" varchar(255) COLLATE "pg_catalog"."default",
  "bankCode" varchar(20) COLLATE "pg_catalog"."default",
  "account" varchar(30) COLLATE "pg_catalog"."default",
  "callbackUrl" varchar(255) COLLATE "pg_catalog"."default",
  "resultNotificationUrl" varchar(255) COLLATE "pg_catalog"."default",
  "qrValidTime" date,
  "areaOfRealEstateCode" varchar(20) COLLATE "pg_catalog"."default",
  "areaOfRealEstateName" varchar(20) COLLATE "pg_catalog"."default",
  "apartmentAddr" varchar(20) COLLATE "pg_catalog"."default",
  "coveredArea" numeric(15,2),
  "ownerName" varchar(50) COLLATE "pg_catalog"."default",
  "dealTime" date,
  "feeStandard" numeric(18,2),
  "jffs" int2
)
;
COMMENT ON COLUMN "public"."wxzj_order_log"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_order_log"."merOrderNo" IS '订单号';
COMMENT ON COLUMN "public"."wxzj_order_log"."tranAmt" IS '交易金额';
COMMENT ON COLUMN "public"."wxzj_order_log"."orderDesc" IS '业务概要';
COMMENT ON COLUMN "public"."wxzj_order_log"."bankCode" IS '交易编号';
COMMENT ON COLUMN "public"."wxzj_order_log"."account" IS '终端号';
COMMENT ON COLUMN "public"."wxzj_order_log"."callbackUrl" IS '商户号';
COMMENT ON COLUMN "public"."wxzj_order_log"."resultNotificationUrl" IS '二维码';
COMMENT ON COLUMN "public"."wxzj_order_log"."areaOfRealEstateCode" IS '外部商户订单号';
COMMENT ON COLUMN "public"."wxzj_order_log"."areaOfRealEstateName" IS '物业服务区域名称';
COMMENT ON COLUMN "public"."wxzj_order_log"."apartmentAddr" IS '房屋地址';
COMMENT ON COLUMN "public"."wxzj_order_log"."coveredArea" IS '建筑面积';
COMMENT ON COLUMN "public"."wxzj_order_log"."ownerName" IS '业主名称';
COMMENT ON COLUMN "public"."wxzj_order_log"."dealTime" IS '缴交时间';
COMMENT ON COLUMN "public"."wxzj_order_log"."feeStandard" IS '缴费标准';
COMMENT ON COLUMN "public"."wxzj_order_log"."jffs" IS '交存方式 1-线上缴费  2-线下缴费';
COMMENT ON TABLE "public"."wxzj_order_log" IS '订单日志表';

-- ----------------------------
-- Table structure for wxzj_order_log_batch
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_order_log_batch";
CREATE TABLE "public"."wxzj_order_log_batch" (
  "id" int8 NOT NULL,
  "order_log_id" int8,
  "jflsh" varchar(20) COLLATE "pg_catalog"."default",
  "jfje" numeric(18,2),
  "jk_time" date
)
;
COMMENT ON COLUMN "public"."wxzj_order_log_batch"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_order_log_batch"."order_log_id" IS '订单日志主表id';
COMMENT ON COLUMN "public"."wxzj_order_log_batch"."jflsh" IS '缴费流水号';
COMMENT ON COLUMN "public"."wxzj_order_log_batch"."jfje" IS '缴费金额';
COMMENT ON COLUMN "public"."wxzj_order_log_batch"."jk_time" IS '缴款时间';

-- ----------------------------
-- Table structure for wxzj_pj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_pj";
CREATE TABLE "public"."wxzj_pj" (
  "id" int8 NOT NULL,
  "lrph" varchar(30) COLLATE "pg_catalog"."default",
  "pjmc" varchar(30) COLLATE "pg_catalog"."default",
  "pjbh" varchar(30) COLLATE "pg_catalog"."default",
  "pjzt" int2,
  "lrrq" timestamp(0),
  "fpph" varchar(30) COLLATE "pg_catalog"."default",
  "lydw_id" int8,
  "fprq" date,
  "zfyy" varchar(255) COLLATE "pg_catalog"."default",
  "kprq" date,
  "fw_id" int8,
  "kpje" numeric(15,2),
  "lrr" varchar(20) COLLATE "pg_catalog"."default",
  "fpr" varchar(20) COLLATE "pg_catalog"."default",
  "hxr" varchar(20) COLLATE "pg_catalog"."default",
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "ld_id" int8,
  "pjlx" int2
)
;
COMMENT ON COLUMN "public"."wxzj_pj"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_pj"."lrph" IS '录入批号';
COMMENT ON COLUMN "public"."wxzj_pj"."pjmc" IS '票据名称';
COMMENT ON COLUMN "public"."wxzj_pj"."pjbh" IS '票据编号';
COMMENT ON COLUMN "public"."wxzj_pj"."pjzt" IS '票据状态(0-有效,1-使用，2-领用，3-作废，4-核销)';
COMMENT ON COLUMN "public"."wxzj_pj"."lrrq" IS '录入日期';
COMMENT ON COLUMN "public"."wxzj_pj"."fpph" IS '分配批号';
COMMENT ON COLUMN "public"."wxzj_pj"."lydw_id" IS '领用单位(银行的主键id)';
COMMENT ON COLUMN "public"."wxzj_pj"."fprq" IS '分配日期';
COMMENT ON COLUMN "public"."wxzj_pj"."zfyy" IS '作废原因';
COMMENT ON COLUMN "public"."wxzj_pj"."kprq" IS '开票日期';
COMMENT ON COLUMN "public"."wxzj_pj"."fw_id" IS '房屋Id';
COMMENT ON COLUMN "public"."wxzj_pj"."kpje" IS '开票金额';
COMMENT ON COLUMN "public"."wxzj_pj"."lrr" IS '录入人';
COMMENT ON COLUMN "public"."wxzj_pj"."fpr" IS '分配人';
COMMENT ON COLUMN "public"."wxzj_pj"."hxr" IS '核销人';
COMMENT ON COLUMN "public"."wxzj_pj"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_pj"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_pj"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_pj"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_pj"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_pj"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_pj"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_pj"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_pj"."ld_id" IS '楼栋id';
COMMENT ON COLUMN "public"."wxzj_pj"."pjlx" IS '票据类型(1-单户交存 2-开发商批量交存)';
COMMENT ON TABLE "public"."wxzj_pj" IS '票据表';

-- ----------------------------
-- Table structure for wxzj_qw_order
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_qw_order";
CREATE TABLE "public"."wxzj_qw_order" (
  "id" int8 NOT NULL,
  "tzd_id" int8,
  "billNo" varchar(64) COLLATE "pg_catalog"."default",
  "billName" varchar(64) COLLATE "pg_catalog"."default",
  "descDetails" varchar(255) COLLATE "pg_catalog"."default",
  "expireDate" timestamp(6),
  "oweAmt" numeric(18,2) DEFAULT 0,
  "areaOfRealEstateCode" varchar(50) COLLATE "pg_catalog"."default",
  "areaOfRealEstateName" varchar(50) COLLATE "pg_catalog"."default",
  "areaOfRealEstateAddr" varchar(255) COLLATE "pg_catalog"."default",
  "apartmentAddr" varchar(255) COLLATE "pg_catalog"."default",
  "coveredArea" numeric(20,2) DEFAULT 0,
  "feeStandard" numeric(20,2) DEFAULT 0,
  "custName" varchar(25) COLLATE "pg_catalog"."default",
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "callBackUrl" varchar(255) COLLATE "pg_catalog"."default",
  "callBackText" varchar(255) COLLATE "pg_catalog"."default",
  "payment_qr_code" varchar(255) COLLATE "pg_catalog"."default",
  "ddzt" int2 DEFAULT 1,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "ddzfsj" date,
  "ddgbsj" date,
  "ddcssj" date,
  "ddyxq" int8,
  "traceno" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_qw_order"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_qw_order"."tzd_id" IS '通知单id';
COMMENT ON COLUMN "public"."wxzj_qw_order"."billNo" IS '订单编号';
COMMENT ON COLUMN "public"."wxzj_qw_order"."billName" IS '订单名称';
COMMENT ON COLUMN "public"."wxzj_qw_order"."descDetails" IS '摘要';
COMMENT ON COLUMN "public"."wxzj_qw_order"."expireDate" IS '账单到期日期';
COMMENT ON COLUMN "public"."wxzj_qw_order"."oweAmt" IS '应交金额';
COMMENT ON COLUMN "public"."wxzj_qw_order"."areaOfRealEstateCode" IS '物业服务区域代码';
COMMENT ON COLUMN "public"."wxzj_qw_order"."areaOfRealEstateName" IS '物业服务区域名称';
COMMENT ON COLUMN "public"."wxzj_qw_order"."areaOfRealEstateAddr" IS '物业服务区域地址';
COMMENT ON COLUMN "public"."wxzj_qw_order"."apartmentAddr" IS '房屋详细地址';
COMMENT ON COLUMN "public"."wxzj_qw_order"."coveredArea" IS '建筑面积';
COMMENT ON COLUMN "public"."wxzj_qw_order"."feeStandard" IS '缴费标准';
COMMENT ON COLUMN "public"."wxzj_qw_order"."custName" IS '业主姓名';
COMMENT ON COLUMN "public"."wxzj_qw_order"."remark" IS '备注';
COMMENT ON COLUMN "public"."wxzj_qw_order"."callBackUrl" IS '支付成功跳转地址';
COMMENT ON COLUMN "public"."wxzj_qw_order"."callBackText" IS '支付成功跳转按钮名称';
COMMENT ON COLUMN "public"."wxzj_qw_order"."payment_qr_code" IS '支付二维码';
COMMENT ON COLUMN "public"."wxzj_qw_order"."ddzt" IS '订单状态1-支付中 2-已支付，3-超时，4-订单关闭 5-支付失败 6-主动查询失败临时状态';
COMMENT ON COLUMN "public"."wxzj_qw_order"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_qw_order"."ddzfsj" IS '订单支付时间';
COMMENT ON COLUMN "public"."wxzj_qw_order"."ddgbsj" IS '订单关闭时间';
COMMENT ON COLUMN "public"."wxzj_qw_order"."ddyxq" IS '订单有效期';
COMMENT ON COLUMN "public"."wxzj_qw_order"."traceno" IS '订单流水号（二维码）';
COMMENT ON TABLE "public"."wxzj_qw_order" IS '犍为_线上支付订单表';

-- ----------------------------
-- Table structure for wxzj_review
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_review";
CREATE TABLE "public"."wxzj_review" (
  "id" int8 NOT NULL,
  "yhlsh" varchar(50) COLLATE "pg_catalog"."default",
  "jkzhzh" varchar(50) COLLATE "pg_catalog"."default",
  "jcr" varchar(50) COLLATE "pg_catalog"."default",
  "jyrq" timestamp(6),
  "jcje" numeric(18,2),
  "bjbh" varchar(20) COLLATE "pg_catalog"."default",
  "jyfs" int2,
  "file_id" int8,
  "tzdId" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_review"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_review"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_review"."jkzhzh" IS '交款账户账号';
COMMENT ON COLUMN "public"."wxzj_review"."jcr" IS '交存人';
COMMENT ON COLUMN "public"."wxzj_review"."jyrq" IS '交易日期';
COMMENT ON COLUMN "public"."wxzj_review"."jcje" IS '交存金额';
COMMENT ON COLUMN "public"."wxzj_review"."bjbh" IS '票据编号';
COMMENT ON COLUMN "public"."wxzj_review"."jyfs" IS '交易方式';
COMMENT ON COLUMN "public"."wxzj_review"."file_id" IS '附件id';
COMMENT ON COLUMN "public"."wxzj_review"."tzdId" IS '通知单id';
COMMENT ON COLUMN "public"."wxzj_review"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_review" IS '复核明细表';

-- ----------------------------
-- Table structure for wxzj_sssb
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_sssb";
CREATE TABLE "public"."wxzj_sssb" (
  "id" int8 NOT NULL,
  "wxyt" int2,
  "sssb" varchar(255) COLLATE "pg_catalog"."default",
  "sssbno" varchar(255) COLLATE "pg_catalog"."default",
  "zt" int2,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" timestamp(6),
  "del_flag" int2 DEFAULT 0,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_sssb"."id" IS '共用部位/设备管理id';
COMMENT ON COLUMN "public"."wxzj_sssb"."wxyt" IS '维修用途 1-住宅共用部位  2-共用设施设备';
COMMENT ON COLUMN "public"."wxzj_sssb"."sssb" IS '部位/设备分类';
COMMENT ON COLUMN "public"."wxzj_sssb"."sssbno" IS '部位/设备分类编号';
COMMENT ON COLUMN "public"."wxzj_sssb"."zt" IS '状态 0-停用 1-启用';
COMMENT ON TABLE "public"."wxzj_sssb" IS '共用部位/设备管理';

-- ----------------------------
-- Table structure for wxzj_tk_review
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_tk_review";
CREATE TABLE "public"."wxzj_tk_review" (
  "id" int8 NOT NULL,
  "yhlsh" varchar(25) COLLATE "pg_catalog"."default",
  "zkyh" varchar(25) COLLATE "pg_catalog"."default",
  "jysj" date,
  "skr" varchar(25) COLLATE "pg_catalog"."default",
  "skzh" varchar(25) COLLATE "pg_catalog"."default",
  "jcje" numeric(18,2),
  "jyfs" int2,
  "bjbh" varchar(25) COLLATE "pg_catalog"."default",
  "tzdid" int8,
  "zkyhzh" varchar(25) COLLATE "pg_catalog"."default",
  "skyh" varchar(25) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_tk_review"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_tk_review"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_tk_review"."zkyh" IS '支款银行';
COMMENT ON COLUMN "public"."wxzj_tk_review"."jysj" IS '交易时间';
COMMENT ON COLUMN "public"."wxzj_tk_review"."skr" IS '收款人';
COMMENT ON COLUMN "public"."wxzj_tk_review"."skzh" IS '收款账号';
COMMENT ON COLUMN "public"."wxzj_tk_review"."jcje" IS '交存金额';
COMMENT ON COLUMN "public"."wxzj_tk_review"."jyfs" IS '交易方式';
COMMENT ON COLUMN "public"."wxzj_tk_review"."bjbh" IS '票据编号';
COMMENT ON COLUMN "public"."wxzj_tk_review"."tzdid" IS '通知单编号';
COMMENT ON COLUMN "public"."wxzj_tk_review"."zkyhzh" IS '支款银行账号';
COMMENT ON COLUMN "public"."wxzj_tk_review"."skyh" IS '收款银行';
COMMENT ON COLUMN "public"."wxzj_tk_review"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_tkls
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_tkls";
CREATE TABLE "public"."wxzj_tkls" (
  "id" int8 NOT NULL,
  "tzd_id" int8,
  "dd_id" varchar(64) COLLATE "pg_catalog"."default",
  "fsje" numeric(18,2),
  "zkyhzh" varchar(50) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "rzsj" date,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "batch_no" int8,
  "jcfs" int2,
  "jyqd" int2,
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "zkyh" varchar(50) COLLATE "pg_catalog"."default",
  "skyh" varchar(50) COLLATE "pg_catalog"."default",
  "skzh" varchar(50) COLLATE "pg_catalog"."default",
  "dzzt" int2 DEFAULT 3,
  "bd" int2,
  "tenant_id" int8,
  "dept" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_tkls"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_tkls"."tzd_id" IS ' 通知单id';
COMMENT ON COLUMN "public"."wxzj_tkls"."dd_id" IS '订单_id/票据编号';
COMMENT ON COLUMN "public"."wxzj_tkls"."fsje" IS '发生金额';
COMMENT ON COLUMN "public"."wxzj_tkls"."zkyhzh" IS '支款银行账号';
COMMENT ON COLUMN "public"."wxzj_tkls"."rzsj" IS '交易时间';
COMMENT ON COLUMN "public"."wxzj_tkls"."qr_order_no" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_tkls"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_tkls"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_tkls"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_tkls"."batch_no" IS '定向定期批次号';
COMMENT ON COLUMN "public"."wxzj_tkls"."jcfs" IS '交存方式 1-线上  2-线下';
COMMENT ON COLUMN "public"."wxzj_tkls"."jyqd" IS '交易渠道';
COMMENT ON COLUMN "public"."wxzj_tkls"."skr" IS '收款人';
COMMENT ON COLUMN "public"."wxzj_tkls"."zkyh" IS '支款银行';
COMMENT ON COLUMN "public"."wxzj_tkls"."skyh" IS '收款银行';
COMMENT ON COLUMN "public"."wxzj_tkls"."skzh" IS '收款账号';
COMMENT ON COLUMN "public"."wxzj_tkls"."dzzt" IS '对账状态，1—已对账（对账成功）、2—未对账（对账失败）、3—银行没账单数据';
COMMENT ON COLUMN "public"."wxzj_tkls"."bd" IS '补单1-补单';
COMMENT ON COLUMN "public"."wxzj_tkls"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_tkls_batch
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_tkls_batch";
CREATE TABLE "public"."wxzj_tkls_batch" (
  "id" int8 NOT NULL,
  "tkls_id" int8,
  "fhzh_id" int8,
  "fsje" numeric(15,2),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_tkls_batch"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_tkls_batch"."tkls_id" IS '退款流水id';
COMMENT ON COLUMN "public"."wxzj_tkls_batch"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_tkls_batch"."fsje" IS '发生金额';
COMMENT ON COLUMN "public"."wxzj_tkls_batch"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_tktzd_order
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_tktzd_order";
CREATE TABLE "public"."wxzj_tktzd_order" (
  "id" int8 NOT NULL,
  "tzdId" int8,
  "ddzt" int2 DEFAULT 1,
  "ddyxq" int8,
  "qrCode" varchar(255) COLLATE "pg_catalog"."default",
  "qrOrderNo" varchar(64) COLLATE "pg_catalog"."default",
  "ddzfsj" date,
  "ddgbsj" date,
  "ddcssj" date,
  "delFlag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."id" IS 'id';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."tzdId" IS '通知单id';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."ddzt" IS '订单状态1-退款中 2-已退款，3-超时，4-订单关闭 5-退款失败';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."ddyxq" IS '订单有效期';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."qrCode" IS '二维码';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."qrOrderNo" IS '退款订单号';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."ddzfsj" IS '订单退款时间';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."ddgbsj" IS '订单关闭时间';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."delFlag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_tktzd_order"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_tpqm_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_tpqm_file";
CREATE TABLE "public"."wxzj_tpqm_file" (
  "id" int8 NOT NULL,
  "file_id" int8,
  "tpxx_id" int8,
  "fw_id" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_tpqm_file"."id" IS '投票签名主键';
COMMENT ON COLUMN "public"."wxzj_tpqm_file"."file_id" IS '文件id';
COMMENT ON COLUMN "public"."wxzj_tpqm_file"."tpxx_id" IS '投票信息id';
COMMENT ON COLUMN "public"."wxzj_tpqm_file"."fw_id" IS '房屋id';
COMMENT ON COLUMN "public"."wxzj_tpqm_file"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_tpqm_file" IS '投票签名';

-- ----------------------------
-- Table structure for wxzj_tpxx_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_tpxx_file";
CREATE TABLE "public"."wxzj_tpxx_file" (
  "id" int8 NOT NULL,
  "file_id" int8,
  "tpxx_id" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_tpxx_file"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_tpxx_file"."file_id" IS '文件id';
COMMENT ON COLUMN "public"."wxzj_tpxx_file"."tpxx_id" IS '公示信息id';
COMMENT ON COLUMN "public"."wxzj_tpxx_file"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_tpxx_file" IS '投票文件关联表';

-- ----------------------------
-- Table structure for wxzj_tzd_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_tzd_log";
CREATE TABLE "public"."wxzj_tzd_log" (
  "id" int8 NOT NULL,
  "tzd_id" int8,
  "lx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "czr" varchar(50) COLLATE "pg_catalog"."default",
  "czsj" timestamp(6),
  "cznr" varchar(255) COLLATE "pg_catalog"."default",
  "cz" int2,
  "jyje" numeric(18,2),
  "yhqr_time" timestamp(6),
  "fhr" varchar(64) COLLATE "pg_catalog"."default",
  "fh_time" timestamp(6),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_tzd_log"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."tzd_id" IS ' 通知单';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."lx" IS '1-生成 2-复核 3-撤销 4-修改 5-删除';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."czr" IS '操作人';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."czsj" IS '操作时间';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."cznr" IS '操作内容';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."cz" IS '操作 1-交存  2-退款';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."jyje" IS '交易金额';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."yhqr_time" IS '银行确认时间';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."fhr" IS '复核人';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."fh_time" IS '复核时间';
COMMENT ON COLUMN "public"."wxzj_tzd_log"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_tzd_log" IS '通知单操作日志表';

-- ----------------------------
-- Table structure for wxzj_tzd_order
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_tzd_order";
CREATE TABLE "public"."wxzj_tzd_order" (
  "id" int8 NOT NULL,
  "tzdId" int8,
  "ddzt" int2 DEFAULT 1,
  "ddyxq" int8,
  "qrCode" varchar(255) COLLATE "pg_catalog"."default",
  "qrOrderNo" varchar(64) COLLATE "pg_catalog"."default",
  "ddzfsj" date,
  "ddgbsj" date,
  "ddcssj" date,
  "delFlag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_tzd_order"."id" IS 'id';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."tzdId" IS '通知单id';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."ddzt" IS '订单状态1-支付中 2-已支付，3-超时，4-订单关闭 5-支付失败';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."ddyxq" IS '订单有效期';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."qrCode" IS '二维码';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."qrOrderNo" IS '申码订单号';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."ddzfsj" IS '订单支付时间';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."ddgbsj" IS '订单关闭时间';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."delFlag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_tzd_order"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_voucher_infoVo
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_voucher_infoVo";
CREATE TABLE "public"."wxzj_voucher_infoVo" (
  "id" int8 NOT NULL,
  "tzd_id" int8,
  "frequency" int4 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_voucher_infoVo"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_voucher_infoVo"."tzd_id" IS '通知单id';
COMMENT ON COLUMN "public"."wxzj_voucher_infoVo"."frequency" IS '访问次数';
COMMENT ON TABLE "public"."wxzj_voucher_infoVo" IS '凭证信息表';

-- ----------------------------
-- Table structure for wxzj_wyqy
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_wyqy";
CREATE TABLE "public"."wxzj_wyqy" (
  "id" int8 NOT NULL,
  "xzqhdm_id" int8,
  "wyqymc" varchar(50) COLLATE "pg_catalog"."default",
  "wyqydm" varchar(15) COLLATE "pg_catalog"."default",
  "wyqylx" int2 DEFAULT 1,
  "zjzmj" numeric(15,2),
  "jbr" varchar(50) COLLATE "pg_catalog"."default",
  "jbrdh" varchar(20) COLLATE "pg_catalog"."default",
  "kfjsdw_id" int8,
  "wyfwqy_id" int8,
  "xxdz" varchar(200) COLLATE "pg_catalog"."default",
  "beiz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "mph" varchar(30) COLLATE "pg_catalog"."default",
  "szsq" varchar(50) COLLATE "pg_catalog"."default",
  "dz" varchar(30) COLLATE "pg_catalog"."default",
  "xz" varchar(30) COLLATE "pg_catalog"."default",
  "nz" varchar(30) COLLATE "pg_catalog"."default",
  "bz" varchar(30) COLLATE "pg_catalog"."default",
  "zbxx" varchar(50) COLLATE "pg_catalog"."default",
  "zydmj" numeric(15,2),
  "zlhmj" numeric(15,2),
  "dszjzmj" numeric(15,2),
  "dxzjzmj" numeric(15,2),
  "jdmj" numeric(15,2),
  "rjl" numeric(15,2),
  "lhl" numeric(15,2),
  "jgrq" date,
  "njfrq" date,
  "wylx" int2,
  "zghdg" int2,
  "wyqyzh" varchar(30) COLLATE "pg_catalog"."default",
  "wyggqyzh" varchar(30) COLLATE "pg_catalog"."default",
  "wyqysyzh" varchar(30) COLLATE "pg_catalog"."default",
  "cwgs" int4,
  "jdb_id" int8,
  "jwh_id" int8,
  "kfjsdw" varchar(100) COLLATE "pg_catalog"."default",
  "wyfwqy" varchar(100) COLLATE "pg_catalog"."default",
  "jdb" varchar(100) COLLATE "pg_catalog"."default",
  "jwh" varchar(100) COLLATE "pg_catalog"."default",
  "jcbz" numeric(15,2),
  "tyshxydm" varchar(20) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "zlds" int2,
  "zfws" int2,
  "zbdz" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_wyqy"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_wyqy"."xzqhdm_id" IS '行政区划代码id';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wyqymc" IS '物业区域名称';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wyqydm" IS '物业区域代码 行政区划代码应为9位，即前6位为县级行政区划代码，后3位为街道(乡镇)代码，当无法细到街道(乡镇)时，后3位可为0；序列代码位数应为6位，不足位前面补0。';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wyqylx" IS '物业区域类型  1-商品房 
2-公有售房 
3-新居工程
4-拆迁安置房
5-单一产权人
6-统规自建房
7-征地拆迁房
8-商业非住宅
9-其他非住宅
10-保障性住房
11-全额集资建房
12-农村集中居住区
99-其他';
COMMENT ON COLUMN "public"."wxzj_wyqy"."zjzmj" IS '总建筑面积';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jbr" IS '经办人';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jbrdh" IS '经办人电话';
COMMENT ON COLUMN "public"."wxzj_wyqy"."kfjsdw_id" IS '开发建设单位id';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wyfwqy_id" IS '物业服务企业id';
COMMENT ON COLUMN "public"."wxzj_wyqy"."xxdz" IS '详细地址';
COMMENT ON COLUMN "public"."wxzj_wyqy"."beiz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_wyqy"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_wyqy"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_wyqy"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_wyqy"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_wyqy"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_wyqy"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_wyqy"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_wyqy"."mph" IS '门牌号';
COMMENT ON COLUMN "public"."wxzj_wyqy"."szsq" IS '所在社区';
COMMENT ON COLUMN "public"."wxzj_wyqy"."dz" IS '东至';
COMMENT ON COLUMN "public"."wxzj_wyqy"."xz" IS '西至';
COMMENT ON COLUMN "public"."wxzj_wyqy"."nz" IS '南至';
COMMENT ON COLUMN "public"."wxzj_wyqy"."bz" IS '北至';
COMMENT ON COLUMN "public"."wxzj_wyqy"."zbxx" IS '坐标信息';
COMMENT ON COLUMN "public"."wxzj_wyqy"."zydmj" IS '总用地面积';
COMMENT ON COLUMN "public"."wxzj_wyqy"."zlhmj" IS '总绿化面积';
COMMENT ON COLUMN "public"."wxzj_wyqy"."dszjzmj" IS '地上总建筑面积';
COMMENT ON COLUMN "public"."wxzj_wyqy"."dxzjzmj" IS '地下总建筑面积';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jdmj" IS '基底面积';
COMMENT ON COLUMN "public"."wxzj_wyqy"."rjl" IS '容积率';
COMMENT ON COLUMN "public"."wxzj_wyqy"."lhl" IS '绿化率';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jgrq" IS '竣工日期';
COMMENT ON COLUMN "public"."wxzj_wyqy"."njfrq" IS '拟交付日期';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wylx" IS '物业类型(1-住宅物业 2-非住宅物业 3-商住综合物业)';
COMMENT ON COLUMN "public"."wxzj_wyqy"."zghdg" IS '自管或代管(1-自管 ，2- 代管)';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wyqyzh" IS '物业区域
账户账号';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wyggqyzh" IS '物业区域
公共户账号';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wyqysyzh" IS '物业区域
收益账号';
COMMENT ON COLUMN "public"."wxzj_wyqy"."cwgs" IS '车位个数';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jdb_id" IS '街道办id';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jwh_id" IS '居委会id';
COMMENT ON COLUMN "public"."wxzj_wyqy"."kfjsdw" IS '开发建设单位名称';
COMMENT ON COLUMN "public"."wxzj_wyqy"."wyfwqy" IS '物业服务企业名称';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jdb" IS '街道办';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jwh" IS '居委会';
COMMENT ON COLUMN "public"."wxzj_wyqy"."jcbz" IS '交存标准';
COMMENT ON COLUMN "public"."wxzj_wyqy"."tyshxydm" IS '统一社会信用代码';
COMMENT ON COLUMN "public"."wxzj_wyqy"."zlds" IS '总楼栋数';
COMMENT ON COLUMN "public"."wxzj_wyqy"."zfws" IS '总房屋数';
COMMENT ON COLUMN "public"."wxzj_wyqy"."zbdz" IS '坐标地址';
COMMENT ON TABLE "public"."wxzj_wyqy" IS '物业区域表';

-- ----------------------------
-- Table structure for wxzj_xwdt_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_xwdt_file";
CREATE TABLE "public"."wxzj_xwdt_file" (
  "id" int8 NOT NULL,
  "file_id" int8,
  "xwdt_id" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_xwdt_file"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_xwdt_file"."file_id" IS '文件id';
COMMENT ON COLUMN "public"."wxzj_xwdt_file"."xwdt_id" IS '新闻动态id';
COMMENT ON COLUMN "public"."wxzj_xwdt_file"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_xzqh
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_xzqh";
CREATE TABLE "public"."wxzj_xzqh" (
  "id" int8 NOT NULL,
  "xzqhmc" varchar(100) COLLATE "pg_catalog"."default",
  "xzqhdm" varchar(9) COLLATE "pg_catalog"."default",
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "pid" int8
)
;
COMMENT ON COLUMN "public"."wxzj_xzqh"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_xzqh"."xzqhmc" IS '行政区划名称';
COMMENT ON COLUMN "public"."wxzj_xzqh"."xzqhdm" IS '行政区划代码';
COMMENT ON COLUMN "public"."wxzj_xzqh"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_xzqh"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_xzqh"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_xzqh"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_xzqh"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_xzqh"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_xzqh"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_xzqh"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_xzqh"."pid" IS '父级id';
COMMENT ON TABLE "public"."wxzj_xzqh" IS '行政区划表';

-- ----------------------------
-- Table structure for wxzj_yhckrjz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_yhckrjz";
CREATE TABLE "public"."wxzj_yhckrjz" (
  "id" int8 NOT NULL,
  "dzrq" date,
  "yhzh_id" varchar(20) COLLATE "pg_catalog"."default",
  "kjqj" date,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "kjkm_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."dzrq" IS '对账日期';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."yhzh_id" IS '银行账户id';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."kjqj" IS '会计期间';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."del_flag" IS '逻辑删除(0-正常 1-删除)';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_yhckrjz"."kjkm_id" IS '会计科目id';
COMMENT ON TABLE "public"."wxzj_yhckrjz" IS '维修资金银行存款日记账';

-- ----------------------------
-- Table structure for wxzj_yhzd
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_yhzd";
CREATE TABLE "public"."wxzj_yhzd" (
  "id" int8 NOT NULL,
  "resp_code" varchar(50) COLLATE "pg_catalog"."default",
  "resp_msg" varchar(200) COLLATE "pg_catalog"."default",
  "card_no" varchar(200) COLLATE "pg_catalog"."default",
  "settle_date" date,
  "tran_date" date,
  "tran_time" timestamp(6),
  "tran_amt" numeric(18,2),
  "fee" numeric(18,2),
  "settle_amt" numeric(18,2),
  "third_order_no" varchar(50) COLLATE "pg_catalog"."default",
  "mer_order_no" varchar(50) COLLATE "pg_catalog"."default",
  "auth_no" varchar(50) COLLATE "pg_catalog"."default",
  "channel_order_no" varchar(50) COLLATE "pg_catalog"."default",
  "card_type" int2,
  "tran_type" int2,
  "plan_num" int2,
  "ccy_code" int2,
  "ccy_tran_amt" numeric,
  "tran_rrn" varchar(50) COLLATE "pg_catalog"."default",
  "scan_flag" int2,
  "void_third_order_no" varchar(50) COLLATE "pg_catalog"."default",
  "void_channel_order_no" varchar(50) COLLATE "pg_catalog"."default",
  "channel_flag" int2,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "zy" varchar(200) COLLATE "pg_catalog"."default",
  "lsh" varchar(50) COLLATE "pg_catalog"."default",
  "jyfx" int2,
  "dzzt" int2 DEFAULT 3,
  "hdzt" int2 DEFAULT 1,
  "lqrq" date,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_yhzd"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_yhzd"."resp_code" IS '本笔交易的结果代码';
COMMENT ON COLUMN "public"."wxzj_yhzd"."resp_msg" IS '本笔交易的结果描述';
COMMENT ON COLUMN "public"."wxzj_yhzd"."card_no" IS '卡号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."settle_date" IS '清算日期';
COMMENT ON COLUMN "public"."wxzj_yhzd"."tran_date" IS '交易日期';
COMMENT ON COLUMN "public"."wxzj_yhzd"."tran_time" IS '交易时间';
COMMENT ON COLUMN "public"."wxzj_yhzd"."tran_amt" IS '交易金额';
COMMENT ON COLUMN "public"."wxzj_yhzd"."fee" IS '手续费';
COMMENT ON COLUMN "public"."wxzj_yhzd"."settle_amt" IS '清算金额';
COMMENT ON COLUMN "public"."wxzj_yhzd"."third_order_no" IS '商户订单号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."mer_order_no" IS '外部商户订单号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."auth_no" IS '授权号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."channel_order_no" IS '交易渠道订单号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."card_type" IS '卡别(枚举)';
COMMENT ON COLUMN "public"."wxzj_yhzd"."tran_type" IS '交易类型（枚举）';
COMMENT ON COLUMN "public"."wxzj_yhzd"."plan_num" IS '分期数';
COMMENT ON COLUMN "public"."wxzj_yhzd"."ccy_code" IS '交易币种（枚举）';
COMMENT ON COLUMN "public"."wxzj_yhzd"."ccy_tran_amt" IS '交易币种金额';
COMMENT ON COLUMN "public"."wxzj_yhzd"."tran_rrn" IS '参考号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."scan_flag" IS '正反面标识（枚举）';
COMMENT ON COLUMN "public"."wxzj_yhzd"."void_third_order_no" IS '原商户订单号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."void_channel_order_no" IS '原交易渠道订单号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."channel_flag" IS '交易渠道';
COMMENT ON COLUMN "public"."wxzj_yhzd"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_yhzd"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_yhzd"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_yhzd"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_yhzd"."del_flag" IS '逻辑删除，0—正常、1—删除';
COMMENT ON COLUMN "public"."wxzj_yhzd"."zy" IS '摘要';
COMMENT ON COLUMN "public"."wxzj_yhzd"."lsh" IS '流水号';
COMMENT ON COLUMN "public"."wxzj_yhzd"."jyfx" IS '交易方向（1-支出 2-收入）';
COMMENT ON COLUMN "public"."wxzj_yhzd"."dzzt" IS '状态(1-对账成功，2-对账失败，3-未对账)';
COMMENT ON COLUMN "public"."wxzj_yhzd"."hdzt" IS '核对状态(1-未核对 2-已核对)';
COMMENT ON COLUMN "public"."wxzj_yhzd"."lqrq" IS '账单拉取日期';
COMMENT ON COLUMN "public"."wxzj_yhzd"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_yhzd" IS '银行账单表（）';

-- ----------------------------
-- Table structure for wxzj_yhzh
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_yhzh";
CREATE TABLE "public"."wxzj_yhzh" (
  "id" int8 NOT NULL,
  "yhdm" varchar(20) COLLATE "pg_catalog"."default",
  "yhmc" varchar(50) COLLATE "pg_catalog"."default",
  "yhdz" varchar(200) COLLATE "pg_catalog"."default",
  "zhmc" varchar(50) COLLATE "pg_catalog"."default",
  "zhzh" varchar(30) COLLATE "pg_catalog"."default",
  "jt" int2 DEFAULT 0,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "zhlx" int2,
  "lxr" varchar(20) COLLATE "pg_catalog"."default",
  "lxdh" varchar(20) COLLATE "pg_catalog"."default",
  "ye" numeric(15,2) DEFAULT 0,
  "djye" numeric(15,2),
  "kyye" numeric(15,2) DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_yhzh"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_yhzh"."yhdm" IS '银行代码';
COMMENT ON COLUMN "public"."wxzj_yhzh"."yhmc" IS '银行名称';
COMMENT ON COLUMN "public"."wxzj_yhzh"."yhdz" IS '银行地址';
COMMENT ON COLUMN "public"."wxzj_yhzh"."zhmc" IS '专户名称';
COMMENT ON COLUMN "public"."wxzj_yhzh"."zhzh" IS '专户账号';
COMMENT ON COLUMN "public"."wxzj_yhzh"."jt" IS '0-正常 1-冻结';
COMMENT ON COLUMN "public"."wxzj_yhzh"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_yhzh"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_yhzh"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_yhzh"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_yhzh"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_yhzh"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_yhzh"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_yhzh"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_yhzh"."zhlx" IS '账户类型(0-归集账户，1-增值账户,2-机构账户，3-专户账户  4-备用金账户)';
COMMENT ON COLUMN "public"."wxzj_yhzh"."lxr" IS '联系人';
COMMENT ON COLUMN "public"."wxzj_yhzh"."lxdh" IS '联系电话';
COMMENT ON COLUMN "public"."wxzj_yhzh"."ye" IS '余额';
COMMENT ON COLUMN "public"."wxzj_yhzh"."djye" IS '冻结余额';
COMMENT ON COLUMN "public"."wxzj_yhzh"."kyye" IS '可用余额';
COMMENT ON TABLE "public"."wxzj_yhzh" IS '银行账户表';

-- ----------------------------
-- Table structure for wxzj_ywtb_qxsx
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_ywtb_qxsx";
CREATE TABLE "public"."wxzj_ywtb_qxsx" (
  "id" int8 NOT NULL,
  "sxbs" varchar(255) COLLATE "pg_catalog"."default",
  "qx_dept_code" varchar(255) COLLATE "pg_catalog"."default",
  "area_code" varchar(255) COLLATE "pg_catalog"."default",
  "event_code" varchar(255) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6) DEFAULT now(),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "event_name" varchar(255) COLLATE "pg_catalog"."default",
  "node_dept_name" varchar(255) COLLATE "pg_catalog"."default",
  "city_code" varchar(255) COLLATE "pg_catalog"."default",
  "public_key" varchar(255) COLLATE "pg_catalog"."default",
  "private_key" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."sxbs" IS '事项标识，
住宅专项维修资金查询——zzzxwxzjcx
住宅专项维修资金交存——zzzxwxzjjc
住宅专项维修资金分户账更名——zzzxwxzjfzhgm
住宅专项维修资金使用备案——zzzxwxzjba


';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."qx_dept_code" IS '区县部门编码';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."area_code" IS '区县编码';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."event_code" IS '事项编码';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."event_name" IS '事项名称';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."node_dept_name" IS '节点部门名称';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."city_code" IS '市州编码';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."public_key" IS '公钥';
COMMENT ON COLUMN "public"."wxzj_ywtb_qxsx"."private_key" IS '私钥';
COMMENT ON TABLE "public"."wxzj_ywtb_qxsx" IS '一网通办区县事项表';

-- ----------------------------
-- Table structure for wxzj_ywtb_sxcl
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_ywtb_sxcl";
CREATE TABLE "public"."wxzj_ywtb_sxcl" (
  "id" int8 NOT NULL,
  "req_parm" varchar(2000) COLLATE "pg_catalog"."default",
  "xqbh" varchar(50) COLLATE "pg_catalog"."default",
  "wxzj_fw_id" int8,
  "sxlx" int2,
  "clzt" int2 DEFAULT 1,
  "del_flag" int2 DEFAULT 0,
  "update_time" timestamp(6),
  "create_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "serial_no" varchar(60) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."req_parm" IS '请求参数';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."xqbh" IS '小区编号';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."wxzj_fw_id" IS '维修资金房屋id';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."sxlx" IS '事项类型，1—维修资金使用备案，2—维修资金分户账户更名';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."clzt" IS '事项处理状态，1—未完成，2—已完成';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."del_flag" IS '删除标志(0代表存在 1代表删除)';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."serial_no" IS '事项流水号';
COMMENT ON COLUMN "public"."wxzj_ywtb_sxcl"."tenant_id" IS '租户id';
COMMENT ON TABLE "public"."wxzj_ywtb_sxcl" IS '一网通办事项参数,事项处理表';

-- ----------------------------
-- Table structure for wxzj_ywtbjd_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_ywtbjd_log";
CREATE TABLE "public"."wxzj_ywtbjd_log" (
  "id" int8 NOT NULL,
  "scope_code" varchar(255) COLLATE "pg_catalog"."default",
  "module" varchar(100) COLLATE "pg_catalog"."default",
  "operator" varchar(255) COLLATE "pg_catalog"."default",
  "method" varchar(255) COLLATE "pg_catalog"."default",
  "req_method" varchar(100) COLLATE "pg_catalog"."default",
  "req_url" varchar(255) COLLATE "pg_catalog"."default",
  "req_params" varchar(3000) COLLATE "pg_catalog"."default",
  "res_result" varchar(3000) COLLATE "pg_catalog"."default",
  "res_status" varchar(100) COLLATE "pg_catalog"."default",
  "error_msg" varchar(3000) COLLATE "pg_catalog"."default",
  "exec_time" timestamp(6),
  "del_flag" int2 DEFAULT 0,
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "log_time" timestamp(6),
  "center_apicode" varchar(255) COLLATE "pg_catalog"."default",
  "cqzxbm" varchar(255) COLLATE "pg_catalog"."default",
  "result_code" varchar(255) COLLATE "pg_catalog"."default",
  "result_msg" varchar(500) COLLATE "pg_catalog"."default",
  "ywlsh" varchar(255) COLLATE "pg_catalog"."default",
  "ywlx" varchar(100) COLLATE "pg_catalog"."default",
  "czygh" varchar(255) COLLATE "pg_catalog"."default",
  "czyxm" varchar(255) COLLATE "pg_catalog"."default",
  "title" varchar(255) COLLATE "pg_catalog"."default",
  "sqrxm" varchar(155) COLLATE "pg_catalog"."default",
  "sqbm" varchar(100) COLLATE "pg_catalog"."default",
  "bjbm" varchar(100) COLLATE "pg_catalog"."default",
  "event_code" varchar(100) COLLATE "pg_catalog"."default",
  "event_name" varchar(100) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "sxcl_result" text COLLATE "pg_catalog"."default",
  "jddylx" varchar(100) COLLATE "pg_catalog"."default",
  "xshsxx" int2,
  "req_time" varchar(25) COLLATE "pg_catalog"."default",
  "sxreq_parm" text COLLATE "pg_catalog"."default",
  "business_id" int8,
  "sqrzjhm" varchar(155) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."id" IS '日志id';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."scope_code" IS '数据范围编码';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."module" IS '模块名称';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."operator" IS '操作内容(操作类型)';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."method" IS '方法名称';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."req_method" IS '请求方式';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."req_url" IS '请求URL';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."req_params" IS '请求参数';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."res_result" IS '返回参数';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."res_status" IS '响应状态码';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."error_msg" IS '错误消息';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."exec_time" IS '执行时间(毫秒)';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."del_flag" IS '删除标志(0代表存在 1代表删除)';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."create_by" IS '创建者';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."log_time" IS '记录时间';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."center_apicode" IS '接口编号';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."cqzxbm" IS '发起中心编码';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."result_code" IS '返回代码 200成功 其他失败';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."result_msg" IS '返回消息';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."ywlsh" IS '业务流水号';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."ywlx" IS '业务类型，0-网络办件，1-行政审批一般办件，2-综合窗口办件';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."czygh" IS '操作员工号';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."czyxm" IS '操作员姓名';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."title" IS '标题';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."sqrxm" IS '申请人姓名';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."sqbm" IS '事项申请编码';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."bjbm" IS '事项办件编码';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."event_code" IS '事项编码';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."event_name" IS '事项名称';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."sxcl_result" IS '事项处理响应结果';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."jddylx" IS '一网通办节点调用类型，
apply—办件申请提交、
accept—办件受理、
approval—办件审批、
finish—办件办结、
applyFinish—办件受理申请并提交';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."xshsxx" IS '1-线上，2-线下';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."req_time" IS '事项请求时间';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."sxreq_parm" IS '事项请求参数';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."business_id" IS '业务id';
COMMENT ON COLUMN "public"."wxzj_ywtbjd_log"."sqrzjhm" IS '申请人证件号码';
COMMENT ON TABLE "public"."wxzj_ywtbjd_log" IS '一网通办回调接口节点日志表';

-- ----------------------------
-- Table structure for wxzj_ywtbsqcl_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_ywtbsqcl_file";
CREATE TABLE "public"."wxzj_ywtbsqcl_file" (
  "id" int8 NOT NULL,
  "other_id" int8,
  "sqcl_file_name" varchar(50) COLLATE "pg_catalog"."default",
  "sqcl_file_url" varchar(100) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "update_time" timestamp(6),
  "create_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."other_id" IS '关联业务id';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."sqcl_file_name" IS '申请材料文件名';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."sqcl_file_url" IS '申请材料文件url';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."del_flag" IS '删除标志(0代表存在 1代表删除)';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_ywtbsqcl_file"."tenant_id" IS '租户id';
COMMENT ON TABLE "public"."wxzj_ywtbsqcl_file" IS '一网通办事项申请材料表';

-- ----------------------------
-- Table structure for wxzj_yysq
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_yysq";
CREATE TABLE "public"."wxzj_yysq" (
  "id" int8 NOT NULL,
  "wyqy_id" int8,
  "kfqy" varchar(50) COLLATE "pg_catalog"."default",
  "wygs" varchar(50) COLLATE "pg_catalog"."default",
  "zhyh" varchar(50) COLLATE "pg_catalog"."default",
  "wxlx" int4,
  "wxxm" varchar(255) COLLATE "pg_catalog"."default",
  "jjcd" int2,
  "ftlx" int2,
  "ftfw" varchar(50) COLLATE "pg_catalog"."default",
  "sjfw" int4,
  "ysje" numeric(18,2),
  "sgqy" varchar(50) COLLATE "pg_catalog"."default",
  "zzzs" varchar(255) COLLATE "pg_catalog"."default",
  "hbdw" varchar(50) COLLATE "pg_catalog"."default",
  "khyh" varchar(50) COLLATE "pg_catalog"."default",
  "dwzh" varchar(30) COLLATE "pg_catalog"."default",
  "jgrq" timestamp(6),
  "jddw" varchar(50) COLLATE "pg_catalog"."default",
  "sjdw" varchar(50) COLLATE "pg_catalog"."default",
  "phone" varchar(20) COLLATE "pg_catalog"."default",
  "sqdw" varchar(20) COLLATE "pg_catalog"."default",
  "sqry" varchar(20) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(20) COLLATE "pg_catalog"."default",
  "update_by" varchar(20) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "status" int2,
  "shyj" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_yysq"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_yysq"."kfqy" IS '开发企业';
COMMENT ON COLUMN "public"."wxzj_yysq"."wygs" IS '物业公司';
COMMENT ON COLUMN "public"."wxzj_yysq"."zhyh" IS '专户银行';
COMMENT ON COLUMN "public"."wxzj_yysq"."wxlx" IS '维修类型';
COMMENT ON COLUMN "public"."wxzj_yysq"."wxxm" IS '维修项目';
COMMENT ON COLUMN "public"."wxzj_yysq"."jjcd" IS '紧急程度 01-一般使用 02-紧急使用';
COMMENT ON COLUMN "public"."wxzj_yysq"."ftlx" IS '分摊类型';
COMMENT ON COLUMN "public"."wxzj_yysq"."ftfw" IS '分摊范围';
COMMENT ON COLUMN "public"."wxzj_yysq"."sjfw" IS '涉及房屋数';
COMMENT ON COLUMN "public"."wxzj_yysq"."ysje" IS '预算金额';
COMMENT ON COLUMN "public"."wxzj_yysq"."sgqy" IS '施工企业';
COMMENT ON COLUMN "public"."wxzj_yysq"."zzzs" IS '资质证书';
COMMENT ON COLUMN "public"."wxzj_yysq"."hbdw" IS '划拨单位';
COMMENT ON COLUMN "public"."wxzj_yysq"."khyh" IS '开户银行';
COMMENT ON COLUMN "public"."wxzj_yysq"."dwzh" IS '单位账号';
COMMENT ON COLUMN "public"."wxzj_yysq"."jgrq" IS '竣工日期';
COMMENT ON COLUMN "public"."wxzj_yysq"."jddw" IS '鉴定单位';
COMMENT ON COLUMN "public"."wxzj_yysq"."sjdw" IS '审计单位';
COMMENT ON COLUMN "public"."wxzj_yysq"."phone" IS '联系电话';
COMMENT ON COLUMN "public"."wxzj_yysq"."sqdw" IS '申请单位';
COMMENT ON COLUMN "public"."wxzj_yysq"."sqry" IS '申请人员';
COMMENT ON COLUMN "public"."wxzj_yysq"."dept_id" IS '部门id';
COMMENT ON COLUMN "public"."wxzj_yysq"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_yysq"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_yysq"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_yysq"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_yysq"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_yysq"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_yysq"."status" IS '状态 01-待审核 02-已通过 03-驳回';
COMMENT ON COLUMN "public"."wxzj_yysq"."shyj" IS '审核意见';
COMMENT ON TABLE "public"."wxzj_yysq" IS '预用申请表';

-- ----------------------------
-- Table structure for wxzj_yz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_yz";
CREATE TABLE "public"."wxzj_yz" (
  "id" int8 NOT NULL,
  "yz" varchar(300) COLLATE "pg_catalog"."default",
  "zjlx" int2,
  "zjhm" varchar(1000) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "bz" varchar(225) COLLATE "pg_catalog"."default",
  "fhzh_id" int8,
  "yzlx" int2,
  "sjhm" varchar(100) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_yz"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_yz"."yz" IS '业主';
COMMENT ON COLUMN "public"."wxzj_yz"."zjlx" IS '证件类型 111-居民身份证 112 -临时居民身份证  335-机动车驾驶证 336-机动车临时驾驶许可证 414-普通护照 511-台湾居民来往大陆通行证（多次有效） 512-台湾居民来往大陆通行证（一次有效） 516-港澳居民来来往内地通行证 552-台湾居民定居证 553-外国人永久居留证 554-外国人居留证或居留许可 555-外国人临时居留证 611-工商营业执照 612-组织机构代码证 613-税务登记证';
COMMENT ON COLUMN "public"."wxzj_yz"."zjhm" IS '证件号码';
COMMENT ON COLUMN "public"."wxzj_yz"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_yz"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_yz"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_yz"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_yz"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_yz"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_yz"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_yz"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_yz"."yzlx" IS '业主类型(1-自然人，2-非自然人)';
COMMENT ON COLUMN "public"."wxzj_yz"."sjhm" IS '手机号码';
COMMENT ON TABLE "public"."wxzj_yz" IS '房屋业主表';

-- ----------------------------
-- Table structure for wxzj_yztpb
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_yztpb";
CREATE TABLE "public"."wxzj_yztpb" (
  "open_id" varchar(100) COLLATE "pg_catalog"."default",
  "tpzt" int2,
  "tp_id" int8,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "id" int8 NOT NULL,
  "fw_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_yztpb"."open_id" IS 'open_id';
COMMENT ON COLUMN "public"."wxzj_yztpb"."tpzt" IS '投票状态 0-未投票 1-已投票';
COMMENT ON COLUMN "public"."wxzj_yztpb"."tp_id" IS '投票id';
COMMENT ON COLUMN "public"."wxzj_yztpb"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_yztpb"."fw_id" IS '房屋id';
COMMENT ON TABLE "public"."wxzj_yztpb" IS '业主投票表';

-- ----------------------------
-- Table structure for wxzj_yzwyh
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_yzwyh";
CREATE TABLE "public"."wxzj_yzwyh" (
  "id" int8 NOT NULL,
  "yzwyhmc" varchar(100) COLLATE "pg_catalog"."default",
  "wyqy_id" int8,
  "bazh" varchar(30) COLLATE "pg_catalog"."default",
  "yzwyhjs" int2,
  "clsj" date,
  "djsj" date,
  "yzwyhxm" varchar(20) COLLATE "pg_catalog"."default",
  "zjlx" int2,
  "zjhm" varchar(20) COLLATE "pg_catalog"."default",
  "lxdh" varchar(20) COLLATE "pg_catalog"."default",
  "cz" varchar(20) COLLATE "pg_catalog"."default",
  "dzyx" varchar(100) COLLATE "pg_catalog"."default",
  "txdz" varchar(200) COLLATE "pg_catalog"."default",
  "zzxx" varchar(255) COLLATE "pg_catalog"."default",
  "yhzh_id" int8,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "zt" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_yzwyh"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."yzwyhmc" IS '业主委员会名称';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."wyqy_id" IS '物业服务区域id';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."bazh" IS '备案证号';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."yzwyhjs" IS '业主委员会届数';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."clsj" IS '成立时间';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."djsj" IS '到届时间';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."yzwyhxm" IS '业主委员姓名';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."zjlx" IS '证件类型 111-居民身份证
112 -临时居民身份证 
335-机动车驾驶证
336-机动车临时驾驶许可证
414-普通护照
511-台湾居民来往大陆通行证（多次有效）
512-台湾居民来往大陆通行证（一次有效）
516-港澳居民来来往内地通行证
552-台湾居民定居证
553-外国人永久居留证
554-外国人居留证或居留许可
555-外国人临时居留证';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."zjhm" IS '证件号码';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."lxdh" IS '联系电话';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."cz" IS '传真';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."dzyx" IS '电子邮箱';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."txdz" IS '通讯地址';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."zzxx" IS '证照信息';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."yhzh_id" IS '银行账户信息id';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_yzwyh"."zt" IS '状态';
COMMENT ON TABLE "public"."wxzj_yzwyh" IS '业主委员会';

-- ----------------------------
-- Table structure for wxzj_zhcx
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhcx";
CREATE TABLE "public"."wxzj_zhcx" (
  "id" int8 NOT NULL,
  "xzqh_id" int8,
  "xzqhdm" varchar(255) COLLATE "pg_catalog"."default",
  "wyqy_id" int8,
  "wyqydm" varchar(255) COLLATE "pg_catalog"."default",
  "lzmc" varchar(50) COLLATE "pg_catalog"."default",
  "dymc" varchar(200) COLLATE "pg_catalog"."default",
  "sh" varchar(20) COLLATE "pg_catalog"."default",
  "fwlx" int2,
  "fwyt" int2,
  "fhzh" int8,
  "jcje_zxz" numeric(15,2),
  "fhzhye_zxz" numeric(18,2),
  "fhzhsyje_zxz" numeric(18,2),
  "zzje_zxz" numeric(18,2),
  "tkje_zxz" numeric(18,2),
  "jzmj_zxz" numeric(15,2),
  "yz" varchar(50) COLLATE "pg_catalog"."default",
  "zjhm" varchar(20) COLLATE "pg_catalog"."default",
  "cxrqks" timestamp(6),
  "fhzhzt" int2,
  "user_id" int8,
  "query_type" int2,
  "fwmc" varchar(200) COLLATE "pg_catalog"."default",
  "fwdm" varchar(25) COLLATE "pg_catalog"."default",
  "fwjzdm" varchar(18) COLLATE "pg_catalog"."default",
  "xxdz" varchar(200) COLLATE "pg_catalog"."default",
  "wqbm" varchar(26) COLLATE "pg_catalog"."default",
  "bdcdybm" varchar(50) COLLATE "pg_catalog"."default",
  "hxjg" int2,
  "query_name" varchar(50) COLLATE "pg_catalog"."default",
  "tzdlx" int2,
  "tzdzt" int2,
  "fsje" numeric(18,2),
  "tzdfskssj" timestamp(6),
  "tzdfsjssj" timestamp(6),
  "yhqrkssj" timestamp(6),
  "yhqrjssj" timestamp(6),
  "yhzh_id" int8,
  "zy" varchar(255) COLLATE "pg_catalog"."default",
  "zghdg" int2,
  "zddm" varchar(20) COLLATE "pg_catalog"."default",
  "ghxkzny" date,
  "sgxkzny" date,
  "jgrq" date,
  "zjzmj_zxz" numeric(15,2),
  "zfws_zxz" int2,
  "zlzs_zxz" int2,
  "zjdplx" int2,
  "zzlx" int2,
  "zjzt" int2,
  "ftzt" int2,
  "ftrqks" timestamp(6),
  "qcrqks" timestamp(6),
  "dqrqks" timestamp(6),
  "qszx" int2,
  "zcjezx" numeric,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "spbh" varchar(255) COLLATE "pg_catalog"."default",
  "sylx" int2,
  "syqrsj_zdz" timestamp(6),
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT now(),
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "wyqylx" int2,
  "jdmj_zxz" numeric,
  "lzytlx" int2,
  "zjlx" int2,
  "zhmc" varchar(50) COLLATE "pg_catalog"."default",
  "zhzh" varchar(30) COLLATE "pg_catalog"."default",
  "yhmc" varchar(50) COLLATE "pg_catalog"."default",
  "kfjsdw_id" int8,
  "skzhkhh" varchar(50) COLLATE "pg_catalog"."default",
  "skzhhm" varchar(50) COLLATE "pg_catalog"."default",
  "skzhzh" varchar(255) COLLATE "pg_catalog"."default",
  "wyfwqy_id" int8,
  "zfws_zdz" int2,
  "zjzmj_zdz" numeric(15,2),
  "zlzs_zdz" int2,
  "jdmj_zdz" varchar(255) COLLATE "pg_catalog"."default",
  "ftrqjs" timestamp(6),
  "qcrqjs" timestamp(6),
  "dqrqjs" timestamp(6),
  "qszd" int2,
  "zcjezd" numeric(15,2),
  "jcje_zdz" numeric(15,2),
  "fhzhye_zdz" numeric(15,2),
  "fhzhsyje_zdz" numeric(15,2),
  "zzje_zdz" numeric(15,2),
  "tkje_zdz" numeric(15,2),
  "jzmj_zdz" numeric(15,2),
  "yjje_zxz" numeric(15,2),
  "yjje_zdz" numeric(15,2),
  "syqrsj_zxz" timestamp(6),
  "shouyije_zxz" numeric(15,2),
  "shouyije_zdz" numeric(15,2),
  "sgdw_id" int8,
  "sjdw_id" int8,
  "xmzje_zxz" numeric(15,2),
  "xmzje_zdz" numeric(15,2),
  "wylx" int2,
  "zhdbh" varchar(50) COLLATE "pg_catalog"."default",
  "zjsyzt" int2,
  "shiyonlx" int2,
  "wxxmcjqrks" timestamp(6),
  "wxxmcjqrjs" timestamp(6),
  "sbrqks" timestamp(6),
  "sbrqjs" timestamp(6),
  "xmmc" varchar(50) COLLATE "pg_catalog"."default",
  "xmzt" int2,
  "cxrqjs" timestamp(6),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zhcx"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_zhcx"."xzqh_id" IS '行政区划主键id';
COMMENT ON COLUMN "public"."wxzj_zhcx"."xzqhdm" IS '行政区划代码';
COMMENT ON COLUMN "public"."wxzj_zhcx"."wyqy_id" IS '物业区域主键id';
COMMENT ON COLUMN "public"."wxzj_zhcx"."wyqydm" IS '物业区域代码 行政区划代码应为9位，即前6位为县级行政区划代码，后3位为街道(乡镇)代码，当无法细到街道(乡镇)时，后3位可为0；序列代码位数应为6位，不足位前面补0。';
COMMENT ON COLUMN "public"."wxzj_zhcx"."lzmc" IS '楼幢名称';
COMMENT ON COLUMN "public"."wxzj_zhcx"."dymc" IS '单元名称';
COMMENT ON COLUMN "public"."wxzj_zhcx"."sh" IS '室号';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fwlx" IS '房屋类型 
0-全部
1-住宅
2-商业用房
  3-办公用房
  4-工业用房
  5-仓储用房
  6-车库
  7-商业展馆
  8-体育场馆
  9-其他';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fwyt" IS '房屋用途 
0-全部
1-住宅
    2-工业、交通、仓储
    3-商业、金融、信息
    4-教育、医疗、卫生、科研
    5-文化、娱乐、体育
    6-办公
    7-军事 
    8-其他';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fhzh" IS '分户账号';
COMMENT ON COLUMN "public"."wxzj_zhcx"."jcje_zxz" IS '缴存金额（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fhzhye_zxz" IS '分户账户余额（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fhzhsyje_zxz" IS '分户账户使用金额（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zzje_zxz" IS '增值金额（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."tkje_zxz" IS '退款金额（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."jzmj_zxz" IS '建筑面积（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."yz" IS '业主';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zjhm" IS '证件号码';
COMMENT ON COLUMN "public"."wxzj_zhcx"."cxrqks" IS '查询日期（开始时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fhzhzt" IS '分户账户状态 0-全部 1-未交 2-正常  3-余额不足';
COMMENT ON COLUMN "public"."wxzj_zhcx"."user_id" IS '用户id';
COMMENT ON COLUMN "public"."wxzj_zhcx"."query_type" IS '查询类型，1-物业区域查询 2-房屋信息查询 3-通知单查询 4-资金调配查询 5-维修项目查询 6-分户账户信息查询 7-资金利息查询 8-资金收益查询';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fwmc" IS '房屋名称';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fwdm" IS '房屋代码';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fwjzdm" IS '房屋建筑代码 (房屋建筑统一编码与基本属性数据标准)';
COMMENT ON COLUMN "public"."wxzj_zhcx"."xxdz" IS '详细地址';
COMMENT ON COLUMN "public"."wxzj_zhcx"."wqbm" IS '网签编码 (全国房屋网签备案业务数据标准)';
COMMENT ON COLUMN "public"."wxzj_zhcx"."bdcdybm" IS '不动产单元代码';
COMMENT ON COLUMN "public"."wxzj_zhcx"."hxjg" IS '户型结构 0-全部 1-平层  2-错层  3-复式楼  4-跃层  5-其他';
COMMENT ON COLUMN "public"."wxzj_zhcx"."query_name" IS '常用查询名称';
COMMENT ON COLUMN "public"."wxzj_zhcx"."tzdlx" IS '通知单类型  1-单户交存  2-批量交存 ';
COMMENT ON COLUMN "public"."wxzj_zhcx"."tzdzt" IS '通知单状态  0-待支付 1-支付中 2-已支付 3-已复核 4-已撤销';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fsje" IS '发生金额';
COMMENT ON COLUMN "public"."wxzj_zhcx"."tzdfskssj" IS '通知单发送开始时间';
COMMENT ON COLUMN "public"."wxzj_zhcx"."tzdfsjssj" IS '通知单发送结束时间';
COMMENT ON COLUMN "public"."wxzj_zhcx"."yhqrkssj" IS '银行确认开始时间';
COMMENT ON COLUMN "public"."wxzj_zhcx"."yhqrjssj" IS '银行确认结束时间';
COMMENT ON COLUMN "public"."wxzj_zhcx"."yhzh_id" IS '银行账户主键id';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zy" IS '摘要';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zghdg" IS '自管或代管(1-自管 ，2- 代管)';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zddm" IS '宗地代码';
COMMENT ON COLUMN "public"."wxzj_zhcx"."ghxkzny" IS '规划许可证年月';
COMMENT ON COLUMN "public"."wxzj_zhcx"."sgxkzny" IS '施工许可证年月';
COMMENT ON COLUMN "public"."wxzj_zhcx"."jgrq" IS '竣工日期';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zjzmj_zxz" IS '总建筑面积（数量最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zfws_zxz" IS '总房屋数（数量最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zlzs_zxz" IS '总楼幢数（数量最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zjdplx" IS '资金调配类型 0-全部 1-使用备案 2-竣工验收 3-质量保证';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zzlx" IS '增值类型 0-全部 1-定期- 2-国债';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zjzt" IS '资金状态 0-全部 1-未转出 2-已转出 3-已转回';
COMMENT ON COLUMN "public"."wxzj_zhcx"."ftzt" IS '是否分摊 0-全部 1-未分摊 2-分摊中 3-已分摊';
COMMENT ON COLUMN "public"."wxzj_zhcx"."ftrqks" IS '分摊日期（最小时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."qcrqks" IS '起存日期（最小时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."dqrqks" IS '到期日期（最小时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."qszx" IS '期数(最小期数）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zcjezx" IS '转存金额（最小金额）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."qr_order_no" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_zhcx"."spbh" IS '审批编号';
COMMENT ON COLUMN "public"."wxzj_zhcx"."sylx" IS '收益类型 0-全部 1-经营收入 2-公共设施收入';
COMMENT ON COLUMN "public"."wxzj_zhcx"."syqrsj_zdz" IS '收益确认时间（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."del_flag" IS '逻辑删除，0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_zhcx"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhcx"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_zhcx"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhcx"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhcx"."wyqylx" IS '物业区域类型  01-商品房 
02-公有售房 
03-新居工程
04-拆迁安置房
05-单一产权人
06-统规自建房
07-征地拆迁房
08-商业非住宅
09-其他非住宅
10-保障性住房
11-全额集资建房
12-农村集中居住区
99-其他';
COMMENT ON COLUMN "public"."wxzj_zhcx"."jdmj_zxz" IS '基底面积（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."lzytlx" IS '楼幢用途类型
0-全部
1-住宅 
2-非住宅
3-商住综合';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zjlx" IS '证件类型 111-居民身份证 112 -临时居民身份证  335-机动车驾驶证 336-机动车临时驾驶许可证 414-普通护照 511-台湾居民来往大陆通行证（多次有效） 512-台湾居民来往大陆通行证（一次有效） 516-港澳居民来来往内地通行证 552-台湾居民定居证 553-外国人永久居留证 554-外国人居留证或居留许可 555-外国人临时居留证';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zhmc" IS '专户名称';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zhzh" IS '专户账号';
COMMENT ON COLUMN "public"."wxzj_zhcx"."yhmc" IS '专户银行名称';
COMMENT ON COLUMN "public"."wxzj_zhcx"."kfjsdw_id" IS '机构主键id(开发建设单位id)';
COMMENT ON COLUMN "public"."wxzj_zhcx"."skzhkhh" IS '收款银行专户名称';
COMMENT ON COLUMN "public"."wxzj_zhcx"."skzhhm" IS '收款银行户名';
COMMENT ON COLUMN "public"."wxzj_zhcx"."skzhzh" IS '收款银行账号';
COMMENT ON COLUMN "public"."wxzj_zhcx"."wyfwqy_id" IS '机构id(物业服务企业id)';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zfws_zdz" IS '总房屋数（数量最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zjzmj_zdz" IS '总建筑面积（数量最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zlzs_zdz" IS '总楼幢数（数量最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."jdmj_zdz" IS '基底面积（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."ftrqjs" IS '分摊日期（最大时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."qcrqjs" IS '起存日期（最大时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."dqrqjs" IS '到期日期（最大时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."qszd" IS '期数(最大期数）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zcjezd" IS '转存金额（最大金额）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."jcje_zdz" IS '缴存金额（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fhzhye_zdz" IS '分户账户余额（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."fhzhsyje_zdz" IS '分户账户使用金额（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zzje_zdz" IS '增值金额（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."tkje_zdz" IS '退款金额（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."jzmj_zdz" IS '建筑面积（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."yjje_zxz" IS '应交金额（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."yjje_zdz" IS '应交金额（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."syqrsj_zxz" IS '收益确认时间（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."shouyije_zxz" IS '收益金额（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."shouyije_zdz" IS '收益金额（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."sgdw_id" IS '施工单位id';
COMMENT ON COLUMN "public"."wxzj_zhcx"."sjdw_id" IS '审价单位id';
COMMENT ON COLUMN "public"."wxzj_zhcx"."xmzje_zxz" IS '项目总金额（最小值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."xmzje_zdz" IS '项目总金额（最大值）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."wylx" IS '物业类型(1-住宅物业 2-非住宅物业 3-商住综合物业)';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zhdbh" IS '通知单编号';
COMMENT ON COLUMN "public"."wxzj_zhcx"."zjsyzt" IS '（项目状态）资金使用状态 - 1-未提交 2-待审核 3-通过 4-驳回';
COMMENT ON COLUMN "public"."wxzj_zhcx"."shiyonlx" IS '资金使用类型 1-一般使用 2-紧急使用';
COMMENT ON COLUMN "public"."wxzj_zhcx"."wxxmcjqrks" IS '维修项目创建日期（开始时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."wxxmcjqrjs" IS '维修项目创建日期（结束时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."sbrqks" IS '维修项目申报日期（开始时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."sbrqjs" IS '维修项目申报日期（结束时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."xmmc" IS '项目名称';
COMMENT ON COLUMN "public"."wxzj_zhcx"."xmzt" IS '维修项目状态 - 1-未提交 2-待审核 3-通过 4-驳回';
COMMENT ON COLUMN "public"."wxzj_zhcx"."cxrqjs" IS '查询日期（结束时间）';
COMMENT ON COLUMN "public"."wxzj_zhcx"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_zhcx" IS '综合查询，查询条件';

-- ----------------------------
-- Table structure for wxzj_zhfw_fj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_fj";
CREATE TABLE "public"."wxzj_zhfw_fj" (
  "id" int8 NOT NULL,
  "glzy_id" int8,
  "fjurl" text COLLATE "pg_catalog"."default",
  "fjm" varchar(100) COLLATE "pg_catalog"."default",
  "lx" int2,
  "del_flag" int2 DEFAULT 0,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_fj"."id" IS 'id';
COMMENT ON COLUMN "public"."wxzj_zhfw_fj"."glzy_id" IS '关联资源id';
COMMENT ON COLUMN "public"."wxzj_zhfw_fj"."fjurl" IS '附件url';
COMMENT ON COLUMN "public"."wxzj_zhfw_fj"."fjm" IS '附件名';
COMMENT ON COLUMN "public"."wxzj_zhfw_fj"."lx" IS '类型 1-公示附件 ，2-投票附件';
COMMENT ON COLUMN "public"."wxzj_zhfw_fj"."del_flag" IS '0-正常   1-删除';
COMMENT ON COLUMN "public"."wxzj_zhfw_fj"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_zhfw_fj" IS '附件表';

-- ----------------------------
-- Table structure for wxzj_zhfw_fwxx
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_fwxx";
CREATE TABLE "public"."wxzj_zhfw_fwxx" (
  "id" int8 NOT NULL,
  "gsxx_id" int8,
  "fwmc" varchar(200) COLLATE "pg_catalog"."default",
  "yzmc" varchar(50) COLLATE "pg_catalog"."default",
  "fwmj" numeric(16,2),
  "zhye" numeric(18,2),
  "ftje" numeric(16,2),
  "tpqk" int2 DEFAULT 0,
  "yzid" int8,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2,
  "fwid" int8,
  "tptjsj" timestamp(6),
  "lxdh" varchar(100) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."id" IS 'id';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."gsxx_id" IS '关联id';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."fwmc" IS '房屋名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."yzmc" IS '业主名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."fwmj" IS '房屋面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."zhye" IS '账户余额';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."ftje" IS '分摊金额';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."tpqk" IS '投票情况 0-未投票 1-同意,2-不同意,3-弃票';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."yzid" IS '业主id，关联业主信息表';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."del_flag" IS '逻辑删除   0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."fwid" IS '房屋id';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."tptjsj" IS '投票提交时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_fwxx"."lxdh" IS '联系电话';
COMMENT ON TABLE "public"."wxzj_zhfw_fwxx" IS '综合服务-房屋信息表';

-- ----------------------------
-- Table structure for wxzj_zhfw_gljg
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_gljg";
CREATE TABLE "public"."wxzj_zhfw_gljg" (
  "id" int8 NOT NULL,
  "xzqh" varchar(20) COLLATE "pg_catalog"."default",
  "xzqh_id" int8,
  "jgmc" varchar(50) COLLATE "pg_catalog"."default",
  "dwfwnr" varchar(255) COLLATE "pg_catalog"."default",
  "jgdz" varchar(255) COLLATE "pg_catalog"."default",
  "zxdh" varchar(255) COLLATE "pg_catalog"."default",
  "gzsj" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 NOT NULL DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."xzqh" IS '行政区划';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."xzqh_id" IS '行政区划id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."jgmc" IS '机构名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."dwfwnr" IS '对外服务内容';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."jgdz" IS '机构地址';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."zxdh" IS '咨询电话';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."gzsj" IS '工作时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_gljg"."del_flag" IS '逻辑删除  0-正常   1-删除';
COMMENT ON TABLE "public"."wxzj_zhfw_gljg" IS '公共服务管理机构表';

-- ----------------------------
-- Table structure for wxzj_zhfw_gs_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_gs_log";
CREATE TABLE "public"."wxzj_zhfw_gs_log" (
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "cznr" varchar(50) COLLATE "pg_catalog"."default",
  "gs_id" varchar(50) COLLATE "pg_catalog"."default",
  "id" int8 NOT NULL,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_gs_log"."create_time" IS '操作时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gs_log"."create_by" IS '操作人';
COMMENT ON COLUMN "public"."wxzj_zhfw_gs_log"."cznr" IS '操作内容';
COMMENT ON COLUMN "public"."wxzj_zhfw_gs_log"."gs_id" IS '公示id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gs_log"."id" IS 'id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gs_log"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_zhfw_gs_log" IS '公示日志表';

-- ----------------------------
-- Table structure for wxzj_zhfw_gsxx
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_gsxx";
CREATE TABLE "public"."wxzj_zhfw_gsxx" (
  "id" int8 NOT NULL,
  "gsmc" varchar(50) COLLATE "pg_catalog"."default",
  "gsms" varchar(200) COLLATE "pg_catalog"."default",
  "gsfqsj" timestamp(6),
  "gsjssj" timestamp(6),
  "fqr" varchar(50) COLLATE "pg_catalog"."default",
  "gslx" int2,
  "wyqy_id" int8,
  "sssblx" varchar(50) COLLATE "pg_catalog"."default",
  "yjsyje" numeric(18,2),
  "syzje" numeric(18,2),
  "sgdw_id" int8,
  "yjsgsj" timestamp(6),
  "yjsgyssj" timestamp(6),
  "wxxmmj" numeric(15,2),
  "sjdw_id" int8,
  "gszt" int2,
  "ysry" varchar(50) COLLATE "pg_catalog"."default",
  "ysqk" varchar(200) COLLATE "pg_catalog"."default",
  "glzy_id" int8,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2,
  "xmbh" int8,
  "sylx" int2,
  "llcs" int4 DEFAULT 0,
  "ftfs" int4,
  "sgkssj" timestamp(6),
  "sgjssj" timestamp(6),
  "tpkssj" timestamp(6),
  "tpjssj" timestamp(6),
  "tpjg" int2 DEFAULT '-1'::integer,
  "tprs" int2 DEFAULT 0,
  "tptyrs" int2 DEFAULT 0,
  "tpfdrs" int2 DEFAULT 0,
  "tyrszb" numeric(16,2) DEFAULT 0,
  "fdrszb" numeric(16,2) DEFAULT 0,
  "fdfwmjzb" numeric(16,2) DEFAULT 0,
  "tyfwmjzb" numeric(16,2) DEFAULT 0,
  "tpfqr" varchar(50) COLLATE "pg_catalog"."default" DEFAULT ''::character varying,
  "qprs" int2 DEFAULT 0,
  "qprszb" numeric(16,2) DEFAULT 0,
  "qpfwmjzb" numeric(16,2) DEFAULT 0,
  "tpmc" varchar(64) COLLATE "pg_catalog"."default",
  "tpqpfwmj" numeric(16,2) DEFAULT 0,
  "tptyfwmj" numeric(16,2) DEFAULT 0,
  "tpfdfwmj" numeric(16,2) DEFAULT 0,
  "tpmj" numeric(16,2) DEFAULT 0,
  "glzt" int2,
  "sssblx_id" int8,
  "xszt" int2,
  "xmsgje" numeric(16,2),
  "xmsjje" numeric(16,2)
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."id" IS 'id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."gsmc" IS '公示名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."gsms" IS '公示描述';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."gsfqsj" IS '公示发起时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."gsjssj" IS '公示结束时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."fqr" IS '发起人';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."gslx" IS '公示类型   0-使用方案，1-项目投票，2-项目验收.';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."sssblx" IS '设施设备类型';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."yjsyje" IS '预计使用金额';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."syzje" IS '使用总金额';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."sgdw_id" IS '施工单位id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."yjsgsj" IS '预计施工时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."yjsgyssj" IS '预计施工验收时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."wxxmmj" IS '维修项目面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."sjdw_id" IS '审价单位id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."gszt" IS '公示状态   0-未发布，1-未公示，2-进行中，3-已结束';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."ysry" IS '验收人员';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."ysqk" IS '验收情况  ';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."glzy_id" IS '关联资源表id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."del_flag" IS '逻辑删除';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."xmbh" IS '项目编号';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."sylx" IS '使用类型 1-一般使用， 2-紧急使用';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."llcs" IS '浏览次数';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."ftfs" IS '分摊方式 1线上分摊，2线下分摊';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."sgkssj" IS '施工开始时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."sgjssj" IS '施工结束时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpkssj" IS '投票开始时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpjssj" IS '投票结束时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpjg" IS '投票结果：0-未通过   1-通过 ';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tprs" IS '投票人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tptyrs" IS '投票同意人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpfdrs" IS '投票反对人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tyrszb" IS '同意人数占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."fdrszb" IS '反对人数占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."fdfwmjzb" IS '反对人数房屋面积占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tyfwmjzb" IS '同意人数房屋面积占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpfqr" IS '投票发起人';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."qprs" IS '弃票人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."qprszb" IS '弃票人数占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."qpfwmjzb" IS '弃票人数房屋面积占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpmc" IS '投票名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpqpfwmj" IS '弃票人数房屋面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tptyfwmj" IS '同意人数房屋面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpfdfwmj" IS '反对人数房屋面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."tpmj" IS '投票面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."glzt" IS '关联状态 0-没被关联1-已被关联';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."sssblx_id" IS '设施设备类型id';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."xszt" IS '显示状态 0-显示 1-隐藏';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."xmsgje" IS '项目施工金额';
COMMENT ON COLUMN "public"."wxzj_zhfw_gsxx"."xmsjje" IS '项目审价金额';
COMMENT ON TABLE "public"."wxzj_zhfw_gsxx" IS '综合服务-公示信息表';

-- ----------------------------
-- Table structure for wxzj_zhfw_hdp
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_hdp";
CREATE TABLE "public"."wxzj_zhfw_hdp" (
  "id" int8 NOT NULL,
  "hdpbt" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "xwdt_id" int8,
  "sx" int2,
  "zt" int2 NOT NULL DEFAULT 1,
  "lbtp" text COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 NOT NULL DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."hdpbt" IS '幻灯片标题';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."xwdt_id" IS '关联新闻动态Id';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."sx" IS '顺序';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."zt" IS '状态 0-隐藏、1-显示';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."lbtp" IS '轮播图片';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_hdp"."del_flag" IS '逻辑删除  0-正常   1-删除';
COMMENT ON TABLE "public"."wxzj_zhfw_hdp" IS '门户幻灯片表';

-- ----------------------------
-- Table structure for wxzj_zhfw_tp
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_tp";
CREATE TABLE "public"."wxzj_zhfw_tp" (
  "id" int8 NOT NULL,
  "tpmc" varchar(50) COLLATE "pg_catalog"."default",
  "tpms" text COLLATE "pg_catalog"."default",
  "fqr" varchar(50) COLLATE "pg_catalog"."default",
  "tplx" int2,
  "tpkssj" timestamp(6),
  "tpjssj" timestamp(6),
  "glzy_id" int8,
  "url" text COLLATE "pg_catalog"."default",
  "tpzt" int2 DEFAULT '-1'::integer,
  "tpjg" int2 DEFAULT '-1'::integer,
  "tprs" int2 DEFAULT 0,
  "tptyrs" int2 DEFAULT 0,
  "tpfdrs" int2 DEFAULT 0,
  "tyrszb" numeric(16,2) DEFAULT 0,
  "fdrszb" numeric(16,2) DEFAULT 0,
  "fdfwmjzb" numeric(16,2) DEFAULT 0,
  "tyfwmjzb" numeric(16,2) DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 DEFAULT 0,
  "qprs" int2 DEFAULT 0,
  "qprszb" numeric(16,2) DEFAULT 0,
  "qpfwmjzb" numeric(16,2) DEFAULT 0,
  "wtprs" int2 DEFAULT 0,
  "wtprszb" numeric(16,2) DEFAULT 0,
  "wtpfwmjzb" numeric(16,2) DEFAULT 0,
  "wyqy_id" int8,
  "sssblx" varchar(50) COLLATE "pg_catalog"."default",
  "yjsyje" numeric(18,2),
  "sjsyje" numeric(18,2),
  "sgdw_id" int8,
  "yjsgsj" timestamp(6),
  "yjsgyssj" timestamp(6),
  "wxxmmj" numeric(16,2),
  "sjdw_id" int8,
  "xzqy_id" int8,
  "sjwcsj" timestamp(6),
  "ftfs" int4,
  "tpqpfwmj" numeric(16,2) DEFAULT 0,
  "tptyfwmj" numeric(16,2) DEFAULT 0,
  "tpfdfwmj" numeric(16,2) DEFAULT 0,
  "tpmj" numeric(16,2) DEFAULT 0,
  "glzt" int2 DEFAULT 0,
  "sssblx_id" int8,
  "xmsgje" numeric(16,2),
  "xmsjje" numeric(16,2)
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpmc" IS '投票名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpms" IS '投票描述';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."fqr" IS '发起人';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tplx" IS '投票类型，1-维修资金使用 2-维修项目验收';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpkssj" IS '投票开始时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpjssj" IS '投票结束时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."glzy_id" IS '关联资源id';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."url" IS '附件存url
';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpzt" IS '投票状态：0-已发布 1-进行中   2-已完成  -1-未发布 ';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpjg" IS '投票结果：0-未通过   1-通过 ';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tprs" IS '投票人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tptyrs" IS '投票同意人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpfdrs" IS '投票反对人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tyrszb" IS '同意人数占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."fdrszb" IS '反对人数占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."fdfwmjzb" IS '反对人数房屋面积占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tyfwmjzb" IS '同意人数房屋面积占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."del_flag" IS '0-正常   1-删除';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."qprs" IS '弃票人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."qprszb" IS '弃票人数占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."qpfwmjzb" IS '弃票人数房屋面积占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."wtprs" IS '未投票人数';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."wtprszb" IS '未投票人数占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."wtpfwmjzb" IS '未投票人数房屋面积占比';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."sssblx" IS '设施设备类型id';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."yjsyje" IS '预计使用金额';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."sjsyje" IS '实际使用金额';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."sgdw_id" IS '施工单位id';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."yjsgsj" IS '预计施工时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."yjsgyssj" IS '预计施工验收时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."wxxmmj" IS '维修项目面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."sjdw_id" IS '审价单位id';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."xzqy_id" IS '行政区域id';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."sjwcsj" IS '实际完成时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."ftfs" IS '分摊方式 1线上分摊，2线下分摊';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpqpfwmj" IS '弃票人数房屋面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tptyfwmj" IS '同意人数房屋面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpfdfwmj" IS '反对人数房屋面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."tpmj" IS '投票面积';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."glzt" IS '关联状态 0-没被关联1-已被关联';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."sssblx_id" IS '设施设备类型id';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."xmsgje" IS '项目施工金额';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp"."xmsjje" IS '项目审价金额';
COMMENT ON TABLE "public"."wxzj_zhfw_tp" IS '综合服务-投票信息表';

-- ----------------------------
-- Table structure for wxzj_zhfw_tp_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_tp_log";
CREATE TABLE "public"."wxzj_zhfw_tp_log" (
  "create_time" timestamp(6) DEFAULT now(),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "cznr" varchar(50) COLLATE "pg_catalog"."default",
  "id" int8 NOT NULL,
  "tp_id" int8,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_tp_log"."create_time" IS '操作时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp_log"."create_by" IS '操作人';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp_log"."cznr" IS '操作内容';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp_log"."tp_id" IS '投票id';
COMMENT ON COLUMN "public"."wxzj_zhfw_tp_log"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_zhfw_tp_log" IS '综合服务-投票-操作日志';

-- ----------------------------
-- Table structure for wxzj_zhfw_xglj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_xglj";
CREATE TABLE "public"."wxzj_zhfw_xglj" (
  "id" int8 NOT NULL,
  "ljmc" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "ljdz" text COLLATE "pg_catalog"."default",
  "ms" varchar(200) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 NOT NULL DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."ljmc" IS '链接名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."ljdz" IS '链接地址';
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."ms" IS '描述';
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_xglj"."del_flag" IS '逻辑删除  0-正常   1-删除';
COMMENT ON TABLE "public"."wxzj_zhfw_xglj" IS '相关链接表';

-- ----------------------------
-- Table structure for wxzj_zhfw_xwdt
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_xwdt";
CREATE TABLE "public"."wxzj_zhfw_xwdt" (
  "id" int8 NOT NULL,
  "xwfbsj" timestamp(6),
  "fbr" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "xwbt" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "fbzt" varchar(16) COLLATE "pg_catalog"."default",
  "xwnr" text COLLATE "pg_catalog"."default" NOT NULL,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 NOT NULL DEFAULT 0,
  "xwms" varchar(255) COLLATE "pg_catalog"."default",
  "xwfl_id" int8,
  "ly" varchar(100) COLLATE "pg_catalog"."default",
  "djl" int8 DEFAULT 0,
  "zt" int2 DEFAULT 0,
  "zd" int4 DEFAULT 0,
  "bz" text COLLATE "pg_catalog"."default",
  "fwfw" varchar(255) COLLATE "pg_catalog"."default",
  "xwflmc" varchar(50) COLLATE "pg_catalog"."default",
  "zd_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."xwfbsj" IS '新闻发布时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."fbr" IS '作者';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."xwbt" IS '新闻标题';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."fbzt" IS '发布状态: 1-已发布 2-未发布
';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."xwnr" IS '新闻内容';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."del_flag" IS '逻辑删除  0-正常   1-删除';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."xwms" IS '新闻描述';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."xwfl_id" IS '新闻分类id';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."ly" IS '来源';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."djl" IS '点击量';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."zt" IS '状态 0-启用 1-停用';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."zd" IS '置顶 0-未置顶，1-已置顶';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."fwfw" IS '办事指南 服务范围 0-施工单位、1-业委会、2-开发建设单位、3-审价单位、4-业主';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."xwflmc" IS '新闻分类名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwdt"."zd_time" IS '置顶时间';
COMMENT ON TABLE "public"."wxzj_zhfw_xwdt" IS '新闻动态表';

-- ----------------------------
-- Table structure for wxzj_zhfw_xwfj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_xwfj";
CREATE TABLE "public"."wxzj_zhfw_xwfj" (
  "id" int8 NOT NULL,
  "glxw_id" int8,
  "fjm" text COLLATE "pg_catalog"."default",
  "fj_url" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(0) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."glxw_id" IS '关联新闻id';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."fjm" IS '附件名';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."fj_url" IS '附件地址';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfj"."del_flag" IS '0-正常   1-删除';
COMMENT ON TABLE "public"."wxzj_zhfw_xwfj" IS '综合服务-新闻附件表';

-- ----------------------------
-- Table structure for wxzj_zhfw_xwfl
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_xwfl";
CREATE TABLE "public"."wxzj_zhfw_xwfl" (
  "id" int8 NOT NULL,
  "flmc" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "ms" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 NOT NULL DEFAULT 0,
  "parent_id" int8,
  "zt" int2 NOT NULL DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."flmc" IS '分类名称';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."ms" IS '描述';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."del_flag" IS '逻辑删除  0-正常   1-删除';
COMMENT ON COLUMN "public"."wxzj_zhfw_xwfl"."zt" IS '状态 0-停用 1-启用';
COMMENT ON TABLE "public"."wxzj_zhfw_xwfl" IS '新闻分类表';

-- ----------------------------
-- Table structure for wxzj_zhfw_yzxx
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_yzxx";
CREATE TABLE "public"."wxzj_zhfw_yzxx" (
  "id" int8 NOT NULL,
  "zjhm" varchar(20) COLLATE "pg_catalog"."default",
  "lxdh" varchar(30) COLLATE "pg_catalog"."default",
  "mrfw" int8,
  "open_id" varchar(100) COLLATE "pg_catalog"."default",
  "fhzh_id" int8,
  "yzxm" varchar(50) COLLATE "pg_catalog"."default" DEFAULT CURRENT_TIMESTAMP,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."zjhm" IS '证件号码';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."lxdh" IS '联系电话';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."mrfw" IS '默认房屋id';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."open_id" IS 'openid';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."yzxm" IS '业主姓名';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_yzxx"."del_flag" IS '逻辑删除 0-正常   1-删除';
COMMENT ON TABLE "public"."wxzj_zhfw_yzxx" IS '综合服务-业主信息表';

-- ----------------------------
-- Table structure for wxzj_zhfw_zlb
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_zlb";
CREATE TABLE "public"."wxzj_zhfw_zlb" (
  "id" int8 NOT NULL,
  "zlfbsj" timestamp(6),
  "fbr" varchar(50) COLLATE "pg_catalog"."default",
  "zlbt" varchar(50) COLLATE "pg_catalog"."default",
  "fbzt" int2,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."zlfbsj" IS '资料发布时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."fbr" IS '发布人';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."zlbt" IS '资料标题';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."fbzt" IS '发布状态';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlb"."del_flag" IS '逻辑删除 0-正常 1-删除';
COMMENT ON TABLE "public"."wxzj_zhfw_zlb" IS '资料表';

-- ----------------------------
-- Table structure for wxzj_zhfw_zlfj
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhfw_zlfj";
CREATE TABLE "public"."wxzj_zhfw_zlfj" (
  "id" int8 NOT NULL,
  "glzl_id" int8,
  "fjm" varchar(100) COLLATE "pg_catalog"."default",
  "fj_url" varchar(255) COLLATE "pg_catalog"."default",
  "create_time" timestamp(0) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "del_flag" int2 DEFAULT 0
)
;
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."glzl_id" IS '关联资料id';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."fjm" IS '附件名';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."fj_url" IS '附件地址';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zhfw_zlfj"."del_flag" IS '0-正常   1-删除';
COMMENT ON TABLE "public"."wxzj_zhfw_zlfj" IS '综合服务-资料附件表';

-- ----------------------------
-- Table structure for wxzj_zhjymx
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zhjymx";
CREATE TABLE "public"."wxzj_zhjymx" (
  "id" int8 NOT NULL,
  "jylsh" varchar(20) COLLATE "pg_catalog"."default",
  "yhzh_id" varchar(20) COLLATE "pg_catalog"."default",
  "jyfx" int2,
  "jyje" numeric(18,2) DEFAULT 0,
  "jysj" date,
  "jylx" int2,
  "zy" varchar(50) COLLATE "pg_catalog"."default",
  "ywdm" varchar(16) COLLATE "pg_catalog"."default",
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zhjymx"."id" IS '主键id';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."jylsh" IS '交易流水号';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."yhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."jyfx" IS '交易方向(0-存入  1-取出)';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."jyje" IS '交易金额';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."jysj" IS '交易时间';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."jylx" IS '交易类型(1-归集，2-使用，3-退款，4-业务会划拨，5-分割合并，6-调整，7-结息，8-资金收益，9-资金收益分摊，10-经营收益，11-经营收益分摊)';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."zy" IS '摘要';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."ywdm" IS '业务代码';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zhjymx"."tenant_id" IS '租户';
COMMENT ON TABLE "public"."wxzj_zhjymx" IS '账户交易明细';

-- ----------------------------
-- Table structure for wxzj_zjsy
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy";
CREATE TABLE "public"."wxzj_zjsy" (
  "id" int8 NOT NULL,
  "lx" int2,
  "xzqh_id" int8,
  "wyqy_id" int8,
  "zhyh_id" int8,
  "sssblx_id" int8,
  "sylx" int2,
  "xmbh" varchar(50) COLLATE "pg_catalog"."default",
  "xmmc" varchar(50) COLLATE "pg_catalog"."default",
  "xmzje" numeric(16,2),
  "sgdw_id" int8,
  "sjdw_id" int8,
  "zt" int2,
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(16) COLLATE "pg_catalog"."default",
  "update_by" varchar(16) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "fws" int8,
  "ftfs" int2 DEFAULT 1,
  "tenant_id" int8,
  "jhdycbfje" numeric(16,2),
  "jhdycsysj" timestamp(6),
  "jhdecbfje" numeric(16,2),
  "jhdecsysj" timestamp(6),
  "jhdscbfje" numeric(16,2),
  "jhdscsysj" timestamp(6),
  "ywtblsh" varchar(255) COLLATE "pg_catalog"."default",
  "xmsgje" numeric(16,2),
  "xmsjje" numeric(16,2),
  "sjyjsysj" timestamp(6),
  "glzt" int2 DEFAULT 0,
  "xmqtje" numeric(16,2),
  "qtdwmc" varchar(255) COLLATE "pg_catalog"."default",
  "qttyshxydm" varchar(255) COLLATE "pg_catalog"."default",
  "qtlxr" varchar(255) COLLATE "pg_catalog"."default",
  "qtlxdh" varchar(255) COLLATE "pg_catalog"."default",
  "qtyhzhzh" varchar(255) COLLATE "pg_catalog"."default",
  "qtyhzhxm" varchar(255) COLLATE "pg_catalog"."default",
  "qtzhkhyh" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_zjsy"."lx" IS '申请类型 1-使用备案申请 2-竣工验收 3-质量保证';
COMMENT ON COLUMN "public"."wxzj_zjsy"."xzqh_id" IS '行政区划id';
COMMENT ON COLUMN "public"."wxzj_zjsy"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_zjsy"."zhyh_id" IS '专户银行id';
COMMENT ON COLUMN "public"."wxzj_zjsy"."sssblx_id" IS '设施设备类型id';
COMMENT ON COLUMN "public"."wxzj_zjsy"."sylx" IS '使用类型 1-一般使用 2-紧急使用';
COMMENT ON COLUMN "public"."wxzj_zjsy"."xmbh" IS '项目编号';
COMMENT ON COLUMN "public"."wxzj_zjsy"."xmmc" IS '项目名称';
COMMENT ON COLUMN "public"."wxzj_zjsy"."xmzje" IS '项目总金额';
COMMENT ON COLUMN "public"."wxzj_zjsy"."sgdw_id" IS '施工单位id';
COMMENT ON COLUMN "public"."wxzj_zjsy"."sjdw_id" IS '审价单位id';
COMMENT ON COLUMN "public"."wxzj_zjsy"."zt" IS '状态 - 1-未提交 2-待审核 3-通过 4-驳回 5-已申请划拨 6-申请划拨被驳回 7-划拨完成';
COMMENT ON COLUMN "public"."wxzj_zjsy"."remark" IS '备注';
COMMENT ON COLUMN "public"."wxzj_zjsy"."fws" IS '房屋数';
COMMENT ON COLUMN "public"."wxzj_zjsy"."ftfs" IS '1 系统分摊 2 手动分摊';
COMMENT ON COLUMN "public"."wxzj_zjsy"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy"."jhdycbfje" IS '计划第一次拨付金额';
COMMENT ON COLUMN "public"."wxzj_zjsy"."jhdycsysj" IS '计划第一次使用时间';
COMMENT ON COLUMN "public"."wxzj_zjsy"."jhdecbfje" IS '计划第二次拨付金额';
COMMENT ON COLUMN "public"."wxzj_zjsy"."jhdecsysj" IS '计划第二次使用时间';
COMMENT ON COLUMN "public"."wxzj_zjsy"."jhdscbfje" IS '计划第三次拨付金额';
COMMENT ON COLUMN "public"."wxzj_zjsy"."jhdscsysj" IS '计划第三次使用时间';
COMMENT ON COLUMN "public"."wxzj_zjsy"."ywtblsh" IS '一网通办流水号';
COMMENT ON COLUMN "public"."wxzj_zjsy"."xmsgje" IS '项目施工金额';
COMMENT ON COLUMN "public"."wxzj_zjsy"."xmsjje" IS '项目审价金额';
COMMENT ON COLUMN "public"."wxzj_zjsy"."sjyjsysj" IS '审价预计使用时间';
COMMENT ON COLUMN "public"."wxzj_zjsy"."glzt" IS '关联状态 0-没被关联1-已被关联';
COMMENT ON COLUMN "public"."wxzj_zjsy"."xmqtje" IS '项目其他金额';
COMMENT ON COLUMN "public"."wxzj_zjsy"."qtdwmc" IS '单位名称';
COMMENT ON COLUMN "public"."wxzj_zjsy"."qttyshxydm" IS '统一社会信用代码';
COMMENT ON COLUMN "public"."wxzj_zjsy"."qtlxr" IS '联系人';
COMMENT ON COLUMN "public"."wxzj_zjsy"."qtlxdh" IS '联系人电话';
COMMENT ON COLUMN "public"."wxzj_zjsy"."qtyhzhzh" IS '银行账户账号';
COMMENT ON COLUMN "public"."wxzj_zjsy"."qtyhzhxm" IS '银行账户户名';
COMMENT ON COLUMN "public"."wxzj_zjsy"."qtzhkhyh" IS '账户开户银行';
COMMENT ON TABLE "public"."wxzj_zjsy" IS '资金使用项目表';

-- ----------------------------
-- Table structure for wxzj_zjsy_file
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_file";
CREATE TABLE "public"."wxzj_zjsy_file" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "file_name" varchar(100) COLLATE "pg_catalog"."default",
  "file_url" varchar(255) COLLATE "pg_catalog"."default",
  "content_type" varchar(255) COLLATE "pg_catalog"."default",
  "file_size" varchar(255) COLLATE "pg_catalog"."default",
  "lx" int2,
  "create_time" timestamp(6),
  "file_no" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."id" IS '资金使用附件表';
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."zjsy_id" IS '资金使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."file_name" IS '附件文件名称';
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."file_url" IS '附件文件地址';
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."content_type" IS 'mime类型';
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."file_size" IS '文件大小';
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."lx" IS '类型 1-使用备案 2-竣工验收 3-质量保证 4-公示文件 5-投票文件';
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."file_no" IS '档案号';
COMMENT ON COLUMN "public"."wxzj_zjsy_file"."tenant_id" IS '租户主键id';

-- ----------------------------
-- Table structure for wxzj_zjsy_ft_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_ft_log";
CREATE TABLE "public"."wxzj_zjsy_ft_log" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "fw_id" int8,
  "ftje" numeric(16,2),
  "status" int2,
  "create_time" timestamp(6),
  "fhzh_id" int8,
  "syhb_id" int8,
  "tpqk" int2 DEFAULT 0,
  "tenant_id" int8,
  "zcje" numeric(18,2) DEFAULT 0,
  "zczt" int2 DEFAULT 2,
  "tptjsj" timestamp(6)
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."zjsy_id" IS '使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."fw_id" IS '房屋id';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."ftje" IS '分摊金额';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."status" IS '1-总分摊 2-每次划拨分摊';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."syhb_id" IS '使用划拨id';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."tpqk" IS '投票情况 0-未投票 1-同意 2-不同意 3-弃票';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."zcje" IS '自筹金额';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."zczt" IS '自筹状态 1-完全自筹（不记流水） 2-不自筹或自筹一部分';
COMMENT ON COLUMN "public"."wxzj_zjsy_ft_log"."tptjsj" IS '投票提交时间';

-- ----------------------------
-- Table structure for wxzj_zjsy_gs
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_gs";
CREATE TABLE "public"."wxzj_zjsy_gs" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "gsmc" varchar(50) COLLATE "pg_catalog"."default",
  "sssblx_id" varchar(64) COLLATE "pg_catalog"."default",
  "gslx" varchar(255) COLLATE "pg_catalog"."default",
  "gssj" timestamp(6),
  "lx" int2,
  "create_time" timestamp(6),
  "end_time" timestamp(6),
  "tenant_id" int8,
  "is_relative" int2
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."id" IS '公示id';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."zjsy_id" IS '资金使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."gsmc" IS '公示名称';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."sssblx_id" IS '设施设备类型';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."gslx" IS '公示类型';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."gssj" IS '公示时间 开始时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."lx" IS '类型 1-使用备案 2-竣工验收 3-质量保证';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."end_time" IS '结束时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy_gs"."is_relative" IS '关联状态  1-手动 2-关联';
COMMENT ON TABLE "public"."wxzj_zjsy_gs" IS '资金使用公示';

-- ----------------------------
-- Table structure for wxzj_zjsy_hb
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_hb";
CREATE TABLE "public"."wxzj_zjsy_hb" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "hbje" numeric(16,2),
  "hbcs" int2,
  "hbsj" timestamp(6),
  "tenant_id" int8,
  "hbzt" int2
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_hb"."id" IS '划拨记录表主键';
COMMENT ON COLUMN "public"."wxzj_zjsy_hb"."zjsy_id" IS '资金使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_hb"."hbje" IS '划拨金额';
COMMENT ON COLUMN "public"."wxzj_zjsy_hb"."hbcs" IS '划拨次数';
COMMENT ON COLUMN "public"."wxzj_zjsy_hb"."hbsj" IS '划拨时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_hb"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy_hb"."hbzt" IS '划拨状态 1-未划拨 2-对账中 3-已划拨';
COMMENT ON TABLE "public"."wxzj_zjsy_hb" IS '划拨记录表（大竹杰宇版）';

-- ----------------------------
-- Table structure for wxzj_zjsy_hbsq
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_hbsq";
CREATE TABLE "public"."wxzj_zjsy_hbsq" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "sqhbje" numeric(16,2),
  "lx" int2,
  "shzt" int2,
  "hbzt" int2 DEFAULT 1,
  "create_time" timestamp(6),
  "tenant_id" int8,
  "hbsgje" numeric(16,2),
  "hbsjje" numeric(16,2),
  "xmqtje" numeric(16,2)
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."id" IS '资金使用划拨主键';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."zjsy_id" IS '资金使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."sqhbje" IS '申请划拨金额';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."lx" IS '类型 1-使用备案 2-竣工验收 3-质量保证';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."shzt" IS '划拨审核状态  0-审核中 1-会计审批 2-分管领导审批 3-主要领导审批 4-通过 5-驳回';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."hbzt" IS '划拨状态 1-待划拨  2-划拨中  3-已划拨';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."hbsgje" IS '划拨施工金额';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."hbsjje" IS '划拨审价金额';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq"."xmqtje" IS '项目其他金额';
COMMENT ON TABLE "public"."wxzj_zjsy_hbsq" IS '资金使用划拨申请表';

-- ----------------------------
-- Table structure for wxzj_zjsy_hbsq_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_hbsq_log";
CREATE TABLE "public"."wxzj_zjsy_hbsq_log" (
  "id" int8 NOT NULL,
  "hbsq_id" int8,
  "shmc" varchar(50) COLLATE "pg_catalog"."default",
  "user_id" int8,
  "spyj" varchar(255) COLLATE "pg_catalog"."default",
  "spjg" int2,
  "create_time" timestamp(6),
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "signature" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."id" IS '划拨审核记录';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."hbsq_id" IS '划拨申请id';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."shmc" IS '审核名称';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."user_id" IS '审核人id';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."spyj" IS '审批意见';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."spjg" IS '审批结果 1-通过 2-未通过';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."create_time" IS '审批时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."remark" IS '备注';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy_hbsq_log"."signature" IS '签字图片';
COMMENT ON TABLE "public"."wxzj_zjsy_hbsq_log" IS '划拨申请记录表';

-- ----------------------------
-- Table structure for wxzj_zjsy_sgdw
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_sgdw";
CREATE TABLE "public"."wxzj_zjsy_sgdw" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "qymc" varchar(50) COLLATE "pg_catalog"."default",
  "tyshxydm" varchar(50) COLLATE "pg_catalog"."default",
  "fddbr" varchar(50) COLLATE "pg_catalog"."default",
  "frsjh" varchar(50) COLLATE "pg_catalog"."default",
  "zjlx" varchar(50) COLLATE "pg_catalog"."default",
  "zjhm" varchar(50) COLLATE "pg_catalog"."default",
  "zcdz" varchar(50) COLLATE "pg_catalog"."default",
  "lxr" varchar(50) COLLATE "pg_catalog"."default",
  "lxdh" varchar(50) COLLATE "pg_catalog"."default",
  "yhzhzh" varchar(50) COLLATE "pg_catalog"."default",
  "yhzhhm" varchar(50) COLLATE "pg_catalog"."default",
  "yhkhyh" varchar(50) COLLATE "pg_catalog"."default",
  "sgdwxz" int2
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."zjsy_id" IS '资金使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."qymc" IS '企业名称';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."tyshxydm" IS '统一社会信用代码';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."fddbr" IS '法人手机号';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."frsjh" IS '法人手机';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."zjlx" IS '证件类型 111-居民身份证
112 -临时居民身份证 
335-机动车驾驶证
336-机动车临时驾驶许可证
414-普通护照
511-台湾居民来往大陆通行证（多次有效）
512-台湾居民来往大陆通行证（一次有效）
516-港澳居民来来往内地通行证
552-台湾居民定居证
553-外国人永久居留证
554-外国人居留证或居留许可
555-外国人临时居留证';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."zjhm" IS '证件号码';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."zcdz" IS '注册地址';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."lxr" IS '联系人';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."lxdh" IS '联系电话';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."yhzhzh" IS '银行账户账号';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."yhzhhm" IS '银行账户户名';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."yhkhyh" IS '账户开户银行';
COMMENT ON COLUMN "public"."wxzj_zjsy_sgdw"."sgdwxz" IS '施工单位性质 1-企业 2-个体';
COMMENT ON TABLE "public"."wxzj_zjsy_sgdw" IS '施工单位（大竹杰宇版）';

-- ----------------------------
-- Table structure for wxzj_zjsy_sh
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_sh";
CREATE TABLE "public"."wxzj_zjsy_sh" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "lx" int2,
  "user_id" int8,
  "spyj" varchar(255) COLLATE "pg_catalog"."default",
  "spjg" int2,
  "create_time" timestamp(6),
  "remark" varchar(255) COLLATE "pg_catalog"."default",
  "shmc" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id" int4,
  "signature" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."zjsy_id" IS '资金使用项目备案id';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."lx" IS '类型 1-使用备案申请 2-竣工验收 3-质量保证';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."user_id" IS '审批人id';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."spyj" IS '审批意见';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."spjg" IS '审批结果 1-通过 2-未通过';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."create_time" IS '审批时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."remark" IS '备注';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."shmc" IS '审核名称';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy_sh"."signature" IS '签字图片';
COMMENT ON TABLE "public"."wxzj_zjsy_sh" IS '项目备案审核记录表';

-- ----------------------------
-- Table structure for wxzj_zjsy_sqr
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_sqr";
CREATE TABLE "public"."wxzj_zjsy_sqr" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "sqrlx" int2,
  "lxr" varchar(50) COLLATE "pg_catalog"."default",
  "lxdh" varchar(16) COLLATE "pg_catalog"."default",
  "lx" int2,
  "create_time" timestamp(6),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_sqr"."zjsy_id" IS '资金使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_sqr"."sqrlx" IS '申请人类型 1-业主委员会 2-施工单位 3-街道办（乡镇政府）4-居（村）委会';
COMMENT ON COLUMN "public"."wxzj_zjsy_sqr"."lxr" IS '联系人';
COMMENT ON COLUMN "public"."wxzj_zjsy_sqr"."lxdh" IS '联系电话';
COMMENT ON COLUMN "public"."wxzj_zjsy_sqr"."lx" IS '类型 1-使用备案 2-竣工验收 3-质量保证';
COMMENT ON COLUMN "public"."wxzj_zjsy_sqr"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_zjsy_sqr" IS '资金使用申请人表';

-- ----------------------------
-- Table structure for wxzj_zjsy_syhb
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_syhb";
CREATE TABLE "public"."wxzj_zjsy_syhb" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "hbje" numeric(16,2),
  "hbcs" int2,
  "hbsj" timestamp(6),
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_syhb"."id" IS '划拨记录表主键';
COMMENT ON COLUMN "public"."wxzj_zjsy_syhb"."zjsy_id" IS '资金使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_syhb"."hbje" IS '划拨金额';
COMMENT ON COLUMN "public"."wxzj_zjsy_syhb"."hbcs" IS '划拨次数';
COMMENT ON COLUMN "public"."wxzj_zjsy_syhb"."hbsj" IS '划拨时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_syhb"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_zjsy_syhb" IS '划拨记录表';

-- ----------------------------
-- Table structure for wxzj_zjsy_tp
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_tp";
CREATE TABLE "public"."wxzj_zjsy_tp" (
  "id" int8 NOT NULL,
  "zjsy_id" int8,
  "tpmc" varchar(50) COLLATE "pg_catalog"."default",
  "sssblx_id" varchar(50) COLLATE "pg_catalog"."default",
  "tplx" int2,
  "tprs" int2,
  "tyrszb" numeric(16,2),
  "fdrszb" numeric(16,2),
  "tpmj" numeric(16,2),
  "tyrsfwmjzb" numeric(16,2),
  "fdrsfwmjzb" numeric(16,2),
  "create_time" timestamp(6),
  "lx" int2,
  "tyrsfwmj" numeric(16,2),
  "fdrsfwmj" numeric(16,2),
  "tenant_id" int8,
  "tptyrs" int2,
  "tpfdrs" int2,
  "qprs" int2,
  "qprszb" numeric(16,2),
  "qprsfwmj" numeric(16,2)
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."id" IS '投票主键';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."zjsy_id" IS '资金使用id';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tpmc" IS '投票名称';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."sssblx_id" IS '设施设备类型';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tplx" IS '投票类型';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tprs" IS '投票人数';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tyrszb" IS '同意人数占比(%)';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."fdrszb" IS '反对人数占比(%)';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tpmj" IS '投票面积(m2)';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tyrsfwmjzb" IS '同意人数房屋面积占比(%)';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."fdrsfwmjzb" IS '反对人数房屋面积占比(%)';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."lx" IS '类型 1-使用备案 2-竣工验收 3-质量保证';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tyrsfwmj" IS '同意人数房屋面积';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."fdrsfwmj" IS '反对人数房屋面积';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tptyrs" IS '投票同意人数';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."tpfdrs" IS '投票反对人数';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."qprs" IS '弃票人数';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."qprszb" IS '弃票人数占比';
COMMENT ON COLUMN "public"."wxzj_zjsy_tp"."qprsfwmj" IS '弃票人数房屋面积';
COMMENT ON TABLE "public"."wxzj_zjsy_tp" IS '资金使用投票';

-- ----------------------------
-- Table structure for wxzj_zjsy_tzd
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjsy_tzd";
CREATE TABLE "public"."wxzj_zjsy_tzd" (
  "id" int8 NOT NULL,
  "tzdbh" varchar(16) COLLATE "pg_catalog"."default",
  "hbsq_id" int8,
  "create_time" timestamp(6),
  "create_by" varchar(16) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "update_time" timestamp(6),
  "update_by" varchar(16) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "yhlsh" varchar(50) COLLATE "pg_catalog"."default",
  "zhsj" timestamp(6),
  "tenant_id" int8,
  "dzzt" int2 DEFAULT 3,
  "batch_no" int8,
  "file_url" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."id" IS '资金使用通知单';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."tzdbh" IS '通知单编号';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."hbsq_id" IS '划拨申请id';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."zhsj" IS '回执时间';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."dzzt" IS '对账状态，1—已对账（对账成功）、2—未对账（对账失败）、3—银行没账单数据';
COMMENT ON COLUMN "public"."wxzj_zjsy_tzd"."batch_no" IS '批次号';
COMMENT ON TABLE "public"."wxzj_zjsy_tzd" IS '资金使用通知单';

-- ----------------------------
-- Table structure for wxzj_zjtktzd
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjtktzd";
CREATE TABLE "public"."wxzj_zjtktzd" (
  "id" int8 NOT NULL,
  "zhdbh" varchar(64) COLLATE "pg_catalog"."default",
  "tzdlx" int2,
  "fw_id" int8,
  "wyqy_id" int8,
  "tkje" numeric(18,2) DEFAULT 0,
  "tkfw" varchar(255) COLLATE "pg_catalog"."default",
  "fwhj" int8 DEFAULT 0,
  "mjhj" numeric(18,2) DEFAULT 0,
  "sthj" numeric(18,2) DEFAULT 0,
  "tkyy" int2,
  "tzdzt" int2 DEFAULT 1,
  "tkfs" int2,
  "skzhzh" varchar(30) COLLATE "pg_catalog"."default",
  "skzhhm" varchar(30) COLLATE "pg_catalog"."default",
  "skzhkhh" varchar(30) COLLATE "pg_catalog"."default",
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "bz" varchar(255) COLLATE "pg_catalog"."default",
  "zy" varchar(50) COLLATE "pg_catalog"."default",
  "yhqr_time" date,
  "fhzh_id" int8,
  "jyqd" int2,
  "jcje" numeric(18,2) DEFAULT 0,
  "zhyh" varchar(20) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "dept" varchar(255) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "jctzd_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."zhdbh" IS '通知单编号';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."tzdlx" IS '通知单类型  1-单户退款 2-批量退款';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."fw_id" IS '房屋Id';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."tkje" IS '退款金额';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."tkfw" IS '退款范围';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."fwhj" IS '房屋合计';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."mjhj" IS '面积合计';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."sthj" IS '实退合计';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."tkyy" IS '退款原因 1--房屋灭失 2--面积变更  3--房屋拆迁 4--多交 5--退房';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."tzdzt" IS '通知单状态  1-新增通知单 2-已复核 3-已撤销 4-复核解绑';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."tkfs" IS '退款方式 1-一次性退款  2-分期退款';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."skzhzh" IS '收款账户账号';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."skzhhm" IS '收款账户户名';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."skzhkhh" IS '收款账户开户行';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."zy" IS '摘要';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."yhqr_time" IS '银行确认时间';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."jyqd" IS '交易渠道 1-微信 2-支付宝 3-POS机 4-现金 5-转账';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."jcje" IS '交存金额';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."zhyh" IS '专户银行';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."dept" IS '部门';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjtktzd"."jctzd_id" IS '交存通知单id';
COMMENT ON TABLE "public"."wxzj_zjtktzd" IS '资金退款通知单';

-- ----------------------------
-- Table structure for wxzj_zjtktzd_batch
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjtktzd_batch";
CREATE TABLE "public"."wxzj_zjtktzd_batch" (
  "id" int8 NOT NULL,
  "tktzd_id" int8,
  "fw_id" int8,
  "tkje" numeric(18,2) DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "jcje" numeric(18,2) DEFAULT 0,
  "bz" varchar(255) COLLATE "pg_catalog"."default",
  "fhzh_id" int8,
  "del_flag" int2 DEFAULT 0,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."tktzd_id" IS '退款通知单id';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."fw_id" IS '房屋id';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."tkje" IS '退款金额';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."jcje" IS '交存金额';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."fhzh_id" IS '分户账户id';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_zjtktzd_batch"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_zjtktzd_batch" IS '批量退款通知单子表';

-- ----------------------------
-- Table structure for wxzj_zjzz_dqgz
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_dqgz";
CREATE TABLE "public"."wxzj_zjzz_dqgz" (
  "id" int8 NOT NULL,
  "ywdm" varchar(16) COLLATE "pg_catalog"."default",
  "spbh" varchar(16) COLLATE "pg_catalog"."default",
  "qcrq" timestamp(6),
  "dqrq" timestamp(6),
  "zzlx" int2,
  "zxll" varchar(16) COLLATE "pg_catalog"."default",
  "glfhfs" int2,
  "zjzt" int2 DEFAULT 1,
  "ft" int2 DEFAULT 1,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(16) COLLATE "pg_catalog"."default",
  "update_by" varchar(16) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "zcrq" timestamp(6),
  "zhrq" timestamp(6),
  "ftsj" timestamp(6),
  "tenant_id" int8,
  "zhyh_id" int8,
  "hbyh_id" int8,
  "je" numeric(16,2) DEFAULT 0,
  "zhje" numeric(16,2) DEFAULT 0,
  "zchzfj" varchar(255) COLLATE "pg_catalog"."default",
  "zhhzfj" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."ywdm" IS '业务代码';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."spbh" IS '审批编号';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."qcrq" IS '起存日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."dqrq" IS '到期日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zzlx" IS '增值类型  1-定期- 2-国债';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zxll" IS '执行利率';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."glfhfs" IS '关联分户方式 1-当前全部小区 2-银行关联小区 3-自管小区';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zjzt" IS '资金状态 1-未转出 2-已转出 3-已转回';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."ft" IS '是否分摊 1-未分摊 2-分摊中 3-已分摊';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zcrq" IS '转出日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zhrq" IS '转回日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."ftsj" IS '分摊时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zhyh_id" IS '专户银行id';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."hbyh_id" IS '划拨银行id';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."je" IS '转存金额';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zhje" IS '转回金额';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zchzfj" IS '转出回执附件地址';
COMMENT ON COLUMN "public"."wxzj_zjzz_dqgz"."zhhzfj" IS '转回回执附件地址';
COMMENT ON TABLE "public"."wxzj_zjzz_dqgz" IS '资金增值-银行定期与国债利息收入表 ';

-- ----------------------------
-- Table structure for wxzj_zjzz_ft_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_ft_log";
CREATE TABLE "public"."wxzj_zjzz_ft_log" (
  "id" int8 NOT NULL,
  "zjzz_id" int8,
  "fhzh_id" int8,
  "ftje" numeric(16,2),
  "status" int2 DEFAULT 1,
  "create_time" timestamp(6),
  "zzlx" int2,
  "tenant_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_ft_log"."id" IS '收益分摊记录id';
COMMENT ON COLUMN "public"."wxzj_zjzz_ft_log"."zjzz_id" IS '资金增值id';
COMMENT ON COLUMN "public"."wxzj_zjzz_ft_log"."fhzh_id" IS '分摊的账户id';
COMMENT ON COLUMN "public"."wxzj_zjzz_ft_log"."ftje" IS '分摊金额';
COMMENT ON COLUMN "public"."wxzj_zjzz_ft_log"."status" IS '状态(1 正常 2 分户余额处理异常  3  分户流水异常';
COMMENT ON COLUMN "public"."wxzj_zjzz_ft_log"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_ft_log"."zzlx" IS '1-定期 2-国债 3-活期 4-经营收入 5-公共设施设备收入';
COMMENT ON COLUMN "public"."wxzj_zjzz_ft_log"."tenant_id" IS '租户主键id';
COMMENT ON TABLE "public"."wxzj_zjzz_ft_log" IS '收益分摊记录表';

-- ----------------------------
-- Table structure for wxzj_zjzz_glfh
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_glfh";
CREATE TABLE "public"."wxzj_zjzz_glfh" (
  "id" int8 NOT NULL,
  "zjzz_id" int8,
  "wyqy_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_glfh"."zjzz_id" IS '资金增值id 定期国债和活期id';
COMMENT ON COLUMN "public"."wxzj_zjzz_glfh"."wyqy_id" IS '物业区域id 或银行id';
COMMENT ON TABLE "public"."wxzj_zjzz_glfh" IS '资金关联分户表';

-- ----------------------------
-- Table structure for wxzj_zjzz_hq
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_hq";
CREATE TABLE "public"."wxzj_zjzz_hq" (
  "id" int8 NOT NULL,
  "ywdm" varchar(64) COLLATE "pg_catalog"."default",
  "yhlsh" varchar(64) COLLATE "pg_catalog"."default",
  "zhyh_id" int8,
  "hqll" varchar(64) COLLATE "pg_catalog"."default",
  "scjxrq" timestamp(6),
  "bqjxrq" timestamp(6),
  "jxbj" numeric(16,2),
  "lxsy" numeric(16,2),
  "yehj" numeric(16,2),
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(64) COLLATE "pg_catalog"."default",
  "update_by" varchar(64) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "ft" int2 DEFAULT 1,
  "glfhfs" int2,
  "ftsj" timestamp(6),
  "tenant_id" int8,
  "fjdz" varchar(255) COLLATE "pg_catalog"."default",
  "dzzt" int2 DEFAULT 3,
  "batch_no" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."ywdm" IS '业务代码';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."zhyh_id" IS '专户银行id';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."hqll" IS '活期利率';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."scjxrq" IS '上次结息日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."bqjxrq" IS '本次结息日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."jxbj" IS '结息本金（万元）';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."lxsy" IS '利息收益（万元）';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."yehj" IS '余额合计（万元）';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."ft" IS '是否分摊 1-未分摊 2-分摊中 3-已分摊';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."glfhfs" IS '关联分户方式 1-当前全部小区 2-银行关联小区 3-自管小区';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."ftsj" IS '分摊时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."fjdz" IS '附件地址';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."dzzt" IS '对账状态，1—已对账（对账成功）、2—未对账（对账失败）、3—银行没账单数据';
COMMENT ON COLUMN "public"."wxzj_zjzz_hq"."batch_no" IS '批次号';
COMMENT ON TABLE "public"."wxzj_zjzz_hq" IS '资金增值-银行活期利息表';

-- ----------------------------
-- Table structure for wxzj_zjzz_pzdh
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_pzdh";
CREATE TABLE "public"."wxzj_zjzz_pzdh" (
  "id" int8 NOT NULL,
  "zjsp_id" int8,
  "dqcklx" int2,
  "zhyhzh_id" int8,
  "qcrq" timestamp(6),
  "dqrq" timestamp(6),
  "zzje" numeric(16,2),
  "zxll" varchar(255) COLLATE "pg_catalog"."default",
  "pzdhlx" int2,
  "zjzt" int2,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2,
  "tenant_id" int8,
  "zdzc" int2,
  "zhje" numeric(16,2),
  "ft" int2 DEFAULT 1,
  "glfhfs" int2,
  "qs" int2,
  "zhzjsp_id" int8,
  "ftsj" timestamp(6)
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."id" IS '品种调换业务主键id';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."zjsp_id" IS '资金审批id';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."dqcklx" IS '当前存款类型 1-活期 2-定期 3-国债';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."zhyhzh_id" IS '专户银行id';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."qcrq" IS '起存日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."dqrq" IS '到期日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."zzje" IS '增值金额';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."zxll" IS '执行利率';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."pzdhlx" IS '品种调换类型 1-定期 2-国债 3-活期';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."zjzt" IS '资金状态 1-未转出 2-已转出 3-已转回';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."zdzc" IS '自动转存 1-是 2-否';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."zhje" IS '转回金额';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."ft" IS '分摊状态 1-未分摊 2-分摊中 3-已分摊';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."glfhfs" IS '关联分户方式';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."qs" IS '期数(N个月)';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."zhzjsp_id" IS '转回资金审批id';
COMMENT ON COLUMN "public"."wxzj_zjzz_pzdh"."ftsj" IS '分摊时间';
COMMENT ON TABLE "public"."wxzj_zjzz_pzdh" IS '品种调换表';

-- ----------------------------
-- Table structure for wxzj_zjzz_sr
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_sr";
CREATE TABLE "public"."wxzj_zjzz_sr" (
  "id" int8 NOT NULL,
  "ywdm" varchar(16) COLLATE "pg_catalog"."default",
  "yhlsh" varchar(16) COLLATE "pg_catalog"."default",
  "zhyh_id" int8,
  "sylx" int2,
  "syxm" varchar(20) COLLATE "pg_catalog"."default",
  "syqrsj" timestamp(6),
  "syje" numeric(16,2),
  "ft" int2 DEFAULT 1,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(16) COLLATE "pg_catalog"."default",
  "update_by" varchar(16) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "wyqy_id" int8,
  "ld_ids" varchar(1024) COLLATE "pg_catalog"."default",
  "dy_ids" varchar(1024) COLLATE "pg_catalog"."default",
  "ftsj" timestamp(6),
  "tenant_id" int8,
  "fjdz" varchar(255) COLLATE "pg_catalog"."default",
  "batch_no" int8,
  "dzzt" int2 DEFAULT 3,
  "spzt" int2
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."id" IS '资金增值收入主键';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."ywdm" IS '业务代码';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."zhyh_id" IS '专户银行id';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."sylx" IS '收益类型 1-经营收入 2-公共设施收入';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."syxm" IS '收益项目';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."syqrsj" IS '收益确认时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."syje" IS '收益金额';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."ft" IS '是否分摊 1-未分摊 2-分摊中 3-已分摊';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."wyqy_id" IS '物业区域id';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."ld_ids" IS '楼栋id列表 逗号隔开';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."dy_ids" IS '单元id列表 逗号隔开';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."ftsj" IS '分摊时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."fjdz" IS '附件地址';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."batch_no" IS '批次号';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."dzzt" IS '对账状态，1—已对账（对账成功）、2—未对账（对账失败）、3—银行没账单数据';
COMMENT ON COLUMN "public"."wxzj_zjzz_sr"."spzt" IS '审批状态(0:审批中,1:已通过,-1已撤销,2:已驳回)';
COMMENT ON TABLE "public"."wxzj_zjzz_sr" IS '资金增值-收入';

-- ----------------------------
-- Table structure for wxzj_zjzz_srfh
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_srfh";
CREATE TABLE "public"."wxzj_zjzz_srfh" (
  "id" int8 NOT NULL,
  "zjzz_id" int8,
  "fw_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_srfh"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_zjzz_srfh"."zjzz_id" IS '资金增值id  收入id';
COMMENT ON COLUMN "public"."wxzj_zjzz_srfh"."fw_id" IS '房屋id';
COMMENT ON TABLE "public"."wxzj_zjzz_srfh" IS '资金增值收入分户';

-- ----------------------------
-- Table structure for wxzj_zjzz_tzd
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_tzd";
CREATE TABLE "public"."wxzj_zjzz_tzd" (
  "id" int8 NOT NULL,
  "tzdbh" varchar(16) COLLATE "pg_catalog"."default",
  "zjzz_id" int8,
  "tzdlx" int2,
  "create_time" timestamp(6),
  "create_by" varchar(16) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "update_time" timestamp(6),
  "update_by" varchar(16) COLLATE "pg_catalog"."default",
  "del_flag" int2 DEFAULT 0,
  "yhlsh" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "dzzt" int2 DEFAULT 3,
  "batch_no" int8,
  "hzfj" varchar(255) COLLATE "pg_catalog"."default",
  "hzsj" timestamp(6)
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."id" IS '资金增值通知单';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."tzdbh" IS '通知单编号';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."zjzz_id" IS '资金增值id 定期国债';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."tzdlx" IS '通知单类型 1-品种调换转出 2-品种调换转回 3-分存';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."yhlsh" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."tenant_id" IS '租户主键id';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."dzzt" IS '对账状态，1—已对账（对账成功）、2—未对账（对账失败）、3—银行没账单数据';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."batch_no" IS '批次号';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."hzfj" IS '回执附件';
COMMENT ON COLUMN "public"."wxzj_zjzz_tzd"."hzsj" IS '回执时间';
COMMENT ON TABLE "public"."wxzj_zjzz_tzd" IS '资金增值通知单';

-- ----------------------------
-- Table structure for wxzj_zjzz_zjfc
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_zjfc";
CREATE TABLE "public"."wxzj_zjzz_zjfc" (
  "id" int8 NOT NULL,
  "zjsp_id" int8,
  "fkzhyh_id" int8,
  "fcje" numeric(16,2),
  "skzhyh_id" int8,
  "fclx" int2,
  "zjzt" int2,
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2,
  "tenant_id" int8,
  "qcrq" timestamp(6),
  "wyqy_id" int8
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."id" IS '资金分存业务主键';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."zjsp_id" IS '资金审批id';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."fkzhyh_id" IS '付款专户银行id';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."fcje" IS '分存金额';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."skzhyh_id" IS '收款专户银行id';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."fclx" IS '分存类型
1划拨备用金
2备用金补足

3收回备用金

4备用金利息转回

5转至业委会

6业委会转回

7专户银行变更
8
其他';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."zjzt" IS '资金状态 0-未转出 1-已转出';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."qcrq" IS '起存日期';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjfc"."wyqy_id" IS '转至业务会时选择的物业区域id';
COMMENT ON TABLE "public"."wxzj_zjzz_zjfc" IS '资金分存表';

-- ----------------------------
-- Table structure for wxzj_zjzz_zjsp
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zjzz_zjsp";
CREATE TABLE "public"."wxzj_zjzz_zjsp" (
  "id" int8 NOT NULL,
  "ywbh" varchar(255) COLLATE "pg_catalog"."default",
  "sxmc" varchar(255) COLLATE "pg_catalog"."default",
  "sxzw" text COLLATE "pg_catalog"."default",
  "spzt" int2,
  "fqr" int8,
  "fqsj" timestamp(6),
  "create_time" timestamp(6),
  "update_time" timestamp(6),
  "create_by" varchar(255) COLLATE "pg_catalog"."default",
  "update_by" varchar(255) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2,
  "tenant_id" int8,
  "splx" int2
)
;
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."id" IS '资金增值审批主键';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."ywbh" IS '业务编号';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."sxmc" IS '事项名称';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."sxzw" IS '事项正文';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."spzt" IS '审批状态(0:审批中,1:已通过,-1已撤销,2:已驳回)';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."fqr" IS '发起人id';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."fqsj" IS '发起时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."update_time" IS '更新时间';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."update_by" IS '更新人';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."dept_id" IS '分组标签';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."del_flag" IS '逻辑删除标签';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."tenant_id" IS '租户id';
COMMENT ON COLUMN "public"."wxzj_zjzz_zjsp"."splx" IS '审批类型 1-综合审批 2-资金分存 3-品种调换';
COMMENT ON TABLE "public"."wxzj_zjzz_zjsp" IS '资金审批表';

-- ----------------------------
-- Table structure for wxzj_zl
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_zl";
CREATE TABLE "public"."wxzj_zl" (
  "id" int8 NOT NULL,
  "zlzsbh" varchar(50) COLLATE "pg_catalog"."default",
  "zldj" varchar(20) COLLATE "pg_catalog"."default",
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "jggl_id" int8,
  "zlyxq" int2,
  "zlxx" varchar(100) COLLATE "pg_catalog"."default",
  "zlzsmc" varchar(50) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."wxzj_zl"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_zl"."zlzsbh" IS '资历证书编号';
COMMENT ON COLUMN "public"."wxzj_zl"."zldj" IS '资历等级';
COMMENT ON COLUMN "public"."wxzj_zl"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_zl"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_zl"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_zl"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_zl"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_zl"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_zl"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_zl"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_zl"."jggl_id" IS '机构管理id';
COMMENT ON COLUMN "public"."wxzj_zl"."zlyxq" IS '资历有效期';
COMMENT ON COLUMN "public"."wxzj_zl"."zlxx" IS '资历信息';
COMMENT ON COLUMN "public"."wxzj_zl"."zlzsmc" IS '资历证书名称';
COMMENT ON TABLE "public"."wxzj_zl" IS '资历表';

-- ----------------------------
-- Table structure for xxl_job_group
-- ----------------------------
DROP TABLE IF EXISTS "public"."xxl_job_group";
CREATE TABLE "public"."xxl_job_group" (
  "id" int8 NOT NULL,
  "app_name" varchar(64) COLLATE "pg_catalog"."default" NOT NULL,
  "title" varchar(12) COLLATE "pg_catalog"."default" NOT NULL,
  "address_type" int2 NOT NULL,
  "address_list" varchar(512) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."xxl_job_group"."app_name" IS '执行器AppName';
COMMENT ON COLUMN "public"."xxl_job_group"."title" IS '执行器名称';
COMMENT ON COLUMN "public"."xxl_job_group"."address_type" IS '执行器地址类型：0=自动注册、1=手动录入';
COMMENT ON COLUMN "public"."xxl_job_group"."address_list" IS '执行器地址列表，多地址逗号分隔';

-- ----------------------------
-- Table structure for xxl_job_info
-- ----------------------------
DROP TABLE IF EXISTS "public"."xxl_job_info";
CREATE TABLE "public"."xxl_job_info" (
  "id" int8 NOT NULL,
  "job_group" int8 NOT NULL,
  "job_cron" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "job_desc" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "add_time" timestamp(6),
  "update_time" timestamp(6),
  "author" varchar(64) COLLATE "pg_catalog"."default",
  "alarm_email" varchar(255) COLLATE "pg_catalog"."default",
  "executor_route_strategy" varchar(50) COLLATE "pg_catalog"."default",
  "executor_handler" varchar(255) COLLATE "pg_catalog"."default",
  "executor_param" varchar(512) COLLATE "pg_catalog"."default",
  "executor_block_strategy" varchar(50) COLLATE "pg_catalog"."default",
  "executor_timeout" int4 NOT NULL,
  "executor_fail_retry_count" int4 NOT NULL,
  "glue_type" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "glue_source" text COLLATE "pg_catalog"."default",
  "glue_remark" varchar(128) COLLATE "pg_catalog"."default",
  "glue_updatetime" timestamp(6),
  "child_jobid" varchar(255) COLLATE "pg_catalog"."default",
  "trigger_status" int2 NOT NULL,
  "trigger_last_time" int8 NOT NULL,
  "trigger_next_time" int8 NOT NULL
)
;
COMMENT ON COLUMN "public"."xxl_job_info"."job_group" IS '执行器主键ID';
COMMENT ON COLUMN "public"."xxl_job_info"."job_cron" IS '任务执行CRON';
COMMENT ON COLUMN "public"."xxl_job_info"."author" IS '作者';
COMMENT ON COLUMN "public"."xxl_job_info"."alarm_email" IS '报警邮件';
COMMENT ON COLUMN "public"."xxl_job_info"."executor_route_strategy" IS '执行器路由策略';
COMMENT ON COLUMN "public"."xxl_job_info"."executor_handler" IS '执行器任务handler';
COMMENT ON COLUMN "public"."xxl_job_info"."executor_param" IS '执行器任务参数';
COMMENT ON COLUMN "public"."xxl_job_info"."executor_block_strategy" IS '阻塞处理策略';
COMMENT ON COLUMN "public"."xxl_job_info"."executor_timeout" IS '任务执行超时时间，单位秒';
COMMENT ON COLUMN "public"."xxl_job_info"."executor_fail_retry_count" IS '失败重试次数';
COMMENT ON COLUMN "public"."xxl_job_info"."glue_type" IS 'GLUE类型';
COMMENT ON COLUMN "public"."xxl_job_info"."glue_source" IS 'GLUE源代码';
COMMENT ON COLUMN "public"."xxl_job_info"."glue_remark" IS 'GLUE备注';
COMMENT ON COLUMN "public"."xxl_job_info"."glue_updatetime" IS 'GLUE更新时间';
COMMENT ON COLUMN "public"."xxl_job_info"."child_jobid" IS '子任务ID，多个逗号分隔';
COMMENT ON COLUMN "public"."xxl_job_info"."trigger_status" IS '调度状态：0-停止，1-运行';
COMMENT ON COLUMN "public"."xxl_job_info"."trigger_last_time" IS '上次调度时间';
COMMENT ON COLUMN "public"."xxl_job_info"."trigger_next_time" IS '下次调度时间';

-- ----------------------------
-- Table structure for xxl_job_lock
-- ----------------------------
DROP TABLE IF EXISTS "public"."xxl_job_lock";
CREATE TABLE "public"."xxl_job_lock" (
  "lock_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;
COMMENT ON COLUMN "public"."xxl_job_lock"."lock_name" IS '锁名称';

-- ----------------------------
-- Table structure for xxl_job_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."xxl_job_log";
CREATE TABLE "public"."xxl_job_log" (
  "id" int8 NOT NULL,
  "job_group" int8 NOT NULL,
  "job_id" int8 NOT NULL,
  "executor_address" varchar(255) COLLATE "pg_catalog"."default",
  "executor_handler" varchar(255) COLLATE "pg_catalog"."default",
  "executor_param" varchar(512) COLLATE "pg_catalog"."default",
  "executor_sharding_param" varchar(20) COLLATE "pg_catalog"."default",
  "executor_fail_retry_count" int4 NOT NULL,
  "trigger_time" timestamp(6),
  "trigger_code" int4 NOT NULL,
  "trigger_msg" text COLLATE "pg_catalog"."default",
  "handle_time" timestamp(6),
  "handle_code" int4 NOT NULL,
  "handle_msg" text COLLATE "pg_catalog"."default",
  "alarm_status" int2 NOT NULL
)
;
COMMENT ON COLUMN "public"."xxl_job_log"."job_group" IS '执行器主键ID';
COMMENT ON COLUMN "public"."xxl_job_log"."job_id" IS '任务，主键ID';
COMMENT ON COLUMN "public"."xxl_job_log"."executor_address" IS '执行器地址，本次执行的地址';
COMMENT ON COLUMN "public"."xxl_job_log"."executor_handler" IS '执行器任务handler';
COMMENT ON COLUMN "public"."xxl_job_log"."executor_param" IS '执行器任务参数';
COMMENT ON COLUMN "public"."xxl_job_log"."executor_sharding_param" IS '执行器任务分片参数，格式如 1/2';
COMMENT ON COLUMN "public"."xxl_job_log"."executor_fail_retry_count" IS '失败重试次数';
COMMENT ON COLUMN "public"."xxl_job_log"."trigger_time" IS '调度-时间';
COMMENT ON COLUMN "public"."xxl_job_log"."trigger_code" IS '调度-结果';
COMMENT ON COLUMN "public"."xxl_job_log"."trigger_msg" IS '调度-日志';
COMMENT ON COLUMN "public"."xxl_job_log"."handle_time" IS '执行-时间';
COMMENT ON COLUMN "public"."xxl_job_log"."handle_code" IS '执行-状态';
COMMENT ON COLUMN "public"."xxl_job_log"."handle_msg" IS '执行-日志';
COMMENT ON COLUMN "public"."xxl_job_log"."alarm_status" IS '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';

-- ----------------------------
-- Table structure for xxl_job_log_report
-- ----------------------------
DROP TABLE IF EXISTS "public"."xxl_job_log_report";
CREATE TABLE "public"."xxl_job_log_report" (
  "id" int8 NOT NULL,
  "trigger_day" timestamp(6),
  "running_count" int4 NOT NULL,
  "suc_count" int4 NOT NULL,
  "fail_count" int4 NOT NULL
)
;
COMMENT ON COLUMN "public"."xxl_job_log_report"."trigger_day" IS '调度-时间';
COMMENT ON COLUMN "public"."xxl_job_log_report"."running_count" IS '运行中-日志数量';
COMMENT ON COLUMN "public"."xxl_job_log_report"."suc_count" IS '执行成功-日志数量';
COMMENT ON COLUMN "public"."xxl_job_log_report"."fail_count" IS '执行失败-日志数量';

-- ----------------------------
-- Table structure for xxl_job_logglue
-- ----------------------------
DROP TABLE IF EXISTS "public"."xxl_job_logglue";
CREATE TABLE "public"."xxl_job_logglue" (
  "id" int8 NOT NULL,
  "job_id" int8 NOT NULL,
  "glue_type" varchar(50) COLLATE "pg_catalog"."default",
  "glue_source" text COLLATE "pg_catalog"."default",
  "glue_remark" varchar(128) COLLATE "pg_catalog"."default" NOT NULL,
  "add_time" timestamp(6),
  "update_time" timestamp(6)
)
;
COMMENT ON COLUMN "public"."xxl_job_logglue"."job_id" IS '任务，主键ID';
COMMENT ON COLUMN "public"."xxl_job_logglue"."glue_type" IS 'GLUE类型';
COMMENT ON COLUMN "public"."xxl_job_logglue"."glue_source" IS 'GLUE源代码';
COMMENT ON COLUMN "public"."xxl_job_logglue"."glue_remark" IS 'GLUE备注';

-- ----------------------------
-- Table structure for xxl_job_registry
-- ----------------------------
DROP TABLE IF EXISTS "public"."xxl_job_registry";
CREATE TABLE "public"."xxl_job_registry" (
  "id" int8 NOT NULL,
  "registry_group" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "registry_key" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "registry_value" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "update_time" timestamp(6)
)
;

-- ----------------------------
-- Table structure for xxl_job_user
-- ----------------------------
DROP TABLE IF EXISTS "public"."xxl_job_user";
CREATE TABLE "public"."xxl_job_user" (
  "id" int8 NOT NULL,
  "username" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "password" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "role" int2 NOT NULL,
  "permission" varchar(255) COLLATE "pg_catalog"."default"
)
;
COMMENT ON COLUMN "public"."xxl_job_user"."username" IS '账号';
COMMENT ON COLUMN "public"."xxl_job_user"."password" IS '密码';
COMMENT ON COLUMN "public"."xxl_job_user"."role" IS '角色：0-普通用户、1-管理员';
COMMENT ON COLUMN "public"."xxl_job_user"."permission" IS '权限：执行器ID列表，多个逗号分割';

-- ----------------------------
-- Table structure for wxzj_fh_ls
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fh_ls";
CREATE TABLE "public"."wxzj_fh_ls" (
  "id" int8 NOT NULL,
  "fsje" numeric(18,2),
  "bgsj" timestamp(6),
  "skr" varchar(50) COLLATE "pg_catalog"."default",
  "skyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "zkyhzh" varchar(30) COLLATE "pg_catalog"."default",
  "bglx" int2,
  "bz" varchar(200) COLLATE "pg_catalog"."default",
  "fh_id" int8,
  "dept_id" int8,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "tzd_id" int8,
  "fhye" numeric(18,2) DEFAULT 0,
  "qr_order_no" varchar(100) COLLATE "pg_catalog"."default",
  "order_id" int8,
  "batch_no" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "check_booking" int2 DEFAULT 0,
  "jctk_id" int8
)
PARTITION BY LIST (
  "month" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops"
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_01" FOR VALUES IN (
'01'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_02" FOR VALUES IN (
'02'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_03" FOR VALUES IN (
'03'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_04" FOR VALUES IN (
'04'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_05" FOR VALUES IN (
'05'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_06" FOR VALUES IN (
'06'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_07" FOR VALUES IN (
'07'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_08" FOR VALUES IN (
'08'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_09" FOR VALUES IN (
'09'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_10" FOR VALUES IN (
'10'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_11" FOR VALUES IN (
'11'
)
;
ALTER TABLE "public"."wxzj_fh_ls" ATTACH PARTITION "public"."wxzj_fh_ls_12" FOR VALUES IN (
'12'
)
;
COMMENT ON COLUMN "public"."wxzj_fh_ls"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."fsje" IS '发生金额';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."bgsj" IS '变更时间';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."skr" IS '收款人';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."skyhzh" IS '收款银行账户';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."zkyhzh" IS '支款银行账户';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."bglx" IS '变更类型  1-交存 2-使用 3-增值 4-退款 ';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."bz" IS '备注';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."fh_id" IS '分户id';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."dept_id" IS '部门';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."tzd_id" IS '通知单id';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."fhye" IS '分户余额';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."qr_order_no" IS '银行流水号';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."order_id" IS '订单id';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."batch_no" IS '定向定期批次号/业务流水号';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."month" IS '分表按月份';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."check_booking" IS '是否对账 0-否 1-是';
COMMENT ON COLUMN "public"."wxzj_fh_ls"."jctk_id" IS '交存退款业务id';
COMMENT ON TABLE "public"."wxzj_fh_ls" IS '分户流水表主表';

-- ----------------------------
-- Table structure for wxzj_fhzh_ye
-- ----------------------------
DROP TABLE IF EXISTS "public"."wxzj_fhzh_ye";
CREATE TABLE "public"."wxzj_fhzh_ye" (
  "id" int8 NOT NULL,
  "fhzh_id" int8,
  "rq" date,
  "zhmtye" numeric(18,2) DEFAULT 0,
  "del_flag" int2 DEFAULT 0,
  "create_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "update_time" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "create_by" varchar(50) COLLATE "pg_catalog"."default",
  "update_by" varchar(50) COLLATE "pg_catalog"."default",
  "tenant_id" int8,
  "month" varchar(2) COLLATE "pg_catalog"."default"
)
PARTITION BY LIST (
  "month" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops"
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_01" FOR VALUES IN (
'01'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_02" FOR VALUES IN (
'02'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_03" FOR VALUES IN (
'03'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_04" FOR VALUES IN (
'04'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_05" FOR VALUES IN (
'05'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_06" FOR VALUES IN (
'06'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_07" FOR VALUES IN (
'07'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_08" FOR VALUES IN (
'08'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_09" FOR VALUES IN (
'09'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_10" FOR VALUES IN (
'10'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_11" FOR VALUES IN (
'11'
)
;
ALTER TABLE "public"."wxzj_fhzh_ye" ATTACH PARTITION "public"."wxzj_fhzh_ye_12" FOR VALUES IN (
'12'
)
;
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."id" IS '主键';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."fhzh_id" IS '分户账号id';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."rq" IS '日期';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."zhmtye" IS '账户每天余额';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."del_flag" IS '0-正常 1-删除';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."create_time" IS '创建时间';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."update_time" IS '修改时间';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."create_by" IS '创建人';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."update_by" IS '修改人';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."tenant_id" IS '租户';
COMMENT ON COLUMN "public"."wxzj_fhzh_ye"."month" IS '按月份分区';
COMMENT ON TABLE "public"."wxzj_fhzh_ye" IS '分户余额分区主表';

-- ----------------------------
-- Function structure for cs_timestamp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."cs_timestamp"();
CREATE OR REPLACE FUNCTION "public"."cs_timestamp"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
begin
    new.update_time= current_timestamp;
    return new;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for find_in_set
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."find_in_set"(int8, varchar);
CREATE OR REPLACE FUNCTION "public"."find_in_set"(int8, varchar)
  RETURNS "pg_catalog"."bool" AS $BODY$
DECLARE
  STR ALIAS FOR $1;
  STRS ALIAS FOR $2;
  POS INTEGER;
  STATUS BOOLEAN;
BEGIN
	SELECT POSITION( ','||STR||',' IN ','||STRS||',') INTO POS;
	IF POS > 0 THEN
	  STATUS = TRUE;
	ELSE
	  STATUS = FALSE;
	END IF;
	RETURN STATUS;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- Function structure for update
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."update"();
CREATE OR REPLACE FUNCTION "public"."update"()
  RETURNS "pg_catalog"."void" AS $BODY$BEGIN
	-- Routine body goes here...

	RETURN;
END$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- View structure for view_self_table
-- ----------------------------
DROP VIEW IF EXISTS "public"."view_self_table";
CREATE VIEW "public"."view_self_table" AS  SELECT pg_database.datname AS table_catalog,
    pg_get_userbyid(c.relowner) AS tableowner,
    pg_ns.nspname AS table_schema,
    c.relname AS table_name,
    (obj_description(c.relfilenode, 'pg_class'::name))::character varying AS table_comment,
    now() AS create_time,
    now() AS update_time
   FROM ((pg_class c
     LEFT JOIN pg_namespace pg_ns ON ((pg_ns.oid = c.relnamespace)))
     LEFT JOIN pg_database ON ((c.relowner = pg_database.datdba)))
  WHERE (c.relname IN ( SELECT pg_tables.tablename
           FROM pg_tables));

-- ----------------------------
-- View structure for view_self_table_columns
-- ----------------------------
DROP VIEW IF EXISTS "public"."view_self_table_columns";
CREATE VIEW "public"."view_self_table_columns" AS  SELECT columns.table_catalog,
    columns.table_schema,
    columns.table_name,
    columns.ordinal_position AS sort,
    columns.column_name,
    columns.data_type AS typename,
        CASE
            WHEN (((columns.is_nullable)::text = 'no'::text) AND (c.contype <> 'p'::"char")) THEN '1'::text
            ELSE NULL::text
        END AS is_required,
        CASE
            WHEN (c.contype = 'p'::"char") THEN '1'::text
            ELSE '0'::text
        END AS is_pk,
    COALESCE((columns.character_maximum_length)::integer, (columns.numeric_precision)::integer, '-1'::integer) AS length,
    columns.numeric_scale AS scale,
        CASE columns.is_nullable
            WHEN 'NO'::text THEN 0
            ELSE 1
        END AS cannull,
    columns.column_default AS defaultval,
        CASE
            WHEN ("position"((columns.column_default)::text, 'nextval'::text) > 0) THEN 1
            ELSE 0
        END AS isidentity,
        CASE
            WHEN ("position"((columns.column_default)::text, 'nextval'::text) > 0) THEN 1
            ELSE 0
        END AS is_increment,
    c.detext AS column_comment,
    c.typname AS column_type,
    c.contype,
    columns.ordinal_position
   FROM (information_schema.columns
     LEFT JOIN ( SELECT pg_database.datname,
            pg_get_userbyid(pg_class.relowner) AS tableowner,
            pg_ns.nspname,
            pg_class.relname,
            pg_attr.attname,
            pg_desc.description AS detext,
            pg_type.typname,
            pg_cons.contype
           FROM ((((((pg_class
             LEFT JOIN pg_attribute pg_attr ON ((pg_attr.attrelid = pg_class.oid)))
             LEFT JOIN pg_description pg_desc ON (((pg_desc.objoid = pg_attr.attrelid) AND (pg_desc.objsubid = pg_attr.attnum))))
             LEFT JOIN pg_namespace pg_ns ON ((pg_ns.oid = pg_class.relnamespace)))
             LEFT JOIN pg_database ON ((pg_class.relowner = pg_database.datdba)))
             LEFT JOIN pg_type ON ((pg_attr.atttypid = pg_type.oid)))
             LEFT JOIN ( SELECT pg_con.conname,
                    pg_con.connamespace,
                    pg_con.contype,
                    pg_con.condeferrable,
                    pg_con.condeferred,
                    pg_con.convalidated,
                    pg_con.conrelid,
                    pg_con.contypid,
                    pg_con.conindid,
                    pg_con.confrelid,
                    pg_con.confupdtype,
                    pg_con.confdeltype,
                    pg_con.confmatchtype,
                    pg_con.conislocal,
                    pg_con.coninhcount,
                    pg_con.connoinherit,
                    pg_con.conkey,
                    pg_con.confkey,
                    pg_con.conpfeqop,
                    pg_con.conppeqop,
                    pg_con.conffeqop,
                    pg_con.conexclop,
                    pg_con.conbin,
                    unnest(pg_con.conkey) AS conkey_new
                   FROM pg_constraint pg_con) pg_cons ON (((pg_attr.attrelid = pg_class.oid) AND (pg_attr.attnum = pg_cons.conkey_new) AND (pg_cons.conrelid = pg_class.oid))))
          WHERE ((pg_attr.attnum > 0) AND (pg_attr.attrelid = pg_class.oid))) c ON ((((columns.table_catalog)::name = c.datname) AND ((columns.table_schema)::name = c.nspname) AND ((columns.table_name)::name = c.relname) AND ((columns.column_name)::name = c.attname))));

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."act_evt_log_log_nr__seq"
OWNED BY "public"."act_evt_log"."log_nr_";
SELECT setval('"public"."act_evt_log_log_nr__seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."act_hi_tsk_log_id__seq"
OWNED BY "public"."act_hi_tsk_log"."id_";
SELECT setval('"public"."act_hi_tsk_log_id__seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."undo_log_id_seq"', 13803, true);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
SELECT setval('"public"."user_id_quence"', 1188, true);

-- ----------------------------
-- Primary Key structure for table act_evt_log
-- ----------------------------
ALTER TABLE "public"."act_evt_log" ADD CONSTRAINT "act_evt_log_pkey" PRIMARY KEY ("log_nr_");

-- ----------------------------
-- Indexes structure for table act_ge_bytearray
-- ----------------------------
CREATE INDEX "act_idx_bytear_depl" ON "public"."act_ge_bytearray" USING btree (
  "deployment_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ge_bytearray
-- ----------------------------
ALTER TABLE "public"."act_ge_bytearray" ADD CONSTRAINT "act_ge_bytearray_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_ge_property
-- ----------------------------
ALTER TABLE "public"."act_ge_property" ADD CONSTRAINT "act_ge_property_pkey" PRIMARY KEY ("name_");

-- ----------------------------
-- Indexes structure for table act_hi_actinst
-- ----------------------------
CREATE INDEX "act_idx_hi_act_inst_end" ON "public"."act_hi_actinst" USING btree (
  "end_time_" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_act_inst_exec" ON "public"."act_hi_actinst" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "act_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_act_inst_procinst" ON "public"."act_hi_actinst" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "act_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_act_inst_start" ON "public"."act_hi_actinst" USING btree (
  "start_time_" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_hi_actinst
-- ----------------------------
ALTER TABLE "public"."act_hi_actinst" ADD CONSTRAINT "act_hi_actinst_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_hi_attachment
-- ----------------------------
ALTER TABLE "public"."act_hi_attachment" ADD CONSTRAINT "act_hi_attachment_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_hi_comment
-- ----------------------------
ALTER TABLE "public"."act_hi_comment" ADD CONSTRAINT "act_hi_comment_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_hi_detail
-- ----------------------------
CREATE INDEX "act_idx_hi_detail_act_inst" ON "public"."act_hi_detail" USING btree (
  "act_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_detail_name" ON "public"."act_hi_detail" USING btree (
  "name_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_detail_proc_inst" ON "public"."act_hi_detail" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_detail_task_id" ON "public"."act_hi_detail" USING btree (
  "task_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_detail_time" ON "public"."act_hi_detail" USING btree (
  "time_" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_hi_detail
-- ----------------------------
ALTER TABLE "public"."act_hi_detail" ADD CONSTRAINT "act_hi_detail_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_hi_entitylink
-- ----------------------------
CREATE INDEX "act_idx_hi_ent_lnk_root_scope" ON "public"."act_hi_entitylink" USING btree (
  "root_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "root_scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "link_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_ent_lnk_scope" ON "public"."act_hi_entitylink" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "link_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_ent_lnk_scope_def" ON "public"."act_hi_entitylink" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "link_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_hi_entitylink
-- ----------------------------
ALTER TABLE "public"."act_hi_entitylink" ADD CONSTRAINT "act_hi_entitylink_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_hi_identitylink
-- ----------------------------
CREATE INDEX "act_idx_hi_ident_lnk_procinst" ON "public"."act_hi_identitylink" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_ident_lnk_scope" ON "public"."act_hi_identitylink" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_ident_lnk_scope_def" ON "public"."act_hi_identitylink" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_ident_lnk_sub_scope" ON "public"."act_hi_identitylink" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_ident_lnk_task" ON "public"."act_hi_identitylink" USING btree (
  "task_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_ident_lnk_user" ON "public"."act_hi_identitylink" USING btree (
  "user_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_hi_identitylink
-- ----------------------------
ALTER TABLE "public"."act_hi_identitylink" ADD CONSTRAINT "act_hi_identitylink_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_hi_procinst
-- ----------------------------
CREATE INDEX "act_idx_hi_pro_i_buskey" ON "public"."act_hi_procinst" USING btree (
  "business_key_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_pro_inst_end" ON "public"."act_hi_procinst" USING btree (
  "end_time_" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table act_hi_procinst
-- ----------------------------
ALTER TABLE "public"."act_hi_procinst" ADD CONSTRAINT "act_hi_procinst_proc_inst_id__key" UNIQUE ("proc_inst_id_");

-- ----------------------------
-- Primary Key structure for table act_hi_procinst
-- ----------------------------
ALTER TABLE "public"."act_hi_procinst" ADD CONSTRAINT "act_hi_procinst_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_hi_taskinst
-- ----------------------------
CREATE INDEX "act_idx_hi_task_inst_procinst" ON "public"."act_hi_taskinst" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_task_scope" ON "public"."act_hi_taskinst" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_task_scope_def" ON "public"."act_hi_taskinst" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_task_sub_scope" ON "public"."act_hi_taskinst" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_hi_taskinst
-- ----------------------------
ALTER TABLE "public"."act_hi_taskinst" ADD CONSTRAINT "act_hi_taskinst_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_hi_tsk_log
-- ----------------------------
ALTER TABLE "public"."act_hi_tsk_log" ADD CONSTRAINT "act_hi_tsk_log_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_hi_varinst
-- ----------------------------
CREATE INDEX "act_idx_hi_procvar_exe" ON "public"."act_hi_varinst" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_procvar_name_type" ON "public"."act_hi_varinst" USING btree (
  "name_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "var_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_procvar_proc_inst" ON "public"."act_hi_varinst" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_procvar_task_id" ON "public"."act_hi_varinst" USING btree (
  "task_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_var_scope_id_type" ON "public"."act_hi_varinst" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_hi_var_sub_id_type" ON "public"."act_hi_varinst" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_hi_varinst
-- ----------------------------
ALTER TABLE "public"."act_hi_varinst" ADD CONSTRAINT "act_hi_varinst_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_id_bytearray
-- ----------------------------
ALTER TABLE "public"."act_id_bytearray" ADD CONSTRAINT "act_id_bytearray_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_id_group
-- ----------------------------
ALTER TABLE "public"."act_id_group" ADD CONSTRAINT "act_id_group_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_id_info
-- ----------------------------
ALTER TABLE "public"."act_id_info" ADD CONSTRAINT "act_id_info_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_id_membership
-- ----------------------------
CREATE INDEX "act_idx_memb_group" ON "public"."act_id_membership" USING btree (
  "group_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_memb_user" ON "public"."act_id_membership" USING btree (
  "user_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_id_membership
-- ----------------------------
ALTER TABLE "public"."act_id_membership" ADD CONSTRAINT "act_id_membership_pkey" PRIMARY KEY ("user_id_", "group_id_");

-- ----------------------------
-- Uniques structure for table act_id_priv
-- ----------------------------
ALTER TABLE "public"."act_id_priv" ADD CONSTRAINT "act_uniq_priv_name" UNIQUE ("name_");

-- ----------------------------
-- Primary Key structure for table act_id_priv
-- ----------------------------
ALTER TABLE "public"."act_id_priv" ADD CONSTRAINT "act_id_priv_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_id_priv_mapping
-- ----------------------------
CREATE INDEX "act_idx_priv_group" ON "public"."act_id_priv_mapping" USING btree (
  "group_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_priv_mapping" ON "public"."act_id_priv_mapping" USING btree (
  "priv_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_priv_user" ON "public"."act_id_priv_mapping" USING btree (
  "user_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_id_priv_mapping
-- ----------------------------
ALTER TABLE "public"."act_id_priv_mapping" ADD CONSTRAINT "act_id_priv_mapping_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_id_property
-- ----------------------------
ALTER TABLE "public"."act_id_property" ADD CONSTRAINT "act_id_property_pkey" PRIMARY KEY ("name_");

-- ----------------------------
-- Primary Key structure for table act_id_token
-- ----------------------------
ALTER TABLE "public"."act_id_token" ADD CONSTRAINT "act_id_token_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_id_user
-- ----------------------------
ALTER TABLE "public"."act_id_user" ADD CONSTRAINT "act_id_user_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_procdef_info
-- ----------------------------
CREATE INDEX "act_idx_procdef_info_json" ON "public"."act_procdef_info" USING btree (
  "info_json_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_procdef_info_proc" ON "public"."act_procdef_info" USING btree (
  "proc_def_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table act_procdef_info
-- ----------------------------
ALTER TABLE "public"."act_procdef_info" ADD CONSTRAINT "act_uniq_info_procdef" UNIQUE ("proc_def_id_");

-- ----------------------------
-- Primary Key structure for table act_procdef_info
-- ----------------------------
ALTER TABLE "public"."act_procdef_info" ADD CONSTRAINT "act_procdef_info_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_re_deployment
-- ----------------------------
ALTER TABLE "public"."act_re_deployment" ADD CONSTRAINT "act_re_deployment_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_re_model
-- ----------------------------
CREATE INDEX "act_idx_model_deployment" ON "public"."act_re_model" USING btree (
  "deployment_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_model_source" ON "public"."act_re_model" USING btree (
  "editor_source_value_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_model_source_extra" ON "public"."act_re_model" USING btree (
  "editor_source_extra_value_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_re_model
-- ----------------------------
ALTER TABLE "public"."act_re_model" ADD CONSTRAINT "act_re_model_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Uniques structure for table act_re_procdef
-- ----------------------------
ALTER TABLE "public"."act_re_procdef" ADD CONSTRAINT "act_uniq_procdef" UNIQUE ("key_", "version_", "derived_version_", "tenant_id_");

-- ----------------------------
-- Primary Key structure for table act_re_procdef
-- ----------------------------
ALTER TABLE "public"."act_re_procdef" ADD CONSTRAINT "act_re_procdef_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_actinst
-- ----------------------------
CREATE INDEX "act_idx_ru_acti_end" ON "public"."act_ru_actinst" USING btree (
  "end_time_" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ru_acti_exec" ON "public"."act_ru_actinst" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ru_acti_exec_act" ON "public"."act_ru_actinst" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "act_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ru_acti_proc" ON "public"."act_ru_actinst" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ru_acti_proc_act" ON "public"."act_ru_actinst" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "act_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ru_acti_start" ON "public"."act_ru_actinst" USING btree (
  "start_time_" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_actinst
-- ----------------------------
ALTER TABLE "public"."act_ru_actinst" ADD CONSTRAINT "act_ru_actinst_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_deadletter_job
-- ----------------------------
CREATE INDEX "act_idx_deadletter_job_correlation_id" ON "public"."act_ru_deadletter_job" USING btree (
  "correlation_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_deadletter_job_custom_values_id" ON "public"."act_ru_deadletter_job" USING btree (
  "custom_values_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_deadletter_job_exception_stack_id" ON "public"."act_ru_deadletter_job" USING btree (
  "exception_stack_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_deadletter_job_execution_id" ON "public"."act_ru_deadletter_job" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_deadletter_job_proc_def_id" ON "public"."act_ru_deadletter_job" USING btree (
  "proc_def_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_deadletter_job_process_instance_id" ON "public"."act_ru_deadletter_job" USING btree (
  "process_instance_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_djob_scope" ON "public"."act_ru_deadletter_job" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_djob_scope_def" ON "public"."act_ru_deadletter_job" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_djob_sub_scope" ON "public"."act_ru_deadletter_job" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_deadletter_job
-- ----------------------------
ALTER TABLE "public"."act_ru_deadletter_job" ADD CONSTRAINT "act_ru_deadletter_job_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_entitylink
-- ----------------------------
CREATE INDEX "act_idx_ent_lnk_root_scope" ON "public"."act_ru_entitylink" USING btree (
  "root_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "root_scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "link_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ent_lnk_scope" ON "public"."act_ru_entitylink" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "link_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ent_lnk_scope_def" ON "public"."act_ru_entitylink" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "link_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_entitylink
-- ----------------------------
ALTER TABLE "public"."act_ru_entitylink" ADD CONSTRAINT "act_ru_entitylink_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_event_subscr
-- ----------------------------
CREATE INDEX "act_idx_event_subscr" ON "public"."act_ru_event_subscr" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_event_subscr_config_" ON "public"."act_ru_event_subscr" USING btree (
  "configuration_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_event_subscr
-- ----------------------------
ALTER TABLE "public"."act_ru_event_subscr" ADD CONSTRAINT "act_ru_event_subscr_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_execution
-- ----------------------------
CREATE INDEX "act_idx_exe_parent" ON "public"."act_ru_execution" USING btree (
  "parent_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_exe_procdef" ON "public"."act_ru_execution" USING btree (
  "proc_def_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_exe_procinst" ON "public"."act_ru_execution" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_exe_root" ON "public"."act_ru_execution" USING btree (
  "root_proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_exe_super" ON "public"."act_ru_execution" USING btree (
  "super_exec_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_exec_buskey" ON "public"."act_ru_execution" USING btree (
  "business_key_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_execution
-- ----------------------------
ALTER TABLE "public"."act_ru_execution" ADD CONSTRAINT "act_ru_execution_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_external_job
-- ----------------------------
CREATE INDEX "act_idx_ejob_scope" ON "public"."act_ru_external_job" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ejob_scope_def" ON "public"."act_ru_external_job" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ejob_sub_scope" ON "public"."act_ru_external_job" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_external_job_correlation_id" ON "public"."act_ru_external_job" USING btree (
  "correlation_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_external_job_custom_values_id" ON "public"."act_ru_external_job" USING btree (
  "custom_values_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_external_job_exception_stack_id" ON "public"."act_ru_external_job" USING btree (
  "exception_stack_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_external_job
-- ----------------------------
ALTER TABLE "public"."act_ru_external_job" ADD CONSTRAINT "act_ru_external_job_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table act_ru_history_job
-- ----------------------------
ALTER TABLE "public"."act_ru_history_job" ADD CONSTRAINT "act_ru_history_job_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_identitylink
-- ----------------------------
CREATE INDEX "act_idx_athrz_procedef" ON "public"."act_ru_identitylink" USING btree (
  "proc_def_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ident_lnk_group" ON "public"."act_ru_identitylink" USING btree (
  "group_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ident_lnk_scope" ON "public"."act_ru_identitylink" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ident_lnk_scope_def" ON "public"."act_ru_identitylink" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ident_lnk_sub_scope" ON "public"."act_ru_identitylink" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ident_lnk_user" ON "public"."act_ru_identitylink" USING btree (
  "user_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_idl_procinst" ON "public"."act_ru_identitylink" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_tskass_task" ON "public"."act_ru_identitylink" USING btree (
  "task_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_identitylink
-- ----------------------------
ALTER TABLE "public"."act_ru_identitylink" ADD CONSTRAINT "act_ru_identitylink_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_job
-- ----------------------------
CREATE INDEX "act_idx_job_correlation_id" ON "public"."act_ru_job" USING btree (
  "correlation_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_job_custom_values_id" ON "public"."act_ru_job" USING btree (
  "custom_values_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_job_exception_stack_id" ON "public"."act_ru_job" USING btree (
  "exception_stack_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_job_execution_id" ON "public"."act_ru_job" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_job_proc_def_id" ON "public"."act_ru_job" USING btree (
  "proc_def_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_job_process_instance_id" ON "public"."act_ru_job" USING btree (
  "process_instance_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_job_scope" ON "public"."act_ru_job" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_job_scope_def" ON "public"."act_ru_job" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_job_sub_scope" ON "public"."act_ru_job" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_job
-- ----------------------------
ALTER TABLE "public"."act_ru_job" ADD CONSTRAINT "act_ru_job_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_suspended_job
-- ----------------------------
CREATE INDEX "act_idx_sjob_scope" ON "public"."act_ru_suspended_job" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_sjob_scope_def" ON "public"."act_ru_suspended_job" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_sjob_sub_scope" ON "public"."act_ru_suspended_job" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_suspended_job_correlation_id" ON "public"."act_ru_suspended_job" USING btree (
  "correlation_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_suspended_job_custom_values_id" ON "public"."act_ru_suspended_job" USING btree (
  "custom_values_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_suspended_job_exception_stack_id" ON "public"."act_ru_suspended_job" USING btree (
  "exception_stack_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_suspended_job_execution_id" ON "public"."act_ru_suspended_job" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_suspended_job_proc_def_id" ON "public"."act_ru_suspended_job" USING btree (
  "proc_def_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_suspended_job_process_instance_id" ON "public"."act_ru_suspended_job" USING btree (
  "process_instance_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_suspended_job
-- ----------------------------
ALTER TABLE "public"."act_ru_suspended_job" ADD CONSTRAINT "act_ru_suspended_job_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_task
-- ----------------------------
CREATE INDEX "act_idx_task_create" ON "public"."act_ru_task" USING btree (
  "create_time_" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_task_exec" ON "public"."act_ru_task" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_task_procdef" ON "public"."act_ru_task" USING btree (
  "proc_def_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_task_procinst" ON "public"."act_ru_task" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_task_scope" ON "public"."act_ru_task" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_task_scope_def" ON "public"."act_ru_task" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_task_sub_scope" ON "public"."act_ru_task" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_task
-- ----------------------------
ALTER TABLE "public"."act_ru_task" ADD CONSTRAINT "act_ru_task_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_timer_job
-- ----------------------------
CREATE INDEX "act_idx_timer_job_correlation_id" ON "public"."act_ru_timer_job" USING btree (
  "correlation_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_timer_job_custom_values_id" ON "public"."act_ru_timer_job" USING btree (
  "custom_values_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_timer_job_exception_stack_id" ON "public"."act_ru_timer_job" USING btree (
  "exception_stack_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_timer_job_execution_id" ON "public"."act_ru_timer_job" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_timer_job_proc_def_id" ON "public"."act_ru_timer_job" USING btree (
  "proc_def_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_timer_job_process_instance_id" ON "public"."act_ru_timer_job" USING btree (
  "process_instance_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_tjob_scope" ON "public"."act_ru_timer_job" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_tjob_scope_def" ON "public"."act_ru_timer_job" USING btree (
  "scope_definition_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_tjob_sub_scope" ON "public"."act_ru_timer_job" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_timer_job
-- ----------------------------
ALTER TABLE "public"."act_ru_timer_job" ADD CONSTRAINT "act_ru_timer_job_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table act_ru_variable
-- ----------------------------
CREATE INDEX "act_idx_ru_var_scope_id_type" ON "public"."act_ru_variable" USING btree (
  "scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_ru_var_sub_id_type" ON "public"."act_ru_variable" USING btree (
  "sub_scope_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "scope_type_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_var_bytearray" ON "public"."act_ru_variable" USING btree (
  "bytearray_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_var_exe" ON "public"."act_ru_variable" USING btree (
  "execution_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_var_procinst" ON "public"."act_ru_variable" USING btree (
  "proc_inst_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "act_idx_variable_task_id" ON "public"."act_ru_variable" USING btree (
  "task_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table act_ru_variable
-- ----------------------------
ALTER TABLE "public"."act_ru_variable" ADD CONSTRAINT "act_ru_variable_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table flw_channel_definition
-- ----------------------------
CREATE UNIQUE INDEX "act_idx_channel_def_uniq" ON "public"."flw_channel_definition" USING btree (
  "key_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "version_" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "tenant_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table flw_channel_definition
-- ----------------------------
ALTER TABLE "public"."flw_channel_definition" ADD CONSTRAINT "FLW_CHANNEL_DEFINITION_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table flw_ev_databasechangeloglock
-- ----------------------------
ALTER TABLE "public"."flw_ev_databasechangeloglock" ADD CONSTRAINT "flw_ev_databasechangeloglock_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table flw_event_definition
-- ----------------------------
CREATE UNIQUE INDEX "act_idx_event_def_uniq" ON "public"."flw_event_definition" USING btree (
  "key_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "version_" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "tenant_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table flw_event_definition
-- ----------------------------
ALTER TABLE "public"."flw_event_definition" ADD CONSTRAINT "FLW_EVENT_DEFINITION_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table flw_event_deployment
-- ----------------------------
ALTER TABLE "public"."flw_event_deployment" ADD CONSTRAINT "FLW_EVENT_DEPLOYMENT_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table flw_event_resource
-- ----------------------------
ALTER TABLE "public"."flw_event_resource" ADD CONSTRAINT "FLW_EVENT_RESOURCE_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table flw_ru_batch
-- ----------------------------
ALTER TABLE "public"."flw_ru_batch" ADD CONSTRAINT "flw_ru_batch_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Indexes structure for table flw_ru_batch_part
-- ----------------------------
CREATE INDEX "flw_idx_batch_part" ON "public"."flw_ru_batch_part" USING btree (
  "batch_id_" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table flw_ru_batch_part
-- ----------------------------
ALTER TABLE "public"."flw_ru_batch_part" ADD CONSTRAINT "flw_ru_batch_part_pkey" PRIMARY KEY ("id_");

-- ----------------------------
-- Primary Key structure for table sys_menu
-- ----------------------------
ALTER TABLE "public"."sys_menu" ADD CONSTRAINT "sys_menu_pkey" PRIMARY KEY ("menu_id");

-- ----------------------------
-- Primary Key structure for table t_account
-- ----------------------------
ALTER TABLE "public"."t_account" ADD CONSTRAINT "t_payment_pkey1" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_account_balance
-- ----------------------------
ALTER TABLE "public"."t_account_balance" ADD CONSTRAINT "t_house_balance_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_account_flow_information
-- ----------------------------
ALTER TABLE "public"."t_account_flow_information" ADD CONSTRAINT "t_account_flow_information_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_account_remind
-- ----------------------------
ALTER TABLE "public"."t_account_remind" ADD CONSTRAINT "t_account_remind_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_account_result
-- ----------------------------
ALTER TABLE "public"."t_account_result" ADD CONSTRAINT "t_account_result_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_batch_payment
-- ----------------------------
ALTER TABLE "public"."t_batch_payment" ADD CONSTRAINT "t_batch_payment_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_batch_refund
-- ----------------------------
ALTER TABLE "public"."t_batch_refund" ADD CONSTRAINT "t_batch_refund_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_bill
-- ----------------------------
ALTER TABLE "public"."t_bill" ADD CONSTRAINT "t_payment_pkey3" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_buildup
-- ----------------------------
ALTER TABLE "public"."t_buildup" ADD CONSTRAINT "t_payment_pkey4" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_collective_balance
-- ----------------------------
ALTER TABLE "public"."t_collective_balance" ADD CONSTRAINT "t_collective_balance_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_current_bill
-- ----------------------------
ALTER TABLE "public"."t_current_bill" ADD CONSTRAINT "t_current_bill_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_everyday_account_allbal
-- ----------------------------
ALTER TABLE "public"."t_everyday_account_allbal" ADD CONSTRAINT "t_everyday_allbal_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_everyday_bank_bill
-- ----------------------------
ALTER TABLE "public"."t_everyday_bank_bill" ADD CONSTRAINT "t_payment_pkey2" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_everyday_platform_bill
-- ----------------------------
ALTER TABLE "public"."t_everyday_platform_bill" ADD CONSTRAINT "t_everyday_bill_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_major_capital
-- ----------------------------
ALTER TABLE "public"."t_major_capital" ADD CONSTRAINT "t_major_transfer_capital_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_notice
-- ----------------------------
ALTER TABLE "public"."t_notice" ADD CONSTRAINT "t_payment_pkey6" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_profit_payment
-- ----------------------------
ALTER TABLE "public"."t_profit_payment" ADD CONSTRAINT "t_profit_payment_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_rate
-- ----------------------------
ALTER TABLE "public"."t_rate" ADD CONSTRAINT "t_rate_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_repair_capital
-- ----------------------------
ALTER TABLE "public"."t_repair_capital" ADD CONSTRAINT "t_repair_capital_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_revolving_fund
-- ----------------------------
ALTER TABLE "public"."t_revolving_fund" ADD CONSTRAINT "t_revolving_fund_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_settlement_interest
-- ----------------------------
ALTER TABLE "public"."t_settlement_interest" ADD CONSTRAINT "t_settlement_interest_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_single_payment
-- ----------------------------
ALTER TABLE "public"."t_single_payment" ADD CONSTRAINT "t_payment_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_single_refund
-- ----------------------------
ALTER TABLE "public"."t_single_refund" ADD CONSTRAINT "t_single_refund_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_tp
-- ----------------------------
ALTER TABLE "public"."t_tp" ADD CONSTRAINT "t_tp_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_tpdoc
-- ----------------------------
ALTER TABLE "public"."t_tpdoc" ADD CONSTRAINT "t_tp_copy1_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_transfer
-- ----------------------------
ALTER TABLE "public"."t_transfer" ADD CONSTRAINT "t_transfer_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table t_transferdoc
-- ----------------------------
ALTER TABLE "public"."t_transferdoc" ADD CONSTRAINT "t_transferdoc_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_dp_cxcs
-- ----------------------------
ALTER TABLE "public"."wxzj_dp_cxcs" ADD CONSTRAINT "qw_dp_cxcs_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_dzhd_bank
-- ----------------------------
ALTER TABLE "public"."wxzj_dzhd_bank" ADD CONSTRAINT "wxzj_dzhd_bank_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_dzhd_business
-- ----------------------------
ALTER TABLE "public"."wxzj_dzhd_business" ADD CONSTRAINT "wxzj_dzhd_business_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_fhzh
-- ----------------------------
ALTER TABLE "public"."wxzj_fhzh" ADD CONSTRAINT "wxzj_fhzh_pkey1" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_fhzh_zzdj
-- ----------------------------
ALTER TABLE "public"."wxzj_fhzh_zzdj" ADD CONSTRAINT "wxzj_fhzh_zzdj_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_file
-- ----------------------------
ALTER TABLE "public"."wxzj_file" ADD CONSTRAINT "wxzj_yysq_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table wxzj_fw
-- ----------------------------
CREATE INDEX "fw_inde_key" ON "public"."wxzj_fw" USING hash (
  "fwdm" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops"
);
COMMENT ON INDEX "public"."fw_inde_key" IS '房屋代码索引';

-- ----------------------------
-- Triggers structure for table wxzj_fw
-- ----------------------------
CREATE TRIGGER "up" BEFORE UPDATE ON "public"."wxzj_fw"
FOR EACH ROW
EXECUTE PROCEDURE "public"."cs_timestamp"();

-- ----------------------------
-- Primary Key structure for table wxzj_fzhs
-- ----------------------------
ALTER TABLE "public"."wxzj_fzhs" ADD CONSTRAINT "wxzj_fzhs_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_fzhs_kjpz
-- ----------------------------
ALTER TABLE "public"."wxzj_fzhs_kjpz" ADD CONSTRAINT "wxzj_fzhs_kjpz_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_gsxx_file
-- ----------------------------
ALTER TABLE "public"."wxzj_gsxx_file" ADD CONSTRAINT "wxzj_gsxx_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_hqdz
-- ----------------------------
ALTER TABLE "public"."wxzj_hqdz" ADD CONSTRAINT "wxzj_hqdz_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_information
-- ----------------------------
ALTER TABLE "public"."wxzj_information" ADD CONSTRAINT "wxzj_information_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_jcls
-- ----------------------------
ALTER TABLE "public"."wxzj_jcls" ADD CONSTRAINT "wxzj_jcls_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table wxzj_jcls_batch
-- ----------------------------
CREATE INDEX "jc_index_fhzh_id" ON "public"."wxzj_jcls_batch" USING btree (
  "fhzh_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);
COMMENT ON INDEX "public"."jc_index_fhzh_id" IS '交存流水账户索引';

-- ----------------------------
-- Primary Key structure for table wxzj_jcls_batch
-- ----------------------------
ALTER TABLE "public"."wxzj_jcls_batch" ADD CONSTRAINT "wxzj_jcls__pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_jctzd
-- ----------------------------
ALTER TABLE "public"."wxzj_jctzd" ADD CONSTRAINT "wxzj_tzd_pkey1" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_jctzd_batch
-- ----------------------------
ALTER TABLE "public"."wxzj_jctzd_batch" ADD CONSTRAINT "wxzj_jctzd_batch_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table wxzj_jgxx
-- ----------------------------
CREATE TRIGGER "up" BEFORE UPDATE ON "public"."wxzj_jgxx"
FOR EACH ROW
EXECUTE PROCEDURE "public"."cs_timestamp"();

-- ----------------------------
-- Primary Key structure for table wxzj_jgxx
-- ----------------------------
ALTER TABLE "public"."wxzj_jgxx" ADD CONSTRAINT "wxzj_jgxx_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_jgxx_file
-- ----------------------------
ALTER TABLE "public"."wxzj_jgxx_file" ADD CONSTRAINT "wxzj_jgxx_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_jgxx_ysb
-- ----------------------------
ALTER TABLE "public"."wxzj_jgxx_ysb" ADD CONSTRAINT "wxzj_jgxx_ysb_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table wxzj_kjkm
-- ----------------------------
CREATE TRIGGER "up" BEFORE UPDATE ON "public"."wxzj_kjkm"
FOR EACH ROW
EXECUTE PROCEDURE "public"."cs_timestamp"();

-- ----------------------------
-- Primary Key structure for table wxzj_kjkm
-- ----------------------------
ALTER TABLE "public"."wxzj_kjkm" ADD CONSTRAINT "wxzj_kjkm_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjkm_fzhs
-- ----------------------------
ALTER TABLE "public"."wxzj_kjkm_fzhs" ADD CONSTRAINT "wxzj_kjkm_fzhs_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjkm_je
-- ----------------------------
ALTER TABLE "public"."wxzj_kjkm_je" ADD CONSTRAINT "wxzj_kjkm_je_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjkm_jz
-- ----------------------------
ALTER TABLE "public"."wxzj_kjkm_jz" ADD CONSTRAINT "wxzj_kjkm_jz_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjkm_qmjz
-- ----------------------------
ALTER TABLE "public"."wxzj_kjkm_qmjz" ADD CONSTRAINT "wxzj_kjkm_qmjz_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table wxzj_kjpz
-- ----------------------------
CREATE TRIGGER "up" BEFORE UPDATE ON "public"."wxzj_kjpz"
FOR EACH ROW
EXECUTE PROCEDURE "public"."cs_timestamp"();

-- ----------------------------
-- Primary Key structure for table wxzj_kjpz
-- ----------------------------
ALTER TABLE "public"."wxzj_kjpz" ADD CONSTRAINT "wxzj_kjpz_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjpz_auto
-- ----------------------------
ALTER TABLE "public"."wxzj_kjpz_auto" ADD CONSTRAINT "wxzj_kjpz_auto_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjpz_file
-- ----------------------------
ALTER TABLE "public"."wxzj_kjpz_file" ADD CONSTRAINT "wxzj_kjpz_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjpz_kjkm
-- ----------------------------
ALTER TABLE "public"."wxzj_kjpz_kjkm" ADD CONSTRAINT "wxzj_kjpz_kjkm_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjzt
-- ----------------------------
ALTER TABLE "public"."wxzj_kjzt" ADD CONSTRAINT "wxzj_kjzt_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_kjzt_dept
-- ----------------------------
ALTER TABLE "public"."wxzj_kjzt_dept" ADD CONSTRAINT "wxzj_kjzt_dept_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table wxzj_ld
-- ----------------------------
CREATE INDEX "ld_index_key" ON "public"."wxzj_ld" USING hash (
  "lzdm" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops"
);
COMMENT ON INDEX "public"."ld_index_key" IS '楼幢代码索引';

-- ----------------------------
-- Triggers structure for table wxzj_ld
-- ----------------------------
CREATE TRIGGER "up" BEFORE UPDATE ON "public"."wxzj_ld"
FOR EACH ROW
EXECUTE PROCEDURE "public"."cs_timestamp"();

-- ----------------------------
-- Primary Key structure for table wxzj_ld
-- ----------------------------
ALTER TABLE "public"."wxzj_ld" ADD CONSTRAINT "wxzj_ld_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_mrjz
-- ----------------------------
ALTER TABLE "public"."wxzj_mrjz" ADD CONSTRAINT "wxzj_mrjz_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_order_log
-- ----------------------------
ALTER TABLE "public"."wxzj_order_log" ADD CONSTRAINT "wxzj_order_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_order_log_batch
-- ----------------------------
ALTER TABLE "public"."wxzj_order_log_batch" ADD CONSTRAINT "wxzj_order_log_batch_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_pj
-- ----------------------------
ALTER TABLE "public"."wxzj_pj" ADD CONSTRAINT "wxzj_pj_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_qw_order
-- ----------------------------
ALTER TABLE "public"."wxzj_qw_order" ADD CONSTRAINT "wxzj_qw_order_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_review
-- ----------------------------
ALTER TABLE "public"."wxzj_review" ADD CONSTRAINT "wxzj_review_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_sssb
-- ----------------------------
ALTER TABLE "public"."wxzj_sssb" ADD CONSTRAINT "wxzj_sssb_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_tk_review
-- ----------------------------
ALTER TABLE "public"."wxzj_tk_review" ADD CONSTRAINT "wxzj_tk_review_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_tkls_batch
-- ----------------------------
ALTER TABLE "public"."wxzj_tkls_batch" ADD CONSTRAINT "wxzj_tkls_batch_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_tpqm_file
-- ----------------------------
ALTER TABLE "public"."wxzj_tpqm_file" ADD CONSTRAINT "wxzj_tpqm_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_tpxx_file
-- ----------------------------
ALTER TABLE "public"."wxzj_tpxx_file" ADD CONSTRAINT "wxzj_tpxx_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_tzd_log
-- ----------------------------
ALTER TABLE "public"."wxzj_tzd_log" ADD CONSTRAINT "wxzj_tzd_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_tzd_order
-- ----------------------------
ALTER TABLE "public"."wxzj_tzd_order" ADD CONSTRAINT "wxzj_tzd_order_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_voucher_infoVo
-- ----------------------------
ALTER TABLE "public"."wxzj_voucher_infoVo" ADD CONSTRAINT "wxzj_voucher_InfoVo_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table wxzj_wyqy
-- ----------------------------
CREATE INDEX "qydm_key" ON "public"."wxzj_wyqy" USING hash (
  "wyqydm" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops"
);
COMMENT ON INDEX "public"."qydm_key" IS '物业区域代码';

-- ----------------------------
-- Triggers structure for table wxzj_wyqy
-- ----------------------------
CREATE TRIGGER "up" BEFORE UPDATE ON "public"."wxzj_wyqy"
FOR EACH ROW
EXECUTE PROCEDURE "public"."cs_timestamp"();

-- ----------------------------
-- Primary Key structure for table wxzj_wyqy
-- ----------------------------
ALTER TABLE "public"."wxzj_wyqy" ADD CONSTRAINT "wxzj_wyqy_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_xwdt_file
-- ----------------------------
ALTER TABLE "public"."wxzj_xwdt_file" ADD CONSTRAINT "wxzj_xwdt_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_xzqh
-- ----------------------------
ALTER TABLE "public"."wxzj_xzqh" ADD CONSTRAINT "wxzj_xzqh_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_yhckrjz
-- ----------------------------
ALTER TABLE "public"."wxzj_yhckrjz" ADD CONSTRAINT "wxzj_yhckrjz_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_yhzd
-- ----------------------------
ALTER TABLE "public"."wxzj_yhzd" ADD CONSTRAINT "wxzj_yhzd_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table wxzj_yhzh
-- ----------------------------
CREATE TRIGGER "up" BEFORE UPDATE ON "public"."wxzj_yhzh"
FOR EACH ROW
EXECUTE PROCEDURE "public"."cs_timestamp"();

-- ----------------------------
-- Primary Key structure for table wxzj_yhzh
-- ----------------------------
ALTER TABLE "public"."wxzj_yhzh" ADD CONSTRAINT "wxzj_yhzh_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_ywtb_qxsx
-- ----------------------------
ALTER TABLE "public"."wxzj_ywtb_qxsx" ADD CONSTRAINT "wxzj_ywtb_qxsx_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_ywtb_sxcl
-- ----------------------------
ALTER TABLE "public"."wxzj_ywtb_sxcl" ADD CONSTRAINT "wxzj_ywtb_sxcl_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_ywtbjd_log
-- ----------------------------
ALTER TABLE "public"."wxzj_ywtbjd_log" ADD CONSTRAINT "ywtb_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_ywtbsqcl_file
-- ----------------------------
ALTER TABLE "public"."wxzj_ywtbsqcl_file" ADD CONSTRAINT "wxzj_ywtbsqcl_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_yysq
-- ----------------------------
ALTER TABLE "public"."wxzj_yysq" ADD CONSTRAINT "wxzj_yysq_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table wxzj_yz
-- ----------------------------
CREATE INDEX "index_fhzh_id" ON "public"."wxzj_yz" USING btree (
  "fhzh_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);
COMMENT ON INDEX "public"."index_fhzh_id" IS '账户索引';
CREATE INDEX "index_zjhm" ON "public"."wxzj_yz" USING btree (
  "zjhm" COLLATE "pg_catalog"."default" "pg_catalog"."varchar_ops" ASC NULLS LAST
);
COMMENT ON INDEX "public"."index_zjhm" IS '证件号码索引';

-- ----------------------------
-- Primary Key structure for table wxzj_yz
-- ----------------------------
ALTER TABLE "public"."wxzj_yz" ADD CONSTRAINT "wxzj_yz_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_yztpb
-- ----------------------------
ALTER TABLE "public"."wxzj_yztpb" ADD CONSTRAINT "业主投票表_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table wxzj_yzwyh
-- ----------------------------
CREATE TRIGGER "up" BEFORE UPDATE ON "public"."wxzj_yzwyh"
FOR EACH ROW
EXECUTE PROCEDURE "public"."cs_timestamp"();

-- ----------------------------
-- Primary Key structure for table wxzj_yzwyh
-- ----------------------------
ALTER TABLE "public"."wxzj_yzwyh" ADD CONSTRAINT "wxzj_yzwyh_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhcx
-- ----------------------------
ALTER TABLE "public"."wxzj_zhcx" ADD CONSTRAINT "wxzj_zhcx_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table wxzj_zhfw_fj
-- ----------------------------
CREATE INDEX "glzy_id" ON "public"."wxzj_zhfw_fj" USING btree (
  "glzy_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_fj
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_fj" ADD CONSTRAINT "wxzj_zhfw_fj_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_fwxx
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_fwxx" ADD CONSTRAINT "wxzj_zhfw_sjfw_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_gljg
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_gljg" ADD CONSTRAINT "wxzj_zhfw_gljg_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_gs_log
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_gs_log" ADD CONSTRAINT "wxzj_zhfw_gs_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_gsxx
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_gsxx" ADD CONSTRAINT "wxzj_zhfw_gsxx_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_hdp
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_hdp" ADD CONSTRAINT "wxzj_zhfw_hdp_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_tp
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_tp" ADD CONSTRAINT "wxzj_tpxxb_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_tp_log
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_tp_log" ADD CONSTRAINT "wxzj_zhfw_tp_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_xglj
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_xglj" ADD CONSTRAINT "wxzj_zhfw_xglj_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_xwdt
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_xwdt" ADD CONSTRAINT "wxzj_zhfw_xwdt_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_xwfj
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_xwfj" ADD CONSTRAINT "wxzj_zhfw_xwfj_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_xwfl
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_xwfl" ADD CONSTRAINT "wxzj_zhfw_xwlx_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table wxzj_zhfw_yzxx
-- ----------------------------
CREATE INDEX "open_id key" ON "public"."wxzj_zhfw_yzxx" USING hash (
  "open_id" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops"
);
COMMENT ON INDEX "public"."open_id key" IS 'Opened';

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_yzxx
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_yzxx" ADD CONSTRAINT "wxzj_zhfw_yzxx_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_zlb
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_zlb" ADD CONSTRAINT "wxzj_zhfw_zlb_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhfw_zlfj
-- ----------------------------
ALTER TABLE "public"."wxzj_zhfw_zlfj" ADD CONSTRAINT "wxzj_zhfw_zlfj_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zhjymx
-- ----------------------------
ALTER TABLE "public"."wxzj_zhjymx" ADD CONSTRAINT "wxzj_zhjymx_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy" ADD CONSTRAINT "wxzj_zjsy_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_file
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_file" ADD CONSTRAINT "wxzj_zjsy_file_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_ft_log
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_ft_log" ADD CONSTRAINT "wxzj_zjsy_ft_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_gs
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_gs" ADD CONSTRAINT "wxzj_zjsy_gs_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_hb
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_hb" ADD CONSTRAINT "wxzj_zjsy_syhb_copy1_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_hbsq
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_hbsq" ADD CONSTRAINT "wxzj_zjsy_hb_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_hbsq_log
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_hbsq_log" ADD CONSTRAINT "wxzj_hbsq_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_sgdw
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_sgdw" ADD CONSTRAINT "wxjz_zjsy_sgdw_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_sh
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_sh" ADD CONSTRAINT "wxzj_zjsy_sh_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_sqr
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_sqr" ADD CONSTRAINT "wxzj_zjsy_sqr_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_syhb
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_syhb" ADD CONSTRAINT "wxzj_zjsy_hb_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_tp
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_tp" ADD CONSTRAINT "wxzj_zjsy_tp_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjsy_tzd
-- ----------------------------
ALTER TABLE "public"."wxzj_zjsy_tzd" ADD CONSTRAINT "wxzj_zjzz_tzd_copy1_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjtktzd
-- ----------------------------
ALTER TABLE "public"."wxzj_zjtktzd" ADD CONSTRAINT "wxzj_zjtktzd_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjtktzd_batch
-- ----------------------------
ALTER TABLE "public"."wxzj_zjtktzd_batch" ADD CONSTRAINT "wxzj_zijtktzd_batch_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_dqgz
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_dqgz" ADD CONSTRAINT "wxzj_zjzz__pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_ft_log
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_ft_log" ADD CONSTRAINT "wxzj_zjzz_ft_record_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_glfh
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_glfh" ADD CONSTRAINT "wxzj_zjzzft_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_hq
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_hq" ADD CONSTRAINT "wxzj_zjzz_hq_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_pzdh
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_pzdh" ADD CONSTRAINT "wxzj_zjzz_pzdh_doc_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_sr
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_sr" ADD CONSTRAINT "wxzj_zjzz_sr_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_srfh
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_srfh" ADD CONSTRAINT "wxzj_zjzz_srfh_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_tzd
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_tzd" ADD CONSTRAINT "wxzj_zjzz_tzd_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_zjfc
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_zjfc" ADD CONSTRAINT "wxzj_zjzz_zjfc_doc_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zjzz_zjsp
-- ----------------------------
ALTER TABLE "public"."wxzj_zjzz_zjsp" ADD CONSTRAINT "wxzj_zjzz_zjfc_copy1_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table wxzj_zl
-- ----------------------------
ALTER TABLE "public"."wxzj_zl" ADD CONSTRAINT "wxzj_zl_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table xxl_job_group
-- ----------------------------
ALTER TABLE "public"."xxl_job_group" ADD CONSTRAINT "xxl_job_group_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table xxl_job_info
-- ----------------------------
ALTER TABLE "public"."xxl_job_info" ADD CONSTRAINT "xxl_job_info_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table xxl_job_lock
-- ----------------------------
ALTER TABLE "public"."xxl_job_lock" ADD CONSTRAINT "xxl_job_lock_pkey" PRIMARY KEY ("lock_name");

-- ----------------------------
-- Indexes structure for table xxl_job_log
-- ----------------------------
CREATE INDEX "I_handle_code" ON "public"."xxl_job_log" USING btree (
  "handle_code" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "I_trigger_time" ON "public"."xxl_job_log" USING btree (
  "trigger_time" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table xxl_job_log
-- ----------------------------
ALTER TABLE "public"."xxl_job_log" ADD CONSTRAINT "xxl_job_log_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table xxl_job_log_report
-- ----------------------------
CREATE INDEX "i_trigger_day" ON "public"."xxl_job_log_report" USING btree (
  "trigger_day" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table xxl_job_log_report
-- ----------------------------
ALTER TABLE "public"."xxl_job_log_report" ADD CONSTRAINT "xxl_job_log_report_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table xxl_job_logglue
-- ----------------------------
ALTER TABLE "public"."xxl_job_logglue" ADD CONSTRAINT "xxl_job_logglue_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table xxl_job_registry
-- ----------------------------
CREATE INDEX "i_g_k_v" ON "public"."xxl_job_registry" USING btree (
  "registry_group" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "registry_key" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "registry_value" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table xxl_job_registry
-- ----------------------------
ALTER TABLE "public"."xxl_job_registry" ADD CONSTRAINT "xxl_job_registry_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table xxl_job_user
-- ----------------------------
CREATE INDEX "i_username" ON "public"."xxl_job_user" USING btree (
  "username" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table xxl_job_user
-- ----------------------------
ALTER TABLE "public"."xxl_job_user" ADD CONSTRAINT "xxl_job_user_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table act_ge_bytearray
-- ----------------------------
ALTER TABLE "public"."act_ge_bytearray" ADD CONSTRAINT "act_fk_bytearr_depl" FOREIGN KEY ("deployment_id_") REFERENCES "public"."act_re_deployment" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_id_membership
-- ----------------------------
ALTER TABLE "public"."act_id_membership" ADD CONSTRAINT "act_fk_memb_group" FOREIGN KEY ("group_id_") REFERENCES "public"."act_id_group" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_id_membership" ADD CONSTRAINT "act_fk_memb_user" FOREIGN KEY ("user_id_") REFERENCES "public"."act_id_user" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_id_priv_mapping
-- ----------------------------
ALTER TABLE "public"."act_id_priv_mapping" ADD CONSTRAINT "act_fk_priv_mapping" FOREIGN KEY ("priv_id_") REFERENCES "public"."act_id_priv" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_procdef_info
-- ----------------------------
ALTER TABLE "public"."act_procdef_info" ADD CONSTRAINT "act_fk_info_json_ba" FOREIGN KEY ("info_json_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_procdef_info" ADD CONSTRAINT "act_fk_info_procdef" FOREIGN KEY ("proc_def_id_") REFERENCES "public"."act_re_procdef" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_re_model
-- ----------------------------
ALTER TABLE "public"."act_re_model" ADD CONSTRAINT "act_fk_model_deployment" FOREIGN KEY ("deployment_id_") REFERENCES "public"."act_re_deployment" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_re_model" ADD CONSTRAINT "act_fk_model_source" FOREIGN KEY ("editor_source_value_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_re_model" ADD CONSTRAINT "act_fk_model_source_extra" FOREIGN KEY ("editor_source_extra_value_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_deadletter_job
-- ----------------------------
ALTER TABLE "public"."act_ru_deadletter_job" ADD CONSTRAINT "act_fk_deadletter_job_custom_values" FOREIGN KEY ("custom_values_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_deadletter_job" ADD CONSTRAINT "act_fk_deadletter_job_exception" FOREIGN KEY ("exception_stack_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_deadletter_job" ADD CONSTRAINT "act_fk_deadletter_job_execution" FOREIGN KEY ("execution_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_deadletter_job" ADD CONSTRAINT "act_fk_deadletter_job_proc_def" FOREIGN KEY ("proc_def_id_") REFERENCES "public"."act_re_procdef" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_deadletter_job" ADD CONSTRAINT "act_fk_deadletter_job_process_instance" FOREIGN KEY ("process_instance_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_event_subscr
-- ----------------------------
ALTER TABLE "public"."act_ru_event_subscr" ADD CONSTRAINT "act_fk_event_exec" FOREIGN KEY ("execution_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_execution
-- ----------------------------
ALTER TABLE "public"."act_ru_execution" ADD CONSTRAINT "act_fk_exe_parent" FOREIGN KEY ("parent_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_execution" ADD CONSTRAINT "act_fk_exe_procdef" FOREIGN KEY ("proc_def_id_") REFERENCES "public"."act_re_procdef" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_execution" ADD CONSTRAINT "act_fk_exe_procinst" FOREIGN KEY ("proc_inst_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_execution" ADD CONSTRAINT "act_fk_exe_super" FOREIGN KEY ("super_exec_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_external_job
-- ----------------------------
ALTER TABLE "public"."act_ru_external_job" ADD CONSTRAINT "act_fk_external_job_custom_values" FOREIGN KEY ("custom_values_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_external_job" ADD CONSTRAINT "act_fk_external_job_exception" FOREIGN KEY ("exception_stack_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_identitylink
-- ----------------------------
ALTER TABLE "public"."act_ru_identitylink" ADD CONSTRAINT "act_fk_athrz_procedef" FOREIGN KEY ("proc_def_id_") REFERENCES "public"."act_re_procdef" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_identitylink" ADD CONSTRAINT "act_fk_idl_procinst" FOREIGN KEY ("proc_inst_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_identitylink" ADD CONSTRAINT "act_fk_tskass_task" FOREIGN KEY ("task_id_") REFERENCES "public"."act_ru_task" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_job
-- ----------------------------
ALTER TABLE "public"."act_ru_job" ADD CONSTRAINT "act_fk_job_custom_values" FOREIGN KEY ("custom_values_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_job" ADD CONSTRAINT "act_fk_job_exception" FOREIGN KEY ("exception_stack_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_job" ADD CONSTRAINT "act_fk_job_execution" FOREIGN KEY ("execution_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_job" ADD CONSTRAINT "act_fk_job_proc_def" FOREIGN KEY ("proc_def_id_") REFERENCES "public"."act_re_procdef" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_job" ADD CONSTRAINT "act_fk_job_process_instance" FOREIGN KEY ("process_instance_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_suspended_job
-- ----------------------------
ALTER TABLE "public"."act_ru_suspended_job" ADD CONSTRAINT "act_fk_suspended_job_custom_values" FOREIGN KEY ("custom_values_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_suspended_job" ADD CONSTRAINT "act_fk_suspended_job_exception" FOREIGN KEY ("exception_stack_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_suspended_job" ADD CONSTRAINT "act_fk_suspended_job_execution" FOREIGN KEY ("execution_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_suspended_job" ADD CONSTRAINT "act_fk_suspended_job_proc_def" FOREIGN KEY ("proc_def_id_") REFERENCES "public"."act_re_procdef" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_suspended_job" ADD CONSTRAINT "act_fk_suspended_job_process_instance" FOREIGN KEY ("process_instance_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_task
-- ----------------------------
ALTER TABLE "public"."act_ru_task" ADD CONSTRAINT "act_fk_task_exe" FOREIGN KEY ("execution_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_task" ADD CONSTRAINT "act_fk_task_procdef" FOREIGN KEY ("proc_def_id_") REFERENCES "public"."act_re_procdef" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_task" ADD CONSTRAINT "act_fk_task_procinst" FOREIGN KEY ("proc_inst_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_timer_job
-- ----------------------------
ALTER TABLE "public"."act_ru_timer_job" ADD CONSTRAINT "act_fk_timer_job_custom_values" FOREIGN KEY ("custom_values_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_timer_job" ADD CONSTRAINT "act_fk_timer_job_exception" FOREIGN KEY ("exception_stack_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_timer_job" ADD CONSTRAINT "act_fk_timer_job_execution" FOREIGN KEY ("execution_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_timer_job" ADD CONSTRAINT "act_fk_timer_job_proc_def" FOREIGN KEY ("proc_def_id_") REFERENCES "public"."act_re_procdef" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_timer_job" ADD CONSTRAINT "act_fk_timer_job_process_instance" FOREIGN KEY ("process_instance_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table act_ru_variable
-- ----------------------------
ALTER TABLE "public"."act_ru_variable" ADD CONSTRAINT "act_fk_var_bytearray" FOREIGN KEY ("bytearray_id_") REFERENCES "public"."act_ge_bytearray" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_variable" ADD CONSTRAINT "act_fk_var_exe" FOREIGN KEY ("execution_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."act_ru_variable" ADD CONSTRAINT "act_fk_var_procinst" FOREIGN KEY ("proc_inst_id_") REFERENCES "public"."act_ru_execution" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table flw_ru_batch_part
-- ----------------------------
ALTER TABLE "public"."flw_ru_batch_part" ADD CONSTRAINT "flw_fk_batch_part_parent" FOREIGN KEY ("batch_id_") REFERENCES "public"."flw_ru_batch" ("id_") ON DELETE NO ACTION ON UPDATE NO ACTION;
