# Prolog Cheat Sheet

## Usage

* Start prolog with `$ swipl`.
* Load code with `?- ['laborator/labx/sample.pl'].`.
* Exit `swipl` with `?- halt.`.

## Syntax

 * Variables, starting with capital letters or underscores without quotes.
 * Atoms are:
    * starting with lowercase letters.
    * Special caracters (e.g. `+`, `:::`, `<<->>+`).
    * In quotes (e.g. `"This is an atom"`).
 * Numbers
 
## Query

 ```pl
    bigger(elefant, horse).
    bigger(horse, donkey).
    bigger(donkey, mouse).
    bigger(house, elefant).

    is_bigger(A, B) :- bigger(A, B).
    is_bigger(A, B) :- bigger(A, X), is_bigger(X, B).
 ```

 * True / False query: `?- is_bigger(house, mouse).`
 * Get values: `?- is_bigger(X, mouse).`
    * `enter` to dimiss answers.
    * `;` to get next answer.
 * Multiple conditions: `?- is_bigger(house, X), is_bigger(X, Y), is_bigger(Y, mouse).`
