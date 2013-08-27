within Districts.Utilities.Psychrometrics.Functions.BaseClasses;
function der_pW_TDewPoi_amb "Derivative of function pW_TDewPoi_amb"
  extends
    Districts.Utilities.Psychrometrics.Functions.BaseClasses.pW_TDewPoi_amb;
  input Modelica.SIunits.Temperature T "Dew point temperature";
  input Real dT;
  output Real dp_w "Differential of water vapor partial pressure";
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
May 21, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end der_pW_TDewPoi_amb;
