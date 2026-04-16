/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 50622
 Source Host           : localhost:3306
 Source Schema         : nexusreview

 Target Server Type    : MySQL
 Target Server Version : 50622
 File Encoding         : 65001

 Date: 14/03/2022 21:38:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_blog
-- ----------------------------
DROP TABLE IF EXISTS `tb_blog`;
CREATE TABLE `tb_blog`  (
                            `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `shop_id` bigint(20) NOT NULL COMMENT '商户id',
                            `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户id',
                            `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
                            `images` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '探店的照片，最多9张，多张以\",\"隔开',
                            `content` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '探店的文字描述',
                            `liked` int(8) UNSIGNED NULL DEFAULT 0 COMMENT '点赞数量',
                            `comments` int(8) UNSIGNED NULL DEFAULT NULL COMMENT '评论数量',
                            `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_blog
-- ----------------------------
INSERT INTO `tb_blog` VALUES (4, 4, 2, '无尽浪漫的夜晚丨在万花丛中摇晃着红酒杯🍷品战斧牛排🥩', '/imgs/blogs/7/14/4771fefb-1a87-4252-816c-9f7ec41ffa4a.jpg,/imgs/blogs/4/10/2f07e3c9-ddce-482d-9ea7-c21450f8d7cd.jpg,/imgs/blogs/2/6/b0756279-65da-4f2d-b62a-33f74b06454a.jpg,/imgs/blogs/10/7/7e97f47d-eb49-4dc9-a583-95faa7aed287.jpg,/imgs/blogs/1/2/4a7b496b-2a08-4af7-aa95-df2c3bd0ef97.jpg,/imgs/blogs/14/3/52b290eb-8b5d-403b-8373-ba0bb856d18e.jpg', '生活就是一半烟火·一半诗意<br/>手执烟火谋生活·心怀诗意以谋爱·<br/>当然<br/>\r\n男朋友给不了的浪漫要学会自己给🍒<br/>\n无法重来的一生·尽量快乐.<br/><br/>🏰「小筑里·神秘浪漫花园餐厅」🏰<br/><br/>\n💯这是一家最最最美花园的西餐厅·到处都是花餐桌上是花前台是花  美好无处不在\n品一口葡萄酒，维亚红酒马瑟兰·微醺上头工作的疲惫消失无际·生如此多娇🍃<br/><br/>📍地址:延安路200号(家乐福面)<br/><br/>🚌交通:地铁①号线定安路B口出右转过下通道右转就到啦～<br/><br/>--------------🥣菜品详情🥣---------------<br/><br/>「战斧牛排]<br/>\n超大一块战斧牛排经过火焰的炙烤发出阵阵香，外焦里嫩让人垂涎欲滴，切开牛排的那一刻，牛排的汁水顺势流了出来，分熟的牛排肉质软，简直细嫩到犯规，一刻都等不了要放入嘴里咀嚼～<br/><br/>「奶油培根意面」<br/>太太太好吃了💯<br/>我真的无法形容它的美妙，意面混合奶油香菇的香味真的太太太香了，我真的舔盘了，一丁点美味都不想浪费‼️<br/><br/><br/>「香菜汁烤鲈鱼」<br/>这个酱是辣的 真的绝好吃‼️<br/>鲈鱼本身就很嫩没什么刺，烤过之后外皮酥酥的，鱼肉蘸上酱料根本停不下来啊啊啊啊<br/>能吃辣椒的小伙伴一定要尝尝<br/><br/>非常可 好吃子🍽\n<br/>--------------🍃个人感受🍃---------------<br/><br/>【👩🏻‍🍳服务】<br/>小姐姐特别耐心的给我们介绍彩票 <br/>推荐特色菜品，拍照需要帮忙也是尽心尽力配合，太爱他们了<br/><br/>【🍃环境】<br/>比较有格调的西餐厅 整个餐厅的布局可称得上的万花丛生 有种在人间仙境的感觉🌸<br/>集美食美酒与鲜花为一体的风格店铺 令人向往<br/>烟火皆是生活 人间皆是浪漫<br/>', 1, 104, '2021-12-28 19:50:01', '2022-03-10 14:26:34');
INSERT INTO `tb_blog` VALUES (5, 1, 2, '人均30💰杭州这家港式茶餐厅我疯狂打call‼️', '/imgs/blogs/4/7/863cc302-d150-420d-a596-b16e9232a1a6.jpg,/imgs/blogs/11/12/8b37d208-9414-4e78-b065-9199647bb3e3.jpg,/imgs/blogs/4/1/fa74a6d6-3026-4cb7-b0b6-35abb1e52d11.jpg,/imgs/blogs/9/12/ac2ce2fb-0605-4f14-82cc-c962b8c86688.jpg,/imgs/blogs/4/0/26a7cd7e-6320-432c-a0b4-1b7418f45ec7.jpg,/imgs/blogs/15/9/cea51d9b-ac15-49f6-b9f1-9cf81e9b9c85.jpg', '又吃到一家好吃的茶餐厅🍴环境是怀旧tvb港风📺边吃边拍照片📷几十种菜品均价都在20+💰可以是很平价了！<br>·<br>店名：九记冰厅(远洋店)<br>地址：杭州市丽水路远洋乐堤港负一楼（溜冰场旁边）<br>·<br>✔️黯然销魂饭（38💰）<br>这碗饭我吹爆！米饭上盖满了甜甜的叉烧 还有两颗溏心蛋🍳每一粒米饭都裹着浓郁的酱汁 光盘了<br>·<br>✔️铜锣湾漏奶华（28💰）<br>黄油吐司烤的脆脆的 上面洒满了可可粉🍫一刀切开 奶盖流心像瀑布一样流出来  满足<br>·<br>✔️神仙一口西多士士（16💰）<br>简简单单却超级好吃！西多士烤的很脆 黄油味浓郁 面包体超级柔软 上面淋了炼乳<br>·<br>✔️怀旧五柳炸蛋饭（28💰）<br>四个鸡蛋炸成蓬松的炸蛋！也太好吃了吧！还有大块鸡排 上淋了酸甜的酱汁 太合我胃口了！！<br>·<br>✔️烧味双拼例牌（66💰）<br>选了烧鹅➕叉烧 他家烧腊品质真的惊艳到我！据说是每日广州发货 到店现烧现卖的黑棕鹅 每口都是正宗的味道！肉质很嫩 皮超级超级酥脆！一口爆油！叉烧肉也一点都不柴 甜甜的很入味 搭配梅子酱很解腻 ！<br>·<br>✔️红烧脆皮乳鸽（18.8💰）<br>乳鸽很大只 这个价格也太划算了吧， 肉质很有嚼劲 脆皮很酥 越吃越香～<br>·<br>✔️大满足小吃拼盘（25💰）<br>翅尖➕咖喱鱼蛋➕蝴蝶虾➕盐酥鸡<br>zui喜欢里面的咖喱鱼！咖喱酱香甜浓郁！鱼蛋很q弹～<br>·<br>✔️港式熊仔丝袜奶茶（19💰）<br>小熊🐻造型的奶茶冰也太可爱了！颜值担当 很地道的丝袜奶茶 茶味特别浓郁～<br>·', 1, 0, '2021-12-28 20:57:49', '2022-03-10 09:21:39');
INSERT INTO `tb_blog` VALUES (6, 10, 1, '杭州周末好去处｜💰50就可以骑马啦🐎', '/imgs/blogs/blog1.jpg', '杭州周末好去处｜💰50就可以骑马啦🐎', 1, 0, '2022-01-11 16:05:47', '2022-03-10 09:21:41');
INSERT INTO `tb_blog` VALUES (7, 10, 1, '杭州周末好去处｜💰50就可以骑马啦🐎', '/imgs/blogs/blog1.jpg', '杭州周末好去处｜💰50就可以骑马啦🐎', 1, 0, '2022-01-11 16:05:47', '2022-03-10 09:21:42');

-- ----------------------------
-- Table structure for tb_blog_comments
-- ----------------------------
DROP TABLE IF EXISTS `tb_blog_comments`;
CREATE TABLE `tb_blog_comments`  (
                                     `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
                                     `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户id',
                                     `blog_id` bigint(20) UNSIGNED NOT NULL COMMENT '探店id',
                                     `parent_id` bigint(20) UNSIGNED NOT NULL COMMENT '关联的1级评论id，如果是一级评论，则值为0',
                                     `answer_id` bigint(20) UNSIGNED NOT NULL COMMENT '回复的评论id',
                                     `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '回复的内容',
                                     `liked` int(8) UNSIGNED NULL DEFAULT NULL COMMENT '点赞数',
                                     `status` tinyint(1) UNSIGNED NULL DEFAULT NULL COMMENT '状态，0：正常，1：被举报，2：禁止查看',
                                     `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                     `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                     PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_blog_comments
-- ----------------------------

-- ----------------------------
-- Table structure for tb_follow
-- ----------------------------
DROP TABLE IF EXISTS `tb_follow`;
CREATE TABLE `tb_follow`  (
                              `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
                              `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户id',
                              `follow_user_id` bigint(20) UNSIGNED NOT NULL COMMENT '关联的用户id',
                              `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_follow
-- ----------------------------

-- ----------------------------
-- Table structure for tb_seckill_voucher
-- ----------------------------
DROP TABLE IF EXISTS `tb_seckill_voucher`;
CREATE TABLE `tb_seckill_voucher`  (
                                       `voucher_id` bigint(20) UNSIGNED NOT NULL COMMENT '关联的优惠券的id',
                                       `stock` int(8) NOT NULL COMMENT '库存',
                                       `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                       `begin_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '生效时间',
                                       `end_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '失效时间',
                                       `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                       PRIMARY KEY (`voucher_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '秒杀优惠券表，与优惠券是一对一关系' ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_seckill_voucher
-- ----------------------------

-- ----------------------------
-- Table structure for tb_shop
-- ----------------------------
DROP TABLE IF EXISTS `tb_shop`;
CREATE TABLE `tb_shop`  (
                            `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商铺名称',
                            `type_id` bigint(20) UNSIGNED NOT NULL COMMENT '商铺类型的id',
                            `images` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商铺图片，多个图片以\',\'隔开',
                            `area` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商圈，例如陆家嘴',
                            `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '地址',
                            `x` double UNSIGNED NOT NULL COMMENT '经度',
                            `y` double UNSIGNED NOT NULL COMMENT '维度',
                            `avg_price` bigint(10) UNSIGNED NULL DEFAULT NULL COMMENT '均价，取整数',
                            `sold` int(10) UNSIGNED ZEROFILL NOT NULL COMMENT '销量',
                            `comments` int(10) UNSIGNED ZEROFILL NOT NULL COMMENT '评论数量',
                            `score` int(2) UNSIGNED ZEROFILL NOT NULL COMMENT '评分，1~5分，乘10保存，避免小数',
                            `open_hours` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '营业时间，例如 10:00-22:00',
                            `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            PRIMARY KEY (`id`) USING BTREE,
                            INDEX `foreign_key_type`(`type_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_shop
-- ----------------------------
-- ----------------------------
-- Records of tb_shop (Sweden Nationwide Elite Edition)
-- ----------------------------
-- 1. Stockholm
INSERT INTO `tb_shop` VALUES (1, 'Vete-Katten', 1, '/imgs/shops/vete_katten.jpg', 'Norrmalm', 'Kungsgatan 55, Stockholm', 18.0610, 59.3343, 120, 0000005000, 0000001200, 48, '07:30-20:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (2, 'Meatballs for the People', 3, '/imgs/shops/meatballs.jpg', 'Södermalm', 'Nytorgsgatan 30, Stockholm', 18.0827, 59.3148, 250, 0000008000, 0000002500, 49, '11:00-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (3, 'Sturehof', 2, '/imgs/shops/sturehof.jpg', 'Östermalm', 'Stureplan 2, Stockholm', 18.0732, 59.3358, 450, 0000012000, 0000004500, 47, '11:00-02:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (4, 'Pelikan', 3, '/imgs/shops/pelikan.jpg', 'Södermalm', 'Blekingegatan 40, Stockholm', 18.0850, 59.3093, 300, 0000006500, 0000001800, 46, '16:00-00:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (5, 'Ai Ramen', 7, '/imgs/shops/airamen.jpg', 'Södermalm', 'Erstagatan 22, Stockholm', 18.0820, 59.3149, 140, 0000004200, 0000000950, 45, '11:30-21:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (6, 'Drop Coffee', 1, '/imgs/shops/dropcoffee.jpg', 'Södermalm', 'Wollmar Yxkullsgatan 10, Stockholm', 18.0626, 59.3170, 80, 0000003500, 0000000850, 48, '08:00-18:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 2. Gothenburg
INSERT INTO `tb_shop` VALUES (10, 'Sjöbaren', 2, '/imgs/shops/sjobaren.jpg', 'Haga', 'Lorensbergsgatan 14, Göteborg', 11.9772, 57.6989, 280, 0000007200, 0000002100, 49, '11:30-22:30', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (11, 'Café Husaren', 1, '/imgs/shops/husaren.jpg', 'Haga', 'Haga Nygata 28, Göteborg', 11.9560, 57.6997, 95, 0000009500, 0000003000, 47, '09:00-19:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (12, 'Moon Thai Kitchen', 7, '/imgs/shops/moonthai.jpg', 'Lorensberg', 'Kristinelundsgatan 9, Göteborg', 11.9773, 57.6983, 220, 0000005500, 0000001200, 46, '16:00-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 3. Malmö
INSERT INTO `tb_shop` VALUES (20, 'Ruths', 4, '/imgs/shops/ruths.jpg', 'Centrum', 'Malmborgsgatan 6, Malmö', 12.9996, 55.6047, 320, 0000004800, 0000001100, 48, '07:00-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (21, 'Vollmers', 4, '/imgs/shops/vollmers.jpg', 'Centrum', 'Tegnérgatan 7, Malmö', 13.0039, 55.6030, 1800, 0000001200, 0000000500, 50, '18:00-00:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 4. Uppsala
INSERT INTO `tb_shop` VALUES (30, 'Domtrappkällaren', 3, '/imgs/shops/domtrapp.jpg', 'Centrum', 'S:t Eriks torg 15, Uppsala', 17.6353, 59.8583, 380, 0000003200, 0000000900, 47, '11:00-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (31, 'Hambergs Fisk', 2, '/imgs/shops/hambergs.jpg', 'Centrum', 'Fyristorg 8, Uppsala', 17.6361, 59.8581, 420, 0000002800, 0000000750, 48, '11:30-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 5. Lund
INSERT INTO `tb_shop` VALUES (40, 'Mat & Destillat', 4, '/imgs/shops/matdest.jpg', 'Centrum', 'Kyrkogatan 17, Lund', 13.1936, 55.7042, 350, 0000002500, 0000000600, 49, '11:30-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (41, 'Café Ariman', 5, '/imgs/shops/ariman.jpg', 'Centrum', 'Kungsgatan 2, Lund', 13.1934, 55.7046, 110, 0000006800, 0000001500, 45, '11:00-01:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 6. Kiruna
INSERT INTO `tb_shop` VALUES (50, 'Stejk Street Food', 6, '/imgs/shops/stejk.jpg', 'Centrum', 'Konduktörsgatan 22, Kiruna', 20.2250, 67.8540, 160, 0000004500, 0000001200, 50, '11:00-20:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (51, 'Camp Ripan Kitchen', 6, '/imgs/shops/ripan.jpg', 'Camping', 'Campingvägen 5, Kiruna', 20.2520, 67.8631, 450, 0000002200, 0000000650, 47, '17:00-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 7. Visby
INSERT INTO `tb_shop` VALUES (60, 'Bakfickan', 2, '/imgs/shops/bakfickan.jpg', 'Innerstaden', 'S:t Katarinagatan 2, Visby', 18.2954, 57.6406, 280, 0000005200, 0000001800, 48, '11:30-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (61, 'Surfers', 7, '/imgs/shops/surfers.jpg', 'Innerstaden', 'Södra Kyrkogatan 1, Visby', 18.2960, 57.6393, 350, 0000004100, 0000001100, 49, '17:00-00:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 8. Umeå
INSERT INTO `tb_shop` VALUES (70, 'Köksbaren', 4, '/imgs/shops/koksbaren.jpg', 'Centrum', 'Rådhusesplanaden 17, Umeå', 20.2657, 63.8292, 380, 0000003100, 0000000850, 49, '17:00-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 9. Helsingborg
INSERT INTO `tb_shop` VALUES (80, 'Sillen & Makrillen', 2, '/imgs/shops/sillen.jpg', 'Gröningen', 'Gröningen Norra 1, Helsingborg', 12.6813, 56.0556, 420, 0000003800, 0000001050, 48, '12:00-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 10. Jönköping
INSERT INTO `tb_shop` VALUES (90, 'El Gordo', 8, '/imgs/shops/elgordo.jpg', 'Vättern', 'Järnvägsgatan 2, Jönköping', 14.1610, 57.7830, 180, 0000002900, 0000000700, 44, '11:30-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 11. Norrköping
INSERT INTO `tb_shop` VALUES (100, 'Stadsvakten', 3, '/imgs/shops/stadsvakten.jpg', 'Industrilandskapet', 'Nya Rådstugugatan 16, Norrköping', 16.1856, 58.5878, 320, 0000002600, 0000000650, 47, '11:30-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- ----------------------------
-- Table structure for tb_shop_type
-- ----------------------------
DROP TABLE IF EXISTS `tb_shop_type`;
CREATE TABLE `tb_shop_type`  (
                                 `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
                                 `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型名称',
                                 `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
                                 `sort` int(3) UNSIGNED NULL DEFAULT NULL COMMENT '顺序',
                                 `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_shop_type
-- ----------------------------
INSERT INTO `tb_shop_type` VALUES (1, 'Fika/下午茶', '/types/fika.png', 1, '2021-12-22 20:17:47', '2021-12-23 11:24:31');
INSERT INTO `tb_shop_type` VALUES (2, '海鲜盛宴', '/types/seafood.png', 2, '2021-12-22 20:18:27', '2021-12-23 11:24:31');
INSERT INTO `tb_shop_type` VALUES (3, '瑞典经典家常', '/types/traditional.png', 3, '2021-12-22 20:18:48', '2021-12-23 11:24:31');
INSERT INTO `tb_shop_type` VALUES (4, '北欧高端创意', '/types/fusion.png', 4, '2021-12-22 20:19:04', '2021-12-23 11:24:31');
INSERT INTO `tb_shop_type` VALUES (5, '微醺酒吧', '/types/bar.png', 5, '2021-12-22 20:19:27', '2021-12-23 11:24:31');
INSERT INTO `tb_shop_type` VALUES (6, '萨米/极北特色', '/types/sami.png', 6, '2021-12-22 20:19:35', '2021-12-23 11:24:31');
INSERT INTO `tb_shop_type` VALUES (7, '亚洲融合风味', '/types/asian.png', 7, '2021-12-22 20:19:53', '2021-12-23 11:24:31');
INSERT INTO `tb_shop_type` VALUES (8, '街头美食', '/types/street.png', 8, '2021-12-22 20:20:02', '2021-12-23 11:24:31');

-- ----------------------------
-- Table structure for tb_sign
-- ----------------------------
DROP TABLE IF EXISTS `tb_sign`;
CREATE TABLE `tb_sign`  (
                            `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户id',
                            `year` year NOT NULL COMMENT '签到的年',
                            `month` tinyint(2) NOT NULL COMMENT '签到的月',
                            `date` date NOT NULL COMMENT '签到的日期',
                            `is_backup` tinyint(1) UNSIGNED NULL DEFAULT NULL COMMENT '是否补签',
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_sign
-- ----------------------------

-- ----------------------------
-- Table structure for tb_user
-- ----------------------------
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user`  (
                            `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
                            `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
                            `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码，加密存储',
                            `nick_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称，默认是用户id',
                            `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '人物头像',
                            `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            PRIMARY KEY (`id`) USING BTREE,
                            UNIQUE INDEX `uniqe_key_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1010 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_user
-- ----------------------------
INSERT INTO `tb_user` VALUES (1, '13686869696', '', '小鱼同学', '/imgs/blogs/blog1.jpg', '2021-12-24 10:27:19', '2022-01-11 16:04:00');
INSERT INTO `tb_user` VALUES (2, '13838411438', '', '可可今天不吃肉', '/imgs/icons/kkjtbcr.jpg', '2021-12-24 15:14:39', '2021-12-28 19:58:04');
INSERT INTO `tb_user` VALUES (4, '13456789011', '', 'user_slxaxy2au9f3tanffaxr', '', '2022-01-07 12:07:53', '2022-01-07 12:07:53');
INSERT INTO `tb_user` VALUES (5, '13456789001', '', '可爱多', '/imgs/icons/user5-icon.png', '2022-01-07 16:11:33', '2022-03-11 09:09:20');
INSERT INTO `tb_user` VALUES (6, '13456762069', '', 'user_xn5wr3hpsv', '', '2022-02-07 17:54:10', '2022-02-07 17:54:10');
INSERT INTO `tb_user` VALUES (10, '13688668889', '', 'user_88arndojw9', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (11, '13688668890', '', 'user_qcfr2k1lmi', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (12, '13688668891', '', 'user_ffsk4hli07', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (13, '13688668892', '', 'user_r62q62ijef', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (14, '13688668893', '', 'user_f3rymyt1q5', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (15, '13688668894', '', 'user_hnyhc3mjat', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (16, '13688668895', '', 'user_2spo35f5rl', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (17, '13688668896', '', 'user_q3r70baqe1', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (18, '13688668897', '', 'user_v73ottjqxt', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (19, '13688668898', '', 'user_tmh8o4r11q', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (20, '13688668899', '', 'user_4epgb7b5u1', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (21, '13688668900', '', 'user_g474zoujxj', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (22, '13688668901', '', 'user_r3kh1g6aah', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (23, '13688668902', '', 'user_u3uuo7l5fo', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (24, '13688668903', '', 'user_9o93lbsojt', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (25, '13688668904', '', 'user_jbhmr43wpq', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (26, '13688668905', '', 'user_nevyd3c5ux', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (27, '13688668906', '', 'user_oow4frmjp3', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (28, '13688668907', '', 'user_cvmknmec74', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (29, '13688668908', '', 'user_0t2x5njbz7', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (30, '13688668909', '', 'user_y5x09783hp', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (31, '13688668910', '', 'user_owe4eyuhhh', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (32, '13688668911', '', 'user_j76auh0ggg', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (33, '13688668912', '', 'user_aal5w9rm33', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (34, '13688668913', '', 'user_a2pgu8cr21', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (35, '13688668914', '', 'user_nle60p846v', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (36, '13688668915', '', 'user_w1mck7c7yv', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (37, '13688668916', '', 'user_bnpiybumlk', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (38, '13688668917', '', 'user_4w7xeo2yyt', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (39, '13688668918', '', 'user_99u4voj7xl', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (40, '13688668919', '', 'user_g03is27pd6', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (41, '13688668920', '', 'user_3j9erfkl0p', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (42, '13688668921', '', 'user_l7rs56ah9y', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (43, '13688668922', '', 'user_p3655ctliy', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (44, '13688668923', '', 'user_qi1qze1yp1', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (45, '13688668924', '', 'user_vrd5ir0rj0', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (46, '13688668925', '', 'user_tubboh1byc', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (47, '13688668926', '', 'user_j2bdj3d2eo', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (48, '13688668927', '', 'user_ncj7r0vu1h', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (49, '13688668928', '', 'user_63rhqjqa0a', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (50, '13688668929', '', 'user_80ue5cywnk', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (51, '13688668930', '', 'user_j4q037vhpi', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (52, '13688668931', '', 'user_ms0uat5bf0', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (53, '13688668932', '', 'user_oqep16bdel', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (54, '13688668933', '', 'user_vjtvjjdqh7', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (55, '13688668934', '', 'user_0168i9hv5g', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (56, '13688668935', '', 'user_vh1j6zw1q4', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (57, '13688668936', '', 'user_rkf2nxouof', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (58, '13688668937', '', 'user_whlt2chtv3', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (59, '13688668938', '', 'user_lpqr90wbeo', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (60, '13688668939', '', 'user_h40y3ipk9k', '', '2022-02-28 10:50:47', '2022-02-28 10:50:47');
INSERT INTO `tb_user` VALUES (61, '13688668940', '', 'user_awdqkmbkt7', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (62, '13688668941', '', 'user_1xgbg9v4r5', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (63, '13688668942', '', 'user_7vf5fgiu68', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (64, '13688668943', '', 'user_lsgiz015vf', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (65, '13688668944', '', 'user_0nqjvanruk', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (66, '13688668945', '', 'user_8alg1taath', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (67, '13688668946', '', 'user_q45ykjgpxe', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (68, '13688668947', '', 'user_4hy0o6ir0r', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (69, '13688668948', '', 'user_q6rh7e6zo9', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (70, '13688668949', '', 'user_1wp3ygfyn2', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (71, '13688668950', '', 'user_13vjvo6flp', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (72, '13688668951', '', 'user_glyshbbwin', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (73, '13688668952', '', 'user_3ewzgsnhzj', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (74, '13688668953', '', 'user_ky481zf1fs', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (75, '13688668954', '', 'user_o5yzu0epev', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (76, '13688668955', '', 'user_ycbracmsi3', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (77, '13688668956', '', 'user_974wwi1283', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (78, '13688668957', '', 'user_1y0xokmk9w', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (79, '13688668958', '', 'user_nd74cho3tu', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (80, '13688668959', '', 'user_5z7u2eysa4', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (81, '13688668960', '', 'user_yvf8hfu5yy', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (82, '13688668961', '', 'user_2poi4wvpms', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (83, '13688668962', '', 'user_v4ysxjt1yu', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (84, '13688668963', '', 'user_kbvn4gpgk6', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (85, '13688668964', '', 'user_23niik1tyg', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (86, '13688668965', '', 'user_uf2zz6ispe', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (87, '13688668966', '', 'user_5k19vf7c4o', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (88, '13688668967', '', 'user_5ahdd98xbr', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (89, '13688668968', '', 'user_a5cnfnoopx', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (90, '13688668969', '', 'user_utnmcyfg13', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (91, '13688668970', '', 'user_0k6n8ikb95', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (92, '13688668971', '', 'user_zqk5maqtmi', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (93, '13688668972', '', 'user_9i9suwd3nd', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (94, '13688668973', '', 'user_u0y0ngrdjo', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (95, '13688668974', '', 'user_stvijjwvzu', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (96, '13688668975', '', 'user_7if7tttays', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');
INSERT INTO `tb_user` VALUES (97, '13688668976', '', 'user_f9hmz0ngdu', '', '2022-02-28 10:50:48', '2022-02-28 10:50:48');

-- ----------------------------
-- Table structure for tb_user_info
-- ----------------------------
DROP TABLE IF EXISTS `tb_user_info`;
CREATE TABLE `tb_user_info`  (
                                 `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '主键，用户id',
                                 `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '城市名称',
                                 `introduce` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '个人介绍，不要超过128个字符',
                                 `fans` int(8) UNSIGNED NULL DEFAULT 0 COMMENT '粉丝数量',
                                 `followee` int(8) UNSIGNED NULL DEFAULT 0 COMMENT '关注的人的数量',
                                 `gender` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '性别，0：男，1：女',
                                 `birthday` date NULL DEFAULT NULL COMMENT '生日',
                                 `credits` int(8) UNSIGNED NULL DEFAULT 0 COMMENT '积分',
                                 `level` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '会员级别，0~9级,0代表未开通会员',
                                 `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_user_info
-- ----------------------------

-- ----------------------------
-- Table structure for tb_voucher
-- ----------------------------
DROP TABLE IF EXISTS `tb_voucher`;
CREATE TABLE `tb_voucher`  (
                               `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
                               `shop_id` bigint(20) UNSIGNED NULL DEFAULT NULL COMMENT '商铺id',
                               `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代金券标题',
                               `sub_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '副标题',
                               `rules` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '使用规则',
                               `pay_value` bigint(10) UNSIGNED NOT NULL COMMENT '支付金额，单位是分。例如200代表2元',
                               `actual_value` bigint(10) NOT NULL COMMENT '抵扣金额，单位是分。例如200代表2元',
                               `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0,普通券；1,秒杀券',
                               `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '1,上架; 2,下架; 3,过期',
                               `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                               PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_voucher
-- ----------------------------
INSERT INTO `tb_voucher` VALUES (1, 1, '50元代金券', '周一至周日均可使用', '全场通用\\n无需预约\\n可无限叠加\\不兑现、不找零\\n仅限堂食', 4750, 5000, 0, 1, '2022-01-04 09:42:39', '2022-01-04 09:43:31');

-- ----------------------------
-- Table structure for tb_voucher_order
-- ----------------------------
DROP TABLE IF EXISTS `tb_voucher_order`;
CREATE TABLE `tb_voucher_order`  (
                                     `id` bigint(20) NOT NULL COMMENT '主键',
                                     `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '下单的用户id',
                                     `voucher_id` bigint(20) UNSIGNED NOT NULL COMMENT '购买的代金券id',
                                     `pay_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '支付方式 1：余额支付；2：支付宝；3：微信',
                                     `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '订单状态，1：未支付；2：已支付；3：已核销；4：已取消；5：退款中；6：已退款',
                                     `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
                                     `pay_time` timestamp NULL DEFAULT NULL COMMENT '支付时间',
                                     `use_time` timestamp NULL DEFAULT NULL COMMENT '核销时间',
                                     `refund_time` timestamp NULL DEFAULT NULL COMMENT '退款时间',
                                     `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                     PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;




create table if not exists tb_reservation (
                                              id bigint primary key auto_increment comment '主键',
                                              user_id bigint(20) unsigned not null comment '用户id',
                                              user_phone varchar(11) character set utf8mb4 collate utf8mb4_general_ci not null comment '用户手机号',
                                              shop_id bigint(20) unsigned not null comment '商铺id',
                                              reservation_time datetime not null comment '预约时间',
                                              status varchar(20) not null default '待确认' comment '预约状态，默认待确认',
                                              create_time timestamp not null default current_timestamp comment '创建时间',
                                              unique key uk_user_shop_time (user_id, shop_id, reservation_time),
                                              key idx_shop_id (shop_id),
                                              key idx_user_phone (user_phone),
                                              foreign key (user_id) references tb_user(id) on delete cascade on update cascade,
                                              foreign key (user_phone) references tb_user(phone) on delete cascade on update cascade,
                                              foreign key (shop_id) references tb_shop(id) on delete cascade on update cascade
) engine=InnoDB default charset=utf8mb4 comment='店铺预约表';

-- ----------------------------
-- Records of tb_voucher_order
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
INSERT INTO `tb_shop` VALUES (7, 'Pelikan', 3, '/imgs/shops/pelikan.jpg', 'Södermalm', 'Blekingegatan 40, Stockholm', 18.0850, 59.3093, 300, 0000006500, 0000001800, 46, '16:00-00:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (8, 'Riche', 4, '/imgs/shops/riche.jpg', 'Östermalm', 'Birger Jarlsgatan 4, Stockholm', 18.0750, 59.3330, 400, 0000008500, 0000002200, 47, '11:00-02:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (9, 'Prinsen', 3, '/imgs/shops/prinsen.jpg', 'Norrmalm', 'Mäster Samuelsgatan 4, Stockholm', 18.0730, 59.3335, 350, 0000007500, 0000001900, 48, '11:30-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (13, 'Sjömagasinet', 2, '/imgs/shops/sjomagasinet.jpg', 'Klippan', 'Adolf Edelsvärds gata 5, Göteborg', 11.9160, 57.6900, 650, 0000004500, 000001200, 49, '11:30-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (14, 'Hagabullen', 1, '/imgs/shops/hagabullen.jpg', 'Haga', 'Haga Nygata 28, Göteborg', 11.9560, 57.6997, 85, 0000009500, 0000003000, 50, '09:00-19:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (22, 'Bastard Burgers', 8, '/imgs/shops/bastard.jpg', 'Centrum', 'Södergatan 22, Malmö', 13.0010, 55.6050, 150, 0000005500, 0000001800, 46, '11:00-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (23, 'Lilla Kafferosteriet', 1, '/imgs/shops/karo.jpg', 'Centrum', 'Baltzarsgatan 24, Malmö', 13.0040, 55.6035, 90, 0000007200, 0000002100, 49, '08:00-19:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
-- 7. Visby (Gotland)
INSERT INTO `tb_shop` VALUES (62, 'Crêperie & Logi', 8, '/imgs/shops/crep.jpg', 'Innerstaden', 'Wallers plats 3, Visby', 18.2930, 57.6400, 180, 0000003500, 0000000850, 48, '11:00-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (63, 'Lindgården', 4, '/imgs/shops/lind.jpg', 'Innerstaden', 'Strandgatan 26, Visby', 18.2910, 57.6410, 450, 0000002200, 0000000650, 47, '17:00-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 8. Umeå
INSERT INTO `tb_shop` VALUES (71, 'Gotthards Krog', 4, '/imgs/shops/gotthards.jpg', 'Centrum', 'Storgatan 46, Umeå', 20.2608, 63.8250, 420, 0000002800, 0000000750, 49, '11:30-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (72, 'Kulturbageriet', 1, '/imgs/shops/kultur.jpg', 'Centrum', 'Storgatan 46, Umeå', 20.2610, 63.8251, 110, 0000006200, 0000001500, 48, '08:00-18:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 9. Helsingborg
INSERT INTO `tb_shop` VALUES (81, 'Château Forêt', 4, '/imgs/shops/chateau.jpg', 'Centrum', 'Södra Storgatan 19, Helsingborg', 12.6970, 56.0460, 380, 0000003100, 0000000800, 47, '17:00-23:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 10. Jönköping
INSERT INTO `tb_shop` VALUES (91, 'Sjökanten', 2, '/imgs/shops/sjokanten.jpg', 'Vättern', 'Jönköping Waterfront', 14.1620, 57.7840, 350, 0000002500, 0000000600, 46, '11:30-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- 11. Norrköping
INSERT INTO `tb_shop` VALUES (101, 'Trattoria Gabriel', 7, '/imgs/shops/gabriel.jpg', 'Centrum', 'Drottninggatan 1, Norrköping', 16.1880, 58.5900, 220, 0000004500, 0000001200, 45, '11:00-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');

-- Batch more items to reach 60+ (adding similar top-rated spots)
INSERT INTO `tb_shop` VALUES (110, 'Pascal', 1, '/imgs/shops/pascal.jpg', 'Odenplan', 'Norrtullsgatan 4, Stockholm', 18.0500, 59.3430, 95, 0000008500, 0000002800, 49, '07:30-18:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (111, 'Green Rabbit', 1, '/imgs/shops/green.jpg', 'Norrmalm', 'Tegnérgatan 17, Stockholm', 18.0610, 59.3400, 85, 0000007200, 0000001900, 48, '08:00-17:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (112, 'Smörgåstårteriet', 3, '/imgs/shops/smor.jpg', 'Norrmalm', 'Dalagatan 42, Stockholm', 18.0450, 59.3405, 280, 0000004200, 0000000950, 47, '11:30-22:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (113, 'Ekstedt', 4, '/imgs/shops/ekstedt.jpg', 'Östermalm', 'Humlegårdsgatan 17, Stockholm', 18.0760, 59.3360, 1500, 0000001500, 0000000400, 50, '18:00-00:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
INSERT INTO `tb_shop` VALUES (114, 'Nook', 7, '/imgs/shops/nook.jpg', 'Södermalm', 'Åsögatan 176, Stockholm', 18.0860, 59.3130, 450, 0000003200, 0000000950, 48, '17:00-00:00', '2022-01-01 10:00:00', '2022-01-01 10:00:00');
