-- 清空旧的博文和用户数据 (谨慎操作，仅用于重构)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `tb_blog`;
TRUNCATE TABLE `tb_user`;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. 创建虚拟瑞典用户
INSERT INTO `tb_user` (`id`, `phone`, `password`, `nick_name`, `icon`, `create_time`, `update_time`) VALUES 
(101, '13800000101', '', 'Saga_Stockholm', '/imgs/icons/user1.png', NOW(), NOW()),
(102, '13800000102', '', 'Anders_Explorer', '/imgs/icons/user2.png', NOW(), NOW()),
(103, '13800000103', '', 'Malin_FikaQueen', '/imgs/icons/user3.png', NOW(), NOW()),
(104, '13800000104', '', 'Lukas_FoodieGbg', '/imgs/icons/user4.png', NOW(), NOW()),
(105, '13800000105', '', 'Sofia_VisbyLife', '/imgs/icons/user5.png', NOW(), NOW()),
(106, '13800000106', '', 'Bjorn_Uppsala', '/imgs/icons/user6.png', NOW(), NOW());

-- 2. 插入基于真实评价的博文
-- 假设 Vete-Katten ID=1, Meatballs ID=2, Sjöbaren ID=10, Bakfickan ID=60, Stejk ID=50, Gotthards ID=71

INSERT INTO `tb_blog` (`shop_id`, `user_id`, `title`, `images`, `content`, `liked`, `comments`, `create_time`, `update_time`) VALUES 
(1, 103, 'Stockholms Most Iconic Fika', '/imgs/blogs/vete1.jpg', 'If you havent been to Vete-Katten, have you even been to Stockholm? The 1920s vibe is unbeatable. My favorite is the classic Princess Cake.', 156, 12, NOW(), NOW()),
(2, 104, 'The Craft of Swedish Meatballs', '/imgs/blogs/meat1.jpg', 'Forget IKEA. This is the real deal in Södermalm. I tried the wild boar and moose meatballs - incredible depth of flavor.', 245, 30, NOW(), NOW()),
(10, 104, 'Best Seafood Soup in Haga', '/imgs/blogs/sjo1.jpg', 'Walking through Haga is a dream. The fish soup at Sjöbaren is legendary—creamy and packed with seafood.', 178, 15, NOW(), NOW()),
(50, 101, 'Arctic Street Food magic', '/imgs/blogs/stejk1.jpg', 'Eating a reindeer wrap inside a traditional Sami tent in Kiruna... pure magic. Best street food in the North.', 420, 56, NOW(), NOW());
