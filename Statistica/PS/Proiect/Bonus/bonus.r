#################### a) #######################

frepcomgen <- function(n, m) {
	# Valorile lui X 
	xv <- seq(1, n, by=1)
	# Valorile lui Y
	yv <- seq(1, m, by=1)

	# Valorile din repartitia comuna a celor 2
	# sub forma de vector
	xycomp <- round(runif(m, 1, n + m), 0)
	xycomp <- append(xycomp, 0)

	for (i in 2:n) {
		aux <- round(runif(m, 1, n + m), 0)
		xycomp <- append(xycomp, aux)
		xycomp <- append(xycomp, 0)
	}
	xycomp <- append(xycomp, replicate(m + 1, 0))

	# Scaleaza valorile ca suma lor sa fie 1
	sum <- sum(xycomp)
	xycomp <- xycomp / sum

	# Transformarea in matrice
	xycomp <- matrix(xycomp, ncol = m + 1, byrow=TRUE)

	# Completarea probabilitatilor lui X si Y (ultima coloana / linie)
	for (i in 1:n) {
		sum <- sum(xycomp[i,])
		xycomp[i, m + 1] <- sum
	}
	for (i in 1:m) {
		sum <- sum(xycomp[, i])
		xycomp[n + 1, i] <- sum
	}
	xycomp[n + 1, m + 1] = 1
	# Schimbarea numelor liniilor si coloanelor
	rownames(xycomp) <- append(xv, "q")
	colnames(xycomp) <- append(yv, "p")
	xycomp[n, m] = NaN

	return(xycomp)
}

##################### b) ######################

# Gaseste prima pozitie din v pe care apare valoare value.
# In cazul in care last = TRUE, o gaseste pe ultima
find <- function(v, value, last=FALSE) {
	n <- length(v)

	if (last) {
		for (i in n:1) {
			if (v[i] == value) {
				return(i)
			}
		}
	} else {
		for (i in 1:n) {
			if (v[i] == value) {
				return(i)
			}
		}
	}
	return(NaN)
}

# Genereaza urmatoarea pozitie completabila din tabel
next_to_complete <- function(xycomp) {
	# Deminsiunile celor doua variabile
	n <- dim(xycomp)[1] - 1
	m <- dim(xycomp)[2] - 1

	# Cauta o pozitie completabila prin sume pe linii
	for (i in 1:(n + 1)) {
		row <- xycomp[i, ]
		first_NaN = find(is.nan(row), TRUE)
		last_NaN = find(is.nan(row), TRUE, last=TRUE)
		if (first_NaN == last_NaN && !is.nan(first_NaN)) {
			if (first_NaN != m + 1) {
				return(c(i, first_NaN, "l"))
			} else {
				return(c(i, first_NaN, NaN))
			}
		}
	}

	# Cauta o pozitie completabila prin sume pe coloane
	for (i in 1:(m + 1)) {
		col <- xycomp[, i]
		first_NaN = find(is.nan(col), TRUE)
		last_NaN = find(is.nan(col), TRUE, last=TRUE)
		if (first_NaN == last_NaN && !is.nan(first_NaN)) {
			if (first_NaN != n + 1) {
				return(c(first_NaN, i, "c"))
			} else {
				return(c(n + 1, i, NaN))
			}
		}	
	}

	return(NaN)
}

fcomplrepcom <- function(xycomp) {
	# Deminsiunile celor doua variabile
	n <- dim(xycomp)[1] - 1
	m <- dim(xycomp)[2] - 1

	poz <- next_to_complete(xycomp)
	while(!is.nan(poz)) {
		if (is.nan(poz[3])) {
			if (poz[1] == n + 1) {
				xycomp[poz[1], poz[2]] = sum(xycomp[poz[1], 1:m])
			} else if (poz[2] == m + 1) {
				xycomp[poz[1], poz[2]] = sum(xycomp[1:n, poz[2]])
			}
		} else if (identical(poz[3], "l")) {
			xycomp[poz[1], poz[2]] = xycomp[poz[1], m + 1] - sum(xycomp[poz[1], 1:m], na.rm=TRUE)
		} else {
			xycomp[poz[1], poz[2]] = xycomp[n + 1, poz[2]] - sum(xycomp[1:n, poz[2]], na.rm=TRUE)
		}
		poz <- next_to_complete(xycomp)
	}

	return (xycomp)
}

##################### c) ######################

# Calculeaza media unei variabile aleatoare X
E <- function(x) {
	return(sum(x[2, ] * x[1, ]))
}

# Calculeaza Cov(aX, bY)
Cov <- function(xycomp, a = 1, b = 1) {
	# Daca a si b exista, atunci apeleaza recursiv
	# Cov(X, Y)
	if (a != 1 || b != 1) {
		return(a * b * Cov(xycomp))
	}
	# Deminsiunile celor doua variabile
	n <- dim(xycomp)[1] - 1
	m <- dim(xycomp)[2] - 1

	# Calculam variabila aleatoare obtinuta daca din X scadem E(X)
	x <- append(round(as.numeric(rownames(xycomp[1:n, ])), 0), xycomp[1:n, m + 1])
	x <- matrix(x, nrow=2, byrow=TRUE)
	x[1, ] <- x[1, ] - E(x)

	# Calculam variabila aleatoare obtinuta daca din Y scadem E(Y)
	y <- append(round(as.numeric(colnames(xycomp[, 1:m])), 0), xycomp[n + 1, 1:m])
	y <- matrix(y, nrow=2, byrow=TRUE)
	y[1, ] <- y[1, ] - E(y)

	answer <- 0
	for (i in 1:n) {
		answer <- answer + sum(xycomp[i, 1:m] * y[1,]) * x[1, i]
	}

	return(answer)
}

# Calculeaza P(0 < X < 3 | Y > 2)
p1 <- function(xycomp) {
	# Deminsiunile celor doua variabile
	n <- dim(xycomp)[1] - 1
	m <- dim(xycomp)[2] - 1
	# P(A | B) = P(A ^ B) / P(B)
	# P(A ^ B)
	a <- sum(xycomp[1:2, 3:m])
	# P(B)
	b <- sum(xycomp[n + 1, 3:m])
	return(a / b)
}

# Calculeaza P(X > 6, Y < 7)
p2 <- function(xycomp) {
	# Deminsiunile celor doua variabile
	n <- dim(xycomp)[1] - 1
	m <- dim(xycomp)[2] - 1
	return(sum(xycomp[7:n, 1:6]))
}

###################### d) #####################

fverind <- function(xycomp) {
	# Deminsiunile celor doua variabile
	n <- dim(xycomp)[1] - 1
	m <- dim(xycomp)[2] - 1

	# Verifica pt fiecare element daca este produsul probabilitatilor din X si Y
	for (i in 1:n) {
		for (j in 1:m) {
			if (xycomp[i, j] != xycomp[i, m + 1] * xycomp[n + 1, j]) {
				return(FALSE)
			}
		}
	}

	return(TRUE)
}

fvernecor <- function(xycomp) {
	# Verifica daca Cov(X, Y) = 0
	return(Cov(xycomp) == 0)
}