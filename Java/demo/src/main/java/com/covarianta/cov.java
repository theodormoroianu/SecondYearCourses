package com.covarianta;


class Base {
    protected void f() {
        System.out.println("Base!");
    }
}

class Derived extends Base {
    public void f() {
        System.out.println("Derived!");
    }
}

class BasePrime {
    public Base f() {
        return new Base();
    }
}

class DerivedPrime extends BasePrime {
    public Derived f() {
        return new Derived();
    }
}



public class cov {
    public static void main(String[] args) {
        var a = ((BasePrime)new DerivedPrime()).f();
        System.out.println(a.getClass().getName());
    }
}
