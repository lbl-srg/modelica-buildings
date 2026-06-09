within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentD "D-axis electrical current at terminal that connects electric grid with the model"

  input Real i_ds "D-axis stator current";
  input Boolean enabled "True to calculate current, False to force zero";
  output Real i "Terminal current interface";

algorithm
  i :=if enabled then 1.5*i_ds else 0.0;
annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute d-axis current for the model
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end CurrentD;
