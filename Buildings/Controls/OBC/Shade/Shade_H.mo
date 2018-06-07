within Buildings.Controls.OBC.Shade;
block Shade_H "Shading device enable/disable based on a solar irradiance setpoint"

  parameter Modelica.SIunits.Irradiance HSet = 1000
    "Solar irradiance threshold"
    annotation(Evaluate=true);

  parameter Modelica.SIunits.Irradiance HDiff = 10
    "Irradiance difference for the hysteresis"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));

  CDL.Interfaces.RealInput H(final unit = "W/m2")
    "Total solar irradiance on horizontal or on window surface"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Interfaces.RealOutput yShaEna(
    final min = 0,
    final max = 1)
    "Shade/Blind/Glaze/Screen status signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}}),
    iconTransformation(extent={{100,-20},{140,20}})));

protected
  parameter Real HHigSet = HSet
    "Upper limit for the irradiance hysteresis";
  parameter Real HLowSet = (HHigSet - HDiff)
    "Lower limit for the irradiance hysteresis";

  CDL.Continuous.Hysteresis HHys(
    final uLow=HLowSet,
    final uHigh=HHigSet) "Solar irradiance hysteresis"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Conversions.BooleanToReal booToRea "Boolean to real converter"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(H, HHys.u) annotation (Line(points={{-100,0},{-22,0}}, color={0,0,127}));
  connect(HHys.y, booToRea.u) annotation (Line(points={{1,0},{38,0}}, color={255,0,255}));
  connect(booToRea.y, yShaEna) annotation (Line(points={{61,0},{90,0}}, color={0,0,127}));
    annotation(Evaluate=true, Dialog(group="Advanced"),
    defaultComponentName = "shaH",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,102}},
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
This block enables a shading device based on a solar irradiance setpoint (<code>HSet</code>). 
It can be used to enable or disable window shading devices such such as shades, blinds, glazing, 
or screens. The control sequence 
takes a solar irradiance (<code>H</code>) input and outputs the shade status
<code>yShaEna</code> based on the setpoint.
</p>
<p align=\"center\">
<img alt=\"Control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/Shade/Shade_HStateMachineChart.png\"/>
</p>
<p>
Control diagram:
</p>
<p align=\"center\">
<img alt=\"Control diagram\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/Shade/Shade_HControlDiagram.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Shade_H;
