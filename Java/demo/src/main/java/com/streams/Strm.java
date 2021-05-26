package com.streams;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Map;
import java.util.stream.Collectors;

public class Strm {
    public static void main(String[] args) throws IOException {
    Files.lines(Paths.get("exemplu.txt"))
        //creăm un stream în care înlocuim fiecare linie
        //cu un tablou format din cuvintele de pe linia respectivă
        .map(linie -> linie.split("[^\\w]+"))
        //creăm un stream în care înlocuim fiecare tablou de cuvinte
        //cu un stream format din cuvintele din tabloul respectiv
        .flatMap(tablou -> Arrays.stream(tablou))
        //păstrăm doar cuvintele cu lungime nenulă, adică
        //eliminăm liniile vide din fișierul text dat
        .filter(cuvant -> cuvant.length() > 0)
        //grupăm cuvintele și calculăm frecvența fiecărui cuvânt,
        //rezultatul fiind obținut într-un Map cu perechi cheie-valoare de 
        //forma (cuvânt, frecvență_cuvânt)
        .collect(Collectors.groupingBy(cuvant -> cuvant, Collectors.counting()))
        //creăm un nou stream din perechile din Map-ul obținut anterior
        .entrySet().stream()
        //sortăm perechile în ordinea descrescătoare a frecvențelor
        .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
        //afișam rezultatul
        .forEach(System.out::println);
    }
}
