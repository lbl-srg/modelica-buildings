within Buildings.Obsolete.Media.PerfectGases.Examples;
model MoistAirComparison
  extends Modelica.Icons.Example;

   package PerfectMedium = Buildings.Obsolete.Media.PerfectGases.MoistAir;
   //package IdealMedium =   Modelica.Media.Air.MoistAir;
   package IdealMedium =   Buildings.Obsolete.Media.GasesConstantDensity.MoistAir;

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
    Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC
    "Temperature";

    Real errLiq "Error liquid phase";
    Real errSte "Error steam phase";
    Real errAir "Error gas mixture";
    Real errMix "Error gas mixture";
    Real errT
    "Error in temperature when enthalpy-temperature relation is inverted";

    parameter Modelica.SIunits.Pressure P = 101325 "Pressure";

equation
    T_degC = 1+99*time; // exclude 0, to avoid large relative error
    T = 273.15 + T_degC;
    hLiqPer=PerfectMedium.enthalpyOfLiquid(T);
    hStePer=PerfectMedium.enthalpyOfCondensingGas(T);
    hAirPer=PerfectMedium.enthalpyOfGas(T, X);
    hLiqIde=IdealMedium.enthalpyOfLiquid(T);
    hSteIde=IdealMedium.enthalpyOfCondensingGas(T);
    hAirIde=IdealMedium.enthalpyOfGas(T, X);

    hMixPer=PerfectMedium.h_pTX(P, T, X);
    hMixIde=IdealMedium.h_pTX(P, T, X);

    errLiq * abs(hLiqIde+1E-3) = hLiqIde - hLiqPer;
    errSte * abs(hSteIde+1E-3) = hSteIde - hStePer;
    errAir * abs(hAirIde+1E-3) = hAirIde - hAirPer;
    errMix * abs(hMixIde+1E-3) = hMixIde - hMixPer;
    errT * T = T - PerfectMedium.T_phX(P, PerfectMedium.h_pTX(P, T, X), X);

    assert( abs(errLiq) < 0.09, "Error too large. Check medium model.");
    assert( abs(errSte) < 0.01, "Error too large. Check medium model.");
    assert( abs(errAir) < 0.01, "Error too large. Check medium model.");
    assert( abs(errMix) < 2.01, "Error too large. Check medium model.");
    assert( abs(errT) < 0.01, "Error too large. Check medium model.");

   annotation(experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Media/PerfectGases/Examples/MoistAirComparison.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example compares the perfect medium model
<a href=\"modelica://Buildings.Obsolete.Media.PerfectGases.MoistAir\">Buildings.Obsolete.Media.PerfectGases.MoistAir</a>
 with the ideal gas model
from <a href=\"modelica://Modelica.Media.Air.MoistAir\">Modelica.Media.Air.MoistAir</a>
</p>
</html>",   revisions="<html>
<ul>
<li>
April 1, 2013, by Michael Wetter:<br/>
Changed <code>IdealMedium</code> from <code>Modelica.Media.Air.MoistAir</code>
to <code>Buildings.Obsolete.Media.GasesConstantDensity.MoistAir</code> as the old declaration
leads to an error if the model is checked in pedantic mode in Dymola 2014.
</li>
<li>
May 12, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistAirComparison;
