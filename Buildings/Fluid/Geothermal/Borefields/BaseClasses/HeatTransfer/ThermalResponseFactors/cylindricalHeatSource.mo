within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors;
function cylindricalHeatSource
  "Cylindrical heat source solution from Carslaw and Jaeger"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Time t "Time";
  input Modelica.Units.SI.ThermalDiffusivity aSoi "Ground thermal diffusivity";
  input Modelica.Units.SI.Distance dis "Radial distance between borehole axes";
  input Modelica.Units.SI.Radius rBor "Radius of emitting borehole";

  output Real G "Thermal response factor of borehole 1 on borehole 2";

protected
  Real Fo = aSoi*t/rBor^2 "Fourier number";
  Real p = dis/rBor "Fourier number";

algorithm
  G := Modelica.Math.Nonlinear.quadratureLobatto(
      function Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource_Integrand(
      Fo=Fo,
      p=p),
    a = 1e-12,
    b = 100,
    tolerance = 1e-6);

annotation (
Inline=true,
Documentation(info="<html>
<p>
This function evaluates the cylindrical heat source solution. This solution
gives the relation between the constant heat transfer rate (per unit length)
injected by a cylindrical heat source of infinite length and the temperature
raise in the medium. The cylindrical heat source solution is defined by
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/CylindricalHeatSource_01.png\" />
</p>
<p>
where <i>&Delta;T(t,r)</i> is the temperature raise after a time <i>t</i> of
constant heat injection and at a distance <i>r</i> from the cylindrical source,
<i>Q'</i> is the heat injection rate per unit length, <i>k<sub>s</sub></i> is
the soil thermal conductivity, <i>Fo</i> is the Fourier number,
<i>aSoi<sub>s</sub></i> is the ground thermal diffusivity,
<i>r<sub>b</sub></i> is the radius of the cylindrical source and <i>G</i>
is the cylindrical heat source solution.
</p>
<p>
The cylindrical heat source solution is given by:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/CylindricalHeatSource_02.png\" />
</p>
<p>
The integral is solved numerically, with the integrand defined in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource_Integrand\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.cylindricalHeatSource_Integrand</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end cylindricalHeatSource;
