within Buildings.Fluid.HeatExchangers.BaseClasses;
function lmtd "Log-mean temperature difference"
  input Modelica.Units.SI.Temperature T_a1 "Temperature at port a1";
  input Modelica.Units.SI.Temperature T_b1 "Temperature at port b1";
  input Modelica.Units.SI.Temperature T_a2 "Temperature at port a2";
  input Modelica.Units.SI.Temperature T_b2 "Temperature at port b2";
  output Modelica.Units.SI.TemperatureDifference lmtd
    "Log-mean temperature difference";
protected
  Modelica.Units.SI.TemperatureDifference dT1 "Temperature difference side 1";
  Modelica.Units.SI.TemperatureDifference dT2 "Temperature difference side 2";
algorithm
  dT1 :=T_a1 - T_b2;
  dT2 :=T_b1 - T_a2;
  lmtd :=(dT2 - dT1)/Modelica.Math.log(dT2/dT1);
annotation (preferredView="info",
Documentation(info="<html>
<p>
This function computes the log mean temperature difference of a heat exchanger.
</p>
<p>
Note that the implementation requires the temperature differences <i>T<sub>a1</sub> - T<sub>b2</sub></i> and
<i>T<sub>b1</sub> - T<sub>a2</sub></i> to be not equal to each other.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 30, 2020, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2268\">Buildings, #2268</a>.
</li>
<li>
May 28, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end lmtd;
