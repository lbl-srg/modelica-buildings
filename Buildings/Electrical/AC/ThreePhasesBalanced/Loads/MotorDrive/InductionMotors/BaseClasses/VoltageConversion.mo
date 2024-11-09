within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.BaseClasses;
block VoltageConversion
  "Convert the stator voltage from its root mean square (RMS) value into q-axis and d-axis voltages"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput V_rms annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),
                                        iconTransformation(extent={{-140,-20},{-100,
            20}})));
  Modelica.Blocks.Interfaces.RealOutput v_qs annotation (Placement(transformation(
          extent={{100,42},{138,80}}),iconTransformation(extent={{100,42},{138,80}})));
  Modelica.Blocks.Interfaces.RealOutput v_ds annotation (Placement(transformation(
          extent={{100,-78},{136,-42}}),iconTransformation(extent={{98,-80},{136,
            -42}})));

algorithm
  v_ds:= V_rms;
algorithm
  v_qs:= 0;

   // annotation (Line(points={{120,-60},{120,-60}}, color={0,0,127}),
   // Icon(coordinateSystem(preserveAspectRatio=false)),
   // Diagram(coordinateSystem(preserveAspectRatio=false)));
end VoltageConversion;
