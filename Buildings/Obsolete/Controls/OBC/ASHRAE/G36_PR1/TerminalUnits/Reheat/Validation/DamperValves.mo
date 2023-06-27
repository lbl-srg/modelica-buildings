within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.Validation;
model DamperValves
  "Validate model for controlling damper and valve position of VAV reheat terminal unit"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves
    damVal(kDam=1, V_flow_nominal=2)
    "Output signal for controlling VAV reheat box damper and valve position"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    duration=36000,
    height=-1,
    offset=1,
    startTime=0)
    "Heating control signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    height=1,
    duration=36000,
    offset=0,
    startTime=50400)
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActMin_flow(k=0.01)
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActHeaMin_flow(k=0.015)
    "Active heating minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActHeaMax_flow(k=0.05)
    "Active heating maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMin_flow(k=0.015)
    "Active cooling minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMax_flow(k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin VDis_flow(
    offset=0.015,
    amplitude=0.002,
    freqHz=1/86400) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(k=273.15 + 25)
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occSig(
    k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied signal"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

equation
  connect(VDis_flow.y, damVal.VDis_flow)
    annotation (Line(points={{41,-60},{74,-60},{74,37}}, color={0,0,127}));
  connect(TDis.y, damVal.TDis)
    annotation (Line(points={{41,-20},{66,-20},{66,37}}, color={0,0,127}));
  connect(VActCooMax_flow.y, damVal.VActCooMax_flow)
    annotation (Line(points={{41,80},{50,80},{50,59},{59,59}}, color={0,0,127}));
  connect(VActCooMin_flow.y, damVal.VActCooMin_flow)
    annotation (Line(points={{-59,80},{-2,80},{-2,57},{59,57}}, color={0,0,127}));
  connect(VActHeaMax_flow.y, damVal.VActHeaMax_flow)
    annotation (Line(points={{-19,60},{-4,60},{-4,55},{59,55}}, color={0,0,127}));
  connect(VActHeaMin_flow.y, damVal.VActHeaMin_flow)
    annotation (Line(points={{-59,40},{-4,40},{-4,53},{59,53}}, color={0,0,127}));
  connect(VActMin_flow.y, damVal.VActMin_flow)
    annotation (Line(points={{-19,20},{-2,20},{-2,51},{59,51}}, color={0,0,127}));
  connect(uCoo.y, damVal.uCoo)
    annotation (Line(points={{-59,0},{0,0},{0,49},{59,49}}, color={0,0,127}));
  connect(uHea.y, damVal.uHea)
    annotation (Line(points={{-19,-20},{2,-20},{2,47},{59,47}}, color={0,0,127}));
  connect(THeaSet.y, damVal.THeaSet)
    annotation (Line(points={{-59,-40},{4,-40},{4,45},{59,45}}, color={0,0,127}));
  connect(TSup.y, damVal.TSup)
    annotation (Line(points={{-19,-60},{6,-60},{6,43},{59,43}}, color={0,0,127}));
  connect(TZon.y, damVal.TZon)
    annotation (Line(points={{-59,-80},{8,-80},{8,41},{59,41}}, color={0,0,127}));
  connect(occSig.y, damVal.uOpeMod)
    annotation (Line(points={{41,20},{50,20},{50,39},{59,39}}, color={255,127,0}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Reheat/Validation/DamperValves.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves</a>
for damper and valve control of VAV reheat terminal unit.
</p>
</html>", revisions="<html>
<ul>
<li>
Spetember 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
end DamperValves;
