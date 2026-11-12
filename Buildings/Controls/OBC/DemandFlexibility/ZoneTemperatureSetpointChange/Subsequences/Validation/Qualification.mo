within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Validation;
model Qualification
  "Validation model for the zone qualification check"

  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Qualification
    qua(
    final nZon=2,
    final TZonMax={273.15 + 24,273.15 + 24},
    final TZonHys=0.5)
    "Zone qualification check"
    annotation (Placement(transformation(extent={{40,-20},{80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TZon[2](
    each final amplitude=2,
    each final freqHz=1/86400,
    final phase={0,3.1415926535898},
    each final offset=273.15 + 24)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uStaZon[2](
    each final width=0.5,
    each final period=43200,
    final shift={0,10800})
    "Starved zone signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uRogZon[2](
    each final width=0.5,
    each final period=21600,
    final shift={0,5400})
    "Rogue zone signal"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

equation
  connect(TZon.y, qua.TZon)
    annotation (Line(points={{-38,60},{0,60},{0,12},{36,12}},
      color={0,0,127}));
  connect(uStaZon.y, qua.uStaZon)
    annotation (Line(points={{-38,0},{36,0}}, color={255,0,255}));
  connect(uRogZon.y, qua.uRogZon)
    annotation (Line(points={{-38,-60},{0,-60},{0,-12},{36,-12}},
      color={255,0,255}));

  annotation (experiment(StopTime=86400, Interval=1, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/ZoneTemperatureSetpointChange/Subsequences/Validation/Qualification.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates the block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Qualification\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Qualification</a>
for two zones.
</p>
<p>
The zone temperatures of the two zones vary sinusoidally around
the maximum zone temperature threshold <code>TZonMax</code> in
opposite phases over a 24 h period, while the starved zone and
rogue zone signals pulse with periods of 12 h and 6 h. Each zone
is qualified (<code>qua.yQua[i] = true</code>) only when its
temperature condition (with hysteresis <code>TZonHys</code>) is
satisfied and neither the starved nor the rogue signal is active.
</p>
</html>", revisions="<html>
<ul>
<li>
November 12, 2026, by Weiping Huang and Liam Cochrane:<br/>
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
end Qualification;
