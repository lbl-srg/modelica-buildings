within Buildings.Occupancy.Residential.Heating.Validation;
model TestNicol2001HeatingUK "Package with examples to test the model Nicol2001HeatingOnUK"
      "To test the model TestNicol2001HeatingUK"
      Modelica.Blocks.Sources.BooleanStep Occu "True for occupied"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
      Modelica.Blocks.Sources.Sine OutdoorTemp(
        amplitude=15,
        offset=288,
        freqHz=0.001) "Unit: K"
        annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
      Residential.Heating.Nicol2001HeatingUK nicol2001HeatingUK
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    equation
      connect(Occu.y, nicol2001HeatingUK.Occu) annotation (Line(points={{-59,20},
              {-36,20},{-36,2},{-12,2}}, color={255,0,255}));
      connect(OutdoorTemp.y, nicol2001HeatingUK.OutdoorTemp) annotation (Line(
            points={{-59,-20},{-36,-20},{-36,-2},{-12,-2}}, color={0,0,127}));
      annotation (preferredView="info", Documentation(info="<html>
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
