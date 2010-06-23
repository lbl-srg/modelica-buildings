within ;
package Buildings "Library with models for building energy and control systems"


package UsersGuide "User's Guide"

  class Conventions "Conventions"

    annotation (Documentation(info="<html>
This library follows the conventions of the 
<a href=\"modelica://Modelica.UsersGuide.Conventions\">Modelica Standard Library</a>.
</p>
<p>
The nomenclature used in the package
<a href=\"modelica://Buildings.Utilities.Psychrometrics\">
Buildings.Utilities.Psychrometrics</a>
 is as follows, 
<ul>
<li>
Uppercase <code>X</code> denotes mass fraction per total mass.
</li>
<li>
Lowercase <code>x</code> denotes mass fraction per mass of dry air.
</li>
<li>
The notation <code>z_xy</code> denotes that the function or block has output
<code>z</code> and inputs <code>x</code> and <code>y</code>.
</li>
<li>
The symbol <code>pW</code> denotes water vapor pressure, <code>Tdp</code> 
denotes dew point temperature, <code>Twb</code> denotes wet bulb temperature,
and <code>Tdb</code> (or simply <code>T</code>) denotes dry bulb temperature.
</li>
</ul>
</html>
"));
  end Conventions;

  package ReleaseNotes "Release notes"

  class Version_0_9_1 "Version 0.9.1"

  annotation (Documentation(info="<html>
The following <b style=\"color:red\">critical error</b> has been fixed (i.e. error
that can lead to wrong simulation results):
</p>
<p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>Buildings.Fluid.Storage.</b></td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.Stratifier\">
  Buildings.Fluid.Storage.BaseClasses.Stratifier</a></td>
      <td valign=\"top\">The model had a sign error that lead to a wrong energy balance.
      The model that was affected by this error is
      <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
      Buildings.Fluid.Storage.StratifiedEnhanced</a>.
      The model 
      <a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
      Buildings.Fluid.Storage.Stratified</a> was not affected.
      
      </td>
  </tr>
</table>
</html>
"));
  end Version_0_9_1;

  class Version_0_9_0 "Version 0.9.0"

  annotation (Documentation(info="<html>
<ul>
<li>
Added the following heat exchanger models
<ul>
<li> 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</a>
for a sensible heat exchanger that uses the <code>epsilon-NTU</code>
relations to compute the heat transfer.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>
to model a coil without and with water vapor condensation. These models
approximate the coil as a counterflow heat exchanger.
</li>
</ul>
<li>
Revised air damper 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>.
The new implementation avoids warnings and leads to faster convergence
since the solver does not attempt anymore to solve for a variable that
needs to be strictly positive.
</li>
<li>
Revised package
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a>
to allow zero flow for some pump or fan models.
If the input to the model is the control signal <code>y</code>, then
the flow is equal to zero if <code>y=0</code>. This change required rewriting
the package to avoid division by the rotational speed.
</li>
<li>
Revised package
<a href=\"modelica://Buildings.HeatTransfer\">
Buildings.HeatTransfer</a>
to include a model for a multi-layer construction, and to
allow individual material layers to be computed steady-state or
transient.
</li>
<li>
In package  <a href=\"modelica://Buildings.Fluid\">
Buildings.Fluid</a>, changed models so that
if the parameter <code>dp_nominal</code> is set to zero,
then the pressure drop equation is removed. This allows, for example, 
to model a heating and a cooling coil in series, and lump there pressure drops
into a single element, thereby reducing the dimension of the nonlinear system
of equations.
</li>
<li>
Added model <a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>, which is identical to 
<a href=\"Modelica:Modelica.Blocks.Continuous.LimPID\">
Modelica.Blocks.Continuous.LimPID</a>, except that it 
allows reverse control action. This simplifies use of the controller
for cooling applications.
</li>
<li>
Added model <a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBox\">
Buildings.Fluid.Actuators.Dampers.MixingBox</a> for an outside air
mixing box with air dampers.
</li>
<li>
Changed implementation of flow resistance in
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow\">
Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow</a>. Instead of using a
fixed resistance and a damper model in series, only one model is used
that internally adds these two resistances. This leads to smaller systems
of nonlinear equations.
</li>
<li>
Changed 
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAir.T_phX\">
Buildings.Media.PerfectGases.MoistAir.T_phX</a> (and by inheritance all
other moist air medium models) to first compute <code>T</code> 
in closed form assuming no saturation. Then, a check is done to determine
whether the state is in the fog region. If the state is in the fog region,
then <code>Internal.solve</code> is called. This new implementation
can lead to significantly shorter computing
time in models that frequently call <code>T_phX</code>.
<li>
Added package
<a href=\"modelica://Buildings.Media.GasesConstantDensity\">
Buildings.Media.GasesConstantDensity</a> which contains medium models
for dry air and moist air.
The use of a constant density avoids having pressure as a state variable in mixing volumes. Hence, fast transients
introduced by a change in pressure are avoided. 
The drawback is that the dimensionality of the coupled
nonlinear equation system is typically larger for flow
networks.
</li>
<li>
In 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</a>,
added default value for parameter <code>A</code> to avoid compilation error
if the parameter is disabled but not specified.
</li>
<li>
Simplified the mixing volumes in 
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a> by removing the port velocity, 
pressure drop and height.
</li>
</ul>
</p>
</html>
"));
  end Version_0_9_0;

  class Version_0_8_0 "Version 0.8.0"

              annotation (Documentation(info="<html>
<ul>
<li>
In 
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialLumpedVolume\">
Buildings.Fluid.Interfaces.PartialLumpedVolume</a>,
added to <code>Medium.BaseProperties</code> the initialization 
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li>
Renamed <code>Buildings.Media.PerfectGases.MoistAirNonSaturated</code>
to 
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAirUnsaturated\">
Buildings.Media.PerfectGases.MoistAirUnsaturated</a>
and <code>Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid</code>
to 
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated\">
Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated</a>,
and added <code>assert</code> statements if saturation occurs.
</li>
<li>
Added regularizaation near zero flow to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
and
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>.
</li>
<li>
Fixed bug regarding temperature offset in 
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAirUnsaturated.T_phX\">
Buildings.Media.PerfectGases.MoistAirUnsaturated.T_phX</a>.
</li>
<li>
Added implementation of function
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas\">
Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas</a> and its derivative.
</li>
<li>
In <a href=\"modelica://Buildings.Media.PerfectGases.MoistAir\">
Buildings.Media.PerfectGases.MoistAir</a>, fixed
bug in implementation of <a href=\"modelica://Buildings.Media.PerfectGases.MoistAir.T_phX\">
Buildings.Media.PerfectGases.MoistAir.T_phX</a>. In the 
previous version, it computed the inverse of its parent class,
which gave slightly different results.
</li>
<li>
In <a href=\"modelica://Buildings.Utilities.IO.BCVTB.BCVTB\">
Buildings.Utilities.IO.BCVTB.BCVTB</a>, added parameter to specify
the value to be sent to the BCVTB at the first data exchange,
and added parameter that deactivates the interface. Deactivating 
the interface is sometimes useful during debugging. 
</li>
<li>
In <a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAir\">
Buildings.Media.GasesPTDecoupled.MoistAir</a> and in
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAir\">
Buildings.Media.PerfectGases.MoistAir</a>, added function
<tt>enthalpyOfNonCondensingGas</tt> and its derivative.
<li>
In <a href=\"modelica://Buildings.Media\">
Buildings.Media</a>, 
fixed bug in implementations of derivatives.
</li>
<li>
Added model 
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
</li>
<li>
Added Wrapper function <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.solve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.solve</a> for 
<a href=\"Modelica:Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a>. This is currently needed since 
<a href=\"Modelica:Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a> does not specify a 
derivative.
</li>
<li>
Fixed bug in 
<a href=\"Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a>. 
In the previous version, 
for computing the heat conduction between the top (or bottom) segment and
the outside, 
the whole thickness of the water volume was used
instead of only half the thickness.
<li>
In <a href=\"Buildings.Media.ConstantPropertyLiquidWater\">
Buildings.Media.ConstantPropertyLiquidWater</a>, added the option to specify a compressibility.
This can help reducing the size of the coupled nonlinear system of equations, at
the expense of introducing stiffness. This change required to change the inheritance 
tree of the medium. Its base class is now
<a href=\"Buildings.Media.Interfaces.PartialSimpleMedium\">
Buildings.Media.Interfaces.PartialSimpleMedium</a>,
which contains the equation for the compressibility. The default setting will model 
the flow as incompressible.
</li>
<li>
In <a href=\"modelica://Buildings.Controls.Continuous.Examples.PIDHysteresis\">
Buildings.Controls.Continuous.Examples.PIDHysteresis</a>
and <a href=\"modelica://Buildings.Controls.Continuous.Examples.PIDHysteresisTimer\">
Buildings.Controls.Continuous.Examples.PIDHysteresisTimer</a>,
fixed error in default parameter <code>eOn</code>.
Fixed error by introducing parameter <code>Td</code>, 
which used to be hard-wired in the PID controller.
</li>
<li>
Added more models for fans and pumps to the package 
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a>.
The models are similar to the ones in
<a href=\"modelica://Modelica.Fluid.Machines\">
Modelica.Fluid.Machines</a> but have been adapted for 
air-based systems, and to include more characteristic curves
in 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
The new models are better suited than the existing fan model
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachinePolynomial\">
Buildings.Fluid.Movers.FlowMachinePolynomial</a> for zero flow rate.
</li>
<li>
Added an optional mixing volume to <a href=\"modelica://Buildings.Fluid.BaseClasses.PartialThreeWayResistance\">
Buildings.Fluid.BaseClasses.PartialThreeWayResistance</a>
and hence to the flow splitter and to the three-way valves. This often breaks algebraic loops and provides a state for the temperature if the mass flow rate goes to zero.
</li>
</ul>
</p>
</html>
"));
  end Version_0_8_0;

    class Version_0_7_0 "Version 0.7.0"

              annotation (Documentation(info="<html>
<ul>
<li>
Updated library from Modelica_Fluid to Modelica.Fluid 1.0
<li>
Merged sensor and source models from Modelica.Fluid to Buildings.Fluid.
</li>
<li> Added sensor for sensible and latent enthalpy flow rate,
<a href=\"modelica://Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate\">
Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate</a> and
<a href=\"modelica://Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
These sensors are needed, for example, to interface air-conditioning
systems that are modeled with Modelica with the Building Controls
Virtual Test Bed.
</li>
</ul>
</p>
</html>
"));
    end Version_0_7_0;

  class Version_0_6_0 "Version 0.6.0"

      annotation (Documentation(info="<html>
<ul>
<li>
Added the package
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">
Buildings.Utilities.IO.BCVTB</a>
which contains an interface to the 
<a href=\"https://gaia.lbl.gov/bcvtb\">Building Controls Virtual Test Bed.</a>
<li> 
Updated license to Modelica License 2.
<li>
Replaced 
<a href=\"modelica://Buildings.Utilities.Psychrometrics.HumidityRatioPressure.mo\">
Buildings.Utilities.Psychrometrics.HumidityRatioPressure.mo</a>
by
<a href=\"modelica://Buildings.Utilities.Psychrometrics.HumidityRatio_pWat.mo\">
Buildings.Utilities.Psychrometrics.HumidityRatio_pWat.mo</a>
and
<a href=\"modelica://Buildings.Utilities.Psychrometrics.VaporPressure_X.mo\">
Buildings.Utilities.Psychrometrics.VaporPressure_X.mo</a>
because the old model used <tt>RealInput</tt> ports, which are obsolete
in Modelica 3.0.
</li>
<li>
Changed the base class 
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer\">
Buildings.Fluid.Interfaces.PartialStaticTwoPortHeatMassTransfer</a>
to enable computation of pressure drop of mechanical equipment.
</li>
<li>
Introduced package
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels\">
Buildings.Fluid.BaseClasses.FlowModels</a> to model pressure drop,
and rewrote 
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\">
Buildings.Fluid.BaseClasses.PartialResistance</a>.
</li>
<li>
Redesigned package
<a href=\"modelica://Buildings.Utilities.Math\">
Buildings.Utilities.Math</a> to allow having blocks and functions
with the same name. Functions are now in 
<a href=\"modelica://Buildings.Utilities.Math.Functions\">
Buildings.Utilities.Math.Functions</a>.
</li>
<li>
Fixed sign error in
<a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.Stratifier\">
Buildings.Fluid.Storage.BaseClasses.Stratifier</a>
which caused a wrong energy balance in
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</li>
<li>
Renamed 
<tt>Buildings.Fluid.HeatExchangers.HeaterCoolerIdeal</tt> to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</a>
to have the same nomenclatures as is used for
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>
</li>
<li>
In 
<a href=\"modelica://Buildings.Fluid/Actuators/BaseClasses/PartialDamperExponential\">
Buildings.Fluid/Actuators/BaseClasses/PartialDamperExponential</a>,
added option to compute linearization near zero based on 
the fraction of nominal flow instead of the Reynolds number.
This was set as the default, as it leads most reliably to a model 
parametrization that leads to a derivative <tt>d m_flow/d p</tt> 
near the origin that is not too steep for a Newton-based solver.
</li>
<li>
In damper and VAV box models, added optional parameters
to allow specifying the nominal face velocity instead of the area.
</li>
<li>
Set nominal attribute for pressure drop <tt>dp</tt> in 
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\"</a>
Buildings.Fluid.BaseClasses.PartialResistance</a> and in its
child classes.
</li>
<li>
Added models for chiller
(<a href=\"modelica://Buildings.Fluid.Chillers.Carnot\">
Buildings.Fluid.Chillers.Carnot</a>),
for occupancy
(<a href=\"modelica://Buildings.Controls.SetPoints.OccupancySchedule\">
Buildings.Controls.SetPoints.OccupancySchedule</a>) and for
blocks that take a vector as an argument
(<a href=\"modelica://Buildings.Utilities.Math.Min\">
Buildings.Utilities.Math.Min</a>,
<a href=\"modelica://Buildings.Utilities.Math.Max\">
Buildings.Utilities.Math.Max</a>, and
<a href=\"modelica://Buildings.Utilities.Math.Average\">
Buildings.Utilities.Math.Average</a>).
</li>
<li>
Changed various variable names to be consistent with naming
convention used in Modelica.Fluid 1.0.
</li>
</ul>
</p>
</html>
"));
  end Version_0_6_0;

  class Version_0_5_0 "Version 0.5.0"

      annotation (Documentation(info="<html>
<ul>
<li>
Updated library to Modelica.Fluid 1.0.
</li>
<li>
Moved most examples from package <a href=\"modelica://Buildings.Fluid.Examples\">
Buildings.Fluid.Examples</a> to the example directory in the package of the
individual model.
</li>
<li>
Renamed package <a href=\"modelica://Buildings.Utilites.Controls\">
Buildings.Utilites.Controls</a> to 
<a href=\"modelica://Buildings.Utilites.Diagnostics\">
Buildings.Utilites.Diagnostics</a>.
</li>
<li>
Introduced packages 
<a href=\"modelica://Buildings.Controls\">Buildings.Controls</a>,
<a href=\"modelica://Buildings.HeatTransfer\">Buildings.HeatTransfer</a>
(which contains models for heat transfer that generally does not involve 
modeling of the fluid flow),
<a href=\"modelica://Buildings.Fluid.Boilers\">Buildings.Fluid.Boilers</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators\">
Buildings.Fluid.HeatExchangers.Radiators</a>.
</li>
<li>
Changed valve models in <a href=\"modelica://Buildings.Fluid.Actuators.Valves\">
Buildings.Fluid.Actuators.Valves</a> so that <tt>Kv</tt> or <tt>Cv</tt> can
be used as the flow coefficient (in [m3/h] or [USG/min]).
</li>
</ul>
</p>
</html>
"));
  end Version_0_5_0;

  class Version_0_4_0 "Version 0.4.0"

      annotation (Documentation(info="<html>
<ul>
<li>
Added package <a href=\"modelica://Buildings.Fluid.Storage\">
Buildings.Fluid.Storage</a>
with models for thermal energy storage.
<li>
Added a steady-state model for a heat and moisture exchanger with
constant effectiveness. 
See <a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>
<li>
Added package <a href=\"modelica://Buildings.Utilities.Reports\">Buildings.Utilities.Reports</a>.
The package contains models that facilitate reporting.
</li>
</ul>
</p>
</html>
"));
  end Version_0_4_0;

  class Version_0_3_0 "Version 0.3.0"

      annotation (Documentation(info="<html>
<ul>
<li>
Added package <a href=\"modelica://Buildings.Fluid.Sources\">Buildings.Fluid.Sources</a>.
The package contains models for modeling species that
do not affect the medium balance of volumes. This can be used to track
for example carbon dioxide or other species that have a small concentration.
</li>
<li>
The package <a href=\"modelica://Buildings.Fluid.Actuators.Motors\">Buildings.Fluid.Actuators.Motors</a> has been added.
The package contains a motor model for valves and dampers.
</li>
<li>
The package <a href=\"modelica://Buildings.Media\">Buildings.Media</a> has been reorganized and
the new medium model 
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAir\">
Buildings.Media.GasesPTDecoupled.MoistAir</a>
has been added.
<br>
In addition, this package now contains a bug fix that is needed for Modelica 2.2.1 and 2.2.2.
The bugs are fixed by using a new
base class
<a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleIdealGasMedium\">
Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</a>
 (that fixes the bugs) instead of
<a href=\"Modelica:Modelica.Media.Interfaces.PartialSimpleIdealGasMedium\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</a>.
In the original implementation, initial states of fluid volumes can be far away from
the steady-state value because of an inconsistent implementation of the the enthalpy
and internal energy.
When the <tt>Buildings</tt> library is upgraded to
to Modelica 3.0.0, it should be safe to remove this bug fix.
</li>
<li>
The package <a href=\"modelica://Buildings.Fluid.HeatExchangers\">Buildings.Fluid.HeatExchangers</a> 
has been revised and several models have been renamed.
The heat exchanger models have been revised to allow computing the fluid volumes either
dynamically, or in steady-state.
</li>
<li>
The damper with exponential opening characteristic has been revised to allow control signals
over the whole range between <tt>0</tt> and <tt>1</tt>. This was in earlier versions restricted.
In the same model, a bug was fixed that caused the flow to be largest for <tt>y=0</tt>, i.e., when the damper is closed.
</li>
<li>
Additional models for psychrometric equations have been added. The new models contain equations
that convert dew point temperature and water vapor pressure, as well
as water vapor concentration and water vapor pressure.
</li>
<li>
A new mixing volume has been added that allows latent heat exchange with the volume.
This model can be used to model a volume of moist air with water vapor condensation 
inside the volume. The condensate is removed from the volume in its liquid phase.
</li>
</ul>
</p>
</html>
"));
  end Version_0_3_0;

  class Version_0_2_0 "Version 0.2.0"

      annotation (Documentation(info="<html>
New in this version are models for two and three way valves.
In addition, the <tt>Fluids</tt> package has been slightly revised.
The package <tt>Fluid.BaseClasses</tt> has been added because in
the previous version, partial models for fixed resistances 
where part of the <tt>Actuator</tt> package.
</p>
</html>
"));
  end Version_0_2_0;

  class Version_0_1_0 "Version 0.1.0"

      annotation (Documentation(info="<html>
<p>First release of the library.
</p>
<p>This version contains basic models for modeling building HVAC systems.
It also contains new medium models in the package
<a href=\"modelica://Buildings.Media\">Buildings.Media</a>. These medium models
have simpler property functions than the ones from
<a href=\"modelica://Modelica.Media\">Modelica.Media</a>. For example,
there is medium model with constant heat capacity which is often sufficiently 
accurate for building HVAC simulation, in contrast to the more detailed models
from <a href=\"modelica://Modelica.Media\">Modelica.Media</a> that are valid in 
a larger temperature range, at the expense of introducing non-linearities due
to the medium properties.
</html>
"));
  end Version_0_1_0;

    annotation (Documentation(info="<html>
This section summarizes the changes that have been performed
on the Buildings library
</p>
<ul>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_9_1\">
Version 0.9.1 </a>(June 23, 2010)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_9_0\">
Version 0.9.0 </a>(June 11, 2010)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_8_0\">
Version 0.8.0 </a>(February 6, 2010)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_7_0\">
Version 0.7.0 </a>(September 29, 2009)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_6_0\">
Version 0.6.0 </a>(May 15, 2009)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_5_0\">
Version 0.5.0 </a>(February 19, 2009)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_4_0\">
Version 0.4.0 </a>(October 31, 2008)</li>
<li> 
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_3_0\">
Version 0.3.0 </a>(September 30, 2008)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_2_0\">
Version 0.2.0 </a>(June 17, 2008)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_1_0\">
Version 0.1.0 </a>(May 27, 2008)</li>
</ul>
</html>
"));
  end ReleaseNotes;

  class Contact "Contact"

    annotation (Documentation(info="<html>
<dl>
<dt>The development of the Buildings package is organized by</dt>
<dd><a href=\"http://simulationresearch.lbl.gov/wetter\">Michael Wetter</a><br>
    Lawrence Berkeley National Laboratory (LBNL)<br>
    One Cyclotron Road<br> 
    Bldg. 90-3147<br>
    Berkeley, CA 94720<br>
    USA<br>
    email: <A HREF=\"mailto:MWetter@lbl.gov\">MWetter@lbl.gov</A><br></dd>
</dl>
<p>
</html>
"));

  end Contact;

  class License "Modelica License 2"

    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>The Modelica License 2</font></h4>
 
<strong>Preamble.</strong> The goal of this license is that Modelica related model libraries, software, images, documents, data files etc. can be used freely in the original or a modified form, in open source and in commercial environments (as long as the license conditions below are fulfilled, in particular sections 2c) and 2d). The Original Work is provided free of charge and the use is completely at your own risk. Developers of free Modelica packages are encouraged to utilize this license for their work. 
<p>
The Modelica License applies to any Original Work that contains the following licensing notice adjacent to the copyright notice(s) for this Original Work: 
<p>
<strong>Note.</strong> This is the standard Modelica License 2, except for the following changes: the parenthetical in paragraph 7., paragraph 5., and the addition of paragraph 15.d). 
<p>
<strong>Licensed by The Regents of the University of California, through Lawrence Berkeley National Laboratory under the Modelica License 2 </strong> 
 
<h4>1. Definitions</h4>
<ol type=\"a\"><li>
\"License\" is this Modelica License.
</li><li>
\"Original Work\" is any work of authorship, including software, images, documents, data files, that contains the above licensing notice or that is packed together with a licensing notice referencing it. 
</li><li>
\"Licensor\" is the provider of the Original Work who has placed this licensing notice adjacent to the copyright notice(s) for the Original Work. The Original Work is either directly provided by the owner of the Original Work, or by a licensee of the owner. 
</li><li>
\"Derivative Work\" is any modification of the Original Work which represents, as a whole, an original work of authorship. For the matter of clarity and as examples:
<ol type=\"A\">
<li>
Derivative Work shall not include work that remains separable from the Original Work, as well as merely extracting a part of the Original Work without modifying it. 
</li><li>
Derivative Work shall not include (a) fixing of errors and/or (b) adding vendor specific Modelica annotations and/or (c) using a subset of the classes of a Modelica package, and/or (d) using a different representation, e.g., a binary representation. 
</li><li>
Derivative Work shall include classes that are copied from the Original Work where declarations, equations or the documentation are modified. 
</li><li>
Derivative Work shall include executables to simulate the models that are generated by a Modelica translator based on the Original Work (of a Modelica package). </li>
</ol>
</li>
<li>
\"Modified Work\" is any modification of the Original Work with the following exceptions: (a) fixing of errors and/or (b) adding vendor specific Modelica annotations and/or (c) using a subset of the classes of a Modelica package, and/or (d) using a different representation, e.g., a binary representation. 
</li><li>
\"Source Code\" means the preferred form of the Original Work for making modifications to it and all available documentation describing how to modify the Original Work. 
</li><li>
\"You\" means an individual or a legal entity exercising rights under, and complying with all of the terms of, this License. 
</li><li>
\"Modelica package\" means any Modelica library that is defined with the
 <b>package</b> &lt;Name&gt; ... <b>end</b> &lt;Name&gt;<b>;</b> Modelica language element.
</li>
</ol>
 
<h4>2. Grant of Copyright License</h4>
<p>
Licensor grants You a worldwide, royalty-free, non-exclusive, sublicensable license, for the duration of the copyright, to do the following: 
<ol type=\"a\">
<li>
To reproduce the Original Work in copies, either alone or as part of a collection. 
</li><li>
To create Derivative Works according to Section 1d) of this License. 
</li><li>
To distribute or communicate to the public copies of the <u>Original Work</u> or a <u>Derivative Work</u> under <u>this License</u>. No fee, neither as a copyright-license fee, nor as a selling fee for the copy as such may be charged under this License. Furthermore, a verbatim copy of this License must be included in any copy of the Original Work or a Derivative Work under this License. 
<br>
For the matter of clarity, it is permitted A) to distribute or communicate such copies as part of a (possible commercial) collection where other parts are provided under different licenses and a license fee is charged for the other parts only and B) to charge for mere printing and shipping costs. 
</li><li>
To distribute or communicate to the public copies of a <u>Derivative Work</u>, alternatively to Section 2c), under <u>any other license</u> of your choice, especially also under a license for commercial/proprietary software, as long as You comply with Sections 3, 4 and 8 below. 
<br>
For the matter of clarity, no restrictions regarding fees, either as to a copyright-license fee or as to a selling fee for the copy as such apply. 
</li><li>
To perform the Original Work publicly. 
</li><li>
To display the Original Work publicly. 
</li></ol><p>
<h4>3. Acceptance</h4>
<p>
Any use of the Original Work or a Derivative Work, or any action according to either Section 2a) to 2f) above constitutes Your acceptance of this License. 
<p>
<h4>4. Designation of Derivative Works and of Modified Works</h4>
 
<p>
The identifying designation of Derivative Work and of Modified Work must be different to the corresponding identifying designation of the Original Work. This means especially that the (root-level) name of a Modelica package under this license must be changed if the package is modified (besides fixing of errors, adding vendor specific Modelica annotations, using a subset of the classes of a Modelica package, or using another representation, e.g. a binary representation). <p>
 
<h4>5. [reserved]</h4>
<p>
<h4>6. Provision of Source Code</h4>
<p>Licensor agrees to provide You with a copy of the Source Code of the Original Work but reserves the right to decide freely on the manner of how the Original Work is provided. For the matter of clarity, Licensor might provide only a binary representation of the Original Work. In that case, You may (a) either reproduce the Source Code from the binary representation if this is possible (e.g., by performing a copy of an encrypted Modelica package, if encryption allows the copy operation) or (b) request the Source Code from the Licensor who will provide it to You. 
<p>
<h4>7. Exclusions from License Grant</h4>
<p>
Neither the names of Licensor (including, but not limited to, University of California, Lawrence Berkeley National Laboratory, U.S. Dept. of Energy, UC, LBNL, LBL, and DOE), nor the names of any contributors to the Original Work, nor any of their trademarks or service marks, may be used to endorse or promote products derived from this Original Work without express prior permission of the Licensor. Except as otherwise expressly stated in this License and in particular in Sections 2 and 5, nothing in this License grants any license to Licensor's trademarks, copyrights, patents, trade secrets or any other intellectual property, and no patent license is granted to make, use, sell, offer for sale, have made, or import embodiments of any patent claims. 
<p>
No license is granted to the trademarks of Licensor even if such trademarks are included in the Original Work, except as expressly stated in this License. Nothing in this License shall be interpreted to prohibit Licensor from licensing under terms different from this License any Original Work that Licensor otherwise would have a right to license. 
<p>
<h4>8. Attribution Rights</h4>
<p>
You must retain in the Source Code of the Original Work and of any Derivative Works that You create, all author, copyright, patent, or trademark notices, as well as any descriptive text identified therein as an \"Attribution Notice\". The same applies to the licensing notice of this License in the Original Work. For the matter of clarity, \"author notice\" means the notice that identifies the original author(s). 
<p>
You must cause the Source Code for any Derivative Works that You create to carry a prominent Attribution Notice reasonably calculated to inform recipients that You have modified the Original Work. 
<p>In case the Original Work or Derivative Work is not provided in Source Code, the Attribution Notices shall be appropriately displayed, e.g., in the documentation of the Derivative Work. <p>
 
<h4>9. Disclaimer of Warranty</h4>
<p><u><strong>The Original Work is provided under this License on an \"as is\" basis and without warranty, either express or implied, including, without limitation, the warranties of non-infringement, merchantability or fitness for a particular purpose. The entire risk as to the quality of the Original Work is with You.</strong></u> This disclaimer of warranty constitutes an essential part of this License. No license to the Original Work is granted by this License except under this disclaimer. 
<p>
<h4>10. Limitation of Liability</h4>
<p>Under no circumstances and under no legal theory, whether in tort (including negligence), contract, or otherwise, shall the Licensor, the owner or a licensee of the Original Work be liable to anyone for any direct, indirect, general, special, incidental, or consequential damages of any character arising as a result of this License or the use of the Original Work including, without limitation, damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses. This limitation of liability shall not apply to the extent applicable law prohibits such limitation. 
<p>
<h4>11. Termination</h4>
<p>
This License conditions your rights to undertake the activities listed in Section 2 and 5, including your right to create Derivative Works based upon the Original Work, and doing so without observing these terms and conditions is prohibited by copyright law and international treaty. Nothing in this License is intended to affect copyright exceptions and limitations. This License shall terminate immediately and You may no longer exercise any of the rights granted to You by this License upon your failure to observe the conditions of this license. 
<p>
<h4>12. Termination for Patent Action</h4>
<p>
This License shall terminate automatically and You may no longer exercise any of the rights granted to You by this License as of the date You commence an action, including a cross-claim or counterclaim, against Licensor, any owners of the Original Work or any licensee alleging that the Original Work infringes a patent. This termination provision shall not apply for an action alleging patent infringement through combinations of the Original Work under combination with other software or hardware.
<p>
<h4>13. Jurisdiction</h4>
<p>
Any action or suit relating to this License may be brought only in the courts of a jurisdiction wherein the Licensor resides and under the laws of that jurisdiction excluding its conflict-of-law provisions. The application of the United Nations Convention on Contracts for the International Sale of Goods is expressly excluded. Any use of the Original Work outside the scope of this License or after its termination shall be subject to the requirements and penalties of copyright or patent law in the appropriate jurisdiction. This section shall survive the termination of this License. 
<p>
<h4>14. Attorneys' Fees</h4>
<p>
In any action to enforce the terms of this License or seeking damages relating thereto, the prevailing party shall be entitled to recover its costs and expenses, including, without limitation, reasonable attorneys' fees and costs incurred in connection with such action, including any appeal of such action. This section shall survive the termination of this License. 
<p>
<h4>15. Miscellaneous</h4>
<ol type=\"a\">
<li>If any provision of this License is held to be unenforceable, such provision shall be reformed only to the extent necessary to make it enforceable. 
</li><li>
No verbal ancillary agreements have been made. Changes and additions to this License must appear in writing to be valid. This also applies to changing the clause pertaining to written form. 
</li><li>
You may use the Original Work in all ways not otherwise restricted or conditioned by this License or by law, and Licensor promises not to interfere with or be responsible for such uses by You. 
</li><li>
You are under no obligation whatsoever to provide any bug fixes, patches, or upgrades to the features, functionality or performance of the source code (\"Enhancements\") to anyone; however, if you choose to make your Enhancements available either publicly, or directly to Lawrence Berkeley National Laboratory, without imposing a separate written license agreement for such Enhancements, then you hereby grant the following license: a non-exclusive, royalty-free perpetual license to install, use, modify, prepare derivative works, incorporate into other computer software, distribute, and sublicense such enhancements or derivative works thereof, in binary and source code form. 
</li></ol>
<p>
<h4>How to Apply the Modelica License 2</h4>
<p>
At the top level of your Modelica package and at every important subpackage, add the following notices in the info layer of the package: 
<ul><li style=\"list-style-type:none\">
Licensed by The Regents of the University of California, through Lawrence Berkeley National Laboratory under the Modelica License 2 Copyright (c) 2009, The Regents of the University of California, through Lawrence Berkeley National Laboratory. 
<p>
<li style=\"list-style-type:none\"><i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) here or at </em><a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html</a>. 
</i>
</li></ul>
<p>
Include a copy of the Modelica License 2 under <strong>&lt;library&gt;.UsersGuide.ModelicaLicense2</strong> 
(use <a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.mo\">
http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.mo</a>) 
Furthermore, add the list of authors and contributors under 
<strong>&lt;library&gt;.UsersGuide.Contributors</strong> or <strong>&lt;library&gt;.UsersGuide.Contact</strong> 
<p>
For example, sublibrary Modelica.Blocks of the Modelica Standard Library may have the following notices: 
<p>
<ul><li style=\"list-style-type:none\">
Licensed by Modelica Association under the Modelica License 2 Copyright (c) 1998-2008, Modelica Association. 
<p>
<li style=\"list-style-type:none\"><i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) here or at 
<a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html</a>. 
</i>
</li></ul>
<p>For C-source code and documents, add similar notices in the corresponding file.
<p>
For images, add a \"readme.txt\" file to the directories where the images are stored and include a similar notice in this file. 
<p>
In these cases, save a copy of the Modelica License 2 in one directory of the distribution, e.g., 
<a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2-standalone.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2-standalone.html</a> in directory <strong>&lt;library&gt;/help/documentation/ModelicaLicense2.html</strong>. 
</html>
"));

  end License;

  class Copyright "Copyright"

    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>Copyright</font></h4>
<p>
Copyright (c) 2009, The Regents of the University of California, through Lawrence Berkeley National Laboratory (subject to receipt of any required approvals from the U.S. Dept. of Energy). All rights reserved.
</p><p>
If you have questions about your rights to use or distribute this software, please contact Berkeley Lab's Technology Transfer Department at 
<A HREF=\"mailto:TTD@lbl.gov\">TTD@lbl.gov</A>
</p><p>
NOTICE. This software was developed under partial funding from the U.S. Department of Energy. As such, the U.S. Government has been granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, and perform publicly and display publicly. Beginning five (5) years after the date permission to assert copyright is obtained from the U.S. Department of Energy, and subject to any subsequent five (5) year renewals, the U.S. Government is granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, distribute copies to the public, perform publicly and display publicly, and to permit others to do so. 
</p>
</html>
"));

  end Copyright;

  annotation (DocumentationClass=true, Documentation(info="<html>
Package <b>Buildings</b> is a free package for modeling building energy and control systems. 
Many models are based on models from the package
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a> and use
the same ports to ensure compatibility with models from that library.
</p><p>
The web page for this library is
<a href=\"https://gaia.lbl.gov/bir\">https://gaia.lbl.gov/bir</a>. 
We welcome contributions from different users to further advance this library, 
whether it is through collaborative model development, through model use and testing
or through requirements definition or by providing feedback regarding the model applicability
to solve specific problems.
</p>
<p>
This is a short <b>User's Guide</b> for
the overall library. Some of the main sublibraries have their own
User's Guides that can be accessed by the following links:
</p>
<table border=1 cellspacing=0 cellpadding=2>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.UsersGuide\">Fluid</a>
   </td>
   <td valign=\"top\">Library for one-dimensional fluid in piping networks with heat exchangers, valves, etc.</td>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Fluid.Movers</a>
   </td>
   <td valign=\"top\">Library with fans and pumps.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.HeatTransfer.UsersGuide\">HeatTransfer</a>
   </td>
   <td valign=\"top\">Library for heat transfer in building constructions.</td>
</tr>
</table>
</html>"));
end UsersGuide;


annotation (preferedView="info",
      version="0.9.1",
      uses(Modelica(version="3.1")),
      Documentation(info="<html>
The <b>Buildings</b> library is a free library
for modeling building energy and control systems. 
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The figure below shows a section of the schematic view of the model 
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
In the lower part of the figure, there is a dynamic model of a boiler, a pump and a stratified energy storage tank. Based on the temperatures of the storage tank, a finite state machine switches the boiler on and off. 
The heat distribution is done using a hydronic heating system with a three way valve and a pump with variable revolutions. The upper right hand corner shows a simplified room model that is connected to a radiator whose flow is controlled by a thermostatic valve.
</p>
<p>
<img src=\"../Images/UsersGuide/HydronicHeating.png\" border=\"1\">
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>. 
Contributions from different users to further advance this library are
welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Buildings;
