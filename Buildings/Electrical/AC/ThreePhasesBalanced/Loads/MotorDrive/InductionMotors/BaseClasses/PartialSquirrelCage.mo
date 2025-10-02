within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model PartialSquirrelCage
  "Partial model for squirrel cage type induction motor with electrical interface"
  extends Buildings.Electrical.Interfaces.PartialOnePort(
    redeclare package PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal);
  replaceable parameter Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per
    constrainedby Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
    "Record with induction machine performance data"
    annotation (choicesAllMatching=true,Placement(transformation(extent={{60,60}, {80,80}})));

  parameter Boolean have_speCon "Have the closed loop built-in speed control";

  Real v_rms "RMS voltage";
  Modelica.Units.SI.Angle theta_s "Supply voltage phase angel";
  Modelica.Units.SI.Voltage v[:] = terminal.v "Voltage vector";
  Modelica.Units.SI.Current i[:] = terminal.i "Current vector";

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.MotorMachineInterface torSpe(
    final P=per.P,
    final J=per.J,
    final Lr=per.Lr,
    final Ls=per.Ls,
    final Rr=per.Rr,
    final Lm=per.Lm,
    final Rs=per.Rs)
    "Calculates Electromagnetic torque of induction machine"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Mechanics.Rotational.Sources.Speed spe(
    exact=true) "Speed connector"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft
    "Mechanical connector"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.SpeedBlock speBlo(
    final J=per.J,
    final P=per.P)
   "Calculates Speed of induction machine rotor"
   annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentBlock curBlo
    "Calculates current of induction machine rotor"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Modelica.Blocks.Continuous.Der volAngFre "Supply voltage angular frequency"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Sources.RealExpression rmsVol(final y=v_rms) "RMS voltage"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.RealExpression volPhaAng(final y=theta_s)
    "Supply voltage phase angle"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Continuous.Integrator int "Integrator for voltage angular fequency"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  replaceable Modelica.Blocks.Sources.RealExpression conVol
    "Supply voltage phase angle"
    annotation (Placement(visible=have_speCon, transformation(extent={{-40,20},{-20,40}})));

equation
  theta_s = PhaseSystem.thetaRef(terminal.theta) "phase angle";
  v_rms=Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.RMS_Voltage(v[1],v[2]);
  if have_speCon then
    i[1] =Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentD_VFD(torSpe.motMod.i_ds,conVol.y,v_rms);
    i[2] =Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentQ_VFD(torSpe.motMod.i_qs,conVol.y,v_rms);
  else
    i[1] = Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentD(torSpe.motMod.i_ds);
    i[2] = Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.CurrentQ(torSpe.motMod.i_qs);
  end if;
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
Documentation(info="<html>
<p>
This is the base model for the induction motor model.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>"));
end PartialSquirrelCage;
