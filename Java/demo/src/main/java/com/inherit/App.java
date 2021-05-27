package com.inherit;

class Base {
    public int a = 10;
    protected int b = 20;

    static protected void f() {
        System.out.println("Base!");
    }

    void g() {
        Base.f();
    }

    Base() {

    }
}

class Derived extends Base {
    int a = 30;
    Derived() {
        System.out.println(super.b);
    }

    static public void f() {
        System.out.println("Derived!");
    }
}

public class App {
    public static void main(String[] args) {
        Base a = new Derived();
        a.g();
        System.out.println(a.a);
    }
}
