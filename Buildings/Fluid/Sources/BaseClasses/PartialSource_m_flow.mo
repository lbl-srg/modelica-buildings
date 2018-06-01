within Buildings.Fluid.Sources.BaseClasses;
model PartialSource_m_flow "Partial source with prescribed flow rate"
  extends Buildings.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_m_flow_in = false
    "Get the mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Modelica.SIunits.MassFlowRate m_flow = 0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Dialog(enable = not use_m_flow_in,group="Fixed inputs"));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s") if use_m_flow_in
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),iconTransformation(extent={{-140,60},
            {-100,100}})));
protected
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal(final unit="kg/s")
    "Needed to connect to conditional connector";
equation
  connect(m_flow_in, m_flow_in_internal);
  if not use_m_flow_in then
    m_flow_in_internal = m_flow;
  end if;
  for i in 1:nPorts loop
    ports[i].p = p_in_internal;
  end for;
  sum(ports.m_flow) = -m_flow_in_internal;

  annotation (Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
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
          visible=use_m_flow_in,
          extent={{-185,132},{-45,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Text(
          extent={{-54,32},{16,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Text(
          extent={{-150,130},{150,170}},
          textString="%name",
          lineColor={0,0,255}),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
      Documentation(revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Initial version for refactoring inputs of sources.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
</ul>
</html>", info="<html>
<p>
Partial model that defines the <i>sum</i> of
<code>ports.m_flow</code> using an optional input for
the total mass flow rate.
All port pressures are assumed equal.
Otherwise the parameter value is used.
</p>
</html>"));
end PartialSource_m_flow;
