within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors;
model SquirrelCage
  "Squirrel cage type induction motor with electrical interface"
  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare package PhaseSystem =Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);
  replaceable parameter Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per
    constrainedby Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{52,60},{72,80}})));

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
    annotation (Placement(transformation(extent={{-64,10},{-44,30}})));

  final Modelica.Blocks.Sources.RealExpression fre(y=omega/(2*Modelica.Constants.pi))
    "Supply voltage frequency"
    annotation (Placement(transformation(extent={{-64,-8},{-44,12}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m(unit="N.m")
    "Load torque"
    annotation (Placement(transformation(
        extent={{-140,-100},{-100,-60}}),
        iconTransformation(
        extent={{-140,-100},{-100,-60}})));

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
      Placement(transformation(extent={{-10,-12},{10,12}}, origin={-56,-58})));
  Modelica.Blocks.Sources.RealExpression angFre(y=omega)
    "Supply voltage angular frequency" annotation (Placement(transformation(
          extent={{-10,-12},{10,12}}, origin={-32,-80})));
  Modelica.Blocks.Sources.RealExpression angFre1(y=omega)
    "Supply voltage angular frequency" annotation (Placement(transformation(
          extent={{-10,-12},{10,12}}, origin={-30,70})));
  Modelica.Mechanics.Rotational.Sources.Speed speed(exact=true)
    "Speed connector"
    annotation (Placement(transformation(extent={{64,-8},{80,8}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
    "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  BaseClasses.MotorMachineInterface torSpe(
    P=per.P,
    J=per.J,
    Lr=per.Lr,
    Ls=per.Ls,
    Rr=per.Rr,
    Lm=per.Lm,
    Rs=per.Rs) "Calculates Electromagnetic torque of induction machine" annotation (Placement(transformation(extent={{2,-6},{16,8}})));
  BaseClasses.SpeedBlock speBlo(J=per.J, P=per.P)
   "Calculates Speed of induction machine rotor" annotation (Placement(transformation(extent={{-4,-76},{16,-56}})));
  BaseClasses.CurrentBlock current_Block
   "Calculates current of induction machine rotor" annotation (Placement(transformation(extent={{66,28},{86,48}})));
equation
theta_s = PhaseSystem.thetaRef(terminal.theta) "phase angle";
omega = der(theta_s);
v_rms=Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.RMS_Voltage(v[1],v[2]);
i[1] = Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentCalculationD(torSpe.motMod.i_ds);
i[2] = Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentCalculationQ(torSpe.motMod.i_qs);
  connect(integrator.u, angFre1.y) annotation (Line(points={{-4,70},{-19,70}},
                         color={0,0,127}));
  connect(fre.y, torSpe.f)
    annotation (Line(points={{-43,2},{-22,2},{-22,1},{0.6,1}},
                                               color={0,0,127}));
  connect(Vrms.y, torSpe.V_rms) annotation (Line(points={{-43,20},{-26,20},{-26,
          6},{0,6},{0,5.2},{0.6,5.2}},
                       color={0,0,127}));
  connect(speed.flange, shaft)
    annotation (Line(points={{80,0},{100,0}}, color={0,0,0}));
  connect(angFre.y, speBlo.omega) annotation (Line(points={{-21,-80},{-12,-80},{
          -12,-72},{-6,-72}}, color={0,0,127}));
  connect(integrator.y, current_Block.wt) annotation (Line(points={{19,70},{46,70},
          {46,54},{64,54},{64,46}}, color={0,0,127}));
  connect(i_ds.y, current_Block.i_ds)
    annotation (Line(points={{41,40},{41,38},{64,38}}, color={0,0,127}));
  connect(i_qs.y, current_Block.i_qs) annotation (Line(points={{41,24},{56,24},{
          56,30},{64,30}}, color={0,0,127}));
  connect(eleTor.y, speBlo.tau_e) annotation (Line(points={{-45,-58},{-42,-58},
          {-42,-60},{-6,-60}}, color={0,0,127}));
  connect(tau_m, speBlo.tau_m) annotation (Line(points={{-120,-80},{-60,-80},{
          -60,-66},{-6,-66}}, color={0,0,127}));
  connect(speBlo.omega_r, speed.w_ref) annotation (Line(points={{18,-60},{48,
          -60},{48,0},{62.4,0}},      color={0,0,127}));
  connect(torSpe.omega_r, speed.w_ref) annotation (Line(points={{0.6,-3.2},{-8,
          -3.2},{-8,-40},{48,-40},{48,0},{62.4,0}},                   color={0,
          0,127}));
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
