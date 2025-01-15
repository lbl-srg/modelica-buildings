within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Validation;
model EnableLead_headered
  "Validate sequence for enabling lead pump of plants with headered condenser water pumps"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_headered
    enaLeaConPum
    "Enable lead chilled water pump based on status of chilled water isolation valve status"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiConWatIsoVal[2](
    final period=fill(3600, 2),
    final shift=fill(300, 2))
    "Chiller condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse WSEConWatIsoVal(
    final period=3600,
    final shift=800) "Water side economizer condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

equation
  connect(WSEConWatIsoVal.y, enaLeaConPum.uWseConIsoVal)
    annotation (Line(points={{2,-30},{20,-30},{20,0},{38,0}},   color={255,0,255}));
  connect(chiConWatIsoVal.y, enaLeaConPum.uChiConIsoVal) annotation (Line(
        points={{2,30},{20,30},{20,6},{38,6}}, color={255,0,255}));
  connect(con1.y, enaLeaConPum.uEnaPla) annotation (Line(points={{2,-70},{30,-70},
          {30,-6},{38,-6}}, color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/CondenserWater/Subsequences/Validation/EnableLead_headered.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_headered</a>.
</p>
<p>
It shows the process of enabling and disabling lead condenser water pump
of the plants with headered condenser water pumps.
</p>
<p>
The instance <code>enaLeaConPum</code> shows that the lead pump is enabled at 300
seconds when there is chiller condenser water isolation valve being enabled. The pump
becomes disabled when both the chiller condenser water isolation valve and the waterside
economizer condenser water isolation valve are disabled.
</p>
</html>", revisions="<html>
<ul>
<li>
August 4, 2019, by Jianjun Hu:<br/>
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
