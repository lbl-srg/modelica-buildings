within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Examples;
model SquirrelCageStartUp
  "Squirrel cage induction motor start up performance"
  extends Modelica.Icons.Example;

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive motDri(
      have_speCon=false) "Motor driver with the disabled speed control"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

  Modelica.Blocks.Sources.RealExpression loaTor(y=26.5) "Load torque"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

equation
  connect(loaTor.y, motDri.tau_m)
    annotation (Line(points={{-59,0},{-40,0},{-40,-13},{-12,-13}}, color={0,0,127}));
  connect(sou.terminal, motDri.terminal) annotation (Line(points={{0,20},{0,0}},
          color={0,120,120}));
  connect(booleanConstant.y, motDri.on) annotation (Line(points={{-59,-50},{-40,
          -50},{-40,-19},{-12,-19}}, color={255,0,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6,StartTime=0,StopTime=1),
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Examples/SquirrelCageStartUp.mos"
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
An example of induction motor start up sequence.
</p>
</html>"));
end SquirrelCageStartUp;
