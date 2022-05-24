import matplotlib.pyplot as plt
from scipy.special import expit
import numpy as np

# range of x values
x = np.linspace(-16, 16, 100)

# weight and bias
w = 5
bias = 10

# sigmoid for x value
sig1 = expit(x)
sig2 = expit(x * w)
sig3 = expit(x + bias)
sig4 = expit(x - bias)

# plot and legend
plt.grid()
plt.plot(x, sig1, label = 'sig(x)')
plt.plot(x, sig2, label = 'sig(x * w)')
plt.plot(x, sig3, label = 'sig(x + bias)')
plt.plot(x, sig4, label = 'sig(x - bias)')
plt.plot(2, 0, marker = "o", markersize = 6, label = 'point(2,x)')
plt.legend(loc = "upper left")
plt.xlabel('input [x]')
plt.ylabel('output [F(x)]')
plt.show()