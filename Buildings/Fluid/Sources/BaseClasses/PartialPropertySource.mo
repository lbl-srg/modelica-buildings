within Buildings.Fluid.Sources.BaseClasses;
partial model PartialPropertySource
  "Partial model for overriding fluid properties that flow through the component"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Boolean use_Xi_in= false
    "Set to true to get the composition from the input connector"
    annotation(Evaluate=true, Dialog(group="Inputs"));
  parameter Boolean use_C_in= false
    "Set to true to get the trace substances from the input connector"
    annotation(Evaluate=true, Dialog(group="Inputs"));

  Modelica.Blocks.Interfaces.RealInput Xi_in[Medium.nXi] if use_Xi_in
    "Prescribed values for composition" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC](
    final quantity=Medium.extraPropertiesNames) if use_C_in
    "Prescribed values for trace substances" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,120})));
protected
  Modelica.Blocks.Interfaces.RealOutput h_internal_a
    "Internal outlet value of port_a.h_outflow";
  Modelica.Blocks.Interfaces.RealOutput h_internal_b
    "Internal outlet value of port_b.h_outflow";
  Modelica.Blocks.Interfaces.RealOutput h_in_a = inStream(port_a.h_outflow)
    "Connector for inStream value of port_a.h_outflow";
  Modelica.Blocks.Interfaces.RealOutput h_in_b = inStream(port_b.h_outflow)
    "Connector for inStream value of port_b.h_outflow";

  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi_internal_a
    "Internal outlet value of port_a.Xi_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi_internal_b
    "Internal outlet value of port_b.Xi_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi_in_a = inStream(port_a.Xi_outflow)
    "Connector for inStream value of port_a.Xi_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi_in_b = inStream(port_b.Xi_outflow)
    "Connector for inStream value of port_b.Xi_outflow";

  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_internal_a
    "Internal outlet value of port_a.C_outflow";
  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_internal_b
    "Internal outlet value of port_b.C_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nC] C_in_a = inStream(port_a.C_outflow)
    "Connector for inStream value of port_a.C_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nC] C_in_b = inStream(port_b.C_outflow)
    "Connector for inStream value of port_b.C_outflow";
equation
  connect(Xi_internal_a, Xi_in);
  connect(Xi_internal_b, Xi_in);
  if not (use_Xi_in) then
    connect(Xi_internal_a,Xi_in_b);
    connect(Xi_internal_b,Xi_in_a);
  end if;

  connect(C_internal_a, C_in);
  connect(C_internal_b, C_in);
  if not (use_C_in) then
    connect(C_internal_a,C_in_b);
    connect(C_internal_b,C_in_a);
  end if;

  port_a.h_outflow = if allowFlowReversal then h_internal_a else Medium.h_default;
  port_b.h_outflow = h_internal_b;
  port_a.Xi_outflow = if allowFlowReversal then Xi_internal_a else Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = Xi_internal_b;
  port_a.C_outflow = if allowFlowReversal then C_internal_a else zeros(Medium.nC);
  port_b.C_outflow = C_internal_b;

  port_a.p = port_b.p;
  port_a.m_flow + port_b.m_flow = 0;

  annotation (defaultComponentName="proSou",
        Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          visible=use_Xi_in,
          extent={{-48,98},{54,58}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Xi"),
        Text(
          visible=use_C_in,
          extent={{-10,98},{92,58}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C"),
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}),
    Documentation(info="<html>
<p>
Model that changes the properties, 
but not the mass flow rate,
of the fluid that passes through it.
</p>
<h4>Typical use and important parameters</h4>
<p>
If <code>allowFlowReversal=true</code>, then the properties are changed for both flow directions,
i.e., from <code>port_a</code> to <code>port_b</code> and
from <code>port_b</code> to <code>port_a</code>.
</p>
<h4>Dynamics</h4>
<p>
This model has no dynamics.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 30, 2018, by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/881\">#881</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}})));
end PartialPropertySource;
