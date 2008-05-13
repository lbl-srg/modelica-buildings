model MoistAirComparison 
  
   annotation(Diagram, Commands(file="MoistAirComparison.mos" "run"));
    annotation (
      Documentation(info="<html>
<p>
This example compares the perfect medium model
<a href=\"Modelica://Buildings.Fluids.Media.PerfectGases.MoistAir\">Buildings.Fluids.Media.PerfectGases.MoistAir</a>
 with the ideal gas model
from <a href=\"Modelica://Modelica.Media.Air.MoistAir\">Modelica.Media.Air.MoistAir</a>
</p>
</html>",   revisions="<html>
<ul>
<li>
May 12, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
   package PerfectMedium = Buildings.Fluids.Media.PerfectGases.MoistAir;
   package IdealMedium =   Modelica.Media.Air.MoistAir;
  
    Modelica.SIunits.SpecificEnthalpy hLiqPer "Liquid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hLiqIde "Liquid phase enthalpy";
    Modelica.SIunits.SpecificEnthalpy hStePer "Water vapor enthalpy";
    Modelica.SIunits.SpecificEnthalpy hSteIde "Water vapor enthalpy";
    Modelica.SIunits.SpecificEnthalpy hAirPer "Air enthalpy";
    Modelica.SIunits.SpecificEnthalpy hAirIde "Air enthalpy";
  
    Modelica.SIunits.SpecificEnthalpy hMixPer "Mixture specific enthalpy";
    Modelica.SIunits.SpecificEnthalpy hMixIde "Mixture specific enthalpy";
  
    Modelica.SIunits.MassFraction X[2] = {0.01, 0.09};
    Modelica.SIunits.Temperature T "Temperature";
    Modelica.SIunits.CelsiusTemperature T_degC "Temperature";
  
    Real errLiq "Error liquid phase";
    Real errSte "Error steam phase";
    Real errAir "Error gas mixture";
    Real errMix "Error gas mixture";
    Real errT 
    "Error in temperature when enthalpy-temperature relation is inverted";
  
    parameter Modelica.SIunits.Pressure P = 101325 "Pressure";
  
equation 
    T_degC = 100*time;
    T = 273.15 + T_degC;
    hLiqPer=PerfectMedium.enthalpyOfLiquid(T);
    hStePer=PerfectMedium.enthalpyOfCondensingGas(T);
    hAirPer=PerfectMedium.enthalpyOfGas(T, X);
    hLiqIde=IdealMedium.enthalpyOfLiquid(T);
    hSteIde=IdealMedium.enthalpyOfCondensingGas(T);
    hAirIde=IdealMedium.enthalpyOfGas(T, X);
  
    hMixPer=PerfectMedium.h_pTX(P, T, X);
    hMixIde=IdealMedium.h_pTX(P, T, X);
  
    errLiq * hLiqIde = hLiqIde - hLiqPer;
    errSte * hSteIde = hSteIde - hStePer;
    errAir * hAirIde = hAirIde - hAirPer;
    errMix * hMixIde = hMixIde - hMixPer;
  
    assert( abs(errLiq) < 0.09, "Error too large. Check medium model.");
    assert( abs(errSte) < 0.01, "Error too large. Check medium model.");
    assert( abs(errAir) < 0.01, "Error too large. Check medium model.");
    assert( abs(errMix) < 0.01, "Error too large. Check medium model.");
  
    errT * T = T - PerfectMedium.T_phX(P, PerfectMedium.h_pTX(P, T, X), X);
    assert( abs(errT) < 0.01, "Error too large. Check medium model.");
  
end MoistAirComparison;
