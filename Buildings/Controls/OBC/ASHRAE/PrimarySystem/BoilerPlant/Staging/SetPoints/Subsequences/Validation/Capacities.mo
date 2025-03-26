within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation;
model Capacities
  "Validate stage capacities subsequence for boiler stage inputs"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities
    staCap0(
    final nSta=3)
    "Outputs design capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities
    staCap1(
    final nSta=3)
    "Outputs design capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities
    staCap2(
    final nSta=3)
    "Outputs design capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities
    staCap3(
    final nSta=3)
    "Outputs design capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desStaCap[3](
    final k={2e5,1e6,1.5e6})
    "Design stage capacities"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minStaCap[3](
    final k={4e4,2e5,3e5})
    "Minimum stage capacities"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(
    final k=0)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(
    final k=1)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(
    final k=2)
    "Boiler stage"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true)
    "Boolean signal"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage3(
    final k=3)
    "Boiler stage"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage4(
    final k=3)
    "Boiler stage"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage5(
    final k=3)
    "Boiler stage"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage6(
    final k=3)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage7(
    final k=1)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Boolean signal"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

equation
  connect(stage0.y, staCap0.u)
    annotation (Line(points={{-118,30},{-110,30},{-110,13},{-102,13}},
      color={255,127,0}));
  connect(stage1.y, staCap1.u)
    annotation (Line(points={{-38,30},{-30,30},{-30,13},{-22,13}},
      color={255,127,0}));
  connect(stage2.y, staCap2.u)
    annotation (Line(points={{42,30},{50,30},{50,13},{58,13}},
      color={255,127,0}));
  connect(stage3.y, staCap3.u)
    annotation (Line(points={{122,30},{130,30},{130,13},{138,13}},
      color={255,127,0}));
  connect(stage0.y, staCap0.uDown) annotation (Line(points={{-118,30},{-110,30},
          {-110,7},{-102,7}},   color={255,127,0}));
  connect(staCap0.uUp, stage7.y) annotation (Line(points={{-102,10},{-116,10},{-116,
          -10},{-118,-10}},      color={255,127,0}));
  connect(stage0.y, staCap1.uDown) annotation (Line(points={{-118,30},{-70,30},{
          -70,7},{-22,7}},     color={255,127,0}));
  connect(stage6.y, staCap1.uUp) annotation (Line(points={{-38,-10},{-30,-10},{-30,
          10},{-22,10}},     color={255,127,0}));
  connect(stage1.y, staCap2.uDown) annotation (Line(points={{-38,30},{10,30},{10,
          7},{58,7}},      color={255,127,0}));
  connect(staCap2.uUp, stage5.y) annotation (Line(points={{58,10},{50,10},{50,-10},
          {42,-10}},      color={255,127,0}));
  connect(stage2.y, staCap3.uDown) annotation (Line(points={{42,30},{90,30},{90,
          7},{138,7}},   color={255,127,0}));
  connect(staCap3.uUp, stage4.y) annotation (Line(points={{138,10},{130,10},{130,
          -10},{122,-10}},     color={255,127,0}));
  connect(desStaCap.y, staCap0.uDesCap) annotation (Line(points={{-118,110},{
          -106,110},{-106,19},{-102,19}}, color={0,0,127}));
  connect(minStaCap.y, staCap0.uMinCap) annotation (Line(points={{-118,70},{-108,
          70},{-108,16},{-102,16}},     color={0,0,127}));
  connect(desStaCap.y, staCap1.uDesCap) annotation (Line(points={{-118,110},{
          -24,110},{-24,19},{-22,19}}, color={0,0,127}));
  connect(minStaCap.y, staCap1.uMinCap) annotation (Line(points={{-118,70},{-26,
          70},{-26,16},{-22,16}}, color={0,0,127}));
  connect(desStaCap.y, staCap2.uDesCap) annotation (Line(points={{-118,110},{54,
          110},{54,19},{58,19}}, color={0,0,127}));
  connect(minStaCap.y, staCap2.uMinCap) annotation (Line(points={{-118,70},{52,70},
          {52,16},{58,16}},   color={0,0,127}));
  connect(desStaCap.y, staCap3.uDesCap) annotation (Line(points={{-118,110},{
          134,110},{134,19},{138,19}}, color={0,0,127}));
  connect(staCap3.uMinCap, minStaCap.y) annotation (Line(points={{138,16},{132,16},
          {132,70},{-118,70}}, color={0,0,127}));
  connect(con1.y, staCap1.uHig) annotation (Line(points={{-118,-50},{-28,-50},{-28,
          4},{-22,4}},     color={255,0,255}));
  connect(con.y, staCap1.uLow) annotation (Line(points={{-118,-90},{-26,-90},{-26,
          1},{-22,1}},     color={255,0,255}));
  connect(staCap0.uHig, con1.y) annotation (Line(points={{-102,4},{-110,4},{-110,
          -50},{-118,-50}},      color={255,0,255}));
  connect(staCap0.uLow, con.y) annotation (Line(points={{-102,1},{-108,1},{-108,
          -90},{-118,-90}}, color={255,0,255}));
  connect(con1.y, staCap2.uHig) annotation (Line(points={{-118,-50},{52,-50},{52,
          4},{58,4}},    color={255,0,255}));
  connect(con1.y, staCap2.uLow) annotation (Line(points={{-118,-50},{54,-50},{54,
          1},{58,1}},    color={255,0,255}));
  connect(con.y, staCap3.uHig) annotation (Line(points={{-118,-90},{132,-90},{132,
          4},{138,4}},     color={255,0,255}));
  connect(con1.y, staCap3.uLow) annotation (Line(points={{-118,-50},{134,-50},{134,
          1},{138,1}},     color={255,0,255}));
annotation (
 experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/Capacities.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Capacities</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2020, by Karthik Devaprasad:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-180,-120},{180,140}})));
end Capacities;
