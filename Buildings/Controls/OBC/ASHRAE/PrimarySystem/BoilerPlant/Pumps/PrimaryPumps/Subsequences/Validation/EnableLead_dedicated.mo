within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Validation;
model EnableLead_dedicated
    "Validate sequence for enabling lead pump of plants with dedicated primary hot water pumps"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_dedicated
    enaLeaPriPum
    "Enable and disable lead hot water primary pump"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=3600,
    final shift=300)
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

equation
  connect(booPul.y,enaLeaPriPum. uPlaEna) annotation (Line(points={{-28,0},{20,0},
          {20,5},{38,5}}, color={255,0,255}));

  connect(booPul.y,enaLeaPriPum.uLeaBoiSta)
    annotation (Line(points={{-28,0},{20,0},{20,-5},{38,-5}}, color={255,0,255}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/PrimaryPumps/Subsequences/Validation/EnableLead_dedicated.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_dedicated</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2020, by Karthik Devaprasad:<br/>
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
end EnableLead_dedicated;
