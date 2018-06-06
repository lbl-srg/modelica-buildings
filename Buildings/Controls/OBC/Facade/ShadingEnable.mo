within Buildings.Controls.OBC.Facade;
block ShadingEnable "Generic shading device enable/disable seqence"

  parameter Boolean use_solIrr = false
    "Set to true if enabling based on solar irradiance, otherwise enabling based on temeprature"
    annotation(Dialog(group = "Conditional"));
  parameter Modelica.SIunits.Temperature TThr = 298.15 if not use_solIrr
    "Temperature threshold (either zone or outdoor air)"
    annotation(Evaluate=true, Dialog(group="Hysteresis", enable = not use_solIrr));
  parameter Modelica.SIunits.Irradiance irrThr = 1000 if use_solIrr
    "Solar irradiance threshold"
    annotation(Evaluate=true, Dialog(group="Hysteresis", enable = use_solIrr));

  CDL.Interfaces.BooleanInput uEnable "Shading device enable schedule"
    annotation (Placement(transformation(extent={{-120,-60},{-80,-20}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.RealInput T if not use_solIrr
    "Zone or oudoor air temperature"
    annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.RealInput irr if use_solIrr
    "Total solar irradiance on horizontal or on window surface"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Interfaces.BooleanOutput yShaEna
    "Shade/Blind/Glaze/Screen status signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
     iconTransformation(extent={{100,-20},{140,20}})));

protected
  parameter Modelica.SIunits.TemperatureDifference TDiff = 1 if not use_solIrr
    "Temperature difference for the hysteresis";
  parameter Modelica.SIunits.Irradiance irrDiff = 10 if use_solIrr
    "Irradiance difference for the hysteresis";

  parameter Real THighThr = TThr if not use_solIrr
    "Upper limit for the temperature hysteresis";
  parameter Real TLowThr = (THighThr - TDiff) if not use_solIrr
    "Lower limit for the temperature hysteresis";

  parameter Real irrHighThr = irrThr if use_solIrr
    "Upper limit for the irradiance hysteresis";
  parameter Real irrLowThr = (irrHighThr - irrDiff) if use_solIrr
    "Lower limit for the irradiance hysteresis";

  CDL.Continuous.Hysteresis hysTem(
    final uLow=TLowThr,
    final uHigh=THighThr) if not use_solIrr
    "Temperature signal hysteresis"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  CDL.Continuous.Hysteresis hysIrr(
    final uLow=irrLowThr,
    final uHigh=irrHighThr) if use_solIrr
    "Solar irradiance signal hysteresis"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(irr, hysIrr.u)
    annotation (Line(points={{-100,0},{-42,0}}, color={0,0,127}));
  connect(T, hysTem.u)
    annotation (Line(points={{-100,40},{-42,40}}, color={0,0,127}));
  connect(hysTem.y, and2.u1)
    annotation (Line(points={{-19,40},{0,40},{0,0},{18,0}}, color={255,0,255}));
  connect(hysIrr.y, and2.u1)
    annotation (Line(points={{-19,0},{18,0}}, color={255,0,255}));
  connect(uEnable, and2.u2)
    annotation (Line(points={{-100,-40},{0,-40},{0,-8},{18,-8}}, color={255,0,255}));
  connect(and2.y, yShaEna)
    annotation (Line(points={{41,0},{110,0}},color={255,0,255}));
annotation (
    defaultComponentName = "shaEna",
    Icon(graphics={
        Rectangle(
          extent={{-100,-102},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-164,144},{164,106}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-80,-100},{100,100}},
        initialScale=0.05)),
Documentation(info="<html>
<p>
This block is a generic shading device enable/disable seqence. It can be used to enable or disable
window shading devices such such as shades, blinds, glazing, or screens. The control sequence 
takes two inputs, a schedule (<code>uEnable</code>) and either a temperature (<code>T</code>)
or a solar irradiance ((<code>irr</code>) input, based on the value of the 
<code>use_solIrr</code> parameter.
</p>
<p>
If the schedule allows the deployment of the shading device, the device is fully enabled as soon 
as the temperature or, if <code>use_solIrr = true</code>, solar irradiance is above a threshold.
Illustrated using a state machine chart:
</p>
<p align=\"center\">
<img alt=\"Control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/Facade/ShadingEnableStateMachineChart.png\"/>
</p>
<p>
Control chart:
</p>
<p align=\"center\">
<img alt=\"Control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/Facade/ShadingEnableControlDiagram.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShadingEnable;
