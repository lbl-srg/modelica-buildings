within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentQ_VFD "Function to compute current in q axis entering the induction machine"

input Real i_qs "Q-axis stator current";
input Real v_VFD "VFD voltage";
input Real v_rms "Root mean square voltage";
output Real i "Terminal current interface";

algorithm
  i :=1.0*i_qs*(v_VFD/v_rms);

annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute q-axis VFD current for the model
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
end CurrentQ_VFD;
