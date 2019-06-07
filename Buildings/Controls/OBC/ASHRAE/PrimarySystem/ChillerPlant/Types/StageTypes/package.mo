within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types;
package StageTypes "Stage type based on the type of chillers in the stage"

  constant Integer posDis = 1 "The stage has any positive displacement machines";
  constant Integer vsdCen = 2 "The stage has any variable speed centrifugal machines";
  constant Integer conCen = 3 "The stage has any constant speed centrifugal machines";

annotation (
Documentation(info="<html>
<p>
This package provides constants that indicate the AHU zone state.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2017, by Milica Grahovac:<br/>
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
end StageTypes;
