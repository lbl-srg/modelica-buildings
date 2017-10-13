within Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants;
package AlarmLevels
  "Package with constants that indicate the alarm level"
  extends Modelica.Icons.Package;

  constant Integer level0 = 0 "Alarms are not active";
  constant Integer level1 = 1 "Alarm level 1";
  constant Integer level2 = 2 "Alarm level 2";
  constant Integer level3 = 3 "Alarm level 3";
  constant Integer level4 = 4 "Alarm level 4";
  constant Integer level5 = 5 "Alarm level 5";

annotation (
Documentation(info="<html>
<p>
This package provides constants that indicate the
alarm level.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end AlarmLevels;
