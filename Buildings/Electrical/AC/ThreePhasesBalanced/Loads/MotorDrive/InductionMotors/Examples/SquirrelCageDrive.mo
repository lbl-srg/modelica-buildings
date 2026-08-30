within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Examples;
model SquirrelCageDrive
  "Squirrel cage induction motor with closed loop built-in speed control"

  extends Modelica.Icons.Example;

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive motDri(
    redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per,
    reverseActing=true,
    k=0.1,
    Ti=0.1) "Induction motor with speed control"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.RealExpression mea(
    y=motDri.speBlo.N)
    "Measured value of control target"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Step Speed_ref(
    height=1500,
    offset=0,
    startTime=0)
    "Set point of control target"
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  Modelica.Blocks.Sources.Step Speed_ref1(
    height=26.5,
    offset=0,
    startTime=1)
    "Set point of control target"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

equation
  connect(motDri.terminal, sou.terminal)
    annotation (Line(points={{20,20},{20,40}}, color={0,120,120}));
  connect(Speed_ref.y, motDri.setPoi)
    annotation (Line(points={{-39,18},{8,18}},  color={0,0,127}));
  connect(mea.y, motDri.mea) annotation (Line(points={{-39,-10},{-20,-10},{-20,13},
          {8,13}},  color={0,0,127}));
  connect(Speed_ref1.y, motDri.tau_m) annotation (Line(points={{-39,-40},{-10,-40},
          {-10,7},{8,7}}, color={0,0,127}));
  connect(booleanConstant.y, motDri.on) annotation (Line(points={{-39,-80},{0,-80},
          {0,1},{8,1}}, color={255,0,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
  coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6,StartTime=0,StopTime=2),
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Examples/SquirrelCageDrive.mos"
      "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>", info="<html>
<p>
An example of induction motor drive with closed loop variable speed controller.
</p>
</html>"));
end SquirrelCageDrive;
