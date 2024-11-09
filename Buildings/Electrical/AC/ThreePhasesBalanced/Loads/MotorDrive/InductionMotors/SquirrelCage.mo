within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1;
model SquirrelCage
  "Squirrel cage type induction motor with electrical interface"
  extends Buildings.Electrical.Interfaces.PartialOnePort(
   redeclare package PhaseSystem =
        Buildings.Electrical.PhaseSystems.OnePhase,
   redeclare replaceable Interfaces.Terminal_n terminal);
   replaceable parameter Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.Data.Generic per
    constrainedby
    Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.Data.Generic
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
            Real i_rms "RMS current";
            Real v_rms "RMS voltage";
            Real pow_gap "Power gap";

  Modelica.Units.SI.Angle theta_s
    "Supply voltage phase angel";
  Modelica.Units.SI.AngularVelocity omega
    "Supply voltage angular frequency";

  Modelica.Units.SI.Voltage v[:] = terminal.v
    "Voltage vector";
  Modelica.Units.SI.Current i[:] = terminal.i
    "Current vector";
  final Modelica.Blocks.Sources.RealExpression Vrms(y=v_rms) "RMS voltage"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  final Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
    "Supply voltage frequency"
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));

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

  InductionMotors1.BaseClasses.CurrentBlock current_Block
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  InductionMotors1.BaseClasses.SpeedBlock speBlo(final J=J, final P=P)
    annotation (Placement(transformation(extent={{-10,-66},{10,-44}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{-2,60},{18,80}})));
  Modelica.Blocks.Sources.RealExpression i_ds(y=torSpe.motMod.i_ds)
    annotation (
      Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,40})));
  Modelica.Blocks.Sources.RealExpression i_qs(y=torSpe.motMod.i_qs)
    annotation (
      Placement(transformation(extent={{-10,-12},{10,12}}, origin={30,24})));
  Modelica.Blocks.Sources.RealExpression eleTor(y=torSpe.tau_e)
    annotation (
      Placement(transformation(extent={{-10,-12},{10,12}}, origin={-32,-42})));
  Modelica.Blocks.Sources.RealExpression angFre(y=omega)
    "Supply voltage angular frequency" annotation (Placement(transformation(
          extent={{-10,-12},{10,12}}, origin={-32,-68})));
  InductionMotors1.BaseClasses.MotorMachineInterface torSpe(
    final P=P,
    final Lm=Lm,
    final J=J,
    final Lr=Lr,
    final Ls=Ls,
    final Rr=Rr,
    final Rs=Rs)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression angFre1(y=omega)
    "Supply voltage angular frequency" annotation (Placement(transformation(
          extent={{-10,-12},{10,12}}, origin={-30,70})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true)
    "Speed connector"
    annotation (Placement(transformation(extent={{64,-8},{80,8}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
    "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  // Assign values for motor model calculation from electrical interface
  theta_s = PhaseSystem.thetaRef(terminal.theta) "phase angle";
  omega = der(theta_s);
  v_rms=sqrt(v[1]^2+v[2]^2);
  pow_gap = speBlo.N/9.55*torSpe.tau_e;
  // Equations to calculate current
  i[1] = 2*(sqrt(2)/sqrt(3))*torSpe.motMod.i_ds;
  i[2] =(sqrt(3)/sqrt(2))*torSpe.motMod.i_qs;
  i_rms=sqrt(i[1]^2+i[2]^2);
  connect(integrator.y,current_Block. wt) annotation (Line(points={{19,70},{50,70},
          {50,48},{58,48}},        color={0,0,127}));
  connect(i_ds.y, current_Block.i_ds) annotation (Line(points={{41,40},{58,40}},
                        color={0,0,127}));
  connect(i_qs.y, current_Block.i_qs)
    annotation (Line(points={{41,24},{50,24},{50,32},{58,32}},
                                               color={0,0,127}));
  connect(integrator.u, angFre1.y) annotation (Line(points={{-4,70},{-19,70}},
                         color={0,0,127}));
  connect(speBlo.tau_e, eleTor.y) annotation (Line(points={{-12,-48.4},{-21,-48.4},
          {-21,-42}},           color={0,0,127}));
  connect(speBlo.tau_m, tau_m) annotation (Line(points={{-12,-55},{-60,-55},{-60,
          -80},{-120,-80}}, color={0,0,127}));
  connect(speBlo.omega, angFre.y) annotation (Line(points={{-12,-61.6},{-16,-61.6},
          {-16,-68},{-21,-68}},           color={0,0,127}));
  connect(torSpe.omega_r, speBlo.omega_r) annotation (Line(points={{-18.5714,
          -10},{-40,-10},{-40,-18},{18,-18},{18,-48.29},{11.9,-48.29}},
                                                             color={0,0,127}));
  connect(fre.y, torSpe.f)
    annotation (Line(points={{-43,0},{-26,0},{-26,-1.42857},{-12.8571,-1.42857}},
                                               color={0,0,127}));
  connect(Vrms.y, torSpe.V_rms) annotation (Line(points={{-39,20},{-18,20},{-18,
          7.14286},{-18.5714,7.14286}},
                       color={0,0,127}));
  connect(speed.flange, shaft)
    annotation (Line(points={{80,0},{100,0}}, color={0,0,0}));
  connect(speed.w_ref, speBlo.omega_r) annotation (Line(points={{62.4,0},{40,0},
          {40,-48},{26,-48},{26,-48.29},{11.9,-48.29}}, color={0,0,127}));
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
<p>This model implements an induction motor model. The model takes the set point of load torque, 
as an input and simulates a transient simulation when the motor is operating in its rated speed and setpoint load torque. </p>
</html>", revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>
"));
end SquirrelCage;
