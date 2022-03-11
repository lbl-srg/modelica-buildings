within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Validation;
model SystemRequests
  "Validation of model that generates system requests"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.SystemRequests sysReq(
    final floHys=0.01,
    final looHys=0.01,
    final damPosHys=0.01) "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(
    final freqHz=1/7200,
    final offset=296.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonCooSet(
    final samplePeriod=1800)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon(
    final freqHz=1/7200,
    final amplitude=2,
    final offset=299.15) "Zone temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Cooling loop signal"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirSet(
    final height=0.9,
    final duration=7200,
    final offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirRate(
    final duration=7200,
    final offset=0.1,
    final height=0.3) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    final duration=7200,
    final height=0.7,
    final offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=7200)
    "After suppression"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));

equation
  connect(sine.y, TZonCooSet.u)
    annotation (Line(points={{-38,60},{-22,60}}, color={0,0,127}));
  connect(TZonCooSet.y, sysReq.TZonCooSet) annotation (Line(points={{2,60},{38,60},
          {38,16},{58,16}}, color={0,0,127}));
  connect(TZon.y, sysReq.TZon) annotation (Line(points={{-38,20},{36,20},{36,14},
          {58,14}}, color={0,0,127}));
  connect(uCoo.y, sysReq.uCoo) annotation (Line(points={{2,-10},{36,-10},{36,12},
          {58,12}}, color={0,0,127}));
  connect(disAirRate.y, sysReq.VDis_flow) annotation (Line(points={{2,-50},{40,-50},
          {40,4},{58,4}}, color={0,0,127}));
  connect(disAirSet.y, sysReq.VSet_flow) annotation (Line(points={{-38,-30},{38,
          -30},{38,7},{58,7}}, color={0,0,127}));
  connect(damPos.y, sysReq.uDam) annotation (Line(points={{-38,-80},{42,-80},{42,
          1},{58,1}}, color={0,0,127}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-38,100},{-22,100}}, color={255,0,255}));
  connect(not1.y, sysReq.uAftSup) annotation (Line(points={{2,100},{40,100},{40,
          19},{58,19}}, color={255,0,255}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly/Subsequences/Validation/SystemRequests.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.SystemRequests</a>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}}), graphics={
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
