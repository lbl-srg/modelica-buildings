within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model Up "Validate change stage up condition sequence"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up
    staUp(have_locSen=true, effConTruDelay=900)
          "Generates stage up signal"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up
    staUp1(final have_WSE=true, have_locSen=true)
    "Generates stage up signal"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant avaCur(
    final k=true)
    "Current stage availability"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant avaCur1(
    final k=true)
    "Current stage availability"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  CDL.Logical.Sources.Pulse                        booPul(final width=0.1,
      final period=3600)
    "Enabled plant"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  CDL.Logical.Not                        not1
    "Logical not"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(
    final k=0) "0th stage"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(
    final k=1) "1st stage"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TCWSup(
    final amplitude=3,
    final freqHz=1/3600,
    final offset=273.15 + 16) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin dpChiWat(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin Ope(
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100,
    final amplitude=0.05) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant StaUp(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
   "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TCWSup1(
    final amplitude=3,
    final offset=273.15 + 15.5,
    final freqHz=1/3600)
                        "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin dpChiWat1(
    final amplitude=6895,
    phase=-0.78539816339745,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin Ope1(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant StaUp1(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

equation

  connect(StaUp.y, staUp.uStaUp) annotation (Line(points={{-98,60},{-88,60},{
          -88,69},{-42,69}}, color={0,0,127}));
  connect(Ope.y, staUp.uOpe) annotation (Line(points={{-98,100},{-80,100},{-80,
          71},{-42,71}},
                     color={0,0,127}));
  connect(TCWSupSet.y, staUp.TChiWatSupSet) annotation (Line(points={{-138,0},{
          -80,0},{-80,67},{-42,67}},    color={0,0,127}));
  connect(TCWSup.y, staUp.TChiWatSup) annotation (Line(points={{-138,-40},{-74,
          -40},{-74,65},{-42,65}},color={0,0,127}));
  connect(dpChiWatSet.y, staUp.dpChiWatPumSet_local) annotation (Line(points={{-98,20},
          {-68,20},{-68,63},{-42,63}},           color={0,0,127}));
  connect(dpChiWat.y, staUp.dpChiWatPum_local) annotation (Line(points={{-98,-20},
          {-62,-20},{-62,61},{-42,61}},      color={0,0,127}));
  connect(stage0.y, staUp.u) annotation (Line(points={{-138,120},{-56,120},{-56,
          55},{-42,55}}, color={255,127,0}));
  connect(StaUp1.y, staUp1.uStaUp) annotation (Line(points={{82,60},{92,60},{92,
          69},{138,69}}, color={0,0,127}));
  connect(Ope1.y, staUp1.uOpe) annotation (Line(points={{82,100},{100,100},{100,
          71},{138,71}}, color={0,0,127}));
  connect(TCWSupSet1.y, staUp1.TChiWatSupSet) annotation (Line(points={{42,0},{
          100,0},{100,67},{138,67}},    color={0,0,127}));
  connect(TCWSup1.y, staUp1.TChiWatSup) annotation (Line(points={{42,-40},{106,
          -40},{106,65},{138,65}}, color={0,0,127}));
  connect(dpChiWatSet1.y, staUp1.dpChiWatPumSet_local) annotation (Line(points={{82,20},
          {112,20},{112,63},{138,63}},            color={0,0,127}));
  connect(dpChiWat1.y, staUp1.dpChiWatPum_local) annotation (Line(points={{82,-20},
          {118,-20},{118,61},{138,61}},      color={0,0,127}));
  connect(stage1.y, staUp1.u) annotation (Line(points={{42,120},{124,120},{124,
          55},{138,55}},
                    color={255,127,0}));
  connect(avaCur.y, staUp.uAvaCur) annotation (Line(points={{-78,-60},{-56,-60},
          {-56,53},{-42,53}}, color={255,0,255}));
  connect(avaCur1.y, staUp1.uAvaCur) annotation (Line(points={{102,-60},{124,
          -60},{124,53},{138,53}}, color={255,0,255}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{-138,-90},{-122,-90}}, color={255,0,255}));
  connect(not1.y, staUp.uPla) annotation (Line(points={{-98,-90},{-50,-90},{-50,
          51},{-42,51}}, color={255,0,255}));
  connect(avaCur1.y, staUp1.uPla) annotation (Line(points={{102,-60},{124,-60},
          {124,51},{138,51}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2020, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,
            140}}),
        graphics={
        Text(
          extent={{-138,-110},{-76,-134}},
          textColor={0,0,127},
          textString="Tests stage 0 to stage 1 enable
based on chilled water supply
temperature.

Other inputs are kept the same 
as in the example on the right."),
        Text(
          extent={{46,-108},{106,-130}},
          textColor={0,0,127},
          textString="Tests stage up enable for any stage above 
and including stage 1. In this test the plant has a WSE. 
The same applies for any stage in case the plant does not have a WSE.")}));
end Up;
