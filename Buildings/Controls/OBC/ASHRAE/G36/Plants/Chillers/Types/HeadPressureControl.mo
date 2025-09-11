within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types;
type HeadPressureControl= enumeration(
    NotRequired
  "Head pressure control is not required",
    ByChiller
  "Head pressure controlled by chiller",
    ByPlant
  "Head pressure controlled by plant")
  "Head pressure control type enumeration"
 annotation (
Documentation(info="<html>
<p>
It provides constants that indicate if the head pressure control is required, or if
it is required then if the head pressure control signal is from the chiller.
</p>
</html>", revisions="<html>
<ul>
<li>
September 9, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
