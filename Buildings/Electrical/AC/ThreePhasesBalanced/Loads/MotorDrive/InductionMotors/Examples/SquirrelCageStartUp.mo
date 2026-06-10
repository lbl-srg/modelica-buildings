within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Examples;
model SquirrelCageStartUp
  "Squirrel cage induction motor start up performance"
    extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.RealExpression loaTor(y=26.5) "Load torque"
    annotation (Placement(transformation(extent={{-54,-22},{-34,-2}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive motDri(
      have_speCon=false) "Motor driver with the disabled speed control"
    annotation (Placement(transformation(extent={{-18,-20},{2,0}})));

  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-84,-30},{-64,-10}})));
equation
  connect(loaTor.y, motDri.tau_m)
    annotation (Line(points={{-33,-12},{-26,-12},{-26,-13},{-20,-13}},
                                                   color={0,0,127}));
  connect(sou.terminal, motDri.terminal) annotation (Line(points={{-10,20},{-8,
          20},{-8,8.88178e-16}}, color={0,120,120}));

  connect(booleanConstant.y, motDri.u) annotation (Line(points={{-63,-20},{-58,
          -20},{-58,-30},{-20,-30},{-20,-19}}, color={255,0,255}));
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
