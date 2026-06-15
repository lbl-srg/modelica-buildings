import numpy as np
import pandas as pd
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

#----------------------------
# Import data
#----------------------------
# Load the CSV file
df = pd.read_csv('SteamTurbineOperationData.csv')

# Assign data from each column to a specific variable.
# NOTE: adjust the column names below to match your ThermoPower export.
# The new correlation needs steam temperature and steam mass flow in
# addition to the exhaust-side quantities.
SimTim          = df['Time [s]']
T_Exhaust_ref_C = df['T_Gas [C]']        # exhaust gas temperature [C]
m_Exhaust_ref   = df['m_Gas [kg/s]']     # exhaust gas mass flow   [kg/s]
T_Steam_ref_C   = df['T_Steam [C]']      # steam temperature       [C]
m_Steam_ref     = df['m_Steam [kg/s]']   # steam mass flow         [kg/s]

#----------------------------
# Target quantity: mu = steam-to-exhaust mass flow ratio
#----------------------------
mu_ref = np.array(m_Steam_ref) / np.array(m_Exhaust_ref)

#----------------------------
# Unit handling
#----------------------------
# The correlation constants (T_exhaust/100 - 11) and (T_steam - 1050)/25 are
# written for temperature in Fahrenheit (same convention as the reference
# regression_model, which used T_Gas*9/5+32). Convert the CSV Celsius values
# to Fahrenheit here. If your CSV already stores temperatures in Fahrenheit,
# replace the two assignments below with a direct pass-through.
def C_to_F(T_C):
    return np.array(T_C) * 9.0 / 5.0 + 32.0

T_Exhaust_ref = C_to_F(T_Exhaust_ref_C)
T_Steam_ref   = C_to_F(T_Steam_ref_C)

#----------------------------
# Define the correlation
#   mu = [a + b*(T_exhaust/100 - 11)] - c*(T_steam - 1050)/25
#----------------------------
def mu_model(X, a, b, c):
    T_exhaust, T_steam = X
    return (a + b * (T_exhaust / 100.0 - 11.0)) - c * (T_steam - 1050.0) / 25.0

# Initial guess: a ~ mean mu (matches a_SteMas constant 0.1140), b and c small.
initial_guess = [0.1140, 0.0, 0.0]

# Use curve_fit to fit the model to the data
popt, pcov = curve_fit(mu_model, (T_Exhaust_ref, T_Steam_ref), mu_ref, p0=initial_guess)

# popt contains the optimal values for the parameters a, b, and c
a_opt, b_opt, c_opt = popt

print("Optimal coefficients:")
print("a =", a_opt)
print("b =", b_opt)
print("c =", c_opt)

#------------------------------------------
# Validation and Comparison
#------------------------------------------
# Predict mu with the fitted coefficients
mu_pre = mu_model((T_Exhaust_ref, T_Steam_ref), a_opt, b_opt, c_opt)

# Creating the plot
plt.figure(figsize=(10, 5))
plt.plot(SimTim, mu_ref, label='Steam-to-exhaust ratio (ref)',
         marker='o', markerfacecolor='none', linestyle='-', linewidth=2)
plt.plot(SimTim, mu_pre, label='Predicted ratio',
         marker='x', linestyle='--', linewidth=2)

# Adding title and labels
plt.title('Steam-to-Exhaust Mass Flow Ratio Prediction')
plt.xlabel('Simulation Time [s]')
plt.ylabel('mu = m_steam / m_exhaust [-]')
plt.legend()

# Show the plot
plt.show()
