within Buildings.HeatTransfer.Convection.Functions;
function windDirectionModifier
  "Wind direction modifier that is used to compute the wind-driven convective heat transfer coefficient"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.Angle azi "Surface azimuth";
  input Modelica.SIunits.Angle dir(min=0, max=2*Modelica.Constants.pi)
    "Wind direction (0=wind from North)";
  output Real W "Wind direction modifier";
protected
  constant Modelica.SIunits.Angle lee = Modelica.SIunits.Conversions.from_deg(100)
    "Angle at which the transition occurs";
  constant Real cosLee = Modelica.Math.cos(lee)
    "Cosine of the angle at which the transition occurs";
algorithm
// The wind direction is defined in TMY3 as dir=0 if from North, and 0 <= dir < 2*pi
// Hence, we subtract pi to redefine dir=0 as wind coming from the south.
// This simplifies the implementation since a surface azimuth is defined as azi=0
// if the surface is south-facing
  W:=Buildings.Utilities.Math.Functions.spliceFunction(
    pos=0.5,
    neg=1,
    x=cosLee-Modelica.Math.cos(azi+Modelica.Constants.pi-dir),
    deltax=0.05);
    annotation (
smoothOrder=1,
Documentation(info="<html>
<p>
Function that outputs <i>1</i> if the incidence angle is below 100 degrees, and
<i>0.5</i> otherwise.
The implementation is once continuously differentiable in its input arguments.
</p>
<p>
See
<a href=\"modelica://Buildings.HeatTransfer.Convection.Exterior\">
Buildings.HeatTransfer.Convection.Exterior</a>
for an example that uses this function.
</p>
</html>", revisions="<html>
<ul>
<li>
March 30, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end windDirectionModifier;
