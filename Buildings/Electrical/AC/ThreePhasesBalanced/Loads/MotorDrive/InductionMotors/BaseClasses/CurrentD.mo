within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function CurrentD   "Function to compute d axis of the electrical current at terminal that connects electric grid with the model"

  input Real i_ds "D-axis stator current";

  output Real i "Terminal current interface";

algorithm
  i :=1.5*i_ds;
annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute d-axis current for the model
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>"));
end CurrentD;
