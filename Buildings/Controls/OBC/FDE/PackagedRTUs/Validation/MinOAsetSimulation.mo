within Buildings.Controls.OBC.FDE.PackagedRTUs.Validation;
model MinOAsetSimulation
  "Simulation of the minimum outdoor air flow set point selector."
  MinOAset minOAset
    annotation (Placement(transformation(extent={{22,6},{34,16}})));
  CDL.Logical.Sources.Pulse                        OccGen(width=0.5, period=
        2880)
    annotation (Placement(transformation(extent={{-54,10},{-34,30}})));
equation
  connect(minOAset.Occ, OccGen.y) annotation (Line(points={{20,11.6},{-6,11.6},
          {-6,20},{-32,20}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MinOAsetSimulation;
