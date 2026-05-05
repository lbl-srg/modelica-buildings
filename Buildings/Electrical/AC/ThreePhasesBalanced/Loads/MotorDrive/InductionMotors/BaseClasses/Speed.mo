within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model Speed
  "Calculate speed and slip using electromagnetic torque, load torque and frequency"
  extends Modelica.Blocks.Icons.Block;

  parameter Real J(
    start=0.0131,
    fixed=true,
    unit="kg.m2",
    quantity="MomentOfInertia")
    "Moment of inertia";
  parameter Integer P(
    start=4,
    fixed=true)
    "Number of poles";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_e(
    final quantity="Torque",
    final unit="N.m")
    "Electromagnetic torque"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m(
    final quantity="Torque",
    final unit="N.m")
    "Mechanical torque"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega(
    final quantity="AngularVelocity",
    final unit="rad/s")
    "Electrical angular frequency"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput omega_r(
    final quantity="AngularVelocity",
    final unit="rad/s")
    "Rotor angular frequency"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput N
    "Rotor speed"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput omega_r1(
    final quantity="AngularVelocity",
    final unit="rad/s")
    "Rotor angular frequency"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Modelica.Blocks.Math.Feedback torDif
    "Torque difference"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Blocks.Math.Gain gai(
    final k=P/(2*J))
    "Gain"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Continuous.Integrator angFre
    "Angular frequency"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.Blocks.Math.Gain rotSpe(
    final k=(2/P)*(60/(2*Modelica.Constants.pi)))
    "Rotor speed"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Blocks.Math.Feedback angFreDif
    "Angular frequency difference"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-70}})));

equation
  connect(torDif.u1, tau_e)
    annotation (Line(points={{-88,60},{-120,60}}, color={0,0,127}));
  connect(torDif.u2, tau_m)
    annotation (Line(points={{-80,52},{-80,0},{-120,0}}, color={0,0,127}));
  connect(torDif.y, gai.u)
    annotation (Line(points={{-71,60},{-42,60}}, color={0,0,127}));
  connect(gai.y, angFre.u)
    annotation (Line(points={{-19,60},{-2,60}}, color={0,0,127}));
  connect(angFre.y, rotSpe.u)
    annotation (Line(points={{21,60},{38,60}}, color={0,0,127}));
  connect(rotSpe.y, N) annotation (Line(points={{61,60},{70,60},{70,-70},{120,-70}},
        color={0,0,127}));
  connect(angFreDif.u1, omega) annotation (Line(points={{-68,-60},{-120,-60}},
          color={0,0,127}));
  connect(angFreDif.y, omega_r) annotation (Line(points={{-51,-60},{80,-60},{80,
          70},{120,70}}, color={0,0,127}));

  connect(angFre.y, omega_r1) annotation (Line(points={{21,60},{30,60},{30,-20},
          {120,-20}}, color={0,0,127}));
  connect(angFre.y, angFreDif.u2) annotation (Line(points={{21,60},{30,60},{30,
          -20},{-60,-20},{-60,-52}}, color={0,0,127}));
annotation (defaultComponentName="speSli",
Documentation(info="<html>
<p>
This block computes the rotor mechanical speed and slip of an induction machine
using the electromagnetic torque, mechanical load torque, and electrical supply frequency.
It integrates the acceleration derived from the torque difference and converts it to speed.
</p>
<p>
The fundamental mechanical equation used is:
</p>
<p>
\\[
J \\frac{d\\omega_r}{dt} = \\tau_e - \\tau_m
\\qquad\\Longrightarrow\\qquad
\\frac{d\\omega_r}{dt} = \\frac{\\tau_e - \\tau_m}{J}
\\]
</p>
<p>
The rotor speed in revolutions per minute (rpm) is:
</p>
<p>
\\[
N = \\frac{60}{2\\pi} \\, \\omega_r
\\qquad\\text{ and }\\qquad
\\omega_{syn} = \\frac{2\\pi f}{P/2}
\\]
</p>
<p>
Slip can be computed from:
</p>
<p>
\\[
s = \\frac{\\omega_{syn} - \\omega_r}{\\omega_{syn}}
\\]
</p>
<p>
<b>Inputs:</b> <i>&tau;<sub>e</sub></i> [N·m], <i>&tau;<sub>m</sub></i> [N·m],
<i>&omega;</i> [rad/s] &nbsp; | &nbsp;
<b>Outputs:</b> <i>&omega;<sub>r</sub></i> [rad/s], <i>N</i> [rpm], <i>s</i> [-]
</p>
<p>
This block is used in
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
end Speed;
