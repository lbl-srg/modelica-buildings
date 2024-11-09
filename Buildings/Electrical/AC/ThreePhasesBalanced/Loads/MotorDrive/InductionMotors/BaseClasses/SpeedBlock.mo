within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.BaseClasses;
model SpeedBlock
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput tau_e annotation (Placement(transformation(
          extent={{-140,40},{-100,80}}),iconTransformation(extent={{-140,40},{-100,
            80}})));
  Modelica.Blocks.Interfaces.RealInput tau_m annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{
            -100,20}})));
  Modelica.Blocks.Interfaces.RealInput omega annotation (Placement(transformation(
          extent={{-140,-80},{-100,-40}}),iconTransformation(extent={{-140,-80},
            {-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput omega_r annotation (Placement(transformation(
          extent={{100,42},{138,80}}),iconTransformation(extent={{100,42},{138,80}})));
  Modelica.Blocks.Interfaces.RealOutput N annotation (Placement(transformation(
          extent={{102,-78},{138,-42}}),iconTransformation(extent={{100,-80},
            {138,-42}})));

parameter Real J( start=0.0131, fixed=true);
parameter Integer P( start=4, fixed=true);
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-70,22},{-50,42}})));
  Modelica.Blocks.Math.Gain gain(k=P/(2*J))
    annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  Modelica.Blocks.Math.Gain gain1(k=(2/P)*(60/(2*Modelica.Constants.pi)))
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{-70,-70},{-50,-90}})));
  Modelica.Blocks.Interfaces.RealOutput omega_r1
                                                annotation (Placement(transformation(
          extent={{100,-22},{138,16}}),
                                      iconTransformation(extent={{100,-22},
            {138,16}})));
equation
  connect(feedback.u1, tau_e) annotation (Line(points={{-68,32},{-80,32},{-80,
          60},{-120,60}},
                     color={0,0,127}));
  connect(feedback.u2, tau_m)
    annotation (Line(points={{-60,24},{-60,0},{-120,0}},color={0,0,127}));
  connect(feedback.y, gain.u)
    annotation (Line(points={{-51,32},{-42,32},{-42,0},{-24,0}},
                                                 color={0,0,127}));
  connect(gain.y, integrator.u)
    annotation (Line(points={{-1,0},{10,0}},  color={0,0,127}));
  connect(integrator.y, gain1.u)
    annotation (Line(points={{33,0},{48,0}},   color={0,0,127}));
  connect(gain1.y, N) annotation (Line(points={{71,0},{80,0},{80,-60},{120,
          -60}},
        color={0,0,127}));
  connect(feedback1.u1, omega) annotation (Line(points={{-68,-80},{-80,-80},{-80,-60},
          {-120,-60}},     color={0,0,127}));
  connect(feedback1.u2, gain1.u) annotation (Line(points={{-60,-72},{42,
          -72},{42,0},{48,0}},
                           color={0,0,127}));
  connect(N, N)
    annotation (Line(points={{120,-60},{120,-60}}, color={0,0,127}));
  connect(feedback1.y, omega_r) annotation (Line(points={{-51,-80},{88,
          -80},{88,61},{119,61}},
                         color={0,0,127}));
  connect(omega_r1, integrator.y) annotation (Line(points={{119,-3},{106,
          -3},{106,-4},{94,-4},{94,-40},{36,-40},{36,0},{33,0}}, color={0,
          0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end SpeedBlock;
