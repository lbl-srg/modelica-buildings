within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors1.Examples;
model SquirrelCageDrive
  "This example shows how to use the squirrel cage induction motor with closed loop built-in speed control"

  extends Modelica.Icons.Example;

  Sources.Grid                                             sou(f=50, V=220*1.414)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.RealExpression mea(y=motDri.speBlo.N)
    "Measured value of control target"
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
  Modelica.Blocks.Sources.Step Speed_ref(
    height=650,
    offset=800,
    startTime=2.5) "Set point of control target"
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive
    motDri(have_controller=true)
    annotation (Placement(transformation(extent={{-4,0},{20,20}})));
  Real Efficiency,Loss,slip,Ns;
  Modelica.Blocks.Sources.Constant Tau_m(k=26) "Load Torque"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
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
    annotation (Line(points={{10,20},{10,40}}, color={0,120,120}));
  connect(Speed_ref.y, motDri.setPoi)
    annotation (Line(points={{-39,18},{-5.8,18}}, color={0,0,127}));
  connect(mea.y, motDri.mea) annotation (Line(points={{-39,-26},{-28,-26},{-28,12},
          {-5.8,12}}, color={0,0,127}));
  connect(Tau_m.y, motDri.tau_m) annotation (Line(points={{-39,-50},{-10,
          -50},{-10,2},{-5.8,2}}, color={0,0,127}));
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
end SquirrelCageDrive;
