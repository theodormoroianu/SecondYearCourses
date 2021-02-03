#  Cerinta 1
model <- infert
plot(model)
edu <- model$age

medie<-mean(edu)
medie
varianta<-var(edu) 
varianta
q1=quantile(edu,1/4)
q1
q2=quantile(edu,2/4)
q2
q3=quantile(edu,3/4)
q3
q4=quantile(edu,4/4)
q4
mdn = median(edu, na.rm = FALSE)

varsta <- model$age

medie<-mean(varsta)
medie
varianta<-var(varsta) 
varianta
q1=quantile(varsta,1/4)
q1
q2=quantile(varsta,2/4)
q2
q3=quantile(varsta,3/4)
q3
q4=quantile(varsta,4/4)
q4
mdn = median(varsta, na.rm = FALSE)

paritate <- model$parity

medie<-mean(paritate)
medie
varianta<-var(paritate) 
varianta
q1=quantile(paritate,1/4)
q1
q2=quantile(paritate,2/4)
q2
q3=quantile(paritate,3/4)
q3
q4=quantile(paritate,4/4)
q4
mdn = median(paritate, na.rm = FALSE)

# Boxplot pentru Varsta si Numarul de nasteri
varstasrt = sort(varsta)
varsta
varstasrt
lg<-length(varstasrt)
boxplot(varsta~paritate,data=infert, main="Varsta-Numarul de nasteri
        (inainte de termen)", 
        xlab="Numarul de nasteri", ylab="Varsta",staplewex = 1, ylim=c(varstasrt[1], varstasrt[lg]))


boxplot(varsta~paritate,data=infert, main="Varsta-Numarul de nasteri(inainte de termen)", 
        xlab="Numarul de nasteri", ylab="Varsta",staplewex = 1, ylim=c(varstasrt[1], varstasrt[lg]))

text(y=fivenum(varsta~paritate), labels =fivenum(varsta~paritate), x=0.25)

boxplot(varsta, horizontal = TRUE, axes = FALSE, staplewex = 1)
text(x=fivenum(X), labels =fivenum(X), y=1.25)

vec <- c(26,26,26,38,38,39,39,39)
vec

quantile(vec)

indus <- model$induced

medie<-mean(indus)
medie
varianta<-var(indus) 
varianta

q1=quantile(indus,1/4)
q1
q2=quantile(indus,2/4)
q2
q3=quantile(indus,3/4)
q3
q4=quantile(indus,4/4)
q4
mdn = median(indus, na.rm = FALSE)

case <- model$case

medie<-mean(case)
medie
varianta<-var(case) 
varianta
q1=quantile(case,1/4)
q1
q2=quantile(case,2/4)
q2
q3=quantile(case,3/4)
q3
q4=quantile(case,4/4)
q4
mdn = median(case, na.rm = FALSE)

spontan <- model$spontaneous

medie<-mean(spontan)
medie
varianta<-var(spontan) 
varianta
q1=quantile(spontan,1/4)
q1
q2=quantile(spontan,2/4)
q2
q3=quantile(spontan,3/4)
q3
q4=quantile(spontan,4/4)
q4
mdn = median(spontan, na.rm = FALSE)

stratum <- model$stratum

medie<-mean(stratum)
medie
varianta<-var(stratum) 
varianta
q1=quantile(stratum,1/4)
q1
q2=quantile(stratum,2/4)
q2
q3=quantile(stratum,3/4)
q3
q4=quantile(stratum,4/4)
q4
mdn = median(stratum, na.rm = FALSE)

pooled.stratum <- model$pooled.stratum

medie<-mean(pooled.stratum)
medie
varianta<-var(pooled.stratum) 
varianta
q1=quantile(pooled.stratum,1/4)
q1
q2=quantile(pooled.stratum,2/4)
q2
q3=quantile(pooled.stratum,3/4)
q3
q4=quantile(pooled.stratum,4/4)
q4
mdn = median(pooled.stratum, na.rm = FALSE)

#  Cerinta 2

# Varianta 1 - Regresii Liniare

# Regresie simpla
edu <- infert$edu
varsta <- infert$age

linMod <- lm(edu ~ varsta, data = infert)
plot(x= varsta, y = edu, col = "red", pch = "*")
abline(linMod, col = "blue")

# Regresie multipla
varsta <- infert$age
paritate <- infert$parity
edu <- infert$edu
spontan <- infert$spontaneous

linMod1 <- lm(varsta ~ paritate + edu + spontan)
summary(linMod1)
layout(matrix(c(1, 2, 3, 4), 2, 2)) # 4 grafuri pe pagina

plot(linMod1)


# Varianta 2:

# Regresie liniara simpla cu o variabila independenta prin metoda celor mai mici patrate
varsta <- model$age # set de date initial
length(varsta) 
yage <-model$age #preluare date de analizat pentru selectie de regresie liniara
yrage<-yage*3/4 #propunere selectie de date pentru regresia liniara
yrage
round(yrage, digits = 0) #rotunjim detele noii propuneri de set de date
c=cbind(1,age)
solve(t(c) %*% c, t(c) %*% yrage)

boxplot(yrage~paritate,data=infert, main="Regresie liniara penru varsta", 
        xlab="Numarul de nasteri", ylab="Varsta",staplewex = 1)

# Regresie liniara multipla
# Regresie liniara multipla cu 2 variabila independente prin metoda celor mai mici patrate 
varsta <- model$age #set1 de date initial -> selectie de regresie liniara
length(varsta) 
paritate<-(model$parity) #set2 de date initial -> selectie de regresie liniara
c=cbind(1,varsta,paritate)
yrage=(1/4+paritate+varsta) #set combinat al datelor initiale 
round(yrage, digits = 0)
solve(t(c) %*% c, t(c) %*% yrage)

# Cerinta 3

# Distributia Weibull

layout(matrix(c(1, 2), 1, 2))
t <- seq(0, 2.5, 0.0001)
plot(t, pweibull(t, 0.5, 1), pch = ".", col = 2, xlim=c(0, 2.5), ylim=c(0, 1.0))
lines(t, pweibull(t, 1, 1), pch = ".", col = 3)
lines(t, pweibull(t, 1.5, 1), pch = ".", col = 4)
lines(t, pweibull(t, 5, 1), pch = ".", col = 5)
plot(t, dweibull(t, 0.5, 1), pch = ".", col = 2, xlim=c(0, 2.5), ylim=c(0, 2.5))
lines(t, dweibull(t, 1, 1), pch = ".", col = 3)
lines(t, dweibull(t, 1.5, 1), pch = ".", col = 4)
lines(t, dweibull(t, 5, 1), pch = ".", col = 5)
mean1 <- mean(pweibull(t, 0.5, 1))
mean2 <- mean(pweibull(t, 1, 1))
mean3 <- mean(pweibull(t, 1.5, 1))
mean4 <- mean(pweibull(t, 5, 1))
var1 <- var(pweibull(t, 0.5, 1))
var2 <- var(pweibull(t, 1, 1))
var3 <- var(pweibull(t, 1.5, 1))
var4 <- var(pweibull(t, 5, 1))
