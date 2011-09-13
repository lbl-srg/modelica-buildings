within Buildings.Fluid.MixingVolumes;
model MixingVolume
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
  outer Modelica.Fluid.System system "System properties";
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  // Port definitions
  parameter Integer nPorts=0 "Number of ports"
    annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
  parameter Medium.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean allowFlowReversal = system.allowFlowReversal
    "= true to allow flow reversal in medium, false restricts to design direction (ports[1] -> ports[2]). Used only if model has two ports."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Modelica.SIunits.Volume V "Volume";
  parameter Boolean prescribedHeatFlowRate=false
    "Set to true if the model has a prescribed heat flow at its heatPort"
   annotation(Evaluate=true, Dialog(tab="Assumptions",
      enable=use_HeatTransfer,
      group="Heat transfer"));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-40,-10},{40,10}},
      origin={0,-100})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port connected to outflowing medium"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  // Set nominal attributes where literal values can be used.
  // The parameter preferredMediumStates is only set to true for the dynamic balances.
  // Otherwise, Dymola 2012 may differentiate the steady-state model in order to obtain
  // temperature as a state, because the medium BaseProperties declare
  // T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)
  // See Dynasim #13596
  Medium.BaseProperties medium(
    preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState),
    p(start=p_start, nominal=Medium.p_default),
    h(start=Medium.specificEnthalpy_pTX(p_start, T_start, X_start)),
    T(start=T_start, nominal=Medium.T_default),
    Xi(start=X_start[1:Medium.nXi], nominal=Medium.X_default[1:Medium.nXi]),
    d(start=rho_nominal)) "Medium properties";

  Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
    "Trace substance mixture content";
   // Models for the steady-state and dynamic energy balance.
// fixme: Make protected for release.
// Here, it is public for access to parameter use_safeDivision
   Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger steBal(
    sensibleOnly = true,
    redeclare final package Medium=Medium,
    final m_flow_nominal = m_flow_nominal,
    final dp_nominal = 0,
    final allowFlowReversal = allowFlowReversal,
    final m_flow_small = m_flow_small,
    final homotopyInitialization = homotopyInitialization,
    final show_V_flow = false,
    final from_dp = false,
    final linearizeFlowResistance = true,
    final deltaM = 0.3,
    Q_flow = Q_flow,
    mXi_flow = zeros(Medium.nXi)) if
        useSteadyStateTwoPort "Model for steady-state balance if nPorts=2";
  Buildings.Fluid.Interfaces.LumpedVolume dynBal(
    redeclare final package Medium = Medium,
    final nPorts = nPorts,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final fluidVolume = V,
    m(start=V*rho_nominal),
    U(start=V*rho_nominal*Medium.specificInternalEnergy(
        state_start)),
    Q_flow = Q_flow,
    mXi_flow = zeros(Medium.nXi)) if
        not useSteadyStateTwoPort "Model for dynamic energy balance";
