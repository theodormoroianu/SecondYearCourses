# Examen ML

## Links

Link la intrebari din anii trecuti:
    - [CheatSheet](https://docs.google.com/document/d/1a0W5_j6gT0kQ6bveNjJczeOU4dyit6JesaGqSxg30Nk/edit)
    - [Exercitii rezolvate](https://docs.google.com/document/d/13WX6yz3jVaoXQnxX0Lkii8X939P5BjPZfCSC1dFEbzk/edit#heading=h.iu429wxt7qcc)

## Formule

```
D_1((a, b), (x, y)) = rad_1(abs(a - x)^1 + abs(b - y)^1)
D_2((a, b), (x, y)) = rad_2(abs(a - x) ^ 2 + abs(b - y) ^ 2)
```

```
Precision           = TP/(TP+FP)
Sensitivity(recall) = TP/(TP+FN)
Specificity         = TN/(TN+FP)
Accuracy            = (TP+TN)/(TP+TN+FP+FN)
F1                  = 2/(1/Precision+1/Recall)
```

# Functii Kernel

1. Functia RBF

Forma duala al unei matrice X: X.dot(X.T)

# Functii de performanta

1. MSE -> Regresie
2. Media erorilor in valoare absolutia -> Regresie
3. True positive ... matrice de confuzie -> Clasificare
4. Misclassificaiton error -> Clasificare