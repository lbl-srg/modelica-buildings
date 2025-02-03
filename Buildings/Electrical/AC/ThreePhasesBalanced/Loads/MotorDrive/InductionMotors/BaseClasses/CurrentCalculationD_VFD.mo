within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentCalculationD_VFD "Function to compute current to interface with electrical grid"

input Real i_ds;
input Real VFDvol;
input Real vrms;
output Real i;

algorithm
  i :=1.5*i_ds*(VFDvol/vrms);
end CurrentCalculationD_VFD;
