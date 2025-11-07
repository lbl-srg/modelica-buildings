within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.BaseClasses;
function Power   "Function to compute Mechancial Power"

input Real tau "Torque";
input Real spe "Rotational Speed";
input Real upper "Upper Limit for smooth function";
input Real lower "Lower Limit for smooth function";

output Real P "Computed power consumption";

algorithm
  P :=tau*Buildings.Utilities.Math.Functions.smoothMax(spe,upper,lower);
annotation (preferredView="info", Documentation(info="<html>
<p>
This function contains script to compute power consumption for the models in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid</a>.
</p>
</html>"));
end Power;
