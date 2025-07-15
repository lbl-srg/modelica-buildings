within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors;
model SquirrelCage
  "Squirrel cage type induction motor with electrical interface"
  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare package PhaseSystem =Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);
  replaceable parameter Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per
    constrainedby Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{60,60},
            {80,80}})));

  Real v_rms "RMS voltage";
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
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m(unit="N.m")
    "Load torque"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Continuous.Integrator int
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.RealExpression angFre(y=omega)
    "Supply voltage angular frequency"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-50,-90})));
  Modelica.Blocks.Sources.RealExpression angFre1(y=omega)
    "Supply voltage angular frequency"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-30,70})));
  Modelica.Mechanics.Rotational.Sources.Speed spe(exact=true) "Speed connector"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
    "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface torSpe(
    final P=per.P,
    final J=per.J,
    final Lr=per.Lr,
    final Ls=per.Ls,
    final Rr=per.Rr,
    final Lm=per.Lm,
    final Rs=per.Rs)
    "Calculates Electromagnetic torque of induction machine"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.SpeedBlock speBlo(J=per.J, P=per.P)
   "Calculates Speed of induction machine rotor"
   annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentBlock
    curBlo "Calculates current of induction machine rotor"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
equation
  theta_s = PhaseSystem.thetaRef(terminal.theta) "phase angle";
  omega = der(theta_s);
  v_rms=Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.RMS_Voltage(v[1],v[2]);
  i[1] = Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentCalculationD(torSpe.motMod.i_ds);
  i[2] = Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentCalculationQ(torSpe.motMod.i_qs);
  connect(int.u, angFre1.y)
    annotation (Line(points={{-2,70},{-19,70}}, color={0,0,127}));
  connect(fre.y, torSpe.f)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  connect(Vrms.y, torSpe.V_rms) annotation (Line(points={{-39,20},{-20,20},{-20,
          6},{-12,6}}, color={0,0,127}));
  connect(spe.flange, shaft)
    annotation (Line(points={{70,0},{100,0}}, color={0,0,0}));
  connect(angFre.y, speBlo.omega) annotation (Line(points={{-39,-90},{-20,-90},{
          -20,-76},{-12,-76}},color={0,0,127}));
  connect(int.y, curBlo.wt) annotation (Line(points={{21,70},{50,70},{50,48},{
          58,48}}, color={0,0,127}));
  connect(tau_m, speBlo.tau_m) annotation (Line(points={{-120,-70},{-12,-70}},
          color={0,0,127}));
  connect(speBlo.omega_r, spe.w_ref) annotation (Line(points={{12,-64},{30,-64},
          {30,0},{48,0}}, color={0,0,127}));
  connect(speBlo.omega_r, torSpe.omega_r) annotation (Line(points={{12,-64},{30,
          -64},{30,-40},{-20,-40},{-20,-6},{-12,-6}}, color={0,0,127}));
  connect(torSpe.tau_e, speBlo.tau_e) annotation (Line(points={{12,0},{20,0},{
          20,-20},{-30,-20},{-30,-64},{-12,-64}}, color={0,0,127}));
  connect(torSpe.i_ds, curBlo.i_ds)
    annotation (Line(points={{12,8},{20,8},{20,40},{58,40}}, color={0,0,127}));
  connect(torSpe.i_qs, curBlo.i_qs)
    annotation (Line(points={{12,5},{30,5},{30,32},{58,32}}, color={0,0,127}));
annotation(
Icon(coordinateSystem(preserveAspectRatio=true,
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
This model implements an induction motor model. The model takes the set point of load torque, 
as an input and simulates a transient simulation when the motor is operating in its
rated speed and setpoint load torque.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>
First Implementation.
</li>
</ul>
</html>"));
end SquirrelCage;
