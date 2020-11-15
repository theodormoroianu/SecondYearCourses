# Tema Laborator Probabilitati si Statistica
# Autor: Theodor Moroianu
# Grupa: 234
# Data: 15 Nov

# I Definirea functiei Beta

# functia din interiorul intregralei gama
fgama <- function(x, a)
{
  x^(a-1)*exp(-x)
}

# definirea functiei gama, folosind proprietati ale acesteia
gama_teo <- function(x)
{
  if (x == round(x))
    return(factorial(x - 1))
  if (x > 1)
    return((x - 1.0) * gama_teo(x - 1.0))
  if (x == 0.5)
    return(sqrt(pi))
  return(integrate(fgama, 0, Inf, a = x)$value)
}

# definirea functiei beta, cu ajutorul unor proprietati
# ale acestia, si a functie gama definite mai sus
beta_teo <- function(a, b)
{
  if (a + b == 1)
    return(pi / sin(a * pi))
  return(gama_teo(a) * gama_teo(b) / gama_teo(a + b))
}

gama_teo(1.2)
beta_teo(1, 1)




# =========================================================================
# =========================================================================



# II Lucru cu `discreteRV`

# includ pachetele necesare
library(discreteRV)
library(MASS)

# Rezolvarea exercitiilor din fisierul "Lab 5-6"

# Ex 1
# A
X1 <- RV(c(2, 3), c(1/5, 4/5))
Y1 <- RV(c(-3, -2), c(4/5, 1/5))

# 3X - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- 3 * X1)
(manual <- RV(c(6, 9), c(1/5, 4/5)))

# X^-1 - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- X1^-1)
(manual <- RV(c(1/2, 1/3), c(1/5, 4/5)))

# cos(pi/2 * X) - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- cos(pi / 2 * X1))
(manual <- RV(c(cos(pi/2*2), cos(pi/2*3)), c(1/5, 4/5)))

# Y^2 - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- Y1^2)
(manual <- RV(c(9, 4), c(4/5, 1/5)))

# Y + 1 - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- Y1 + 1)
(manual <- RV(c(-2, -1), c(4/5, 1/5)))

# -------------------------------------------------

# B

X2 <- RV(c(0, 9), c(1/2, 1/2))
Y2 <- RV(c(-3, 1), c(1/7, 6/7))

# X - 1 - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- X2 - 1)
(manual <- RV(c(-1, 8), c(1/2, 1/2)))

# X^-2 - Nu se poate defini o probabilitate infinta
(computed <- X2^(-2))
(manual <- RV(c(Inf, 1/81), c(1/2, 1/2)))

# sin(pi/4 X) - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- sin(pi * X2 / 4))
(manual <- RV(c(0, sin(9 * pi / 4)), c(1/2, 1/2)))

# Y * 5 - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- Y2 * 5)
(manual <- RV(c(-15, 5), c(1/7, 6/7)))

# e^Y - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- exp(Y2))
(manual <- RV(c(exp(-3), exp(1)), c(1/7, 6/7)))

# -------------------------------------------------

# C
# Exercitiile se rezolva analog.
# Nu am mai copiat si rezolvarea mea

X3 <- RV(c(5, 8), c(1/3, 2/3))
Y3 <- RV(c(-1, 1), c(1/6, 5/6))

# 2X
(computed <- 2 * X3)

# X^-3
(computed <- X3 ^ -3)

# tg(pi X)
(computed <- tan(pi * X3))

# Y - 2
(computed <- Y3 - 2)

# |Y|
(computed <- abs(Y3))

# -------------------------------------------------

# D
# Exercitiile se rezolva analog.
# Nu am mai copiat si rezolvarea mea

X4 = RV(c(-3, 6), c(1/8, 7/8))
Y4 = RV(c(exp(1), exp(3)), c(1/4, 3/4))

# 2 - X
(computed <- 2 - X4)

# X^3
(computed <- X4^3)

# Cos(pi / 6 X)
(computed <- cos(pi / 6 * X4))

# 3 Y^-1
(computed <- Y4^-1)

# ln(Y)
(computed <- log(Y4))



# -------------------------------------------------


# Ex 2

# A

# 2x + 3y - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- 2 * X1 + 3 * Y1)
(manual <- RV(c(0, -2, -3, -5), c(4/25, 1/25, 16/25, 4/25)))

# 3x - y - rezultatul calculat manual este acelasi
# cu cel calculat automat
(computed <- 3 * X1 - Y1)
(manual <- RV(c(8, 9, 11, 12), c(1/25, 4/25, 4/25, 16/25)))

