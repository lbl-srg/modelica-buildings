within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model Motor "Induction machine"
  parameter Real Lr(
    final unit="H",
    final quantity="Inductance")
    "Rotor inductance";
  parameter Real Ls(
    final unit="H",
    final quantity="Inductance")
    "Stator inductance";
  parameter Real Rr(
    final unit="Ohm",
    final quantity="Resistance")
    "Rotor resistance";
  parameter Real Lm(
    final unit="H",
    final quantity="Inductance")
    "Mutual inductance";
  parameter Real Rs(
    final unit="Ohm",
    final quantity="Resistance")
    "Stator resistance";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_ds(
    final unit="V",
    final quantity="Voltage")
    "D-axis stator voltage"
    annotation (Placement(transformation(extent={{-180,50},{-140,90}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_qs(
    final unit="V",
    final quantity="Voltage")
    "Q-axis stator voltage"
    annotation (Placement(transformation(extent={{-180,90},{-140,130}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega(
    final quantity="AngularVelocity",
    final unit="rad/s")
    "Fundamental frequency"
    annotation (Placement(transformation(extent={{-180,10},{-140,50}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega_r(
    final quantity="AngularVelocity",
    final unit="rad/s")
    "Rotor frequency"
    annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_qs(
    final unit="A",
    final quantity="ElectricCurrent")
    "Q-axis stator current"
    annotation (Placement(transformation(extent={{140,70},{180,110}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_ds(
    final unit="A",
    final quantity="ElectricCurrent")
    "D-axis stator current"
    annotation (Placement(transformation(extent={{140,30},{180,70}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_qr(
    final unit="A",
    final quantity="ElectricCurrent")
    "Q-axis rotor current"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput i_dr(
    final unit="A",
    final quantity="ElectricCurrent")
    "D-axis rotor current"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  Modelica.Blocks.Continuous.Integrator qRotCur
    "Q-axis rotor current"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={70,-40})));
  Modelica.Blocks.Continuous.Integrator dRotCur
    "D-axis rotor current"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={70,-100})));
  Modelica.Blocks.Sources.Constant zerRotVol(
    final k=0)
    "Zero Q-axis rotor voltage"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-110,-80})));
  Modelica.Blocks.Continuous.Integrator qStaCur
    "Q-axis stator current"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={70,90})));
  Modelica.Blocks.Continuous.Integrator dStaCur
    "D-axis stator current"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={70,50})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentDerivative_qStator
    qStaCurDer(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs,
    final Ls=Ls) "Time derivative of the Q-axis stator current"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentDerivative_dStator
    dStaCurDer(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm,
    final Rs=Rs,
    final Ls=Ls) "Time derivative of the D-axis stator current"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentDerivative_dRotor
    dRotCurDer(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm) "Time derivative of the D-axis rotor current"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentDerivative_qRotor
    qRotCurDer(
    final Lr=Lr,
    final Rr=Rr,
    final Lm=Lm) "Time derivative of the Q-axis rotor current"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
equation
  connect(qRotCurDer.der_i_qr, qRotCur.u)
    annotation (Line(points={{22,-40},{58,-40}}, color={0,0,127}));
  connect(zerRotVol.y, dRotCurDer.v_dr) annotation (Line(points={{-99,-80},{-40,
          -80},{-40,-91},{-2,-91}}, color={0,0,127}));
  connect(i_ds, dStaCur.y)
    annotation (Line(points={{160,50},{81,50}},  color={0,0,127}));
  connect(i_qr, qRotCur.y)
    annotation (Line(points={{160,-40},{81,-40}},  color={0,0,127}));
  connect(dRotCur.y, i_dr)
    annotation (Line(points={{81,-100},{160,-100}},  color={0,0,127}));
  connect(dStaCurDer.der_i_ds, dStaCur.u) annotation (Line(points={{22,50},{58,50}},
          color={0,0,127}));
  connect(dRotCurDer.der_i_dr, dRotCur.u)
    annotation (Line(points={{22,-100},{58,-100}}, color={0,0,127}));
  connect(qStaCur.y, i_qs)
    annotation (Line(points={{81,90},{160,90}},  color={0,0,127}));
  connect(qStaCur.u, qStaCurDer.der_i_qs) annotation (Line(points={{58,90},{22,90}},
          color={0,0,127}));
  connect(v_qs,qStaCurDer. v_qs)
    annotation (Line(points={{-160,110},{-10,110},{-10,99},{-2,99}}, color={0,0,127}));
  connect(omega,dStaCurDer. omega) annotation (Line(points={{-160,30},{-100,30},
          {-100,48},{-2,48}},color={0,0,127}));
  connect(omega,qStaCurDer. omega) annotation (Line(points={{-160,30},{-100,30},
          {-100,88},{-2,88}},color={0,0,127}));
  connect(omega_r,qRotCurDer. omega_r) annotation (Line(points={{-160,-120},{-90,
          -120},{-90,-42},{-2,-42}}, color={0,0,127}));
  connect(omega_r,dRotCurDer. omega_r) annotation (Line(points={{-160,-120},{-90,
          -120},{-90,-102},{-2,-102}}, color={0,0,127}));
  connect(qRotCurDer.der_i_qr,qStaCurDer. der_i_qr) annotation (Line(points={{22,-40},
          {40,-40},{40,-20},{-40,-20},{-40,92},{-2,92}},       color={0,0,127}));
  connect(dRotCurDer.der_i_dr,dStaCurDer. der_i_dr) annotation (Line(points={{22,-100},
          {40,-100},{40,-80},{-30,-80},{-30,52},{-2,52}},        color={0,0,127}));
  connect(qStaCurDer.der_i_qs,qRotCurDer. der_i_qs) annotation (Line(points={{22,90},
          {40,90},{40,70},{-10,70},{-10,-38},{-2,-38}},      color={0,0,127}));
  connect(dStaCurDer.der_i_ds,dRotCurDer. der_i_ds) annotation (Line(points={{22,50},
          {40,50},{40,20},{-60,20},{-60,-98},{-2,-98}},    color={0,0,127}));
  connect(zerRotVol.y, qRotCurDer.v_qr) annotation (Line(points={{-99,-80},{-40,
          -80},{-40,-31},{-2,-31}}, color={0,0,127}));
  connect(qStaCur.y, qStaCurDer.i_qs) annotation (Line(points={{81,90},{100,90},
          {100,120},{-70,120},{-70,96},{-2,96}}, color={0,0,127}));
  connect(qStaCur.y, dStaCurDer.i_qs) annotation (Line(points={{81,90},{100,90},
          {100,120},{-70,120},{-70,41},{-2,41}}, color={0,0,127}));
  connect(qStaCur.y, dRotCurDer.i_qs) annotation (Line(points={{81,90},{100,90},
          {100,120},{-70,120},{-70,-109},{-2,-109}}, color={0,0,127}));
  connect(dStaCur.y, qStaCurDer.i_ds) annotation (Line(points={{81,50},{100,50},
          {100,10},{-50,10},{-50,81},{-2,81}}, color={0,0,127}));
  connect(dStaCur.y, dStaCurDer.i_ds) annotation (Line(points={{81,50},{100,50},
          {100,10},{-50,10},{-50,56},{-2,56}}, color={0,0,127}));
  connect(dStaCur.y, qRotCurDer.i_ds) annotation (Line(points={{81,50},{100,50},
          {100,10},{-50,10},{-50,-49},{-2,-49}}, color={0,0,127}));
  connect(qRotCur.y, dStaCurDer.i_qr) annotation (Line(points={{81,-40},{100,-40},
          {100,-10},{-80,-10},{-80,44},{-2,44}}, color={0,0,127}));
  connect(qRotCur.y, qRotCurDer.i_qr) annotation (Line(points={{81,-40},{100,-40},
          {100,-10},{-80,-10},{-80,-34},{-2,-34}}, color={0,0,127}));
  connect(qRotCur.y, dRotCurDer.i_qr) annotation (Line(points={{81,-40},{100,-40},
          {100,-10},{-80,-10},{-80,-106},{-2,-106}}, color={0,0,127}));
  connect(dRotCur.y, dRotCurDer.i_dr) annotation (Line(points={{81,-100},{100,-100},
          {100,-60},{-20,-60},{-20,-94},{-2,-94}}, color={0,0,127}));
  connect(dRotCur.y, qStaCurDer.i_dr) annotation (Line(points={{81,-100},{100,-100},
          {100,-60},{-20,-60},{-20,84},{-2,84}}, color={0,0,127}));
  connect(dRotCur.y, qRotCurDer.i_dr) annotation (Line(points={{81,-100},{100,-100},
          {100,-60},{-20,-60},{-20,-46},{-2,-46}}, color={0,0,127}));
  connect(v_ds, dStaCurDer.v_ds) annotation (Line(points={{-160,70},{-120,70},{-120,
          59},{-2,59}}, color={0,0,127}));
  annotation (defaultComponentName="indMac",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,
            140}})),
    Documentation(revisions="<html>
<ul>
<li>
November 10, 2023, by Viswanathan Ganesh:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block implements a dynamic model of a three-phase induction machine in the
synchronous rotating d–q reference frame.
It computes the stator and rotor currents (<i>i<sub>ds</sub></i>, <i>i<sub>qs</sub></i>,
<i>i<sub>dr</sub></i>, <i>i<sub>qr</sub></i>)
from the applied d–q stator voltages (<i>v<sub>ds</sub></i>, <i>v<sub>qs</sub></i>)
and the electrical
(<i>&omega;</i>) and mechanical (<i>&omega;<sub>r</sub></i>) rotor speeds, given
the machine parameters.
</p>
<p>
The stator and rotor voltage equations in d–q matrix form are:
</p>
<p>
\\[
\\begin{bmatrix}
v_{ds} \\\\[4pt]
v_{qs}
\\end{bmatrix}
=
\\begin{bmatrix}
R_s &amp; 0 \\\\[4pt]
0 &amp; R_s
\\end{bmatrix}
\\begin{bmatrix}
i_{ds} \\\\[4pt]
i_{qs}
\\end{bmatrix}
+
\\frac{d}{dt}
\\begin{bmatrix}
\\psi_{ds} \\\\[4pt]
\\psi_{qs}
\\end{bmatrix}
+
\\begin{bmatrix}
0 &amp; -\\omega \\\\[4pt]
\\omega &amp; 0
\\end{bmatrix}
\\begin{bmatrix}
\\psi_{ds} \\\\[4pt]
\\psi_{qs}
\\end{bmatrix}
\\]
</p>
<p>
\\[
\\begin{bmatrix}
0 \\\\[4pt]
0
\\end{bmatrix}
=
\\begin{bmatrix}
R_r &amp; 0 \\\\[4pt]
0 &amp; R_r
\\end{bmatrix}
\\begin{bmatrix}
i_{dr} \\\\[4pt]
i_{qr}
\\end{bmatrix}
+
\\frac{d}{dt}
\\begin{bmatrix}
\\psi_{dr} \\\\[4pt]
\\psi_{qr}
\\end{bmatrix}
+
\\begin{bmatrix}
0 &amp; -(\\omega - \\omega_r) \\\\[4pt]
(\\omega - \\omega_r) &amp; 0
\\end{bmatrix}
\\begin{bmatrix}
\\psi_{dr} \\\\[4pt]
\\psi_{qr}
\\end{bmatrix}
\\]
</p>
<p>
where the flux linkages are:
</p>
<p>
\\[
\\begin{bmatrix}
\\psi_{ds} \\\\[4pt]
\\psi_{qs}
\\end{bmatrix}
=
\\begin{bmatrix}
L_s &amp; L_m \\\\[4pt]
L_m &amp; L_r
\\end{bmatrix}
\\begin{bmatrix}
i_{ds} \\\\[4pt]
i_{dr}
\\end{bmatrix},
\\qquad
\\begin{bmatrix}
\\psi_{qs} \\\\[4pt]
\\psi_{qr}
\\end{bmatrix}
=
\\begin{bmatrix}
L_s &amp; L_m \\\\[4pt]
L_m &amp; L_r
\\end{bmatrix}
\\begin{bmatrix}
i_{qs} \\\\[4pt]
i_{qr}
\\end{bmatrix}
\\]
</p>
<p>
<b>Inputs:</b> <i>v<sub>ds</sub></i>, <i>v<sub>qs</sub></i> [V], <i>&omega;</i> [rad/s],
<i>&omega;<sub>r</sub></i> [rad/s] &nbsp; | &nbsp;
<b>Outputs:</b> <i>i<sub>ds</sub></i>, <i>i<sub>qs</sub></i>, <i>i<sub>dr</sub></i>,
<i>i<sub>qr</sub></i> [A]
</p>
<p>
This block is part of
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>"));
end Motor;
