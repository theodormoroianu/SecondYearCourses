
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



i <- 2

X <- c(1, 2, 3, i + 3)

# Exercițiul 6
C <- cbind(1, X, X^2)
y <- c(1, 2, 3, 4)

# beta = (C^T * C)^(-1) * C^T * y
beta <- solve(t(C)%*%C, t(C)%*%y)

print(t(beta)) # Afișare pe linie

# Verificare cu lm
X_sq <- X^2

model <- lm(y ~ X + X_sq)
print(model$coefficients)

X2 <- X^2
lm(y ~ X + X2)




# Examen

i <- 116

# 1
DPlus = am boala
DMinus = nu am boala

Tplus = testul e pozitiv
TMinus = testul e negativ

Dplus <- i / 1000
Dminus <- 1 - Dplus

# Fals pozitiv
TplusCondDminus <- 0.03
TminusCondDplus <- 0.03

TplusCondDplus <- 1 - TminusCondDplus

Tplus <- TplusCondDminus * Dminus + TplusCondDplus * Dplus

# vrem sa calculam
(DplusCondTplus <- TplusCondDplus * Dplus / Tplus)

# 2
e <- 1^2 * i / 1000 + 2^2 * i / 500 + 3^2 * (1000 - 3 * i) / 1000
e

# 3

X ~ U(0, i)
Y = x^2
domeniu de valori este [0, sqrt(i)]

Fy(y) = P(Y <= y) = P(sqrt(X) <= y) = P(X <= y^2) = Fx(y^2) = y^2 / i
Fy(y) = y^2 / i
fy(y) = Fy(y)'' = 2 * y / i
fy(y) = 2 * y / i

# 4
# I aversuri -> folosim MLE
# P(i aversuri | p) = C(200, i) * p^i * (1 - p)^(200-i)
# Probabilitatea e maxima -> d/dp din P(i aversuri | p) = 0
# d/dp C(200, i) * p^i * (1 - p)^(200 - i) = 0
# i * p^(i - 1) * (1 - p)^(200 - i) - (200 - i) * p^i * (1 - p)^(200 - i - 1) = 0
# i * (1 - p) = (200 - i) * p
# i - i * p = 200 * p - i * p
# p = i / 200

# 5

Ipoteza               Prior                Likelihood                  Bayes numerator               posterior
   H                   P(H)                 P(D | H)                       P(D | H) * P(H)            P(H | D)
   A                   i / 200                0.5                            0.5 * i / 200            0.
   B                  1 - i / 200             0.8                         0.8 * (1 - i / 200)

P(D) = 0.5 * i / 200 + 0.8 * (1 - i / 200)
pd <- 0.5 * i / 200 + 0.8 * (1 - i / 200)
pd

(pAcondD <- 0.5 * i / 200 / pd)
(pBcondD <- 0.8 * (1 - i / 200) / pd)

(pAvers <- pAcondD * 0.5 + pBcondD * 0.8)
(pPriori <- 0.5 * i / 200 + 0.8 * (1 - i / 200))


# 6

