within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
model HydraulicHeader "Hydraulic header manifold"
 replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
  "Medium model";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
   "Nominal mass flow rate";
  parameter Integer nPorts_a=0
  "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Integer nPorts_b=0
  "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Boolean show_T=false
  "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal";

  Buildings.Fluid.FixedResistances.LosslessPipe pip(
    redeclare package Medium=Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal)
    "Dummy pipe component used to model ideal mixing at each port"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPorts_a](
    redeclare package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid ports"
    annotation (Placement(
      transformation(extent={{-110,-40},{-90,40}}),
        iconTransformation(extent={{-10,-40}, {10,40}},
       rotation=180,
       origin={-100,0})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPorts_b](
    redeclare package Medium=Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid ports"
    annotation (Placement(
       transformation(extent={{90,-40},{110,40}}),
       iconTransformation(extent={{-10,-40}, {10,40}},
       rotation=0,
       origin={100,0})));
// Thermodynamic states for each individual connected port

  Medium.ThermodynamicState sta_a[nPorts_a]=
                  {Medium.setState_phX(ports_a[i].p,
                          noEvent(actualStream(ports_a[i].h_outflow)),
                          noEvent(actualStream(ports_a[i].Xi_outflow)))
                                      for i} if   show_T;
  Medium.ThermodynamicState sta_b [nPorts_b]=
                         {Medium.setState_phX(ports_b[i].p,
                           noEvent(actualStream(ports_b[i].h_outflow)),
                           noEvent(actualStream(ports_b[i].Xi_outflow)))
                                      for i} if   show_T;
equation
    for i in 1:nPorts_a loop
      connect(pip.port_b, ports_a[i])
        annotation (Line(points={{-10,0},{-100,0}},color={0,127,255}));
    end for;
    for i in 1:nPorts_b loop
      connect(pip.port_a, ports_b[i])
        annotation (Line(points={{10,0},{100,0}},   color={0,127,255}));
    end for;

    annotation (Icon(graphics={
       Rectangle(
         extent={{-90,20},{88,-20}},
         lineColor={255,170,255},
         lineThickness=0.5,
         fillColor={255,255,170},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{-100,20},{-88,-20}},
         lineColor={217,67,180},
         lineThickness=0.5,
         fillColor={255,170,213},
         fillPattern=FillPattern.Solid),
       Rectangle(
         extent={{88,20},{100,-20}},
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
         defaultComponentName="hydHed",
Documentation(info="<html>
 <h4> Water hydraulic header </h4>
 <p>
 The model represents a header or a common pipe which hydraulically split
 up the entering flow into the branch circuits attached to it with zero head loss. 
 </p>

</html>", revisions="<html>
<ul>
<li>
January 16, 2020 by Antoine Gauitier :<br/>
Updated the implementation 
</li>
<li>
September 10, 2019 by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end HydraulicHeader;
