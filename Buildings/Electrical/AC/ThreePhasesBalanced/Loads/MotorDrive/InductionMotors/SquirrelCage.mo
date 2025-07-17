within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors;
model SquirrelCage
  "Squirrel cage type induction motor with electrical interface"
  extends Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses.PartialSquirrelCage(
    final have_speCon=false,
    redeclare final Modelica.Blocks.Sources.RealExpression conVol(y=1));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tau_m(unit="N.m")
    "Load torque"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1/(2*Modelica.Constants.pi))
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(torSpe.i_ds, curBlo.i_ds)
    annotation (Line(points={{42,8},{50,8},{50,40},{58,40}}, color={0,0,127}));
  connect(torSpe.i_qs, curBlo.i_qs)
    annotation (Line(points={{42,5},{54,5},{54,32},{58,32}}, color={0,0,127}));
  connect(rmsVol.y, torSpe.V_rms) annotation (Line(points={{-59,50},{10,50},{10,
          6},{18,6}}, color={0,0,127}));
  connect(speBlo.omega_r, torSpe.omega_r) annotation (Line(points={{2,-74},{10,-74},
          {10,-6},{18,-6}}, color={0,0,127}));
  connect(torSpe.tau_e, speBlo.tau_e) annotation (Line(points={{42,0},{50,0},{
          50,-20},{-30,-20},{-30,-74},{-22,-74}}, color={0,0,127}));
  connect(tau_m, speBlo.tau_m)
    annotation (Line(points={{-120,-80},{-22,-80}}, color={0,0,127}));
  connect(volAngFre.y, speBlo.omega) annotation (Line(points={{-19,80},{0,80},{
          0,60},{-40,60},{-40,-86},{-22,-86}}, color={0,0,127}));
  connect(speBlo.omega_r, spe.w_ref) annotation (Line(points={{2,-74},{60,-74},{
          60,0},{70,0}},  color={0,0,127}));
  connect(spe.flange, shaft)
    annotation (Line(points={{92,0},{100,0}}, color={0,0,0}));
  connect(gai.y, torSpe.f)
    annotation (Line(points={{2,0},{18,0}}, color={0,0,127}));
  connect(volAngFre.y, gai.u) annotation (Line(points={{-19,80},{0,80},{0,60},{
          -40,60},{-40,0},{-22,0}}, color={0,0,127}));
  connect(volAngFre.y, int.u)
    annotation (Line(points={{-19,80},{0,80},{0,80},{18,80}}, color={0,0,127}));
  connect(int.y, curBlo.wt) annotation (Line(points={{41,80},{50,80},{50,48},{58,
          48}},    color={0,0,127}));
  connect(volPhaAng.y, volAngFre.u)
    annotation (Line(points={{-59,80},{-42,80}}, color={0,0,127}));
annotation(defaultComponentName="motDri",
    Documentation(info="<html>
<p>
This model implements an induction motor model. The model takes the set point of load torque, 
as an input and simulates a transient simulation when the motor is operating in its
rated speed and setpoint load torque.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>"));
end SquirrelCage;
