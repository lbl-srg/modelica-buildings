within Districts.Utilities.Psychrometrics.Functions.BaseClasses;
partial function pW_TDewPoi_amb
  "Partial function to compute the water vapor partial pressure for a given dew point temperature of moist air and its inverse"

protected
  constant Modelica.SIunits.Temperature T1=283.15 "First support point";
  constant Modelica.SIunits.Temperature T2=293.15 "Second support point";
  constant Modelica.SIunits.Pressure p1=1227.97 "First support point";
  constant Modelica.SIunits.Pressure p2=2338.76 "Second support point";

  constant Real a1=(Modelica.Math.log(p2) - Modelica.Math.log(p1)*T2/T1)/(1 -
      T2/T1);
  constant Real a2(unit="1/K")=(Modelica.Math.log(p1) - a1)/T1;

  annotation (
    Documentation(info="<html>
<p>
Partial function to compute the dew point temperature for moist air between <i>0 degC</i> and <i>30 degC</i>,
and for its inverse function.
</p>
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
end pW_TDewPoi_amb;
