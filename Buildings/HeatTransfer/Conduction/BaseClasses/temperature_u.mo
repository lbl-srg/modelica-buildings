within Buildings.HeatTransfer.Conduction.BaseClasses;
function temperature_u
  "Computes the temperature of a phase change material for a given specific internal energy"

  input Modelica.Units.SI.SpecificInternalEnergy ud[Buildings.HeatTransfer.Conduction.nSupPCM]
    "Support points for derivatives";
  input Modelica.Units.SI.Temperature Td[Buildings.HeatTransfer.Conduction.nSupPCM]
    "Support points for derivatives";
  input Real dT_du[:](each fixed=false, each unit="kg.K2/J")
    "Derivatives dT/du at the support points";

  input Modelica.Units.SI.SpecificInternalEnergy u "Specific internal energy";

  output Modelica.Units.SI.Temperature T "Resulting temperature";
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
This function computes for a given specific internal energy <i>u</i>
the temperature <i>T(u)</i>, using a cubic hermite spline approximation to the
temperature vs. specific internal energy relation.
Input to the function are the derivatives <i>dT/du</i> at the support points.
These derivatives can be computed using
<a href=\"modelica://Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u\">
Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u</a>.
</p>
<h4>Implementation</h4>
<p>
The derivatives <i>dT/du</i> are an input to this function because they typically only need
to be computed once, whereas <i>T(u)</i> must be evaluated at each time step.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 9, 2013, by Michael Wetter:<br/>
Revised implementation to use new data record.
</li>
<li>
January 19, 2013, by Armin Teskeredzic:<br/>
First implementations.
</li>
</ul>
</html>"));
end temperature_u;
