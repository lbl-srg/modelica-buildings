within Buildings.Utilities.Psychrometrics.Functions.BaseClasses;
function der_TDewPoi_pW_amb "Derivative of function TDewPoi_pW_amb"
  extends
    Buildings.Utilities.Psychrometrics.Functions.BaseClasses.pW_TDewPoi_amb;

  input Modelica.SIunits.Pressure p_w "Water vapor partial pressure";
  input Real dp_w "Differential of water vapor partial pressure";
  output Real dT "Differential of dew point temperature";
algorithm
  dT := dp_w / a2 / p_w;

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
end der_TDewPoi_pW_amb;
