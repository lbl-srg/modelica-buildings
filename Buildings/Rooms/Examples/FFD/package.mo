within Buildings.Rooms.Examples;
package FFD "Package that tests the models for coupled simulation between Modelica and Fast Fluid Dynamics"
  extends Modelica.Icons.ExamplesPackage;


annotation (Documentation(info="<html>
<p>
The coupled simulation of model
<a href=\"Buildings.Rooms.CFD\">Buildings.Rooms.CFD</a> with the Fast Fluid Dynamics (FFD) program is tested in this package.
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
