within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Validation;
model DamperValves
  "Validate model for controlling damper and valve position of VAV reheat terminal unit"

  Dampers
    damValReh(kDam=1, V_flow_nominal=2)
    "Output signal for controlling VAV reheat box damper and valve position"
    annotation (Placement(transformation(extent={{80,20},{100,60}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine VDis_flow(
    offset=0.015,
    amplitude=0.002,
    freqHz=1/86400) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDis(k=273.15 + 25)
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occSig(
    k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied signal"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

equation
  connect(VActCooMax_flow.y, damValReh.VActCooMax_flow) annotation (Line(points={{42,80},
          {50,80},{50,56},{78,56}},         color={0,0,127}));
  connect(VActHeaMax_flow.y, damValReh.VActHeaMax_flow) annotation (Line(points={{-18,60},
          {-4,60},{-4,27},{78,27}},          color={0,0,127}));
  connect(VActMin_flow.y, damValReh.VActMin_flow) annotation (Line(points={{-18,20},
          {-2,20},{-2,42},{78,42}},     color={0,0,127}));
  connect(uCoo.y, damValReh.uCoo)
    annotation (Line(points={{-58,0},{0,0},{0,59},{78,59}}, color={0,0,127}));
  connect(uHea.y, damValReh.uHea) annotation (Line(points={{-18,-20},{2,-20},{2,
          30},{78,30}}, color={0,0,127}));
  connect(TZon.y, damValReh.TZon) annotation (Line(points={{-58,-80},{8,-80},{8,
          38},{78,38}}, color={0,0,127}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/Reheat/Subsequences/Validation/DamperValves.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves</a>
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
