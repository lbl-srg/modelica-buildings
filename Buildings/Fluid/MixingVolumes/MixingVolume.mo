within Buildings.Fluid.MixingVolumes;
model MixingVolume
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
  extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume(
    final initialize_p = not Medium.singleState,
    steBal(final use_C_flow = use_C_flow),
    dynBal(final use_C_flow = use_C_flow));

  parameter Boolean use_C_flow = false
    "Set to true to enable input connector for trace substance"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort(
    T(start=T_start)) "Heat port for heat exchange with the control volume"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_flow if use_C_flow
    "Trace substance mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

equation
  connect(heaFloSen.port_a, heatPort)
    annotation (Line(points={{-90,0},{-96,0},{-100,0}}, color={191,0,0}));
  connect(C_flow, steBal.C_flow) annotation (Line(points={{-120,-60},{-80,-60},
          {12,-60},{12,6},{18,6}}, color={0,0,127}));
  connect(C_flow, dynBal.C_flow) annotation (Line(points={{-120,-60},{-52,-60},
          {52,-60},{52,6},{58,6}}, color={0,0,127}));
  annotation (
defaultComponentName="vol",
Documentation(info="<html>
<p>
This model represents an instantaneously mixed volume.
Potential and kinetic energy at the port are neglected,
and there is no pressure drop at the ports.
The volume can exchange heat through its <code>heatPort</code>.
</p>
<p>
The volume can be parameterized as a steady-state model or as
dynamic model.</p>
<p>
To increase the numerical robustness of the model, the constant
<code>prescribedHeatFlowRate</code> can be set by the user.
This constant only has an effect if the model has exactly two fluid ports connected,
and if it is used as a steady-state model.
Use the following settings:
</p>
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if the <i>only</i> means of heat transfer
at the <code>heatPort</code> is a prescribed heat flow rate that
is <i>not</i> a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
If the <code>heatPort</code> is not connected, then set <code>prescribedHeatFlowRate=true</code> as
in this case, <code>heatPort.Q_flow=0</code>.
</li>
<li>Set <code>prescribedHeatFlowRate=false</code> if there is heat flow at the <code>heatPort</code>
computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.<br/>
If there is a combination of <i>K * (T-heatPort.T)</i> and a prescribed heat flow rate,
for example a solar collector that dissipates heat to the ambient and receives heat from
the solar radiation, then set <code>prescribedHeatFlowRate=false</code>.
</li>
</ul>
<h4>Options</h4>
<p>
The parameter <code>mSenFac</code> can be used to increase the thermal mass of this model
without increasing its volume. This way, species concentrations are still calculated
correctly even though the thermal mass increases. The additional thermal mass is calculated
based on the density and the value of the function <code>HeatCapacityCp</code>
of the medium state <code>state_default</code>. <br/>
This parameter can for instance be useful in a pipe model when the developer wants to
lump the pipe thermal mass to the fluid volume. By default <code>mSenFac = 1</code>, hence
the mass is unchanged. For higher values of <code>mSenFac</code>, the mass will be scaled proportionally.
</p>
<p>
Set the parameter <code>use_C_flow = true</code> to enable an input connector for the trace substance flow rate.
This allows to directly add or subtract trace substances such as
CO2 to the volume.
See
<a href=\"modelica://Buildings.Fluid.Sensors.Examples.PPM\">Buildings.Fluid.Sensors.Examples.PPM</a>
for an example.
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
</p>
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
<p>
For the rationale of selecting different energy and mass balances, and for the
use of <code>prescribedHeatFlowRate</code>, see the documentation of
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume</a>.
</p>
<p>
For simple models that uses this model, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a> and
<a href=\"modelica://Buildings.Fluid.Humidifiers.Humidifier_u\">
Buildings.Fluid.Humidifiers.Humidifier_u</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
October 19, 2017, by Michael Wetter:<br/>
Set <code>initialize_p</code> to <code>final</code> so that it does not
appear as a user-selectable parameter. This is done because
<code>initialize_p</code> has been changed from a <code>constant</code>
to a <code>parameter</code> for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1013\">Buildings, issue 1013</a>.
</li>
<li>
April 11, 2017, by Michael Wetter:<br/>
Changed comment of heat port, as this needs to be the total heat flow
rate in order to be able to use this model for modeling steam humidifiers
and adiabatic humidifiers.<br/>
Removed blocks <code>QSen_flow</code> and
<code>QLat_flow</code>.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
April 11, 2016 by Michael Wetter:<br/>
Corrected wrong hyperlink in documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>.
</li>
<li>
January 19, 2016, by Michael Wetter:<br/>
Updated documentation due to the addition of an input for trace substance
in the mixing volume.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">
issue 372</a>.
</li>
<li>
January 17, 2016, by Michael Wetter:<br/>
Removed <code>protected</code> block <code>masExc</code> as
this revision introduces a conditional connector for the
moisture flow rate in the energy and mass balance models.
This change was done to use the same modeling concept for the
moisture input as is used for the trace substance input.
</li>
<li>
December 2, 2015, by Filip Jorissen:<br/>
Changed code for handling trace substance insertions using input <code>C_flow</code>.
</li>
<li>
May 1, 2015 by Michael Wetter<br/>
Set <code>final</code> keyword for <code>masExc(final k=0)</code>.
This addresses
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/230\">
issue 230</a>.
</li>
<li>
February 11, 2014 by Michael Wetter:<br/>
Redesigned implementation of latent and sensible heat flow rates
as port of the correction of issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 17, 2011 by Michael Wetter:<br/>
Removed instance <code>medium</code> as this is already used in <code>dynBal</code>.
Removing the base properties led to 30% faster computing time for a solar thermal system
that contains many fluid volumes.
</li>
<li>
September 13, 2011 by Michael Wetter:<br/>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Revised model to use new declarations from
<a href=\"modelica://Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticeable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added nominal value for <code>mC</code> to avoid wrong trajectory
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br/>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
Changed base class to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
      graphics={
      Text(
          extent={{-152,100},{148,140}},
          textString="%name",
          textColor={0,0,255})}));
end MixingVolume;
