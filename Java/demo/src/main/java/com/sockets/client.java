package com.sockets;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.Scanner;

public class client {
    public static void main(String[] args) throws UnknownHostException, IOException {
        Scanner sc = new Scanner(System.in);
        System.out.print("Adresa serverului: ");
        String adresa = sc.next();
        System.out.print("Portul serverului: ");
        int port = sc.nextInt();
        sc.nextLine();
        //conectarea la server
        Socket cs = new Socket(adresa, port);
        System.out.println("Conectare reusita la server!");
        //preluăm fluxurile de intrare/ieșire de la/către server
        DataInputStream dis = new DataInputStream(cs.getInputStream());
        DataOutputStream dos = new DataOutputStream(cs.getOutputStream());
        //citim o linie de text de la tastatură și o transmitem server-ului,
        //după care așteptam răspunsul server-ului
        //chat-ul se închide tastând cuvântul STOP
        while(true) {
            System.out.print("Mesaj de trimis: ");
            String linie = sc.nextLine();
            dos.writeUTF(linie);
            if (linie.equals("STOP"))
                break;
            linie = dis.readUTF();
            System.out.println("Mesaj receptionat: " + linie);
        }
        cs.close();
        dis.close();
        dos.close();
    }   
}
