import numpy as np

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

def kendall_tau(v1, v2):
    def sgn(x):
        return 1 if x > 0 else 0 if x == 0 else -1

    ans = 0
    for i in range(len(v1)):
        for j in range(i, len(v1)):
            ans += sgn(v1[i] - v1[j]) * sgn(v2[i] - v2[j])
    ans = 2 * ans / len(v1) / (len(v1) - 1)

    return ans
    
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