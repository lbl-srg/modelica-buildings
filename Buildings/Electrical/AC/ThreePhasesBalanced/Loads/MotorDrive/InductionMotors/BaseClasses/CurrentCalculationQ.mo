within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentCalculationQ "Function to compute current to interface with electrical grid"

  input Real i_qs;

  output Real i;

algorithm
  i :=1.0*i_qs;

end CurrentCalculationQ;
