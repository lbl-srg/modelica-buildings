within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Validations;
model MSL "Validate the induction motor model by comparing results with the one from MSL"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.RealExpression loaTor(y=26.5) "Load torque"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=50, V=220*1.414)
    "Voltage source"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCageDrive motDri(
    final have_speCon=false)
    "Squirrel cage induction motor"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Modelica.Blocks.Sources.CombiTimeTable torRef(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/torque.txt"))
    "Reference torque from reference"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.CombiTimeTable speRef(
    tableOnFile=true,
    tableName="tab2",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/speed.txt"))
    "Reference speed from reference"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.CombiTimeTable powRef(
    tableOnFile=true,
    tableName="tab4",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/power.txt"))
    "Reference active power from reference"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.CombiTimeTable torMSL(
    tableOnFile=true,
    tableName="msltorque",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/msltorque.txt"))
    "Torque data calculated by the models from the Modelica Standard Library"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.CombiTimeTable speMSL(
    tableOnFile=true,
    tableName="mslspeed",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/mslspeed.txt"))
    "Rotor speed data calculated by the models from the Modelica Standard Library"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Sources.CombiTimeTable powMSL(
    tableOnFile=true,
    tableName="mslpower",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/mslpower.txt"))
    "Active power data calculated by the models from the Modelica Standard Library"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Modelica.Blocks.Sources.BooleanConstant booTru "Boolean true"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(loaTor.y, motDri.tau_m)
    annotation (Line(points={{-59,10},{-40,10},{-40,-13},{-22,-13}}, color={0,0,127}));
  connect(sou.terminal, motDri.terminal) annotation (Line(points={{-10,20},{-10,
          8.88178e-16}}, color={0,120,120}));
  connect(booTru.y, motDri.on) annotation (Line(points={{-59,-50},{-40,-50},{-40,
          -19},{-22,-19}}, color={255,0,255}));

annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6,StartTime=0,StopTime=0.8),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Validations/MSL.mos"
        "Simulate and Plot"),
Documentation(revisions="<html>
<ul>
<li>
September 12, 2025, by Viswanathan Ganesh:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example validates the induction model by comparing its results with the one from
the models in Modelica Standard Library (MSL), with the setup as described in Ganesh et al.
(2025). The reference data of MSL is simulated reference data from the model
<a href=\"modelica://Modelica.Electrical.Machines.Examples.InductionMachines.IMC_DOL\">
Modelica.Electrical.Machines.Examples.InductionMachines.IMC_DOL</a>.
The LeFosse reference data plotted is from the simulation setup as described in
Roberta Le Fosse (2021).
</p>
<h4>Reference</h4>
<p>
Viswanathan Ganesh, Zhanwei He, Jianjun Hu, Sen Huang, Wangda Zuo, 2025.
<a href=\"https://ieeexplore.ieee.org/document/11045278\">
<i>Coupled induction machine and HVAC models for simulating HVAC performance
considering grid dynamics in buildings</i></a>. IEEE Access, vol. 13,
pp. 107745-107763.
</p>
<p>
Roberta Le Fosse, 2021. <i>Dynamic modeling of induction motors in developing tool
for automotive applications</i>. <a href=\"https://webthesis.biblio.polito.it/17858/\">
[Thesis]</a>.
</p>
</html>"));
end MSL;
