within Buildings.Experimental.RadiantControl.SlabTempSignal.OutputOnly.Validation;
model SlaSetCor "Validation model for slab temperature error block"

    final parameter Real TSlaSetCor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=294.3;
  SlabSetCore slabSetCore(TSlaCor=TSlaSetCor)
    annotation (Placement(transformation(extent={{-20,-2},{0,18}})));
  annotation (Documentation(info="<html>
<p>
This validates the slab setpoint for a core zone. 
</p>
</html>"),experiment(StopTime=31536000.0, Tolerance=1e-06),Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SlaSetCor;
