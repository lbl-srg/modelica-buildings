within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model Up "Validate change stage up condition sequence"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up
    staUp(have_locSen=true, effConTruDelay=900)
          "Generates stage up signal"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up
    staUp1(final have_WSE=true, have_locSen=true)
    "Generates stage up signal"
    annotation (Placement(transformation(extent={{140,20},{160,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant avaCur(
    final k=true)
    "Current stage availability"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant avaCur1(
    final k=true)
    "Current stage availability"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(
    final k=0) "0th stage"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(
    final k=1) "1st stage"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup(
    final amplitude=3,
    final freqHz=1/3600,
    final offset=273.15 + 16) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine Ope(
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100,
    final amplitude=0.05) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant StaUp(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
   "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup1(
    final amplitude=3,
    final offset=273.15 + 15.5,
    final freqHz=1/3600)
                        "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat1(
    final amplitude=6895,
    phase=-0.78539816339745,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine Ope1(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant StaUp1(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

equation

  connect(StaUp.y, staUp.uStaUp) annotation (Line(points={{-98,30},{-88,30},{
          -88,38},{-42,38}}, color={0,0,127}));
  connect(Ope.y, staUp.uOpe) annotation (Line(points={{-98,70},{-60,70},{-60,40},
          {-42,40}}, color={0,0,127}));
  connect(TCWSupSet.y, staUp.TChiWatSupSet) annotation (Line(points={{-138,-30},
          {-70,-30},{-70,36},{-42,36}}, color={0,0,127}));
  connect(TCWSup.y, staUp.TChiWatSup) annotation (Line(points={{-138,-70},{-60,
          -70},{-60,34},{-42,34}},color={0,0,127}));
  connect(dpChiWatSet.y, staUp.dpChiWatPumSet_local) annotation (Line(points={{
          -98,-10},{-56,-10},{-56,31},{-42,31}}, color={0,0,127}));
  connect(dpChiWat.y, staUp.dpChiWatPum_local) annotation (Line(points={{-98,
          -50},{-52,-50},{-52,29},{-42,29}}, color={0,0,127}));
  connect(stage0.y, staUp.u) annotation (Line(points={{-138,90},{-50,90},{-50,
          22},{-42,22}}, color={255,127,0}));
  connect(StaUp1.y, staUp1.uStaUp) annotation (Line(points={{82,30},{92,30},{92,
          38},{138,38}}, color={0,0,127}));
  connect(Ope1.y, staUp1.uOpe) annotation (Line(points={{82,70},{120,70},{120,
          40},{138,40}}, color={0,0,127}));
  connect(TCWSupSet1.y, staUp1.TChiWatSupSet) annotation (Line(points={{42,-30},
          {110,-30},{110,36},{138,36}}, color={0,0,127}));
  connect(TCWSup1.y, staUp1.TChiWatSup) annotation (Line(points={{42,-70},{120,
          -70},{120,34},{138,34}}, color={0,0,127}));
  connect(dpChiWatSet1.y, staUp1.dpChiWatPumSet_local) annotation (Line(points=
          {{82,-10},{124,-10},{124,31},{138,31}}, color={0,0,127}));
  connect(dpChiWat1.y, staUp1.dpChiWatPum_local) annotation (Line(points={{82,
          -50},{128,-50},{128,29},{138,29}}, color={0,0,127}));
  connect(stage1.y, staUp1.u) annotation (Line(points={{42,90},{130,90},{130,22},
          {138,22}},color={255,127,0}));
  connect(avaCur.y, staUp.uAvaCur) annotation (Line(points={{-58,-90},{-46,-90},
          {-46,20},{-42,20}}, color={255,0,255}));
  connect(avaCur1.y, staUp1.uAvaCur) annotation (Line(points={{122,-90},{132,
          -90},{132,20},{138,20}}, color={255,0,255}));
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
          extent={{-138,-108},{-76,-132}},
          lineColor={0,0,127},
          textString="Tests stage 0 to stage 1 enable
based on chilled water supply
temperature.

Other inputs are kept the same 
as in the example on the right."),
        Text(
          extent={{46,-106},{106,-128}},
          lineColor={0,0,127},
          textString="Tests stage up enable for any stage above 
and including stage 1. In this test the plant has a WSE. 
The same applies for any stage in case the plant does not have a WSE.")}));
end Up;
