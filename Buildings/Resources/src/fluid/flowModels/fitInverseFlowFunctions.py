#!/usr/bin/env python3
"""Fit the starting values of the inverse flow functions in
IBPSA.Fluid.BaseClasses.FlowModels and report their accuracy.

In normalised variables, the laminar branches of the flow functions are odd
polynomials x -> y = x*(A + B*x^2 + C*x^4) on [-1, 1]. Their inverses start
from a rational function in t = y^2 and refine it with Halley steps:

  basicFlowFunction_m_flow_inv  rational (4,4), then 1 Halley step
  basicFlowFunction_dp_inv      rational (3,3), then 1 Halley step
  powerLaw_m_flow_inv           rational (1,1) whose coefficients are
                                quadratic in n-1, then 2 Halley steps
  powerLaw_dp_inv               closed-form rational (1,1), then 2 Halley steps

The coefficients minimise the maximum error, approximated by a least-squares
fit followed by L^p refinements with increasing p.

Usage: python3 fitInverseFlowFunctions.py
Requires numpy and scipy. The reference inverses use long double.
"""
import numpy as np
from scipy.optimize import least_squares

LD = np.longdouble


def coefficients(e):
    """Coefficients A, B, C of the laminar polynomial of the power law with
    exponent e. e=2 and e=1/2 give basicFlowFunction_m_flow and _dp."""
    return (e - 3)*(e - 5)/8, (e - 1)*(5 - e)/4, (e - 1)*(e - 3)/8


def poly(x, e):
    A, B, C = coefficients(e)
    return x*(A + x*x*(B + x*x*C))


def poly_der(x, e):
    A, B, C = coefficients(e)
    return A + x*x*(3*B + 5*C*x*x)


def poly_der2(x, e):
    A, B, C = coefficients(e)
    return x*(6*B + 20*C*x*x)


def exact_inverse(y, e):
    """Inverse of poly on [0, 1] by bisection and Newton in long double."""
    y = np.asarray(y, dtype=LD)
    e = np.asarray(e, dtype=LD)
    lo = np.zeros_like(y)
    hi = np.ones_like(y)
    for _ in range(64):
        mid = (lo + hi)/2
        below = poly(mid, e) < y
        lo = np.where(below, mid, lo)
        hi = np.where(below, hi, mid)
    x = (lo + hi)/2
    for _ in range(3):
        x -= (poly(x, e) - y)/poly_der(x, e)
    return x


def halley(x, y, e):
    F = poly(x, e) - y
    F1 = poly_der(x, e)
    return x - 2*F*F1/(2*F1*F1 - F*poly_der2(x, e))


def rational(c, t, n):
    p = c[:n + 1]
    q = np.r_[1.0, c[n + 1:]]
    return np.polyval(p[::-1], t)/np.polyval(q[::-1], t)


def fit_fixed(e, n):
    """Rational (n,n) start for a fixed exponent, fitted to the absolute
    error of x = y*R(y^2)."""
    y = np.linspace(0, 1, 20001)
    x = y.copy()
    for _ in range(60):
        x = x - (poly(x, e) - y)/poly_der(x, e)
    y, x = y[1:], x[1:]
    t = y*y
    h = x/y
    w = np.ones_like(t)
    for _ in range(30):
        M = np.hstack([np.stack([t**i for i in range(n + 1)], 1),
                       -np.stack([h*t**j for j in range(1, n + 1)], 1)])/w[:, None]
        c, *_ = np.linalg.lstsq(M, h/w, rcond=None)
        w = np.polyval(np.r_[1.0, c[n + 1:]][::-1], t)
    for pw in (4, 8, 16, 32, 64):
        res = lambda c: np.abs(y*rational(c, t, n) - x)**(pw/2)*1e3**(pw/2)
        c = least_squares(res, c, xtol=1e-15, ftol=1e-15, gtol=1e-15, max_nfev=20000).x
    return c


