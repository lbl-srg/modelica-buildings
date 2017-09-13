within Buildings.Controls.OBC.ASHRAE.G36.Constants;
package OperationModes
  extends Modelica.Icons.Package;
  constant Integer cooDow = 2 "Cool-down mode index";
  constant Integer frePro = 6 "Freeze protection mode index";
  constant Integer occMod = 1 "Occupied mode index";
  constant Integer setBac = 5 "Set-back mode index";
  constant Integer setUp =  3 "Set-up mode index";
  constant Integer unoMod = 7 "Unoccupied mode index";
  constant Integer warUp =  4 "Warm-up mode index";

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
</html>"));
end OperationModes;
