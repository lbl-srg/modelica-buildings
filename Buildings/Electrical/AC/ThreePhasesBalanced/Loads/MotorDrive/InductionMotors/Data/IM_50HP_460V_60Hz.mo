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
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the record of parameters for Induction Machine models from MATLAB
<code>(IM50HP460V60Hz)</code>
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