def start_power_law(c, y, e):
    """Fitted start for powerLaw_m_flow_inv: c holds p0, p1, q1 as quadratics in s = e - 1."""
    s = e - 1
    p0, p1, q1 = (r[0] + s*(r[1] + s*r[2]) for r in c.reshape(3, 3))
    t = y*y
    return y*(p0 + p1*t)/(1 + q1*t)


def fit_power_law():
    """Start for exponents e in [1, 2], fitted to the relative error."""
    E, Y = np.meshgrid(np.linspace(1, 2, 41),
                       np.r_[np.logspace(-8, -1.5, 25), np.linspace(0.03, 1, 120)])
    E, Y = E.ravel(), Y.ravel()
    S, T = E - 1, Y*Y
    G = (exact_inverse(Y, E)/Y).astype(float)
    basis = [S**j for j in range(3)]
    w = np.ones_like(G)
    for _ in range(20):
        M = np.array(basis + [T*b for b in basis] + [-G*T*b for b in basis]).T/(G*w)[:, None]
        c, *_ = np.linalg.lstsq(M, 1/w, rcond=None)
        w = 1 + T*(c[6] + S*(c[7] + S*c[8]))
    for pw in (4, 8, 16, 32, 64):
        res = lambda c: np.abs(start_power_law(c, Y, E)/(G*Y) - 1)**(pw/2)*10**(pw/2)
        c = least_squares(res, c, xtol=1e-15, ftol=1e-15, gtol=1e-15, max_nfev=3000).x
    return c


def start_closed_form(y, e):
    """Start for powerLaw_dp_inv: the (1,1) rational in t = y^2 with the slope
    of the inverse at y=0 and its value and slope at y=1."""
    t = y*y
    return y*(8 + 2*(7*e - e*e - 4)*t)/((e - 3)*(e - 5) + (22*e - 3*e*e - 15)*t)


def report(name, start, exponents, steps):
    y = np.r_[np.logspace(-12, 0, 600), np.linspace(0, 1, 8001)[1:]]
    errors = np.zeros(steps + 1)
    for e in exponents:
        r = exact_inverse(y, e)
        x = start(y, e)
        for k in range(steps + 1):
            errors[k] = max(errors[k], float(np.max(np.abs(x/r - 1))))
            x = halley(x, y, e)
    print(f"{name}: largest relative error of the start {errors[0]:.2e}, "
          + ", ".join(f"after {k} Halley step{'s' if k > 1 else ''} {errors[k]:.2e}"
                      for k in range(1, steps + 1)))


def modelica(c):
    return ", ".join(repr(float(v)) for v in c)


if __name__ == "__main__":
    c_m_flow = fit_fixed(2.0, 4)
    c_dp = fit_fixed(0.5, 3)
    c_pl = fit_power_law()
    print("basicFlowFunction_m_flow_inv, numerator then denominator (constant term 1 omitted):")
    print("  " + modelica(c_m_flow))
    print("basicFlowFunction_dp_inv, numerator then denominator (constant term 1 omitted):")
    print("  " + modelica(c_dp))
    print("powerLaw_m_flow_inv, rows p0, p1, q1, each as coefficients of 1, s, s^2 with s = n - 1:")
    for r in c_pl.reshape(3, 3):
        print("  " + modelica(r))
    print()
    report("basicFlowFunction_m_flow_inv", lambda y, e: y*rational(c_m_flow, y*y, 4), [2.0], 1)
    report("basicFlowFunction_dp_inv", lambda y, e: y*rational(c_dp, y*y, 3), [0.5], 1)
    report("powerLaw_m_flow_inv, n in [1, 2]",
           lambda y, e: start_power_law(c_pl, y, e), np.linspace(1, 2, 41), 2)
    report("powerLaw_dp_inv, m = 1/n in [0.5, 1]", start_closed_form, np.linspace(0.5, 1, 26), 2)
