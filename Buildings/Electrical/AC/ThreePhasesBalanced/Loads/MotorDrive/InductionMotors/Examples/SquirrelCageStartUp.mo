within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Examples;
model SquirrelCageStartUp
  "Squirrel cage induction motor start up performance"
    extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.RealExpression loaTor(y=26.5) "Load torque"
    annotation (Placement(transformation(extent={{-54,-28},{-34,-8}})));
  Sources.Grid                                             sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  SquirrelCage motDri
    annotation (Placement(transformation(extent={{-18,-20},{2,0}})));
equation


  connect(loaTor.y, motDri.tau_m)
    annotation (Line(points={{-33,-18},{-20,-18}}, color={0,0,127}));
  connect(sou.terminal, motDri.terminal) annotation (Line(points={{-10,20},{-8,
          20},{-8,8.88178e-16}},
                         color={0,120,120}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1e-6,StartTime=0,StopTime=1),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Examples/SquirrelCageStartUp.mos"
      "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br>First Implementation. </li>
</ul>
</html>",
      info="<html>
An example of induction motor start up sequence.
</html>"));
end SquirrelCageStartUp;