within Buildings.Controls.OBC.ASHRAE.G36_PR1.Types;
package FreezeProtectionStages "Package with constants that indicate the freeze protection stages"
  constant Integer stage0 = 0 "Freeze protection is deactivated";
  constant Integer stage1 = 1 "First stage of freeze protection";
  constant Integer stage2 = 2 "Second stage of freeze protection";
  constant Integer stage3 = 3 "Third stage of freeze protection";

annotation (
Documentation(info="<html>
<p>
This package provides constants that indicate the
freeze protection stages.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2017, by Michael Wetter:<br/>
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
end FreezeProtectionStages;
