package com.example;

import javax.xml.transform.stream.StreamSource;

class Test {
    String s = "A";
    void A() {
        try {
            s += "B";
            B();
        }
        catch (Exception e) {
            s += "C";
        }
    }

    void B() throws Exception {
        try {
            s += "D";
            C();
        }
        catch (Exception e) {
            throw new Exception();
        }
        finally {
            s += "E";
        }
    }

    void C() throws Exception {
        throw new Exception();
    }
}

class A {
    public int x = 1;
    void afisare() {
        System.out.println(x);
    }
}

class B extends A {
    public int x = 2;
    void afisare() {
        System.out.println(x);
    }
}

public class App
{
    public static void main(String[] args)
    {
        A ob = new B();
        System.out.println(++ob.x);
    }
}

