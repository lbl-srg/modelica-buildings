within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model SpeedBlock "Calculate speed and slip using electromagnetic torque, load torque and frequency"
  extends Modelica.Blocks.Icons.Block;

  parameter Real J( start=0.0131, fixed=true);
  parameter Integer P( start=4, fixed=true);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_e
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput omega_r
    annotation (Placement(transformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput N
    annotation (Placement(transformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput omega_r1
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Blocks.Math.Gain gain(k=P/(2*J))
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Math.Gain gain1(k=(2/P)*(60/(2*Modelica.Constants.pi)))
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{-70,-70},{-50,-90}})));

equation
  connect(feedback.u1, tau_e) annotation (Line(points={{-88,60},{-120,60}},
                     color={0,0,127}));
  connect(feedback.u2, tau_m)
    annotation (Line(points={{-80,52},{-80,0},{-120,0}},color={0,0,127}));
  connect(feedback.y, gain.u)
    annotation (Line(points={{-71,60},{-60,60},{-60,0},{-42,0}},
                                                 color={0,0,127}));
  connect(gain.y, integrator.u)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(integrator.y, gain1.u)
    annotation (Line(points={{21,0},{38,0}},   color={0,0,127}));
  connect(gain1.y, N) annotation (Line(points={{61,0},{70,0},{70,-60},{120,-60}},
        color={0,0,127}));
  connect(feedback1.u1, omega) annotation (Line(points={{-68,-80},{-80,-80},{-80,-60},
          {-120,-60}},     color={0,0,127}));
  connect(N, N)
    annotation (Line(points={{120,-60},{120,-60}}, color={0,0,127}));
  connect(feedback1.y, omega_r) annotation (Line(points={{-51,-80},{90,-80},{90,
          60},{120,60}}, color={0,0,127}));
  connect(feedback1.u2, gain1.u) annotation (Line(points={{-60,-72},{-60,-48},{30,
          -48},{30,0},{38,0}},    color={0,0,127}));
  connect(omega_r1, gain1.u) annotation (Line(points={{120,0},{80,0},{80,-48},{30,
          -48},{30,0},{38,0}},     color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end SpeedBlock;
