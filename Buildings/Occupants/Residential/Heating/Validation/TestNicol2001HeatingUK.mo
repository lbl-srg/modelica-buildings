within Buildings.Occupants.Residential.Heating.Validation;
model TestNicol2001HeatingUK "To test the model TestNicol2001HeatingUK"
      Modelica.Blocks.Sources.BooleanStep occ "True for occupied"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Sine TOut(
    amplitude=15,
    offset=288,
    freqHz=0.001,
    y(unit="K",
      displayUnit="degC")) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Nicol2001HeatingUK hea
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(hea.occ, occ.y) annotation (Line(points={{-12,6},{-36,6},{-36,20},{-59,
          20}}, color={255,0,255}));
  connect(hea.TOut, TOut.y) annotation (Line(points={{-12,-6},{-36,-6},{-36,-20},
          {-59,-20}}, color={0,0,127}));
annotation (
experiment(Tolerance=1e-6, StopTime=3600.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Residential/Heating/Validation/TestNicol2001HeatingUK.mos"
                      "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates the TestNicol2001HeatingUK model in the heating package by examing how the heater state corresponds
to the outdoor temperature.
</p>
<p>
A outdoor temperature variation was simulated by a ramp function. The output is how the heater state
change with the outdoor temperature.
</p>
</html>"),
    Icon(graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent = {{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
end TestNicol2001HeatingUK;
