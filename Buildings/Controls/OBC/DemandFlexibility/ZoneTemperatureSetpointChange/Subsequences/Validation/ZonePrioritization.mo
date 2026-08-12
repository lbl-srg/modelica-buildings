within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Validation;
model ZonePrioritization "Zone prioritization"

  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization zonPri(
    nZon=5,
    airConMod=true)
    "Zone prioritization block"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonVal[5](
    k={273.15 + 17,273.15 + 23,273.15 + 15,273.15 + 12,273.15 + 13})
    "Zone temperature values for Zone 1 through 5"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonSetVal[5](
    k=fill(273.15 + 20, 5))
    "Zone temperature setpoint values for Zone 1 through 5"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse nSelVal(
    period=60,
    offset=2)
    "An integer value for the number of zones to select for prioritization"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse disFlaZon5(
    period=30)
    "A flag to disqualify Zone 5 for zone temperature comparison"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant disFlaZon1234[4](
    k=fill(false, 4))
    "Flags to disqualify Zone 1 through 4 for zone temperature comparison"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation
  connect(TZonSetVal.y, zonPri.TZonSet)
    annotation (Line(points={{-58,-30},{-40,-30},{-40,-12},{38,-12}},
      color={0,0,127}));
  connect(TZonVal.y, zonPri.TZon)
    annotation (Line(points={{-58,10},{-40,10},{-40,-8},{38,-8}}, color={0,0,127}));
  connect(nSelVal.y, zonPri.nSel)
    annotation (Line(points={{-58,-70},{-20,-70},{-20,-16},{38,-16}},
      color={255,127,0}));
  connect(disFlaZon1234.y, zonPri.disFla[1:4])
    annotation (Line(points={{-18,70},{0,70},{0,-3.6},{38,-3.6}},
      color={255,0,255}));
  connect(disFlaZon5.y, zonPri.disFla[5])
    annotation (Line(points={{-58,50},{0,50},{0,-4},{38,-4},{38,-3.2}},
      color={255,0,255}));
annotation (experiment(StopTime=60, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ZoneTemperatureSetpointChange/Subsequences/Validation/ZonePrioritization.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization</a>
for a 5-zone building under the heating operation.
</p>
</html>", revisions="<html>
<ul>
<li>
July 27, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end ZonePrioritization;
