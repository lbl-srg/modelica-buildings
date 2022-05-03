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
</p>
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
Some of its pumps and valves are conditionally enabled based on the plant setup.
See its documentation for details.
</li>
</ul>
<p>
The schematics belay show the plant model's structure under different setups.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Plant Setup<br></th>
    <th>Schematic</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><code>ClosedLocal</code></td>
    <td>
<p align=\"center\">
<img alt=\"Image of a storage tank\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant_ClosedLocal.png\"/>
</p>
    </td>
  </tr>
  <tr>
    <td><code>ClosedRemote</code></td>
    <td>
<p align=\"center\">
<img alt=\"Image of a storage tank\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant_ClosedRemote.png\"/>
</p>
    </td>
  </tr>
  <tr>
    <td><code>Open</code></td>
    <td>
<p align=\"center\">
<img alt=\"Image of a storage tank\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant_Open.png\"/>
</p>
    </td>
  </tr>
</tbody>
</table>
<p>
When the tank is open, because the district network cannot charged it with
the pressure difference between the main supply and return pipes,
an auxiliary pump is needed to pressurise the water to the CHW return line.
</p>
</html>"));
end UsersGuide;
