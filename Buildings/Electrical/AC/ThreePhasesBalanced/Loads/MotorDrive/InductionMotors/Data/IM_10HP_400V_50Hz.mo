within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_10HP_400V_50Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    ( P = 4,
      J = 0.0343 "Moment of Inertia [kg/m2]",
      Lr = 0.127145 "Rotor Inductance [H]",
      Ls = 0.127145 "Stator Inductance [H]",
      Lm = 0.1241 "Mutual Inductance [H]",
      Rs = 0.7384 "Stator Resistance [ohm]",
      Rr = 0.7402 "Rotor Resistance [ohm]",
      Freq = 50 "Standard Frequency [Hz]",
      Voltage = 400) "Generic 10hp motor operating at 400V and 50Hz"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
