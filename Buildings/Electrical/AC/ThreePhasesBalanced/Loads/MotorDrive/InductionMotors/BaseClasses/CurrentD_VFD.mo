within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentD_VFD "D-axis VFD electrical current at terminal that connects electric grid with the model"

input Real i_ds "D-axis stator current";
input Real v_VFD "VFD voltage";
input Real v_rms "Root mean squre voltage";
output Real i "Terminal current interface";

algorithm
  i :=1.5*i_ds*(v_VFD/v_rms);
annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute d-axis VFD current for the model
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end CurrentD_VFD;
