# -*- coding: utf-8 -*-
"""
Created on Fri Mar  9 18:33:59 2018

@author: Massimo Cimmino

This script generates the figures for
IBPSA.Media.Antifreeze.PropyleneGlycolWater.
"""

from __future__ import division, print_function, absolute_import
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from matplotlib.ticker import AutoMinorLocator
import numpy as np

def main():

    plot_properties(c=[5,10,20,30,40,50,60])
    plot_relative_error(c=[5,10,20,30,40,50,60], dT=10)
    plot_relative_error(c=[5,10,20,30,40,50,60], dT=20)


def plot_properties(c):
    plt.rc('figure', figsize=(8, 4))
    plt.figure()
    gs = gridspec.GridSpec(2, 2)
    ax0 = plt.subplot(gs[0])
    ax1 = plt.subplot(gs[1])
    ax2 = plt.subplot(gs[2])
    ax3 = plt.subplot(gs[3])
    
    for i in range(len(c)):
        Tf = propyleneGlycol_FusionTemperature(c[i], 0)
        T = np.linspace(Tf, 100, num=200)
        # Density
        rho = np.array([propyleneGlycol_Density(c[i], T[j]) for j in range(len(T))])
        ax0.plot(T, rho, lw=1.5, label='c = {}%'.format(c[i]))
        # Heat Capacity
        cp = np.array([propyleneGlycol_HeatCapacity(c[i], T[j]) for j in range(len(T))])
        ax1.plot(T, cp, lw=1.5, label='c = {}%'.format(c[i]))
        # Density
        k = np.array([propyleneGlycol_ThermalConductivity(c[i], T[j]) for j in range(len(T))])
        ax2.plot(T, k, lw=1.5, label='c = {}%'.format(c[i]))
        # Density
        mu = np.array([propyleneGlycol_DynamicViscosity(c[i], T[j]) for j in range(len(T))])
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
    
    plt.savefig('PropyleneGlycolWaterProperties.png', dpi=100)
    plt.savefig('PropyleneGlycolWaterProperties.pdf', dpi=100)


def plot_relative_error(c, dT):
    plt.rc('figure', figsize=(8, 4))
    plt.figure()
    gs = gridspec.GridSpec(2, 2)
    ax0 = plt.subplot(gs[0])
    ax1 = plt.subplot(gs[1])
    ax2 = plt.subplot(gs[2])
    ax3 = plt.subplot(gs[3])
    
    for i in range(len(c)):
        Tf = propyleneGlycol_FusionTemperature(c[i], 0)
        T = np.linspace(Tf+dT, 100-dT, num=200)
        # Density
        rho = np.array([propyleneGlycol_Density(c[i], T[j]) for j in range(len(T))])
        rhop = np.array([propyleneGlycol_Density(c[i], min(T[j]+dT, 100)) for j in range(len(T))])
        rhom = np.array([propyleneGlycol_Density(c[i], max(T[j]-dT, Tf)) for j in range(len(T))])
        drho = np.maximum(np.abs((rhop-rho)/rho),np.abs((rhom-rho)/rho))
        ax0.plot(T, drho, lw=1.5, label='c = {}%'.format(c[i]))
        # Heat Capacity
        cp = np.array([propyleneGlycol_HeatCapacity(c[i], T[j]) for j in range(len(T))])
        cpp = np.array([propyleneGlycol_HeatCapacity(c[i], min(T[j]+dT, 100)) for j in range(len(T))])
        cpm = np.array([propyleneGlycol_HeatCapacity(c[i], max(T[j]-dT, Tf)) for j in range(len(T))])
        dcp = np.maximum(np.abs((cpp-cp)/cp),np.abs((cpm-cp)/cp))
        ax1.plot(T, dcp, lw=1.5, label='c = {}%'.format(c[i]))
        # Thermal Conductivity
        k = np.array([propyleneGlycol_ThermalConductivity(c[i], T[j]) for j in range(len(T))])
        kp = np.array([propyleneGlycol_ThermalConductivity(c[i], min(T[j]+dT, 100)) for j in range(len(T))])
        km = np.array([propyleneGlycol_ThermalConductivity(c[i], max(T[j]-dT, Tf)) for j in range(len(T))])
        dk = np.maximum(np.abs((kp-k)/k),np.abs((km-k)/k))
        ax2.plot(T, dk, lw=1.5, label='c = {}%'.format(c[i]))
        # Dynamic Viscosity
        mu = np.array([propyleneGlycol_DynamicViscosity(c[i], T[j]) for j in range(len(T))])
        mup = np.array([propyleneGlycol_DynamicViscosity(c[i], min(T[j]+dT, 100)) for j in range(len(T))])
        mum = np.array([propyleneGlycol_DynamicViscosity(c[i], max(T[j]-dT, Tf)) for j in range(len(T))])
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
    
    plt.savefig('PropyleneGlycolWaterError{}degC.png'.format(dT), dpi=100)
    plt.savefig('PropyleneGlycolWaterError{}degC.pdf'.format(dT), dpi=100)


