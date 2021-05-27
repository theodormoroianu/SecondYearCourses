package com.serialization;

import java.io.Serializable;

class PersonOld {
    public int x;
}

public class Person extends PersonOld implements Serializable {
    public String s;
    public transient String t;
    // PersonOld p; If defined, and not null, willl get notserializableException

    Person(int x, String s, String t) {
        this.x = x;
        this.s = s;
        this.t = t;
        System.out.println("Hello");
        // p = new PersonOld();
    }

    Person() {
        System.out.println("Hello default");
    }
}
