within Buildings.Rooms.BaseClasses;
model FFDFluidInterface
 extends Buildings.BaseClasses.BaseIcon;

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Integer nPorts(final min=2)=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.SIunits.Volume V = 1 "Volume. Fixme: propagate V";
  final parameter Modelica.SIunits.Mass m_start = 1.2 * V
    "Initial mass of air inside the room. Fixme: use actual density.";
  Modelica.Blocks.Interfaces.RealInput T_outflow[nPorts](
  each min=200,
  each nominal=300,
  each unit="K",
  each displayUnit="degC") "Temperature if m_flow < 0"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput Xi_outflow[nPorts*Medium.nXi](
  each min=0,
  each max=1,
  each unit="1") if Medium.nXi > 0 "Species concentration if m_flow < 0"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput C_outflow[nPorts*Medium.nC](
  each min=0) if Medium.nC > 0 "Trace substances if m_flow < 0"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealOutput p(
    min=80000,
    nominal=100000,
    max=120000,
    unit="Pa") "Room-averaged total pressure"
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
  unit="1") if
     Medium.nXi > 0 "Species concentration if m_flow >= 0"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput C_inflow[nPorts*Medium.nC](
  each min=0) if
     Medium.nC > 0 "Trace substances if m_flow >= 0"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  // Fluid port
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each final package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));

protected
  Modelica.Blocks.Interfaces.RealOutput Xi_inflow_internal[max(nPorts, nPorts*Medium.nXi)](
  min=0,
  max=1,
  unit="1") "Species concentration if m_flow >= 0";

  Modelica.Blocks.Interfaces.RealOutput C_inflow_internal[max(nPorts, nPorts*Medium.nC)](
  each min=0) "Trace substances if m_flow >= 0";

  Modelica.Blocks.Interfaces.RealInput Xi_outflow_internal[max(nPorts, nPorts*Medium.nXi)](
  each min=0,
  each max=1,
  each unit="1") "Species concentration if m_flow < 0";

  Modelica.Blocks.Interfaces.RealInput C_outflow_internal[max(nPorts, nPorts*Medium.nC)](
  each min=0) "Trace substances if m_flow < 0";

initial equation
  assert(nPorts >= 2, "The FFD model requires at least two fluid connections.");
  p = 101325; //fixme
equation
  // Internal connectors
  if Medium.nXi > 0 then
    connect(Xi_inflow_internal,  Xi_inflow);
    connect(Xi_outflow_internal, Xi_outflow);
  else
    Xi_inflow_internal  = fill(0, nPorts);
    Xi_outflow_internal = fill(0, nPorts);
  end if;
  if Medium.nC > 0 then
    connect(C_inflow_internal,  C_inflow);
    connect(C_outflow_internal, C_outflow);
  else
    C_inflow_internal  = fill(0, nPorts);
    C_outflow_internal = fill(0, nPorts);
  end if;

///////////// fixme
///  connect(vol.ports, ports) annotation (Line(
///      points={{2,-34},{2,-100},{0,-100}},
///      color={0,127,255},
///      smooth=Smooth.None));
  //// fixme: outputs of this model
/*  p1=1;
  m_flow = fill(1, nPorts);
  T_inflow = fill(1, nPorts);
  Xi_inflow_internal = fill(0, max(nPorts, nPorts*Medium.nXi));
  */
 // C_inflow_internal = fill(0, max(nPorts, nPorts*Medium.nC));

  // Pressure balance of bulk volume
  der(p) = p_start/m_start * sum(ports.m_flow);
  // Connection of input signals to ports
  for i in 1:nPorts-1 loop
    ports[i].p = p;
  end for;

  for i in 1:nPorts loop
    ports[i].h_outflow = Medium.specificEnthalpy_pTX(
       p=p,
       T=T_outflow[i],
       X=Xi_outflow_internal[(i-1)*Medium.nXi+1:i*Medium.nXi]);
    ports[i].Xi_outflow = Xi_outflow_internal[(i-1)*Medium.nXi+1:i*Medium.nXi];
    ports[i].C_outflow  = C_outflow_internal[ (i-1)*Medium.nC +1:i*Medium.nC];
  end for;

  // Connection of ports to output signals
   for i in 1:nPorts loop
     m_flow[i] = ports[i].m_flow;
     T_inflow[i] = Medium.temperature(Medium.setState_phX(
       p=  p,
       h=  inStream(ports[i].h_outflow),
       X=  inStream(ports[i].Xi_outflow)));

     for j in 1:Medium.nXi loop
       Xi_inflow_internal[(i-1)*Medium.nXi+j] = inStream(ports[i].Xi_outflow[j]);
     end for;

     for j in 1:Medium.nC loop
       C_inflow_internal[(i-1)*Medium.nC+j]    = inStream(ports[i].C_outflow[j]);
     end for;

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
