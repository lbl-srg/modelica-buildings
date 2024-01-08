# -*- coding: utf-8 -*-
"""
Created on Thu Jan  4 18:07:17 2024

@author: luxi217
"""

import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
from sklearn.metrics import r2_score

# Read the data from the CSV file
df = pd.read_csv('data.csv')

# Define the bi-quadratic function
def bi_quadratic(xy, a, b, c, d, e, f):
    x, y = xy
    return a + b * x + c* x**2+ d * y + e * y**2 + f * x*y 

# Extract x, y, and z data from the dataframe
x_data = df['x'].values
y_data = df['y'].values
z_data = df['z'].values

# Initial guesses for the coefficients
initial_guess = [1, 1, 1, 1, 1, 1]

# Perform the curve fitting
params, covariance = curve_fit(bi_quadratic, (x_data, y_data), z_data, p0=initial_guess)

# Predict the values using the fitted coefficients
predicted_values = bi_quadratic((x_data, y_data), *params)

# Calculate R-squared
r_squared = r2_score(z_data, predicted_values)

# Output the fitted coefficients and R-squared
print("Fitted Coefficients:")
print("a:", params[0])
print("b:", params[1])
print("c:", params[2])
print("d:", params[3])
print("e:", params[4])
print("f:", params[5])
print("\nR-squared:", r_squared)