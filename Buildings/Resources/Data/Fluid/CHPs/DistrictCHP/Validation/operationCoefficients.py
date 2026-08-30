import numpy as np
import pandas as pd
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

# Import data
# Load the CSV file
df = pd.read_csv('SteamTurbineOperationData.csv')

# ------------------------------------------------------
# Dataset needed for finding the coefficients for calculating steam turbine
# exhaust exergy efficiency
Time      = df['Time [s]']
T_Exh_ref = df['T_Gas [C]']       # Reference exhaust gas temperature     [degC]
m_Exh_ref = df['m_Gas [kg/s]']    # Reference exhaust gas mass flow rate  [kg/s]
P_ref     = df['ST_e [W]']        # Reference power generation            [W]

# Define the function for steam turbine power generation (W):
#     P_STG = m_exh * a_exh * ε_exh
# where the a_exh is the exhaust specific exergy (J/kg):
#     a_exh = (0.196 T_exh - 86.918) / 0.0004299226
# and the ε_exh is the exhaust exergy efficiency:
#     ε_exh = a1 + a2 (T_exh / 100) + a3 (T_exh / 100)2 
def power_generation(m_Exh, T_Exh, a, b, c):
    return m_Exh * (0.1961*(T_Exh*9/5+32)-86.918)/(0.0004299226) * (a + b * ((T_Exh*9/5+32) / 100) + c * ((T_Exh*9/5+32) / 100)**2)

# The independent variables must be passed as separate arguments, hence a small modification
def fitting_function(X, a, b, c):
    m_Exh, T_Exh = X
    return power_generation(m_Exh, T_Exh, a, b, c)

# Initial guess for the parameters
a_ini = [0.1134, 0.0746, -0.00279]

# Use curve_fit to fit the model to the data
popt, pcov = curve_fit(fitting_function, (m_Exh_ref, T_Exh_ref), P_ref, p0 = a_ini)

# Thus the coefficients for calculating steam turbine exhaust exergy efficiency:
print("Coefficients for calculating steam turbine exhaust exergy efficiency a:")
print(popt)


# ------------------------------------------------------
# Additional dataset needed for finding the coefficients for calculating steam turbine
# steam to exhaust mass flow ratio
T_Ste_ref = df['T_Steam [C]']      # Steam temperature    [degC]
m_Ste_ref = df['m_Steam [kg/s]']   # Steam mass flow      [kg/s]

# Target quantity: steam to exhaust mass flow ratio
mu_ref = np.array(m_Ste_ref) / np.array(m_Exh_ref)

# Convert temperature from degC to degF
def degC_to_degF(T_degC):
    return np.array(T_degC) * 9.0 / 5.0 + 32.0

T_Exhaust_ref = degC_to_degF(T_Exh_ref)
T_Steam_ref   = degC_to_degF(T_Ste_ref)

# Define the correlation. The following function is implemented in
# Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.Functions.SteamToExhaustMassFlowRatio
#   mu = [a + b*(T_exhaust/100 - 11)] - c*(T_steam - 1050)/25
def steam_exhaust_ratio(X, a, b, c):
    T_Exh, T_Ste = X
    return (a + b * (T_Exh / 100.0 - 11.0)) - c * (T_Ste - 1050.0) / 25.0

# Initial guess: a ~ mean mu (matches a_SteMas constant 0.1140), b and c small.
a_SteMas_ini = [0.1140, 0.0, 0.0]

# Use curve_fit to fit the model to the data
popt, pcov = curve_fit(steam_exhaust_ratio, (T_Exhaust_ref, T_Steam_ref), mu_ref, p0 = a_SteMas_ini)

# Thus the coefficients for calculating steam turbine steam to exhaust mass flow ratio:
print("Coefficients for calculating steam turbine exhaust exergy efficiency a_SteMas:")
print(popt)


