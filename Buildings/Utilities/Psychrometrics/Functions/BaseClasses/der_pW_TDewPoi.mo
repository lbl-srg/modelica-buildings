within Buildings.Utilities.Psychrometrics.Functions.BaseClasses;
function der_pW_TDewPoi "Derivative of function pW_TDewPoi"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature T "Dew point temperature";
  input Real dT "Temperature differential";
  output Real dp_w "Differential of water vapor partial pressure";
protected
  constant Real C8=-5.800226E3;
  constant Real C9=1.3914993E0;
  constant Real C10=-4.8640239E-2;
  constant Real C11=4.1764768E-5;
  constant Real C12=-1.4452093E-8;
  constant Real C13=6.5459673E0;
algorithm
  dp_w := Modelica.Math.exp(C8/T + C9 + T*(C10 + T*(C11 + T*C12)) + C13*
    Modelica.Math.log(T))*(-C8/T/T + C10 + 2*C11*T + 3*C12*T*T + C13/T)*dT;
  annotation (
    Documentation(info="<html>
<p>
Derivative of dew point temperature calculation for moist air above freezing temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
April 15, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_pW_TDewPoi;
