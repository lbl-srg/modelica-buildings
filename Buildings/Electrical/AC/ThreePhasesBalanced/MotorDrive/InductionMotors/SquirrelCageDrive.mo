within Buildings.Electrical.AC.ThreePhasesBalanced.MotorDrive.InductionMotors;
model SquirrelCageDrive "Squirrel cage type induction motor with electrical interface and built-in speed control"
  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare package PhaseSystem =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);

  parameter Integer pole=4 "Number of pole pairs";
  parameter Integer n=3 "Number of phases";
  parameter Modelica.Units.SI.Inertia J(min=0)=2
    "Moment of inertia";
  parameter Modelica.Units.SI.Resistance R_s=0.013
    "Electric resistance of stator";
  parameter Modelica.Units.SI.Resistance R_r=0.009
    "Electric resistance of rotor";
  parameter Modelica.Units.SI.Reactance X_s=0.14
    "Complex component of the impedance of stator";
  parameter Modelica.Units.SI.Reactance X_r=0.12
    "Complex component of the impedance of rotor";
  parameter Modelica.Units.SI.Reactance X_m=2.4
    "Complex component of the magnetizing reactance";
  parameter Boolean use_PID = true
    "set to true for enableing PID control";

  Real s(min=0,max=1) "Motor slip";
  Real v_rms "RMS voltage";
  Modelica.Units.SI.Torque tau_e
    "Electromagenetic torque of rotor";
  Modelica.Units.SI.Power pow_gap
    "Air gap power";
  Modelica.Units.SI.Angle theta_s
    "Supply voltage phase angel";
  Modelica.Units.SI.AngularVelocity omega
    "Supply voltag angular frequency";
  Modelica.Units.SI.AngularVelocity omega_r
    "Rotor angular frequency";
  Modelica.Units.SI.Voltage v[:] = terminal.v
    "Voltage vector";
  Modelica.Units.SI.Current i[:] = terminal.i
    "Current vector";
  Modelica.Units.SI.Resistance Req "Equivelant resistance";
  Modelica.Units.SI.Reactance Xeq "Equivelant reactance";

  Modelica.Blocks.Sources.RealExpression w_r(y=omega_r)
    "Rotor speed"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms) "RMS voltage"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.Continuous.LimPID VFD(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0.2,
    k=0.1,
    Ti=60,
    reverseActing=true) if use_PID
    annotation (Placement(transformation(extent={{-80,-10},
            {-60,10}})));
  Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi)) "Supply voltage frequency"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Math.Product VFDfre "Controlled frequency"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression NorCoe(y=1) if not use_PID "Coefficient used in uncontrolled case"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true) "Speed connector"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  BaseClasses.MotorMachineInterface torSpe(
  final n=n,
  final pole=pole,
  final R_s=R_s,
  final R_r=R_r,
  final X_s=X_s,
  final X_r=X_r,
  final X_m=X_m)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Product VFDvol "Controlled voltage"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Modelica.Blocks.Interfaces.RealInput setPoi if use_PID "Set point of control target"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,70}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Modelica.Blocks.Interfaces.RealInput mea if use_PID "Measured value of control target"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
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
  Modelica.Blocks.Interfaces.RealOutput P(final quantity = "Power", final unit = "W")
    "Real power"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput Q(final quantity = "Power", final unit = "var")
    "Reactive power"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,20},{140,60}})));

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

  P = if noEvent(torSpe.omega_s>0) then n*v_rms^2*Req/(Req^2+Xeq^2) else 0;
  Q = if noEvent(torSpe.omega_s>0) then n*v_rms^2*Xeq/(Req^2+Xeq^2) else 0;

  // Equations to calculate current
  i[1] = (v[2]*Q + v[1]*P)/(v[1]^2 + v[2]^2);
  i[2] = (v[2]*P - v[1]*Q)/(v[1]^2 + v[2]^2);

  connect(w_r.y, torSpe.omega_r) annotation (Line(points={{-19,-50},{-16,-50},{-16,-4},{-12,-4}},
                         color={0,0,127}));

  connect(setPoi, VFD.u_s) annotation (Line(points={{-120,70},{-92,70},{-92,0},
          {-82,0}},color={0,0,127}));
  connect(fre.y, VFDfre.u1) annotation (Line(points={{-59,-70},{-48,-70},{-48,6},
          {-42,6}},color={0,0,127}));
  connect(VFD.y, VFDfre.u2) annotation (Line(points={{-59,0},{-50,0},{-50,-6},{
          -42,-6}},
                color={0,0,127}));
  connect(VFDfre.y, torSpe.f)
    annotation (Line(points={{-19,0},{-12,0}},
                                            color={0,0,127}));
  connect(NorCoe.y, VFDfre.u2) annotation (Line(points={{-59,-50},{-46,-50},{
          -46,-6},{-42,-6}},
                         color={0,0,127}));
  connect(mea, VFD.u_m) annotation (Line(points={{-120,40},{-92,40},{-92,-20},{
          -70,-20},{-70,-12}}, color={0,0,127}));
  connect(shaft,speed. flange)
    annotation (Line(points={{100,0},{80,0}}, color={0,0,0}));
  connect(w_r.y, speed.w_ref) annotation (Line(points={{-19,-50},{40,-50},{40,0},
          {58,0}}, color={0,0,127}));
  connect(Vrms.y, VFDvol.u1) annotation (Line(points={{-59,50},{-48,50},{-48,56},
          {-42,56}}, color={0,0,127}));
  connect(VFD.y, VFDvol.u2) annotation (Line(points={{-59,0},{-50,0},{-50,44},{
          -42,44}}, color={0,0,127}));
  connect(VFDvol.y, torSpe.V_rms) annotation (Line(points={{-19,50},{-16,50},{
          -16,4},{-12,4}}, color={0,0,127}));
  annotation(defaultComponentName="motDri", Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
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
<p>This model implements an induction motor model with built-in idealized frequency control that tracks the set point and adjust the input frequency of motor.</p>
<p>The model is identical to <a href=\"modelica://MotorDrive.InductionMotors.SquirrelCage\">MotorDrive.InductionMotors.SquirrelCage</a>, except that it takes as an input the set point and adjust the motor torque output to meet the set point. This set point is maintained if the motor allow sufficient torque to meet the load side requirement. </p>
<p>The built-in control is an idealization of a speed controller, implemented by a PI controller and adjusts the torque output of the motor to meet the set point within its work area.</p>
</html>", revisions="<html>
<ul>
<li>October 15, 2021, by Mingzhe Liu:<br>Refactored implementation to add mechanical interface and integrate inertia. </li>
<li>6 March 2019, by Yangyang Fu:<br>First implementation.</li>
</ul>
</html>"));
end SquirrelCageDrive;
