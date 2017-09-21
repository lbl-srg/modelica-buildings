within Buildings.Controls.OBC.ASHRAE.G36.Constants;
package OperationModes
  extends Modelica.Icons.Package;
  constant Integer cooDow = 2 "Cool-down mode";
  constant Integer frePro = 6 "Freeze protection mode";
  constant Integer occMod = 1 "Occupied mode";
  constant Integer setBac = 5 "Set-back mode";
  constant Integer setUp =  3 "Set-up mode";
  constant Integer unoMod = 7 "Unoccupied mode";
  constant Integer warUp =  4 "Warm-up mode";

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
