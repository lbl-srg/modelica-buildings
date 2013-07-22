within Buildings.Rooms.BaseClasses;
model FFDFluidInterface
 extends Buildings.BaseClasses.BaseIcon;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Integer nPorts(final min=2)=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));

  Modelica.Blocks.Interfaces.RealInput p[nPorts-1](
  each min=80000,
  each nominal=100000,
  each max=120000,
  each unit="Pa") "Total pressure in ports[2:nPorts]"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput T_outflow[nPorts](
  each min=200,
  each nominal=300,
  each unit="K",
  each displayUnit="degC") "Temperature if m_flow < 0"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput Xi_outflow[nPorts*Medium.nXi](
  each min=0,
  each max=1,
  each unit="1") "Species concentration if m_flow < 0"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput C_outflow[nPorts*Medium.nC](
  each min=0) "Trace substances if m_flow < 0"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealOutput p1(
  min=80000,
  nominal=100000,
  max=120000,
  unit="Pa") "Total pressure in ports[1]"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow[nPorts] "Mass flow rates"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput T_inflow[nPorts](
  each min=200,
  each nominal=300,
  each unit="K",
  each displayUnit="degC") "Temperature if m_flow >= 0"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput Xi_inflow[nPorts*Medium.nXi](
  min=0,
  max=1,
  unit="1") "Species concentration if m_flow >= 0"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput C_inflow[nPorts*Medium.nC](
  each min=0) "Trace substances if m_flow >= 0"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  // Fluid port
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each final package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));

initial equation
  assert(nPorts >= 2, "The FFD model requires at least two fluid connections.");
equation
  // Connection of input signals to ports
  ports[2:nPorts].p = p;
  for i in 1:nPorts loop
    ports[i].h_outflow = Medium.specificEnthalpy_pTX(
       p=ports[i].p,
       T=T_outflow[i],
       X=Xi_outflow[(i-1)*Medium.nX+1:i*Medium.nX]);
    ports[i].Xi_outflow = Xi_outflow[(i-1)*Medium.nXi+1:i*Medium.nXi];
    ports[i].C_outflow  = C_outflow[ (i-1)*Medium.nC +1:i*Medium.nC];
  end for;

  // Connection of ports to output signals
   p1 = ports[1].p;
   m_flow = ports.m_flow;
   for i in 1:nPorts loop
     T_inflow[i] = Medium.temperature(Medium.setState_phX(
       p=  ports[i].p,
       h=  inStream(ports[i].h_outflow),
       X=  inStream(ports[i].Xi_outflow)));
     Xi_inflow[(i-1)*Medium.nXi+1:i*Medium.nXi] = inStream(ports[i].Xi_outflow);
     C_inflow[(i-1)*Medium.nC+1:i*Medium.nC]    = inStream(ports[i].C_outflow);
   end for;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model is used to connect the fluid port with
the block that communicates with the fast fluid flow dynamic program.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FFDFluidInterface;
