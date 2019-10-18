within Buildings.Fluid.CHPs.BaseClasses;
model AssertPower "Assert if electric power is outside boundaries"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEleDem(
    final unit="W")
    "Electric power demand"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesDP(
    final message="Power rate of change is outside boundaries!")
    "Assert function for checking power rate"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Nor nor
    "Check if the electric power demand is out of the power production range"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Nand nand "Logical Nand"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cheDPLim(
    final k=per.dPEleLim)
    "Check if dP is limited"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesP(
    final message="Electric power is outside boundaries!")
    "Generate warning when the electric power demand is out of the range"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Derivative demRat(
    final initType=Buildings.Controls.OBC.CDL.Types.Init.InitialState,
    final x_start=0)
    "Power demand rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1 "Absolute value"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold maxRat(
    final threshold=per.dPEleMax)
    "Check if demand rate is more than the maximum rate"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis maxPow(
    final uLow=0.99*per.PEleMax,
    final uHigh=1.01*per.PEleMax)
    "Check if the electric power demand is more than the maximum power production"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis minPow(
    final uLow=0.99*per.PEleMin,
    final uHigh=1.01*per.PEleMin)
    "Check if the electric power demand is larger than the minimum power production"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "If the electric demand is less than minimum production"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(abs1.u, demRat.y) annotation (Line(points={{-42,-40},{-58,-40}},
          color={0,0,127}));
  connect(maxRat.u, abs1.y) annotation (Line(points={{-2,-40},{-18,-40}},
          color={0,0,127}));
  connect(maxPow.u, PEleDem) annotation (Line(points={{-62,40},{-90,40},{-90,0},
          {-120,0}}, color={0,0,127}));
  connect(minPow.u, PEleDem) annotation (Line(points={{-82,0},{-120,0}},
          color={0,0,127}));
  connect(demRat.u, PEleDem) annotation (Line(points={{-82,-40},{-90,-40},{-90,0},
          {-120,0}}, color={0,0,127}));
  connect(nor.u1, maxPow.y) annotation (Line(points={{38,20},{0,20},{0,40},{-38,
          40}}, color={255,0,255}));
  connect(maxRat.y, nand.u1) annotation (Line(points={{22,-40},{38,-40}},
          color={255,0,255}));
  connect(nor.y, assMesP.u) annotation (Line(points={{62,20},{78,20}},
          color={255,0,255}));
  connect(nand.y, assMesDP.u) annotation (Line(points={{62,-40},{78,-40}},
          color={255,0,255}));
  connect(cheDPLim.y, nand.u2) annotation (Line(points={{22,-80},{30,-80},{30,-48},
          {38,-48}}, color={255,0,255}));
  connect(nor.u2, not1.y) annotation (Line(points={{38,12},{0,12},{0,0},{-18,0}},
          color={255,0,255}));
  connect(not1.u, minPow.y) annotation (Line(points={{-42,0},{-58,0}},
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
