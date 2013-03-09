within Districts.Utilities.Psychrometrics.Functions.Examples;
model X_pSatpphi "Model to test X_pSatpphi function"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.PerfectGases.MoistAir "Medium model"
           annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Temperature T = 293.15 "Temperature";
  Modelica.SIunits.AbsolutePressure pSat "Saturation pressure";
  parameter Modelica.SIunits.Pressure p = 101325 "Pressure of the fluid";
  Real phi(min=0, max=1) "Relative humidity";
  Modelica.SIunits.MassFraction X_w(
    min=0,
    max=1,
    nominal=0.01) "Water vapor concentration per total mass of air";

  constant Real conv(unit="1/s") = 1 "Conversion factor";
equation
  phi = time;
  pSat = Medium.saturationPressure(T);
  X_w = Districts.Utilities.Psychrometrics.Functions.X_pSatpphi(pSat=pSat, p=p, phi=phi);

  annotation (__Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/Examples/X_pSatpphi.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example computes the water content of air for a relative humidity between
<i>0</i> and <i>100%</i>,
a temperature of <i>20&circ;C</i>
and atmospheric pressure.
</p>
</html>", revisions="<html>
<ul>
<li>
August 21, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end X_pSatpphi;
