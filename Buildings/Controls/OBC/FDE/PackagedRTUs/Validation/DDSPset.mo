within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model DDSPset "This model simulates DDSPset"
  Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset ddspst(
  conPID(
      k=0.0000001,
      Ti=0.0025,
      reverseAction=true))
    annotation (Placement(transformation(extent={{28,4},{42,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine mostOpenDamGen(
    amplitude=15,
    freqHz=1/4120,
    offset=85)
    annotation (Placement(transformation(extent={{-40,14},{-20,34}})));
equation
  connect(dspst.mostOpenDam, mostOpenDamGen.y)
  annotation (Line(
  points={{26.6,10.4},{4,10.4},{4,24},{-18,24}},
  color={0,0,127}));
  annotation (
    experiment(
      StopTime=5760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/FDE/PackagedRTUs/Validation/DDSPset.mos"
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
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset\">
Buildings.Controls.OBC.FDE.PackagedRTUs.DDSPset</a>.
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
end DDSPset;
