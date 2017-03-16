within Buildings.Utilities.Psychrometrics.Functions;
package Solver_Tsat_ph "Helper solver for Tsat_ph"
  extends Modelica.Media.Common.OneNonLinearEquation;

  function h_pT
    "Find saturation enthalpy given pressure and temperature"

    input Modelica.SIunits.Temperature T
      "The guess temperature";
    input f_nonlinear_Data data
      "Data containint the total pressure of the fluid";
    output Modelica.SIunits.SpecificEnthalpy h
      "The specific enthalpy of the fluid";

protected
      constant Integer watIdx = 1
        "Index of water in Buildings.Media.Air";
      constant Integer othIdx = 2
        "Index of other constituent of Buildings.Media.Air";
      constant Real phiSat(min=0,max=1) = 1
        "Relative humidity at saturation, 100%";
      Modelica.SIunits.Pressure pSat
        "Saturation pressure of the vapor";
      Modelica.SIunits.MassFraction X[2]
        "Mass fractions of components of Buildings.Media.Air at saturation";

  algorithm
      pSat := Buildings.Media.Air.saturationPressure(T);
      X[watIdx] := Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
        pSat=pSat, p=data.p, phi=phiSat);
      X[othIdx] := 1 - X[watIdx];
      h := Buildings.Media.Air.specificEnthalpy_pTX(p=data.p, T=T, X=X);
  end h_pT;

  redeclare record extends f_nonlinear_Data
    Modelica.SIunits.Pressure p "Total pressure of the fluid";
  end f_nonlinear_Data;

  redeclare function extends f_nonlinear
  algorithm
    y := h_pT(x, data=f_nonlinear_data);
  end f_nonlinear;
end Solver_Tsat_ph;
