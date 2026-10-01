within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.Validation;
model RoutingPrimaryPumpStatus
  "Validation model for primary pump status signal routing"
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.RoutingPrimaryPumpStatus rouPumHdr(
    have_pumPriHdr=true,
    nPumPriDedHp=0,
    nPumPriDedPhp=0,
    nPumPri=2)
    "Routing – Headered primary pumps"
    annotation(Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1PumHdr(
    table=[0, 1, 0; 40, 1, 1],
    timeScale=1,
    period=100)
    "Headered primary pump status"
    annotation(Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.RoutingPrimaryPumpStatus rouPumDedHp(
    have_pumPriHdr=false,
    nPumPriDedHp=2,
    nPumPriDedPhp=0,
    nPumPri=2)
    "Routing – Dedicated primary pumps, reversible HP only"
    annotation(Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1PumDedHp(
    table=[0, 0, 0; 20, 1, 1],
    timeScale=1,
    period=100)
    "Dedicated primary pump status – HP"
    annotation(Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.RoutingPrimaryPumpStatus rouPumDedHpPhp(
    have_pumPriHdr=false,
    nPumPriDedHp=1,
    nPumPriDedPhp=1,
    nPumPri=2)
    "Routing – Dedicated primary pumps, reversible HP and polyvalent HP"
    annotation(Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1PumDedHpMix(
    table=[0, 0; 30, 1],
    timeScale=1,
    period=100)
    "Dedicated primary pump status – HP"
    annotation(Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1PumDedPhpMix(
    table=[0, 0; 60, 1],
    timeScale=1,
    period=100)
    "Dedicated primary pump status – Polyvalent HP"
    annotation(Placement(transformation(extent={{-80,-70},{-60,-50}})));
equation
  connect(u1PumHdr.y, rouPumHdr.u1PumPriHdr_actual)
    annotation(Line(points={{-58,40},{-30,40},{-30,48},{-2,48}},
      color={255,0,255}));
  connect(u1PumDedHp.y, rouPumDedHp.u1PumPriDedHp_actual)
    annotation(Line(points={{-58,0},{-2,0}},
      color={255,0,255}));
  connect(u1PumDedHpMix.y, rouPumDedHpPhp.u1PumPriDedHp_actual)
    annotation(Line(points={{-58,-30},{-30,-30},{-30,-40},{-2,-40}},
      color={255,0,255}));
  connect(u1PumDedPhpMix.y, rouPumDedHpPhp.u1PumPriDedPhp_actual)
    annotation(Line(points={{-58,-60},{-30,-60},{-30,-48.2},{-2,-48.2}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Subsequences/Validation/RoutingPrimaryPumpStatus.mos"
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
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.RoutingPrimaryPumpStatus\">
    Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.RoutingPrimaryPumpStatus</a>
  for the following configurations, each with two primary pumps.
</p>
<ul>
  <li>Headered primary pumps: component <code>rouPumHdr</code>.</li>
  <li>
    Dedicated primary pumps serving reversible HP only: component
    <code>rouPumDedHp</code>.
  </li>
  <li>
    Dedicated primary pumps serving one reversible HP and one polyvalent HP:
    component <code>rouPumDedHpPhp</code>.
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
end RoutingPrimaryPumpStatus;
