within Buildings.Controls.OBC.UnitConversions.Validation;
model To_quad "Validation model for unit conversion from joule to quads"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Add add(k2=-1)
    "Difference between the calculated and expected conversion output"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    "Difference between the calculated and expected conversion output"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

protected
  parameter Real kin = 1.*1055.56e15 "Validation input";
  parameter Real kin1 = 2.*1055.56e15 "Validation input 1";
  parameter Real kout = 1. "Validation output";
  parameter Real kout1 = 2. "Validation output 1";

  Buildings.Controls.OBC.UnitConversions.To_quad to_quad
  "Unit converter from joule to quads "
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.UnitConversions.To_quad to_quad1
  "Unit converter from joule to quads "
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant value(
    final k=kin)
    "Value to convert"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant value1(
    final k=kin1)
    "Value to convert"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant result(
    final k=kout)
    "Expected converted value"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant result1(
    final k=kout1)
    "Expected converted value"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));

equation
  connect(result.y, add.u2)
    annotation (Line(points={{2,20},{10,20},{10,44},{18,44}}, color={0,0,127}));
  connect(result1.y, add1.u2)
    annotation (Line(points={{2,-60},{10,-60},{10,-36},{18,-36}}, color={0,0,127}));
  connect(value1.y,to_quad1.u)
    annotation (Line(points={{-38,-30},{-22,-30}}, color={0,0,127}));
  connect(to_quad1.y, add1.u1)
    annotation (Line(points={{2,-30},{8,-30},{8,-24},{18,-24}}, color={0,0,127}));
  connect(to_quad.y, add.u1)
    annotation (Line(points={{2,50},{10,50},{10,56},{18,56}}, color={0,0,127}));
  connect(value.y,to_quad.u)
    annotation (Line(points={{-38,50}, {-22,50}}, color={0,0,127}));
  annotation (Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
                Diagram(coordinateSystem( preserveAspectRatio=false)),
            experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/UnitConversions/Validation/To_quad.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates energy unit conversion from joule to quads.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 05, 2018, Milica Grahovac<br/>
Generated with <code>Buildings/Resources/src/Controls/OBC/UnitConversions/unit_converters.py</code>.<br/>
First implementation.
</li>
</ul>
</html>"));
end To_quad;
