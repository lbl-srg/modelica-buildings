within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function RMS_Voltage "Root mean square voltage"

  input Real a "Voltage in d axis";
  input Real b "Voltage in q axis";

  output Real v "Root mean square voltage";

algorithm
  v :=sqrt(a^2+b^2);
annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute root mean square (RMS) voltage for the model
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end RMS_Voltage;
