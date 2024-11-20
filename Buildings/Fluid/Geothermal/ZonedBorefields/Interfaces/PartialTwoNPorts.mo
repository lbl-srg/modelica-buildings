within Buildings.Fluid.Geothermal.ZonedBorefields.Interfaces;
partial model PartialTwoNPorts "Partial component with vectors of ports"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Integer nPorts(min=1)
    "Number of fluid ports on each side";

  Modelica.Fluid.Interfaces.FluidPort_a port_a[nPorts](
    redeclare each final package Medium = Medium,
      each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
      each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
      each p(start=Medium.p_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b[nPorts](
    redeclare each final package Medium = Medium,
      each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
      each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
      each p(start=Medium.p_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  annotation (
    Documentation(info="<html>
<p>
This partial model defines an interface for components with multiple pairs of
inlet and outlet ports, here implemented as two vectors of ports.
The treatment of the design flow direction and of flow reversal are predefined
based on the parameter <code>allowFlowReversal</code>.
The component may transport fluid and may have internal storage for a given
fluid <code>Medium</code>.
The definitions of flow reversal and the <code>Medium</code> apply to all ports.
</p>
<h4>Implementation</h4>
<p>
This model is similar to
<a href=\"modelica://Modelica.Fluid.Interfaces.PartialTwoPort\">
Modelica.Fluid.Interfaces.PartialTwoPort</a>
but it does not use the <code>outer system</code> declaration.
This declaration is omitted as in building energy simulation,
many models use multiple media, an in practice,
users have not used this global definition to assign parameters.
The ports are vectorized, to allow multiple pairs of inlet and outlet ports.
</p>
</html>", revisions="<html>
<ul>
<li>
February, 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{20,-70},{60,-85},{20,-100},{20,-70}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversal),
        Line(
          points={{55,-85},{-60,-85}},
          color={0,128,255},
          visible=not allowFlowReversal),
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name")}));
end PartialTwoNPorts;
