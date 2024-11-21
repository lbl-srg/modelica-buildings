within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_50HP_400V_50Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    (
    P = 4,
    J = 0.37,
    Lr = 0.027834,
    Ls = 0.027834,
    Lm = 0.02711,
    Rs = 0.08233,
    Rr = 0.0503,
    Freq = 50,
    Voltage = 400) "Generic 50hp motor operating at 400V and 50Hz"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
  coordinateSystem(preserveAspectRatio=false)));
