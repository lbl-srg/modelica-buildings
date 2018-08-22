within Buildings.Occupants.Office.Lighting.Validation;
model TestHunt1979Light "Validation model for Hunt1979Light"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Sine Illu(
    amplitude=200,
    offset=250,
    freqHz=0.001,
    y) "Minimum illuminance at working plane"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Hunt1979Light lig "Tested Lighting model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanPulse occ(period=400)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
equation
  connect(lig.Illu, Illu.y) annotation (Line(points={{-12,-6},{-36,-6},{-36,-20},
          {-59,-20}}, color={0,0,127}));
  connect(occ.y, lig.occ) annotation (Line(points={{-59,20},{-36,20},{-36,6},{-12,
          6}}, color={255,0,255}));
annotation (
experiment(Tolerance=1e-6, StopTime=3600.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Lighting/Validation/TestHunt1979Light.mos"
                      "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Lighting.Hunt1979Light\">
Buildings.Occupants.Office.Lighting.Hunt1979Light</a>
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
end TestHunt1979Light;
