within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentCalculationQ_VFD "Function to compute current to interface with electrical grid"

input Real i_qs;
input Real VFDvol;
input Real vrms;
output Real i;

algorithm
  i :=1.0*i_qs*(VFDvol/vrms);

annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute q-axis VFD current for the model
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive</a>.
</p>
</html>"));
end CurrentCalculationQ_VFD;
