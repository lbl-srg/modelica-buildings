within Buildings.Fluid.HeatExchangers.BaseClasses;
function lmtd "Log-mean temperature difference"
  input Modelica.SIunits.Temperature T_a1 "Temperature at port a1";
  input Modelica.SIunits.Temperature T_b1 "Temperature at port b1";
  input Modelica.SIunits.Temperature T_a2 "Temperature at port a2";
  input Modelica.SIunits.Temperature T_b2 "Temperature at port b2";
  output Modelica.SIunits.TemperatureDifference lmtd
    "Log-mean temperature difference";
protected
  Modelica.SIunits.TemperatureDifference dT1 "Temperature difference side 1";
  Modelica.SIunits.TemperatureDifference dT2 "Temperature difference side 2";
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
Note that the implementation requires the temperature differences to be non-zero.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 28, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end lmtd;
