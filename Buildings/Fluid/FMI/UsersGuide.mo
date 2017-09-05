within Buildings.Fluid.FMI;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This user's guide describes the FMI package (Wetter et al., 2015).
The FMI package has been implemented to facilitate the export
of thermofluid flow models such as HVAC components, HVAC systems
and thermal zones as Functional Mockup Units (FMUs).
This allows to export thermofluid flow models as FMUs so that they can be
imported in other simulators.
To export thermofluid flow components, a Modelica block is needed
in order for the model to only have input and output signals
rather than fluid connectors, as fluid connectors do not impose any causality
on the signal flow.
This package implements such blocks and its connectors.
</p>
<p>
The main packages are as follows:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
  <th>Package</th><th>Description</th>
</tr>
<tr>
  <td>
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers\">
  Buildings.Fluid.FMI.ExportContainers</a>
  </td>
  <td>
  <p>
  Package with blocks to export thermofluid flow components and systems.
  </p>
  <p>
  To export an HVAC component or system with a single inlet and outlet port, instantiate
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ReplaceableTwoPort\">
  Buildings.Fluid.FMI.ExportContainers.ReplaceableTwoPort</a>
  with a replaceable model,
  or extend from
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.PartialTwoPort\">
  Buildings.Fluid.FMI.ExportContainers.PartialTwoPort</a>
  and add components.<br/>
  See
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.Fan\">
  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.Fan</a>
  and
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume\">
  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume</a>.
  </p>
  <p>
  To export an HVAC system that serves a single thermal zone, extend from
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACZone\">
  Buildings.Fluid.FMI.ExportContainers.HVACZone</a>
  and add the HVAC system.<br/>
  See
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone\">
  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone</a>.
  </p>
  <p>
  To export an HVAC system that serves multiple thermal zones, extend from
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACZones\">
  Buildings.Fluid.FMI.ExportContainers.HVACZones</a>
  and add the HVAC system.<br/>
  See
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones\">
  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones</a>.
  </p>
  <p>
  To export a single thermal zone, extend from
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZone\">
  Buildings.Fluid.FMI.ExportContainers.ThermalZone</a>
  and add the thermal zone.<br/>
  See
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone\">
  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone</a>.
  </p>
  <p>
  To export multiple thermal zones, extend from
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZones\">
  Buildings.Fluid.FMI.ExportContainers.ThermalZones</a>
  and add the thermal zone models.<br/>
  See
  <a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZones\">
  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZones</a>.
  </p>
  </td>
</tr>
<tr>
  <td>
  <a href=\"modelica://Buildings.Fluid.FMI.Adaptors\">
  Buildings.Fluid.FMI.Adaptors</a>
  </td>
  <td>
  <p>
  Package with adaptors to connect models with fluid ports to blocks that
  have input and output signals.
  </p>
</td>
</tr>
<tr>
<td>
  <p>
  <a href=\"modelica://Buildings.Fluid.FMI.Conversion\">
  Buildings.Fluid.FMI.Conversion</a>
  </p>
</td>
<td>
  <p>
  Package with blocks that convert between the signal connectors of
  <a href=\"modelica://Buildings.Fluid.FMI.Interfaces\">
  Buildings.Fluid.FMI.Interfaces</a>
  and the real input and output signal connectors of the Modelica Standard Library.
  </p>
</td>
</tr>
<tr>
<td>
  <a href=\"modelica://Buildings.Fluid.FMI.Interfaces\">
  Buildings.Fluid.FMI.Interfaces</a>
</td>
<td>
  <p>
  Package with composite connectors that have different input and output
  signals. These connectors are used to export FMUs, and they contain
  quantities such as mass flow rate, temperature, optional pressure, etc.
  </p>
