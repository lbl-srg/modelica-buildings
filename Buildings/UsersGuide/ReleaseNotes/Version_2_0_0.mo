within Buildings.UsersGuide.ReleaseNotes;
class Version_2_0_0 "Version 2.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<p>
Version 2.0.0 is a major release that contains various new packages, models
and improvements.
</p>
<p>
The following major additions have been done in version 2.0:
</p>
<ul>
<li>
A CFD model
that is embedded in a thermal zone has been added.
This model is implemented in <code>Buildings.ThermalZones.Detailed.CFD</code>.
The CFD model is an implementation of the Fast Fluid Dynamics code
that allows three-dimensional CFD inside a thermal zone,
coupled to building heat transfer, HVAC components and feedback control loops.
</li>
<li>
A new package <code>Buildings.Electrical</code> has been added.
This package allows studying
buildings to electrical grid integration. It includes models for loads, transformers,
cables, batteries, PV and wind turbines.
Models exist for DC and AC systems with two- or three-phase that can be balanced and unbalanced.
The models compute voltage, current, active and reactive power
based on the quasi-stationary assumption or using the dynamic phasorial representation.
</li>
<li>
The new package <code>Buildings.Controls.DemandResponse</code>
contains models for demand response simulation.
</li>
<li>
The new package
<code>Buildings.Controls.Predictors</code>
contains a data-driven model that predicts the electrical load
of a building. The prediction can be done
either using an average baseline or
a linear regression with respect to outside temperature.
For both, optionally a day-of adjustment can be made.
</li>
</ul>
<p>
The tables below give more detailed information to the revisions
of this library compared to the previous release 1.6 build 1.
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Electrical
    </td>
    <td valign=\"top\">Library for electrical grid simulation that
                       allows to study building to electrical grid integration.
                       The library contains models of loads, generation and transmission
                       for DC and AC systems.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Controls.DemandResponse
    </td>
    <td valign=\"top\">Library with a model for demand response prediction.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Controls.Predictors
    </td>
    <td valign=\"top\">Library with a data-driven model that predicts the electrical load
                     of a building. The prediction can be done
                     either using an average baseline or
                     a linear regression with respect to outside temperature.
                     For both, optionally a day-of adjustment can be made.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    </td>
    <td valign=\"top\">Model of a pressure-independent two way valve.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCooler_T
    </td>
    <td valign=\"top\">Model of a heater or cooler that takes as an input
                       the set point for the temperature of the fluid that leaves
                       the component. The set point is tracked exactly
                       if the component has sufficient capacity.
                       Optionally, the component can be configured to compute
                       a dynamic rather than a steady-state response.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Phi_pTX<br/>
                       Buildings.Utilities.Psychrometrics.Functions.phi_pTX
    </td>
    <td valign=\"top\">Block and function that computes the relative humidity
                       for given pressure, temperature and water vapor mass fraction.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.CFD
    </td>
    <td valign=\"top\">Room model that computes the room air flow
                       using computational fluid dynamics (CFD).
                       The CFD simulation is coupled to the thermal simulation of the room
                       and, through the fluid port, to the air conditioning system.
                       Currently, the supported CFD program is the
                       Fast Fluid Dynamics (FFD) program.
                       See <code>Buildings.ThermalZones.Detailed.UsersGuide.CFD</code>
                       for detailed explanations.
    </td>
    </tr>

</table>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Added option to obtain the black body sky temperature
                       from a parameter or an input signal rather than
                       computing it in the weather data reader.<br/><br/>
                       Removed redundant connection
                       <code>connect(conHorRad.HOut, cheHorRad.HIn);</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Chillers.ElectricEIR<br/>
                       Buildings.Chillers.ElectricReformulatedEIR
    </td>
    <td valign=\"top\">Changed implementation so that the model
                       is continuously differentiable.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/373\">373</a>.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow
    </td>
    <td valign=\"top\">Changed assignment of <code>T_m</code> to avoid using the conditionally
                       enabled model <code>ele[:].mas.T</code>, which is only
                       valid in a connect statement.
                       Moved assignments of
                       <code>Q1_flow</code>, <code>Q2_flow</code>, <code>T1</code>,
                       <code>T2</code> and <code>T_m</code> outside of equation section
                       to avoid mixing graphical and textual modeling within the same model.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized
    </td>
    <td valign=\"top\">Removed parameter <code>m1_flow_nominal</code>, as this parameter is already
                    declared in its base class
                    <code>Buildings.Fluid.Interfaces.PartialFourPortInterface</code>.
                    This change avoids an error in OpenModelica as the two declarations
                    had a different value for the <code>min</code> attribute, which is not valid
                    in Modelica.
    </td>
    </tr>
    <tr>
    <td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.CoilRegister<br/>
                       Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldDistributor
    </td>
    <td valign=\"top\">Reformulated the multiple iterators in the <code>sum</code> function
                       as this language construct is not supported in OpenModelica.
    </td>
    </tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
    </td>
    <td valign=\"top\">Set start value for <code>hPip(fluid(T))</code> to avoid
                       a warning about conflicting start values.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.Movers.SpeedControlled_y<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow

    </td>
    <td valign=\"top\">For the parameter setting <code>use_powerCharacteristic=true</code>,
                     changed the computation of the power consumption at
                     reduced speed to properly account for the
                     affinity laws. This is in response to
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>.
    </td>
</tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                       Buildings.Fluid.SolarCollectors.EN12975
    </td>
    <td valign=\"top\">Reformulated the model to avoid a translation error
                       if glycol is used.<br/>
                       Propagated parameters for initialization in base class
                       <code>Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector</code>
                       and set <code>prescribedHeatFlowRate=true</code>.
    </td>
    </tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Replaced the <code>abs()</code> function in the assignment of the parameter
                       <code>nSegHexTan</code> as the return value of <code>abs()</code>
                       is a <code>Real</code> which causes a type error during model check.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.MultiLayer
    </td>
    <td valign=\"top\">Changed the assignment of <code>_T_a_start</code>,
                       <code>_T_b_start</code> and <code>RTot</code> to be
                       in the initial equation section as opposed to
                       the parameter declaration.
                       This is needed to avoid an error during model check
                       and translation in Dymola 2015 FD01 beta1.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective
    </td>
    <td valign=\"top\">Changed model to allow a temperature dependent convective heat transfer
                       on the room side.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleIdealGasMedium<br/>
                       Buildings.Media.Interfaces.PartialSimpleMedium
    </td>
    <td valign=\"top\">Set <code>T(start=T_default)</code> and
                       <code>p(start=p_default)</code> in the
                       <code>ThermodynamicState</code> record. Setting the start value for
                       <code>T</code> is required to avoid an error due to
                       conflicting start values when translating
                       <code>Buildings.Examples.VAVReheat.ClosedLoop</code> in pedantic mode.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Changed model to allow a temperature dependent convective heat transfer
                       on the room side for windows.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
    </td>
    </tr>

<tr><td valign=\"top\">Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow
    </td>
    <td valign=\"top\">Conditionally removed the shade model if no shade is present.
                       This corrects
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/234\">#234</a>.
    </td>
</tr>

