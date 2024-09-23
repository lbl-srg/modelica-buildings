within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialThreeWayValve "Partial three way valve"
  extends Buildings.Fluid.BaseClasses.PartialThreeWayResistance(
    m_flow_small=m_flow_nominal*1e-4,
    final mDyn_flow_nominal=m_flow_nominal,
    redeclare replaceable Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve res1
      constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
        deltaM=deltaM,
        from_dp=from_dp,
        final linearized=linearized[1],
        final homotopyInitialization=homotopyInitialization,
        final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
        final m_flow_nominal=m_flow_nominal,
        final dpValve_nominal=dpValve_nominal,
        final dpFixed_nominal=dpFixed_nominal[1],
        final use_strokeTime=false,
        final strokeTime=strokeTime),
    redeclare FixedResistances.LosslessPipe res2(m_flow_nominal=m_flow_nominal),
    redeclare replaceable Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve res3
      constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
        deltaM=deltaM,
        from_dp=from_dp,
        final linearized=linearized[2],
        final homotopyInitialization=homotopyInitialization,
        final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
        final m_flow_nominal=m_flow_nominal,
        final dpValve_nominal=dpValve_nominal/fraK^2,
        final dpFixed_nominal=dpFixed_nominal[2],
        final use_strokeTime=false,
        final strokeTime=strokeTime));
    extends Buildings.Fluid.Actuators.BaseClasses.ActuatorSignal;
    extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
      rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal[2](
    each displayUnit="Pa",
    each min=0) = {0,0}
    "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3"
    annotation (Dialog(group="Nominal condition"));

  parameter Real fraK(min=0, max=1) = 0.7
    "Fraction Kv(port_3&rarr;port_2)/Kv(port_1&rarr;port_2)";
  parameter Real[2] l(each min=0, each max=1) = {0.0001, 0.0001}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)";
  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Pressure-flow linearization"));

  parameter Boolean[2] linearized = {false, false}
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Advanced"));

protected
  Modelica.Blocks.Math.Feedback inv "Inversion of control signal"
    annotation (Placement(transformation(extent={{-74,40},{-62,52}})));
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Outputs one for bypass valve"
    annotation (Placement(transformation(extent={{-92,40},{-80,52}})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(uni.y, inv.u1)
    annotation (Line(points={{-79.4,46},{-72.8,46}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
    Rectangle(
      extent={{-100,40},{100,-40}},
      lineColor={0,0,0},
      fillPattern=FillPattern.HorizontalCylinder,
      fillColor={192,192,192}),
    Rectangle(
      extent={{-100,22},{100,-22}},
      lineColor={0,0,0},
      fillPattern=FillPattern.HorizontalCylinder,
      fillColor={0,127,255}),
    Rectangle(
      extent={{-60,40},{60,-40}},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Polygon(
      points={{0,0},{-76,60},{-76,-60},{0,0}},
      lineColor={0,0,0},
      fillColor=DynamicSelect({0,0,0}, y*{255,255,255}),
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{0,0},{76,60},{76,-60},{0,0}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Rectangle(
      extent={{-40,-56},{40,-100}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={192,192,192}),
    Rectangle(
      extent={{-22,-56},{22,-100}},
      lineColor={0,0,0},
      fillPattern=FillPattern.VerticalCylinder,
      fillColor={0,127,255}),
    Polygon(
          points={{0,0},{60,-76},{-60,-76},{0,0}},
          lineColor={0,0,0},
          fillColor=DynamicSelect({0,0,0}, (1-y)*{255,255,255}),
          fillPattern=FillPattern.Solid),
    Line(
      visible=use_strokeTime,
      points={{-30,40},{30,40}}),
            Line(
      points={{0,40},{0,0}}),
    Line(
      visible=not use_strokeTime,
      points={{0,100},{0,40}})}),
    Documentation(info="<html>
<p>
Partial model of a three way valve. This is the base model for valves
with different opening characteristics, such as linear, equal percentage
or quick opening. The three way valve model consists of a mixer where
valves are placed in two of the flow legs. The third flow leg
has no friction.
The flow coefficient <code>Kv</code> for flow from <code>port_1 &rarr; port_2</code> is
a parameter.
The flow coefficient for the bypass flow from <code>port_3 &rarr; port_2</code>
is computed as
</p>
<pre>
         Kv(port_3 &rarr; port_2)
  fraK = ----------------------
         Kv(port_1 &rarr; port_2)
</pre>
<p>
where <code>0 &lt; fraK &le; 1</code> is a parameter with a default value
of <code>fraK=0.7</code>.
</p>
<p>
Since this model uses two way valves to construct a three way valve, see
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>
for details regarding the valve implementation.
</p>
</html>", revisions="<html>
<ul>
<li>
February 3, 2023, by Michael Wetter:<br/>
Removed start value for <code>dp</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3231\">Buildings, #3231</a>.
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Propagated parameter <code>strokeTime</code> to valves. The value is not used as the filter is disabled,
but it will show in the result file. Having a consistent value for all these parameters in the result filter
helps during debugging.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
November 5, 2019, by Michael Wetter:<br/>
Moved assignment of leakage from <a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a>
to the parent classes.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1227\">#1227</a>.
</li>
<li>
October 25, 2019, by Jianjun Hu:<br/>
Improved icon graphics annotation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1225\">#1225</a>.
</li>
<li>
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredInput</code> to <code>use_strokeTime</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">#665</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 17, 2015, by Michael Wetter:<br/>
Removed assignment <code>redeclare final package Medium=Medium</code>
as this is now done in the base class.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/475\">
https://github.com/lbl-srg/modelica-buildings/issues/475</a>.
</li>
<li>
November 23, 2015 by Filip Jorissen:<br/>
Corrected valve leakage value to avoid warnings.
</li>
<li>
February 28, 2013, by Michael Wetter:<br/>
Reformulated assignment of parameters.
Removed default value for <code>dpValve_nominal</code>, as this
parameter has the attribute <code>fixed=false</code> for some values
of <code>CvData</code>. In this case, assigning a value is not allowed.
Corrected wrong documentation of parameter <code>fraK(min=0, max=1) = 0.7</code>.
The documenation was
<i>Fraction Kv(port_1&rarr;port_2)/Kv(port_3&rarr;port_2)</i> instead of
<i>Fraction Kv(port_3&rarr;port_2)/Kv(port_1&rarr;port_2)</i>.
Because the parameter set correctly its attributes <code>min=0</code> and <code>max=1</code>,
instances of this model used the correct value.
</li>
<li>
April 12, 2012 by Michael Wetter:<br/>
Removed duplicate declaration of <code>m_flow_nominal</code>.
</li>
<li>
February 20, 2012 by Michael Wetter:<br/>
Renamed parameter <code>dp_nominal</code> to <code>dpValve_nominal</code>,
and added new parameter <code>dpFixed_nominal=0</code>.
See
<a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>.
</li>
<li>
March 25, 2011, by Michael Wetter:<br/>
Added homotopy method.
</li>
<li>
June 3, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialThreeWayValve;
