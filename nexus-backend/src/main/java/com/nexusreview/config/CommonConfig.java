package com.nexusreview.config;

import dev.langchain4j.data.document.Document;
import dev.langchain4j.data.document.loader.ClassPathDocumentLoader;
import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.ChatMemoryProvider;
import dev.langchain4j.memory.chat.MessageWindowChatMemory;
import dev.langchain4j.model.openai.OpenAiChatModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.rag.content.retriever.EmbeddingStoreContentRetriever;
import dev.langchain4j.store.embedding.EmbeddingStore;
import dev.langchain4j.store.embedding.EmbeddingStoreIngestor;
import dev.langchain4j.store.embedding.inmemory.InMemoryEmbeddingStore;
import dev.langchain4j.store.memory.chat.ChatMemoryStore;
import com.nexusreview.entity.Shop;
import com.nexusreview.entity.ShopType;
import com.nexusreview.service.IShopService;
import com.nexusreview.service.IShopTypeService;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.List;

@Configuration
public class CommonConfig {

    private final OpenAiChatModel model;

    private final ChatMemoryStore redisChatMemoryStore;
    private final IShopService shopService;
    private final IShopTypeService shopTypeService;

    public CommonConfig(OpenAiChatModel model, ChatMemoryStore redisChatMemoryStore, 
                        IShopService shopService, IShopTypeService shopTypeService) {
        this.model = model;
        this.redisChatMemoryStore = redisChatMemoryStore;
        this.shopService = shopService;
        this.shopTypeService = shopTypeService;
    }

    @Bean
    public ChatMemory chatMemory(){
        return MessageWindowChatMemory
                .builder()
                .maxMessages(20)//最多记忆20条消息
                .build();
    }

    @Bean
    public ChatMemoryProvider chatMemoryProvider(){
        //匿名内部类
        //根据记忆ID获取记忆对象
        //设置记忆存储组件
        return new ChatMemoryProvider(){//匿名内部类
            //根据记忆ID获取记忆对象
            @Override
            public ChatMemory get(Object memoryId){
                return MessageWindowChatMemory
                        .builder()
                        .maxMessages(20)
                        .id(memoryId)
                        .chatMemoryStore(redisChatMemoryStore)//设置记忆存储组件
                        .build();
            }
        };
    }

    @Bean
    public EmbeddingStore store(){
        // 1. 加载静态 Markdown 文档 (Guidebooks)
        List<Document> documents = ClassPathDocumentLoader.loadDocuments("content");
        System.out.println("AI知识库加载: 静态文档数量 = " + documents.size());

        // 2. 加载数据库内容 (Dynamic Database RAG)
        Map<Long, String> typeMap = shopTypeService.list().stream()
                .collect(Collectors.toMap(ShopType::getId, ShopType::getName));
        
        List<Shop> shops = shopService.list();
        System.out.println("AI知识库加载: 数据库商铺数量 = " + shops.size());

        List<Document> dbDocuments = shops.stream().map(shop -> {
            String category = typeMap.getOrDefault(shop.getTypeId(), "Other");
            // 构建包含中英文地标的描述，提升跨语言检索召回率
            String content = String.format(
                "Shop: [%s]\nCategory: %s\nLocation: %s, Stockholm, Sweden (斯德哥尔摩, 瑞典)\nAddress: %s\nRating: %.1f/5.0\nPrice: %d SEK (Avg)\nHours: %s\nDescription: A top-rated %s spot in the heart of Stockholm.",
                shop.getName(), category, shop.getArea(), shop.getAddress(), 
                shop.getScore() / 10.0, shop.getAvgPrice(), shop.getOpenHours(), 
                category.toLowerCase()
            );
            return Document.from(content);
        }).collect(Collectors.toList());

        // 3. 创建内存向量库
        InMemoryEmbeddingStore store = new InMemoryEmbeddingStore();
        
        // 4. 向量化并摄取数据 (Hybrid Ingestion)
        EmbeddingStoreIngestor ingestor = EmbeddingStoreIngestor.builder()
                .embeddingStore(store)
                .build();
        
        ingestor.ingest(documents);   
        ingestor.ingest(dbDocuments); 
        System.out.println("AI知识库成功初始化: " + (documents.size() + dbDocuments.size()) + " 个分片就绪。");
        
        return store;
    }

    @Bean
    public ContentRetriever contentRetriever(EmbeddingStore store){
        return EmbeddingStoreContentRetriever.builder()
                .embeddingStore(store)//设置向量数据库操作对象
                .minScore(0.3)// 降低分值门槛，确保检索召回率
                .maxResults(5)// 增加结果上限，提供更多上下文
                .build();
    }
}