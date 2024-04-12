within Buildings.UsersGuide.ReleaseNotes;
class Version_0_8_0 "Version 0.8.0"
  extends Modelica.Icons.ReleaseNotes;
            annotation (preferredView="info", Documentation(info=
                 "<html>
<ul>
<li>
In
<code>Buildings.Fluid.Interfaces.ConservationEquation</code>,
added to <code>Medium.BaseProperties</code> the initialization
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li>
Renamed <code>Buildings.Media.PerfectGases.MoistAirNonSaturated</code>
to <code>Buildings.Media.PerfectGases.MoistAirUnsaturated</code>
and <code>Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid</code>
to
<code>Buildings.Media.Air</code>,
and added <code>assert</code> statements if saturation occurs.
</li>
<li>
Added regularizaation near zero flow to
<code>Buildings.Fluid.HeatExchangers.ConstantEffectiveness</code>
and
<code>Buildings.Fluid.MassExchangers.ConstantEffectiveness</code>.
</li>
<li>
Fixed bug regarding temperature offset in
<code>Buildings.Media.PerfectGases.MoistAirUnsaturated.T_phX</code>.
</li>
<li>
Added implementation of function
<code>Buildings.Media.Air.enthalpyOfNonCondensingGas</code> and its derivative.
</li>
<li>
In <code>Buildings.Media.PerfectGases.MoistAir</code>, fixed
bug in implementation of <code>Buildings.Media.PerfectGases.MoistAir.T_phX</code>.
In the previous version, it computed the inverse of its parent class,
which gave slightly different results.
</li>
<li>
In <code>Buildings.Utilities.IO.BCVTB.BCVTB</code>, added parameter to specify
the value to be sent to the BCVTB at the first data exchange,
and added parameter that deactivates the interface. Deactivating
the interface is sometimes useful during debugging.
</li>
<li>
In <code>Buildings.Media.GasesPTDecoupled.MoistAir</code> and in
<code>Buildings.Media.PerfectGases.MoistAir</code>, added function
<code>enthalpyOfNonCondensingGas</code> and its derivative.
</li>
<li>
In <code>Buildings.Media</code>,
fixed bug in implementations of derivatives.
</li>
<li>
Added model
<code>Buildings.Fluid.Storage.ExpansionVessel</code>.
</li>
<li>
Added Wrapper function <code>Buildings.Fluid.Movers.BaseClasses.Characteristics.solve</code>
for <code>Modelica.Math.Matrices.solve</code>. This is currently needed since
<code>Modelica.Math.Matrices.solve</code> does not specify a
derivative.
</li>
<li>
Fixed bug in
<code>Buildings.Fluid.Storage.Stratified</code>.
In the previous version,
for computing the heat conduction between the top (or bottom) segment and
the outside,
the whole thickness of the water volume was used
instead of only half the thickness.
</li>
<li>
In <code>Buildings.Media.ConstantPropertyLiquidWater</code>, added the option to specify
a compressibility. This can help reducing the size of the coupled nonlinear system of
equations, at the expense of introducing stiffness. This change required to change
the inheritance tree of the medium. Its base class is now
<code>Buildings.Media.Interfaces.PartialSimpleMedium</code>,
which contains the equation for the compressibility. The default setting will model
the flow as incompressible.
</li>
<li>
In <code>Buildings.Controls.Continuous.Examples.PIDHysteresis</code>
and <code>Buildings.Controls.Continuous.Examples.PIDHysteresisTimer</code>,
fixed error in default parameter <code>eOn</code>.
Fixed error by introducing parameter <code>Td</code>,
which used to be hard-wired in the PID controller.
</li>
<li>
Added more models for fans and pumps to the package
<code>Buildings.Fluid.Movers</code>.
The models are similar to the ones in
<code>Modelica.Fluid.Machines</code> but have been adapted for
air-based systems, and to include more characteristic curves
in
<code>Buildings.Fluid.Movers.BaseClasses.Characteristics</code>.
The new models are better suited than the existing fan model
<code>Buildings.Fluid.Movers.FlowMachinePolynomial</code> for zero flow rate.
</li>
<li>
Added an optional mixing volume to <code>Buildings.Fluid.BaseClasses.PartialThreeWayResistance</code>
and hence to the flow splitter and to the three-way valves. This often breaks algebraic loops and provides a state for the temperature if the mass flow rate goes to zero.
</li>
</ul>
</html>"));
end Version_0_8_0;
