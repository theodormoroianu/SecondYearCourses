package com.example;

class A1{
    int intA;
    public A1 met1(){
        return new A1();
    }
    final void met2(){}
    public void met3(){}
    public static void met4(){}
    private int met5(int i){return 5;}
}

class B1 extends A1{
    int intB;
    public B1 met1(){
        return new B1();
    }
    public void met2(){}
    private void met3(){}
    static void met4(){}
    private int met5(){return 5;}
}

public class ex11 {
    
}
