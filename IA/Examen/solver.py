#%%
import numpy as np
import scipy.stats as stats
from sklearn.metrics import confusion_matrix
import sklearn.metrics as metrics
from sklearn.neighbors import KNeighborsClassifier

def n(a):
    return np.array(a)

def inv(a):
    return np.linalg.inv(a)

# Norma L2 în forma primală:
def norm_L2(X):
    norms = np.linalg.norm(X, axis = 1, keepdims = True)
    X = X / norms
    return X

# Norma L2 în forma duală:
def norm_L2_dual(X):
    K = np.matmul(X, X.T)
    KNorm = np.sqrt(np.diag(K))
    KNorm = KNorm[np.newaxis]
    K = K / np.matmul(KNorm.T, KNorm)
    return X

# from scipylearn
def kendalltau(v1, v2):
    rez, _ = stats.kendalltau(v1, v2)
    return rez

# def kendall_tau(v1, v2):
#     def sgn(x):
#         return 1 if x > 0 else 0 if x == 0 else -1

#     ans = 0
#     for i in range(len(v1)):
#         for j in range(i, len(v1)):
#             ans += sgn(v1[i] - v1[j]) * sgn(v2[i] - v2[j])
#     ans = 2 * ans / len(v1) / (len(v1) - 1)

#     return ans
    
def precision(TP, FP):
   return TP / (TP + FP)

def recall(TP, FN):
    return TP / (TP + FN)

def specificity(TN, FP):
    return TN / (TN + FP)

def accuracy(TP, TN, FP, FN):
    return (TP + TN) / (TP + TN + FP + FN)

def f1(Precision, Recall):
    return 2 / (1 / Precision + 1 / Recall)

def MSE(y, y_hat):
    return ((n(y) - n(y_hat))**2).mean()

def B_cond_A(A_cond_B, A, B):
    return A_cond_B * B / A

from sklearn.metrics import accuracy_score
from sklearn.metrics import f1_score
from sklearn.metrics import recall_score
from sklearn.metrics import precision_score



# Gets the standardization of data
def compute_standardization2(train, test):
    train = n(train).T
    test = n(test).T

    for i in range(train.shape[0]):
        me = train[i].mean()
        st = train[i].std()
        train[i] = (train[i] - me) / st
        test[i] = (test[i] - me) / st

        print(f"Feature #{i}: mean is {me:.4f}, std is {st:.4f}")

    train = train.T
    test = test.T

    return train, test

def compute_standardization(train):
    a, _  = compute_standardization2(train, train)
    return a

def Ridge_loss(y_hat, y, W, a):
    N = len(y_hat)
    y_hat = n(y_hat)
    y = n(y)
    L2 = (y_hat - y) ** 2
    L2 = L2.sum()
    W = n(W)
    W = (W**2).sum()
    W = np.sqrt(W)
    return 1 / N * L2 + a * W, L2 + a * W

def knn_dist(t, X):
    X = n(X)
    t = n(t)
    S = abs(X - t)
    R = []
    for s in S:
        R.append(s.sum())
    return R

def MAE(y, y_hat):
    y = n(y)
    y_hat = n(y_hat)
    return abs(y - y_hat).sum() / len(y)

def perceptron(input, W, b):
    return (n(input)*n(W)).sum() + b

def L1_norm(x):
    x = n(x)
    x = abs(x)
    s = x.sum()
    return x / s

def relu(x):
    return np.maximum(x, 0)

def net_relu(x, W1, B1, W2, B2):
    x = n(x)
    W1 = n(W1)
    W2 = n(W2)
    B1 = n(B1)
    B2 = n(B2)
    H1 = W1.T @ x + B1
    H1 = relu(H1)
    H2 = W2.T @ H1.T + B2
    H2 = relu(H2)
    return H2.item()

def SGD(W, g, l):
    W = n(W)
    g = n(g)
    return W - g*l

from sklearn.metrics import accuracy_score 
from sklearn.metrics import f1_score
from sklearn.metrics import precision_score, recall_score 

def scores(y_true, y_pred):
    print("Accuracy score: ", accuracy_score(y_true, y_pred))
    print("F1 score: ", f1_score(y_true, y_pred))
    print("Precision score: ", precision_score(y_true, y_pred))
    print("Recall score: ", recall_score(y_true, y_pred))

def knn_dist(K, X_train, Y_train, X_test):
    model = KNeighborsClassifier(K)
    model.fit(X_train, Y_train)
    pred = model.predict(X_test)
    return pred

# %%
