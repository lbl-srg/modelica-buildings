# -*- coding: utf-8 -*-
"""
Created on Sun Oct 18 10:53:00 2020
@author: Massimo Cimmino
This script generates the figures for
IBPSA.Media.Antifreeze.EthyleneGlycolWater.
"""

from __future__ import division, print_function, absolute_import
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from matplotlib.ticker import AutoMinorLocator
import numpy as np

def main():

    print_table(20.)
    plot_properties(c=[5,10,20,30,40,50,60])
    plot_relative_error(c=[5,10,20,30,40,50,60], dT=10)
    plot_relative_error(c=[5,10,20,30,40,50,60], dT=20)


def print_table(c):
    T = [100, 80, 60, 40, 20, 10, 0]
    for temp in T:
        rho = ethyleneGlycol_Density(c, temp)
        cp = ethyleneGlycol_HeatCapacity(c, temp)
        k = ethyleneGlycol_ThermalConductivity(c, temp)
        mu = ethyleneGlycol_DynamicViscosity(c, temp)
        print(temp, rho, cp, k, mu)


def plot_properties(c):
    plt.rc('figure', figsize=(8, 4))
    plt.figure()
    gs = gridspec.GridSpec(2, 2)
    ax0 = plt.subplot(gs[0])
    ax1 = plt.subplot(gs[1])
    ax2 = plt.subplot(gs[2])
    ax3 = plt.subplot(gs[3])
    
    for i in range(len(c)):
        Tf = ethyleneGlycol_FusionTemperature(c[i], 0)
        T = np.linspace(Tf, 100, num=200)
        # Density
        rho = np.array([ethyleneGlycol_Density(c[i], T[j]) for j in range(len(T))])
        ax0.plot(T, rho, lw=1.5, label='c = {}%'.format(c[i]))
        # Heat Capacity
        cp = np.array([ethyleneGlycol_HeatCapacity(c[i], T[j]) for j in range(len(T))])
        ax1.plot(T, cp, lw=1.5, label='c = {}%'.format(c[i]))
        # Density
        k = np.array([ethyleneGlycol_ThermalConductivity(c[i], T[j]) for j in range(len(T))])
        ax2.plot(T, k, lw=1.5, label='c = {}%'.format(c[i]))
        # Density
        mu = np.array([ethyleneGlycol_DynamicViscosity(c[i], T[j]) for j in range(len(T))])
        ax3.plot(T, np.log(mu), lw=1.5, label='c = {}%'.format(c[i]))
    # Axis labels
    ax0.set_xlabel('T [°C]')
    ax0.set_ylabel(r'$\rho$ [kg/m3]')
    ax1.set_xlabel('T [°C]')
    ax1.set_ylabel(r'$c_p$ [J/kg-K]')
    ax2.set_xlabel('T [°C]')
    ax2.set_ylabel(r'$\lambda$ [W/m-K]')
    ax3.set_xlabel('T [°C]')
    ax3.set_ylabel(r'$ln(\eta$) [mPa-s]')
    # Show minor ticks
    ax0.xaxis.set_minor_locator(AutoMinorLocator())
    ax0.yaxis.set_minor_locator(AutoMinorLocator())
    ax1.xaxis.set_minor_locator(AutoMinorLocator())
    ax1.yaxis.set_minor_locator(AutoMinorLocator())
    ax2.xaxis.set_minor_locator(AutoMinorLocator())
    ax2.yaxis.set_minor_locator(AutoMinorLocator())
    ax3.xaxis.set_minor_locator(AutoMinorLocator())
    ax3.yaxis.set_minor_locator(AutoMinorLocator())
    # Show major grid
    ax0.grid(ls=':')
    ax1.grid(ls=':')
    ax2.grid(ls=':')
    ax3.grid(ls=':')
    # Legend
    ax3.legend(loc='upper right', fontsize=6, framealpha=0)
    # Adjust to plot window
    plt.tight_layout()
    
    plt.savefig('EthyleneGlycolWaterProperties.png', dpi=100)
    # plt.savefig('EthyleneGlycolWaterProperties.pdf', dpi=100)


