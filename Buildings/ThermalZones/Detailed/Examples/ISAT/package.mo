within Buildings.ThermalZones.Detailed.Examples;
package ISAT "Package that tests the models for coupled simulation between Modelica and ISAT"
  extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<p>
This package tests the coupled simulation of the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.ISAT\">Buildings.ThermalZones.Detailed.ISAT</a>
with the in situ adaptive tabulation (ISAT) program.
Different cases with various boundary conditions are evaluated.
The models in this package do not represent realistic buildings, but
are rather designed to test the coupled simulation.
</p>
</html>", revisions="<html>
<ul>
<li>April 5, 2020, by Xu Han, Cary Faulkner, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end ISAT;
