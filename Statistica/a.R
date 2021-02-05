
####### Intervale de incredere

# Finds interval of (1 - a) precision
FindMiuKnowDev <- function(x, dev, a) {
    xbar <- mean(x)
    n <- length(x)
    delta = qnorm(1 - a / 2) * dev / sqrt(n)
    st <- xbar - delta
    dr <- xbar + delta
    print(c(st, dr))
}

# Finds interval of (1 - a) precision
FindMiuDontKnowDev <- function(x, a) {
    xbar <- mean(x)
    n <- length(x)
    s <- sqrt(var(x))
    delta = qt(1 - a / 2, n - 1) * s / sqrt(n)
    st <- xbar - delta
    dr <- xbar + delta
    print(c(st, dr))
}

# Finds sigma^2
FindVarDontKnowMiu <- function(x, a) {
    s <- sqrt(var(x))
    n <- length(x)
    dr <- (n - 1) * s^2 / qchisq(a / 2, n - 1)
    st <- (n - 1) * s^2 / qchisq(1 - a / 2, n - 1)
    print(c(st, dr))
}

FindVarDontKnowMiu(c(1, 2, 3, 6, 7), 0.1)

FindMiuDontKnowDev(c(1, 2, 3, 6, 7), 0.1)
FindMiuKnowDev(c(1, 2, 3, 7, 6), sqrt(5), 0.1)


# Combinari
choose (10, 3) / choose(10, 5)

#### Regresie liniara
y = c(1,2,3)
x = c(1,2,3)
x1 = x
x2 = x ^ 2
lm(y ~ (x1 + x2))





a = seq(0, 10, 1e-3)
avg = c()

for (i in 1:100000) {
    s = sample(a, 5)
    avg = c(avg, mean(s))
}






