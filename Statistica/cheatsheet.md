# Examen PS

## Probabilitati

* Bayes: P(a | b) = P(b | a) * P(a) / P(b)
         P(a | b) = p(a ^ b) / P(b)
         P(a ^ b) = P(a | b) * P(b)
* Legea probabilitatii totale:
    A1 ... Ak partitie =>
        P(X) = P(X | A1) * P(A1) + P(X | A2) * P(A2) + ...
* A, B independenti <=> P(A ^ B) = P(A) * P(B)
                        P(A | B) = P(A)
* Dispersia:
    * Var(X) = R((X - m)^2) = E(X^2) - E(X)^2
    * Var(A + B) = Var(A) + Var(b)
    * Var(A * x + y) = x^2 * Var(A)
    * Stddev = sqrt(Var(x))

## Statistica

### Regresie Liniara

* Regresia liniara simpla -> regresie la o dreapta. 

Regresie lineara a punctelor `(x_i, y_i)` la un polinom de grad 2:
```R
    x = c(0,2,3)
    y = c(1,1,4)
    x1 = x
    x2 = x ^ 2
    lm(y ~ (x1 + x2))
```

## Intervale de Incredere

### Interval de incredere pentru o distributie normala cunoscuta

* Pentru distributia normala, interval de incredere de `X`:
    ```R    
        x <- 0.5
        c(qnorm((1 - x) / 2), qnorm(1 - (1 - x) / 2))
    ```
* Pentru distributia normala, probabilitatea sa fie `<X`:
    ```R        
        pnorm(x)
    ```
* P(−1 ≤ Z ≤ 1) ≈ 0.68, P(−2 ≤ Z ≤ 2) ≈ 0.95, P(−3 ≤ Z ≤ 3) ≈ 0.99.

### Interval de incredere pentru medie stiind date si dispersia
See curs 18, pagina 3 
* x1, x2 ... xn ~ N(miu, sigma^2); sigma cunoscut, miu necunoscut
* xbar = mean(x1, ..., xn)
* Intervalul de incredere (1 - a) al lui miu este:
    [xbar - qnorm(1 - a / 2) * sgima / sqrt(n), xbar + qnorm(1 - a / 2) * sigma / sqrt(n)]

## Interval de incredere pentru medie ne-stiind dispersia
See curs 18, pagina 9
* x1, x2 ... xn ~ N(miu, sigma^2); miu, sigma necunoscuti
* xbar = mean(x1, ..., xn)
* s = sqrt(var(x1, ..., xn))
* Intervalul de incredere (1 - a) al lui miu este:
    [xbar - qt(1 - a / 2, n - 1) * s / sqrt(n), xbar + qt(1 - a / 2, n - 1) * s / sqrt(n)]

## Interval de incredere pentru dispersie ne-stiind media
See curs 18, pagina 11
* x1, x2 ... xn ~ N(miu, sigma^2); miu, sigma necunoscuti
* s = sqrt(var(x1, ..., xn))
* Intervalul de incredere (1 - a) al lui sigma^2 este:
    [(n - 1) * s^2 / qchisq(a / 2, n - 1), (n - 1) * s^2 / qchisq(1 - a / 2, n - 1)]


## Limita centrala
Fie x1, x2, ..., xn ~ Distributie de medie miu si varianta var
Fie xbar media a N elemente iid.
Xbar ~ N(miu, var / N).
