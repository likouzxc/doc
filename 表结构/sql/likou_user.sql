DROP DATABASE IF EXISTS `likou_user`;

CREATE DATABASE `likou_user`;

USE `likou_user`;

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `log_user_behavior`
-- ----------------------------
DROP TABLE IF EXISTS `log_user_behavior`;
CREATE TABLE `log_user_behavior` (
  `id` char(32) NOT NULL COMMENT '操作记录id',
  `user_id` char(32) NOT NULL COMMENT '用户id',
  `type` int(11) NOT NULL COMMENT '操作类型：1:注册，2:登录，3:修改昵称，4:密码修改',
  `device` varchar(32) DEFAULT NULL COMMENT '通过何种设备进行操作',
  `content` varchar(255) DEFAULT NULL COMMENT '操作内容',
  `operator` char(32) NOT NULL DEFAULT '' COMMENT '操作人，系统操作则为0，否则为user表的id值',
  `create_time` int(11) NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `index_user_id` (`user_id`) USING BTREE,
  KEY `index_type` (`type`) USING BTREE,
  KEY `index_device` (`device`) USING BTREE,
  KEY `index_operator` (`operator`) USING BTREE,
  KEY `index_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户行为记录表，仅记录用户（客户）的操作行为';

-- ----------------------------
--  Table structure for `log_user_power`
-- ----------------------------
DROP TABLE IF EXISTS `log_user_power`;
CREATE TABLE `log_user_power` (
  `id` char(32) NOT NULL COMMENT '操作记录id',
  `outer_id` char(32) NOT NULL COMMENT '针对组织架构权限表的id或者人员岗位排除表的id',
  `data_type` tinyint(1) NOT NULL COMMENT '操作数据的类型：0：组织架构的权限表，1：人员权限排除权限表',
  `type` int(11) NOT NULL COMMENT '操作类型，1：添加权限；2：修改权限；3：删除权限',
  `old` varchar(255) DEFAULT NULL COMMENT '变更前数据',
  `new` varchar(255) DEFAULT NULL COMMENT '变更后数据',
  `operator` char(32) NOT NULL COMMENT '操作人',
  `create_time` int(11) NOT NULL COMMENT '操作时间',
  PRIMARY KEY (`id`),
  KEY `index_operation` (`operator`),
  KEY `index_outer_id` (`outer_id`,`data_type`),
  KEY `index_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户权限操作日志表';

-- ----------------------------
--  Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` char(32) NOT NULL COMMENT '用户id',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名称，可作为登录名称，由英文和数字组成',
  `nickname` varchar(255) DEFAULT NULL COMMENT '用户昵称',
  `email` varchar(255) DEFAULT NULL COMMENT '用户email，可作为登录使用',
  `mobile` varchar(255) DEFAULT NULL COMMENT '用户手机号，可作为登录使用，纯数字',
  `password` varchar(255) NOT NULL COMMENT '用户登录密码，RSA加密',
  `source` int(11) DEFAULT NULL COMMENT '用户来源',
  `flag` varchar(32) DEFAULT NULL COMMENT '来源标记',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '用户类型，0:用户（客户） ，1:员工',
  `create_time` int(11) NOT NULL COMMENT '用户创建时间',
  `update_time` int(11) NOT NULL COMMENT '用户信息修改时间',
  `last_login` int(11) DEFAULT NULL COMMENT '用户最后登录时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_username` (`username`) USING BTREE,
  UNIQUE KEY `unique_email` (`email`) USING BTREE,
  UNIQUE KEY `unique_mobile` (`mobile`) USING BTREE,
  KEY `index_source` (`source`) USING BTREE,
  KEY `index_flag` (`flag`) USING BTREE,
  KEY `index_create_time` (`create_time`) USING BTREE,
  KEY `index_last_login` (`last_login`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='储存所有用户基本信息，包括客户以及员工的基本信息';

-- ----------------------------
--  Table structure for `user_exclude_power`
-- ----------------------------
DROP TABLE IF EXISTS `user_exclude_power`;
CREATE TABLE `user_exclude_power` (
  `id` char(32) NOT NULL COMMENT '权限id',
  `user_id` char(32) NOT NULL COMMENT '用户id',
  `project_function_id` char(32) COMMENT '工程基本功能表id',
  `name` varchar(32) NOT NULL COMMENT '权限名称',
  `project` char(32) NOT NULL COMMENT '项目id',
  `url` varchar(255) DEFAULT NULL COMMENT '地址，正则表达式',
  `status` tinyint(1) NOT NULL COMMENT '状态，0：无效，1:有效',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  `description` varchar(255) DEFAULT NULL COMMENT '权限描述',
  PRIMARY KEY (`id`),
  KEY `index_user_id` (`user_id`),
  KEY `index_project` (`project`),
  KEY `index_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='人员岗位权限排除表';

-- ----------------------------
--  Table structure for `user_position`
-- ----------------------------
DROP TABLE IF EXISTS `user_position`;
CREATE TABLE `user_position` (
  `id` char(32) NOT NULL COMMENT '人员架构编号id',
  `name` varchar(32) NOT NULL COMMENT '人员架构名称',
  `rank` int(11) NOT NULL COMMENT '人员架构所属等级',
  `superior` char(32) NOT NULL COMMENT '所属上级',
  `status` tinyint(1) NOT NULL COMMENT '状态，0:无效，1:有效',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改架构时间',
  PRIMARY KEY (`id`),
  KEY `index_superior` (`superior`) USING BTREE,
  KEY `index_status` (`status`),
  KEY `index_rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='人员组织架构';

-- ----------------------------
--  Table structure for `user_position_power`
-- ----------------------------
DROP TABLE IF EXISTS `user_position_power`;
CREATE TABLE `user_position_power` (
  `id` char(32) NOT NULL COMMENT '权限id',
  `position_id` char(32) DEFAULT NULL COMMENT '人员组织架构id',
  `project_function_id` char(32) COMMENT '工程基本功能表id',
  `name` varchar(32) COMMENT '权限名称',
  `project` char(32) COMMENT '项目id',
  `url` varchar(255)  COMMENT '地址，一个正则表达式',
  `type` tinyint(1) NOT NULL COMMENT '权限类型，0:赋予，1:排除',
  `user_status` int(11) NOT NULL COMMENT '状态，1：试用期，2：实习期，4：兼职，8：正式,',
  `status` tinyint(1) NOT NULL COMMENT '状态，0:无效，1:有效',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `description` varchar(255) DEFAULT NULL COMMENT '权限描述',
  PRIMARY KEY (`id`),
  KEY `index_project` (`project`),
  KEY `index_url` (`url`),
  KEY `index_type` (`type`),
  KEY `index_position` (`position_id`),
  KEY `index_status` (`status`),
  KEY `index_user_status` (`user_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组织架构权限表';

-- ----------------------------
--  Table structure for `user_position_relation`
-- ----------------------------
DROP TABLE IF EXISTS `user_position_relation`;
CREATE TABLE `user_position_relation` (
  `id` char(32) NOT NULL COMMENT '人员共为对照表id',
  `user_id` char(32) NOT NULL COMMENT '人员id',
  `superior_id` char(32) DEFAULT NULL COMMENT '人员上级领导ID，允许为空， 表示暂无上级',
  `position_id` char(32) NOT NULL COMMENT '人员组织架构id',
  `status` int(11) NOT NULL COMMENT '状态，0:离职，1:试用期，2:实习期，4：兼职，8:正式',
  `allow_login` tinyint(1) NOT NULL COMMENT '是否允许登录，0:禁止登陆，1:允许登录',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `update_time` int(11) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_u_s_p` (`user_id`,`superior_id`,`position_id`) USING BTREE,
  KEY `index_status` (`status`),
  KEY `index_allow_login` (`allow_login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='人员岗位对照表';

-- ----------------------------
--  Table structure for `project_config`
-- ----------------------------
DROP TABLE IF EXISTS `project_config`;
CREATE TABLE `project_config` (
  `id` char(32) NOT NULL COMMENT '项目id',
  `name` varchar(32) NOT NULL COMMENT '项目名称',
  `domain` varchar(32) NOT NULL COMMENT '项目domain',
  `status` tinyint(1) NOT NULL COMMENT '是否启用，0:禁用，1:启用',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `description` varchar(255) DEFAULT NULL COMMENT '项目描述',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_domain` (`domain`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工程基本信息表';

-- ----------------------------
--  Table structure for `project_function`
-- ----------------------------
DROP TABLE IF EXISTS `project_function`;
CREATE TABLE `project_function` (
  `id` char(32) NOT NULL COMMENT '工程基本功能id',
  `name` varchar(32) NOT NULL COMMENT '权限名称',
  `project` int(11) NOT NULL COMMENT '项目id',
  `url` varchar(255) NOT NULL COMMENT '地址，一个正则表达式',
  `status` tinyint(1) NOT NULL COMMENT '状态，0:无效，1:有效',
  `create_time` int(11) NOT NULL COMMENT '创建时间',
  `description` varchar(255) DEFAULT NULL COMMENT '权限描述',
  PRIMARY KEY (`id`),
  KEY `index_project` (`project`),
  KEY `index_url` (`url`),
  KEY `index_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='工程基本功能信息表';

SET FOREIGN_KEY_CHECKS = 1;
