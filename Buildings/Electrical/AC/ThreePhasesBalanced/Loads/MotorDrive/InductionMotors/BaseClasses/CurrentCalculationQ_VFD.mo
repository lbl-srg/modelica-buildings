within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentCalculationQ_VFD "Function to compute current to interface with electrical grid"

input Real i_qs "Q-axis stator current";
input Real VFDvol "VFD voltage";
input Real vrms "RMS voltage";
output Real i "Terminal current interface";

algorithm
  i :=1.0*i_qs*(VFDvol/vrms);

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
First Implementation.
</li>
</ul>
</html>"));
end CurrentCalculationQ_VFD;
