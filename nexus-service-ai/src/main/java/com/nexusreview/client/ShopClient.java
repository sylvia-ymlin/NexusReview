package com.nexusreview.client;

import com.nexusreview.entity.Shop;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import java.util.Map;

@FeignClient(name = "nexus-service-main")
public interface ShopClient {

    @GetMapping("/internal/shops/list")
    List<Shop> listShops();

    @GetMapping("/internal/shops/types")
    Map<Long, String> listShopTypes();
}
