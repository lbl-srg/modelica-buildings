within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model DryWetCalcsSweep
  "Creates a plot of using the DryWetCalcs over a range of input relative humidity"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.Examples.DryWetCalcs(
    wAirInExp(y = wAirIn * R),
    hAirInExp(y = Medium_A.specificEnthalpy_pTX(
      p = pAir,
      T = TAirIn,
      X = {wAirIn * R, 1 - (wAirIn * R)})));
  Real R
    "Parameter to adjust wAirIn with time";
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi TWetBul_TDryBulXi(
    redeclare package Medium = Medium_A,
    TDryBul = TAirIn,
    p = pAir,
    Xi = {wAirIn * R})
    "Utility to calculate the wet bulb temperature";
  Modelica.SIunits.Temperature TWetBul
    "The wet bulb temperature";

equation
  R = time / 10;
  TWetBul = TWetBul_TDryBulXi.TWetBul;
  annotation (
    experiment(StopTime=20),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/DryWetCalcsSweep.mos"
      "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>"));
end DryWetCalcsSweep;
