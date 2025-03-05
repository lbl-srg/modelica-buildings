within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_20HP_460V_60Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    (
    P = 4,
    J = 0.1,
    Lr = 0.078331,
    Ls = 0.078331,
    Lm = 0.07614,
    Rs = 0.2761,
    Rr = 0.1645,
    Freq = 60,
    Voltage = 460) "Generic 20hp motor operating at 460V and 60Hz"
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the record of parameters for Induction Machine models from MATLAB
<code>(IM20HP460V60Hz)</code>
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
