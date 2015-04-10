within Buildings.Obsolete.Media;
package GasesPTDecoupled "Package with models for gases where pressure and temperature are independent of each other"
  extends Modelica.Icons.MaterialPropertiesPackage;


annotation (preferredView="info", Documentation(info="<html>
Medium models in this package use the gas law
<i>d/d<sub>stp</sub> = p/p<sub>stp</sub></i> where
<i>p<sub>std</sub></i> and <i>d<sub>stp</sub></i> are constants for a reference
temperature and density instead of the ideal gas law
<i>&rho; = p &frasl;(R T)</i>.
<p>
This new formulation often leads to smaller systems of nonlinear equations
because pressure and temperature are decoupled, at the expense of accuracy.
</p>
<p>
Note that models in this package implement the equation for the internal energy as
<p align=\"center\" style=\"font-style:italic;\">
  u = h - p<sub>stp</sub> &frasl; &rho;<sub>stp</sub>,
</p>
where
<i>u</i> is the internal energy per unit mass,
<i>h</i> is the enthalpy per unit mass,
<i>p<sub>stp</sub></i> is the static pressure and
<i>&rho;<sub>stp</sub></i> is the mass density at standard pressure and temperature.
The reason for this implementation is that in general,
<p align=\"center\" style=\"font-style:italic;\">
  h = u + p v,
</p>
from which follows that
<p align=\"center\" style=\"font-style:italic;\">
  u = h - p v = h - p &frasl; &rho; = h - p<sub>stp</sub> &frasl; &rho;<sub>std</sub>,
</p>
because <i>p &frasl; &rho; = p<sub>stp</sub> &frasl; &rho;<sub>stp</sub></i> in this medium model.
</html>", revisions="<html>
<ul>
<li>
March 19, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GasesPTDecoupled;
