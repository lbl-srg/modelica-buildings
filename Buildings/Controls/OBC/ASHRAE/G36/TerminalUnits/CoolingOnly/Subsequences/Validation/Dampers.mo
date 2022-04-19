within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Validation;
model Dampers
  "Validate model for controlling damper position of cooling  only terminal unit"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers dam(
    final kDam=1, final V_flow_nominal=0.08)
    "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers dam1(
    final have_preIndDam=false,
    final kDam=1,
    final V_flow_nominal=0.08)
                            "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=900)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(
    final k=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSup(
    final k=273.15 + 13)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActMin_flow(
    final k=0.01)
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMax_flow(
    final k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine VDis_flow(
    final offset=0.015,
    final amplitude=0.002,
    final freqHz=1/3600)  "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp zonSta(
    final offset=3,
    final height=-2,
    final duration=1000,
    startTime=1800) "Zone state"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(uCoo.y, dam.uCoo) annotation (Line(points={{-18,20},{28,20},{28,30},{58,
          30}}, color={0,0,127}));
  connect(TSup.y, dam.TSup) annotation (Line(points={{-18,60},{44,60},{44,36},{58,
          36}}, color={0,0,127}));
  connect(TZon.y, dam.TZon) annotation (Line(points={{-58,40},{40,40},{40,33},{58,
          33}}, color={0,0,127}));
  connect(VActCooMax_flow.y, dam.VActCooMax_flow) annotation (Line(points={{-58,
          0},{32,0},{32,27},{58,27}}, color={0,0,127}));
  connect(VActMin_flow.y, dam.VActMin_flow) annotation (Line(points={{-58,80},{48,
          80},{48,39},{58,39}}, color={0,0,127}));
  connect(zonSta.y,round2. u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-18,-40},{-2,-40}},
      color={0,0,127}));
  connect(reaToInt2.y, dam.uZonSta) annotation (Line(points={{22,-40},{36,-40},{
          36,24},{58,24}}, color={255,127,0}));
  connect(VActMin_flow.y, dam1.VActMin_flow) annotation (Line(points={{-58,80},{
          48,80},{48,-21},{58,-21}}, color={0,0,127}));
  connect(TSup.y, dam1.TSup) annotation (Line(points={{-18,60},{44,60},{44,-24},
          {58,-24}}, color={0,0,127}));
  connect(TZon.y, dam1.TZon) annotation (Line(points={{-58,40},{40,40},{40,-27},
          {58,-27}}, color={0,0,127}));
  connect(uCoo.y, dam1.uCoo) annotation (Line(points={{-18,20},{28,20},{28,-30},
          {58,-30}}, color={0,0,127}));
  connect(VActCooMax_flow.y, dam1.VActCooMax_flow) annotation (Line(points={{-58,
          0},{32,0},{32,-33},{58,-33}}, color={0,0,127}));
  connect(reaToInt2.y, dam1.uZonSta) annotation (Line(points={{22,-40},{36,-40},
          {36,-36},{58,-36}}, color={255,127,0}));
  connect(VDis_flow.y, dam1.VDis_flow) annotation (Line(points={{-58,-70},{40,-70},
          {40,-39},{58,-39}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly/Subsequences/Validation/Dampers.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers\">
BBuildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers</a>
for damper control of VAV cooling only terminal unit.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
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
end Dampers;
