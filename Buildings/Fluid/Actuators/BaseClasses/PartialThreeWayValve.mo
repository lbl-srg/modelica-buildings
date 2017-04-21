within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialThreeWayValve "Partial three way valve"
  extends Buildings.Fluid.BaseClasses.PartialThreeWayResistance(
    final mDyn_flow_nominal = m_flow_nominal,
      redeclare replaceable
      Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve res1
        constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
          deltaM=deltaM,
          dp(start=dpValve_nominal/2),
          from_dp=from_dp,
          final l=l[1],
          final linearized=linearized[1],
          final homotopyInitialization=homotopyInitialization,
          final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
          final m_flow_nominal=m_flow_nominal,
          final dpValve_nominal=dpValve_nominal,
          final dpFixed_nominal=dpFixed_nominal[1],
          final use_inputFilter=false),
      redeclare FixedResistances.LosslessPipe res2(
        m_flow_nominal=m_flow_nominal),
      redeclare replaceable
      Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve res3
        constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
          deltaM=deltaM,
          dp(start=dpValve_nominal/2),
          from_dp=from_dp,
          final l=l[2],
          final linearized=linearized[2],
          final homotopyInitialization=homotopyInitialization,
          final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
          final m_flow_nominal=m_flow_nominal,
          final dpValve_nominal=dpValve_nominal/fraK^2,
          final dpFixed_nominal=dpFixed_nominal[2],
          final use_inputFilter=false));
    extends Buildings.Fluid.Actuators.BaseClasses.ActuatorSignal;
    extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
      rhoStd=Medium.density_pTX(101325, 273.15+4, Medium.X_default));

  parameter Modelica.SIunits.PressureDifference dpFixed_nominal[2](each displayUnit="Pa",
                                                         each min=0) = {0, 0}
    "Nominal pressure drop of pipes and other equipment in flow legs at port_1 and port_3"
    annotation(Dialog(group="Nominal condition"));

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

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

protected
  Modelica.Blocks.Math.Feedback inv "Inversion of control signal"
    annotation (Placement(transformation(extent={{-74,40},{-62,52}})));
  Modelica.Blocks.Sources.Constant uni(final k=1)
    "Outputs one for bypass valve"
    annotation (Placement(transformation(extent={{-92,40},{-80,52}})));
equation
  connect(uni.y, inv.u1)
    annotation (Line(points={{-79.4,46},{-72.8,46}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{0,70},{40,70}}),
        Rectangle(
          extent={{-100,44},{100,-36}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,26},{100,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{0,2},{-78,64},{-78,-56},{0,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-68,56},{0,2},{56,44},{76,60},{-68,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-56,-40},{0,2},{56,44},{60,-40},{-56,-40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,2},{82,64},{82,-54},{0,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,-56},{24,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-14,-56},{14,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{0,2},{62,-80},{-58,-80},{0,2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-30,46},{30,46}}),
        Line(
          points={{0,100},{0,-2}}),
        Rectangle(
          visible=use_inputFilter,
          extent={{-36,36},{36,100}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          visible=use_inputFilter,
          extent={{-36,100},{36,36}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_inputFilter,
          extent={{-22,92},{20,46}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="M",
          textStyle={TextStyle.Bold})}),
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
March 24, 2017, by Michael Wetter:<br/>
Renamed <code>filteredInput</code> to <code>use_inputFilter</code>.<br/>
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
