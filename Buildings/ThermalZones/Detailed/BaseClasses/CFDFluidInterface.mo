within Buildings.ThermalZones.Detailed.BaseClasses;
model CFDFluidInterface
 extends Buildings.BaseClasses.BaseIcon;

   replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));

  // Parameters for the model
  parameter Integer nPorts(min=0)=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Modelica.Units.SI.Density rho_start
    "Density, used to compute fluid mass";
  parameter Modelica.Units.SI.Volume V "Volume";
  final parameter Modelica.Units.SI.Mass m_start=rho_start*V
    "Initial mass of air inside the room.";

  Modelica.Blocks.Interfaces.RealInput T_outflow[nPorts](
  each start=Medium.T_default,
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
    start=p_start,
    min=80000,
    nominal=100000,
    max=120000,
    unit="Pa") "Room-averaged total pressure"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow[nPorts](
  each quantity="MassFlowRate",
  each unit="kg/s") "Mass flow rates"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput T_inflow[nPorts](
  each start=Medium.T_default,
  each min=200,
  each max=373.15,
  each nominal=300,
  each unit="K",
  each displayUnit="degC") "Temperature if m_flow >= 0"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput Xi_inflow[nPorts*Medium.nXi](
  each min=0,
  each max=1,
  each unit="1")
  if Medium.nXi > 0 "Species concentration if m_flow >= 0"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput C_inflow[nPorts*Medium.nC](
  each min=0)
  if Medium.nC > 0 "Trace substances if m_flow >= 0"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  // Fluid port
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each final package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));

protected
  Modelica.Blocks.Interfaces.RealOutput Xi_inflow_internal[max(nPorts, nPorts*Medium.nXi)](
  each min=0,
  each max=1,
  each unit="1") "Species concentration if m_flow >= 0";

  Modelica.Blocks.Interfaces.RealOutput C_inflow_internal[max(nPorts, nPorts*Medium.nC)](
  each min=0) "Trace substances if m_flow >= 0";

  Modelica.Blocks.Interfaces.RealInput Xi_outflow_internal[max(nPorts, nPorts*Medium.nXi)](
  each min=0,
  each max=1,
  each unit="1") "Species concentration if m_flow < 0";

  Modelica.Blocks.Interfaces.RealInput C_outflow_internal[max(nPorts, nPorts*Medium.nC)](
  each min=0) "Trace substances if m_flow < 0";

  Modelica.Units.SI.MassFlowRate[Medium.nXi] mbXi_flow
    "Substance mass flows across boundaries";
  Modelica.Units.SI.MassFlowRate ports_mXi_flow[nPorts,Medium.nXi];

initial equation
  //Disable it for shoebox model test
  //assert(nPorts >= 2, "The CFD model requires at least two fluid connections.");

  if massDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
    p = p_start;
  else
    if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
      der(p) = 0;
    end if;
  end if;

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

  // Mass and pressure balance of bulk volume.
  // The assumption is that change in temperature does not change the pressure.
  // Otherwise, we would need to use the BaseProperties of the medium model.
  for i in 1:nPorts loop
    ports_mXi_flow[i,:] = ports[i].m_flow * actualStream(ports[i].Xi_outflow);
  end for;
  for i in 1:Medium.nXi loop
    mbXi_flow[i] = sum(ports_mXi_flow[:,i]);
  end for;
  if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    0 = sum(ports.m_flow) + sum(mbXi_flow);
  else
    // For the change in pressure, we neglect the term sum(mbXi_flow)
    // as this term is small compared to sum(ports.m_flow) but it
    // introduces a nonlinear equation
    //    der(p) = p_start*(sum(ports.m_flow) + sum(mbXi_flow))/m_start;
    der(p) = p_start*(sum(ports.m_flow))/m_start;
  end if;

  // Connection of input signals to ports.
  // Connect pressures.
  for i in 1:nPorts loop
    ports[i].p = p;
  end for;
  // Connect enthalpy, mass fraction and trace substances.
  for i in 1:nPorts loop
    ports[i].h_outflow = Medium.specificEnthalpy_pTX(
       p=p,
       T=T_outflow[i],
       X=Xi_outflow_internal[(i-1)*Medium.nXi+1:i*Medium.nXi]);
    ports[i].Xi_outflow = Xi_outflow_internal[(i-1)*Medium.nXi+1:i*Medium.nXi];
    ports[i].C_outflow  = C_outflow_internal[ (i-1)*Medium.nC +1:i*Medium.nC];
  end for;

  // Connection of ports to output signals.
   for i in 1:nPorts loop
     m_flow[i] = ports[i].m_flow;
     T_inflow[i] = Medium.temperature(Medium.setState_phX(
       p = p,
       h = inStream(ports[i].h_outflow),
       X = inStream(ports[i].Xi_outflow)));

     for j in 1:Medium.nXi loop
       Xi_inflow_internal[(i-1)*Medium.nXi+j] = inStream(ports[i].Xi_outflow[j]);
     end for;

     for j in 1:Medium.nC loop
       C_inflow_internal[(i-1)*Medium.nC+j]    = inStream(ports[i].C_outflow[j]);
     end for;

   end for;

  annotation (    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model is used to connect the fluid port with
the block that communicates with the CFD program.
</p>
<p>
This model also implements the pressure balance of the medium, as the
FFD implementation uses a constant pressure that is independent of the
pressure of the Modelica model.
If the parameter <code>massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState</code>,
then there is a steady-state mass balance and the pressure of the room
is an algebraic variable.
Otherwise, the time derivative of the pressure is
</p>
<p align=\"center\" style=\"font-style:italic;\">
dp&frasl;dt = p_<sub>start</sub> &nbsp; &sum; m&#775;<sub>i</sub> &frasl; m<sub>start</sub>,
</p>
<p>
where
<i>p_<sub>start</sub></i> is the initial pressure,
<i>&sum; m&#775;<sub>i</sub></i> is the sum of the mass flow rates over all ports, and
<i>m<sub>start</sub></i> is the initial mass of the room.
</p>
</html>", revisions="<html>
<ul>
<li>
July 24, 2014, by Wangda Zuo and Michael Wetter:<br/>
Removed the parameter <code>initialize_p</code>. This parameter
is used in <code>.Media</code> as equations are obtained from
<code>BaseProperties</code>.
This implementation does not use <code>Medium.BaseProperties</code>
and hence this parameter is not needed.
</li>
<li>
July 24, 2014, by Wangda Zuo and Michael Wetter:<br/>
Changed minimum attribute for <code>nPorts</code> from <i>2</i> to <i>0</i>
as the FFD code uses atmospheric pressure and hence does not use the pressure
of the fluid connector.
</li>
<li>
January 25, 2014, by Wangda Zuo:<br/>
Added unit for mass flow rate.
</li>
<li>
July 20, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end CFDFluidInterface;
