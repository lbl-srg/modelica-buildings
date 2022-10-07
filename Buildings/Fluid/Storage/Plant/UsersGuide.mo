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
Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch</a>.
Users are referred to
<a href=\"Modelica://Buildings.Fluid.Chillers\">
Buildings.Fluid.Chillers</a>
for available chiller component models.
</li>
<li>
The <b>tank branch</b> is implemented in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.TankBranch\">
Buildings.Fluid.Storage.Plant.TankBranch</a>.
</li>
<li>
The <b> network connection</b> implements the supply pump and valves for connection
to a district network in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>.
Some of the components are conditionally enabled based on the plant setup.
See its documentation for details.
</li>
</ul>
<p>
All branch models except the chiller branch are extended from
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts\">
Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts</a>.
Because they share many nominal values, the nominal values can be assigned
conveniently in a single data record in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Data.NominalValues\">
Buildings.Fluid.Storage.Plant.Data.NominalValues</a>.
</p>
<p>
The model can be configured to allow or disallow remote charging
using the Boolean switch <code>allowRemoteCharging</code>.
It changes the structure of the plant model as shown in the schematics below:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th><code>allowRemoteCharging</code></th>
    <th>Schematic</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><code>=false</code></td>
    <td>
<p align=\"center\">
<img alt=\"ClosedLocal\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant_Local.png\"/>
</p>
    </td>
    <td>The tank functions similarly to a common pipe.
        Its charging or discharging state is not directly controlled.
    </td>
  </tr>
  <tr>
    <td><code>=true</code></td>
    <td>
<p align=\"center\">
<img alt=\"ClosedRemote\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant_Remote.png\"/>
</p>
    </td>
    <td>A pair of interlocked valves are used to allow for reversing the flow
        to charge the storage tank from a remote source.
        They are interlocked in a way that they are not allowed to open
        at the same time to prevent flow short circuit.
        In this setting, there is another plant in the district network that
        maintains the differential pressure between the supply and return lines.
        Therefore <code>pum</code> is mainly controlled to track the flow rate
        of the tank to charge or discharge it.
        When the storage plant outputs CHW to the district network,
        <code>valToNet</code> is open and <code>valFroNet</code> is closed.
        When the storage plant is charged remotely, <code>valToNet</code>
        is closed to isolate <code>pum</code> and <code>valFroNet</code>
        is modulated to track the flow rate setpoint at the tank.
    </td>
  </tr>
</tbody>
</table>
</html>"));
end UsersGuide;
