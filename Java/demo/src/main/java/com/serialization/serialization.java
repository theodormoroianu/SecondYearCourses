package com.serialization;

import java.io.FileOutputStream;
import java.io.ObjectOutputStream;

public class serialization {
    public static void main(String[] args) {
        Person a = new Person(12, "123", "123");
        try (ObjectOutputStream fout = new ObjectOutputStream(new FileOutputStream("person.bin"))) {
            fout.writeObject(a);
        }
        catch (Exception e) {
            System.out.println(e);
        }
    }
}
