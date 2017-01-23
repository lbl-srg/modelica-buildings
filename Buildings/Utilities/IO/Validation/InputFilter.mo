within Buildings.Utilities.IO.Validation;
model InputFilter "Validation model for the input filter model"
  import Buildings;
  extends Modelica.Icons.Example;

  Buildings.Utilities.IO.InputFilter inFil "Filter the inpug"
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Modelica.Blocks.Sources.Constant con(k=0.5*Modelica.Constants.pi)
                                              "Input"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Modelica.Blocks.Sources.Sine sin1(freqHz=1, amplitude=0.03)
    "Input"
    annotation (Placement(transformation(extent={{-60,-6},{-40,14}})));
  Modelica.Blocks.Math.Add add "Adder to offset the sin input signal"
    annotation (Placement(transformation(extent={{-14,8},{6,28}})));
  Modelica.Blocks.Sources.Constant con1(k=1.0)
                                              "Input"
    annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));
equation

  connect(add.u1, con.y) annotation (Line(points={{-16,24},{-24,24},{-24,40},{-39,
          40}}, color={0,0,127}));
  connect(sin1.y, add.u2) annotation (Line(points={{-39,4},{-24,4},{-24,12},{-16,
          12}},color={0,0,127}));
  connect(add.y, inFil.u1)
    annotation (Line(points={{7,18},{14,18},{14,4},{26,4}}, color={0,0,127}));
  connect(con1.y, inFil.u2) annotation (Line(points={{-39,-28},{-20,-28},{0,-28},
          {0,-4},{26,-4}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file="Resources/Scripts/Dymola/Utilities/IO/Validation/InputFilter.mos"
        "Simulate and plot"),
  Documentation(
    info="<html>
<p>
This model validates the use of the
<a href=\"modelica://Buildings.Utilities.IO.InputFilter\">
Buildings.Utilities.IO.InputFilter</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 23, 2017, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-6, StartTime=0.0, StopTime=1.0));
end InputFilter;
