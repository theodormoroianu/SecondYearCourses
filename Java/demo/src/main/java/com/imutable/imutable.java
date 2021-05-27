package com.imutable;

class A {
    Integer intA;
    public A(Integer i) {intA = i;}
    public void set(Integer i) {intA = i;}
    public A(A other) {intA = other.intA;}
}

class B{
    A obiect;
    public B(A init) {
        obiect = new A(init);
    }
    public B(B other) {obiect = other.obiect;}
    public A getA() {
        return obiect;
    }
}

class C{
    B obiect;
    public C(B init) {
        obiect = new B(init);
    }
    public B getB() {
        return new B(obiect);
    }
}

public class imutable {
    public static void main(String[] args) {
        C im = new C(new B(new A(10)));

        System.out.println("Initial value stored in C: " + im.getB().getA().intA);
        // prints "Initial value stored in C: 10"

        // Change value of im.
        im.getB().getA().set(20);
        
        
        System.out.println("Final value stored in C: " + im.getB().getA().intA);
        // prints "Final value stored in C: 20"
    }    
}