def plot_relative_error(c, dT):
    plt.rc('figure', figsize=(8, 4))
    plt.figure()
    gs = gridspec.GridSpec(2, 2)
    ax0 = plt.subplot(gs[0])
    ax1 = plt.subplot(gs[1])
    ax2 = plt.subplot(gs[2])
    ax3 = plt.subplot(gs[3])
    
    for i in range(len(c)):
        Tf = ethyleneGlycol_FusionTemperature(c[i], 0)
        T = np.linspace(Tf+dT, 100-dT, num=200)
        # Density
        rho = np.array([ethyleneGlycol_Density(c[i], T[j]) for j in range(len(T))])
        rhop = np.array([ethyleneGlycol_Density(c[i], min(T[j]+dT, 100)) for j in range(len(T))])
        rhom = np.array([ethyleneGlycol_Density(c[i], max(T[j]-dT, Tf)) for j in range(len(T))])
        drho = np.maximum(np.abs((rhop-rho)/rho),np.abs((rhom-rho)/rho))
        ax0.plot(T, drho, lw=1.5, label='c = {}%'.format(c[i]))
        # Heat Capacity
        cp = np.array([ethyleneGlycol_HeatCapacity(c[i], T[j]) for j in range(len(T))])
        cpp = np.array([ethyleneGlycol_HeatCapacity(c[i], min(T[j]+dT, 100)) for j in range(len(T))])
        cpm = np.array([ethyleneGlycol_HeatCapacity(c[i], max(T[j]-dT, Tf)) for j in range(len(T))])
        dcp = np.maximum(np.abs((cpp-cp)/cp),np.abs((cpm-cp)/cp))
        ax1.plot(T, dcp, lw=1.5, label='c = {}%'.format(c[i]))
        # Thermal Conductivity
        k = np.array([ethyleneGlycol_ThermalConductivity(c[i], T[j]) for j in range(len(T))])
        kp = np.array([ethyleneGlycol_ThermalConductivity(c[i], min(T[j]+dT, 100)) for j in range(len(T))])
        km = np.array([ethyleneGlycol_ThermalConductivity(c[i], max(T[j]-dT, Tf)) for j in range(len(T))])
        dk = np.maximum(np.abs((kp-k)/k),np.abs((km-k)/k))
        ax2.plot(T, dk, lw=1.5, label='c = {}%'.format(c[i]))
        # Dynamic Viscosity
        mu = np.array([ethyleneGlycol_DynamicViscosity(c[i], T[j]) for j in range(len(T))])
        mup = np.array([ethyleneGlycol_DynamicViscosity(c[i], min(T[j]+dT, 100)) for j in range(len(T))])
        mum = np.array([ethyleneGlycol_DynamicViscosity(c[i], max(T[j]-dT, Tf)) for j in range(len(T))])
        dmu = np.maximum(np.abs((mup-mu)/mu),np.abs((mum-mu)/mu))
        ax3.plot(T, dmu, lw=1.5, label='c = {}%'.format(c[i]))
    # Axis labels
    ax0.set_xlabel('T [°C]')
    ax1.set_xlabel('T [°C]')
    ax2.set_xlabel('T [°C]')
    ax3.set_xlabel('T [°C]')
    ax0.set_title(r'$max(|\rho(T)-\rho(T\pm{}°C)|)/\rho(T)$'.format(dT))
    ax1.set_title(r'$max(|c_p(T)-c_p(T\pm{}°C)|)/c_p(T)$'.format(dT))
    ax2.set_title(r'$max(|\lambda(T)-\lambda(T\pm{}°C)|)/\lambda(T)$'.format(dT))
    ax3.set_title(r'$max(|\eta(T)-\eta(T\pm{}°C)|)/\eta(T)$'.format(dT))
    # Show minor ticks
    ax0.xaxis.set_minor_locator(AutoMinorLocator())
    ax0.yaxis.set_minor_locator(AutoMinorLocator())
    ax1.xaxis.set_minor_locator(AutoMinorLocator())
    ax1.yaxis.set_minor_locator(AutoMinorLocator())
    ax2.xaxis.set_minor_locator(AutoMinorLocator())
    ax2.yaxis.set_minor_locator(AutoMinorLocator())
    ax3.xaxis.set_minor_locator(AutoMinorLocator())
    ax3.yaxis.set_minor_locator(AutoMinorLocator())
    # Show major grid
    ax0.grid(ls=':')
    ax1.grid(ls=':')
    ax2.grid(ls=':')
    ax3.grid(ls=':')
    # Legend
    ax3.legend(loc='upper right', fontsize=6, framealpha=0)
    # Adjust to plot window
    plt.tight_layout()
    
    plt.savefig('EthyleneGlycolWaterError{}degC.png'.format(dT), dpi=100)
    # plt.savefig('EthyleneGlycolWaterError{}degC.pdf'.format(dT), dpi=100)


