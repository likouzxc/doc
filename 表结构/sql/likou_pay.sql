DROP DATABASE IF EXISTS `likou_pay`;

CREATE DATABASE `likou_pay`;

USE `likou_pay`;

SET NAMES utf8;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
--  Table structure for `app_config`
-- ----------------------------
DROP TABLE IF EXISTS `app_config`;
CREATE TABLE `app_config` (
  `id` char(32) NOT NULL,
  `name` varchar(255) NOT NULL COMMENT '配置名称',
  `appid` char(16) NOT NULL COMMENT 'appid',
  `public_key` text NOT NULL COMMENT '外部系统进行RSA加密时使用的publicKey',
  `private_key` text NOT NULL COMMENT '外部系统进行RSA加密时使用的privateKey',
  `inner_public_key` text NOT NULL COMMENT '内部系统进行RSA加密时使用的publicKey',
  `inner_private_key` text NOT NULL COMMENT '内部系统进行RSA加密时使用的privateKey',
  `request_ip` varchar(255) NOT NULL COMMENT 'ip白名单',
  `return_url` varchar(255) DEFAULT NULL COMMENT '回调URL',
  `notice_url` varchar(255) DEFAULT NULL COMMENT '消息通知URL',
  `status` tinyint(1) NOT NULL COMMENT '状态，0：无效,1：有效',
  `create_time` int(11) NOT NULL COMMENT '配置创建时间',
  `update_time` int(11) NOT NULL COMMENT '配置更新时间',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`),
  KEY `unique_appid` (`appid`),
  KEY `index_update_time` (`update_time`),
  KEY `index_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付系统接入配置表';

-- ----------------------------
--  Table structure for `pay`
-- ----------------------------
DROP TABLE IF EXISTS `pay`;
CREATE TABLE `pay` (
  `id` char(32) NOT NULL COMMENT '支付流水号，提供于各系统使用',
  `inner_id` char(32) NOT NULL COMMENT '内部单号（合同单号）',
  `outer_id` varchar(255) DEFAULT NULL COMMENT '外部单号，即第三方单号',
  `type` tinyint(1) NOT NULL COMMENT '支付类型，0:线下，1：线上',
  `channel` varchar(32) DEFAULT NULL COMMENT '支付渠道，如：支付宝，微信，贷款，银行......',
  `money` decimal(14,2) NOT NULL COMMENT '预计支付金额',
  `pay_money` decimal(14,2) DEFAULT NULL COMMENT '实际支付金额',
  `request_id` varchar(255) NOT NULL COMMENT '发起请求的IP',
  `return_url` varchar(255) DEFAULT NULL COMMENT '支付结束后，回调URL',
  `notice_url` varchar(255) DEFAULT NULL COMMENT '支付结束后，消息通知URL',
  `create_time` int(11) NOT NULL COMMENT '支付流水创建时间',
  `over_time` int(11) DEFAULT NULL COMMENT '支付流水完成时间',
  `status` int(11) NOT NULL COMMENT '退款状态，0：进行中，1：已完成，999：失败，998：多收款项，997：款项不足',
  `sign` varchar(255) DEFAULT NULL COMMENT '机密数据',
  `error_message` varchar(255) DEFAULT NULL COMMENT '反馈错误信息',
  PRIMARY KEY (`id`),
  KEY `index_inner_id` (`inner_id`),
  KEY `index_type` (`type`),
  KEY `index_channel` (`channel`),
  KEY `index_ip` (`request_id`),
  KEY `index_over_time` (`over_time`),
  KEY `index_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='支付信息表';

-- ----------------------------
--  Table structure for `refund`
-- ----------------------------
DROP TABLE IF EXISTS `refund`;
CREATE TABLE `refund` (
  `id` char(32) NOT NULL COMMENT '退款单号',
  `inner_id` char(32) NOT NULL COMMENT '内部单号（合同单号）',
  `type` tinyint(1) NOT NULL COMMENT '退款类型，0:线下，1:线上',
  `money` decimal(14,2) NOT NULL COMMENT '退款金额',
  `request_ip` varchar(255) NOT NULL COMMENT '发起请求的ip',
  `return_url` varchar(255) DEFAULT NULL COMMENT '退款结束后，回调URL',
  `notice_url` varchar(255) DEFAULT NULL COMMENT '退款结束后，消息通知URL',
  `create_time` int(11) NOT NULL COMMENT '退款流水创建时间',
  `over_time` int(11) DEFAULT NULL COMMENT '退款流水完成时间',
  `status` int(11) NOT NULL COMMENT '退款结果状态，0：未开始，1：进行中，2：已完成，999：失败',
  `error_message` varchar(255) DEFAULT NULL COMMENT '反馈错误信息',
  PRIMARY KEY (`id`),
  KEY `index_inner_id` (`inner_id`),
  KEY `index_type` (`type`),
  KEY `index_ip` (`request_ip`),
  KEY `index_over_time` (`over_time`),
  KEY `index_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='退款信息表';

SET FOREIGN_KEY_CHECKS = 1;
