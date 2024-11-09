within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.Data;
record IM_200HP_400V_50Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.Data.Generic
    (
    P = 4,
    J = 2.9,
    Lr = 0.007842,
    Ls = 0.007842,
    Lm = 0.00769,
    Rs = 0.01379,
    Rr = 0.007728,
    Freq = 50,
    Voltage = 400) "Generic 200hp motor operating at 400V and 50Hz"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
  coordinateSystem(preserveAspectRatio=false)));
