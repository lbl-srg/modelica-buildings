within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model HydraulicHeader "Hydraulic header manifold"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Integer nPorts_a = 0
    "Number of ports"
    annotation(Dialog(connectorSizing=true, tab="General",group="Ports"), Evaluate=true);
  parameter Integer nPorts_b = 0
    "Number of ports"
    annotation(Dialog(connectorSizing=true, tab="General",group="Ports"), Evaluate=true);
  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPorts_a](
    redeclare each final package Medium=Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors a (positive design flow direction is from ports_a to ports_b)"
    annotation (Placement(
      transformation(extent={{-110,-40},{-90,40}}),
        iconTransformation(extent={{-10,-40}, {10,40}},
       rotation=90,
       origin={-60,0})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPorts_b](
    redeclare each final package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors b (positive design flow direction is from ports_a to ports_b)"
    annotation (Placement(
       transformation(extent={{90,-40},{110,40}}),
       iconTransformation(extent={{-10,-40}, {10,40}},
       rotation=90,
       origin={60,0})));
  Buildings.Fluid.FixedResistances.LosslessPipe pip(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal)
    "Dummy pipe component used to model ideal mixing at each port"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  for i in 1:nPorts_a loop
    connect(ports_a[i], pip.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  end for;
  for i in 1:nPorts_b loop
    connect(pip.port_b, ports_b[i])
      annotation (Line(points={{10,0},{100,0},{100,0}}, color={0,127,255}));
    end for;
annotation (Icon(graphics={
  Rectangle(
   extent={{-90,40},{90,-40}},
   lineColor={0,128,255},
   lineThickness=0.5,
   fillColor={170,213,255},
   fillPattern=FillPattern.HorizontalCylinder,
          pattern=LinePattern.None),
  Rectangle(
   extent={{-100,40},{-90,-40}},
   lineColor={217,67,180},
   lineThickness=0.5,
   fillColor={0,0,0},
   fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
  Rectangle(
   extent={{90,40},{100,-40}},
   lineColor={217,67,180},
   lineThickness=0.5,
   fillColor={0,0,0},
   fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
  Text(
   extent={{-149,93},{151,53}},
   lineColor={0,0,255},
   fillPattern=FillPattern.HorizontalCylinder,
   fillColor={0,127,255},
   textString="%name")}),
   defaultComponentName="hdr",
Documentation(info="<html>
<h4>Hydraulic header</h4>
<p>
The model represents a header or a common pipe which hydraulically splits
up the entering flow into the branch circuits attached to it with zero head loss. 
</p>
</html>",
revisions="<html>
<ul>
<li>
January 16, 2020 by Antoine Gauitier:<br/>
Updated the implementation 
</li>
<li>
September 10, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end HydraulicHeader;
