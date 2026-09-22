within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.Validation;
model AssertMinimumRuntime
  "Validation model for the assertion of minimum runtime and off-time"
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.AssertMinimumRuntime assRunTim(
    use_runTim=true,
    nUni=2,
    dt_min=15)
    "Assert minimum runtime"
    annotation(Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Hea(
    table=[0, 1, 0; 8, 0, 1; 40, 1, 0; 70, 0, 0],
    timeScale=1,
    period=100)
    "Polyvalent HP heating on/off command"
    annotation(Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Coo(
    table=[0, 0, 1; 20, 1, 1; 50, 0, 0],
    timeScale=1,
    period=100)
    "Polyvalent HP cooling on/off command"
    annotation(Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.AssertMinimumRuntime assOffTim(
    use_runTim=false,
    nUni=1,
    dt_min=15)
    "Assert minimum off-time"
    annotation(Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1HeaOff(
    table=[0, 1; 20, 0; 30, 1; 50, 0],
    timeScale=1,
    period=100)
    "Polyvalent HP heating on/off command"
    annotation(Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1CooOff(
    table=[0, 0; 25, 1; 70, 0],
    timeScale=1,
    period=100)
    "Polyvalent HP cooling on/off command"
    annotation(Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(u1Hea.y, assRunTim.u1Hea)
    annotation(Line(points={{-58,40},{-20,40},{-20,28},{-2,28}},
      color={255,0,255}));
  connect(u1Coo.y, assRunTim.u1Coo)
    annotation(Line(points={{-58,0},{-20,0},{-20,12},{-2,12},{-2,12}},
      color={255,0,255}));
  connect(u1HeaOff.y, assOffTim.u1Hea)
    annotation(Line(points={{-58,-40},{-20,-40},{-20,-32},{-2,-32}},
      color={255,0,255}));
  connect(u1CooOff.y, assOffTim.u1Coo)
    annotation(Line(points={{-58,-80},{-20,-80},{-20,-48},{-2,-48}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/PolyvalentHeatPumps/Validation/AssertMinimumRuntime.mos"
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
  <a href=\"modelica://Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.AssertMinimumRuntime\">
    Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.AssertMinimumRuntime</a>
  for the following configurations, each with a minimum runtime or off-time
  <code>dt_min=15</code>&nbsp;s.
</p>
<ul>
  <li>
    Minimum runtime assertion enabled (<code>use_runTim=true</code>):
    component <code>assRunTim</code>.
  </li>
  <li>
    Minimum off-time assertion enabled (<code>use_runTim=false</code>):
    component <code>assOffTim</code>.
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
