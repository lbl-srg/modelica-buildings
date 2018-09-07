within Buildings.Occupants.Office.Blinds;
package Validation "Package with examples to validate models in Blinds package"
  extends Modelica.Icons.ExamplesPackage;

  model TestNewsham1994BlindsSIntensity
    "Validating the model for blind behaviors"
    extends Modelica.Icons.Example;

    Modelica.Blocks.Sources.BooleanStep occ(startTime=1800)
                                            "True for occupied"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    Modelica.Blocks.Sources.Sine H(
      amplitude=250,
      offset=300,
      freqHz=0.001,
      y(unit="W/m2")) "Solar intensity at the window"
      annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
    Newsham1994BlindsSIntensity bli "Tested blinds model"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(occ.y, bli.occ) annotation (Line(points={{-59,20},{-34,20},{-34,6},{-12,
            6}}, color={255,0,255}));
    connect(H.y, bli.H) annotation (Line(points={{-59,-20},{-36,-20},{-36,-6},{-12,
            -6}}, color={0,0,127}));

  annotation (
  experiment(Tolerance=1e-6, StopTime=3600.0),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Blinds/Validation/TestNewsham1994BlindsSIntensity.mos"
                        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Blinds.Newsham1994BlindsSIntensity\">
Buildings.Occupants.Office.Blinds.Newsham1994BlindsSIntensity</a>
by examing how the blinds state corresponds
to the Solar Intensity.
</p>
<p>
An Solar Intensity variation was simulated by a sine function. The output is how the blind state
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
  end TestNewsham1994BlindsSIntensity;

  model TestInkarojrit2008BlindsSIntensity
    "Validating the model for blind behaviors"
    extends Modelica.Icons.Example;

    Modelica.Blocks.Sources.BooleanStep occ(startTime=1800)
                                            "True for occupied"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    Modelica.Blocks.Sources.Sine H(
      amplitude=250,
      offset=300,
      freqHz=0.001,
      y(unit="W/m2")) "Solar intensity at the window"
      annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
    Inkarojrit2008BlindsSIntensity bli(LSen= 1)
                               "Tested blinds model"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(occ.y, bli.occ) annotation (Line(points={{-59,20},{-34,20},{-34,6},{-12,
            6}}, color={255,0,255}));
    connect(H.y, bli.H) annotation (Line(points={{-59,-20},{-36,-20},{-36,-6},{-12,
            -6}}, color={0,0,127}));

  annotation (
  experiment(Tolerance=1e-6, StopTime=3600.0),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Blinds/Validation/TestInkarojrit2008BlindsSIntensity.mos"
                        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Blinds.Inkarojrit2008BlindsSIntensity\">
Buildings.Occupants.Office.Blinds.Inkarojrit2008BlindsSIntensity</a>
by examing how the blinds state corresponds
to the Solar Intensity.
</p>
<p>
An Solar Intensity variation was simulated by a sine function. The output is how the blind state
changes with the Intensity variation.
</p>
</html>", revisions="<html>
<ul>
<li>
July 23, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
  end TestInkarojrit2008BlindsSIntensity;

  model TestZhang2012BlindsSIntensity
    "Validating the model for blind behaviors"
    extends Modelica.Icons.Example;

    Modelica.Blocks.Sources.BooleanStep occ(startTime=1800)
                                            "True for occupied"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    Modelica.Blocks.Sources.Sine H(
      amplitude=250,
      offset=300,
      freqHz=0.001,
      y(unit="W/m2")) "Solar intensity at the window"
      annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
    Zhang2012BlindsSIntensity bli "Tested blinds model"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(occ.y, bli.occ) annotation (Line(points={{-59,20},{-34,20},{-34,6},{-12,
            6}}, color={255,0,255}));
    connect(H.y, bli.H) annotation (Line(points={{-59,-20},{-36,-20},{-36,-6},{-12,
            -6}}, color={0,0,127}));

  annotation (
  experiment(Tolerance=1e-6, StopTime=3600.0),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Blinds/Validation/TestZhang2012BlindsSIntensity.mos"
                        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Blinds.Zhang2012BlindsSIntensity\">
Buildings.Occupants.Office.Blinds.Zhang2012BlindsSIntensity</a>
by examing how the blinds state corresponds
to the Solar Intensity.
</p>
<p>
An Solar Intensity variation was simulated by a sine function. The output is how the blind state
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
  end TestZhang2012BlindsSIntensity;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples to validate models in Blinds package.
</p>
</html>"));
end Validation;