</table>
<!-- Non-backward compatible changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Airflow</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.ZonalFlow_ACS<br/>
                       Buildings.Airflow.Multizone.ZonalFlow_m_flow
   </td>
   <td valign=\"top\">Removed parameter <code>forceErrorControlOnFlow</code> as it was not used.
                       For Dymola, the conversion script will automatically
                       update existing models.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
   </td>
   <td valign=\"top\">Changed the following signals for compatibility with OpenModelica:<br/>
                      <code>weaBus.sol.zen</code> to <code>weaBus.solZen</code>.<br/>
                      <code>weaBus.sol.dec</code> to <code>weaBus.solDec</code>.<br/>
                      <code>weaBus.sol.alt</code> to <code>weaBus.solAlt</code>.<br/>
                      <code>weaBus.sol.solHouAng</code> to <code>weaBus.solHouAng</code>.<br/>
                      For Dymola, the conversion script will automatically
                      update existing models.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Examples</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.IntegerSum
   </td>
   <td valign=\"top\">Removed block as it is not used in any model.
                      Models that require an integer sum can use
                      <code>Modelica.Blocks.MathInteger.Sum</code>.
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.UnoccupiedOn
   </td>
   <td valign=\"top\">Removed block as it is not used in any model.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Data.GlazingSystems.Generic
    </td>
    <td valign=\"top\">Removed parameter <code>nLay</code> as OpenModelica
                       could not assign it during translation.
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u
    </td>
    <td valign=\"top\">Changed the input argument for this function from type
                       <code>Buildings.HeatTransfer.Data.BaseClasses.Material</code>
                       to the elements of this type as OpenModelica fails to translate the
                       model if the input to this function is a record.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Types.Azimuth<br/>
                       Buildings.HeatTransfer.Types.Tilt
    </td>
    <td valign=\"top\">Moved these types from <code>Buildings.HeatTransfer</code>
                       to the top-level package <code>Buildings</code> because
                       they are used in <code>Buildings.BoundaryConditions</code>,
                       <code>Buildings.HeatTransfer</code> and <code>Buildings.ThermalZones.Detailed</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.Pipe<br/>
                       Buildings.Fluid.FixedResistances.BaseClasses.Pipe<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
    </td>
    <td valign=\"top\">Renamed pressure drop from <code>res</code> to
                       <code>preDro</code> to use the same name as in other models.
                       This corrects
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">#271</a>.
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilDiscretized
    </td>
    <td valign=\"top\">Reformulated flow splitter in the model to reduce
                       the dimension of the coupled linear or nonlinear
                       system of equations. With this revision, the optional
                       control volume in the duct inlet has been removed
                       as it is no longer needed. Therefore, the parameter
                       <code>dl</code> has also been removed.
                       Replaced the parameters <code>energyDynamics1</code>
                       and  <code>energyDynamics2</code> with
                       <code>energyDynamics</code>.
                       Removed the parameter <code>ductConnectionDynamics</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed
    </td>
    <td valign=\"top\">Renamed the model to <code>HeaterCooler_u</code> due to
                       the introduction of the new model <code>HeaterCooler_T</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab
    </td>
    <td valign=\"top\">Changed the models to use by default an <i>&epsilon;-NTU</i>
                       approach for the heat transfer between the fluid and the slab
                       rather than a finite difference scheme along the
                       flow path.
                       Optionally, the finite difference scheme can also be used
                       as this is needed for some control design applications.<br/>
                       The new <i>&epsilon;-NTU</i> formulation has shown to lead to
                       about five times faster
                       computation on several test cases including the models in
                       <code>Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
 </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldFixedResistance
    </td>
    <td valign=\"top\">Reformulated flow splitter in the model to reduce
                       the dimension of the coupled linear or nonlinear
                       system of equations. With this revision, the optional
                       control volume in the duct inlet has been removed
                       as it is no longer needed. Therefore, the parameters
                       <code>dl</code> and <code>energyDynamics</code> have
                       also been removed.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.CoilRegister
    </td>
    <td valign=\"top\">Replaced the parameters <code>energyDynamics1</code>
                       and <code>energyDynamics2</code> with
                       the new parameter <code>energyDynamics</code>.
                       Removed the parameters <code>steadyState_1</code>
                       and <code>steadyState_2</code> as this information
                       is already contained in <code>energyDynamics</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.MassExchangers.HumidifierPrescribed
    </td>
    <td valign=\"top\">Renamed the model to <code>Humidifier_u</code> due to
                       the introduction of the new model <code>HeaterCooler_T</code>
                       and to use the same naming pattern as <code>HeaterCooler_u</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.Movers
    </td>
    <td valign=\"top\">This package has been redesigned.
                       The models have been renamed as follows:<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_dp</code>
                       is now called
                       <code>Buildings.Fluid.Movers.FlowControlled_dp</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_m_flow</code>
                       is now called
                       <code>Buildings.Fluid.Movers.FlowControlled_m_flow</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_Nrpm</code>
                       is now called
                       <code>Buildings.Fluid.Movers.SpeedControlled_Nrpm</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_y</code>
                       is now called
                       <code>Buildings.Fluid.Movers.SpeedControlled_y</code>.<br/><br/>
                       In addition, the performance
                       data of all movers are now stored in a record.
                       These records are in
                       <code>Buildings.Fluid.Movers.Data</code>.
                       For most existing instances, it should be sufficient to enclose
                       the existing performance data in a record called <code>per</code>.
                       For example,
                       <code><br/>
                       Buildings.Fluid.Movers.FlowMachine_y fan(<br/>
                       &nbsp;redeclare package Medium = Medium,<br/>
                       &nbsp;pressure(<br/>
                       &nbsp;&nbsp;V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,<br/>
                       &nbsp;&nbsp;dp={2*dp_nominal,dp_nominal,0})));<br/>
                       </code>
                       becomes
                       <code><br/>
                       Buildings.Fluid.Movers.SpeedControlled_y fan(<br/>
                       &nbsp;redeclare package Medium = Medium,<br/>
                       &nbsp;per(<br/>
                       &nbsp;&nbsp;pressure(<br/>
                       &nbsp;&nbsp;&nbsp;V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,<br/>
                       &nbsp;&nbsp;&nbsp;dp={2*dp_nominal,dp_nominal,0})));<br/>
                       </code>
                       <br/>
                       See the <code>Buildings.Fluid.Movers.UsersGuide</code> for more
                       information about these records.
                       <br/><br/>
                       For Dymola, the conversion script will
                       update existing models to use the old implementations
                       which are now in the package <code>Buildings.Obsolete.Fluid.Movers</code>.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media
    </td>
