within Buildings.Fluid.SolarCollectors.BaseClasses;
function IAM "Function for incident angle modifer"
  input Modelica.SIunits.Angle incAng "Incident angle";
  input Real B0 "1st incident angle modifer coefficient";
  input Real B1 "2nd incident angle modifer coefficient";
  output Real incAngMod "Incident angle modifier coefficient";
  parameter Modelica.SIunits.Angle incAngMin = Modelica.Constants.pi / 2 -0.1
    "Minimum incidence angle to avoid /0";
  parameter Real delta = 0.0001 "Width of the smoothing function";
algorithm
  // E+ Equ (555)
  incAngMod := 1 + B0*(1/Buildings.Utilities.Math.Functions.smoothMax(Modelica.Math.cos(incAng), Modelica.Math.cos(incAngMin), delta) - 1) + B1*(1/Buildings.Utilities.Math.Functions.smoothMax(Modelica.Math.cos(incAng), Modelica.Math.cos(incAngMin), delta) - 1)^2;

  annotation (
    Documentation(info="<html>
<h4>Overview</h4>
<p>
This function computes the coefficient for incident angle modifier for the off-normal angle. It applies a quadratic correlation to calculate the coefficient. 
The parameters B0 and B1 are listed in the Directory of SRCC (Solar Rating and Certification Corporation) Certified Solar Collector Ratings.
Note: If the angle is larger than 60 degree, the output is 0. 
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0.0 Engineering Reference</a>, October 13, 2011.
</p>
</html>", revisions="<html>
<ul>
<li>
May 22, 2012, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(graphics),
    Icon(graphics));
end IAM;
