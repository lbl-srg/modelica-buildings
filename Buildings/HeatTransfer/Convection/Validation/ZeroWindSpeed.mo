within Buildings.HeatTransfer.Convection.Validation;
model ZeroWindSpeed "Validation model for zero wind speed"
  extends Buildings.HeatTransfer.Convection.Examples.Exterior(vWin(k=0));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},
            {140,180}})),
experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Convection/Validation/ZeroWindSpeed.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the convective heat transfer models for exterior surfaces if the wind speed is zero.
From <i>t=0...3600</i> seconds, the wind traverses from North to West to South to East and back to
North. The plot validates that there is no influence of the wind direction on the forced convection
coefficient for wall surfaces that face North, West, East and South if the wind speed is zero.
</p>
</html>", revisions="<html>
<ul>
<li>
May 7, 2020, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1923\">#1923</a>.
</li>
</ul>
</html>"));
end ZeroWindSpeed;
