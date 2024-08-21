within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Validation;
model SystemRequests
  "Validation of model that generates system requests"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.SystemRequests sysReq(
    final have_duaSen=false,
    final floHys=0.01,
    final looHys=0.01,
    final damPosHys=0.01) "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,-20},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine(
    final freqHz=1/7200,
    final offset=296.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonCooSet(
    final samplePeriod=1800) "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TZon(
    final freqHz=1/7200,
    final amplitude=2,
    final offset=299.15)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(
    final height=-1,
    final duration=2000,
    final offset=1,
    final startTime=1000)
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp colDucAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Cold-duct airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp colDucAirRate(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Cold duct airflow rate"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp colDamPos(
    final duration=3000,
    final height=-0.7,
    final offset=0.7) "Cold-duct damper position"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=7200)
    "After suppression"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sine1(
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
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uHea(
    final height=0.9,
    final duration=3600,
    final startTime=3600)
    "Heating loop signal"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp hotDucAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1)
    "Hot-duct airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp hotDucAirRate(
    final duration=7200,
    final offset=0.1,
    final height=0.3)
    "Hot duct airflow rate"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp hotDamPos(
    final duration=3600,
    final height=0.7,
    startTime=3600)
    "Hot-duct damper position"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(final t=0.01)
    "Check if damper is open"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(final t=0.01)
    "Check if damper is open"
    annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));

equation
  connect(sine.y, TZonCooSet.u)
    annotation (Line(points={{-38,130},{-22,130}}, color={0,0,127}));
  connect(TZonCooSet.y, sysReq.TCooSet) annotation (Line(points={{2,130},{40,
          130},{40,16},{58,16}}, color={0,0,127}));
  connect(TZon.y, sysReq.TZon) annotation (Line(points={{-58,100},{36,100},{36,13},
          {58,13}}, color={0,0,127}));
  connect(uCoo.y, sysReq.uCoo) annotation (Line(points={{2,80},{32,80},{32,10},{
          58,10}}, color={0,0,127}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-38,160},{-22,160}}, color={255,0,255}));
  connect(not1.y, sysReq.uAftSupCoo) annotation (Line(points={{2,160},{44,160},{
          44,19},{58,19}}, color={255,0,255}));
  connect(colDucAirSet.y, sysReq.VColDuc_flow_Set) annotation (Line(points={{-38,60},
          {28,60},{28,7},{58,7}},     color={0,0,127}));
  connect(colDucAirRate.y, sysReq.VColDucDis_flow)
    annotation (Line(points={{2,40},{24,40},{24,5},{58,5}}, color={0,0,127}));
  connect(colDamPos.y, sysReq.uCooDam) annotation (Line(points={{-58,20},
          {10,20},{10,2},{58,2}}, color={0,0,127}));
  connect(sine1.y, TZonHeaSet.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(booPul1.y, not2.u)
    annotation (Line(points={{-58,-30},{-42,-30}}, color={255,0,255}));
  connect(not2.y, sysReq.uAftSupHea) annotation (Line(points={{-18,-30},{20,-30},
          {20,-3},{58,-3}}, color={255,0,255}));
  connect(TZonHeaSet.y, sysReq.THeaSet) annotation (Line(points={{-18,-60},{24,
          -60},{24,-6},{58,-6}}, color={0,0,127}));
  connect(uHea.y, sysReq.uHea) annotation (Line(points={{22,-80},{28,-80},{28,-9},
          {58,-9}},  color={0,0,127}));
  connect(hotDucAirSet.y, sysReq.VHotDuc_flow_Set) annotation (Line(points={{-38,
          -100},{32,-100},{32,-12},{58,-12}}, color={0,0,127}));
  connect(hotDucAirRate.y, sysReq.VHotDucDis_flow) annotation (Line(points={{2,-120},
          {36,-120},{36,-14},{58,-14}}, color={0,0,127}));
  connect(hotDamPos.y, sysReq.uHeaDam) annotation (Line(points={{-38,-140},
          {40,-140},{40,-17},{58,-17}}, color={0,0,127}));
  connect(colDamPos.y, greThr.u) annotation (Line(points={{-58,20},{-50,20},{-50,
          0},{-42,0}}, color={0,0,127}));
  connect(greThr.y, sysReq.u1CooDam)
    annotation (Line(points={{-18,0},{58,0}}, color={255,0,255}));
  connect(hotDamPos.y, greThr1.u) annotation (Line(points={{-38,-140},{-30,-140},
          {-30,-160},{-22,-160}}, color={0,0,127}));
  connect(greThr1.y, sysReq.u1HeaDam) annotation (Line(points={{2,-160},{44,-160},
          {44,-19},{58,-19}}, color={255,0,255}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctSnapActing/Subsequences/Validation/SystemRequests.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.SystemRequests</a>
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
