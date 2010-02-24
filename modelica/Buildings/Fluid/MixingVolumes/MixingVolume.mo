within Buildings.Fluid.MixingVolumes;
model MixingVolume
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
  extends Buildings.Fluid.Interfaces.PartialLumpedVolume(
      m(start=V*rho_nominal, fixed=false),
      final fluidVolume = V);
    import Modelica.Constants.pi;
  annotation (Documentation(info="<html>
This model represents an instantaneously mixed volume. 
Potential and kinetic energy at the port are neglected,
and there is no pressure drop at the ports.
The volume can be parameterized to allow heat exchange
through a <code>heatPort</code>.
</html>", revisions="<html>
<ul>
<li>
February 7, 2010 by Michael Wetter:<br>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br>
Changed base class to
<a href=\"Modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"), Diagram(graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{-100,98},{100,-102}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}), Text(
          extent={{-58,14},{58,-18}},
          lineColor={0,0,0},
          textString="V=%V")}));

  // Port definitions
  parameter Integer nPorts=0 "Number of ports" 
    annotation(Evaluate=true, Dialog(__Dymola_connectorSizing=true, tab="General",group="Ports"));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets" 
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));

//  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0)=system.m_flow_small
//    "Regularization range at zero mass flow rate"
//    annotation(Dialog(tab="Advanced", group="Port properties", enable=stiffCharacteristicForEmptyPort));
  Medium.EnthalpyFlowRate ports_H_flow[nPorts];
  Medium.MassFlowRate ports_mXi_flow[nPorts,Medium.nXi];
  Medium.MassFlowRate[Medium.nXi] sum_ports_mXi_flow
    "Substance mass flows through ports";
  Medium.ExtraPropertyFlowRate ports_mC_flow[nPorts,Medium.nC];
  Medium.ExtraPropertyFlowRate[Medium.nC] sum_ports_mC_flow
    "Trace substance mass flows through ports";

  // Heat transfer through boundary
  parameter Boolean use_HeatTransfer = false
    "= true to use the HeatTransfer model" 
      annotation (Dialog(tab="Assumptions", group="Heat transfer"));
  replaceable model HeatTransfer = 
      Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer 
    constrainedby
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer
    "Wall heat transfer" 
      annotation (Dialog(tab="Assumptions", group="Heat transfer",enable=use_HeatTransfer),choicesAllMatching=true);
  HeatTransfer heatTransfer(
    redeclare final package Medium = Medium,
    surfaceAreas={4*pi*(3/4*V/pi)^(2/3)},
    final n=1,
    final states = {medium.state},
    final use_k = use_HeatTransfer) 
      annotation (Placement(transformation(
        extent={{-10,-10},{30,30}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_HeatTransfer 
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  parameter Modelica.SIunits.Volume V "Volume";

protected
   parameter Medium.ThermodynamicState sta0 = Medium.setState_pTX(T=T_start,
         p=p_start, X=X_start[1:Medium.nXi]);
   parameter Modelica.SIunits.Density rho_nominal=Medium.density(sta0)
    "Density, used to compute fluid mass";

equation
// Only one connection allowed to a port to avoid unwanted ideal mixing
  for i in 1:nPorts loop
    assert(cardinality(ports[i]) <= 1,"
each ports[i] of volume can at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");
  end for;

  // actual definition of port variables
  for i in 1:nPorts loop
    // fluid flow through ports
      // regular operation: fluidLevel is above ports[i]
      // Note: >= covers default values of zero as well
    ports[i].p          = medium.p;
    ports[i].h_outflow  = medium.h;
    ports[i].Xi_outflow = medium.Xi;
    ports[i].C_outflow  = C;

    ports_H_flow[i]     = ports[i].m_flow * actualStream(ports[i].h_outflow)
      "Enthalpy flow";
    ports_mXi_flow[i,:] = ports[i].m_flow * actualStream(ports[i].Xi_outflow)
      "Component mass flow";
    ports_mC_flow[i,:]  = ports[i].m_flow * actualStream(ports[i].C_outflow)
      "Trace substance mass flow";
  end for;

  for i in 1:Medium.nXi loop
    sum_ports_mXi_flow[i] = sum(ports_mXi_flow[:,i]);
  end for;

  for i in 1:Medium.nC loop
    sum_ports_mC_flow[i]  = sum(ports_mC_flow[:,i]);
  end for;
  mb_flow = sum(ports.m_flow);
  mbXi_flow = sum_ports_mXi_flow;
  mbC_flow  = sum_ports_mC_flow;
  Hb_flow = sum(ports_H_flow);
  Qb_flow = heatTransfer.Q_flows[1];

  connect(heatPort, heatTransfer.heatPorts[1]) annotation (Line(
      points={{-100,5.55112e-16},{-87,5.55112e-16},{-87,2.22045e-15},{-74,
          2.22045e-15}},
      color={191,0,0},
      smooth=Smooth.None));

end MixingVolume;
