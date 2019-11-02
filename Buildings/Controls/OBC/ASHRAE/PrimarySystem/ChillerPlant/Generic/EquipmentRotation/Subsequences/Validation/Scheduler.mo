within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Validation;
model Scheduler
  "Validation sequence for the device swap scheduler in case of continuous lead device operation"

  parameter Modelica.SIunits.Temperature aveTWetBul = 288.15
    "Chilled water supply set temperature";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch(weeInt=false, dayCou=10)
           "Equipment rotation happens every 10 days at 2am"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch1(weeCou=2, weekday=2)
    "Equipment rotation happens bi-weekly on Tuesday at 2am"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=1800,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(trueHoldDuration=1800,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{80,60},{100,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch2(
    weeInt=false,
    houOfDay=5,
    dayCou=6) "Equipment rotation happens every 5 days at 6am"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol2(trueHoldDuration=1800,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    rotSch3(
    weeInt=true,
    houOfDay=12,
    weeCou=4,
    weekday=6) "Equipment rotation happens every 4 weeks on Satruday at noon"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol3(trueHoldDuration=1800,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

equation

  connect(rotSch.yRot, truFalHol.u)
    annotation (Line(points={{-118,70},{-82,70}}, color={255,0,255}));
  connect(rotSch1.yRot, truFalHol1.u)
    annotation (Line(points={{42,70},{78,70}}, color={255,0,255}));
  connect(rotSch2.yRot, truFalHol2.u)
    annotation (Line(points={{-118,10},{-82,10}}, color={255,0,255}));
  connect(rotSch3.yRot, truFalHol3.u)
    annotation (Line(points={{42,10},{78,10}}, color={255,0,255}));
annotation (
  experiment(StopTime=4000000, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/Validation/PlantEnable.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
  graphics={Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}})));
end Scheduler;
