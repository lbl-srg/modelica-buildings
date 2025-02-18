within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_5HP_460V_60Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    (
    P = 4,
    J = 0.02,
    Lr = 0.209674,
    Ls = 0.209674,
    Lm = 0.2037,
    Rs = 1.115,
    Rr = 1.083,
    Freq = 60,
    Voltage = 460) "Generic 5hp motor operating at 460V and 60Hz"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
  coordinateSystem(preserveAspectRatio=false)));