def ethyleneGlycol_FusionTemperature(c, T):
    xm = 30.8462
    ym = 31.728
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [-1.525e1, -1.566e-6, -2.278e-7, 2.169e-9,-8.080e-1, -1.339e-6, 2.047e-8, -2.717e-11, -1.334e-2, 6.322e-8, 2.373e-10, -2.183e-12, -7.293e-5, 1.764e-9, -2.442e-11, 1.006e-6, -7.662e-11, 1.140e-9]
    Tf = polynomialProperty(c, T, xm, ym, nx, ny, coeff)
    return Tf


def ethyleneGlycol_Density(c, T):
    xm = 30.8462
    ym = 31.728
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [1.034e3, -4.781e-1, -2.692e-3, 4.725e-6, 1.311e0, -6.876e-3, 4.805e-5, 1.690e-8, 7.490e-5, 7.855e-5, -3.995e-7, 4.982e-9, -1.062e-4, 1.229e-6, -1.153e-8, -9.623e-7, -7.211e-8, 4.891e-8]
    rho = polynomialProperty(c, T, xm, ym, nx, ny, coeff)
    return rho


def ethyleneGlycol_HeatCapacity(c, T):
    xm = 30.8462
    ym = 31.728
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [3.737e3, 2.930e0, -4.675e-3, -1.389e-5, -1.799e1, 1.046e-1, -4.147e-4, 1.847e-7, -9.933e-2, 3.516e-4, 5.109e-6, -7.138e-8, 2.610e-3, -1.189e-6, -1.643e-7, 1.537e-5, -4.272e-7, -1.618e-6]
    cp = polynomialProperty(c, T, xm, ym, nx, ny, coeff)
    return cp


def ethyleneGlycol_ThermalConductivity(c, T):
    xm = 30.8462
    ym = 31.728
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [4.720e-1, 8.903e-4, -1.058e-6, -2.789e-9, -4.286e-3, -1.473e-5, 1.059e-7, -1.142e-10, 1.747e-5, 6.814e-8, -3.612e-9, 2.365e-12, 3.017e-8, -2.412e-9, 4.004e-11, -1.322e-9, 2.555e-11, 2.678e-11]
    k = polynomialProperty(c, T, xm, ym, nx, ny, coeff)
    return k


def ethyleneGlycol_DynamicViscosity(c, T):
    xm = 30.8462
    ym = 31.728
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [4.705e-1, -2.550e-2, 1.782e-4, -7.669e-7, 2.471e-2, -1.171e-4, 1.052e-6, -1.634e-8, 3.328e-6, 1.086e-6, 1.051e-8, -6.475e-10, 1.659e-6, 3.157e-9, 4.063e-10, 3.089e-8, 1.831e-10, -1.865e-9]
    mu = np.exp(polynomialProperty(c, T, xm, ym, nx, ny, coeff))
    return mu


def polynomialProperty(x, y, xm, ym, nx, ny, coeff):
    dx = x - xm
    dy = y - ym

    f = 0
    n = -1
    for i in range(nx):
        for j in range(ny[i]):
            n += 1
            f += coeff[n]*dx**i*dy**j

    return f

if __name__ == '__main__':
    main()
    