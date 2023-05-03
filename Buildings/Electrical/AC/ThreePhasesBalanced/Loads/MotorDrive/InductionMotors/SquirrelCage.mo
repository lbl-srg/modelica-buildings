within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors;
model SquirrelCage "Squirrel cage type induction motor with electrical interface"
  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);

  parameter Integer pole=4 "Number of pole pairs";
  parameter Modelica.Units.SI.Inertia J(min=0)=2
    "Moment of inertia";
  parameter Modelica.Units.SI.Resistance R_s=0.641
    "Electric resistance of stator";
  parameter Modelica.Units.SI.Resistance R_r=0.332
    "Electric resistance of rotor";
  parameter Modelica.Units.SI.Reactance X_s=1.106
    "Complex component of the impedance of stator";
  parameter Modelica.Units.SI.Reactance X_r=0.464
    "Complex component of the impedance of rotor";
  parameter Modelica.Units.SI.Reactance X_m=26.3
    "Complex component of the magnetizing reactance";

  Real s(min=0,max=1) "Motor slip";
  Real v_rms "RMS voltage";
  Modelica.Units.SI.Torque tau_e
    "Electromagenetic torque of rotor";
  Modelica.Units.SI.Power pow_gap
    "Air gap power";
  Modelica.Units.SI.Angle theta_s
    "Supply voltage phase angel";
  Modelica.Units.SI.AngularVelocity omega
    "Supply voltage angular frequency";
  Modelica.Units.SI.AngularVelocity omega_r
    "Rotor angular frequency";
  Modelica.Units.SI.Voltage v[:] = terminal.v
    "Voltage vector";
  Modelica.Units.SI.Current i[:] = terminal.i
    "Current vector";
  Modelica.Units.SI.Resistance Req "Equivelant resistance";
  Modelica.Units.SI.Reactance Xeq "Equivelant reactance";

  final Modelica.Blocks.Sources.RealExpression w_r(y=omega_r)
    "Rotor speed"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  final Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
    "Supply voltage frequency"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  final Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms) "RMS voltage"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true) "Speed connector"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface torSpe(
    final pole=pole,
    final R_s=R_s,
    final R_r=R_r,
    final X_s=X_s,
    final X_r=X_r,
    final X_m=X_m)
  "Motor machine interface"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Interfaces.RealOutput P(final quantity = "Power", final unit = "W")
    "Real power"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput Q(final quantity = "Power", final unit = "var")
    "Reactive power"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Interfaces.RealInput tau_m(unit="N.m")
    "Load torque"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));

initial equation
  omega_r=0;

