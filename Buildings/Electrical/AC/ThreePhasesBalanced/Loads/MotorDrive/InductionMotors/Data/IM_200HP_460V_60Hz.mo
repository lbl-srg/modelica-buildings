within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_200HP_460V_60Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    (
    P = 4,
    J = 2.6,
    Lr = 0.009605,
    Ls = 0.009605,
    Lm = 0.009415,
    Rs = 0.01818,
    Rr = 0.009956,
    Freq = 60,
    Voltage = 460) "Generic 200hp motor operating at 460V and 60Hz"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
  coordinateSystem(preserveAspectRatio=false)));
