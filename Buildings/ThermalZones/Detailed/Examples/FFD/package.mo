within Buildings.ThermalZones.Detailed.Examples;
package FFD "Package that tests the models for coupled simulation between Modelica and Fast Fluid Dynamics"
  extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<p>
This package tests the coupled simulation of the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">Buildings.ThermalZones.Detailed.CFD</a> with the Fast Fluid Dynamics (FFD) program.
Different cases with various boundary conditions are evaluated.
The models in this package do not represent realistic buildings, but
are rather designed to test the coupled simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
January 21, 2014, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end FFD;
