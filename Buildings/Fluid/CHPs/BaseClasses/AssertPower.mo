within Buildings.Fluid.CHPs.BaseClasses;
model AssertPower "Assert if electric power is outside boundaries"
  extends Modelica.Blocks.Icons.Block;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-98,-98},{-78,-78}})));

  Modelica.Blocks.Interfaces.RealInput PEleDem(unit="W") "Electric power demand"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Logical.Nor nor
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Logical.Nand nand
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Sources.BooleanExpression cheDPLim(y=per.dPEleLim)
    "Check if dP is limited"
    annotation (Placement(transformation(extent={{-60,-68},{-40,-48}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesP(message="Electric power is outside boundaries!")
    "Assert function for checking power"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesDP(message="Power rate of change is outside boundaries!")
    "Assert function for checking power rate"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Derivative derivative(initType=
        Buildings.Controls.OBC.CDL.Types.Init.InitialState, x_start=0)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Math.Abs abs1
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=per.dPEleMax)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=per.PEleMax)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=per.PEleMin)
    annotation (Placement(transformation(extent={{-60,32},{-40,52}})));

equation

  connect(abs1.u, derivative.y)
    annotation (Line(points={{-32,-30},{-39,-30}}, color={0,0,127}));
  connect(greaterThreshold.u, abs1.y)
    annotation (Line(points={{-2,-30},{-9,-30}}, color={0,0,127}));
  connect(greaterThreshold1.u, PEleDem) annotation (Line(points={{-62,70},{-90,70},
          {-90,0},{-120,0}}, color={0,0,127}));
  connect(lessThreshold.u, PEleDem) annotation (Line(points={{-62,42},{-90,42},{-90,
          0},{-120,0}}, color={0,0,127}));
  connect(derivative.u, PEleDem) annotation (Line(points={{-62,-30},{-90,-30},{-90,
          0},{-120,0}}, color={0,0,127}));
  connect(nor.u1, greaterThreshold1.y) annotation (Line(points={{38,50},{-30,50},
          {-30,70},{-39,70}}, color={255,0,255}));
  connect(nor.u2, lessThreshold.y) annotation (Line(points={{38,42},{-39,42}},
                         color={255,0,255}));
  connect(greaterThreshold.y, nand.u1) annotation (Line(points={{21,-30},{24,-30},
          {24,-50},{38,-50}}, color={255,0,255}));
  connect(nor.y, assMesP.u)
    annotation (Line(points={{61,50},{78,50}}, color={255,0,255}));
  connect(nand.y, assMesDP.u)
    annotation (Line(points={{61,-50},{78,-50}}, color={255,0,255}));

  connect(cheDPLim.y, nand.u2)
    annotation (Line(points={{-39,-58},{38,-58}}, color={255,0,255}));
  annotation (
    defaultComponentName="assPow",
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
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
The model sends a warning message if the power demand is outside the boundaries defined by the manufacturer. 
Limits can be specified for the minimal and maximal electric power and for the maximal power rate of change. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertPower;
