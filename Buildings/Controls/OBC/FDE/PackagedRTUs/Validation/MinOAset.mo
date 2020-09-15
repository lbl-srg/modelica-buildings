within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model MinOAset "This model simulates MinOAset"
  Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset MinOAset
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
  OccGen(width=0.5, period=2880)
    annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
equation

  connect(OccGen.y, MinOAset.occ)
    annotation (Line(points={{-20,0},{10,0}}, color={255,0,255}));
  annotation (
  experiment(
    StopTime=5760,
    Tolerance=1e-06,
    __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/FDE/PackagedRTUs/Validation/MinOAset.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset\">
Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset</a>.
</p>
</html>", revisions="<html>
<ul>
<li>August 21, 2020, by Henry Nickels:<br/>
Built simulation script.</li>
<li>August 16, 2020, by Henry Nickels:<br/>
Added 'experiment' annotation.</li>
<li>July 28, 2020, by Henry Nickels:<br/>
First implementation. 
</li>
</ul>
</html>
"));
end MinOAset;
