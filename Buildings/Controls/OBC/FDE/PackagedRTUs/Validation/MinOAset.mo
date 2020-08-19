within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model MinOAset "This model simulates MinOAset"
  Buildings.Controls.OBC.FDE.PackagedRTUs.MinOAset miOAset
    annotation (Placement(transformation(extent={{22,6},{34,16}})));
  Buildings.Controls.OBC.FDE.PackagedRTUs.CDL.Logical.Sources.Pulse
  OccGen(
  width=0.5,
  period=2880)
    annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
equation
  connect(minOAset.occ, OccGen.y) annotation (Line(points={{20.8,11},{-6,11},{
          -6,20},{-32,20}},  color={255,0,255}));


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
<li>August 16, 2020, by Henry Nickels:<br/>
Added 'experiment' annotation.</li>
<li>July 28, 2020, by Henry Nickels:<br/>
First implementation. 
</li>
</ul>
</html>
"));
end MinOAset;
