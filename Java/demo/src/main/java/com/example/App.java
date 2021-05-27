package com.example;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.stream.Collectors;

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

public class App
{
    public static void main(String[] args)
    {
        ArrayList<Persoana> listaPersoane = new ArrayList<>();
        listaPersoane.add(new Persoana("Batei", 2100));
        listaPersoane.add(new Persoana("Batei2", 3000));
        listaPersoane.add(new Persoana("Batei3", 1000));
        listaPersoane.add(new Persoana("Batei4", 1200));

        var a= listaPersoane.stream()
            .filter(p -> p.getSalariu()>2000)
            .filter(p -> p.getNume().startsWith("B"))
            .map(Persoana::getSalariu)
            .sorted()
            .map(o -> o.toString())
            .collect(Collectors.joining(","));

        System.out.println(a);
        // for (int i = 1; i <= 5; i++)
        //     try (Scanner sc = new Scanner(new File("file" + i + ".txt"))) {
        //         System.out.print(sc.nextInt());
        //     } catch (FileNotFoundException e) {
        //         System.out.print("!");
        //     } catch (Exception e) {
        //         System.out.print("?");
        //     } finally {
        //         System.out.print("F");
        //     }
        // List<Integer> l = new ArrayList<>();
        // l.add(3);
        // l.add(0);

        // var a = l.stream()
        //     .map((x) -> 1 / x);

        // System.out.println("Hello");

        // a.forEach((x) -> System.out.println(x));
            

    }
}