def propyleneGlycol_FusionTemperature(c, T):
    xm = 30.7031
    ym = 32.7089
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [-1.325e1, -3.820e-5, 7.865e-7, -1.733e-9, -6.631e-1, 6.774e-6, -6.242e-8, -7.819e-10, -1.094e-2, 5.332e-8, -4.169e-9, 3.288e-11, -2.283e-4, -1.131e-8, 1.918e-10, -3.409e-6, 8.035e-11, 1.465e-8]
    Tf = polynomialProperty(c, T, xm, ym, nx, ny, coeff)
    return Tf


def propyleneGlycol_Density(c, T):
    xm = 30.7031
    ym = 32.7089
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [1.018e3, -5.406e-1, -2.666e-3, 1.347e-5, 7.604e-1, -9.450e-3, 5.541e-5, -1.343e-7, -2.498e-3, 2.700e-5, -4.018e-7, 3.376e-9, -1.550e-4, 2.829e-6, -7.175e-9, -1.131e-6, -2.221e-8, 2.342e-8]
    rho = polynomialProperty(c, T, xm, ym, nx, ny, coeff)
    return rho


def propyleneGlycol_HeatCapacity(c, T):
    xm = 30.7031
    ym = 32.7089
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [3.882e3, 2.699e0, -1.659e-3, -1.032e-5, -1.304e1, 5.070e-2, -4.752e-5, 1.522e-6, -1.598e-1, 9.534e-5, 1.167e-5, -4.870e-8, 3.539e-4, 3.102e-5, -2.950e-7, 5.000e-5, -7.135e-7, -4.959e-7]
    cp = polynomialProperty(c, T, xm, ym, nx, ny, coeff)
    return cp


def propyleneGlycol_ThermalConductivity(c, T):
    xm = 30.7031
    ym = 32.7089
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [4.513e-1, 7.955e-4, 3.482e-8, -5.966e-9, -4.795e-3, -1.678e-5, 8.941e-8, 1.493e-10, 2.076e-5, 1.563e-7, -4.615e-9, 9.897e-12, -9.083e-8, -2.518e-9, 6.543e-11, -5.952e-10, -3.605e-11, 2.104e-11]
    k = polynomialProperty(c, T, xm, ym, nx, ny, coeff)
    return k


def propyleneGlycol_DynamicViscosity(c, T):
    xm = 30.7031
    ym = 32.7089
    nx = 6
    ny = [4,4,4,3,2,1]
    coeff = [6.837e-1, -3.045e-2, 2.525e-4, -1.399e-6, 3.328e-2, -3.984e-4, 4.332e-6, -1.860e-8, 5.453e-5, -8.600e-8, -1.593e-8, -4.465e-11, -3.900e-6, 1.054e-7, -1.589e-9, -1.587e-8, 4.475e-10, 3.564e-9]
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
    