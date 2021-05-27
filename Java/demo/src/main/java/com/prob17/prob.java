package com.prob17;

class A{
    int intA;
    public A met1(){
        return new A();
    }
    final void met2(){}
    public void met3(){}
    public static void met4(){}
    private int met5(int i){return 5;}
}

class B extends A{
    int intB;
    public B met1(){
        return new B();
    }
    public void met2(){}
    private void met3(){}
    static void met4(){}
    private int met5(){return 5;}
}

public class prob {
    
}
