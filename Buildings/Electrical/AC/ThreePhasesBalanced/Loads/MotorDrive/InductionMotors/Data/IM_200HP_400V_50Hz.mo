within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record IM_200HP_400V_50Hz =
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
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
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the record of parameters for Induction Machine models from MATLAB
<code>(IM200HP400V50Hz)</code>
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
