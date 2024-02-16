within Buildings.Fluid.SolarCollectors.BaseClasses;
function IAM "Function for incident angle modifer"

  input Modelica.Units.SI.Angle incAng "Incident angle";
  input Real b0(final min=0, final max=1, final unit="1") "1st incident angle modifer coefficient";
  input Real b1(final min=0, final max=1, final unit="1") "2nd incident angle modifer coefficient";
  output Real incAngMod "Incident angle modifier coefficient";
protected
  constant Modelica.Units.SI.Angle incAngMin=Modelica.Constants.pi/2 - 0.1
    "Minimum incidence angle to avoid division by zero";
  constant Real delta = 0.0001 "Width of the smoothing function";
  constant Real cosIncAngMin = Modelica.Math.cos(incAngMin) "Cosine of minimum incidence angle";
  Real k = 1/Buildings.Utilities.Math.Functions.smoothMax(Modelica.Math.cos(incAng),
         cosIncAngMin, delta) - 1
         "Term 1/cos(theta)-1 with regularization to avoid division by zero";
algorithm
  // E+ Equ (555), except that we do no longer set incAngMod to zero
  // at incidence angle larger than 60, see
  // https://github.com/lbl-srg/modelica-buildings/issues/785

  incAngMod :=
  Buildings.Utilities.Math.Functions.smoothLimit(
    x = (1 + b0*k + b1*k^2),
    l = 0,
    u = 1,
    deltaX = delta);

  annotation (
  smoothOrder=1,
    Documentation(info="<html>
<h4>Overview</h4>
<p>
This function computes the incidence angle modifier for solar insolation
striking the surface of the solar thermal collector.
It is calculated using Eq 18.298 in the EnergyPlus 23.2.0 Engineering Reference.
</p>

<h4>References</h4>
<p>
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v23.2.0/EngineeringReference.pdf\">
EnergyPlus 23.2.0 Engineering Reference</a>
</p>
</html>", revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
May 31, 2017, by Michael Wetter and Filip Jorissen:<br/>
Change limits for incident angle modifier to avoid dip in temperature
at shallow incidence angles.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/785\">issue 785</a>.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
Added missing <code>protected</code> keyword.
</li>
<li>
May 22, 2012, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end IAM;
