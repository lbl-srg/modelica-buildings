within Buildings.Fluid.CHPs.BaseClasses;
model FilterPower "Constraints for electric power"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Power PEleMax "Maximum power output";
  parameter Modelica.Units.SI.Power PEleMin "Minimum power output";
  parameter Boolean use_powerRateLimit
    "If true, the rate at which net power output can change is limited";
  parameter Real dPEleMax(final unit="W/s")
    "Maximum rate at which net power output can change";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEleDem(final unit="W")
    "Electric power demand"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle(final unit="W")
    "Electric power demand after applied constraints"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Fluid.CHPs.BaseClasses.AssertPower assPow(
    final PEleMax=PEleMax,
    final PEleMin=PEleMin,
    final use_powerRateLimit=use_powerRateLimit,
    final dPEleMax=dPEleMax)
    "Assert if electric power is outside boundaries"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

protected
  Modelica.Blocks.Nonlinear.VariableLimiter PLim "Power limiter"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant PMax(
    final k=PEleMax) "Maximum power"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant PMin(
    final k=PEleMin) "Minimum power"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.LimitSlewRate dPLim(
    final raisingSlewRate(unit="W/s") = dPEleMax,
    final fallingSlewRate(unit="W/s") = -dPEleMax,
    final Td=1) "Power rate limiter"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch switch
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant limDp(
    final k=use_powerRateLimit)
    "Check if dP is limited"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

equation
  connect(PMax.y, PLim.limit1) annotation (Line(points={{-58,30},{-50,30},{-50,
          8},{-42,8}}, color={0,0,127}));
  connect(PMin.y, PLim.limit2) annotation (Line(points={{-58,-30},{-50,-30},{
          -50,-8},{-42,-8}}, color={0,0,127}));
  connect(PLim.u, PEleDem) annotation (Line(points={{-42,0},{-120,0}},
          color={0,0,127}));
  connect(switch.y, PEle) annotation (Line(points={{92,0},{120,0}},
          color={0,0,127}));
  connect(PLim.y, dPLim.u) annotation (Line(points={{-19,0},{-10,0},{-10,30},{-2,30}},
          color={0,0,127}));
  connect(PLim.y, switch.u3) annotation (Line(points={{-19,0},{-10,0},{-10,-8},{
          68,-8}},  color={0,0,127}));
  connect(assPow.PEleDem, PEleDem) annotation (Line(points={{-42,-70},{-90,-70},
          {-90,0},{-120,0}}, color={0,0,127}));
  connect(limDp.y, switch.u2) annotation (Line(points={{22,-30},{40,-30},{40,0},
          {68,0}}, color={255,0,255}));

  connect(dPLim.y, switch.u1)
    annotation (Line(points={{22,30},{40,30},{40,8},{68,8}}, color={0,0,127}));
annotation (
  defaultComponentName="filPow",
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-86,-64},{-46,-44}},
          textColor={128,128,128},
          textString="uMin"),
        Text(
          extent={{-34,76},{-9,56}},
          textColor={128,128,128},
          textString="output"),
        Text(
          extent={{50,50},{90,70}},
          textColor={128,128,128},
          textString="uMax"),
        Text(
          extent={{52,-8},{74,-20}},
          textColor={128,128,128},
          textString="input"),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Line(
      points={{-50,-70},{50,70}}),
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
        Line(points={{50,70},{82,70}}, color={0,0,0}),
        Line(points={{-82,-70},{-50,-70}}, color={0,0,0}),
        Line(points={{-44,-70}}, color={0,0,0}),
        Line(points={{-40,-70},{40,70}}, color={0,0,0})}),
  Documentation(info="<html>
<p>
The model checks if the electric power and power rate are within the boundaries
specified by the manufacturer.
The constraints are applied and a warning message is sent if the electric power
is outside the boundaries.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end FilterPower;
