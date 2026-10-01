within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.Validation;
model AssertMinimumRuntime
  "Validation model for the assertion of minimum runtime and off-time"
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.AssertMinimumRuntime assRunTim(
    have_chiWat=true,
    use_runTim=true,
    nUni=2,
    dt_min=15)
    "Assert minimum runtime – Reversible HP"
    annotation(Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[0, 1, 0; 10, 1, 1; 60, 0, 1; 80, 0, 0],
    timeScale=1,
    period=100)
    "HP on/off command"
    annotation(Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Hea(
    table=[0, 0, 1; 1, 1, 0; 3, 1, 0; 4, 1, 1; 6, 0, 0; 7, 0, 0],
    timeScale=10,
    period=100)
    "HP heating/cooling mode command"
    annotation(Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.AssertMinimumRuntime assOffTim(
    have_chiWat=false,
    use_runTim=false,
    nUni=1,
    dt_min=15)
    "Assert minimum off-time – Heating-only HP"
    annotation(Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Off(
    table=[0, 1; 20, 0; 30, 1; 40, 0; 60, 1],
    timeScale=1,
    period=100)
    "HP on/off command"
    annotation(Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(u1.y, assRunTim.u1)
    annotation(Line(points={{-58,40},{-20,40},{-20,28},{-2,28},{-2,28}},
      color={255,0,255}));
  connect(u1Off.y, assOffTim.u1)
    annotation(Line(points={{-58,-40},{-30,-40},{-30,-32},{-2,-32}},
      color={255,0,255}));
  connect(u1Hea.y, assRunTim.u1Hea)
    annotation(Line(points={{-58,0},{-20,0},{-20,12},{-2,12}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Subsequences/Validation/AssertMinimumRuntime.mos"
    "Simulate and plot"),
  experiment(StopTime=100.0,
    Tolerance=1e-06),
  Icon(graphics={Ellipse(lineColor={75,138,73},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid,
    extent={{-100,-100},{100,100}}),
  Polygon(lineColor={0,0,255},
    fillColor={75,138,73},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Documentation(
    info="<html>
<p>
  This model validates
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.AssertMinimumRuntime\">
    Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.AssertMinimumRuntime</a>
  for the following configurations, each with a minimum runtime or off-time
  <code>dt_min=15</code>&nbsp;s.
</p>
<ul>
  <li>
    Reversible HP with minimum runtime assertion enabled: component
    <code>assRunTim</code>.
  </li>
  <li>
    Heating-only HP with minimum off-time assertion enabled: component
    <code>assOffTim</code>.
  </li>
</ul>
</html>",
    revisions="<html>
<ul>
  <li>
    July 3, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end AssertMinimumRuntime;
