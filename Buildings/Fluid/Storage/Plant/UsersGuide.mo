within Buildings.Fluid.Storage.Plant;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package implements models for a storage plant with a chiller and a tank.
The tank in this plant can be charged by its local chiller or by a remote chiller
on the same CHW district network. The models are implemented in three main parts,
namely the chiller branch, tank branch, and network connection, 
which form the full plant model when used together:
</p>
<ul>
<li>
The <b>chiller branch</b> implementation is up to the user given the high number
of chiller configurations possible.
Example chiller branch models are implemented in this package as base classes within the example models in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch\">
Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch</a>
and validation models in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Validation.BaseClasses.IdealChillerBranch\">
Buildings.Fluid.Storage.Plant.Validation.BaseClasses.IdealChillerBranch</a>.
Users are referred to <a href=\"Modelica://Buildings.Fluid.Chillers\">
Buildings.Fluid.Chillers</a> for available chiller component models.
</li>
<li>
The <b>tank branch</b> is implemented in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.TankBranch\">
Buildings.Fluid.Storage.Plant.TankBranch</a>.
The model conditionally enables a volume for exposure to the atmosperic pressure
if the model is configured to represent an open tank.
</li>
<li>
The <b> network connection</b> implements the supply pump and valves for connection
to a district network in 
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>.
Some of the pumps and valves are conditionally enabled based on the plant setup.
See its documentation for details.
</li>
</ul>
<p>
All branch models except the chiller branch are extended from
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts\">
Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts</a>.
Because they share many nominal values, the nominal values can be assigned
conveniently in
a single data record in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Data.NominalValues\">
Buildings.Fluid.Storage.Plant.Data.NominalValues</a>.
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
<code>ClosedRemote</code> - A closed tank that allows local and remote charging.
</li>
<li>
<code>Open</code> - An open tank. Local and remote charging is always allowed.
</li>
</ul>
<p>
The schematics below show the plant model's structure under these different setups.
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
        A positive flow rate means that the tank is discharging
        while a negative flow rate means that the tank is being charged.
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
    <td>A pair of interlocked valves are used to allow for reversing the flow
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
        to the atmospheric pressure, an auxiliary pump is used
        to pressurise CHW to the return line.
    </td>
  </tr>
</tbody>
</table>
</html>"));
end UsersGuide;
