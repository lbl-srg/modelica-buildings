within Buildings.Fluid.CHPs.BaseClasses;
model AssertFuel "Assert if fuel flow is outside boundaries"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-78,-78},{-62,-62}})));
  parameter Real fueLowHys = 0.1
    "Hysteresis value for fuel flow rate check";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mFue_flow(unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Logical.Nand nand
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.BooleanExpression cheDmLim(
    final y=per.dmFueLim)
    "Check if dmFue is limited"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes(message="Fuel flow rate of change is outside boundaries!")
    "Assert function for checking fuel flow rate"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=per.dmFueMax - fueLowHys,
    final uHigh=per.dmFueMax + fueLowHys)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Derivative derivative(
    final initType=Buildings.Controls.OBC.CDL.Types.Init.InitialState,
    final x_start=0)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(abs1.u, derivative.y)
    annotation (Line(points={{-42,0},{-58,0}}, color={0,0,127}));
  connect(derivative.u, mFue_flow)
    annotation (Line(points={{-82,0},{-120,0}}, color={0,0,127}));
  connect(cheDmLim.y, nand.u2)
    annotation (Line(points={{21,-30},{30,-30},{30,-8},{38,-8}}, color={255,0,255}));
  connect(nand.y, assMes.u)
    annotation (Line(points={{62,0},{78,0}}, color={255,0,255}));
  connect(abs1.y, hys.u)
    annotation (Line(points={{-18,0},{-2,0}}, color={0,0,127}));
  connect(hys.y, nand.u1)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));

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
