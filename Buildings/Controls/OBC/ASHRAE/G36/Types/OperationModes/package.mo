within Buildings.Controls.OBC.ASHRAE.G36.Types;
package OperationModes "Zone group operating modes"
  constant Integer coolDown = 2 "Cool-down";
  constant Integer freezeProtection = 6 "Freeze protection";
  constant Integer occupied = 1 "Occupied";
  constant Integer setBack = 5 "Set-back";
  constant Integer setUp =  3 "Set-up";
  constant Integer unoccupied = 7 "Unoccupied";
  constant Integer warmUp =  4 "Warm-up";

  annotation (
  Documentation(info="<html>
<p>
This package provides constants for indicating different system operation
modes.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Michael Wetter:<br/>
Reordered constants because the file <code>package.order</code> has
the constants listed alphabetically.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/802\">issue 802</a>.
</li>
<li>
July 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end OperationModes;
