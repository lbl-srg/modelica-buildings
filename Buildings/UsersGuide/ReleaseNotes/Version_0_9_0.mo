within Buildings.UsersGuide.ReleaseNotes;
class Version_0_9_0 "Version 0.9.0"
  extends Modelica.Icons.ReleaseNotes;
annotation (preferredView="info", Documentation(info=
                 "<html>
<ul>
<li>
Added the following heat exchanger models
<ul>
<li>
<code>Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</code>
for a sensible heat exchanger that uses the <code>epsilon-NTU</code>
relations to compute the heat transfer.
</li>
<li>
<code>Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</code> and
<code>Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</code>
to model a coil without and with water vapor condensation. These models
approximate the coil as a counterflow heat exchanger.
</li>
</ul>
</li>
<li>
Revised air damper
<code>Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</code>.
The new implementation avoids warnings and leads to faster convergence
since the solver does not attempt anymore to solve for a variable that
needs to be strictly positive.
</li>
<li>
Revised package
<code>Buildings.Fluid.Movers</code>
to allow zero flow for some pump or fan models.
If the input to the model is the control signal <code>y</code>, then
the flow is equal to zero if <code>y=0</code>. This change required rewriting
the package to avoid division by the rotational speed.
</li>
<li>
Revised package
<code>Buildings.HeatTransfer</code>
to include a model for a multi-layer construction, and to
allow individual material layers to be computed steady-state or
transient.
</li>
<li>
In package  <code>Buildings.Fluid</code>, changed models so that
if the parameter <code>dp_nominal</code> is set to zero,
then the pressure drop equation is removed. This allows, for example,
to model a heating and a cooling coil in series, and lump there pressure drops
into a single element, thereby reducing the dimension of the nonlinear system
of equations.
</li>
<li>
Added model <code>Buildings.Controls.Continuous.LimPID</code>, which is identical to
<code>Modelica.Blocks.Continuous.LimPID</code>, except that it
allows reverse control action. This simplifies use of the controller
for cooling applications.
</li>
<li>
Added model <code>Buildings.Fluid.Actuators.Dampers.MixingBox</code> for an outside air
mixing box with air dampers.
</li>
<li>
Changed implementation of flow resistance in
<code>Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow</code>. Instead of using a
fixed resistance and a damper model in series, only one model is used
that internally adds these two resistances. This leads to smaller systems
of nonlinear equations.
</li>
<li>
Changed
<code>Buildings.Media.PerfectGases.MoistAir.T_phX</code> (and by inheritance all
other moist air medium models) to first compute <code>T</code>
in closed form assuming no saturation. Then, a check is done to determine
whether the state is in the fog region. If the state is in the fog region,
then <code>Internal.solve</code> is called. This new implementation
can lead to significantly shorter computing
time in models that frequently call <code>T_phX</code>.
</li>
<li>
Added package
<code>Buildings.Media.GasesConstantDensity</code> which contains medium models
for dry air and moist air.
The use of a constant density avoids having pressure as a state variable in mixing volumes. Hence, fast transients
introduced by a change in pressure are avoided.
The drawback is that the dimensionality of the coupled
nonlinear equation system is typically larger for flow
networks.
</li>
<li>
In
<code>Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
added default value for parameter <code>A</code> to avoid compilation error
if the parameter is disabled but not specified.
</li>
<li>
Simplified the mixing volumes in
<code>Buildings.Fluid.MixingVolumes</code> by removing the port velocity,
pressure drop and height.
</li>
</ul>
</html>"));
end Version_0_9_0;
