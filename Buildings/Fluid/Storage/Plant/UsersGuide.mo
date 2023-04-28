within Buildings.Fluid.Storage.Plant;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<h4>System Concept</h4>
<p>
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
Plant 1 only has a chiller. The supply pump is controlled to ensure that
all users have enough pressure head.
</li>
<li>
Plant 2 has a chiller and a stratified CHW tank.
The storage plant has a reversible connection to the district network.
This connection can either pump water to the network from the plant,
or throttle water from the pressurised network to charge the tank.
</li>
</ul>
<p align=\"center\">
<img alt=\"SystemConcept\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant/SystemConcept.png\"/>
</p>
<h4>Control Signals</h4>
<p>
The plants are controlled as follows:
</p>
<ul>
<li>
In plant 1, the chiller is always on. The speed-controlled pump
ensures that the users have enough pressure head at all times.
</li>
<li>
For plant 2:
<ul>
<li>
In the chiller loop, chiller 2 and its primary pump P<sub>pri</sub>
are on whenever needed (for charging the tank or producing CHW to the
network). Otherwise, they are commanded off.
</li>
<li>
The system receives a command to charge, hold, or discharge the storage tank.
The tank controller returns status signals indicating whether it is depleted,
cooled, or overcooled. The command is not necessarily enforced. For example,
if the chill in the storage tank is depleted, the discharge command will not
be executed. See the Implementation section for details.
</li>
<li>
The reversible connection between plant 2 and the district network
modulates the flow rate needed by plant 2.
<ul>
<li>
When the storage plant produces CHW, P<sub>sec</sub> receives a speed control
signal from the same PI controller as P1 in plant 1.
</li>
<li>
When the storage plant is charged remotely, the pressure-independent valve
is controlled to maintain a constant flow from the pressurised network
to the storage tank.
</li>
<li>
Otherwise, the connection cuts off flow isolates plant 2 from
the district network.
</li>
</ul>
</li>
</ul>
</li>
</ul>
<p align=\"center\">
<img alt=\"ControlSignals\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/Plant/ControlSignals.png\"/>
</p>
<h4>Implementation</h4>
<p>
The chiller is implemented as an ideal temperature source where the outlet
temperature is always at the prescribed value in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.IdealTemperatureSource\">
Buildings.Fluid.Storage.Plant.BaseClasses.IdealTemperatureSource</a>.
</p>
<p>
The control of the storage plant is implemented as a state graph in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Controls.FlowControl\">
Buildings.Fluid.Storage.Plant.Controls.FlowControl</a>.
</p>
<p>
The status of tank is also implemented as a state graph in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Controls.TankStatus\">
Buildings.Fluid.Storage.Plant.Controls.TankStatus</a>.
</p>
</html>"));
end UsersGuide;
