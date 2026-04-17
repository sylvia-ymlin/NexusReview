package com.nexusreview.controller;

import com.nexusreview.dto.Result;
import com.nexusreview.entity.Shop;
import com.nexusreview.service.IShopService;
import com.nexusreview.utils.RedisConstants;
import org.springframework.data.geo.Point;
import org.springframework.data.redis.connection.RedisGeoCommands;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/support")
public class SupportController {

    @Resource
    private IShopService shopService;

    @Resource
    private StringRedisTemplate stringRedisTemplate;

    /**
     * 从 Redis 读取验证码（供自动化测试使用，生产环境应删除）
     */
    @GetMapping("/get-code")
    public Result getCode(@RequestParam("phone") String phone) {
        String code = stringRedisTemplate.opsForValue().get("login:code:" + phone);
        if (code == null) {
            return Result.fail("验证码不存在或已过期");
        }
        Map<String, String> result = new java.util.HashMap<>();
        result.put("code", code);
        return Result.ok(result);
    }

    /**
     * 将数据库中的商铺地理位置信息预热到 Redis GEO 中
     */
    @PostMapping("/warmup-geo")
    public Result warmupGeo() {
        // 1.查询所有店铺信息
        List<Shop> list = shopService.list();
        // 2.按照 typeId 分组
        Map<Long, List<Shop>> map = list.stream().collect(Collectors.groupingBy(Shop::getTypeId));
        // 3.分批写入 Redis
        for (Map.Entry<Long, List<Shop>> entry : map.entrySet()) {
            Long typeId = entry.getKey();
            String key = RedisConstants.SHOP_GEO_KEY + typeId;
            List<Shop> value = entry.getValue();
            List<RedisGeoCommands.GeoLocation<String>> locations = new ArrayList<>(value.size());
            for (Shop shop : value) {
                if (shop.getX() != null && shop.getY() != null) {
                    locations.add(new RedisGeoCommands.GeoLocation<>(
                            shop.getId().toString(),
                            new Point(shop.getX(), shop.getY())
                    ));
                }
            }
            stringRedisTemplate.opsForGeo().add(key, locations);
        }
        return Result.ok("GEO 数据预热成功！");
    }

    /**
     * 手动预热秒杀库存到 Redis
     * @param voucherId 优惠券ID
     * @param stock 库存量
     */
    @PostMapping("/preheat-seckill/{voucherId}/{stock}")
    public Result preheatSeckill(@PathVariable("voucherId") Long voucherId, @PathVariable("stock") Integer stock) {
        stringRedisTemplate.opsForValue().set(RedisConstants.SECKILL_STOCK_KEY + voucherId, stock.toString());
        return Result.ok("秒杀库存预热成功：Voucher " + voucherId + " -> Stock " + stock);
    }
}
