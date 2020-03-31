within Buildings.Utilities.Psychrometrics.Functions.BaseClasses;
function der_pW_TDewPoi_amb "Derivative of function pW_TDewPoi_amb"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature T "Dew point temperature";
  input Real dT;
  output Real dp_w "Differential of water vapor partial pressure";
protected
  constant Modelica.Units.SI.Temperature T1=283.15 "First support point";
  constant Modelica.Units.SI.Temperature T2=293.15 "Second support point";
  constant Modelica.Units.SI.Pressure p1=1227.97 "First support point";
  constant Modelica.Units.SI.Pressure p2=2338.76 "Second support point";

  constant Real a1=(Modelica.Math.log(p2) - Modelica.Math.log(p1)*T2/T1)/(1 -
      T2/T1);
  constant Real a2(unit="1/K")=(Modelica.Math.log(p1) - a1)/T1;

algorithm
  dp_w:=a2*Modelica.Math.exp(a1 + a2*T)*dT;

  annotation (
    Documentation(info="<html>
<p>
Derivative of dew point temperature calculation for moist air.
</p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2014, by Michael Wetter:<br/>
Removed <code>extends Buildings.Utilities.Psychrometrics.Functions.BaseClasses.pW_TDewPoi_amb</code>
as this gives a compile time error in OpenModelica as the input argument <code>T</code>
cannot be found.
</li>
<li>
May 21, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_pW_TDewPoi_amb;
