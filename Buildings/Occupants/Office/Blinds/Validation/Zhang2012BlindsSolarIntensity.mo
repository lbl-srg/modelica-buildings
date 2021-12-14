within Buildings.Occupants.Office.Blinds.Validation;
model Zhang2012BlindsSolarIntensity
    "Validating the model for blind behaviors"
    extends Modelica.Icons.Example;

    Modelica.Blocks.Sources.BooleanStep occ(startTime=1800)
                                            "True for occupied"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Sine H(
    amplitude=250,
    offset=300,
    f=0.001,
    y(unit="W/m2")) "Solar intensity at the window"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
    Buildings.Occupants.Office.Blinds.Zhang2012BlindsSolarIntensity bli "Tested blinds model"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
    connect(occ.y, bli.occ) annotation (Line(points={{-59,20},{-34,20},{-34,6},{-12,
            6}}, color={255,0,255}));
    connect(H.y, bli.H) annotation (Line(points={{-59,-20},{-36,-20},{-36,-6},{-12,
            -6}}, color={0,0,127}));

  annotation (
  experiment(Tolerance=1e-6, StopTime=3600.0),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Blinds/Validation/Zhang2012BlindsSolarIntensity.mos"
                        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Blinds.Zhang2012BlindsSolarIntensity\">
Buildings.Occupants.Office.Blinds.Zhang2012BlindsSolarIntensity</a>
by examing how the blinds state corresponds
to the solar intensity.
</p>
<p>
A solar intensity variation was simulated by a sine function. The output is how the blind state
changes with the Intensity variation.
</p>
</html>", revisions="<html>
<ul>
<li>
July 24, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Zhang2012BlindsSolarIntensity;
