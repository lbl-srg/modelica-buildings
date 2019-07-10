within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Capacities_uLow_uHig
  "Validate stage capacities subsequence for highest and lowest available stage inputs"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap0(final nSta=3)
    "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap1(final nSta=3)
    "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap2(final nSta=3)
    "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desStaCap[3](
    final k={2e5,1e6,1.5e6}) "Design stage capacities"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaCap[3](
    final k={4e4,2e5,3e5}) "Minimum stage capacities"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=true)
    "Boolean signal"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage5(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage6(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage7(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Boolean signal"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
equation
  connect(stage0.y, staCap0.u)
    annotation (Line(points={{-79,30},{-70,30},{-70,13},{-61,13}},
    color={255,127,0}));
  connect(stage1.y, staCap1.u)
    annotation (Line(points={{1,30},{10,30},{10,13},{19,13}},
    color={255,127,0}));
  connect(stage2.y, staCap2.u)
    annotation (Line(points={{81,30},{90,30},{90,13},{99,13}}, color={255,127,0}));
  connect(stage0.y, staCap1.uDown) annotation (Line(points={{-79,30},{-30,30},{-30,
          9},{19,9}},      color={255,127,0}));
  connect(stage6.y, staCap1.uUp) annotation (Line(points={{1,-10},{10,-10},{10,11},
          {19,11}},      color={255,127,0}));
  connect(stage1.y, staCap2.uDown) annotation (Line(points={{1,30},{50,30},{50,9},
          {99,9}},    color={255,127,0}));
  connect(staCap2.uUp, stage5.y) annotation (Line(points={{99,11},{90,11},{90,-10},
          {81,-10}}, color={255,127,0}));
  connect(desStaCap.y, staCap0.uDesCap) annotation (Line(points={{-79,110},{-66,
          110},{-66,19},{-61,19}},   color={0,0,127}));
  connect(minStaCap.y, staCap0.uMinCap) annotation (Line(points={{-79,70},{-68,70},
          {-68,17},{-61,17}},       color={0,0,127}));
  connect(desStaCap.y, staCap1.uDesCap) annotation (Line(points={{-79,110},{16,110},
          {16,19},{19,19}},        color={0,0,127}));
  connect(minStaCap.y, staCap1.uMinCap) annotation (Line(points={{-79,70},{14,70},
          {14,17},{19,17}},       color={0,0,127}));
  connect(desStaCap.y, staCap2.uDesCap) annotation (Line(points={{-79,110},{94,110},
          {94,19},{99,19}},      color={0,0,127}));
  connect(minStaCap.y, staCap2.uMinCap) annotation (Line(points={{-79,70},{92,70},
          {92,17},{99,17}}, color={0,0,127}));
  connect(con1.y, staCap1.uHig) annotation (Line(points={{-79,-50},{12,-50},{12,
          3},{19,3}}, color={255,0,255}));
  connect(con.y, staCap1.uLow) annotation (Line(points={{-79,-90},{14,-90},{14,1},
          {19,1}},     color={255,0,255}));
  connect(staCap0.uUp, stage0.y) annotation (Line(points={{-61,11},{-70,11},{-70,
          30},{-79,30}}, color={255,127,0}));
  connect(stage7.y, staCap0.uDown) annotation (Line(points={{-79,-10},{-70,-10},
          {-70,9},{-61,9}}, color={255,127,0}));
  connect(con1.y, staCap0.uLow) annotation (Line(points={{-79,-50},{-66,-50},{-66,
          1},{-61,1}}, color={255,0,255}));
  connect(con.y, staCap0.uHig) annotation (Line(points={{-79,-90},{-68,-90},{-68,
          3},{-61,3}}, color={255,0,255}));
  connect(con.y, staCap2.uHig) annotation (Line(points={{-79,-90},{92,-90},{92,3},
          {99,3}}, color={255,0,255}));
  connect(con.y, staCap2.uLow) annotation (Line(points={{-79,-90},{94,-90},{94,1},
          {99,1}}, color={255,0,255}));
annotation (
 experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_uLow_uHig.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{140,140}})));
end Capacities_uLow_uHig;
