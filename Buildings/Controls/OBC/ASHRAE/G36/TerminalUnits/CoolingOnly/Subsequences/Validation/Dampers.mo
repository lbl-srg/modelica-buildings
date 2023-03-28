within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Validation;
model Dampers
  "Validate model for controlling damper position of cooling  only terminal unit"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers dam1(
    final VMin_flow=0.01,
    final VCooMax_flow=0.09,
    final kDam=1) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-80},{100,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=900)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZon(
    final k=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSup(
    final k=273.15 + 13)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActMin_flow(
    final k=0.01)
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VActCooMax_flow(
    final k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine VDis_flow(
    final offset=0.015,
    final amplitude=0.002,
    final freqHz=1/3600)  "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp zonSta(
    final offset=3,
    final height=-2,
    final duration=1000,
    startTime=1800) "Zone state"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(
    final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveFlo(
    final height=3,
    final duration=2000,
    startTime=1000) "Override flow setpoint"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp oveDam(
    final height=2,
    final duration=2000,
    startTime=1000) "Override damper position"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round3(final n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
equation
  connect(zonSta.y,round2. u)
    annotation (Line(points={{-78,-60},{-62,-60}}, color={0,0,127}));
  connect(round2.y,reaToInt2. u)
    annotation (Line(points={{-38,-60},{-22,-60}},
      color={0,0,127}));
  connect(VActMin_flow.y, dam1.VActMin_flow) annotation (Line(points={{-78,120},
          {56,120},{56,-42},{78,-42}}, color={0,0,127}));
  connect(TSup.y, dam1.TSup) annotation (Line(points={{-38,100},{52,100},{52,-45},
          {78,-45}}, color={0,0,127}));
  connect(TZon.y, dam1.TZon) annotation (Line(points={{-78,80},{40,80},{40,-48},
          {78,-48}}, color={0,0,127}));
  connect(VActCooMax_flow.y, dam1.VActCooMax_flow) annotation (Line(points={{-78,40},
          {44,40},{44,-54},{78,-54}},   color={0,0,127}));
  connect(reaToInt2.y, dam1.uZonSta) annotation (Line(points={{2,-60},{78,-60}},
                              color={255,127,0}));
  connect(VDis_flow.y, dam1.VDis_flow) annotation (Line(points={{-78,-90},{20,-90},
          {20,-74},{78,-74}}, color={0,0,127}));
  connect(uCoo.y, dam1.uCoo) annotation (Line(points={{-38,60},{36,60},{36,-51},
          {78,-51}}, color={0,0,127}));
  connect(oveFlo.y,round1. u)
    annotation (Line(points={{-78,0},{-62,0}}, color={0,0,127}));
  connect(round1.y,reaToInt1. u)
    annotation (Line(points={{-38,0},{-22,0}}, color={0,0,127}));
  connect(oveDam.y,round3. u)
    annotation (Line(points={{-78,-130},{-62,-130}},  color={0,0,127}));
  connect(round3.y,reaToInt3. u)
    annotation (Line(points={{-38,-130},{-22,-130}}, color={0,0,127}));
  connect(reaToInt1.y, dam1.oveFloSet) annotation (Line(points={{2,0},{32,0},{32,
          -69},{78,-69}}, color={255,127,0}));
  connect(reaToInt3.y, dam1.oveDamPos) annotation (Line(points={{2,-130},{60,-130},
          {60,-78},{78,-78}}, color={255,127,0}));
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
end Dampers;
