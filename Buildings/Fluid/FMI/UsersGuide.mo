within Buildings.Fluid.FMI;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
This user's guide describes the FMI package.
The FMI package has been implemented to facilitate the export
of thermofluid flow models as Functional Mockup Units (FMUs).
The goal is to export such models as FMUs so that they can be
imported in other simulators. 
The challenge is that thermofluid flow components have
acausal connectors, whereas FMUs require input and outputs
to be defined.
</p>
<p>
This package introduces connectors that can be used to wrap the
acausal models within an input/output block. It also contains
various examples in which thermofluid flow components and subsystems
are exported as FMUs.
</p>
<p>
The connectors that define the input and output signals of
the FMUs can be found in the package
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces\">
Buildings.Fluid.FMI.Interfaces</a>.
They have been designed in such a way that an FMU, if exported
with <code>allowFlowReversal=false</code> (and hence mass can only
flow from the inlet to the outlet), has as input the 
mass flow rate, pressure and fluid properties of the inflowing fluid.
At the outlet, there will be mass flow rate, outlet pressure and 
the fluid properties of the outflowing medium. This allows simulators
such as TRNSYS to evaluate the FMUs in the direction of the mass flow
by first setting all inputs, then computing the model, and then obtaining
all outputs before proceeding to the next downstream component.
</p>
<p>
Users who want to export a single fluid flow component, or a
subsystem of components, can use the container
<a href=\"modelica://Buildings.Fluid.FMI.TwoPortComponent\">
Buildings.Fluid.FMI.TwoPortComponent</a>.
The package
<a href=\"modelica://Buildings.Fluid.FMI.Examples.FMUs\">
Buildings.Fluid.FMI.Examples.FMUs</a>
has various examples in which fluid flow models or subsystems of
such models are exported as FMUs.
</p>
<p>
Note the following when exporting FMUs:
</p>
<ol>
<li>
Volumes, if configured with a dynamic balance,
cannot be exported as an FMU as they would require the derivatives
of pressure and mass flow rate as an input.
</li>
<li>
The model
<a href=\"modelica://Buildings.Fluid.FixedResistances.FlowMachine_m_flow\">
Buildings.Fluid.FixedResistances.FlowMachine_m_flow</a>
cannot be exported as an FMU.
This is because it assignes the mass flow rate.
However, the input connector
<a href=\"modelica://Buildings.Fluid.FMI.Interfaces.Inlet\">
Buildings.Fluid.FMI.Interfaces.Inlet</a>
already declares the mass flow rate as an input.
Therefore, the mass flow rate is overdetermined.
As a fall back, if a user needs to set the mass flow rate, he/she can
do so by using
<a href=\"modelica://Buildings.Fluid.FMI.IdealSource_m_flow\">
Buildings.Fluid.FMI.IdealSource_m_flow</a>,
which takes as an input signal the mass flow rate. If this differs
from the mass flow rate of the inlet connector, the simulation
will stop with an error.
</li>
<li>
The fluid flow components cannot be connected in a closed loop
because in this situation, no reference pressure would be provided.
Furthermore, circular assignments for example for the enthalpy may exist,
which can of course not be simulated.
</li>
</ul>
</html>"));
end UsersGuide;
