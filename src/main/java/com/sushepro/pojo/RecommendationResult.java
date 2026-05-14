package com.sushepro.pojo;

import java.util.Map;

public class RecommendationResult {

    private final String text;
    private final Map<String, Integer> scores;

    public RecommendationResult(String text, Map<String, Integer> scores) {
        this.text = text;
        this.scores = scores;
    }

    public String getText() {
        return text;
    }

    public Map<String, Integer> getScores() {
        return scores;
    }
}
