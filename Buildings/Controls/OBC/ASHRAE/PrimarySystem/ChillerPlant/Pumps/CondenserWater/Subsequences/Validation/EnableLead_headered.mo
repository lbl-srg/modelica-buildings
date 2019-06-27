within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Validation;
model EnableLead_headered
  "Validate sequence for enabling lead pump of plants with headered condenser water pumps"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_headered
    enaLeaConPum
    "Enable lead chilled water pump based on status of chilled water isolation valve status"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiConWatIsoVal(
    final period=3600,
    final startTime=300) "Chiller condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse WSEConWatIsoVal(
    final period=3600,
    final startTime=800) "Water side economizer condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

equation
  connect(chiConWatIsoVal.y, enaLeaConPum.uChiConIsoVal)
    annotation (Line(points={{1,50},{20,50},{20,24},{38,24}}, color={255,0,255}));
  connect(WSEConWatIsoVal.y, enaLeaConPum.uWseConIsoVal)
    annotation (Line(points={{1,-10},{20,-10},{20,16},{38,16}}, color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/CondenserWater/Subsequences/Validation/EnableLead_dedicated.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_dedicated</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Arpil 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end EnableLead_headered;
