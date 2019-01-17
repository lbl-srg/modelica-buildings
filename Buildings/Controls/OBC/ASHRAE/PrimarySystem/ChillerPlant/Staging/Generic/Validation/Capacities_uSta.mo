within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Validation;
model Capacities_uSta
  "Validate water side economizer tuning parameter sequence"

  parameter Integer numSta = 2
  "Highest chiller stage";

  parameter Real minPlrSta0 = 0.1
  "Minimal part load ratio of the first stage";

  parameter Real capSta1 = 3.517*1000*310
  "Capacity of stage 1";

  parameter Real capSta2 = 2*capSta1
  "Capacity of stage 2";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities
    staCap0(
    final min_plr1=minPlrSta0,
    final staNomCap={small,capSta1,capSta2},
    final numSta=2) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities
    staCap1(
    final numSta=2,
    final min_plr1=minPlrSta0,
    final staNomCap={small,capSta1,capSta2})
    "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities
    staCap2(
    final numSta=2,
    final min_plr1=minPlrSta0,
    final staNomCap={small,capSta1,capSta2})
    "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(k=2) "Stage 2"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta0(k=small)
    "Nominal and minimal capacity at stage 0"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta1min(
    final k=minPlrSta0*capSta1)
    "Minimal capacity at stage 1"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta1(
    final k=capSta1) "Nominal capacity at stage 1"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta2(
    final k=capSta2) "Nominal capacity at stage 2"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta0[2]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta2[2]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta1[2]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

equation

  connect(stage0.y, staCap0.uSta)
    annotation (Line(points={{-59,60},{-42,60}}, color={255,127,0}));
  connect(stage1.y, staCap1.uSta)
    annotation (Line(points={{-59,0},{-42,0}}, color={255,127,0}));
  connect(stage2.y, staCap2.uSta)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={255,127,0}));
  connect(staCap0.yStaLow, absErrorSta0[1].u1) annotation (Line(points={{-19,56},
          {50,56},{50,80},{58,80}},         color={0,0,127}));
  connect(staCap0.ySta, absErrorSta0[2].u1) annotation (Line(points={{-19,64},
          {50,64},{50,80},{58,80}},     color={0,0,127}));
  connect(sta0.y, absErrorSta0[1].u2) annotation (Line(points={{21,80},{30,
          80},{30,48},{70,48},{70,68}},
                                   color={0,0,127}));
  connect(staCap1.yStaLow, absErrorSta1[1].u1) annotation (Line(points={{-19,-4},
          {-10,-4},{-10,-10},{58,-10}}, color={0,0,127}));
  connect(staCap1.ySta, absErrorSta1[2].u1) annotation (Line(points={{-19,4},{-10,
          4},{-10,-10},{58,-10}}, color={0,0,127}));
  connect(sta1min.y, absErrorSta1[1].u2) annotation (Line(points={{21,40},{50,40},
          {50,-30},{70,-30},{70,-22}},
                              color={0,0,127}));
  connect(sta1.y, absErrorSta1[2].u2) annotation (Line(points={{21,-30},{70,-30},
          {70,-22}},         color={0,0,127}));
  connect(staCap2.yStaLow, absErrorSta2[1].u1) annotation (Line(points={{-19,-54},
          {50,-54},{50,-50},{58,-50}}, color={0,0,127}));
  connect(staCap2.ySta, absErrorSta2[2].u1) annotation (Line(points={{-19,-46},{
          -10,-46},{-10,-50},{58,-50}},
                                      color={0,0,127}));
  connect(sta1.y, absErrorSta2[1].u2) annotation (Line(points={{21,-30},{40,
          -30},{40,-70},{70,-70},{70,-62}},
                             color={0,0,127}));
  connect(sta2.y, absErrorSta2[2].u2) annotation (Line(points={{21,-70},{70,-70},
          {70,-62}},                   color={0,0,127}));
  connect(sta0.y, absErrorSta0[2].u2) annotation (Line(points={{21,80},{40,
          80},{40,48},{70,48},{70,68}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Generic/Validation/Capacities_uSta.mos"
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
        coordinateSystem(preserveAspectRatio=false)));
end Capacities_uSta;
