within Buildings.Occupants.Office.Windows.Validation;
model Yun2008WindowsTIn "Validating the model for window behaviors"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.BooleanStep occ(startTime=1800)
                                          "True for occupied"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Sine TIn(
    amplitude=15,
    offset=288,
    f=0.001,
    y(unit="K", displayUnit="degC")) "Indoor air temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Occupants.Office.Windows.Yun2008WindowsTIn win
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(occ.y, win.occ) annotation (Line(points={{-59,20},{-36,20},{-36,6},{
          -12,6}}, color={255,0,255}));
  connect(TIn.y, win.TIn) annotation (Line(points={{-59,-20},{-34,-20},{-34,-6},
          {-12,-6}}, color={0,0,127}));
annotation (
experiment(Tolerance=1e-6, StopTime=3600.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Windows/Validation/Yun2008WindowsTIn.mos"
                      "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Windows.Yun2008WindowsTIn\">
Buildings.Occupants.Office.Windows.Yun2008WindowsTIn</a>
by examing how the window state corresponds
to the indoor temperature.
</p>
<p>
An indoor temperature variation was simulated by a sine function. The output is how the window state
changes with the indoor temperature.
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
end Yun2008WindowsTIn;
