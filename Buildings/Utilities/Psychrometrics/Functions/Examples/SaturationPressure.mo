within Buildings.Utilities.Psychrometrics.Functions.Examples;
model SaturationPressure "Model to test the saturationPressure function"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Temperature TMin=190 "Temperature";
  parameter Modelica.Units.SI.Temperature TMax=373.16 "Temperature";
  Modelica.Units.SI.Temperature T "Temperature";
  Modelica.Units.SI.AbsolutePressure pSat "Saturation pressure";
  constant Real conv(unit="1/s") = 1 "Conversion factor";
equation
  T = TMin + conv*time * (TMax-TMin);
  pSat = Buildings.Utilities.Psychrometrics.Functions.saturationPressure(T);
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/Examples/SaturationPressure.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example computes the saturation pressure of water.
</p>
</html>", revisions="<html>
<ul>
<li>
April 22, 2016, by Michael Wetter:<br/>
Corrected script name to use capital letter.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/510\">Buildings, issue 510</a>.
</li>
<li>
November 20, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SaturationPressure;
