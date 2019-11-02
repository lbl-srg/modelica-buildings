within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Validation;
model Scheduler
  "Validation sequence for the device swap scheduler in case of continuous lead device operation"

  parameter Modelica.SIunits.Temperature aveTWetBul = 288.15
    "Chilled water supply set temperature";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    equRot(weeInt=false, dayCou=10)
           "Equipment rotation happens every 10 days at 2am"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Scheduler
    equRot1(weeCou=4, weekday=2)
            "Equipment rotation happens each 4 weeks on Tuesday at 2am"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) "False signal to allow latch"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat1
    annotation (Placement(transformation(extent={{80,60},{100,80}})));

equation

  connect(con.y, lat.clr) annotation (Line(points={{-118,30},{-100,30},{-100,64},
          {-82,64}}, color={255,0,255}));
  connect(con.y, lat1.clr) annotation (Line(points={{-118,30},{60,30},{60,64},{78,
          64}}, color={255,0,255}));
  connect(equRot.yRot, lat.u)
    annotation (Line(points={{-118,70},{-82,70}}, color={255,0,255}));
  connect(equRot1.yRot, lat1.u)
    annotation (Line(points={{42,70},{78,70}}, color={255,0,255}));
annotation (
  experiment(StopTime=10, Tolerance=1e-06),
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
