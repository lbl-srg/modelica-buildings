within Buildings.Electrical.AC.ThreePhasesBalanced.MotorDrive.InductionMotors;
model SquirrelCage "Squirrel cage type induction motor with electrical interface"
  extends BaseClasses.PartialOnePort(
    redeclare package PhaseSystem =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);

  Modelica.Units.SI.Angle theta_s "Phase angel";
  Modelica.Units.SI.AngularVelocity omega "Angular frequency";
  Modelica.Units.SI.AngularVelocity omega_r "Rotor angular frequency";

  Modelica.Units.SI.Voltage v[:] = terminal.v
    "Voltage vector";
  Modelica.Units.SI.Current i[:] = terminal.i
    "Current vector";

  parameter Integer pole = 4 "Number of pole pairs";
  parameter Integer n = 3 "Number of phases";
  parameter Modelica.Units.SI.Inertia J(min=0) = 2 "Moment of inertia";

  parameter Modelica.Units.SI.Resistance R_s=0.013 "Electric resistance of stator";
  parameter Modelica.Units.SI.Resistance R_r=0.009 "Electric resistance of rotor";
  parameter Modelica.Units.SI.Reactance X_s=0.14 "Complex component of the impedance of stator";
  parameter Modelica.Units.SI.Reactance X_r=0.12 "Complex component of the impedance of rotor";
  parameter Modelica.Units.SI.Reactance X_m=2.4 "Complex component of the magnetizing reactance";

  Modelica.Units.SI.Torque tau_e "Electromagenetic torque of rotor";
  Modelica.Units.SI.Power pow_gap "Air gap power";

  Modelica.Blocks.Interfaces.RealInput tau_m(unit="N.m")
    "Load torque"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));

  Modelica.Blocks.Sources.RealExpression w_r(y=omega_r)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Modelica.Units.SI.Resistance Req "Equivelant resistance";
  Modelica.Units.SI.Reactance Xeq "Equivelant reactance";
  Real s(min=0,max=1) "Motor slip";
  Real v_rms "RMS voltage";

  Modelica.Blocks.Interfaces.RealOutput P(
    quantity = "Power",
    unit = "W")
    "Real power"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput Q(
    quantity = "Power",
    unit = "W")
    "Reactive power"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  BaseClasses.MotorMachineInterface torSpe(
  n=n,
  pole=pole,
  R_s=R_s,
  R_r=R_r,
  X_s=X_s,
  X_r=X_r,
  X_m=X_m)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
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

  P = if noEvent(torSpe.omega_s>0) then n*v_rms^2*Req/(Req^2+Xeq^2) else 0;
  Q = if noEvent(torSpe.omega_s>0) then n*v_rms^2*Xeq/(Req^2+Xeq^2) else 0;

  // Equations to calculate current
  i[1] = (v[2]*Q + v[1]*P)/(v[1]^2 + v[2]^2);
  i[2] = (v[2]*P - v[1]*Q)/(v[1]^2 + v[2]^2);

  connect(w_r.y, torSpe.omega_r) annotation (Line(points={{-39,-30},{-26,-30},{-26,-4},{-12,-4}},
                         color={0,0,127}));

  connect(fre.y, torSpe.f) annotation (Line(points={{-39,0},{-12,0}},                   color={0,0,127}));
  connect(Vrms.y, torSpe.V_rms) annotation (Line(points={{-39,30},{-20,30},{-20,4},{-12,4}}, color={0,0,127}));
  connect(shaft, speed.flange)
    annotation (Line(points={{100,0},{80,0}}, color={0,0,0}));
  connect(w_r.y, speed.w_ref) annotation (Line(points={{-39,-30},{40,-30},{40,0},
          {58,0}}, color={0,0,127}));
  annotation(defaultComponentName="mot", Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
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
          points={{-70,-90},{-60,-90},{-30,-20},{20,-20},{50,-90},{60,-90},{60,
              -100},{-70,-100},{-70,-90}})}),
    Documentation(info="<html>
<p>This is a simplified model of a squirrel cage type induction motor with electrical and mechanical interface, which is based on the per-phase equivalent circuit model for an induction motor.</p>
<p>The model inputs include load torque, as well as frequency and voltage from the power supply system at the electrical connector as the AC interface.</p>
<p>Besides the electromagnetic torque equation from <a href=\"modelica://MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface\">BaseClasses.MotorMachineInterface</a>, main governing equations used to construct the model are as follows:</p>
<p>The motor-load torque balance equation:</p>
<p align=\"center\" style=\"font-style:italic;\">dW<sub>r</sub>&nbsp;/dt&nbsp;=&nbsp;(tau<sub>e</sub>&nbsp;-&nbsp;tau<sub>m</sub>)&nbsp;/&nbsp;J</p>
<p>Where, the <i>W<sub>r</sub></i> is angular velocity of rotor [rad/s], <i>tau<sub>e</sub></i> is electromagnetizing torque generated by motor [N.m], and <i>tau<sub>m</sub></i> is load torque [N.m], <i>J</i> is motor inertia [kg.m2].
</p>
<p>The active power consumped by the motor:</p>
<p align=\"center\" style=\"font-style:italic;\">P&nbsp;=&nbsp;n&nbsp;*&nbsp;(V<sub>rms</sub>)<sup>2</sup>&nbsp;*&nbsp;R<sub>eq</sub>&nbsp;/&nbsp;[(R<sub>eq</sub>)<sup>2</sup>&nbsp;+&nbsp;(X<sub>eq</sub>)<sup>2</sup>]</p>
<p>The reactive power consumped by the motor:</p>
<p align=\"center\" style=\"font-style:italic;\">P&nbsp;=&nbsp;n&nbsp;*&nbsp;(V<sub>rms</sub>)<sup>2</sup>&nbsp;*&nbsp;X<sub>eq</sub>&nbsp;/&nbsp;[(R<sub>eq</sub>)<sup>2</sup>&nbsp;+&nbsp;(X<sub>eq</sub>)<sup>2</sup>]</p>
<p><i>R<sub>eq</sub></i> and <i>X<sub>eq</sub></i> are the equivalent resistance and reactance of induction motor per-phase equivalent circuit, can be calculated as follows: </p>
<p align=\"center\" style=\"font-style:italic;\">R<sub>eq</sub>&nbsp;=&nbsp;R<sub>s</sub>&nbsp;+&nbsp;(X<sub>m</sub>)<sup>2</sup>&nbsp;*&nbsp;R<sub>r</sub>&nbsp;*&nbsp;s&nbsp;/&nbsp;[(R<sub>r</sub>)<sup>2</sup>&nbsp;+&nbsp;(s)<sup>2</sup>&nbsp;*&nbsp;(X<sub>r</sub>&nbsp;+&nbsp;X<sub>m</sub>)<sup>2</sup>]</p>
<p align=\"center\" style=\"font-style:italic;\">X<sub>eq</sub>&nbsp;=&nbsp;X<sub>s</sub>&nbsp;+&nbsp;X<sub>m</sub>&nbsp;*&nbsp;[(R<sub>r</sub>)<sup>2</sup>&nbsp;+&nbsp;(s&nbsp;*&nbsp;X<sub>r</sub>)<sup>2</sup>&nbsp;+&nbsp;(s)<sup>2</sup>&nbsp;*&nbsp;X<sub>r</sub>&nbsp;*&nbsp;X<sub>m</sub>]&nbsp;/&nbsp;[(R<sub>r</sub>)<sup>2</sup>&nbsp;+&nbsp;(s)<sup>2</sup>&nbsp;*&nbsp;(X<sub>r</sub>&nbsp;+&nbsp;X<sub>m</sub>)<sup>2</sup>]</p>
<p>Where, the subscripts <i>s</i>, <i>r</i> and <i>m</i> represent the stator, rotor and magnetizing part, respectively. The ciruit diagram is referred to <a href=\"modelica://MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface\">BaseClasses.MotorMachineInterface</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>October 15, 2021, by Mingzhe Liu:<br>Refactored implementation to add mechanical interface and integrate inertia. </li>
<li>6 March 2019, by Yangyang Fu:<br>First implementation.</li>
</ul>
</html>"));
end SquirrelCage;
