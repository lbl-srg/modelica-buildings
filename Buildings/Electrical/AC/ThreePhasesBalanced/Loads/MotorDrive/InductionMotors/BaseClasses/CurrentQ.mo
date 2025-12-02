within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentQ "Q-axis electrical current at terminal that connects electric grid with the model"

  input Real i_qs "Q-axis stator current";

  output Real i "Terminal current interface";

algorithm
  i :=1.0*i_qs;
annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute q-axis current for the model
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end CurrentQ;
