within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model DDSPsetSimulation
  "Simulates changing most open damper position to reset down duct static pressure set point."
  DDSPset dDSPset(conPID(
      k=0.0000001,
      Ti=0.0025,
      reverseAction=true))
    annotation (Placement(transformation(extent={{28,4},{42,20}})));
  CDL.Continuous.Sources.Sine                        mostOpenDamGen(
    amplitude=15,
    freqHz=1/4120,
    offset=85) annotation (Placement(transformation(extent={{-40,14},{-20,34}})));
equation
  connect(dDSPset.mostOpenDam, mostOpenDamGen.y) annotation (Line(points={{26.2,
          10.4},{4,10.4},{4,24},{-18,24}}, color={0,0,127}));
  annotation (
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
</html>"));
end DDSPsetSimulation;
