package com.sockets;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

public class server {
    public static void main(String[] args) throws IOException {
        ServerSocket ss = null;
        Socket cs = null;

        Scanner sc = new Scanner(System.in);

        System.out.println("Port: ");
        int port = sc.nextInt();

        ss = new ServerSocket(port);

        System.out.println("Serverul a pornit!");

        cs = ss.accept();

        System.out.println("Connected to client!");
        DataInputStream dis = new DataInputStream(cs.getInputStream());
        DataOutputStream dos = new DataOutputStream(cs.getOutputStream());
        
        while(true) {
            String linie = dis.readUTF();
            System.out.println("Mesaj receptionat: " + linie);
            if (linie.equals("STOP"))
                break;
            System.out.print("Mesaj de trimis: ");
            linie = sc.nextLine();
            dos.writeUTF(linie);
        }
        dis.close();
        dos.close();
        cs.close();
        ss.close();
    }
}
