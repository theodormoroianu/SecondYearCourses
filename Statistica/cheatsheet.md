# Examen PS

## Regresie Liniara

* Regresia liniara simpla -> regresie la o dreapta. 

Regresie lineara a punctelor `(x_i, y_i)` la un polinom de grad 2:
```R
    x = c(0,2,3)
    y = c(1,1,4)
    x1 = x
    x2 = x ^ 2
    lm(y ~ (x1 + x2))
```

## Interval de Incredere

* Pentru distributia normala, interval de incredere de `X`:
    ```R    
        x <- 0.5
        c(qnorm((1 - x) / 2), qnorm(1 - (1 - x) / 2))
    ```
* Pentru distributia normala, probabilitatea sa fie `<X`:
    ```R        
        pnorm(x)
    ```

# TODO:
1. mean, variance, deviation etc