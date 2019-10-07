within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function infiniteLineSource
  "Infinite line source model for borehole heat exchangers"
  extends Modelica.Icons.Function;

  input Real t "Time";
  input Real aSoi "Ground thermal diffusivity";
  input Real dis "Radial distance between borehole axes";

  output Real h_ils "Thermal response factor of borehole 1 on borehole 2";

algorithm
  h_ils := if t > 0.0 then
              Buildings.Utilities.Math.Functions.exponentialIntegralE1(dis^2/(4*aSoi*t))
           else
              0.0;
annotation (
Inline=true,
Documentation(info="<html>
<p>
This function evaluates the infinite line source solution. This solution gives
the relation between the constant heat transfer rate (per unit length) injected
by a line heat source of infinite length and the temperature raise in the
medium. The infinite line source solution is defined by
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/InfiniteLineSource_01.png\" />
</p>
<p>
where <i>&Delta;T(t,r)</i> is the temperature raise after a time <i>t</i> of
constant heat injection and at a distance <i>r</i> from the line source,
<i>Q'</i> is the heat injection rate per unit length, <i>k<sub>s</sub></i> is
the soil thermal conductivity and <i>h<sub>ILS</sub></i> is the infinite line
source solution.
</p>
<p>
The infinite line source solution is given by the exponential integral
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/InfiniteLineSource_02.png\" />
</p>
<p>
where <i>&alpha;<sub>s</sub></i> is the ground thermal diffusivity. The
exponential integral is implemented in
<a href=\"modelica://Buildings.Utilities.Math.Functions.exponentialIntegralE1\">Buildings.Utilities.Math.Functions.exponentialIntegralE1</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end infiniteLineSource;
