package com.serialization;

import java.io.Serializable;

class PersonOld {
    public int x;
}

public class Person extends PersonOld implements Serializable {
    public String s;
    public transient String t;

    Person(int x, String s, String t) {
        this.x = x;
        this.s = s;
        this.t = t;
        System.out.println("Hello");
    }

    Person() {
        System.out.println("Hello default");
    }
}
