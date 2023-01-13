within Buildings.Fluid.Storage.Plant;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This package implements models for a storage plant with a chiller and a tank.
The tank in this plant can be charged by its local chiller or by a remote
chiller on the same CHW district network.
</p>
<p>
In the subpackage
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples\">
Buildings.Fluid.Storage.Plant.Examples</a>,
example models representing variants of a system shown in the schematic below
are implemented. This is a district system model with two CHW plants and
three users.
</p>
<ul>
<li>
The first CHW source is a simplified CHW plant with only a chiller and
a single supply pump. This supply pump is controlled to ensure that
all users have enough pressure head.
</li>
<li>
The second CHW source has a chiller and a stratified CHW tank. Its piping is
arranged in a way that allows the tank to be charged remotely by the other
plant. The secondary pump is controlled to maintain the flow rate setpoint
of the tank.
</li>
</ul>
<p align=\"center\">
<img alt=\"DualSource\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/DualSource.png\"/>
</p>
</html>"));
end UsersGuide;
