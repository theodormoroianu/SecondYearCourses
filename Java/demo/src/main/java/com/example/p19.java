package com.example;

import java.util.HashMap;

class A3{
    private A3() {
        
    }
    int a;
    public A3(int i){a=i;}
    public int hashCode(){ return 1;}
    public boolean equals(Object other){return true;}
    public final void f() {

    }
}

class A4 extends A3 {
    A4() {
        super(4);
    }
    public void f() {
        System.out.println(1);
    }
}

public class p19 {
    public static void main(String[] args) {

        System.out.println((new A4()) instanceof A3 );

        HashMap<A3,Integer> H = new HashMap<>();
        H.put(new A3(1), 1);
        H.put(new A3(1), 1);
        H.put(new A3(2), 2);
        H.put(new A3(2), 2);

        for (var i : H.entrySet())
            System.out.println(i.getKey() + " " + i.getValue());
    }
}
