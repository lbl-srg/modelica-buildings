within Buildings.Electrical.AC.ThreePhasesBalanced.MotorDrive.InductionMotors.Examples;
model SquirrelCageDrive "Test model for squirrel cage induction motor with built-in speed control"

  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Resistance R_s=0.641 "Electric resistance of stator";
  parameter Modelica.Units.SI.Resistance R_r=0.332 "Electric resistance of rotor";
  parameter Modelica.Units.SI.Reactance X_s=1.106 "Complex component of the impedance of stator";
  parameter Modelica.Units.SI.Reactance X_r=0.464 "Complex component of the impedance of rotor";
  parameter Modelica.Units.SI.Reactance X_m=26.3 "Complex component of the magnetizing reactance";
  Buildings.Electrical.AC.OnePhase.Sources.Grid sou(f=60, V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.RealExpression tau_m(y=0.002*simMot.omega_r*
      simMot.omega_r)
  annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Step temSet(
    height=-40,
    offset=130,
    startTime=500)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.RealExpression mea(y=simMot.omega_r)
  annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  MotorDrive.InductionMotors.SquirrelCageDrive simMot
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(temSet.y, simMot.setPoi) annotation (Line(points={{-39,70},{-26,
        70},{-26,8},{-12,8}},
                           color={0,0,127}));
  connect(sou.terminal, simMot.terminal) annotation (Line(points={{30,60},{
        30,40},{0,40},{0,10}},                   color={0,120,120}));
connect(tau_m.y, simMot.tau_m) annotation (Line(points={{-79,50},{-40,50},{
        -40,-8},{-12,-8}}, color={0,0,127}));
connect(mea.y, simMot.mea) annotation (Line(points={{-79,30},{-20,30},{-20,
        4},{-12,4}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/MotorDrive/InductionMotors/Examples/SquirrelCageDrive.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Example that simulates a induction motor where the set point is ramped up at 500 seconds. </p>
</html>",
revisions="<html>
<ul>
<li>October 15, 2021, by Mingzhe Liu:<br>First implementation.</li>
</ul>
</html>"));
end SquirrelCageDrive;