# X^2*Y^2 - rezultatul calculat manual este acelasi
# cu cel calculat automat. Este nevoie de cv vrajeala
# Ca sa pot sa inmulesc cele doua variabile
(computed <- exp(log(X1^2) + log(Y1^2)))
(manual <- RV(c(16, 36, 81), c(1/25, 8/25, 16/25)))

# -------------------------------------------------

# B
# Exercitiile se rezolva analog.
# Nu am mai copiat si rezolvarea mea

# X - Y
(computed <- X2 - Y2)

# cos(pi * x * y) - nu reusesc sa execut operatia
(computed <- cos(pi * X2 * Y2))

# X^2 + 3Y
(computed <- X2^2 + 3 * Y2)

# -------------------------------------------------

# C
# Exercitiile se rezolva analog.
# Nu am mai copiat si rezolvarea mea

# X + Y
(computed <- X3 + Y3)

# sin(pi / 2 * X * Y) - nu reusesc sa il fac sa ruleze
(computed <- sin(pi / 2 * X3 * Y3))

# 1/X + 1/Y
(computed <- 1 / X3 + 1 / Y3)

# -------------------------------------------------

# D
# Exercitiile se rezolva analog.
# Nu am mai copiat si rezolvarea mea

# X * Y - Nu reusesc sa il fac sa ruleze
(computed <- exp(log(X4) + log(Y4)))

# X / Y
(computed <- X4 / Y4)

# sin(pi / 2 * X * Y) - nu reusesc sa il fac sa ruleze
(computed <- sin(pi / 2 * X3 * Y3))

# 1/X + 1/Y
(computed <- 1 / X3 + 1 / Y3)

# |X - Y^2|
(computed <- abs(X4 - Y4 ^ 2))


# -------------------------------------------------

# Ex 3: N/A

# -------------------------------------------------

# Ex 4

# A
P(2 * X1 + 3 + Y1 > 1)

P(2 * X1 + 3 * Y1 > 0 | X1 > 0)
# OR
P((2 * X1 + 3 * Y1 > 0) %AND% (X1 > 0)) / P(X1 > 0)

P(2 * X1 + 3 * Y1 < 0 | Y1 < -2)
# OR
P((2 * X1 + 3 * Y1 < 0) %AND% (Y1 < -2)) / P(Y1 < -2)

P(X1^2 * Y1^3 > 3)

P(X1^2 * Y1^3 <= 3)

P(2 * X1 + 3 * Y1 < 3 * X1 - Y1)

# -------------------------------------------------

# B

P(X2 - Y2 > 0)

P(X2 - Y2 < 0 | X2 > 0)
# OR
P((X2 - Y2 < 0) %AND% (X2 > 0)) / P(X2 > 0)

P(X2 - Y2 > 0 | Y2 <= 0) # Cumva da probabilitatea 3 si nu inteleg de ce
# OR
P((X2 - Y2 > 0) %AND% (Y2 <= 0)) / P(Y2 <= 0) 

P(cos(pi * X2 * Y2) < 1/2) # nu ruleaza :(

P(X2^2 + 3 * Y2 >= 3)

P(X2 - Y2 < X2 ^ 2 + 3 * Y2)


# -------------------------------------------------

# C, D se rezolva similar.

# -------------------------------------------------

# Ex 2
# Facem reprezentarile grafice ale variabilelor

plot(X1)
plot(Y1)

plot(X2)
plot(Y2)

plot(X3)
plot(Y3)

plot(X4)
plot(Y4)

# -------------------------------------------------

# Ex 3
# Reprezentam functiile

t <- seq(-10, 10, 0.01)
plot(t, Map(function(x) { return(P(X1 < x)) }, t))
plot(t, Map(function(x) { return(P(Y1 < x)) }, t))

plot(t, Map(function(x) { return(P(X2 < x)) }, t))
plot(t, Map(function(x) { return(P(Y2 < x)) }, t))

plot(t, Map(function(x) { return(P(X3 < x)) }, t))
plot(t, Map(function(x) { return(P(Y3 < x)) }, t))

plot(t, Map(function(x) { return(P(X4 < x)) }, t))
plot(t, Map(function(x) { return(P(Y4 < x)) }, t))


# -------------------------------------------------

# Ex 4

compute_combined <- function(X, Y) {
  v1 <- as.vector(X)
  v2 <- as.vector (Y)
  p1 <- probs(X)
  p2 <- probs(Y)
  Z <- RV(c(v1, v2), c(p1, p2) / 2)
  return(Z)
}

X <- X1
Y <- Y1

# genereaza n rezultate random
simulate <- function(n) {
  Z <- compute_combined(X, Y)
  return(as.vector(rsim(Z, n)))
}

simulate(10)

plot(compute_combined(X, Y))
plot(t, Map(function(x) { return(P(compute_combined(X, Y) < x)) }, t))

