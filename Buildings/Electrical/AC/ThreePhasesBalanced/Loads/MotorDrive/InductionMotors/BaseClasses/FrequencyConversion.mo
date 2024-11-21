within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
block FrequencyConversion
  "Convert the frequency from Hertz to radians per second"
   extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.RealInput f "Value in hertz" annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),
                                        iconTransformation(extent={{-140,-20},{-100,
            20}})));
  Modelica.Blocks.Interfaces.RealOutput omega "Value in radian per second" annotation (Placement(transformation(
          extent={{100,-20},{138,18}}),
                                      iconTransformation(extent={{100,-20},
            {138,18}})));

algorithm
  omega := 2*Modelica.Constants.pi*f;

end FrequencyConversion;
