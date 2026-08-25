within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.Validation;
model EventSequencingMultiple
  "Validation model for staging event sequencing of a group of heat pumps"
  parameter Integer nHp = 1
    "Number of reversible heat pumps"
    annotation(Evaluate=true);
  parameter Integer nPhp = 1
    "Number of polyvalent units"
    annotation(Evaluate=true);
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EventSequencingMultiple seqEve(
    final nHp=nHp,
    final nPhp=nPhp,
    have_heaWat=true,
    have_chiWat=true,
    have_valHpInlIso=true,
    have_valHpOutIso=false,
    have_valPhpInlIso=false,
    have_valPhpOutIso=true,
    have_pumPriHdr=false,
    have_pumChiWatPriDedHp=false,
    nPumHeaWatPri=nHp + nPhp,
    nPumChiWatPri=nPhp,
    dtVal=10,
    dtOff=10)
    "Staging event sequencing"
    annotation(Placement(transformation(extent={{20,-12},{40,12}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1HeaHpPhp(
    table=[0, 1, 0; 30, 1, 1; 50, 1, 0; 70, 0, 0],
    timeScale=1,
    period=100)
    "Heating enable command – HP (index 1) and polyvalent HP (index 2)"
    annotation(Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1CooHpPhp(
    table=[0, 0, 0; 70, 0, 1; 80, 1, 1],
    timeScale=1,
    period=100)
    "Cooling enable command – HP (index 1) and polyvalent HP (index 2)"
    annotation(Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1ShcPhp(
    table=[0, 0; 50, 1; 70, 0],
    timeScale=1,
    period=100)
    "SHC enable command – Polyvalent HP"
    annotation(Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1PumHeaWatPriDed(
    table=[0, 0, 0; 5, 1, 1],
    timeScale=1,
    period=100)
    "Dedicated primary HW pump status – HP (index 1) and polyvalent HP (index 2)"
    annotation(Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1PumChiWatPriDed(
    table=[0, 0; 62, 1],
    timeScale=1,
    period=100)
    "Dedicated primary CHW pump status – Polyvalent HP"
    annotation(Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(u1HeaHpPhp.y, seqEve.u1HeaHpPhp)
    annotation(Line(points={{-58,40},{-20,40},{-20,12},{18,12}},
      color={255,0,255}));
  connect(u1CooHpPhp.y, seqEve.u1CooHpPhp)
    annotation(Line(points={{-58,10},{-20,10},{-20,10},{18,10}},
      color={255,0,255}));
  connect(u1ShcPhp.y, seqEve.u1ShcPhp)
    annotation(Line(points={{-58,-20},{-16,-20},{-16,8},{18,8}},
      color={255,0,255}));
  connect(u1PumHeaWatPriDed.y, seqEve.u1PumHeaWatPriDed_actual)
    annotation(Line(points={{-58,-50},{-12,-50},{-12,0},{18,0}},
      color={255,0,255}));
  connect(u1PumChiWatPriDed.y, seqEve.u1PumChiWatPriDed_actual)
    annotation(Line(points={{-58,-80},{-8,-80},{-8,-6},{18,-6},{18,-6}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Subsequences/Validation/EventSequencingMultiple.mos"
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
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EventSequencingMultiple\">
    Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EventSequencingMultiple</a>
  in a configuration with one reversible heat pump and one polyvalent heat
  pump, with dedicated primary pumps and isolation valves at the HP inlet and
  at the polyvalent HP outlet.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 3, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end EventSequencingMultiple;
