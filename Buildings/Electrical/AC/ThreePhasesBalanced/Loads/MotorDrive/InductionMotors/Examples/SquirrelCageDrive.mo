within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Examples;
model SquirrelCageDrive "This example shows how to use the squirrel cage induction motor with built-in speed control"

  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Resistance R_s=0.641 "Electric resistance of stator";
  parameter Modelica.Units.SI.Resistance R_r=0.332 "Electric resistance of rotor";
  parameter Modelica.Units.SI.Reactance X_s=1.106 "Complex component of the impedance of stator";
  parameter Modelica.Units.SI.Reactance X_r=0.464 "Complex component of the impedance of rotor";
  parameter Modelica.Units.SI.Reactance X_m=26.3 "Complex component of the magnetizing reactance";

  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=60, V=480)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Modelica.Blocks.Sources.RealExpression tau_m(y=0.002*simMot.omega_r*simMot.omega_r)
    "Load torque"
    annotation (Placement(transformation(extent={{-80,-18},{-60,2}})));
  Modelica.Blocks.Sources.Step temSet(
    height=-40,
    offset=130,
    startTime=500) "Set point of control target"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.RealExpression mea(y=simMot.omega_r)
    "Measured value of control target"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive simMot(
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m) "Motor with speed control"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(temSet.y, simMot.setPoi) annotation (Line(points={{-59,50},{-20,50},
          {-20,8},{-12,8}}, color={0,0,127}));
  connect(sou.terminal, simMot.terminal) annotation (Line(points={{0,40},{0,10}},
          color={0,120,120}));
  connect(tau_m.y, simMot.tau_m) annotation (Line(points={{-59,-8},{-12,-8}},
          color={0,0,127}));
  connect(mea.y, simMot.mea) annotation (Line(points={{-59,20},{-40,20},{-40,4},
          {-12,4}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Examples/SquirrelCageDrive.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates an induction motor with variable speed control to track 
a step signal. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SquirrelCageDrive;
