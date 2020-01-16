within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Agents;
model Decoupler "Model for a primary / secondary hydraulic decoupler"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium
    "Medium model for water"
    annotation (choicesAllMatching = true);
  parameter Integer nSec=1
    "Number of secondary supply pipes"
    annotation(Dialog(connectorSizing=true));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a2[nSec](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors for secondary return"
    annotation (Placement(transformation(extent={{90,-100},{110,-20}}),
      iconTransformation(extent={{90,-92},{110,-12}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium=Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector primary supply"
    annotation (Placement(transformation(
      extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,40},{-90,60}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium=Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector primary return"
    annotation (Placement(transformation(
      extent={{-90,-70},{-110,-50}}), iconTransformation(extent={{-90,-70},{-110,
            -50}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b2[nSec](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors for secondary supply"
    annotation (Placement(transformation(extent={{90,20},{110,100}}),
      iconTransformation(extent={{90,10},{110,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare each final package Medium=Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    final dp_nominal=0)
    "Dummy resistance to compute ideal mixing at each port"
    annotation (Placement(
      transformation(
      extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={0,0})));
equation
  connect(port_a1, res.port_a) annotation (Line(points={{-100,60},{0,60},{0,10},
          {1.77636e-15,10}}, color={0,127,255}));
  connect(res.port_a, ports_b2[1]) annotation (Line(points={{1.77636e-15,10},{0,
          10},{0,60},{100,60}}, color={0,127,255}));
  connect(port_b1, res.port_b) annotation (Line(points={{-100,-60},{0,-60},{0,-10},
          {-1.77636e-15,-10}}, color={0,127,255}));
  connect(ports_a2[1], res.port_b) annotation (Line(points={{100,-60},{0,-60},{0,
          -10},{-1.77636e-15,-10}}, color={0,127,255}));
  annotation (
  defaultComponentName="dec", Icon(coordinateSystem(extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-124},{151,-164}},
          lineColor={0,0,255},
          textString="%name")}));
end Decoupler;
