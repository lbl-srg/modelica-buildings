within Buildings.Controls.OBC.CDL.Logical.Validation;
model IntegerSwitch "Validation model for the IntegerSwitch block"

  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch integerSwitch
    "Integer switch"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
      width=0.7, period=1.5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
      width=0.5, period=3)
    "Block that outputs cyclic on and off: switch between u1 and u3"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
      width=0.5, period=5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=5) "Integer constant"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=2) "Integer constant"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Type converter"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt "Product"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Product proInt1 "Product"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
equation
  connect(booPul2.y,integerSwitch. u2)
    annotation (Line(points={{-5,0},{58,0}}, color={255,0,255}));
  connect(booPul1.y, booToInt.u)
    annotation (Line(points={{-59,30},{-42,30}}, color={255,0,255}));
  connect(booPul3.y, booToInt1.u)
    annotation (Line(points={{-59,-70},{-42,-70}}, color={255,0,255}));
  connect(conInt.y, proInt.u1) annotation (Line(points={{-59,70},{-20,70},{-20,56},
          {-2,56}}, color={255,127,0}));
  connect(booToInt.y, proInt.u2) annotation (Line(points={{-19,30},{-10,30},{-10,
          44},{-2,44}}, color={255,127,0}));
  connect(conInt1.y, proInt1.u1) annotation (Line(points={{-59,-30},{-10,-30},{-10,
          -44},{-2,-44}}, color={255,127,0}));
  connect(booToInt1.y, proInt1.u2) annotation (Line(points={{-19,-70},{-10,-70},
          {-10,-56},{-2,-56}}, color={255,127,0}));
  connect(proInt.y,integerSwitch. u1) annotation (Line(points={{21,50},{40,50},{
          40,8},{58,8}}, color={255,127,0}));
  connect(proInt1.y,integerSwitch. u3) annotation (Line(points={{21,-50},{40,-50},
          {40,-8},{58,-8}}, color={255,127,0}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/IntegerSwitch.mos"
         "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.IntegerSwitch\">
Buildings.Controls.OBC.CDL.Logical.IntegerSwitch</a>.
</p>
<p>
The input <code>u2</code> is the switch input: If <code>u2 = true</code>,
then output <code>y = u1</code>;
else output <code>y = u3</code>.
</p>

</html>", revisions="<html>
<ul>
<li>
July 10, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end IntegerSwitch;
