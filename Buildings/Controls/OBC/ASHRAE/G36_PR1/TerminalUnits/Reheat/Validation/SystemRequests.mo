within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.Validation;
model SystemRequests
  "Validation of model that generates system requests"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests
    sysReq_RehBox(have_heaPla=true, have_heaWatCoi=true)
    "Block outputs system requests"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine(freqHz=1/7200, offset=296.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TCooSet(samplePeriod=1800)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TRoo(
    freqHz=1/7200,
    amplitude=2,
    offset=299.15) "Zone temperature"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp uCoo(
    height=0.9,
    duration=7200,
    offset=0.1) "Cooling loop signal"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirSet(
    height=0.9,
    duration=7200,
    offset=0.1) "Discharge airflow rate setpoint"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp disAirRate(
    duration=7200,
    offset=0.1,
    height=0.3) "Discharge airflow rate"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp damPos(
    duration=7200,
    height=0.7,
    offset=0.3) "Damper position"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sine1(
    freqHz=1/7200,
    offset=305.15)
    "Generate data for setpoint"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TDisSet(
    samplePeriod=1800)
    "Discharge air setpoint temperature"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TDis(
    freqHz=1/7200,
    amplitude=2,
    offset=293.15)
    "Discharge air temperature"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp valPos(
    duration=7200,
    height=1,
    offset=0)
    "Hot water valve position"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));

equation
  connect(sine.y, TCooSet.u)
    annotation (Line(points={{-39,90},{-22,90}}, color={0,0,127}));
  connect(TCooSet.y, sysReq_RehBox.TCooSet)
    annotation (Line(points={{1,90},{46,90},{46,79},{59,79}},
      color={0,0,127}));
  connect(TRoo.y, sysReq_RehBox.TRoo)
    annotation (Line(points={{-39,60},{16,60},{16,77},{59,77}},
      color={0,0,127}));
  connect(uCoo.y, sysReq_RehBox.uCoo)
    annotation (Line(points={{1,40},{18,40},{18,75},{59,75}},
      color={0,0,127}));
  connect(disAirSet.y, sysReq_RehBox.VDisSet)
    annotation (Line(points={{-39,20},{20,20},{20,72},{59,72}},
      color={0,0,127}));
  connect(disAirRate.y, sysReq_RehBox.VDis)
    annotation (Line(points={{1,0},{22,0},{22,70},{59,70}},
      color={0,0,127}));
  connect(damPos.y, sysReq_RehBox.uDam)
    annotation (Line(points={{-39,-20},{24,-20},{24,68},{59,68}},
      color={0,0,127}));
  connect(sine1.y, TDisSet.u)
    annotation (Line(points={{-69,-40},{-22,-40}}, color={0,0,127}));
  connect(TDisSet.y, sysReq_RehBox.TDisSet)
    annotation (Line(points={{1,-40},{26,-40},{26,65},{59,65}},
      color={0,0,127}));
  connect(TDis.y, sysReq_RehBox.TDis)
    annotation (Line(points={{-39,-60},{28,-60},{28,63},{59,63}},
      color={0,0,127}));
  connect(valPos.y,sysReq_RehBox.uHeaVal)
    annotation (Line(points={{1,-80},{30,-80},{30,61},{59,61}},
      color={0,0,127}));

annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Reheat/Validation/SystemRequests.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests</a>
for generating system requests.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2017, by Jianjun Hu:<br/>
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
