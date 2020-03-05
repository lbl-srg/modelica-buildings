within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model HydraulicHeader "Hydraulic header"
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
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors a (positive design flow direction is from ports_a to ports_b)"
    annotation (Placement(
      transformation(extent={{-110,-40},{-90,40}}),
        iconTransformation(extent={{-10,-40}, {10,40}},
       rotation=90,
       origin={-60,0})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPorts_b](
    redeclare each final package Medium=Medium,
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
initial equation
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
This is a model for a hydraulic header where ideal mixing is assumed for all
fluid streams connected to <code>ports_a</code>, respectively to <code>ports_b</code>.
Unbalanced flow rate (from outside components) over each of these fluid port arrays
is compensated by the flow rate (inside the component) toward or from the other 
fluid port array, with no delay and zero pressure drop. 
The condition <code>allowFlowReversal</code> only applies to the dummy pipe 
model used for transporting the fluid from one port array to the other.
Therefore the model can be used to represent a decoupler (vertical separator 
or common pipe) between a primary loop and a secondary loop as illustrated in
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Validation.HydraulicHeader\">
Buildings.Applications.DHC.EnergyTransferStations.Validation.HydraulicHeader</a>.
In that case:
</p>
<ul>
<li>
The primary supply stream (inflowing) gets connected to <code>ports_a</code>
together with the secondary supply streams (outflowing). 
</li>
<li> 
The primary return stream (outflowing) gets connected to <code>ports_b</code>
together with the secondary return streams (inflowing).
</li>
<li>
The parameter <code>allowFlowReversal</code> can be set to false if the primary
system is controlled to maintain a positive flow rate difference with the
secondary system, i.e. an actual positive flow rate from <code>ports_a</code> 
to <code>ports_b</code>.
</li>
</ul>
<p>
Note that the dummy pipe model is necessary to prevent any Modelica tool from
merging <code>ports_a</code> and <code>ports_b</code> if those were to be 
directly connected together. The model thus ensures ideal mixing over each 
fluid port array.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 16, 2020 by Antoine Gauitier:<br/>
Updated implementation and documentation.
</li>
<li>
September 10, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end HydraulicHeader;
