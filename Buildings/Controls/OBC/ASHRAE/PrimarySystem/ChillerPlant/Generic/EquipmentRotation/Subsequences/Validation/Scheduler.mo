within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Validation;
model Scheduler
  "Validation sequence for the device swap scheduler in case of continuous lead device operation"

  parameter Modelica.SIunits.Temperature aveTWetBul = 288.15
    "Chilled water supply set temperature";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch(
    final weeInt=false,
    final dayCou=10) "Equipment rotation happens every 10 days at 2am"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch1(
    final weeCou=2,
    final weekday=2) "Equipment rotation happens bi-weekly on Tuesday at 2am"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch2(
    final weeInt=false,
    final houOfDay=5,
    final dayCou=6) "Equipment rotation happens every 5 days at 6am"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch3(
    final weeInt=true,
    final houOfDay=12,
    final weeCou=4,
    final weekday=6) "Equipment rotation happens every 4 weeks on Saturday at noon"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=1800,
    final falseHoldDuration=0) "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(
    final trueHoldDuration=1800,
    final falseHoldDuration=0) "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(
    final trueHoldDuration=1800,
    final falseHoldDuration=0) "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol3(
    final trueHoldDuration=1800,
    final falseHoldDuration=0) "Holds the signal for visualization purposes"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

equation
  connect(rotSch.yRot, truFalHol.u)
    annotation (Line(points={{-78,30},{-42,30}}, color={255,0,255}));
  connect(rotSch1.yRot, truFalHol1.u)
    annotation (Line(points={{42,30},{78,30}}, color={255,0,255}));
  connect(rotSch2.yRot, truFalHol2.u)
    annotation (Line(points={{-78,-30},{-42,-30}}, color={255,0,255}));
  connect(rotSch3.yRot, truFalHol3.u)
    annotation (Line(points={{42,-30},{78,-30}}, color={255,0,255}));
annotation (
  experiment(StopTime=3000000, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Subsequences/Validation/Scheduler.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Scheduler\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Scheduler</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 5, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-60},{120,60}})));
end Scheduler;
