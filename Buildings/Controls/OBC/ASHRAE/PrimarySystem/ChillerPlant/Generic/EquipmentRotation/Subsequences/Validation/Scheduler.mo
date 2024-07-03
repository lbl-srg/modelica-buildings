within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Validation;
model Scheduler
  "Validation sequence for the device swap scheduler in case of continuous lead device operation"

  parameter Real aveTWetBul(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
      "Chilled water supply set temperature";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch(
    final simTimSta=false,
    final weeInt=false,
    final dayCou=10) "Equipment rotation happens every 10 days at 2am"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch1(
    final simTimSta=false,
    weeInt=true,
    final weeCou=2,
    final weekday=2) "Equipment rotation happens bi-weekly on Tuesday at 2am"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch2(
    final weeInt=false,
    final houOfDay=5,
    final dayCou=6) "Equipment rotation happens every 5 days at 6am"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch3(
    final simTimSta=false,
    final weeInt=true,
    final houOfDay=12,
    final weeCou=4,
    final weekday=6) "Equipment rotation happens every 4 weeks on Saturday at noon"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch4(
    final rotationPeriod=86400,
    simTimSta=true,
    final weeInt=true,
    final houOfDay=12,
    final weeCou=4,
    final weekday=6) "Equipment rotation happens every 4 weeks on Saturday at noon"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=1800,
    final falseHoldDuration=0) "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    final trueHoldDuration=1800,
    final falseHoldDuration=0) "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(
    final trueHoldDuration=1800,
    final falseHoldDuration=0) "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol3(
    final trueHoldDuration=1800,
    final falseHoldDuration=0) "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol4(
    final trueHoldDuration=1800,
    final falseHoldDuration=0)
    "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

equation
  connect(rotSch.yRot, truFalHol.u)
    annotation (Line(points={{-18,80},{18,80}},  color={255,0,255}));
  connect(rotSch1.yRot, truFalHol1.u)
    annotation (Line(points={{-18,40},{18,40}},color={255,0,255}));
  connect(rotSch2.yRot, truFalHol2.u)
    annotation (Line(points={{-18,0},{18,0}},      color={255,0,255}));
  connect(rotSch3.yRot, truFalHol3.u)
    annotation (Line(points={{-18,-40},{18,-40}},color={255,0,255}));
  connect(rotSch4.yRot,truFalHol4. u)
    annotation (Line(points={{-18,-80},{18,-80}},color={255,0,255}));
annotation (
  experiment(StopTime=3000000, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Subsequences/Validation/Scheduler.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(extent={{-60,-100},{60,100}}),
       graphics={Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-100},{60,100}})));
end Scheduler;
