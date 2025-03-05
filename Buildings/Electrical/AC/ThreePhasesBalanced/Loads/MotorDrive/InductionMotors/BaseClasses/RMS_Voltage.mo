within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
function RMS_Voltage "Function to compute RMS voltage"

input Real a;
input Real b;

  output Real v;

algorithm
  v :=sqrt(a^2+b^2);
annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute RMS voltage for the model
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>"));
end RMS_Voltage;
