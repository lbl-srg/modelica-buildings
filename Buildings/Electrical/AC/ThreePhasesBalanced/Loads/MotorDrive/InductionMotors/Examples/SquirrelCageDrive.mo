within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Examples;
model SquirrelCageDrive
  "This example shows how to use the squirrel cage induction motor with closed loop built-in speed control"

  extends Modelica.Icons.Example;

  Sources.Grid                                             sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.RealExpression mea(y=motDri.speBlo.N)
    "Measured value of control target"
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
  Modelica.Blocks.Sources.Step Speed_ref(
    height=1500,
    offset=0,
    startTime=0)   "Set point of control target"
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive
    motDri(
    redeclare
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      per,
    have_controller=true,
    k=0.1,
    Ti=0.1)
    annotation (Placement(transformation(extent={{-2,0},{22,20}})));
  Real Efficiency,Loss,slip,Ns;
  Modelica.Blocks.Sources.Step Speed_ref1(
    height=26.5,
    offset=0,
    startTime=1)   "Set point of control target"
    annotation (Placement(transformation(extent={{-58,-76},{-38,-56}})));
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
    annotation (Line(points={{12,20},{12,30},{10,30},{10,40}},
                                               color={0,120,120}));
  connect(Speed_ref.y, motDri.setPoi)
    annotation (Line(points={{-39,18},{-3.8,18}}, color={0,0,127}));
  connect(mea.y, motDri.mea) annotation (Line(points={{-39,-26},{-28,-26},{-28,
          12},{-3.8,12}},
                      color={0,0,127}));
  connect(Speed_ref1.y, motDri.tau_m) annotation (Line(points={{-37,-66},{-10,
          -66},{-10,2},{-3.8,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=4,
      Tolerance=0.001,
      __Dymola_Algorithm="Dassl"),
    Documentation(revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>",
      info="<html>
An example of induction motor drive with closed loop variable speed controller.
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Examples/SquirrelCageDrive.mos"
        "Simulate and Plot"));
end SquirrelCageDrive;
