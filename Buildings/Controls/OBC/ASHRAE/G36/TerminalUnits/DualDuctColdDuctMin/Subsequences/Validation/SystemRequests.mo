within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Validation;
model SystemRequests
  "Validation of model that generates system requests"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.SystemRequests sysReq(
    final floHys=0.01,
    final looHys=0.01,
    final damPosHys=0.01) "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,-22},{80,18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    final freqHz=1/7200,
    final offset=296.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonCooSet(
    final samplePeriod=1800) "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon(
    final freqHz=1/7200,
    final amplitude=2,
    final offset=299.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=-1,
    final duration=2000,
    final offset=1,
    final startTime=1000)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp colDucAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Cold-duct airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp colDucAirRate(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Cold duct airflow rate"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp colDamPos(
    final duration=3000,
    final height=-0.7,
    final offset=0.7) "Cold-duct damper position"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=7200)
    "After suppression"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    final freqHz=1/7200,
    final offset=293.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonHeaSet(
    final samplePeriod=1800)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.1,
    final period=7200)
    "After suppression"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uHea(
    final height=0.9,
    final duration=3600,
    final startTime=3600)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp hotDucAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1)
    "Hot-duct airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp hotDucAirRate(
    final duration=7200,
    final offset=0.1,
    final height=0.3)
    "Hot duct airflow rate"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp hotDamPos(
    final duration=3600,
    final height=0.7,
    startTime=3600)
    "Hot-duct damper position"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));

equation
  connect(sine.y, TZonCooSet.u)
    annotation (Line(points={{-38,110},{-22,110}}, color={0,0,127}));
  connect(TZonCooSet.y, sysReq.TCooSet) annotation (Line(points={{2,110},{40,
          110},{40,14},{58,14}}, color={0,0,127}));
  connect(TZon.y, sysReq.TZon) annotation (Line(points={{-58,80},{36,80},{36,11},
          {58,11}}, color={0,0,127}));
  connect(uCoo.y, sysReq.uCoo) annotation (Line(points={{2,60},{32,60},{32,8},{58,
          8}}, color={0,0,127}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-38,140},{-22,140}}, color={255,0,255}));
  connect(not1.y, sysReq.uAftSupCoo) annotation (Line(points={{2,140},{44,140},{
          44,17},{58,17}}, color={255,0,255}));
  connect(colDucAirSet.y, sysReq.VColDuc_flow_Set) annotation (Line(points={{-38,
          40},{28,40},{28,5},{58,5}}, color={0,0,127}));
  connect(colDucAirRate.y, sysReq.VColDucDis_flow)
    annotation (Line(points={{2,20},{24,20},{24,3},{58,3}}, color={0,0,127}));
  connect(colDamPos.y, sysReq.uCooDam)
    annotation (Line(points={{-38,0},{58,0}}, color={0,0,127}));
  connect(sine1.y, TZonHeaSet.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(booPul1.y, not2.u)
    annotation (Line(points={{-58,-30},{-42,-30}}, color={255,0,255}));
  connect(not2.y, sysReq.uAftSupHea) annotation (Line(points={{-18,-30},{20,-30},
          {20,-5},{58,-5}}, color={255,0,255}));
  connect(TZonHeaSet.y, sysReq.THeaSet) annotation (Line(points={{-18,-60},{24,
          -60},{24,-8},{58,-8}}, color={0,0,127}));
  connect(uHea.y, sysReq.uHea) annotation (Line(points={{2,-90},{28,-90},{28,-11},
          {58,-11}}, color={0,0,127}));
  connect(hotDucAirSet.y, sysReq.VHotDuc_flow_Set) annotation (Line(points={{-38,
          -110},{32,-110},{32,-14},{58,-14}}, color={0,0,127}));
  connect(hotDucAirRate.y, sysReq.VHotDucDis_flow) annotation (Line(points={{2,-130},
          {36,-130},{36,-16},{58,-16}}, color={0,0,127}));
  connect(hotDamPos.y, sysReq.uHeaDam) annotation (Line(points={{-38,-150},{40,
          -150},{40,-19},{58,-19}}, color={0,0,127}));

annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctColdDuctMin/Subsequences/Validation/SystemRequests.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.SystemRequests</a>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,180}})),
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