</td>
</tr>
</table>
<p>
The package
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs</a>
contains various examples in which HVAC components, HVAC systems
and thermal zones are exported as an FMU.
</p>
<h4>Typical use</h4>
<p>
Users who want to export a single thermofluid flow component, or a
subsystem of thermofluid flow components, can use the block
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ReplaceableTwoPort\">
Buildings.Fluid.FMI.ExportContainers.ReplaceableTwoPort</a>.
This block has a fluid inlet, a fluid outlet, and a replaceable
component that can be replaced with an HVAC component or system that
has an inlet and outlet fluid port.
</p>
<p>
Users who want to export a whole HVAC system that serves a single thermal zone
can do so by extending the partial block
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACZone\">
Buildings.Fluid.FMI.ExportContainers.HVACZone</a>.
The example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZone</a>
illustrates how this can be accomplished.<br/>
Similar export containers and examples are implemented for HVAC systems that serve multiple thermal zones.
</p>
<p>
Conversely, to export a thermal zone, users can extend the partial block
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZone\">
Buildings.Fluid.FMI.ExportContainers.ThermalZone</a>.
The example
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone</a>
illustrates how this can be accomplished.<br/>
Similar export containers and examples are implemented for models of multiple thermal zones.
</p>
<p>
Each example and validation model has a Dymola script that
either simulates the model, or exports the model as an FMU.
The script can be invoked from the pull
down menu <code>Commands -&gt; Export FMU</code>.
</p>
<h4>Options</h4>
<p>
In the
<a href=\"modelica://Buildings.Fluid\">Buildings.Fluid</a> package,
most models have a boolean parameter called <code>allowFlowReversal</code>.
If set to <code>true</code>, then the flow can be in either direction,
otherwise it needs to be from the inlet to the outlet port.
This parameter is also used in the
<a href=\"modelica://Buildings.Fluid.FMI\">Buildings.Fluid.FMI</a> package.
The package was designed in such a way that an FMU,
if exported with <code>allowFlowReversal=false</code>
has as input the mass flow rate,
pressure and fluid properties of the inflowing fluid. The outputs
are the outlet mass flow rate, outlet pressure and the fluid
properties of the outflowing medium. This allows simulators
such as Ptolemy II
to evaluate the FMUs in the direction of the mass flow by first
setting all inputs, then evaluating the model equations,
and finally retrieving the
outputs before proceeding the simulation with the next downstream
component.
If <code>allowFlowReversal=true</code>, then the connectors have additional
signals for the properties of the fluid if it flows backwards.
</p>
<p>
Most components have a boolean parameter <code>use_p_in</code>.
If <code>use_p_in=true</code>, then the pressure is used from the
connector, and based on the mass flow rate, the outlet pressure
is computed and assigned to the outlet connectors.
If <code>use_p_in=false</code>, then the pressure as declared
by the constant <code>p_default</code> of the medium model is
used, and the component computes no pressure drop.
Setting <code>use_p_in=false</code> therefore leads to fewer
equations, but it requires a component that specifies the mass
flow rate, such as
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.IdealSource_m_flow\">
Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.IdealSource_m_flow</a>.
</p>
<h4>Notes</h4>
<p>
Note the following when exporting HVAC component models as an FMU:
</p>
<ol>
<li>
<p>
For models with control volumes,
the mass balance must be configured using
<code>massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState</code>
when used with the media
<a href=\"modelica://Buildings.Media.Air\">
Buildings.Media.Air</a>.
Otherwise, the translation stops with the error
</p>
<pre>
The model requires derivatives of some inputs as listed below:
1 inlet.p
</pre>
<p>
The reason is that for
<a href=\"modelica://Buildings.Media.Air\">
Buildings.Media.Air</a>,
mass is proportional to pressure and pressure is proportional
to density. Hence, <i>dm/dt</i> requires <i>dp/dt</i>,
but the time derivative of the pressure is not an input to the model.
</p>
<p>
For <a href=\"modelica://Buildings.Media.Water\">
Buildings.Media.Water</a>, this setting is not needed
as the mass is independent of pressure.
</p>
</li>
<li>
<p>
The model
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
cannot be exported as an FMU.
This is because it assignes the mass flow rate.
However, the input connector
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Inlet\">
Buildings.Fluid.FMI.Interfaces.Inlet</a>
already declares the mass flow rate as an input.
Therefore, the mass flow rate is overdetermined.
As a fall back, if a user needs to set the mass flow rate, he/she can
do so by using
<a href=\"modelica://Buildings.Fluid.FMI.Source_T\">
Buildings.Fluid.FMI.Source_T</a>,
which takes as an input signal the mass flow rate.
</p>
</li>
</ol>
<p>
When connecting fluid flow components in a loop,
be careful to avoid circular assignments for example for the temperature,
as these can of course not be simulated.
An example of such an ill-posed problem is to connect the outlet of
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>
to its inlet. In this situation, neither pressure, nor mass flow rate or temperature
can be computed. To model such loops, a control volume with a dynamic energy
balance must be presented, and the medium needs to be compressible.
</p>
<h4>References</h4>
<p>
Michael Wetter, Marcus Fuchs and Thierry Stephane Nouidui.<br/>
<a href=\"modelica://Buildings/Resources/Images/Fluid/FMI/UsersGuide/2015-WetterFuchsNouidui.pdf\">
Design choices for thermofluid flow components and systems that are exported as Functional Mockup Units</a>.<br/>
<i>Proc. of the 11th International Modelica Conference</i>,
   p. 31-41,
   Versailles, France, September 2015.
</p>
</html>"));
end UsersGuide;
