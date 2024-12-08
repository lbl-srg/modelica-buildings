within Buildings.Occupants.Residential.AirConditioning.Validation;
model Ren2014ACBedroom "Validating the model for AC behaviors"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.BooleanStep occ(startTime=600)
                                          "True for occupied"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
  Modelica.Blocks.Sources.Sine Tin(
    amplitude=10,
    offset= 303,
    f=0.001,
    y(unit="K", displayUnit="degC")) "Indoor air temperature"
    annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));
  Buildings.Occupants.Residential.AirConditioning.Ren2014ACBedroom ac "Tested AC model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(occ.y, ac.occ) annotation (Line(points={{-59,16},{-36,16},{-36,6},{
          -12,6}},
               color={255,0,255}));
  connect(Tin.y, ac.TIn) annotation (Line(points={{-59,-16},{-36,-16},{-36,-6},
          {-12,-6}},color={0,0,127}));

annotation (
experiment(Tolerance=1e-6, StopTime=3600.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/Residential/AirConditioning/Validation/Ren2014ACBedroom.mos"
                      "Simulate and plot"),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Occupants.Residential.AirConditioning.Ren2014ACBedroom\">
Buildings.Occupants.Residential.AirConditioning.Ren2014ACBedroom</a>
by examing how the AC state corresponds
to the indoor temperature.
</p>
<p>
An indoor temperature variation was simulated by a sine function. The output is how the AC state
changes with the indoor temperature.
</p>
</html>",
        revisions="<html>
<ul>
<li>
July 23, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Ren2014ACBedroom;