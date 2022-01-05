within Buildings.Occupants.Office.Lighting.Validation;
model Reinhart2003Light "Validating the model for light behaviors"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine ill(
    amplitude=200,
    offset=250,
    f=0.001) "Minimum illuminance at working plane"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Occupants.Office.Lighting.Reinhart2003Light lig "Tested lighting model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=400)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
equation
  connect(lig.ill, ill.y) annotation (Line(points={{-12,-6},{-36,-6},{-36,-20},
          {-59,-20}}, color={0,0,127}));
  connect(booleanPulse.y, lig.occ) annotation (Line(points={{-59,20},{-36,20},{-36,
          6},{-12,6}}, color={255,0,255}));
annotation (
experiment(Tolerance=1e-6, StopTime=3600.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Lighting/Validation/Reinhart2003Light.mos"
                      "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Lighting.Reinhart2003Light\">
Buildings.Occupants.Office.Lighting.Reinhart2003Light</a>
by examing how the lighting state corresponds
to the minimum illuminance level on the working plane.
</p>
<p>
An illuminance variation was simulated by a sine function. The output is how the lighting state
changes with the illuminance level.
</p>
</html>",
        revisions="<html>
<ul>
<li>
July 26, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Reinhart2003Light;
