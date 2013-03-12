within Buildings.HeatTransfer.Conduction.BaseClasses;
function temperature_u
  "Computes the temperature of a phase change material for a given specific internal energy"

  input Modelica.SIunits.SpecificInternalEnergy ud[:]
    "Support points for derivatives";
  input Modelica.SIunits.Temperature Td[:] "Support points for derivatives";
  input Real dT_du[:](each fixed=false, unit="kg.K2/J")
    "Derivatives dT/du at the support points";

  input Modelica.SIunits.SpecificInternalEnergy u "Specific internal energy";

  output Modelica.SIunits.Temperature T "Resulting temperature";
protected
  Integer i "Integer to select data interval";
algorithm
  // i is a counter that is used to pick the derivative
  // that corresponds to the interval that contains x
  i := 1;
  for j in 1:size(ud,1) - 1 loop
    if u > ud[j] then
      i := j;
    end if;
  end for;
  // Extrapolate or interpolate the data
  T :=  Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
     x=u,
     x1=ud[i],
     x2=ud[i + 1],
     y1=Td[i],
     y2=Td[i + 1],
     y1d=dT_du[i],
     y2d=dT_du[i + 1]);
  annotation(smoothOrder=1,
      Documentation(info="<html>
<p>
fixme: add documentation.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 9, 2013, by Michael Wetter:<br>
Revised implementation to use new data record.
</li>
<li>
January 19, 2013, by Armin Teskeredzic:<br>
First implementations.
</li>
</ul>
</html>"));
end temperature_u;
