within Buildings.Controls.OBC.Facade;
block ShadingEnable "Generic shading device enable/disable seqence"

  parameter Boolean use_solIrr = false
    "Set to true if using solar irradiance instead of temeprature as a treshold variable"
    annotation(Dialog(group = "Conditional"));

  parameter Modelica.SIunits.Temperature TTre = 298.15 if not use_solIrr
    "Temperature threshold (either zone or outdoor air)"
    annotation(Evaluate=true, Dialog(group="Hysteresis", enable = not use_solIrr));

  parameter Modelica.SIunits.Irradiance irrTre = 1000 if use_solIrr
    "Solar irradiance threshold"
    annotation(Evaluate=true, Dialog(group="Hysteresis", enable = use_solIrr));

  CDL.Interfaces.BooleanInput uEnable "Shading device enable schedule"
    annotation (Placement(transformation(extent={{-120,-60},{-80,-20}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.RealInput T if not use_solIrr
    "Zone or oudoor air temperature"
    annotation (Placement(transformation(extent={{-120,20},{-80,60}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.RealInput Irr if use_solIrr
    "Total solar radiation on horizontal or on window surface"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Interfaces.BooleanOutput yShaEna
    "Shade/Blind/Glaze/Screen status signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
     iconTransformation(extent={{100,-20},{140,20}})));

  CDL.Continuous.Hysteresis hysTem(
    final uLow=TLowTre,
    final uHigh=THighTre) if not use_solIrr
    "Temperature signal hysteresis"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  CDL.Continuous.Hysteresis hysIrr(
    final uLow=irrLowTre,
    final uHigh=irrHighTre) if use_solIrr
    "Solar irradiance signal hysteresis"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  parameter Modelica.SIunits.TemperatureDifference TDiff = 1 if not use_solIrr
    "Temperature difference for the hysteresis";
  parameter Modelica.SIunits.Irradiance irrDiff = 10 if use_solIrr
    "Irradiance difference for the hysteresis";

  parameter Real THighTre = TTre if not use_solIrr
    "Upper limit for the temperature hysteresis";
  parameter Real TLowTre = (THighTre - TDiff) if not use_solIrr
    "Lower limit for the temperature hysteresis";

  parameter Real irrHighTre = irrTre if use_solIrr
    "Upper limit for the irradiance hysteresis";
  parameter Real irrLowTre = (irrHighTre - irrDiff) if use_solIrr
    "Lower limit for the irradiance hysteresis";

equation
  connect(Irr, hysIrr.u) annotation (Line(points={{-100,0},{-42,0}}, color={0,0,127}));
  connect(T, hysTem.u) annotation (Line(points={{-100,40},{-42,40}}, color={0,0,127}));
  connect(hysTem.y, and2.u1)
    annotation (Line(points={{-19,40},{0,40},{0,0},{18,0}}, color={255,0,255}));
  connect(hysIrr.y, and2.u1) annotation (Line(points={{-19,0},{18,0}}, color={255,0,255}));
  connect(uEnable, and2.u2)
    annotation (Line(points={{-100,-40},{0,-40},{0,-8},{18,-8}}, color={255,0,255}));
  connect(and2.y, yShaEna) annotation (Line(points={{41,0},{110,0}},color={255,0,255}));
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

</p>
<p>

</p>
<p>
In addition, the economizer gets disabled without a delay whenever any of the
following is <code>true</code>:
</p>
<ul>
<li>
The supply fan is off (<code>uSupFan = false</code>),
</li>
<li>
the freeze protection stage
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages</a>
is not <code>stage0</code>.
</li>
</ul>
<p>
Chart
</p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconEnableDisableStateMachineChartMultiZone.png\"/>
</p>

<ul>
<li>

</li>
<li>
The outdoor air damper is closed to its minimum outoor airflow control limit (<code>yOutDamPosMax = uOutDamPosMin</code>)
after a <code>disDel</code> time delay.
</li>
</ul>
<p>

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
