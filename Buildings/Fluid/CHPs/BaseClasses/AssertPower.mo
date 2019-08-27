within Buildings.Fluid.CHPs.BaseClasses;
model AssertPower "Assert if electric power is outside boundaries"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-78,-98},{-62,-82}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEleDem(unit="W")
    "Electric power demand"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Logical.Nor nor "Logical Nor"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Nand nand "Logical Nand"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Sources.BooleanExpression cheDPLim(
    final y=per.dPEleLim)
    "Check if dP is limited"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesP(
    final message="Electric power is outside boundaries!")
    "Assert function for checking power"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesDP(
    final message="Power rate of change is outside boundaries!")
    "Assert function for checking power rate"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Derivative derivative(
    final initType=Buildings.Controls.OBC.CDL.Types.Init.InitialState,
    final x_start=0)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greaterThreshold(
    final threshold=per.dPEleMax)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greaterThreshold1(
    final threshold=per.PEleMax)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lessThreshold(
    final threshold=per.PEleMin)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

equation
  connect(abs1.u, derivative.y)
    annotation (Line(points={{-42,-40},{-58,-40}}, color={0,0,127}));
  connect(greaterThreshold.u, abs1.y)
    annotation (Line(points={{-2,-40},{-18,-40}},color={0,0,127}));
  connect(greaterThreshold1.u, PEleDem)
    annotation (Line(points={{-62,60},{-90,60},{-90,0},{-120,0}}, color={0,0,127}));
  connect(lessThreshold.u, PEleDem)
    annotation (Line(points={{-62,20},{-90,20},{-90,0},{-120,0}},
      color={0,0,127}));
  connect(derivative.u, PEleDem)
    annotation (Line(points={{-82,-40},{-90,-40},{-90,0},{-120,0}}, color={0,0,127}));
  connect(nor.u1, greaterThreshold1.y)
    annotation (Line(points={{38,40},{0,40},{0,60},{-38,60}}, color={255,0,255}));
  connect(nor.u2, lessThreshold.y)
    annotation (Line(points={{38,32},{0,32},{0,20},{-38,20}}, color={255,0,255}));
  connect(greaterThreshold.y, nand.u1)
    annotation (Line(points={{22,-40},{38,-40}}, color={255,0,255}));
  connect(nor.y, assMesP.u)
    annotation (Line(points={{62,40},{78,40}}, color={255,0,255}));
  connect(nand.y, assMesDP.u)
    annotation (Line(points={{62,-40},{78,-40}}, color={255,0,255}));
  connect(cheDPLim.y, nand.u2)
    annotation (Line(points={{21,-70},{30,-70},{30,-48},{38,-48}},
      color={255,0,255}));

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
