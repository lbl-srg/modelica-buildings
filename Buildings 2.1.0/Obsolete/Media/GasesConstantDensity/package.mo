within Buildings.Obsolete.Media;
package GasesConstantDensity "Package with models for gases where pressure and temperature are independent of each other"
  extends Modelica.Icons.MaterialPropertiesPackage;


annotation (preferredView="info", Documentation(info="<html>
<p>
Medium models in this package use a constant mass density.
</p>
<p>
The use of a constant density avoids having pressure as a state variable in mixing volumes. Hence, fast transients
introduced by a change in pressure are avoided.
The drawback is that the dimensionality of the coupled
nonlinear equation system is typically larger for flow
networks.
</p>
<p>
Note that models in this package implement the equation for the internal energy as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  u = h - p &frasl; &rho;<sub>stp</sub>,
</p>
<p>
where
<i>u</i> is the internal energy per unit mass,
<i>h</i> is the enthalpy per unit mass,
<i>p</i> is the static pressure and
<i>&rho;<sub>stp</sub></i> is the mass density at standard pressure and temperature.
The reason for this implementation is that in general,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  h = u + p v,
</p>
<p>from which follows that</p>
<p align=\"center\" style=\"font-style:italic;\">
  u = h - p v = h - p &frasl; &rho; = h - p &frasl; &rho;<sub>std</sub>,
</p>
<p>because <i>&rho; = &rho;<sub>std</sub></i> in this medium model.</p>
</html>", revisions="<html>
<ul>
<li>
March 19, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GasesConstantDensity;
