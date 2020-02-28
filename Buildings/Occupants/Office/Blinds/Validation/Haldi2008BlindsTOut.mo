within Buildings.Occupants.Office.Blinds.Validation;
model Haldi2008BlindsTOut
  "Validating the model for blind behaviors"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.BooleanStep occ(startTime=1800)
    "True for occupied"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.Sine TOut(
    amplitude=15,
    offset=293,
    f=0.001,
    y(unit="K", displayUnit="degC")) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Occupants.Office.Blinds.Haldi2008BlindsTOut bli    "Tested blinds model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(occ.y, bli.occ) annotation (Line(points={{-59,20},{-34,20},{-34,6},{-12,
          6}}, color={255,0,255}));
  connect(TOut.y, bli.TOut) annotation (Line(points={{-59,-20},{-36,-20},{-36,-6},{-12,
          -6}}, color={0,0,127}));

annotation (
experiment(Tolerance=1e-6, StopTime=3600.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Office/Blinds/Validation/Haldi2008BlindsTOut.mos"
                      "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Office.Blinds.Haldi2008BlindsTOut\">
Buildings.Occupants.Office.Blinds.Haldi2008BlindsTOut</a>
by examing how the blinds state corresponds
to the outdoor temperature.
</p>
<p>
An outdoor temperature variation was simulated by a sine function. The output is how the blind state
changes with the outdoor temperature.
</p>
</html>",
        revisions="<html>
<ul>
<li>
July 24, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Haldi2008BlindsTOut;
