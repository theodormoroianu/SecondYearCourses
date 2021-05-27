package com.multithread;

class Obj {
    synchronized static void F() { //sync pw obj.class
        for (int i = 0; i < 10; i++) {
            System.out.println("In F!");
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }
    

    synchronized void G() { // sync pe this
        for (int i = 0; i < 10; i++) {
            System.out.println("In G!");
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }
}

class C extends Thread {
    
    String s;
    Obj ob;
    public C(String s, Obj o) {
        this.s = s;
        ob = o;
    }

    @Override
    public void run() {
        if (s == "C1")
            ob.F();
        else
            ob.G();

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



public class Multi {
    public static void main (String args[]) {
        Obj o = new Obj();
        Obj o2 = new Obj();
        C a = new C("C1", o);
        C b = new C("C2", o2);

        a.start();
        b.start();

    }
}
