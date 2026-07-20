import numpy as np
import pandas as pd
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
# Import data
# Load the CSV file
df = pd.read_csv('SteamTurbineOperationData.csv')
# Assign data from each column to a specific variable
SimTim = df['Time [s]']
Gas_Temp_ref = df['T_Gas [C]']  # Note the column name correction
Gas_MassFlow_ref = df['m_Gas [kg/s]']
Electricity_ref = df['ST_e [W]']
# Define the model function
def regression_model(m_Exh, T_Gas, a, b, c):
    return m_Exh * (0.1961*(T_Gas*9/5+32)-86.918)/(0.0004299226)*(a + b * ((T_Gas*9/5+32) / 100) + c * ((T_Gas*9/5+32) / 100)**2)

# The independent variables must be passed as separate arguments, hence a small modification
def fitting_function(X, a, b, c):
    m_Exh, T_Gas = X
    return regression_model(m_Exh, T_Gas, a, b, c)

# Initial guess for the parameters
initial_guess = [0.1134, 0.0746, -0.00279]

# Use curve_fit to fit the model to the data
popt, pcov = curve_fit(fitting_function, (Gas_MassFlow_ref, Gas_Temp_ref), Electricity_ref, p0=initial_guess)

# popt contains the optimal values for the parameters a, b, and c
a_opt, b_opt, c_opt = popt

print("Optimal coefficients:")
print("a =", a_opt)
print("b =", b_opt)
print("c =", c_opt)
#------------------------------------------
# Validation and Comparison
#------------------------------------------
# Load the CSV file
# df = pd.read_csv('TPL_RawData.csv')
# # Assign data from each column to a specific variable
# SimTim = df['Time [s]']
# Gas_Temp_ref = df['T_Gas [C]']  # Note the column name correction
# Gas_MassFlow_ref = df['m_Gas [kg/s]']
# Electricity_ref = df['ST_e [W]']
# # Now you can use a_opt, b_opt, and c_opt to predict new values of electricity
# Electricity_pre = regression_model(Gas_MassFlow_ref, Gas_Temp_ref, a_opt, b_opt, c_opt)

# # Creating the plot
# plt.figure(figsize=(10, 5))  # Set the figure size
# plt.plot(SimTim, Electricity_ref, label='Steam Turbine Electricity', marker='o', markerfacecolor='none', linestyle='-', linewidth=2)  # Plot the actual data
# plt.plot(SimTim, Electricity_pre, label='Predicted Electricity', marker='x', linestyle='--', linewidth=2)  # Plot the predicted data

# # Adding title and labels
# plt.title('Steam Turbine Electricity Prediction')
# plt.xlabel('Simulation Time [s]')
# plt.ylabel('Electricity Usage [W]')
# plt.legend()  # Add a legend

# # Show the plot
# #plt.grid(True)  # Optional: add a grid for easier visualization
# plt.show()
