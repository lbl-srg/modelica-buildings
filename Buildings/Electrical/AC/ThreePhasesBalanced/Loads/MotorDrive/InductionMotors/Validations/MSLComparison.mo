within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Validations;
model MSLComparison "Comparision between MSL and Proposed Model"
    extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.RealExpression loaTor(y=26.5) "Load torque"
    annotation (Placement(transformation(extent={{-54,-28},{-34,-8}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=50, V=220*1.414)
    "Voltage source"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage motDri
    annotation (Placement(transformation(extent={{-18,-20},{2,0}})));

  Modelica.Blocks.Sources.CombiTimeTable LeFosseTorque(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/torque.txt"))
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.CombiTimeTable LeFosseSpeed(
    tableOnFile=true,
    tableName="tab2",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/speed.txt"))
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.CombiTimeTable LeFossePower(
    tableOnFile=true,
    tableName="tab4",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/power.txt"))
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.CombiTimeTable MSLtorque(
    tableOnFile=true,
    tableName="msltorque",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/msltorque.txt"))
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.CombiTimeTable MSLspeed(
    tableOnFile=true,
    tableName="mslspeed",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/mslspeed.txt"))
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Sources.CombiTimeTable MSLpower(
    tableOnFile=true,
    tableName="mslpower",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/mslpower.txt"))
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
equation
  connect(loaTor.y, motDri.tau_m)
    annotation (Line(points={{-33,-18},{-20,-18}}, color={0,0,127}));
  connect(sou.terminal, motDri.terminal) annotation (Line(points={{-10,20},{-8,
          20},{-8,8.88178e-16}}, color={0,120,120}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1e-6,StartTime=0,StopTime=1),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Validations/MSLComparison.mos"
        "Simulate and PLot"),
Documentation(revisions="<html>
<ul>
<li>
September 12, 2025, by Viswanathan Ganesh:<br/>First Implementation.
</li>
</ul>
</html>", info="<html>
Comparison of Induction Machine Models with Modelica Standard Library (Figure 13)  <a href=\"https://ieeexplore.ieee.org/document/11045278\">[1]</a>. The reference data of MSL is simulated reference data from the model 
<a href=\"Modelica.Electrical.Machines.Examples.InductionMachines.IMC_DOL\">Modelica.Electrical.Machines.Examples.InductionMachines.IMC_DOL</a>. The LeFosse reference data plotted is from the simulation setup as decribed in <a href=\"https://webthesis.biblio.polito.it/17858/\">[2]</a>.
</html>
"));
end MSLComparison;
