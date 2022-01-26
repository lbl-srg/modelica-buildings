within Buildings.Utilities.Diagnostics.Validation;
model CheckEquality "Validation model for the check equality model"
  extends Modelica.Icons.Example;

  Buildings.Utilities.Diagnostics.CheckEquality cheEqu
    "Checks for equality of the input"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Sources.Constant con(k=0.1) "Input"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.Sine sin1(f=1, amplitude=0.03) "Input"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.Add add "Adder to offset the sin input signal"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation

  connect(con.y, cheEqu.u1) annotation (Line(points={{-39,40},{-20,40},{-20,26},
          {18,26}},  color={0,0,127}));
  connect(add.u1, con.y) annotation (Line(points={{-22,16},{-30,16},{-30,40},{-39,
          40}}, color={0,0,127}));
  connect(sin1.y, add.u2) annotation (Line(points={{-39,0},{-30,0},{-30,4},{-22,
          4}}, color={0,0,127}));
  connect(add.y, cheEqu.u2) annotation (Line(points={{1,10},{10,10},{10,14},{18,
          14}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Diagnostics/Validation/CheckEquality.mos"
        "Simulate and plot"),
  Documentation(
    info="<html>
<p>
This model validates the use of the
<a href=\"modelica://Buildings.Utilities.Diagnostics.CheckEquality\">
Buildings.Utilities.Diagnostics.CheckEquality</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 17, 2017, by Michael Wetter:<br/>
Updated example to also test negative difference.
</li>
<li>
January 17, 2017, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StopTime=1));
end CheckEquality;
