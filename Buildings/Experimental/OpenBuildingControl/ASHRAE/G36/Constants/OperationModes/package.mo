within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Constants;
package OperationModes
  extends Modelica.Icons.Package;
  constant Integer occModInd = 1 "Occupied mode index";
  constant Integer cooDowInd = 2 "Cool-down mode index";
  constant Integer setUpInd =  3 "Set-up mode index";
  constant Integer warUpInd =  4 "Warm-up mode index";
  constant Integer setBacInd = 5 "Set-back mode index";
  constant Integer freProInd = 6 "Freeze protection mode index";
  constant Integer unoModInd = 7 "Unoccupied mode index";

  annotation (
  Documentation(info="<html>
<p>
This package provides constants for indicating different system operation 
modes.
</p>
</html>", revisions="<html>
<ul>
<li>
July 1, 2017, by Jianjun:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperationModes;
