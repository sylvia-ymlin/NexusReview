package com.nexusreview.controller;

import com.nexusreview.entity.Shop;
import com.nexusreview.entity.ShopType;
import com.nexusreview.service.IShopService;
import com.nexusreview.service.IShopTypeService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 内部 API：供 AI 服务进行 RAG 知识库摄取
 */
@RestController
@RequestMapping("/internal/shops")
public class ShopExportController {

    private final IShopService shopService;
    private final IShopTypeService shopTypeService;

    public ShopExportController(IShopService shopService, IShopTypeService shopTypeService) {
        this.shopService = shopService;
        this.shopTypeService = shopTypeService;
    }

    @GetMapping("/list")
    public List<Shop> listShops() {
        return shopService.list();
    }

    @GetMapping("/types")
    public Map<Long, String> listShopTypes() {
        return shopTypeService.list().stream()
                .collect(Collectors.toMap(ShopType::getId, ShopType::getName));
    }
}
