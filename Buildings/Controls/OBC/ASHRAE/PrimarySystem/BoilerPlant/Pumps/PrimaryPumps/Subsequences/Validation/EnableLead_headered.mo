within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.Validation;
model EnableLead_headered
    "Validate sequence for enabling lead pump of plants with headered primary hot water pumps"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_headered
    enaLeaPriPum(
    final nBoi=2)
    "Enable lead hot water pump based on the status of hot water isolation valves"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    final period=600,
    final shift=300)
    "Real pulse signal"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1(
    final period=1000,
    final shift=500)
    "Real pulse signal"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));

equation
  connect(pul.y, enaLeaPriPum.uHotWatIsoVal[1]) annotation (Line(points={{-28,30},
          {-16,30},{-16,-1},{-2,-1}}, color={0,0,127}));
  connect(pul1.y, enaLeaPriPum.uHotWatIsoVal[2]) annotation (Line(points={{-28,-30},
          {-16,-30},{-16,1},{-2,1}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Pumps/PrimaryPumps/Subsequences/Validation/EnableLead_headered.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences.EnableLead_headered</a>.
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
end EnableLead_headered;
