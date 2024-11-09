within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.Examples;
model SquirrelCageDrive_OnOff
  "This example shows how to use the squirrel cage induction motor with closed loop built-in speed control with boolean control"

  extends Modelica.Icons.Example;

  Sources.Grid                                             sou(f=50, V=220*1.414)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.RealExpression mea(y=motDri.speBlo.N)
    "Measured value of control target"
    annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
  Modelica.Blocks.Sources.Step Speed_ref(
    height=650,
    offset=800,
    startTime=2.5) "Set point of control target"
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  Real Efficiency,Loss,slip,Ns;
  Modelica.Blocks.Sources.Constant Tau_m(k=0) "Load Torque"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive_OnOff
    motDri(have_controller=false)
    annotation (Placement(transformation(extent={{-2,0},{22,20}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=true)
    annotation (Placement(transformation(extent={{-86,-36},{-66,-16}})));
equation
 Ns = (120*sou.f)/motDri.P;
 slip =((Ns-motDri.speBlo.N)/Ns);
 Loss = abs(sou.P.real - motDri.pow_gap);
if (sou.P.real) <=0 then
   Efficiency = 0;
else
   Efficiency = ((motDri.pow_gap)/(sou.P.real))*100;
end if;

  connect(motDri.terminal, sou.terminal)
    annotation (Line(points={{12,20},{10,20},{10,40}}, color={0,120,120}));
  connect(motDri.setPoi, Speed_ref.y)
    annotation (Line(points={{-4,18},{-39,18}}, color={0,0,127}));
  connect(mea.y, motDri.mea) annotation (Line(points={{-39,-8},{-32,-8},{
          -32,12},{-4,12}}, color={0,0,127}));
  connect(Tau_m.y, motDri.tau_m) annotation (Line(points={{-39,-50},{-10,
          -50},{-10,2},{-4,2}}, color={0,0,127}));
  connect(booleanConstant.y, motDri.u) annotation (Line(points={{-65,-26},{
          -12,-26},{-12,6},{-4,6}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=4,
      Interval=0.02,
      __Dymola_Algorithm="Dassl"),
    Documentation(revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>",
      info="<html>
An example of induction motor drive with closed loop variable speed controller.
</html>"));
end SquirrelCageDrive_OnOff;
