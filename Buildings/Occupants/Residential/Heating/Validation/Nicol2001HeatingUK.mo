within Buildings.Occupants.Residential.Heating.Validation;
model Nicol2001HeatingUK "Validating the model for heating behaviors"
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
  Buildings.Occupants.Residential.Heating.Nicol2001HeatingUK hea "Tested heating model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(hea.occ, occ.y) annotation (Line(points={{-12,6},{-36,6},{-36,20},{-59,
          20}}, color={255,0,255}));
  connect(hea.TOut, TOut.y) annotation (Line(points={{-12,-6},{-36,-6},{-36,-20},
          {-59,-20}}, color={0,0,127}));
annotation (
experiment(Tolerance=1e-6, StopTime=3600.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Residential/Heating/Validation/Nicol2001HeatingUK.mos"
                      "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Residential.Heating.Nicol2001HeatingUK\">
Buildings.Occupants.Residential.Heating.Nicol2001HeatingUK</a>
by examing how the heater state corresponds
to the outdoor temperature.
</p>
<p>
An outdoor temperature variation was simulated by a sine function. The output is how the heater state
changes with the outdoor temperature.
</p>
</html>",
        revisions="<html>
<ul>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Nicol2001HeatingUK;
