within Buildings.Utilities.Psychrometrics.Functions;
function pW_TDewPoi_amb
  "Function to compute the water vapor partial pressure for a given dew point temperature of moist air"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Temperature T "Dew point temperature";
  output Modelica.Units.SI.Pressure p_w(displayUnit="Pa", min=100)
    "Water vapor partial pressure";
protected
  constant Modelica.Units.SI.Temperature T1=283.15 "First support point";
  constant Modelica.Units.SI.Temperature T2=293.15 "Second support point";
  constant Modelica.Units.SI.Pressure p1=1227.97 "First support point";
  constant Modelica.Units.SI.Pressure p2=2338.76 "Second support point";

  constant Real a1=(Modelica.Math.log(p2) - Modelica.Math.log(p1)*T2/T1)/(1 -
      T2/T1);
  constant Real a2(unit="1/K")=(Modelica.Math.log(p1) - a1)/T1;

algorithm
  p_w := Modelica.Math.exp(a1 + a2*T);
  annotation (
    inverse(T=TDewPoi_pW_amb(p_w)),
    smoothOrder=99,
    Inline=true,
    derivative=BaseClasses.der_pW_TDewPoi_amb,
    Documentation(info="<html>
<p>
Dew point temperature calculation for moist air between <i>0 degC</i> and <i>30 degC</i>.
</p>
<p>
The correlation used in this model is valid for dew point temperatures between
<i>0</i>&deg;C and <i>30</i>&deg;C. It is an approximation to the correlation from 2005
ASHRAE Handbook, p. 6.2, which is valid in a wider range of temperatures and implemented
in
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi\">
Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi</a>.
The approximation error of this simplified function is below 5% for a
temperature of <i>0</i>&deg;C to <i>30</i>&deg;C.
The benefit of this simpler function is that it can be inverted analytically,
whereas the other function requires a numerical solution.
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
March 9, 2012 by Michael Wetter:<br/>
Added <code>smoothOrder=99</code> and <code>displayUnit</code> for pressure.
</li>
<li>
May 21, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end pW_TDewPoi_amb;
