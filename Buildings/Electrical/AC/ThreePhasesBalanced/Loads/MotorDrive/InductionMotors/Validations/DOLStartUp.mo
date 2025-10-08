within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Validations;
model DOLStartUp
  "Validate the induction motor model at the direct on line startup"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.RealExpression loaTor(y=26.5) "Load torque"
    annotation (Placement(transformation(extent={{-54,-28},{-34,-8}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid sou(f=50, V=220*1.414)
    "Voltage source"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.SquirrelCage motDri
    "Squirrel cage induction motor"
    annotation (Placement(transformation(extent={{-18,-20},{2,0}})));

  Modelica.Blocks.Sources.CombiTimeTable torRef(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/torque.txt"))
    "Reference torque"
    annotation (Placement(transformation(extent={{-42,-86},{-22,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable curRef(
    tableOnFile=true,
    tableName="tab3",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/current.txt"))
    "Reference current"
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable speRef(
    tableOnFile=true,
    tableName="tab2",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/speed.txt"))
    "Reference rotor speed"
    annotation (Placement(transformation(extent={{22,-86},{42,-66}})));
  Modelica.Blocks.Sources.CombiTimeTable powRef(
    tableOnFile=true,
    tableName="tab4",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Electrical/InductionMachine/Validation/power.txt"))
    "Reference active power"
    annotation (Placement(transformation(extent={{52,-86},{72,-66}})));
equation
  connect(loaTor.y, motDri.tau_m)
    annotation (Line(points={{-33,-18},{-20,-18}}, color={0,0,127}));
  connect(sou.terminal, motDri.terminal) annotation (Line(points={{-10,20},{-8,
          20},{-8,8.88178e-16}}, color={0,120,120}));

annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1e-6,StartTime=0,StopTime=0.8),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/InductionMotors/Validations/DOLStartUp.mos"
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
This example validates the induction motor start-up sequence as shown in Ganesh
et al. (2025). The reference data plotted is from the simulation setup as decribed
in Roberta Le Fosse (2021).
To ensure consistency with the model used in the reference, the induction motor model
adopted in this study also neglects iron losses and magnetic saturation.
</p>
<ul>
<li>
The plots of rotor speed response and the electromagnetic torque response show that
the developed model is able to simulate the non linear start-up condition with
very high accuracy.
</li>
<li>
The plot of input current shows that the developed model is able to capture the
transients condition of input current when the starting current is approximately 8
times higher than the steady state condition. Once the induction motor reaches the
nominal operating condition, the input current falls down to a periodic sine wave
with magnitude of 10A.
</li>
<li>
The plot of the variations of active power consumption indicates
that the developed model can achieve high accuracy in estimating the active power
consumption at both the start-up and steady-state periods.
</li>
</ul>
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
end DOLStartUp;