<td>
                       Renamed all media to simplify the media selection.
                       For typical building energy simulation,
                       <code>Buildings.Media.Air</code> and <code>Buildings.Media.Water</code>
                       should be used.<br/><br/>
                       The following changes were made.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated</code><br/>
                       to <code>Buildings.Media.Air</code>.<br/><br/>
                       Renamed <code>Buildings.Media.ConstantPropertyLiquidWater</code><br/>
                       to <code>Buildings.Media.Water</code>.<br/><br/>
                       Renamed <code>Buildings.Media.PerfectGases.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.PerfectGases.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.MoistAirUnsaturated</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.SimpleAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.IdealGases.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.IdealGases.SimpleAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesPTDecoupled.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesPTDecoupled.SimpleAir</code>.<br/><br/>
                       For Dymola, the conversion script will
                       update existing models according to the above list.

</td>
</tr>


<tr><td valign=\"top\">Buildings.Media.Water
    </td>
    <td valign=\"top\">Removed option to model water as a compressible medium as
                       this option was not useful.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow
    </td>
    <td valign=\"top\">Removed the keyword <code>replaceable</code> for the parameters
                       <code>ove</code> and <code>sidFin</code>.<br/>
                       Models that instantiate <code>Buildings.ThermalZones.Detailed.MixedAir</code> are
                       not affected by this change.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Examples.BESTEST
    </td>
    <td valign=\"top\">Moved the package to <code>Buildings.ThermalZones.Detailed.Validation.BESTEST</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.SimulationTime
    </td>
    <td valign=\"top\">Moved the block <code>Buildings.Utilities.SimulationTime</code>
                       to <code>Buildings.Utilities.Time.ModelTime</code>.<br/>
                       For Dymola, the conversion script will
                       update existing models according to the above list.
    </td>
</tr>

</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Corrected error that led the total and opaque sky cover to be ten times
                       too low if its value was obtained from the parameter or the input connector.
                       For the standard configuration in which the sky cover is obtained from
                       the weather data file, the model was correct. This error only affected
                       the other two possible configurations.
    </td>
</tr><tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Pipes
    </td>
    <td valign=\"top\">Corrected wrong entries for inner and outer diameter
                       of PEX pipes.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes.BaseClasses.singleUTubeResistances
    </td>
    <td valign=\"top\">Corrected error in function that used <code>beta</code>
                       before it was assigned a value.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Stratified<br/>
                       Buildings.Fluid.Storage.StratifiedEnhanced<br/>
                       Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Replaced the use of <code>Medium.lambda_const</code> with
                       <code>Medium.thermalConductivity(sta_default)</code> as
                       <code>lambda_const</code> is not declared for all media.
                       This avoids a translation error if certain media are used.
    </td>
</tr><tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Corrected issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">#271</a>
                       which led to a compilation error if the heat exchanger
                       and the tank had different media.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Corrected issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/304\">#304</a>
                       that led to an error in the glass temperatures if the glass conductance
                       is very small.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Added propagation of the parameter value <code>linearizeRadiation</code>
                       to the window model. Prior to this change, the radiation
                       was never linearized for computing the glass long-wave radiation.
    </td>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3WithRadiantFloor<br/>
                            Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor<br/>
                            Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.Examples.X3BWithRadiantFloor
    </td>
    <td valign=\"top\">Corrected wrong entries for inner and outer diameter
                       of PEX pipes.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.FixedResistanceDpM
    </td>
    <td valign=\"top\">Corrected error in documentation of computation of <code>k</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Changed type of <code>tauIR</code> from
                       <code>Modelica.Units.SI.Emissivity</code> to
                       <code>Modelica.Units.SI.TransmissionCoefficient</code>.
                       This avoids a type error in OpenModelica.
    </td>
</tr>

</table>

<p>
<b>Note:</b>
</p>
<p>
With version 2.0, we start using semantic versioning as described at <a href=\"http://semver.org/\">http://semver.org/</a>.
</p>
</html>"));
end Version_2_0_0;
