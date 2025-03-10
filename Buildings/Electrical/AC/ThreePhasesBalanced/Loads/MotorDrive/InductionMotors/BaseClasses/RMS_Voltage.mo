within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function RMS_Voltage

input Real a;
input Real b;

  output Real v;

algorithm
  v :=sqrt(a^2+b^2);
end RMS_Voltage;
