within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Validations;
model DOLStartUp
  "Simulates Direct On Line startup of an induction machine"
    extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.RealExpression loaTor(y=26.5) "Load torque"
    annotation (Placement(transformation(extent={{-54,-28},{-34,-8}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=50, V=220*1.414)
    "Voltage source"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage motDri "Squirrel Cage Motor"
    annotation (Placement(transformation(extent={{-18,-20},{2,0}})));

  Modelica.Blocks.Sources.CombiTimeTable LeFosseTorque(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/torque.txt"))
    annotation (Placement(transformation(extent={{-42,-86},{-22,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable LeFosseCurrent(
    tableOnFile=true,
    tableName="tab3",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/current.txt"))
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable LeFosseSpeed(
    tableOnFile=true,
    tableName="tab2",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/speed.txt"))
    annotation (Placement(transformation(extent={{22,-86},{42,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable LeFossePower(
    tableOnFile=true,
    tableName="tab4",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/power.txt"))
    annotation (Placement(transformation(extent={{52,-86},{72,-66}})));
equation
  connect(loaTor.y, motDri.tau_m)
    annotation (Line(points={{-33,-18},{-20,-18}}, color={0,0,127}));
  connect(sou.terminal, motDri.terminal) annotation (Line(points={{-10,20},{-8,
          20},{-8,8.88178e-16}}, color={0,120,120}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1e-6,StartTime=0,StopTime=1),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Validations/DOLStartUp.mos"
        "Simulate and Plot"),
Documentation(revisions="<html>
<ul>
<li>
September 12, 2025, by Viswanathan Ganesh:<br>First Implementation.
</li>
</ul>
</html>", info="<html>
<p>
An example of induction motor start-up sequence (Figure 9) <a href=\"https://ieeexplore.ieee.org/document/11045278\">[1]</a>. The reference data plotted is from the simulation setup as decribed in <a href=\"https://webthesis.biblio.polito.it/17858/\">[2]</a>.
To ensure consistency with the model used in <a href=\"https://webthesis.biblio.polito.it/17858/\">[2]</a>, the induction motor model adopted in this study also neglects iron losses and magnetic saturation.
</p>
1. Figure 'a' provides a plot of rotor speed response. It shows that the CEAIM model is able to simulate the non linear start-up condition with very high accuracy.<br/>
2. Figure 'b' provides a plot of electromagnetic torque response with high level of accuracy.<br/>
3. Figure 'c' provides a plot of input current. CEAIM model is able to capture the transients condition of input current as the starting current is approximately 8 times higher than the steady state condition. Once IM reaches the nominal operating condition,
input current fall down to a periodic sine wave with magnitude of 10A. <br/>
4. Figure 'd' illustrates the variations of active power consumption and indicates that the proposed model 
can achieve high accuracy in estimating the active power consumption at both the start-up and steady-state periods. <br/>
</html>"));
end DOLStartUp;
