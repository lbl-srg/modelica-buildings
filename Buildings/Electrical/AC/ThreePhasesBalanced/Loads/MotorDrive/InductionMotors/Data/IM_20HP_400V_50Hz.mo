within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_20HP_400V_50Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    (
    P = 4,
    J = 0.102,
    Lr = 0.065181,
    Ls = 0.065181,
    Lm = 0.06419,
    Rs = 0.2147,
    Rr = 0.2205,
    Freq = 50,
    Voltage = 400) "Generic 20hp motor operating at 400V and 50Hz"
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the record of parameters for Induction Machine models from MATLAB
<code>(IM20HP400V50Hz)</code>
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
