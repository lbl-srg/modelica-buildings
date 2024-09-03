within Buildings.Utilities.Psychrometrics.Functions.BaseClasses;
function der_TDewPoi_pW_amb "Derivative of function TDewPoi_pW_amb"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Pressure p_w "Water vapor partial pressure";
  input Real dp_w "Differential of water vapor partial pressure";
  output Real dT "Differential of dew point temperature";

protected
  constant Modelica.Units.SI.Temperature T1=283.15 "First support point";
  constant Modelica.Units.SI.Temperature T2=293.15 "Second support point";
  constant Modelica.Units.SI.Pressure p1=1227.97 "First support point";
  constant Modelica.Units.SI.Pressure p2=2338.76 "Second support point";

  constant Real a1=(Modelica.Math.log(p2) - Modelica.Math.log(p1)*T2/T1)/(1 -
      T2/T1);
  constant Real a2(unit="1/K")=(Modelica.Math.log(p1) - a1)/T1;
algorithm
  dT := dp_w / (a2*p_w);

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
end der_TDewPoi_pW_amb;
