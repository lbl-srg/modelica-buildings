within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.Validation;
model SelectModeState
  "Validation model for equipment mode selection"
  parameter Integer nHp = 2
    "Number of reversible heat pumps"
    annotation(Evaluate=true);
  parameter Integer nPhp = 2
    "Number of polyvalent units"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaHp(
    table=[0, 1, 1; 80, 0, 1],
    timeScale=1,
    period=100)
    "HP available signal"
    annotation(Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.SelectModeState selMod(
    have_chiWat=true,
    final nHp=nHp,
    final nPhp=nPhp)
    "Equipment mode selection"
    annotation(Placement(transformation(extent={{40,-12},{60,12}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uStaHea(
    table=[0, 0, 0; 10, 1, 2; 20, 2, 2; 30, 3, 1; 40, 4, 3],
    timeScale=1,
    period=50)
    "Heating stage index"
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));
  PolyvalentHeatPumps.StagingParameters staPhp(final nHp=nHp, final nPhp=nPhp)
    "Generate staging parameters"
    annotation(Placement(transformation(extent={{60,60},{80,80}})));
  PolyvalentHeatPumps.ExtractStagingMatrix extStaHea(
    final sta=staPhp.staHea,
    is_transpose=true)
    "Extract transpose of heating staging matrix at cooling stage"
    annotation(Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaPhp1(
    table=[0, 1, 1],
    timeScale=1,
    period=100)
    "Polyvalent HP available signal in single mode"
    annotation(Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1AvaPhp2(
    table=[0, 1, 1],
    timeScale=1,
    period=100)
    "Polyvalent HP available signal in SHC mode"
    annotation(Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSorHp[nHp](
    k={i for i in 1:nHp})
    "HP runtime order"
    annotation(Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxSorPhp[nPhp](
    k={i for i in nPhp:-1:1})
    "Polyvalent HP runtime order"
    annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable uStaCoo(
    table=[0, 0; 60, 3],
    timeScale=1,
    period=100)
    "Cooling stage index"
    annotation(Placement(transformation(extent={{-60,10},{-40,30}})));
  PolyvalentHeatPumps.ExtractStagingMatrix extStaCoo(
    final sta=staPhp.staCoo,
    is_transpose=true)
    "Extract transpose of cooling staging matrix at heating stage"
    annotation(Placement(transformation(extent={{-30,-30},{-10,-10}})));
equation
  connect(uStaHea.y[1], selMod.uStaHea)
    annotation(Line(points={{-68,0},{-40,0},{-40,2},{38,2}},
      color={255,127,0}));
  connect(extStaHea.y, selMod.staTraHea)
    annotation(Line(points={{-8,20},{0,20},{0,10},{38,10}},
      color={0,0,127}));
  connect(u1AvaHp.y, selMod.u1AvaHeaHp)
    annotation(Line(points={{-68,-40},{8,-40},{8,-2},{38,-2}},
      color={255,0,255}));
  connect(u1AvaPhp1.y, selMod.u1AvaHeaPhp)
    annotation(Line(points={{-38,-60},{12,-60},{12,-6},{38,-6}},
      color={255,0,255}));
  connect(u1AvaPhp2.y, selMod.u1AvaShcPhp)
    annotation(Line(points={{-68,-80},{16,-80},{16,-10},{38,-10}},
      color={255,0,255}));
  connect(idxSorHp.y, selMod.uIdxSorHp)
    annotation(Line(points={{-38,60},{34,60},{34,6},{38,6}},
      color={255,127,0}));
  connect(idxSorPhp.y, selMod.uIdxSorPhp)
    annotation(Line(points={{-68,40},{32,40},{32,4},{38,4}},
      color={255,127,0}));
  connect(uStaCoo.y[1], extStaHea.u)
    annotation(Line(points={{-38,20},{-32,20}},
      color={255,127,0}));
  connect(u1AvaPhp1.y, selMod.u1AvaCooPhp)
    annotation(Line(points={{-38,-60},{12,-60},{12,-8},{38,-8}},
      color={255,0,255}));
  connect(u1AvaHp.y, selMod.u1AvaCooHp)
    annotation(Line(points={{-68,-40},{8,-40},{8,-4},{38,-4}},
      color={255,0,255}));
  connect(extStaCoo.y, selMod.staTraCoo)
    annotation(Line(points={{-8,-20},{0,-20},{0,8},{38,8}},
      color={0,0,127}));
  connect(uStaHea.y[1], extStaCoo.u)
    annotation(Line(points={{-68,0},{-40,0},{-40,-20},{-32,-20}},
      color={255,127,0}));
  connect(uStaCoo.y[1], selMod.uStaCoo)
    annotation(Line(points={{-38,20},{-34,20},{-34,0},{38,0}},
      color={255,127,0}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/HeatPumps/Subsequences/Validation/SelectModeState.mos"
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
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.SelectModeState\">
    Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.SelectModeState</a>
  in a configuration with two reversible heat pumps and two polyvalent heat
  pumps.
</p>
<p>
  The heating stage index is stepped from stage
  <i>0</i> to stage <i>4</i> and the cooling stage index is stepped from stage
  <i>0</i> to stage <i>3</i>, each independently over time, to exercise
  equipment selection at each stage. The runtime order of the polyvalent heat
  pumps is set to the reverse of that of the reversible heat pumps, so that
  selection by priority order can be observed.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 1, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end SelectModeState;
