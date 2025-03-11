within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Validation;
model Two_uRot
  "Validation sequence for device role rotation for two devices or groups of devices"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two rotTwo
    "Rotates roles between two devices or groups of devices"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two rotTwo1
    "Rotates roles between two devices or groups of devices"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger rotation(period(
        displayUnit="h") = 86400, shift=7200) "Rotation trigger"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger rotation1(period(
        displayUnit="h") = 172800, shift=7200) "Rotation trigger"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

equation
  connect(rotation.y, rotTwo.uRot)
    annotation (Line(points={{-18,30},{18,30}}, color={255,0,255}));
  connect(rotation1.y, rotTwo1.uRot)
    annotation (Line(points={{-18,-30},{18,-30}}, color={255,0,255}));
annotation (
  experiment(StopTime=1000000, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Subsequences/Validation/Two_uRot.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two</a>.
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}})));
end Two_uRot;
