within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
block FrequencyConversion
  "Convert the frequency from Hertz to radians per second"
  extends Modelica.Blocks.Icons.Block;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput f
    "Value in hertz"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput omega
    "Value in radian per second"
    annotation (Placement(transformation(extent={{100,-20},{138,18}})));

algorithm
  omega := 2*Modelica.Constants.pi*f;

end FrequencyConversion;
