package com.nexusreview.service;

import dev.langchain4j.memory.ChatMemory;
import dev.langchain4j.memory.chat.ChatMemoryProvider;
import dev.langchain4j.model.chat.ChatLanguageModel;
import dev.langchain4j.rag.content.retriever.ContentRetriever;
import dev.langchain4j.service.AiServices;
import dev.langchain4j.service.TokenStream;
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class ConsultantService {

    private final ChatLanguageModel chatLanguageModel;
    private final ContentRetriever contentRetriever;
    private final ChatMemoryProvider chatMemoryProvider;

    public ConsultantService(ChatLanguageModel chatLanguageModel, 
                             ContentRetriever contentRetriever, 
                             ChatMemoryProvider chatMemoryProvider) {
        this.chatLanguageModel = chatLanguageModel;
        this.contentRetriever = contentRetriever;
        this.chatMemoryProvider = chatMemoryProvider;
    }

    interface Assistant {
        @dev.langchain4j.service.SystemMessage("You are a professional Swedish culinary expert. Help users find shops and answer questions about food in Sweden. Use provided context to answer. If you don't know, say you don't know.")
        TokenStream chat(String message);
    }

    /**
     * 与 AI 专家对话（流式响应）
     * 接入 Resilience4j 熔断器，防止大模型响应缓慢导致服务死锁
     */
    @CircuitBreaker(name = "aiService", fallbackMethod = "askFallback")
    public TokenStream ask(Long userId, String message) {
        Assistant assistant = AiServices.builder(Assistant.class)
                .chatLanguageModel(chatLanguageModel)
                .contentRetriever(contentRetriever)
                .chatMemory(chatMemoryProvider.get(userId))
                .build();
        return assistant.chat(message);
    }

    /**
     * 熔断降级兜底方案
     */
    public TokenStream askFallback(Long userId, String message, Throwable t) {
        System.err.println("AI Service Error (Circuit Open): " + t.getMessage());
        return tokenStream -> {
            tokenStream.onNext("Sorry, the AI expert is currently taking a fika break (busy or unavailable). Please try again in a few moments! ☕️");
            tokenStream.onComplete();
        };
    }
}
