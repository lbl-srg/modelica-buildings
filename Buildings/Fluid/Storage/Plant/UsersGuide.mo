within Buildings.Fluid.Storage.Plant;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
[fixme: Replace/update schematics.]
This package implements models for a storage plant with a chiller and a tank.
The tank in this plant can be charged by its local chiller or by a remote
chiller on the same CHW district network.
</p>
<p>
An example model for this system is implemented in the subpackage
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples\">
Buildings.Fluid.Storage.Plant.Examples</a>.
Shown in the schematic below, it has two CHW plants and three users.
</p>
<ul>
<li>
Plant 1 is a simplified CHW plant with only a chiller and a supply pump.
This supply pump is controlled to ensure that all users have enough
pressure head.
</li>
<li>
Plant 2 has a chiller and a stratified CHW tank.
The storage plant has a reversible connections to the district network.
This connection can either pump water to the network from the plant,
or throttle water from the pressurised network to charge the tank.
</li>
</ul>
<p align=\"center\">
<img alt=\"DualSource\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant/DualSource.png\"/>
</p>
<p>
The plants are controlled as follows:
</p>
<ul>
<li>
In plant 1, the chiller is always on and the pump is controlled to ensure
that the users have enough head at all times.
</li>
<li>
In plant 2, the control is implemented as a state graph in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Controls.FlowControl\">
Buildings.Fluid.Storage.Plant.Controls.FlowControl</a>.
<ul>
<li>
In the chiller loop, chiller 2 and its primary pump are always on whenever
needed (for charging the tank or outputting CHW to the network), unless it
is commanded offline.
</li>
<li>
The tank receives commands to charge, hold, or discharge. It also returns two
state of charge (SOC) signals indicating it is full or depleted (or in
between when neither, but never both). When the tank is commanded to
discharge and output CHW to the network, it takes priority over chiller 2.
</li>
<li>
The reversible connection (where the secondary pump and return valve are) is
controlled to maintain the flow rate needed by plant 2.
</li>
</ul>
</li>
</ul>
<p align=\"center\">
<img alt=\"DualSource\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant/ControlSignals.png\"/>
</p>
</html>"));
end UsersGuide;
