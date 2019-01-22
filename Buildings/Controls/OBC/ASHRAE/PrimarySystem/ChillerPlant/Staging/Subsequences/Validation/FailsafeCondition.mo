within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model FailsafeCondition "Validate failsafe condition sequence"


  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon "Failsafe condition to test for the operating part load ratio input"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon1 "Failsafe condition to test for the chilled water supply temperature and differential pressure inputs"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  CDL.Continuous.Sources.Sine oplrUp(
    final freqHz=1/300,
    final amplitude=0.1,
    final offset=0.4) "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  CDL.Continuous.Sources.Constant                        oplrUpMin(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  CDL.Continuous.Sources.Constant TCWSup(final k=273.15 + 18)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  CDL.Continuous.Sources.Constant TCWSupSet(final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  CDL.Continuous.Sources.Constant dpChiWat(final k=62*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  CDL.Continuous.Sources.Constant dpChiWatSet(final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));


  CDL.Continuous.Sources.Constant oplrUpMin1(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  CDL.Continuous.Sources.Constant TCWSupSet1(final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  CDL.Continuous.Sources.Constant dpChiWatSet1(final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  CDL.Continuous.Sources.Constant oplrUp1(final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  CDL.Continuous.Sources.Sine TCWSup1(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600)       "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  CDL.Continuous.Sources.Sine dpChiWat2(
    final amplitude=6895,
    final offset=63.5*6895,
    startTime=300,
    final freqHz=1/1200)  "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
equation

  connect(oplrUpMin.y, faiSafCon.uOplrUpMin) annotation (Line(points={{-159,130},
          {-120,130},{-120,154},{-81,154}}, color={0,0,127}));
  connect(oplrUp.y, faiSafCon.uOplrUp) annotation (Line(points={{-159,170},{-120,
          170},{-120,158},{-81,158}}, color={0,0,127}));
  connect(TCWSup.y, faiSafCon.TChiWatSup) annotation (Line(points={{-159,50},{-140,
          50},{-140,120},{-100,120},{-100,147},{-81,147}}, color={0,0,127}));
  connect(TCWSupSet.y, faiSafCon.TChiWatSupSet) annotation (Line(points={{-159,90},
          {-142,90},{-142,122},{-102,122},{-102,149},{-81,149}}, color={0,0,127}));
  connect(dpChiWatSet.y, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-99,
          90},{-90,90},{-90,143},{-81,143}}, color={0,0,127}));
  connect(dpChiWat.y, faiSafCon.dpChiWatPum) annotation (Line(points={{-99,50},{
          -88,50},{-88,141},{-81,141}}, color={0,0,127}));
  connect(oplrUpMin1.y, faiSafCon1.uOplrUpMin) annotation (Line(points={{61,130},
          {100,130},{100,154},{139,154}}, color={0,0,127}));
  connect(TCWSupSet1.y, faiSafCon1.TChiWatSupSet) annotation (Line(points={{61,90},
          {78,90},{78,122},{118,122},{118,149},{139,149}}, color={0,0,127}));
  connect(dpChiWatSet1.y, faiSafCon1.dpChiWatPumSet) annotation (Line(points={{121,
          90},{130,90},{130,143},{139,143}}, color={0,0,127}));
  connect(oplrUp1.y, faiSafCon1.uOplrUp) annotation (Line(points={{61,170},{100,
          170},{100,158},{139,158}}, color={0,0,127}));
  connect(TCWSup1.y, faiSafCon1.TChiWatSup) annotation (Line(points={{61,50},{80,
          50},{80,120},{120,120},{120,147},{139,147}}, color={0,0,127}));
  connect(dpChiWat2.y, faiSafCon1.dpChiWatPum) annotation (Line(points={{121,50},
          {132,50},{132,141},{139,141}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_uSta.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-220},{200,220}})));
end FailsafeCondition;
