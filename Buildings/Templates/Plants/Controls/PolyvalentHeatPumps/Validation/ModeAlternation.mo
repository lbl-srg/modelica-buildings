within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.Validation;
model ModeAlternation
  "Validation model for SHC and single mode alternation"
  parameter Integer nPhp = 2
    "Number of polyvalent units"
    annotation(Evaluate=true);
  Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ModeAlternation selModPhp(
    final nPhp=nPhp)
    "Mode alternation"
    annotation(Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSor[nPhp](
    k={i for i in 1:nPhp})
    "Runtime order"
    annotation(Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable nHea(
    table=[0, 0; 20, 1; 40, 2; 60, 1; 80, 0],
    timeScale=1,
    period=150)
    "Number of units staged in heating mode"
    annotation(Placement(transformation(extent={{-48,30},{-28,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable nCoo(
    table=[0, 0; 100, 1; 120, 0],
    timeScale=1,
    period=150)
    "Number of units staged in cooling mode"
    annotation(Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable nShc(
    table=[0, 0; 60, 1; 80, 0; 120, 1; 140, 0],
    timeScale=1,
    period=150)
    "Number of units staged in SHC mode"
    annotation(Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Hea(
    table=[0, 0, 0; 20, 1, 0; 40, 1, 1; 60, 1, 0; 80, 0, 0],
    timeScale=1,
    period=150)
    "Enable command in heating mode"
    annotation(Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Coo(
    table=[0, 0, 0; 100, 1, 0; 120, 0, 0],
    timeScale=1,
    period=150)
    "Enable command in cooling mode"
    annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Shc(
    table=[0, 0, 0; 60, 0, 1; 80, 0, 0; 120, 1, 0; 140, 0, 0],
    timeScale=1,
    period=150)
    "Enable command in SHC mode"
    annotation(Placement(transformation(extent={{-80,-70},{-60,-50}})));
equation
  connect(idxSor.y, selModPhp.uIdxSor)
    annotation(Line(points={{-58,60},{20,60},{20,0},{38,0}},
      color={255,127,0}));
  connect(nHea.y[1], selModPhp.nHea)
    annotation(Line(points={{-26,40},{16,40},{16,8},{38,8}},
      color={255,127,0}));
  connect(nCoo.y[1], selModPhp.nCoo)
    annotation(Line(points={{-58,20},{12,20},{12,6},{38,6}},
      color={255,127,0}));
  connect(nShc.y[1], selModPhp.nShc)
    annotation(Line(points={{-28,0},{8,0},{8,4},{38,4}},
      color={255,127,0}));
  connect(u1Hea.y, selModPhp.u1Hea)
    annotation(Line(points={{-58,-20},{0,-20},{0,-4},{38,-4}},
      color={255,0,255}));
  connect(u1Coo.y, selModPhp.u1Coo)
    annotation(Line(points={{-28,-40},{4,-40},{4,-6},{38,-6}},
      color={255,0,255}));
  connect(u1Shc.y, selModPhp.u1Shc)
    annotation(Line(points={{-58,-60},{8,-60},{8,-8},{38,-8}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/PolyvalentHeatPumps/Validation/ModeAlternation.mos"
    "Simulate and plot"),
  experiment(StopTime=150.0,
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
  <a href=\"modelica://Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ModeAlternation\">
    Buildings.Templates.Plants.Controls.PolyvalentHeatPumps.ModeAlternation</a>
  in a configuration with two polyvalent
  heat pumps and a constant runtime order
  <code>idxSor={1, 2}</code>.
</p>
<p>
  The number of units staged in each mode and the corresponding enable
  commands of each unit are varied over time to exercise both types of stage
  transition anticipated by this block.
</p>
<ul>
  <li>
    Elementary single-mode staging, e.g., at <i>t</i> = 20&nbsp;s and
    <i>t</i> = 40&nbsp;s, unit 1 and then unit 2 are staged on in heating-only
    mode, and at <i>t</i> = 100&nbsp;s, unit 1 is staged on in cooling-only
    mode.
  </li>
  <li>
    A mode switch between a single mode and SHC mode, e.g., at
    <i>t</i> = 60&nbsp;s, unit 2 switches from heating-only to SHC mode, and
    at <i>t</i> = 120&nbsp;s, unit 1 switches from cooling-only to SHC mode.
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
end ModeAlternation;
