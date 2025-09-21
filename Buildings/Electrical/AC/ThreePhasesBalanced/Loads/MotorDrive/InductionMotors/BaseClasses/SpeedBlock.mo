within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model SpeedBlock "Calculate speed and slip using electromagnetic torque, load torque and frequency"
  extends Modelica.Blocks.Icons.Block;

  parameter Real J( start=0.0131, fixed=true) "Moment of Inertia";
  parameter Integer P( start=4, fixed=true) "Number of poles";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_e "Electromagnetic torque"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m "Mechanical torque"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega "Electrical angular frequency"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput omega_r "Rotor angular frequency"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput N "Rotor speed"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput omega_r1 "Rotor angular frequency"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Blocks.Math.Gain gain(k=P/(2*J))
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Math.Gain gain1(k=(2/P)*(60/(2*Modelica.Constants.pi)))
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{-70,-50},{-50,-70}})));

equation
  connect(feedback.u1, tau_e) annotation (Line(points={{-88,60},{-120,60}},
         color={0,0,127}));
  connect(feedback.u2, tau_m)
    annotation (Line(points={{-80,52},{-80,0},{-120,0}},color={0,0,127}));
  connect(feedback.y, gain.u)
    annotation (Line(points={{-71,60},{-60,60},{-60,0},{-42,0}}, color={0,0,127}));
  connect(gain.y, integrator.u)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(integrator.y, gain1.u)
    annotation (Line(points={{21,0},{38,0}}, color={0,0,127}));
  connect(gain1.y, N) annotation (Line(points={{61,0},{70,0},{70,-70},{120,-70}},
          color={0,0,127}));
  connect(feedback1.u1, omega) annotation (Line(points={{-68,-60},{-120,-60}},
          color={0,0,127}));
  connect(feedback1.y, omega_r) annotation (Line(points={{-51,-60},{90,-60},{90,
          70},{120,70}}, color={0,0,127}));
  connect(feedback1.u2, gain1.u) annotation (Line(points={{-60,-52},{-60,-30},{
          30,-30},{30,0},{38,0}}, color={0,0,127}));
  connect(omega_r1, gain1.u) annotation (Line(points={{120,-30},{30,-30},{30,0},
          {38,0}}, color={0,0,127}));
 annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes the rotor mechanical speed and slip of an induction machine using the electromagnetic torque, mechanical load torque, and electrical supply frequency.
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
<b>Inputs:</b> <i>\\tau<sub>e</sub></i> [N·m], <i>\\tau<sub>m</sub></i> [N·m], <i>\\omega</i> [rad/s] &nbsp; | &nbsp;
<b>Outputs:</b> <i>\\omega<sub>r</sub></i> [rad/s], <i>N</i> [rpm], <i>s</i> [-]
</p>

<p>
This block is used in 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>
",        revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>"));
end SpeedBlock;
