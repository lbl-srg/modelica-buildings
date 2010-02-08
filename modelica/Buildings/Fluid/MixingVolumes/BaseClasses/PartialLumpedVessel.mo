within Buildings.Fluid.MixingVolumes.BaseClasses;
partial model PartialLumpedVessel
  "Lumped volume with a vector of fluid ports and replaceable heat transfer model"
  extends Buildings.Fluid.Interfaces.PartialLumpedVolume;

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
    final n=1,
    final states = {medium.state},
    final use_k = use_HeatTransfer) 
      annotation (Placement(transformation(
        extent={{-10,-10},{30,30}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_HeatTransfer 
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

equation
  mb_flow = sum(ports.m_flow);
  mbXi_flow = sum_ports_mXi_flow;
  mbC_flow  = sum_ports_mC_flow;
  Hb_flow = sum(ports_H_flow);
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

  // actual definition of port variables
  for i in 1:nPorts loop
    // fluid flow through ports
      // regular operation: fluidLevel is above ports[i]
      // Note: >= covers default values of zero as well
    ports[i].p          = medium.p;
    ports[i].h_outflow  = medium.h;
    ports[i].Xi_outflow = medium.Xi;
    ports[i].C_outflow  = C;

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

  connect(heatPort, heatTransfer.heatPorts[1]) annotation (Line(
      points={{-100,5.55112e-16},{-87,5.55112e-16},{-87,2.22045e-15},{-74,
          2.22045e-15}},
      color={191,0,0},
      smooth=Smooth.None));

 annotation (
  Documentation(info="<html>
<p>
This base class extends PartialLumpedVolume with a vector of fluid ports and a replaceable wall HeatTransfer model.
<p>
The following modeling assumption are made:
<ul>
<li>homogenous medium, i.e. phase seperation is not taken into account,</li>
<li>kinetic energy in the fluid is neglected,</li>
<li>pressure loss at vessel port is neglected,</li>
</ul>
</p>
<p>
An extending model needs to define <tt>input fluidVolume</tt>, the volume of the fluid in the vessel.
</p>
<p>
<b>Note:</b> This model is similar to 
<a href=\"Modelica://Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel\">
Modelica.Fluid.Vessels.BaseClasses.PartialLumpedVessel</a>, but it
extends 
<a href=\"Modelica://Buildings.Fluid.Interfaces.PartialLumpedVolume\">
Buildings.Fluid.Interfaces.PartialLumpedVolume</a>
instead of
<a href=\"Modelica://Modelica.Fluid.Interfaces.PartialLumpedVolume\">
Modelica.Fluid.Interfaces.PartialLumpedVolume</a>
to avoid the assert statement.
</html>", revisions="<html>
<ul>
<li><i>October 12, 2009</i> by Michael Wetter:<br>
Implemented first version in <code>Buildings</code> library,
based on <code>Modelica.Fluid 1.0</code>.
</li>
<li><i>Jan. 2009</i> by R&uuml;diger Franke: extended with
   <ul><li>portsData record and threat configurable port heights,</li>
       <li>consideration of kinetic and potential energy of fluid entering or leaving in energy balance</li>
   </ul>
</li>
<li><i>Dec. 2008</i> by R&uuml;diger Franke: derived from OpenTank, in order to make general use of configurable port diameters</i>
</ul>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}),
          graphics),
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Ellipse(
          extent={{-100,98},{100,-102}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255}),
        Text(
          extent={{-60,14},{56,-18}},
          lineColor={0,0,0},
          textString="V=%V")}));

end PartialLumpedVessel;
