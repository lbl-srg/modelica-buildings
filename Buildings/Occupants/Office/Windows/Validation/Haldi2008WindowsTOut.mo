within Buildings.Occupants.Office.Windows.Validation;
model Haldi2008WindowsTOut "Validating the model for window behaviors"
    extends Modelica.Icons.Example;

    Modelica.Blocks.Sources.BooleanStep occ(startTime=1800)
                                            "True for occupied"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Sine TOut(
    amplitude=15,
    offset=288,
    f=0.001,
    y(unit="K", displayUnit="degC")) "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
    Buildings.Occupants.Office.Windows.Haldi2008WindowsTOut win "Tested windows model"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
    connect(win.occ, occ.y) annotation (Line(points={{-12,6},{-36,6},{-36,20},{-59,
            20}}, color={255,0,255}));
    connect(win.TOut, TOut.y) annotation (Line(points={{-12,-6},{-36,-6},{-36,-20},
            {-59,-20}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=3600.0),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Windows/Validation/Haldi2008WindowsTOut.mos"
                        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Windows.Haldi2008WindowsTOut\">
Buildings.Occupants.Office.Windows.Haldi2008WindowsTOut</a>
by examing how the window state corresponds
to the outdoor temperature.
</p>
<p>
An outdoor temperature variation was simulated by a sine function. The output is how the window state
changes with the outdoor temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
July 25, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Haldi2008WindowsTOut;
