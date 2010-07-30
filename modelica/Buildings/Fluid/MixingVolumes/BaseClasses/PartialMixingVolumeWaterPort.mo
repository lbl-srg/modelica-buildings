within Buildings.Fluid.MixingVolumes.BaseClasses;
partial model PartialMixingVolumeWaterPort
  "Partial mixing volume that allows adding or subtracting water vapor"
  extends Buildings.Fluid.Interfaces.PartialLumpedVolume(fluidVolume = V, m(start=V*rho_nominal, fixed=false),
      mC(nominal=V*rho_nominal*C_nominal));

// declarations similar than in PartialLumpedVolumePorts from Modelica.Fluid
  // Port definitions
  parameter Integer nPorts(min=1)=1 "Number of ports"
    annotation(Evaluate=true, Dialog(__Dymola_connectorSizing=true, tab="General",group="Ports"));
  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts](
      redeclare each package Medium = Medium) "Fluid outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));
  Medium.AbsolutePressure ports_p_static
    "static pressure at the ports, inside the volume";

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
      Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer (
       surfaceAreas={4*Modelica.Constants.pi*(3/4*V/Modelica.Constants.pi)^(2/3)})
    constrainedby
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer
    "Wall heat transfer"
      annotation (Dialog(tab="Assumptions", group="Heat transfer",enable=use_HeatTransfer),choicesAllMatching=true);
  HeatTransfer heatTransfer(
    redeclare final package Medium = Medium,
    final n=1,
    final states = {medium.state},
    final use_k = use_HeatTransfer)
      annotation (Placement(transformation(
        extent={{-10,-10},{30,30}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_HeatTransfer
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

 // additional declarations
  Modelica.Blocks.Interfaces.RealInput mWat_flow(final quantity="MassFlowRate",
                                                 final unit = "kg/s")
    "Water flow rate added into the medium"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},rotation=
           0)));
  Modelica.Blocks.Interfaces.RealInput TWat(final quantity="ThermodynamicTemperature",
                                            final unit = "K", displayUnit = "degC", min=260)
    "Temperature of liquid that is drained from or injected into volume"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput X_w "Species composition of medium"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}, rotation=
           0)));
  Medium.MassFlowRate mXi_flow[Medium.nXi]
    "Mass flow rates of independent substances added to the medium";
  Modelica.SIunits.HeatFlowRate HWat_flow
    "Enthalpy flow rate of extracted water";
   parameter Modelica.SIunits.Volume V "Volume";
protected
   parameter Modelica.SIunits.Density rho_nominal=Medium.density(
     Medium.setState_pTX(
      T=T_start,
      p=p_start,
      X=X_start[1:Medium.nXi])) "Density, used to compute fluid mass"
                                           annotation (Evaluate=true);
equation
   assert(not (energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState and
        massDynamics==Modelica.Fluid.Types.Dynamics.SteadyState) or Medium.singleState,
          "Bad combination of dynamics options and Medium not conserving mass if fluidVolume is fixed.");

  ports_p_static = medium.p;

  connect(heatPort, heatTransfer.heatPorts[1]) annotation (Line(
      points={{-100,5.55112e-16},{-87,5.55112e-16},{-87,2.22045e-15},{-74,
          2.22045e-15}},
      color={191,0,0},
      smooth=Smooth.None));
//  Wb_flow = 0;

  mb_flow = sum(ports.m_flow) + mWat_flow
    "eqn. differs from Modelica.Fluid implementation";
  mbXi_flow = sum_ports_mXi_flow + mXi_flow
    "eqn. differs from Modelica.Fluid implementation";
  mbC_flow  = sum_ports_mC_flow;
  Hb_flow = sum(ports_H_flow) + HWat_flow
    "eqn. differs from Modelica.Fluid implementation";
  Qb_flow = heatTransfer.Q_flows[1];

  // Only one connection allowed to a port to avoid unwanted ideal mixing
  for i in 1:nPorts loop
    assert(cardinality(ports[i]) <= 1,"
each ports[i] of volume can at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");
  end for;

  // Boundary conditions
  for i in 1:nPorts loop
    ports[i].p = ports_p_static;
  end for;
  ports.h_outflow = fill(medium.h,   nPorts);
  ports.Xi_outflow = fill(medium.Xi, nPorts);
  ports.C_outflow  = fill(C,         nPorts);

  for i in 1:nPorts loop
    ports_H_flow[i] = ports[i].m_flow * actualStream(ports[i].h_outflow)
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

  annotation (
    Documentation(info="<html>
Model for an ideally mixed fluid volume with <tt>nP</tt> ports and the ability 
to store mass and energy. The volume is fixed. 
<p>
This model represents the same physics as 
<a href=\"Modelica:Modelica.Fluid.Vessels.Volume\">
Modelica.Fluid.Vessels.Volume</a> but in addition,
it allows to connect signals for the water exchanged with the volume.
The model is partial in order to allow a submodel that can be used with media
that contain water as a substance, and a submodel that can be used with dry air.
Having separate models is required because calls to the medium property function
<tt>enthalpyOfLiquid</tt> results in a linker error if a medium such as 
<a href=\"Modelica:Modelica.Media.Air.SimpleAir\">Modelica.Media.Air.SimpleAir</a>
is used that does not implement this function.
</p>
</html>", revisions="<html>
<ul>
<li>
July 30, 2010 by Michael Wetter:<br>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
March 24, 2010 by Michael Wetter:<br>
Changed base class from <code>Modelica.Fluid</code> to <code>Buildings.Fluid</code>.
<li>
August 12, 2008 by Michael Wetter:<br>
Introduced option to compute model in steady state. This allows the heat exchanger model
to switch from a dynamic model for the medium to a steady state model.
</li>
<li>
August 13, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                   graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-76,-6},{198,-48}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="X_w"),
        Text(
          extent={{-122,114},{-80,82}},
          lineColor={0,0,0},
          textString="mWat_flow"),
        Text(
          extent={{-152,74},{-42,50}},
          lineColor={0,0,0},
          textString="TWat"),
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}),
        Text(
          extent={{-60,16},{56,-16}},
          lineColor={0,0,0},
          textString="V=%V")}));
end PartialMixingVolumeWaterPort;
