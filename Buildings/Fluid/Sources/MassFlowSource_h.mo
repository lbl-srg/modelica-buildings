within Buildings.Fluid.Sources;
model MassFlowSource_h
  "Ideal flow source that produces a prescribed mass flow with prescribed specific enthalpy, composition and trace substances"
  extends Buildings.Fluid.Sources.BaseClasses.PartialSource_Xi_C;

  parameter Boolean use_m_flow_in = false
    "Get the mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Modelica.Units.SI.MassFlowRate m_flow=0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Dialog(enable=not use_m_flow_in, group="Fixed inputs"));

  parameter Boolean use_h_in= false
    "Get the specific enthalpy from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Medium.SpecificEnthalpy h = Medium.h_default
    "Fixed value of specific enthalpy"
    annotation (Dialog(enable = not use_h_in, group="Fixed inputs"));

  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s") if use_m_flow_in
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),iconTransformation(extent={{-140,60},
            {-100,100}})));

  Modelica.Blocks.Interfaces.RealInput h_in(final unit="J/kg") if use_h_in
    "Prescribed boundary specific enthalpy"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

protected
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal(final unit="kg/s")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput h_in_internal(final unit="J/kg")
    "Needed to connect to conditional connector";

equation
  // Mass flow rate
  connect(m_flow_in, m_flow_in_internal);
  if not use_m_flow_in then
    m_flow_in_internal = m_flow;
  end if;
  for i in 1:nPorts loop
    ports[i].p = p_in_internal;
  end for;
  sum(ports.m_flow) = -m_flow_in_internal;
  // Enthalpy
  connect(h_in, h_in_internal);
  if not use_h_in then
    h_in_internal = h;
  end if;
  for i in 1:nPorts loop
     ports[i].h_outflow  = h_in_internal;
  end for;
  connect(medium.h, h_in_internal);

  annotation (defaultComponentName="boundary",
    Documentation(info="<html>
<p>
Models an ideal flow source, with prescribed values of flow rate, specific enthalpy, composition and trace substances:
</p>
<ul>
<li> Prescribed mass flow rate.</li>
<li> Prescribed specific enthalpy.</li>
<li> Boundary composition (only for multi-substance or trace-substance flow).</li>
</ul>
<p>
If <code>use_m_flow_in</code> is false (default option),
the <code>m_flow</code> parameter
is used as boundary pressure, and the <code>m_flow_in</code>
input connector is disabled; if <code>use_m_flow_in</code>
is true, then the <code>m_flow</code> parameter is ignored,
and the value provided by the input connector is used instead.
</p>
<p>
The same applies to the specific enthalpy <i>h</i>, composition <i>X<sub>i</sub></i> or <i>X</i> and trace substances <i>C</i>.
</p>
<h4>Options</h4>
<p>
Instead of using <code>Xi_in</code> (the <i>independent</i> composition fractions),
the advanced tab provides an option for setting all
composition fractions using <code>X_in</code>.
<code>use_X_in</code> and <code>use_Xi_in</code> cannot be used
at the same time.
</p>
<p>
Parameter <code>verifyInputs</code> can be set to <code>true</code>
to enable a check that verifies the validity of the used specific enthalpy
and pressures.
This removes the corresponding overhead from the model, which is
a substantial part of the overhead of this model.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>
for more information.
</p>
<p>
Note, that boundary specific enthalpy,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary flow rate, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Made <code>medium</code> conditional and refactored inputs.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
<li>
April 18, 2017, by Filip Jorissen:<br/>
Changed <code>checkBoundary</code> implementation
such that it is run as an initial equation
when it depends on parameters only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/728\">#728</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
Implemenation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          visible=use_m_flow_in,
          extent={{-185,132},{-45,100}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Text(
          visible=use_h_in,
          extent={{-162,34},{-60,-6}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="h"),
        Rectangle(
          extent={{35,45},{100,-45}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-100,80},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{60,0},{-60,-68},{-60,70}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,32},{16,-30}},
          textColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                  Text(
          extent={{-161,110},{139,150}},
          textString="%name",
          textColor={0,0,255})}));
end MassFlowSource_h;
