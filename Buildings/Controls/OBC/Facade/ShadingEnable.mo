within Buildings.Controls.OBC.Facade;
block ShadingEnable "Generic shading device enable/disable seqence"
  CDL.Interfaces.BooleanInput uEnable "Shading device enable schedule" annotation (Placement(
        transformation(extent={{-180,-100},{-140,-60}}), iconTransformation(extent={{-226,38},{-186,
            78}})));
  CDL.Interfaces.RealInput T "Zone or oudoor air temperature" annotation (Placement(transformation(
          extent={{-180,40},{-140,80}}), iconTransformation(extent={{-226,4},{-186,44}})));
  CDL.Interfaces.RealInput Irr "Total solar radiation on horizontal or window surface" annotation (
      Placement(transformation(extent={{-180,-10},{-140,30}}), iconTransformation(extent={{-224,-10},
            {-184,30}})));
annotation (
    defaultComponentName = "shaEna",
    Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-174,142},{154,104}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-140},{140,140}},
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
