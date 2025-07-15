within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentCalculationD   "Function to compute current to interface with electrical grid"

  input Real i_ds;

  output Real i;

algorithm
  i :=1.5*i_ds;
annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute d-axis current for the model
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage</a>.
</p>
</html>"));
end CurrentCalculationD;
