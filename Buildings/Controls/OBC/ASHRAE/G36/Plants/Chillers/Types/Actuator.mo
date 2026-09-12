within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types;
type Actuator = enumeration(
  Modulating
    "Modulating",
  TwoPosition
  "Two-position") "Enumeration to specify the type of actuator"
annotation (
Documentation(info="<html>
<p>
It provides constants that indicate the actuator types.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2026, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
