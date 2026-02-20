within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_10HP_460V_60Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    (
    P = 4,
    J = 0.05,
    Lr = 0.152752,
    Ls = 0.152752,
    Lm = 0.1486,
    Rs = 0.6837,
    Rr = 0.451,
    Freq = 60,
    Voltage = 460) "Generic 10hp motor operating at 460V and 60Hz"
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the record of parameters for Induction Machine models from MATLAB
<code>(IM10HP460V60Hz)</code>
</p>
</html>",
revisions="<html>
<ul>
<li>
May 7, 2024, by Viswanathan Ganesh:<br/>
First implementation.
</li>
</ul>
</html>"));
