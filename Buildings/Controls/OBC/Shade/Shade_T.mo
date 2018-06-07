within Buildings.Controls.OBC.Shade;
block Shade_T "Shading device enable/disable based on a temeprature setpoint"

  parameter Modelica.SIunits.Temperature TSet = 298.15
    "Temperature threshold (either zone or outdoor air)"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.TemperatureDifference TDiff = 1
    "Temperature difference for the hysteresis";
    annotation(Evaluate=true, Dialog(group="Advanced"));

  CDL.Interfaces.RealInput T
    "Zone or oudoor air temperature"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
    iconTransformation(extent={{-140,40},{-100,80}})));

  CDL.Interfaces.RealOutput yShaEna(
    final min = 0,
    final max = 1)
    "Shade/Blind/Glaze/Screen status signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
    iconTransformation(extent={{100,-20},{140,20}})));

protected
  parameter Real THigSet = TSet
    "Upper limit for the temperature hysteresis";
  parameter Real TLowSet = (THigSet - TDiff)
    "Lower limit for the temperature hysteresis";

  CDL.Continuous.Hysteresis THys(
    final uLow=TLowSet,
    final uHigh=THigSet) "Temperature hysteresis"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Conversions.BooleanToReal booToRea "Boolean to real converter"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(T, THys.u) annotation (Line(points={{-100,0},{-22,0}}, color={0,0,127}));
  connect(THys.y, booToRea.u) annotation (Line(points={{1,0},{38,0}}, color={255,0,255}));
  connect(booToRea.y, yShaEna) annotation (Line(points={{61,0},{90,0}}, color={0,0,127}));
  annotation (
        defaultComponentName = "shaT",
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
        extent={{-80,-80},{80,80}},
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
src=\"modelica://Buildings/Resources/Images/Controls/OBC/Shade/ShadingEnableStateMachineChart.png\"/>
</p>
<p>
Control chart:
</p>
<p align=\"center\">
<img alt=\"Control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/Shade/ShadingEnableControlDiagram.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Shade_T;
