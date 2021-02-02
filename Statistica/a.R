
x = c(0,2,3)
y = c(1,1,4)
x1 = x
x2 = x ^ 2
lm(y ~ (x1 + x2))

x <- 0.5
c(qnorm((1 - x) / 2), qnorm(1 - (1 - x) / 2))

pnorm(0)