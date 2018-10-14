within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.Validation;
model Capacities_uChiSta
  "Validate water side economizer tuning parameter sequence"

  parameter Real minPlrSta0 = 0.1
  "Minimal part load ratio of the first stage";

  parameter Real capSta1 = 3.517*1000*310
  "Capacity of stage 1";

  parameter Real capSta0 = minPlrSta0*capSta1
  "Capacity of stage 0";

  parameter Real capSta2 = 2*capSta1
  "Capacity of stage 2";

  Capacities staCap0(
    min_plr1=minPlrSta0,
    nomCapSta1=capSta1,
    nomCapSta2=capSta2)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  CDL.Integers.Sources.Constant stage0(k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  CDL.Integers.Sources.Constant stage1(k=1) "Stage 0"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  CDL.Integers.Sources.Constant stage2(k=2) "Stage 0"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Capacities staCap1(
    min_plr1=0.1,
    nomCapSta1=3.517*1000*310,
    nomCapSta2=2*3.517*1000*310)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Capacities staCap2(
    min_plr1=0.1,
    nomCapSta1=3.517*1000*310,
    nomCapSta2=2*3.517*1000*310)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  CDL.Continuous.Sources.Constant sta0(k=0)
    "Nominal and minimal capacity at stage 0"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  CDL.Continuous.Sources.Constant sta1min(k=minPlrSta0*capSta1)
    "Min capacity at stage 1"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  CDL.Continuous.Sources.Constant sta1(k=capSta1) "Nominal capacity at stage 1"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

  CDL.Continuous.Sources.Constant sta2(k=capSta2) "Nominal capacity at stage 2"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  CDL.Continuous.Feedback absErrorSta0[2]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  CDL.Continuous.Feedback absErrorSta2[2]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  CDL.Continuous.Feedback absErrorSta1[2]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

equation

  connect(stage0.y, staCap0.uChiSta)
    annotation (Line(points={{-59,60},{-42,60}}, color={255,127,0}));
  connect(stage1.y, staCap1.uChiSta)
    annotation (Line(points={{-59,0},{-42,0}}, color={255,127,0}));
  connect(stage2.y, staCap2.uChiSta)
    annotation (Line(points={{-59,-70},{-42,-70}}, color={255,127,0}));
  connect(sta0.y, absErrorSta0[1].u1)
    annotation (Line(points={{21,80},{58,80}}, color={0,0,127}));
  connect(sta0.y, absErrorSta0[2].u1)
    annotation (Line(points={{21,80},{58,80}}, color={0,0,127}));
  connect(staCap0.yCapNomSta, absErrorSta0[1].u2)
    annotation (Line(points={{-19,64},{70,64},{70,68}}, color={0,0,127}));
  connect(staCap0.yCapNomLowSta, absErrorSta0[2].u2)
    annotation (Line(points={{-19,56},{70,56},{70,68}}, color={0,0,127}));
  connect(sta1min.y, absErrorSta1[1].u1) annotation (Line(points={{21,40},{50,40},
          {50,-10},{58,-10}}, color={0,0,127}));
  connect(sta1.y, absErrorSta1[2].u1) annotation (Line(points={{21,10},{50,10},{
          50,-10},{58,-10}}, color={0,0,127}));
  connect(staCap1.yCapNomLowSta, absErrorSta1[1].u2) annotation (Line(points={{-19,
          -4},{-10,-4},{-10,-30},{70,-30},{70,-22}}, color={0,0,127}));
  connect(staCap1.yCapNomSta, absErrorSta1[2].u2) annotation (Line(points={{-19,
          4},{-8,4},{-8,-30},{70,-30},{70,-22}}, color={0,0,127}));
  connect(sta1.y, absErrorSta2[1].u1) annotation (Line(points={{21,10},{50,10},{
          50,-50},{58,-50}}, color={0,0,127}));
  connect(sta2.y, absErrorSta2[2].u1)
    annotation (Line(points={{21,-50},{58,-50}}, color={0,0,127}));
  connect(staCap2.yCapNomLowSta, absErrorSta2[1].u2)
    annotation (Line(points={{-19,-74},{70,-74},{70,-62}}, color={0,0,127}));
  connect(staCap2.yCapNomSta, absErrorSta2[2].u2)
    annotation (Line(points={{-19,-66},{70,-66},{70,-62}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Stage/Validation/Capacities_uChiSta.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerWaterLevel\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerWaterLevel</a>.
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
end Capacities_uChiSta;
