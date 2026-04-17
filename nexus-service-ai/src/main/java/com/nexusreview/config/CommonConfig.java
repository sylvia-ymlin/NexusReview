package com.nexusreview.config;

import com.nexusreview.client.ShopClient;
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
import java.util.Map;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.List;
import java.util.stream.Collectors;

@Configuration
public class CommonConfig {

    private final OpenAiChatModel model;
    private final ChatMemoryStore redisChatMemoryStore;
    private final ShopClient shopClient;

    public CommonConfig(OpenAiChatModel model, ChatMemoryStore redisChatMemoryStore, 
                        ShopClient shopClient) {
        this.model = model;
        this.redisChatMemoryStore = redisChatMemoryStore;
        this.shopClient = shopClient;
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
        return new ChatMemoryProvider(){
            @Override
            public ChatMemory get(Object memoryId){
                return MessageWindowChatMemory
                        .builder()
                        .maxMessages(20)
                        .id(memoryId)
                        .chatMemoryStore(redisChatMemoryStore)
                        .build();
            }
        };
    }

    @Bean
    public EmbeddingStore store(){
        // 1. 加载静态 Markdown 文档 (Guidebooks)
        List<Document> documents = ClassPathDocumentLoader.loadDocuments("content");
        System.out.println("AI知识库加载: 静态文档数量 = " + documents.size());

        // 2. 加载远程数据库内容 (Distributed RAG via Feign)
        Map<Long, String> typeMap = shopClient.listShopTypes();
        List<Shop> shops = shopClient.listShops();
        System.out.println("AI知识库加载: 远程获取商铺数量 = " + shops.size());

        List<Document> dbDocuments = shops.stream().map(shop -> {
            String category = typeMap.getOrDefault(shop.getTypeId(), "Other");
            String content = String.format(
                "Shop: [%s]\nCategory: %s\nLocation: %s, Stockholm, Sweden (斯德哥尔摩, 瑞典)\nAddress: %s\nRating: %.1f/5.0\nPrice: %d SEK (Avg)\nHours: %s\nDescription: A top-rated %s spot in the heart of Stockholm.",
                shop.getName(), category, shop.getArea(), shop.getAddress(), 
                shop.getScore() / 10.0, shop.getAvgPrice(), shop.getOpenHours(), 
                category.toLowerCase()
            );
            return Document.from(content);
        }).collect(Collectors.toList());

        InMemoryEmbeddingStore store = new InMemoryEmbeddingStore();
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
                .embeddingStore(store)
                .minScore(0.3)
                .maxResults(5)
                .build();
    }
}
c ContentRetriever contentRetriever(EmbeddingStore store){
        return EmbeddingStoreContentRetriever.builder()
                .embeddingStore(store)//设置向量数据库操作对象
                .minScore(0.3)// 降低分值门槛，确保检索召回率
                .maxResults(5)// 增加结果上限，提供更多上下文
                .build();
    }
}