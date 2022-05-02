within Buildings.Fluid.Storage.Plant;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package implements a model of a storage plant with a chiller and a tank.
The tank in this plant can be charged by its local chiller or by a remote chiller
on the same CHW district network.
</p>
<p>
The model can be configured to have the following setups using the enumeration
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup\">
Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup</a>:
<ul>
<li>
<code>ClosedLocal</code> - A closed tank that only allows local charging.
</li>
<li>
<code>ClosedRemote</code> - A closed tank that allows remote charging.
</li>
<li>
<code>Open</code> - An open tank. Remote charging is always allowed.
</li>
</ul>
</p>
<p>
The model is implemented in three parts:
</p>
<ul>
<li>
The chiller branch is implemented as base class in example and validation models in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch\">
Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch</a>
and in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Validation.BaseClasses.IdealChillerBranch\">
Buildings.Fluid.Storage.Plant.Validation.BaseClasses.IdealChillerBranch</a>.
</li>
<li>
The tank branch is implemented in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.TankBranch\">
Buildings.Fluid.Storage.Plant.TankBranch</a>.
The model conditionally enables a volume for exposure to the atmosperic pressure
if the model is configured to have an open tank.
</li>
<li>
The supply pump and valves are implemented in 
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>.
See its documentation for details.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image of a storage tank\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant.png\"/>
</p>
</html>"));
end UsersGuide;
