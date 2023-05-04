within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors;
model SquirrelCageDrive "Squirrel cage type induction motor with electrical interface and built-in speed control"
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
  parameter Boolean have_controller = true
    "Set to true for enableing PID control";
  parameter Modelica.Blocks.Types.SimpleController 
  controllerType=Modelica.Blocks.Types.SimpleController.PI
     "Type of controller"
      annotation (Dialog(tab="Advanced", 
                         group="Controller",
                         enable=have_controller));
  parameter Real k(min=0) = 1
     "Gain of controller"
      annotation (Dialog(tab="Advanced",
                         group="Controller", 
                         enable=have_controller));
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=0.5
     "Time constant of Integrator block"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=have_controller and 
  controllerType == Modelica.Blocks.Types.SimpleController.PI or 
  controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0) = 0.1
     "Time constant of Derivative block"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=have_controller and 
  controllerType == Modelica.Blocks.Types.SimpleController.PD or 
  controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
    "Upper limit of output"
     annotation (Dialog(tab="Advanced", 
                       group="Controller", 
                       enable=have_controller));
  parameter Real yMin=0
    "Lower limit of output"
     annotation (Dialog(tab="Advanced", 
                       group="Controller",
                       enable=have_controller));
  parameter Real wp(min=0) = 1
    "Set-point weight for Proportional block (0..1)"
     annotation (Dialog(tab="Advanced",
                        group="Controller", 
                        enable=have_controller));
  parameter Real wd(min=0) = 0
    "Set-point weight for Derivative block (0..1)"
     annotation(Dialog(tab="Advanced", 
                        group="Controller", 
                        enable=have_controller and 
  controllerType==.Modelica.Blocks.Types.SimpleController.PD or 
  controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(tab="Advanced", 
                       group="Controller", 
                       enable=have_controller and 
   controllerType==.Modelica.Blocks.Types.SimpleController.PI or 
   controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
      annotation(Dialog(tab="Advanced", 
                        group="Controller", 
                        enable=have_controller and 
    controllerType==.Modelica.Blocks.Types.SimpleController.PD or 
    controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Boolean reverseActing = true
    "Set to true for reverse acting, or false for direct acting control action"
    annotation (Dialog(tab="Advanced", 
                       group="Controller",
                       enable=have_controller));
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

  final Modelica.Blocks.Sources.RealExpression w_r(y=omega_r)
    "Rotor speed"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  final Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms) "RMS voltage"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.Continuous.LimPID VFD(
    final controllerType=controllerType,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final k=k,
    final Ti=Ti,
    final reverseActing=true) if have_controller
    "PI controller as variable frequency drive"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  final Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
    "Supply voltage frequency"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Math.Product VFDfre "Controlled frequency"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  final Modelica.Blocks.Sources.RealExpression NorCoe(y=1) if not have_controller
    "Coefficient used in uncontrolled case"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
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
    final X_m=X_m) "Motor machine interface"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Math.Product VFDvol "Controlled voltage"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Modelica.Blocks.Interfaces.RealInput setPoi if have_controller "Set point of control target"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,70}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Modelica.Blocks.Interfaces.RealInput mea if have_controller "Measured value of control target"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40}),
        iconTransformation(
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

  P = if noEvent(torSpe.omega_s>0) then 3*v_rms^2*Req/(Req^2+Xeq^2) else 0;
  Q = if noEvent(torSpe.omega_s>0) then 3*v_rms^2*Xeq/(Req^2+Xeq^2) else 0;

  // Equations to calculate current
  i[1] = (v[2]*Q + v[1]*P)/(v[1]^2 + v[2]^2);
  i[2] = (v[2]*P - v[1]*Q)/(v[1]^2 + v[2]^2);

  connect(w_r.y, torSpe.omega_r) annotation (Line(points={{-19,-50},{-16,-50},{
          -16,-4},{-12,-4}},  color={0,0,127}));
  connect(setPoi, VFD.u_s) annotation (Line(points={{-120,70},{-88,70},{-88,0},
          {-82,0}}, color={0,0,127}));
  connect(fre.y, VFDfre.u1) annotation (Line(points={{-59,-70},{-48,-70},{-48,6},
          {-42,6}}, color={0,0,127}));
  connect(VFD.y, VFDfre.u2) annotation (Line(points={{-59,0},{-50,0},{-50,-6},
          {-42,-6}}, color={0,0,127}));
  connect(VFDfre.y, torSpe.f) annotation (Line(points={{-19,0},{-12,0}},
          color={0,0,127}));
  connect(NorCoe.y, VFDfre.u2) annotation (Line(points={{-59,-50},{-46,-50},
          {-46,-6},{-42,-6}}, color={0,0,127}));
  connect(mea, VFD.u_m) annotation (Line(points={{-120,40},{-92,40},{-92,-20},
          {-70,-20},{-70,-12}}, color={0,0,127}));
  connect(shaft,speed. flange) annotation (Line(points={{100,0},{80,0}},
          color={0,0,0}));
  connect(w_r.y, speed.w_ref) annotation (Line(points={{-19,-50},{40,-50},{40,0},
          {58,0}}, color={0,0,127}));
  connect(Vrms.y, VFDvol.u1) annotation (Line(points={{-59,50},{-48,50},{-48,56},
          {-42,56}}, color={0,0,127}));
  connect(VFD.y, VFDvol.u2) annotation (Line(points={{-59,0},{-50,0},{-50,44},
          {-42,44}}, color={0,0,127}));
  connect(VFDvol.y, torSpe.V_rms) annotation (Line(points={{-19,50},{-16,50},{
          -16,4},{-12,4}},  color={0,0,127}));
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
        defaultComponentName="motDri",
    Documentation(info="<html>
<p>
This model implements an induction motor model with a built-in idealized 
frequency control that tracks the set point and adjust the input frequency of 
motor.
</p>
<p>
The model is identical to 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.
SquirrelCage</a>, except that it takes the set point, as an input and adjust 
the motor torque output to meet the set point. This set point is maintained 
if the motor allows sufficient torque to meet the load requirement. The built-in 
control is an ideal speed controller, implemented using a PI controller. 
The controller adjusts the torque output of the motor to meet the set point 
within its work area.
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
end SquirrelCageDrive;
