import numpy as np

X = np.array([
    [1, 2, 3, 4],
    [5, 6, 7, 8]
])

WQ = np.eye(4, dtype=int)
WK = np.eye(4, dtype=int)
WV = np.eye(4, dtype=int)

Q = X @ WQ
K = X @ WK
V = X @ WV

scores = Q @ K.T
scaled_scores = scores // 2   # because sqrt(dk)=sqrt(4)=2

attention = np.zeros_like(scaled_scores)

for i in range(2):
    if scaled_scores[i, 0] >= scaled_scores[i, 1]:
        attention[i] = [3, 1]   # approx [0.75, 0.25]
    else:
        attention[i] = [1, 3]   # approx [0.25, 0.75]

output = attention @ V
output = output // 4

print("Q:")
print(Q)

print("K:")
print(K)

print("V:")
print(V)

print("Scores:")
print(scores)

print("Scaled Scores:")
print(scaled_scores)

print("Approx Attention:")
print(attention)

print("Output:")
print(output)
