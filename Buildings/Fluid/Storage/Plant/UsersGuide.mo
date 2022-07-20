within Buildings.Fluid.Storage.Plant;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package implements a model of a storage plant with a chiller and a tank.
The tank in this plant can be charged by its local chiller or by a remote chiller
on the same CHW district network. The model is implemented in three parts:
</p>
<ul>
<li>
The chiller branch is not directly implemented with the other two parts
because its configuration is highly up to the user.
Example chiller branch models are implemented as base class with example models in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch\">
Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch</a>
and validation models in
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
All branch models except the chiller branch are extended from
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts\">
Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts</a>.
Because they share many nominal values, the nominal values are assigned in
a single data record in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Data.NominalValues\">
Buildings.Fluid.Storage.Plant.Data.NominalValues</a>.
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
The schematics belay show the plant model's structure under different setups.
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Plant Setup</th>
    <th>Schematic</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><code>ClosedLocal</code></td>
    <td>
<p align=\"center\">
<img alt=\"ClosedLocal\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant_ClosedLocal.png\"/>
</p>
    </td>
    <td>The supply pump <code>pumSup</code>
        tracks a flow rate setpoint of the tank.
    </td>
  </tr>
  <tr>
    <td><code>ClosedRemote</code></td>
    <td>
<p align=\"center\">
<img alt=\"ClosedRemote\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant_ClosedRemote.png\"/>
</p>
    </td>
    <td>A pair of interlocked valves are used to allow reversing the flow
        to charge the storage tank from a remote source.
        When the storage plant outputs CHW to the district network,
        <code>valToNet</code> is open and <code>valFroNet</code> is closed.
        When the storage plant is charged remotely, <code>valToNet</code>
        is closed to isolate <code>pumSup</code> and <code>valFroNet</code>
        is modulated to track the flow rate setpoint at the tank.
        The charging CHW flow is enabled by the pressure difference between
        the supply and return lines of the CHW network.
    </td>
  </tr>
  <tr>
    <td><code>Open</code></td>
    <td>
<p align=\"center\">
<img alt=\"Open\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant_Open.png\"/>
</p>
    </td>
    <td>Similar to <code>.ClosedRemote</code>, the reversible flow is managed
        by pairs of interlocked valves. However, because the open tank is exposed
        to the atmospheric pressure, it cannot be charged by the pressure
        difference of the CHW network. The pressurised CHW from the network would
        simply drain into the open tank. An auxiliary pump is therefore used
        to pressurise CHW to the return line.<br/>
        Also due to the tank being open, the mass flow through the tank is not
        automatically balanced. In order to avoid draining or flooding the open
        tank, separate pump and valve groups are used to balance the flow.<br/>
        For example, when the plant is outputting CHW to the district network,
        <code>pumSup</code> tracks a flow rate setpoint at the tank bottom.
        At the same time, <code>intValRet.valFroNet</code> tracks the same
        flow rate setpoint but at the tank top so that the flow rate through
        the open tank is balanced.
    </td>
  </tr>
</tbody>
</table>
</html>"));
end UsersGuide;
