within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Capacities_u
  "Validate stage capacities sequence for chiller stage inputs"

  parameter Integer nSta = 2
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5}
    "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Large number for numerical consistency";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap0(final nSta=3)
                     "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap1(final nSta=3)
                     "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap2(final nSta=3)
                     "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Capacities
    staCap3(final nSta=3)
                     "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desStaCap[3](final k={
        2e5,1e6,1.5e6})
                   "Design stage capacities"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaCap[3](final k={
        4e4,2e5,3e5})
                  "Minimum stage capacities"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(final k=0)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  CDL.Logical.Sources.Constant con(final k=true) "Boolean signal"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  CDL.Integers.Sources.Constant                        stage3(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  CDL.Integers.Sources.Constant                        stage4(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  CDL.Integers.Sources.Constant                        stage5(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  CDL.Integers.Sources.Constant                        stage6(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  CDL.Integers.Sources.Constant                        stage7(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  CDL.Logical.Sources.Constant con1(final k=false) "Boolean signal"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
equation
  connect(stage0.y, staCap0.u)
    annotation (Line(points={{-119,30},{-110,30},{-110,13},{-101,13}},
                                                                   color={255,127,0}));
  connect(stage1.y, staCap1.u)
    annotation (Line(points={{-39,30},{-30,30},{-30,13},{-21,13}},
                                                               color={255,127,0}));
  connect(stage2.y, staCap2.u)
    annotation (Line(points={{41,30},{50,30},{50,13},{59,13}},         color={255,127,0}));
  connect(stage3.y, staCap3.u) annotation (Line(points={{121,30},{130,30},{130,13},
          {139,13}}, color={255,127,0}));
  connect(stage0.y, staCap0.uDown) annotation (Line(points={{-119,30},{-110,30},
          {-110,9},{-101,9}}, color={255,127,0}));
  connect(staCap0.uUp, stage7.y) annotation (Line(points={{-101,11},{-116,11},{-116,
          -10},{-119,-10}}, color={255,127,0}));
  connect(stage0.y, staCap1.uDown) annotation (Line(points={{-119,30},{-70,30},{
          -70,9},{-21,9}}, color={255,127,0}));
  connect(stage6.y, staCap1.uUp) annotation (Line(points={{-39,-10},{-30,-10},{-30,
          11},{-21,11}}, color={255,127,0}));
  connect(stage1.y, staCap2.uDown) annotation (Line(points={{-39,30},{10,30},{10,
          9},{59,9}}, color={255,127,0}));
  connect(staCap2.uUp, stage5.y) annotation (Line(points={{59,11},{50,11},{50,-10},
          {41,-10}}, color={255,127,0}));
  connect(stage2.y, staCap3.uDown) annotation (Line(points={{41,30},{90,30},{90,
          9},{139,9}}, color={255,127,0}));
  connect(staCap3.uUp, stage4.y) annotation (Line(points={{139,11},{130,11},{130,
          -10},{121,-10}}, color={255,127,0}));
  connect(desStaCap.y, staCap0.uDesCap) annotation (Line(points={{-119,110},{-106,
          110},{-106,19},{-101,19}}, color={0,0,127}));
  connect(minStaCap.y, staCap0.uMinCap) annotation (Line(points={{-119,70},{-108,
          70},{-108,17},{-101,17}}, color={0,0,127}));
  connect(desStaCap.y, staCap1.uDesCap) annotation (Line(points={{-119,110},{-24,
          110},{-24,19},{-21,19}}, color={0,0,127}));
  connect(minStaCap.y, staCap1.uMinCap) annotation (Line(points={{-119,70},{-26,
          70},{-26,17},{-21,17}}, color={0,0,127}));
  connect(desStaCap.y, staCap2.uDesCap) annotation (Line(points={{-119,110},{54,
          110},{54,19},{59,19}}, color={0,0,127}));
  connect(minStaCap.y, staCap2.uMinCap) annotation (Line(points={{-119,70},{52,70},
          {52,17},{59,17}}, color={0,0,127}));
  connect(desStaCap.y, staCap3.uDesCap) annotation (Line(points={{-119,110},{134,
          110},{134,19},{139,19}}, color={0,0,127}));
  connect(staCap3.uMinCap, minStaCap.y) annotation (Line(points={{139,17},{132,17},
          {132,70},{-119,70}}, color={0,0,127}));
  connect(con1.y, staCap1.uHigh) annotation (Line(points={{-119,-50},{-28,-50},{
          -28,3},{-21,3}}, color={255,0,255}));
  connect(con.y, staCap1.uLow) annotation (Line(points={{-119,-90},{-26,-90},{-26,
          1},{-21,1}}, color={255,0,255}));
  connect(staCap0.uHigh, con1.y) annotation (Line(points={{-101,3},{-110,3},{-110,
          -50},{-119,-50}}, color={255,0,255}));
  connect(staCap0.uLow, con.y) annotation (Line(points={{-101,1},{-108,1},{-108,
          -90},{-119,-90}}, color={255,0,255}));
  connect(con1.y, staCap2.uHigh) annotation (Line(points={{-119,-50},{52,-50},{52,
          3},{59,3}}, color={255,0,255}));
  connect(con1.y, staCap2.uLow) annotation (Line(points={{-119,-50},{54,-50},{54,
          1},{59,1}}, color={255,0,255}));
  connect(con.y, staCap3.uHigh) annotation (Line(points={{-119,-90},{132,-90},{132,
          3},{139,3}}, color={255,0,255}));
  connect(con1.y, staCap3.uLow) annotation (Line(points={{-119,-50},{134,-50},{134,
          1},{139,1}}, color={255,0,255}));
annotation (
 experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_u.mos"
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
October 13, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,140}})));
end Capacities_u;
