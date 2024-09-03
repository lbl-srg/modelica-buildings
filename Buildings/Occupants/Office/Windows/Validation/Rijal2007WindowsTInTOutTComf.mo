within Buildings.Occupants.Office.Windows.Validation;
model Rijal2007WindowsTInTOutTComf "Validating the model for window behaviors"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.BooleanStep occ(startTime=900)
                                          "True for occupied"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Sine TIn(
    amplitude=10,
    f=0.0007,
    y(unit="K", displayUnit="degC"),
    offset=298) "Indoor air temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Sine TOut(
    f=0.001,
    y(unit="K", displayUnit="degC"),
    offset=298,
    amplitude=12) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,-34},{-60,-14}})));
  Modelica.Blocks.Sources.Sine TComf(
    amplitude=2,
    offset=298,
    f=0.0005,
    y(unit="K", displayUnit="degC")) "Comfort air temperature"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Occupants.Office.Windows.Rijal2007WindowsTInTOutTComf win "Tested windows model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(win.occ, occ.y) annotation (Line(points={{-12,6},{-36,6},{-36,40},{
          -59,40}},
                color={255,0,255}));
  connect(win.TOut, TOut.y) annotation (Line(points={{-12,-4},{-36,-4},{-36,-24},
          {-59,-24}}, color={0,0,127}));
  connect(win.TIn, TIn.y) annotation (Line(points={{-12,0},{-42,0},{-42,10},{
          -59,10}},   color={0,0,127}));
  connect(win.TComf, TComf.y) annotation (Line(points={{-12,-8.4},{-28,-8.4},{
          -28,-60},{-59,-60}},
                      color={0,0,127}));
annotation (
experiment(Tolerance=1e-6, StopTime=3600.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Windows/Validation/Rijal2007WindowsTInTOutTComf.mos"
                      "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Windows.Rijal2007WindowsTInTOutTComf\">
Buildings.Occupants.Office.Windows.Rijal2007WindowsTInTOutTComf</a>
by examing how the window state corresponds
to the indoor, outdoor and comfort temperature.
</p>
<p>
The indoor, outdoor, and comfort temperature variation was simulated by sine functions. The output is how the window state
changes with the indoor, outdoor, and comfort temperature.
</p>
</html>",
        revisions="<html>
<ul>
<li>
July 25, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Rijal2007WindowsTInTOutTComf;
