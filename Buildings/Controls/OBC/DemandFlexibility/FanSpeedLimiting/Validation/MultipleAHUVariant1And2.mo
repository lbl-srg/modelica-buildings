within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Validation;
model MultipleAHUVariant1And2
  "Multiple air handling units in Variant 1 and 2"

  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/FanSpeedLimiting/Validation/MultipleAHUVariant1And2.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Controller\">
Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Controller</a>
for multiple chillers under Variant <i>1</i> and Variant <i>2</i> of setpoint
control.
</p>
</html>",revisions="<html>
<ul>
<li>
October 29, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}},
        grid={2,2}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, grid={2,2})));
end MultipleAHUVariant1And2;
