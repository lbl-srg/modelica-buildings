within Buildings.Experimental.RadiantControl.SlabTempSignal.OutputOnly.Validation;
model ForHiChi "Validation model for forecast high temperature for Chicago"
  ForecastHighChicago forecastHighChicago
    annotation (Placement(transformation(extent={{-20,18},{0,38}})));
  annotation (Documentation(info="<html>
<p>
This validates the Chicago forecast high. 
</p>
</html>"),experiment(StopTime=172800.0, Tolerance=1e-06),Icon(graphics={
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
end ForHiChi;
