within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentCalculationD   "Function to compute current to interface with electrical grid"

  input Real i_ds;

  output Real i;

algorithm
  i :=1.5*i_ds;

end CurrentCalculationD;
