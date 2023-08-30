within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Validation;
model SystemRequests
  "Validation of model that generates system requests"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.SystemRequests sysReq(
    final have_hotWatCoi=true,
    final floHys=0.01,
    final looHys=0.01,
    final damPosHys=0.01,
    final valPosHys=0.01) "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine(
    final freqHz=1/7200,
    final offset=296.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TCooSet(
    final samplePeriod=1800) "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TZon(
    final freqHz=1/7200,
    final amplitude=2,
    final offset=299.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(
    final height=-1,
    final duration=2000,
    final offset=1,
    final startTime=1000)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp disAir(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp damPos(
    final duration=3000,
    final height=-0.7,
    final offset=0.7) "Damper position"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=7200)
    "After suppression"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TDis(
    final duration=3600,
    final offset=273.15 + 20,
    final height=-5)
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDisSet(
    final k=273.15 + 30)
    "Discharge airflow temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp valPos(
    final duration=2000,
    final height=-0.7,
    final offset=0.7,
    final startTime=3600) "Valve position"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
equation
  connect(sine.y, TCooSet.u)
    annotation (Line(points={{-38,80},{-22,80}},   color={0,0,127}));
  connect(TCooSet.y, sysReq.TCooSet) annotation (Line(points={{2,80},{40,80},
          {40,-33},{58,-33}},    color={0,0,127}));
  connect(TZon.y, sysReq.TZon) annotation (Line(points={{-58,50},{36,50},{36,-35},
          {58,-35}},color={0,0,127}));
  connect(uCoo.y, sysReq.uCoo) annotation (Line(points={{2,30},{32,30},{32,-37},
          {58,-37}}, color={0,0,127}));
  connect(disAirSet.y, sysReq.VSet_flow) annotation (Line(points={{-38,10},{28,10},
          {28,-39},{58,-39}}, color={0,0,127}));
  connect(disAir.y, sysReq.VDis_flow) annotation (Line(points={{2,-10},{24,-10},
          {24,-41},{58,-41}}, color={0,0,127}));
  connect(damPos.y, sysReq.uDam) annotation (Line(points={{-58,-30},{20,-30},{
          20,-43},{58,-43}}, color={0,0,127}));
  connect(TDisSet.y, sysReq.TDisSet) annotation (Line(points={{-58,-70},{20,-70},
          {20,-45},{58,-45}}, color={0,0,127}));
  connect(TDis.y, sysReq.TDis) annotation (Line(points={{-18,-90},{24,-90},{24,-47},
          {58,-47}}, color={0,0,127}));
  connect(valPos.y, sysReq.uVal) annotation (Line(points={{-58,-120},{28,-120},
          {28,-49},{58,-49}}, color={0,0,127}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-38,120},{-22,120}}, color={255,0,255}));
  connect(not1.y, sysReq.uAftSup) annotation (Line(points={{2,120},{44,120},{44,
          -31},{58,-31}}, color={255,0,255}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/Reheat/Subsequences/Validation/SystemRequests.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.SystemRequests</a>
for generating system requests.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
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
end SystemRequests;
