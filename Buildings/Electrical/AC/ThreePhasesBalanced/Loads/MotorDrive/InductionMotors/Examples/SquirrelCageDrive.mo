within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Examples;
model SquirrelCageDrive
  "Squirrel cage induction motor with closed loop built-in speed control"

  extends Modelica.Icons.Example;

  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{2,40},{22,60}})));
  Modelica.Blocks.Sources.RealExpression mea(
    y=motDri.speBlo.N)
    "Measured value of control target"
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
  Modelica.Blocks.Sources.Step Speed_ref(
    height=1500,
    offset=0,
    startTime=0)
    "Set point of control target"
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive motDri(
    redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per,
    reverseActing=true,
    k=0.1,
    Ti=0.1) "Induction motor with speed control"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  Modelica.Blocks.Sources.Step Speed_ref1(
    height=26.5,
    offset=0,
    startTime=1)   "Set point of control target"
    annotation (Placement(transformation(extent={{-58,-76},{-38,-56}})));

equation
  connect(motDri.terminal, sou.terminal)
    annotation (Line(points={{10,20},{10,30},{12,30},{12,40}}, color={0,120,120}));
  connect(Speed_ref.y, motDri.setPoi)
    annotation (Line(points={{-39,18},{-2,18}}, color={0,0,127}));
  connect(mea.y, motDri.mea) annotation (Line(points={{-39,-26},{-20,-26},{-20,10},
          {-2,10}}, color={0,0,127}));
  connect(Speed_ref1.y, motDri.tau_m) annotation (Line(points={{-37,-66},{-8,-66},
          {-8,2},{-2,2}}, color={0,0,127}));
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
An example of induction motor drive with closed loop variable speed controller.
</html>"));
end SquirrelCageDrive;
