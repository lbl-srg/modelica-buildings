within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_50HP_460V_60Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    (
    P = 4,
    J = 0.4,
    Lr = 0.031257,
    Ls = 0.031257,
    Lm = 0.03039,
    Rs = 0.09961,
    Rr = 0.05837,
    Freq = 60,
    Voltage = 460) "Generic 50hp motor operating at 460V and 60Hz"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
  coordinateSystem(preserveAspectRatio=false)));