equation
  // Assign values for motor model calculation from electrical interface
  theta_s = PhaseSystem.thetaRef(terminal.theta);
  omega = der(theta_s);
  s = torSpe.s;
  tau_e = torSpe.tau_e;
  v_rms=sqrt(v[1]^2+v[2]^2);

  // Motor-load torque balance equation
  der(omega_r) = (tau_e-tau_m)/J;

  // Equations to calculate power consumption
  pow_gap = torSpe.omega_s*tau_e;
  Req = R_s + R_r*s*X_m^2/(R_r^2+(s^2)*(X_r+X_m)^2);
  Xeq = X_s + X_m*(R_r^2+(s*X_r)^2+(s^2)*X_r*X_m)/(R_r^2+(s^2)*(X_r+X_m)^2);

  P = if noEvent(torSpe.omega_s>0) then 3*v_rms^2*Req/(Req^2+Xeq^2) else 0;
  Q = if noEvent(torSpe.omega_s>0) then 3*v_rms^2*Xeq/(Req^2+Xeq^2) else 0;

  // Equations to calculate current
  i[1] = (v[2]*Q + v[1]*P)/(v[1]^2 + v[2]^2);
  i[2] = (v[2]*P - v[1]*Q)/(v[1]^2 + v[2]^2);

  connect(w_r.y, torSpe.omega_r) annotation (Line(points={{-39,-30},{-20,-30},
          {-20,-4},{-12,-4}}, color={0,0,127}));
  connect(fre.y, torSpe.f) annotation (Line(points={{-39,0},{-12,0}},
          color={0,0,127}));
  connect(Vrms.y, torSpe.V_rms) annotation (Line(points={{-39,30},{-20,30},
          {-20,4},{-12,4}}, color={0,0,127}));
  connect(shaft, speed.flange) annotation (Line(points={{100,0},{80,0}},
          color={0,0,0}));
  connect(w_r.y, speed.w_ref) annotation (Line(points={{-39,-30},{40,-30},{40,0},
          {58,0}}, color={0,0,127}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          origin={0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-80,-60},{80,60}}),
        Rectangle(
          origin={0,0},
          fillColor={128,128,128},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-80,-60},{-60,60}}),
        Rectangle(
          origin={20,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{60,-10},{80,10}}),
        Rectangle(
          origin={0.626262,-10},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          extent={{-60.6263,50},{20.2087,70}}),
        Polygon(
          origin={2.835,0},
          fillPattern=FillPattern.Solid,
          points={{-70,-90},{-60,-90},{-30,-20},{20,-20},{50,-90},{60,-90},
          {60,-100},{-70,-100},{-70,-90}}),
        Text(
          extent={{-82,162},{82,116}},
          textColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          textString="%name")}),
        defaultComponentName="mot",
    Documentation(info="<html>
<p>
This is a simplified model of a squirrel cage type induction motor with electrical 
and mechanical interface, which is based on the per-phase equivalent circuit model 
for an induction motor. The model inputs include load torque, as well as frequency 
and voltage from the power supply system at the electrical connector as the AC interface.
Besides the electromagnetic torque equation from 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.
BaseClasses.MotorMachineInterface</a>, main governing equations used to 
construct the model are as follows:
</p>
<p>
The motor-load torque balance equation:
</p>
<p align=\"center\" style=\"font-style:italic;\">dW<sub>r</sub>&nbsp;/dt&nbsp;=&nbsp;
(tau<sub>e</sub>&nbsp;-&nbsp;tau<sub>m</sub>)&nbsp;/&nbsp;J
</p>
<p>
Where, the <i>W<sub>r</sub></i> is angular velocity of rotor [rad/s], 
<i>tau<sub>e</sub></i> is electromagnetic torque generated by motor [N.m], 
and <i>tau<sub>m</sub></i> is load torque [N.m], <i>J</i> is motor inertia [kg.m2].
</p>
<p>
The active power consumed by the motor:
</p>
<p align=\"center\" style=\"font-style:italic;\">P&nbsp;=&nbsp;n&nbsp;*&nbsp;
(V<sub>rms</sub>)<sup>2</sup>&nbsp;*&nbsp;R<sub>eq</sub>&nbsp;/&nbsp;
[(R<sub>eq</sub>)<sup>2</sup>&nbsp;+&nbsp;(X<sub>eq</sub>)<sup>2</sup>]
</p>
<p>
The reactive power consumed by the motor:
</p>
<p align=\"center\" style=\"font-style:italic;\">Q&nbsp;=&nbsp;n&nbsp;*&nbsp;
(V<sub>rms</sub>)<sup>2</sup>&nbsp;*&nbsp;X<sub>eq</sub>&nbsp;/&nbsp;
[(R<sub>eq</sub>)<sup>2</sup>&nbsp;+&nbsp;(X<sub>eq</sub>)<sup>2</sup>]
</p>
<p>
<i>R<sub>eq</sub></i> and <i>X<sub>eq</sub></i> are the equivalent resistance 
and reactance of induction motor per-phase equivalent circuit, can be 
calculated as follows: 
</p>
<p align=\"center\" style=\"font-style:italic;\">R<sub>eq</sub>&nbsp;=&nbsp;
R<sub>s</sub>&nbsp;+&nbsp;(X<sub>m</sub>)<sup>2</sup>&nbsp;*&nbsp;R<sub>r</sub>&nbsp;
*&nbsp;s&nbsp;/&nbsp;[(R<sub>r</sub>)<sup>2</sup>&nbsp;+&nbsp;(s)<sup>2</sup>&nbsp;
*&nbsp;(X<sub>r</sub>&nbsp;+&nbsp;X<sub>m</sub>)<sup>2</sup>]
</p>
<p align=\"center\" style=\"font-style:italic;\">X<sub>eq</sub>&nbsp;=&nbsp;
X<sub>s</sub>&nbsp;+&nbsp;X<sub>m</sub>&nbsp;*&nbsp;[(R<sub>r</sub>)<sup>2</sup>&nbsp;
+&nbsp;(s&nbsp;*&nbsp;X<sub>r</sub>)<sup>2</sup>&nbsp;+&nbsp;(s)<sup>2</sup>&nbsp;
*&nbsp;X<sub>r</sub>&nbsp;*&nbsp;X<sub>m</sub>]&nbsp;/&nbsp;[(R<sub>r</sub>)<sup>2</sup>&nbsp;
+&nbsp;(s)<sup>2</sup>&nbsp;*&nbsp;(X<sub>r</sub>&nbsp;+&nbsp;X<sub>m</sub>)<sup>2</sup>]
</p>
<p>
Where, the subscripts <i>s</i>, <i>r</i> and <i>m</i> represent the stator, 
rotor and magnetizing part, respectively. The circuit diagram is found in 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface\">
MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
Refactored implementation to add mechanical interface and integrate inertia. 
</li>
<li>
March 6, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SquirrelCage;
