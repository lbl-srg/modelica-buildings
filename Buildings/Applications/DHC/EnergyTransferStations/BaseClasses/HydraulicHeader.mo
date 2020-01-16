within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model HydraulicHeader "Hydraulic header manifold."
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Integer nPorts_a = 0
    "Number of ports"
     annotation (
       Dialog(connectorSizing=true, tab="General", group="Ports"),
       Evaluate=true);
  parameter Integer nPorts_b = 0
    "Number of ports"
    annotation (
      Dialog(connectorSizing=true, tab="General",group="Ports"),
      Evaluate=true);
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal";
  Buildings.Fluid.FixedResistances.LosslessPipe pip(
    redeclare package Medium=Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal)
    "Dummy pipe component used to model ideal mixing at each port"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPorts_a](
    redeclare package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    annotation (Placement(
      transformation(extent={{-110,-40},{-90,40}}),
        iconTransformation(extent={{-10,-40}, {10,40}},
       rotation=180,
       origin={-100,0})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPorts_b](
    redeclare package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    annotation (Placement(
       transformation(extent={{90,-40},{110,40}}),
       iconTransformation(extent={{-10,-40}, {10,40}},
       rotation=0,
       origin={100,0})));
equation
  for i in 1:nPorts_a loop
    connect(ports_a[i], pip.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  end for;
  for i in 1:nPorts_b loop
    connect(pip.port_b, ports_b[i])
      annotation (Line(points={{10,0},{58,0},{58,0}, {100,0}}, color={0,127,255}));
  end for;
  annotation (
    defaultComponentName="hea",
    Icon(graphics={
    Rectangle(
     extent={{-100,8},{100,-6}},
     lineColor={255,170,255},
     lineThickness=0.5,
     fillColor={255,255,170},
     fillPattern=FillPattern.Solid),
    Rectangle(
     extent={{-100,60},{-80,-60}},
     lineColor={217,67,180},
     lineThickness=0.5,
     fillColor={255,170,213},
     fillPattern=FillPattern.Solid),
    Rectangle(
     extent={{80,60},{100,-60}},
     lineColor={217,67,180},
     lineThickness=0.5,
     fillColor={255,170,213},
     fillPattern=FillPattern.Solid),
    Text(
     extent={{-149,93},{151,53}},
     lineColor={0,0,255},
     fillPattern=FillPattern.HorizontalCylinder,
     fillColor={0,127,255},
     textString="%name")}),
Documentation(info="<html>
 <h4> Water hydraulic header </h4>
 <p>
 The model represents a header or a common pipe which hydraulically decouples
 different connected components at the system such as the EIR chiller and  stratified tanks, etc.
</p>

</html>", revisions="<html>
<ul>
<li>
September 10, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end HydraulicHeader;