protected
   parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
      T=T_start,
      p=p_start,
      X=X_start[1:Medium.nXi]) "Start state";
  parameter Modelica.SIunits.Density rho_nominal=Medium.density(
   Medium.setState_pTX(
     T=T_start,
     p=p_start,
     X=X_start[1:Medium.nXi])) "Density, used to compute fluid mass"
  annotation (Evaluate=true);
  ////////////////////////////////////////////////////
  final parameter Boolean useSteadyStateTwoPort=(nPorts == 2) and
      prescribedHeatFlowRate and (
      energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
      massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
      substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
      traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flag, true if the model has two ports only and uses a steady state balance"
    annotation (Evaluate=true);
  Modelica.SIunits.HeatFlowRate Q_flow
    "Heat flow across boundaries or energy source/sink";
  // Outputs that are needed to assign the medium properties
  Modelica.Blocks.Interfaces.RealOutput hOut_internal(unit="J/kg")
    "Internal connector for leaving temperature of the component";
  Modelica.Blocks.Interfaces.RealOutput XiOut_internal[Medium.nXi](unit="1")
    "Internal connector for leaving species concentration of the component";
  Modelica.Blocks.Interfaces.RealOutput COut_internal[Medium.nC](unit="1")
    "Internal connector for leaving trace substances of the component";
equation
  ///////////////////////////////////////////////////////////////////////////
  // asserts
  if not allowFlowReversal then
    assert(ports[1].m_flow > -m_flow_small,
"Model has flow reversal, but the parameter allowFlowReversal is set to false.
  m_flow_small    = " + String(m_flow_small) + "
  ports[1].m_flow = " + String(ports[1].m_flow) + "
");
  end if;
// Only one connection allowed to a port to avoid unwanted ideal mixing
  if not useSteadyStateTwoPort then
    for i in 1:nPorts loop
    assert(cardinality(ports[i]) == 2 or cardinality(ports[i]) == 0,"
each ports[i] of volume can at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");
     end for;
  end if;
  // actual definition of port variables
  // If the model computes the energy and mass balances as steady-state,
  // and if it has only two ports,
  // then we use the same base class as for all other steady state models.
  if useSteadyStateTwoPort then
    connect(ports[1], steBal.port_a);
    connect(ports[2], steBal.port_b);
    connect(hOut_internal,  steBal.hOut);
    connect(XiOut_internal, steBal.XiOut);
    connect(COut_internal,  steBal.COut);
  else
    connect(ports, dynBal.ports);
    connect(hOut_internal,  dynBal.hOut);
    connect(XiOut_internal, dynBal.XiOut);
    connect(COut_internal,  dynBal.COut);
  end if;
  // Medium properties
  medium.p = if nPorts > 0 then ports[1].p else p_start;
  hOut_internal  = medium.h;
  XiOut_internal = medium.Xi;
  COut_internal = C;
  heatPort.T = medium.T;
  heatPort.Q_flow = Q_flow;
  annotation (
defaultComponentName="vol",
Documentation(info="<html>
This model represents an instantaneously mixed volume. 
Potential and kinetic energy at the port are neglected,
and there is no pressure drop at the ports.
The volume can exchange heat through its <code>heatPort</code>.
</p>
<p>
The volume can be parameterized as a steady-state model or as
dynamic model.
</p>
<p>
To increase the numerical robustness of the model, the parameter
<code>prescribedHeatFlowRate</code> can be set by the user. 
This parameter only has an effect if the model has exactly two fluid ports connected,
and if it is used as a steady-state model.
Use the following settings:
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if there is a model connected to <code>heatPort</code>
that computes the heat flow rate <i>not</i> as a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
</li>
<li>Set <code>prescribedHeatFlowRate=true</code> if the only means of heat flow at the <code>heatPort</code>
is computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.
</li>
</ul>
</p>
<h4>Implementation</h4>
<p>
If the model is operated in steady-state and has two fluid ports connected,
then the same energy and mass balance implementation is used as in
steady-state component models, i.e., the use of <code>actualStream</code>
is not used for the properties at the port.
</p>
<p>
The implementation of these balance equations is done in the instances
<code>dynBal</code> for the dynamic balance and <code>steBal</code>
for the steady-state balance. Both models use the same input variables:
<ul>
<li>
The variable <code>Q_flow</code> is used to add sensible <i>and</i> latent heat to the fluid.
For example, <code>Q_flow</code> participates in the steady-state energy balance<pre>
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
</pre>
where <code>m_flowInv</code> approximates the expression <code>1/m_flow</code>.
</li>
<li>
The variable <code>mXi_flow</code> is used to add a species mass flow rate to the fluid.
</li>
</ul>
</p>
<p>
For simple models that uses this model, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</a> and
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2011 by Michael Wetter:<br>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br>
Revised model to use new declarations from
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if 
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
This implementation also simplifies the implementation of 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</a>,
which now uses the same equations as this model.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br>
Changed base class to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
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
          textString="V=%V"),         Text(
          extent={{-152,100},{148,140}},
          textString="%name",
          lineColor={0,0,255})}));
end MixingVolume;
