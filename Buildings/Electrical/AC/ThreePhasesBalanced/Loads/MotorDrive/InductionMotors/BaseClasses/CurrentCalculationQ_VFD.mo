within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentCalculationQ_VFD

input Real i_qs;
input Real VFDvol;
input Real vrms;
output Real i;

algorithm
  i :=1.0*i_qs*(VFDvol/vrms);

end CurrentCalculationQ_VFD;
