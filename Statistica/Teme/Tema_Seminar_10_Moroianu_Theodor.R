# Tema Laborator Probabilitati si Statistica
# Autor: Theodor Moroianu
# Grupa: 234
# Data: 12 Dec

# II Lucru cu `discreteRV`,
# Folosirea variabilelor bidimensionale

# includ pachetele necesare
library(discreteRV)
library(MASS)

# Rezolvarea exercitiilor din fisierul "Lab 5-6"
# care necesita variabile bidimensionale

# Inmulteste doua variabile independente
# Efectiv ia toate combinatiile posibile,
# si presupune ca P(X = a && Y = b) = P(X = a) * P(Y = b)
# pentru ca variabilele sunt independente.
MultiplyIndependentVar <- function(X, Y) {
  value <- array(0, dim=length(X) * length(Y))
  prob <- array(0, dim=length(X) * length(Y))
  
  for (i in c(1:length(X))) {
    for (j in c(1:length(Y))) {
      prob[(i - 1) * length(Y) + j] = P(abs(X - X[i]) < 0.001) * P(abs(Y - Y[j]) < 0.001)
      value[(i - 1) * length(Y) + j] = X[i] * Y[j]
    }
  }
  
  ans <- RV(value, prob)
  return(ans)  
}


X1 <- RV(c(2, 3), c(1/5, 4/5))
Y1 <- RV(c(-3, -2), c(4/5, 1/5))


# X^2*Y^2
(computed <- MultiplyIndependentVar(X1^2, Y1^3))
# P(X^2 * Y^3 > 3)
P(MultiplyIndependentVar(X1^2, Y1^3) > 3)

X2 <- RV(c(0, 9), c(1/2, 1/2))
Y2 <- RV(c(-3, 1), c(1/7, 6/7))

# cos(Pi * X * Y)
(computed <- cos(pi * MultiplyIndependentVar(X2, Y2)))
#P(cos(PI * X * Y) < 1 / 2)
P(cos(pi * MultiplyIndependentVar(X2, Y2)) < 1 / 2)

X3 <- RV(c(5, 8), c(1/3, 2/3))
Y3 <- RV(c(-1, 1), c(1/6, 5/6))

# sin(Pi / 2 * X * Y)
(computed <- sin(pi / 2 * MultiplyIndependentVar(X2, Y2)))
# P(sin(pi /  2 * x * y) <= 1 / 2)
P(sin(pi / 2 * MultiplyIndependentVar(X3, Y3)) <= 1 / 2)

X4 = RV(c(-3, 6), c(1/8, 7/8))
Y4 = RV(c(exp(1), exp(3)), c(1/4, 3/4))

# X / Y
(computed <- MultiplyIndependentVar(X4, Y4^-1))
P(MultiplyIndependentVar(X4, Y4^-1) < abs(X4 - Y4^2))
