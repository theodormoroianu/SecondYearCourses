package com.example;

import java.util.HashMap;
import java.util.Map;

public class App
{
    public static void main(String[] args)
    {
        Map <Integer, String> mp = new HashMap<>();
        
        mp.put(1, "123sd dfs sd2");

        for (var i : mp.entrySet()) {
            System.out.println(i.getKey());
            System.out.println(i.getValue());
        }
        
    }
}

