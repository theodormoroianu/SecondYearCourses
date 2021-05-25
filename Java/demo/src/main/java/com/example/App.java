package com.example;

import javax.swing.text.Style;

/**
 * Hello world!
 *
 */
public class App implements Runnable
{
    int x;

    public App(int x) {
        this.x = x;
    }

    public void run() {
        for (int i = 0; i < 10; i++)
            System.out.print(x);
    }
    public static void main( String[] args ) throws InterruptedException
    {
        String s = "Ionel are mere si pere!!";
        System.out.print(s.length() - s.replace("e", "").length());
        // App obj1 = new App(1);
        // App obj2 = new App(2);

        // Thread t1 = new Thread(obj1);
        // Thread t2 = new Thread(obj2);
        
        // t1.start();
        // t2.start();

        // t2.join();

        // System.out.println(3);

    }
}

