package com.example;

class Fir extends Thread{
    int nivel;
    static int numar = 0;
    public Fir(int n){nivel=n;}
    public void run(){
        if (nivel == 999)
            numar++;
        // System.out.print(nivel+" ");
        if (nivel<4){
            Fir fir = new Fir(nivel+1);
            fir.start();
            try {
                fir.join();
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        if (nivel<1000){
            Fir fir = new Fir(nivel+1);
            fir.start();
            try {
                fir.join();
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }
}
public class ex9 {
    public static void main(String[] args) throws InterruptedException {
        Fir fir = new Fir(0);
        fir.start();
        fir.join();
        System.out.println(Fir.numar);
    }
}
