within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors;
model SquirrelCageDrive
  "Squirrel cage type induction motor with electrical interface and closed loop built-in speed control"
  extends Buildings.Electrical.Interfaces.PartialOnePort(
   redeclare package PhaseSystem =
        Buildings.Electrical.PhaseSystems.OnePhase,
   redeclare replaceable Interfaces.Terminal_n terminal);
     replaceable parameter Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per
    constrainedby
    Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{52,60},{72,80}})));
  parameter Integer P=per.P "Number of poles";
  parameter Real J=per.J "Moment of inertia";
  parameter Real Lr=per.Lr "Rotor inductance [H]";
  parameter Real Ls=per.Ls "Stator inductance [H]";
  parameter Real Lm=per.Lm "Mutual inductance [H]";
  parameter Real Rr=per.Rr "Rotor resistance [ohm]";
  parameter Real Rs=per.Rs "Stator resistance [ohm]";

  //-----------------------------------------------
  // parameter Integer P=4      "Number of poles";
  //parameter Real J=0.17    "Moment of inetia";
  //parameter Real Lr=0.1458    "Rotor inductance [H]";
  //parameter Real Ls=0.1457    "Stator inductance [H]";
  //parameter Real Rr=1.145   "Rotor resistance [ohm]";
  //parameter Real Lm=0.1406   "Mutual inductance [H]";
  //parameter Real Rs=1   "Stator resistance [ohm]";
  //-------------------------------------------------

  parameter Boolean have_controller = true
    "Set to true for enable PID control, False for simple speed control";
  parameter Boolean reverseActing=true
     "Set to true for reverseActing in heating and set to false in cooling mode";
  parameter Modelica.Blocks.Types.SimpleController
  controllerType=Modelica.Blocks.Types.SimpleController.PI
     "Type of controller"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=true));
  parameter Real k(min=0) = 1
     "Gain of controller"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=true));
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=0.5
     "Time constant of Integrator block"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=true and
  controllerType == Modelica.Blocks.Types.SimpleController.PI or
  controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0) = 0.1
     "Time constant of Derivative block"
      annotation (Dialog(tab="Advanced",
                         group="Controller",
                         enable=true and
  controllerType == Modelica.Blocks.Types.SimpleController.PD or
  controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
    "Upper limit of output"
     annotation (Dialog(tab="Advanced",
                       group="Controller",
                       enable=true));
  parameter Real yMin=0
    "Lower limit of output"
     annotation (Dialog(tab="Advanced",
                       group="Controller",
                       enable=true));

  Real v_rms "RMS voltage";
  Real i_rms "RMS current";
  Real  pow_gap;
  Modelica.Units.SI.Angle theta_s "Supply voltage phase angel";
  Modelica.Units.SI.AngularVelocity omega "Supply voltage angular frequency";
  Modelica.Units.SI.Voltage v[:] = terminal.v "Voltage vector";
  Modelica.Units.SI.Current i[:] = terminal.i "Current vector";

  final Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms) "RMS voltage"
    annotation (Placement(transformation(extent={{-76,46},{-56,66}})));
  final Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
    "Supply voltage frequency"
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Modelica.Blocks.Math.Product VFDfre "Controlled frequency"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Math.Product VFDvol "Controlled voltage"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Modelica.Blocks.Interfaces.RealInput setPoi "Set point of control target"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-158,70}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-158,80})));
  Modelica.Blocks.Interfaces.RealInput mea "Measured value of control target"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-158,20}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-158,20})));
  Modelica.Blocks.Interfaces.RealInput tau_m(unit="N.m")
    "Load torque"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-158,-80}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-158,-80})));

  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{-2,60},{18,80}})));
  Modelica.Blocks.Sources.RealExpression i_ds(y=torSpe.motMod.i_ds)
                                                             annotation (
      Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,40})));
  Modelica.Blocks.Sources.RealExpression i_qs(y=torSpe.motMod.i_qs)
                                                             annotation (
      Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,24})));
  Modelica.Blocks.Sources.RealExpression angFre(y=switch1.y*omega)
    "Supply voltage angular frequency" annotation (Placement(transformation(
          extent={{-10,-12},{10,12}}, origin={-24,-88})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
    "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(
    useSupport=false,                               exact=true,
    phi(fixed=true))
    "Speed connector"
    annotation (Placement(transformation(extent={{64,-8},{80,8}})));
  Modelica.Blocks.Sources.RealExpression angFre1(y=switch1.y*omega)
    "Supply voltage angular frequency" annotation (Placement(transformation(
          extent={{-10,-12},{10,12}}, origin={-66,70})));

  Modelica.Blocks.Math.Gain VFD_Equivalent_Freq(k=P/120)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Controls.Continuous.LimPID VFD(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    final Td=Td*2,
    final yMax=yMax,
    final yMin=yMin,
    final k=0.05*k,
    final Ti=15*Ti,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    final reverseActing=reverseActing)
    "PI controller as variable frequency drive"
    annotation (Placement(transformation(extent={{-102,14},{-82,34}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-62,-14},{-42,6}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=have_controller)
    annotation (Placement(transformation(extent={{-118,-14},{-98,6}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=setPoi/(120*per.Freq/
        per.P))
    annotation (Placement(transformation(extent={{-120,-28},{-100,-8}})));
  BaseClasses.CurrentBlock current_Block
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  BaseClasses.MotorMachineInterface torSpe(
    P=P,
    J=J,
    Lr=Lr,
    Ls=Ls,
    Rr=Rr,
    Lm=Lm,
    Rs=Rs) annotation (Placement(transformation(extent={{18,-14},{32,0}})));
  BaseClasses.SpeedBlock speBlo(J=J, P=P)
    annotation (Placement(transformation(extent={{26,-78},{46,-58}})));
equation
  // Assign values for motor model calculation from electrical interface
  theta_s = PhaseSystem.thetaRef(terminal.theta);
  omega = der(theta_s);
  v_rms=sqrt(v[1]^2+v[2]^2); // Equations to calculate current
  i[1] = 2*(sqrt(2)/sqrt(3))*torSpe.motMod.i_ds;
  i[2] =(sqrt(3)/sqrt(2))*torSpe.motMod.i_qs;
  i_rms=sqrt(i[1]^2+i[2]^2);
  pow_gap = speBlo.N/9.55*torSpe.tau_e;

  connect(Vrms.y, VFDvol.u1) annotation (Line(points={{-55,56},{-28,56},{-28,36},
          {-22,36}}, color={0,0,127}));
  connect(torSpe.V_rms, VFDvol.y) annotation (Line(points={{12,-2},{12,30},{1,
          30}},          color={0,0,127}));
  connect(torSpe.f, VFDfre.y)
    annotation (Line(points={{16,-8},{10.0714,-8},{10.0714,-10},{1,-10}},
                                               color={0,0,127}));
  connect(speBlo.tau_m, tau_m) annotation (Line(points={{24,-68},{-132,-68},{
          -132,-80},{-158,-80}},
                            color={0,0,127}));
  connect(angFre1.y, integrator.u) annotation (Line(points={{-55,70},{-4,70}},
                                 color={0,0,127}));
  connect(speBlo.omega, angFre.y) annotation (Line(points={{24,-74},{-8,-74},{
          -8,-88},{-13,-88}},                 color={0,0,127}));
  connect(VFD_Equivalent_Freq.u, setPoi)
    annotation (Line(points={{-122,70},{-158,70}}, color={0,0,127}));
  connect(VFD.u_s, setPoi) annotation (Line(points={{-104,24},{-132,24},{
          -132,70},{-158,70}}, color={0,0,127}));
  connect(VFD.u_m, mea) annotation (Line(points={{-92,12},{-92,6},{-132,6},
          {-132,20},{-158,20}}, color={0,0,127}));
  connect(speed.flange, shaft)
    annotation (Line(points={{80,0},{100,0}}, color={0,0,0}));
  connect(torSpe.omega_r, speBlo.omega_r) annotation (Line(points={{12,-14},{4,
          -14},{4,-26},{52,-26},{52,-61.9},{47.9,-61.9}},color={0,0,127}));
  connect(speBlo.omega_r1, speed.w_ref) annotation (Line(points={{47.9,-68.3},{
          47.9,-68},{56,-68},{56,0},{62.4,0}},          color={0,0,127}));
  connect(fre.y, VFDfre.u2)
    annotation (Line(points={{-49,-50},{-28,-50},{-28,-16},{-22,-16}},
                                                 color={0,0,127}));
  connect(VFDfre.u1, VFDvol.u2) annotation (Line(points={{-22,-4},{-28,-4},{-28,
          24},{-22,24}},
                     color={0,0,127}));
  connect(torSpe.tau_e, speBlo.tau_e) annotation (Line(points={{34,-8},{50,-8},
          {50,-42},{16,-42},{16,-62},{24,-62}},
        color={0,0,127}));
  connect(switch1.y, VFDvol.u2) annotation (Line(points={{-41,-4},{-28,-4},{-28,
          24},{-22,24}}, color={0,0,127}));
  connect(switch1.u1, VFD.y) annotation (Line(points={{-64,4},{-74,4},{-74,24},{
          -81,24}}, color={0,0,127}));
  connect(booleanExpression.y, switch1.u2)
    annotation (Line(points={{-97,-4},{-64,-4}}, color={255,0,255}));
  connect(realExpression.y, switch1.u3) annotation (Line(points={{-99,-18},{-72,
          -18},{-72,-12},{-64,-12}}, color={0,0,127}));
  connect(integrator.y, current_Block.wt) annotation (Line(points={{19,70},{46,
          70},{46,48},{58,48}}, color={0,0,127}));
  connect(i_ds.y, current_Block.i_ds)
    annotation (Line(points={{41,40},{58,40}}, color={0,0,127}));
  connect(i_qs.y, current_Block.i_qs) annotation (Line(points={{41,24},{52,24},
          {52,32},{58,32}}, color={0,0,127}));
 annotation(Icon(coordinateSystem(preserveAspectRatio=true,
        extent={{-140,-100},{100,100}}), graphics={
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
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.SquirrelCage\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.
SquirrelCage</a>, except that it takes the set point, as an input and adjust 
the motor torque output to meet the set point. This set point is maintained 
if the motor allows sufficient torque to meet the load requirement. The built-in 
control is an ideal speed controller, implemented using a PI controller. 
The controller adjusts the torque output of the motor to meet the set point 
within its work area.
</p>
</html>", revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-100},{100,100}})));
end SquirrelCageDrive;
