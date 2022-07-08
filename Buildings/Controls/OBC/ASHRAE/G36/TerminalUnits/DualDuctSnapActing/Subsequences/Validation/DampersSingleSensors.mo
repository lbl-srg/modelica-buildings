within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Validation;
model DampersSingleSensors
  "Validate model for controlling damper position of dual-duct unit"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersSingleSensors dam(
    have_preIndDam=true,
    final VCooMax_flow=0.08,
    final VHeaMax_flow=0.06,
    final kDam=1,
    final samplePeriod=120) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-10},{100,30}})));
  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersSingleSensors dam1(
    final have_preIndDam=false,
    final VCooMax_flow=0.08,
    final VHeaMax_flow=0.06,
    final kDam=1,
    final samplePeriod=120) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-90},{100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=-1,
    final duration=3600,
    final offset=1,
    final startTime=900) "Cooling control signal"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActMin_flow(
    final k=0.01)
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMax_flow(
    final k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine VDis(
    final offset=0.015,
    final amplitude=0.002,
    final freqHz=1/3600) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse cooAhu(
    final width=0.75,
    final period=7200)
    "Cold air handling unit status"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500)
    "Heating control signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActHeaMax_flow(
    final k=0.07)
    "Active heating maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaAhu(
    final width=0.75,
    final period=7200,
    final shift=5000)
    "Hot air handling unit status"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

equation
  connect(uCoo.y, dam.uCoo) annotation (Line(points={{-78,110},{60,110},{60,29},
          {78,29}}, color={0,0,127}));
  connect(VActCooMax_flow.y, dam.VActCooMax_flow) annotation (Line(points={{-38,90},
          {56,90},{56,26},{78,26}},   color={0,0,127}));
  connect(VActMin_flow.y, dam.VActMin_flow) annotation (Line(points={{-78,30},{44,
          30},{44,23},{78,23}}, color={0,0,127}));
  connect(VActMin_flow.y, dam1.VActMin_flow) annotation (Line(points={{-78,30},{
          44,30},{44,-57},{78,-57}}, color={0,0,127}));
  connect(VActCooMax_flow.y, dam1.VActCooMax_flow) annotation (Line(points={{-38,90},
          {56,90},{56,-54},{78,-54}},   color={0,0,127}));
  connect(uCoo.y, dam1.uCoo) annotation (Line(points={{-78,110},{60,110},{60,-51},
          {78,-51}}, color={0,0,127}));
  connect(cooAhu.y, dam.u1CooAHU) annotation (Line(points={{-38,50},{48,50},{48,-5},
          {78,-5}}, color={255,0,255}));
  connect(cooAhu.y, dam1.u1CooAHU) annotation (Line(points={{-38,50},{48,50},{48,
          -85},{78,-85}}, color={255,0,255}));
  connect(uHea.y, dam.uHea) annotation (Line(points={{-38,-30},{32,-30},{32,20},
          {78,20}},color={0,0,127}));
  connect(uHea.y, dam1.uHea) annotation (Line(points={{-38,-30},{32,-30},{32,-60},
          {78,-60}},  color={0,0,127}));
  connect(VActHeaMax_flow.y, dam.VActHeaMax_flow) annotation (Line(points={{-78,-50},
          {28,-50},{28,17},{78,17}},      color={0,0,127}));
  connect(VActHeaMax_flow.y, dam1.VActHeaMax_flow) annotation (Line(points={{-78,-50},
          {28,-50},{28,-63},{78,-63}},      color={0,0,127}));
  connect(heaAhu.y, dam1.u1HeaAHU) annotation (Line(points={{-38,-70},{24,-70},{24,
          -88},{78,-88}}, color={255,0,255}));
  connect(heaAhu.y, dam.u1HeaAHU) annotation (Line(points={{-38,-70},{24,-70},{24,
          -8},{78,-8}}, color={255,0,255}));
  connect(VDis.y, dam1.VDis_flow) annotation (Line(points={{-78,-100},{60,-100},
          {60,-82},{78,-82}}, color={0,0,127}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctSnapActing/Subsequences/Validation/DampersSingleSensors.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersSingleSensors\">
BBuildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersSingleSensors</a>
for damper control of dual-duct unit.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
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
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(extent={{-120,-160},{120,160}})));
end DampersSingleSensors;
