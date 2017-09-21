within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnit.Reheat.Validation;
model DamperValve
  "Validate model for controlling damper and valve position of VAV reheat terminal unit"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnit.Reheat.DamperValve damVal_RehBox(
    kDam=0.8)
    "Output signals for controlling VAV reheat box damper and valve position"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    duration=86400,
    height=0.6,
    offset=0.2) "Heating control signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uCoo(k=0)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSet(k=273.15 + 20)
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(k=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSup(k=273.15 + 13)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActMin(k=0.01)
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActHeaMin(k=0.015)
    "Active heating minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActHeaMax(k=0.05)
    "Active heating maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMin(k=0.015)
    "Active cooling minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMax(k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Sources.Sine VDisAir(
    offset=0.015,
    amplitude=0.002,
    freqHz=1/86400) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDisAir(k=273.15 + 25)
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

equation
  connect(VDisAir.y, damVal_RehBox.VDisAir)
    annotation (Line(points={{41,-60},{74,-60},{74,39}}, color={0,0,127}));
  connect(TDisAir.y, damVal_RehBox.TDisAir)
    annotation (Line(points={{41,-20},{66,-20},{66,39}}, color={0,0,127}));
  connect(VActCooMax.y, damVal_RehBox.VActCooMax)
    annotation (Line(points={{41,80},{50,80},{50,59},{59,59}}, color={0,0,127}));
  connect(VActCooMin.y, damVal_RehBox.VActCooMin)
    annotation (Line(points={{-59,80},{-2,80},{-2,57},{59,57}}, color={0,0,127}));
  connect(VActHeaMax.y, damVal_RehBox.VActHeaMax)
    annotation (Line(points={{-19,60},{-4,60},{-4,55},{59,55}}, color={0,0,127}));
  connect(VActHeaMin.y, damVal_RehBox.VActHeaMin)
    annotation (Line(points={{-59,40},{-4,40},{-4,53},{59,53}}, color={0,0,127}));
  connect(VActMin.y, damVal_RehBox.VActMin)
    annotation (Line(points={{-19,20},{-2,20},{-2,51},{59,51}}, color={0,0,127}));
  connect(uCoo.y, damVal_RehBox.uCoo)
    annotation (Line(points={{-59,0},{0,0},{0,49},{59,49}}, color={0,0,127}));
  connect(uHea.y, damVal_RehBox.uHea)
    annotation (Line(points={{-19,-20},{2,-20},{2,47},{59,47}}, color={0,0,127}));
  connect(THeaSet.y, damVal_RehBox.THeaSet)
    annotation (Line(points={{-59,-40},{4,-40},{4,45},{59,45}}, color={0,0,127}));
  connect(TSup.y, damVal_RehBox.TSup)
    annotation (Line(points={{-19,-60},{6,-60},{6,43},{59,43}}, color={0,0,127}));
  connect(TZon.y, damVal_RehBox.TRoo)
    annotation (Line(points={{-59,-80},{8,-80},{8,41},{59,41}}, color={0,0,127}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnit/Reheat/Validation/DamperValve.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnit.Reheat.DamperValve\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnit.Reheat.DamperValve</a>
for damper and valve control of VAV reheat terminal unit.
</p>
</html>", revisions="<html>
<ul>
<li>
Spetember 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DamperValve;
