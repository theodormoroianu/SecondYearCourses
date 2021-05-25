package com.multithread;

class C1 extends Thread {
    
    String s;
    public C1(String s) {
        this.s = s;
    }

    @Override
    public void run() {
        for (int i = 0; i < 10; i++) {
            System.out.println(s);
            try {
                sleep(1000);
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }
}

class C2 extends C1 {
    public C2() {
        super("C2");
    }
}

public class Multi {
    public static void main (String args[]) {
        C1 a = new C2();

        System.out.println(a instanceof C1);
    }
}
