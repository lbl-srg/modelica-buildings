within Buildings.Utilities.Psychrometrics.Functions.Examples;
model X_pSatpphi "Model to test X_pSatpphi function"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);
  parameter Modelica.Units.SI.Temperature T=293.15 "Temperature";
  parameter Modelica.Units.SI.Pressure p=101325 "Pressure of the fluid";

  Modelica.Units.SI.AbsolutePressure pSat "Saturation pressure";
  Real phi(min=0, max=1) "Relative humidity";
  Modelica.Units.SI.MassFraction X_w(
    min=0,
    max=1,
    nominal=0.01) "Water vapor concentration per total mass of air";

  constant Real conv(unit="1/s") = 1 "Conversion factor";
equation
  phi = time*conv;
  pSat = Medium.saturationPressure(T);
  X_w = Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(pSat=pSat, p=p, phi=phi);

  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/Examples/X_pSatpphi.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example computes the water content of air for a relative humidity between
<i>0</i> and <i>100%</i>,
a temperature of <i>20&deg;C</i>
and atmospheric pressure.
</p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2014, by Michael Wetter:<br/>
Added conversion factor to avoid a unit error.
</li>
<li>
August 21, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end X_pSatpphi;
