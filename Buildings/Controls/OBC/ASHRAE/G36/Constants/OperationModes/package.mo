within Buildings.Controls.OBC.ASHRAE.G36.Constants;
package OperationModes
  extends Modelica.Icons.Package;
  constant Integer cooDowInd = 2 "Cool-down mode index";
  constant Integer freProInd = 6 "Freeze protection mode index";
  constant Integer occModInd = 1 "Occupied mode index";
  constant Integer setBacInd = 5 "Set-back mode index";
  constant Integer setUpInd =  3 "Set-up mode index";
  constant Integer unoModInd = 7 "Unoccupied mode index";
  constant Integer warUpInd =  4 "Warm-up mode index";

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
