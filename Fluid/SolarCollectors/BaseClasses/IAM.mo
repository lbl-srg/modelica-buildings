within Buildings.Fluid.SolarCollectors.BaseClasses;
function IAM "Function for incident angle modifer"

  input Modelica.SIunits.Angle incAng "Incident angle";
  input Real B0 "1st incident angle modifer coefficient";
  input Real B1 "2nd incident angle modifer coefficient";
  output Real incAngMod "Incident angle modifier coefficient";
  parameter Modelica.SIunits.Angle incAngMin = Modelica.Constants.pi / 2 -0.1
    "Minimum incidence angle to avoid divison by zero";
  parameter Real cosIncAngMin(min=Modelica.Constants.eps)=
  Modelica.Math.cos(incAngMin) "Cosine of minimum incidence angle";
  parameter Real delta = 0.0001 "Width of the smoothing function";

algorithm
  // E+ Equ (555)

  incAngMod :=
  Buildings.Utilities.Math.Functions.smoothHeaviside(
  Modelica.Constants.pi/3-incAng, delta)*
  (1 + B0*(1/Buildings.Utilities.Math.Functions.smoothMax(
  Modelica.Math.cos(incAng), Modelica.Math.cos(incAngMin), delta) - 1) +
  B1*(1/Buildings.Utilities.Math.Functions.smoothMax(Modelica.Math.cos(incAng),
  cosIncAngMin, delta) - 1)^2);

  annotation (
  smoothOrder=1,
    Documentation(info="<html>
<h4>Overview</h4>
<p>
This function computes the incidence angle modifier for solar insolation 
striking the surface of the solar thermal collector. It is calculated using 
Eq 555 in the EnergyPlus 7.0.0 Engineering Reference.
</p>
<h4>Notice</h4>
<p>
As stated in EnergyPlus7.0.0 the incidence angle equation performs poorly 
at angles greater than 60 degrees. This model outputs 0 whenever the incidence
angle is greater than 60 degrees.
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, 
October 13, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
May 22, 2012, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end IAM;
