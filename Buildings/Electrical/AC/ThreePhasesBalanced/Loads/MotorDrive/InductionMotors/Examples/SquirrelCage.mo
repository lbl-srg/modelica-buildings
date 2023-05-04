within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Examples;
model SquirrelCage "This example shows how to use the squirrel cage induction motor"

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
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage simMot(
    R_s=R_s,
    R_r=R_r,
    X_s=X_s,
    X_r=X_r,
    X_m=X_m) "Motor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(sou.terminal, simMot.terminal) annotation (Line(points={{0,40},{0,10}},
          color={0,120,120}));
  connect(tau_m.y, simMot.tau_m) annotation (Line(points={{-59,-8},{-12,-8}},
          color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Examples/SquirrelCage.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates a induction motor using the balanced three-phase power 
supply and quadratic type load signal.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation. 
</li>
</ul>
</html>"));
end SquirrelCage;
