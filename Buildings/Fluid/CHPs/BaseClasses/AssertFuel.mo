within Buildings.Fluid.CHPs.BaseClasses;
model AssertFuel "Assert if fuel flow is outside boundaries"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  Modelica.Blocks.Interfaces.RealInput mFue_flow(unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Logical.Nand nand
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.BooleanExpression cheDmLim(y=per.dmFueLim)
    "Check if dmFue is limited"
    annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Fuel flow rate of change is outside boundaries!")
    "Assert function for checking fuel flow rate"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Derivative derivative(initType=
        Buildings.Controls.OBC.CDL.Types.Init.InitialState, x_start=0)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Math.Abs abs1
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=per.dmFueMax)
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
equation

  connect(abs1.u, derivative.y)
    annotation (Line(points={{-32,20},{-39,20}}, color={0,0,127}));
  connect(greaterThreshold.u, abs1.y)
    annotation (Line(points={{-2,20},{-9,20}}, color={0,0,127}));
  connect(derivative.u, mFue_flow) annotation (Line(points={{-62,20},{-80,20},{-80,
          0},{-120,0}}, color={0,0,127}));
  connect(greaterThreshold.y, nand.u1) annotation (Line(points={{21,20},{30,20},{
          30,0},{38,0}}, color={255,0,255}));
  connect(cheDmLim.y, nand.u2)
    annotation (Line(points={{-39,-8},{38,-8}}, color={255,0,255}));
  connect(nand.y, assMes.u)
    annotation (Line(points={{61,0},{78,0}}, color={255,0,255}));
  annotation (
   defaultComponentName="assFue",
   Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,80},{-80,-60},{80,-60},{0,80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{0,72},{-72,-56},{72,-56},{0,72}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,38},{2,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-6,-32},{4,-42}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
          Documentation(info="<html>
<p>
Model sends a warning message if the fuel flow is outside the boundaries defined by the manufacturer. 
Limits can be specified for the maximal mass flow rate of change. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertFuel;
