within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.BaseClasses;
function Power   "Function to compute Mechancial Power"

input Real tau;
input Real spe;
input Real upper;
input Real lower;

output Real P;

algorithm
  P :=tau*Buildings.Utilities.Math.Functions.smoothMax(spe,upper,lower);

end Power;
