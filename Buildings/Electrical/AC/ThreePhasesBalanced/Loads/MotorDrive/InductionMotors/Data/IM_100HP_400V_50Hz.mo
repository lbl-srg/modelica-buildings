within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.Data;
record IM_100HP_400V_50Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.Data.Generic
    (
    P = 4,
    J = 1.25,
    Lr = 0.015435,
    Ls = 0.015435,
    Lm = 0.0151,
    Rs = 0.03552,
    Rr = 0.02092,
    Freq = 50,
    Voltage = 400) "Generic 100hp motor operating at 400V and 50Hz"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
  coordinateMenuSystem(preserveAspectRatio=false)));
