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
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
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
    startTime=1)
    "Set point of control target"
    annotation (Placement(transformation(extent={{-58,-42},{-38,-22}})));

  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(motDri.terminal, sou.terminal)
    annotation (Line(points={{10,20},{10,30},{12,30},{12,40}}, color={0,120,120}));
  connect(Speed_ref.y, motDri.setPoi)
    annotation (Line(points={{-39,18},{-2,18}}, color={0,0,127}));
  connect(mea.y, motDri.mea) annotation (Line(points={{-39,-10},{-20,-10},{-20,
          13},{-2,13}},
                    color={0,0,127}));
  connect(Speed_ref1.y, motDri.tau_m) annotation (Line(points={{-37,-32},{-14,
          -32},{-14,7},{-2,7}},
                          color={0,0,127}));
  connect(booleanConstant.y, motDri.u) annotation (Line(points={{-39,-70},{-10,
          -70},{-10,1},{-2,1}}, color={255,0,255}));
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
