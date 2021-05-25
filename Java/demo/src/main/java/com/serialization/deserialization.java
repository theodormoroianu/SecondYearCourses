package com.serialization;

import java.io.FileInputStream;
import java.io.ObjectInputStream;

public class deserialization {
    public static void main(String[] args) {
        Person a = null;
        try (ObjectInputStream fin = new ObjectInputStream(new FileInputStream("person.bin"))) {
            a = (Person)fin.readObject();
        }
        catch (Exception e) {
            System.out.println(e);
        }

        System.out.println(a.s + ' ' + a.t + ' ' + a.x);
    }
}
