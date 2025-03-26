within Buildings.UsersGuide.ReleaseNotes;
class Version_1_5_build1 "Version 1.5 build 1"
  extends Modelica.Icons.ReleaseNotes;
    annotation (preferredView="info",
    Documentation(info="<html>
<p>
Version 1.5 build 1 is a major release that contains new packages with models for
solar collectors and for the Facility for Low Energy Experiments (FLEXLAB)
at the Lawrence Berkeley National Laboratory.
</p>
<p>
This release also contains a major revision of all info sections to correct invalid html syntax.
The package <code>Buildings.HeatTransfer.Radiosity</code> has been revised to comply
with the Modelica language specification.
The package <code>Buildings.ThermalZones.Detailed</code> has been revised to aid implementation of
non-uniformly mixed room air models.
This release also contains various corrections that avoid warnings during translation
when used with Modelica 3.2.1.
Various models have been revised to increase compatibility with OpenModelica.
However, currently only a subset of the models work with OpenModelica.
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.SolarCollectors
    </td>
    <td valign=\"top\">Library with solar collectors.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.FLEXLAB
    </td>
    <td valign=\"top\">Package with models for test cells of LBNL's FLEXLAB
                       (Facility for Low Energy Experiments in Buildings).
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.FLEXLAB
    </td>
    <td valign=\"top\">Package that demonstrates two-way data exchange
                       between Modelica and LBNL's FLEXLAB (Facility for
                       Low Energy Experiments in Buildings).
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.Storage</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Added a model of a tank with built-in heat exchanger.
                       This model may be used together with solar thermal plants.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Resources</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Resources.Include
    </td>
    <td valign=\"top\">Added an <code>Include</code> folder and the <code>bcvtb.h</code>
    header file to it to fix compilation errors in BCVTB example files.
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
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                       Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
    </td>
    <td valign=\"top\">Improved the algorithm that determines the absolute path of the file.
                       Now weather files are searched in the path specified, and if not found, the urls
                       <code>file://</code>, <code>modelica://</code> and <code>modelica://Buildings</code>
                       are added in this order to search for the weather file.
                       This allows using the data reader without having to specify an absolute path,
                       as long as the <code>Buildings</code> library
                       is on the <code>MODELICAPATH</code>.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
    </td>
    <td valign=\"top\">Reformulated computation of outlet properties to avoid an event at zero mass flow rate.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc
    </td>
    <td valign=\"top\">Simplified the implementation for the situation if
                       <code>allowReverseFlow=false</code>.
                       Avoided the use of the conditionally enabled variables <code>sta_a</code> and
                       <code>sta_b</code> as this was not proper use of the Modelica syntax.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.Examples.ReverseFlowHumidifier
    </td>
    <td valign=\"top\">Changed one instance of <code>Modelica.Fluid.Sources.MassFlowSource_T</code>,
                       that was connected to the two fluid streams,
                       to two instances, each having half the mass flow rate.
                       This is required for the model to work with Modelica 3.2.1 due to the
                       change introduced in
                       ticket <a href=\"https://trac.modelica.org/Modelica/ticket/739\">#739</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.EnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.LatentEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.VolumeFlowRate
    </td>
    <td valign=\"top\">Removed default value <code>tau=0</code> as the base class
                       already sets <code>tau=1</code>.
                       This change was made so that all sensors use the same default value.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstancesTwoPort
    </td>
    <td valign=\"top\">Added default value <code>C_start=0</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    </td>
    <td valign=\"top\">Changed the annotation of the
                       instance <code>material</code> from
                       <code>Evaluate=true</code> to <code>Evaluate=false</code>.
                       This is required to allow changing the
                       material properties after compilation.
                       Note, however, that the number of state variables in
                       <code>Buildings.HeatTransfer.Data.BaseClasses.Material</code>
                       are only computed when the model is translated, because
                       the number of state variables is fixed
                       at compilation time.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Diagnostics.AssertEquality<br/>
                       Buildings.Utilities.Diagnostics.AssertInequality
    </td>
    <td valign=\"top\">Added <code>time</code> in print statement as OpenModelica,
                       in its error message, does not output the time
                       when the assert is triggered.
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
<tr><td valign=\"top\">Buildings.Airflow.Multizone.Orifice<br/>
                       Buildings.Airflow.Multizone.EffectiveAirLeakageArea<br/>
                       Buildings.Airflow.Multizone.ZonalFlow_ACS
    </td>
    <td valign=\"top\">Changed the parameter <code>useConstantDensity</code> to
                       <code>useDefaultProperties</code> to use consistent names
                       within this package.
                       A conversion script in <code>Resources/Scripts/Dymola</code>
                       can be used to update old models that use this parameter.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.IndexWater
    </td>
    <td valign=\"top\">Renamed class to
                       <code>Buildings.Fluid.BaseClasses.IndexMassFraction</code>
                       as it is applicable for all mass fraction sensors.
    </td>
</tr>
<tr><td valign=\"top\">
                       Buildings.Fluid.HeatExchangers.ConstantEffectiveness<br/>
                       Buildings.Fluid.HeatExchangers.DryEffectivenessNTU<br/>
                       Buildings.Fluid.Interfaces.ConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.MassExchangers.ConstantEffectiveness<br/>
                       Buildings.Fluid.MassExchangers.HumidifierPrescribed<br/>
                       Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolumeDryAir<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir<br/>
                       Buildings.Fluid.Storage.ExpansionVessel
    </td>
    <td valign=\"top\">Changed the input connector <code>mXi_flow</code> (or <code>mXi1_flow</code>
                       and <code>mXi2_flow</code>) to <code>mWat_flow</code> (or <code>mWat1_flow</code>
                       and <code>mWat2_flow</code>).
                       This change has been done as declaring <code>mXi_flow</code> is ambiguous
                       because it does not specify what other species are added unless a mass flow rate
                       <code>m_flow</code> is also known. To avoid this confusion, the connector variables
                       have been renamed.
                       The equations that were used were, however, correct.
                       This addresses issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/165\">#165</a>.
    </td>
</tr>
<tr><td valign=\"top\">
                       Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger<br/>
                       Buildings.Fluid.BaseClasses.PartialResistance<br/>
                       Buildings.Fluid.FixedResistances.BaseClasses.Pipe<br/>
                       Buildings.Fluid.FixedResistances.FixedResistanceDpM<br/>
                       Buildings.Fluid.FixedResistances.LosslessPipe<br/>
                       Buildings.Fluid.Geothermal.Boreholes.BaseClasses.BoreholeSegment<br/>
                       Buildings.Fluid.Geothermal.Boreholes.UTube<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab<br/>
                       Buildings.Fluid.Interfaces.FourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.PartialFourPortInterface<br/>
                       Buildings.Fluid.Interfaces.PartialTwoPortInterface<br/>
                       Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume<br/>
                       Buildings.Fluid.Movers.BaseClasses.FlowControlled<br/>
                       Buildings.Fluid.Movers.BaseClasses.IdealSource<br/>
                       Buildings.Fluid.Movers.BaseClasses.PrescribedFlowMachine<br/>
    </td>
    <td valign=\"top\">Removed the computation of <code>V_flow</code> and removed the parameter
                       <code>show_V_flow</code>.
                       The reason is that the computation of <code>V_flow</code> required
                       the use of <code>sta_a</code> (to compute the density),
                       but <code>sta_a</code> is also a variable that is conditionally
                       enabled. However, this was not correct Modelica syntax as conditional variables
                       can only be used in a <code>connect</code>
                       statement, not in an assignment. Dymola 2014 FD01 beta3 is checking
                       for this incorrect syntax. Hence, <code>V_flow</code> was removed as its
                       conditional implementation would require a rather cumbersome implementation
                       that uses a new connector that carries the state of the medium.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes
    </td>
    <td valign=\"top\">Removed <code>Buildings.Fluid.MixingVolumes.MixingVolumeDryAir</code>
                       as this model is no longer used. The model
                       <code>Buildings.Fluid.MixingVolumes.MixingVolume</code>
                       can be used instead of.<br/>
                       Removed base class <code>Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</code>
                       as this model is no longer used.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.Examples.TraceSubstances
    </td>
    <td valign=\"top\">Renamed example from <code>ExtraProperty</code> to
                     <code>TraceSubstances</code> in order to use the same name
                     as the sensor.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.PrescribedExtraPropertyFlowRate
    </td>
    <td valign=\"top\">Renamed model to<code>TraceSubstancesFlowRate</code> to
                     use the same terminology than the Modelica Standard Library.<br/>
                     The conversion script updates existing models that instantiate
                     this model.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.Examples.PrescribedExtraPropertyFlow
    </td>
    <td valign=\"top\">Renamed example to<code>TraceSubstancesFlowRate</code>
                     in order to use the same name as the source model.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume<br/>
                       Buildings.Fluid.FixedResistances.Pipe<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab<br/>
                       Buildings.Fluid.Movers.BaseClasses.FlowControlled
    </td>
    <td valign=\"top\">Renamed <code>X_nominal</code> to <code>X_default</code>
                       or <code>X_start</code>, where <code>X</code> may be
                       <code>state</code>, <code>rho</code>, or <code>mu</code>,
                       depending on whether the medium default values or the start values
                       are used in the computation of the state
                       and derived quantities.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer<br/>
                         Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Interfaces.RadiosityInflow<br/>
                       Buildings.HeatTransfer.Interfaces.RadiosityOutflow<br/>
                       Buildings.HeatTransfer.Radiosity.BaseClasses.ParametersTwoSurfaces<br/>
                       Buildings.HeatTransfer.Radiosity.Constant<br/>
                       Buildings.HeatTransfer.Radiosity.Examples.OpaqueSurface<br/>
                       Buildings.HeatTransfer.Radiosity.Examples.OutdoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.IndoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.OpaqueSurface<br/>
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.RadiositySplitter<br/>
                       Buildings.HeatTransfer.Radiosity.package<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.CenterOfGlass<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.GlassLayer<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.Shade<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Shade<br/>
                       Buildings.HeatTransfer.Windows.Examples.BoundaryHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.ExteriorHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransfer<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationGainDistribution<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.MixedAir<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.Overhang<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.SideFins
    </td>
    <td valign=\"top\">Changed the connectors for the radiosity model.
                       The previous implemenation declared the radiosity as a
                       <code>flow</code> variables, but the implementation did not use
                       a potential variable.<br/>
                       Therefore, the radiosity was the only variable in the connector,
                       which is not allowed for <code>flow</code> variables.
                       This change required a reformulation of models because with the new formulation,
                       the incoming and outcoming radiosity are both non-negative values.
                       This addresses issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer<br/>
                         Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.PartialConvection<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.PartialWindowBoundaryCondition<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Shade<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.ShadeConvection<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective<br/>
                       Buildings.ThermalZones.Detailed.ExteriorBoundaryConditionsWithWindow<br/>
                       Buildings.ThermalZones.Detailed.PartialSurfaceInterface<br/>
                       Buildings.ThermalZones.Detailed.InfraredRadiationExchange<br/>
                       Buildings.ThermalZones.Detailed.AirHeatMassBalanceMixed<br/>
                       Buildings.ThermalZones.Detailed.SolarRadiationExchange<br/>
                       Buildings.ThermalZones.Detailed.RadiationTemperature<br/>
                       Buildings.ThermalZones.Detailed.InfraredRadiationGainDistribution
    </td>
    <td valign=\"top\">Redesigned the implementation of the room model and its base classes.
                       This redesign separates convection from radiation, and it provides
                       one composite model for the convection and the heat and mass balance in
                       the room. This change was done to allow an implementation of the room air
                       heat and mass balance that does not assume uniformly mixed room air.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Convection.Functions.HeatFlux.rayleigh
    </td>
    <td valign=\"top\">Renamed function from <code>raleigh</code> to <code>rayleigh</code>.
    </td>
</tr>


</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.SpecificEntropyTwoPort
    </td>
    <td valign=\"top\">
           Corrected wrong computation of the dynamics used for the sensor signal.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear
    </td>
    <td valign=\"top\">
           Corrected the glass layer thickness, which was <i>5.7</i> mm instead of
           <i>3</i> mm, as the documentation states.
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
<tr><td colspan=\"2\"><b>Buildings</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody<br/>
              Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature<br/>
              Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
              Buildings.Controls.SetPoints.HotWaterTemperatureReset<br/>
              Buildings.Examples.ChillerPlant.BaseClasses.Controls.ChillerSwitch<br/>
              Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl<br/>
              Buildings.Fluid.Boilers.BoilerPolynomial<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.HexElement<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.MassExchangeDummy<br/>
              Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDewPoint<br/>
              Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDryPoint<br/>
              Buildings.Fluid.DXSystems.BaseClasses.CoolingCapacity<br/>
              Buildings.Fluid.DXSystems.Cooling.BaseClasses.DXCooling<br/>
              Buildings.Fluid.DXSystems.BaseClasses.DryCoil<br/>
              Buildings.Fluid.DXSystems.Cooling.BaseClasses.DryWetSelector<br/>
              Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation<br/>
              Buildings.Fluid.DXSystems.Cooling.BaseClasses.WetCoil<br/>
              Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort<br/>
              Buildings.Fluid.Sensors.RelativeTemperature<br/>
              Buildings.Fluid.Sensors.Temperature<br/>
              Buildings.Fluid.Sensors.TemperatureTwoPort<br/>
              Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort<br/>
              Buildings.Fluid.SolarCollectors.BaseClasses.PartialHeatLoss<br/>
              Buildings.Utilities.Comfort.Fanger<br/>
              Buildings.Utilities.IO.BCVTB.From_degC<br/>
              Buildings.Utilities.IO.BCVTB.To_degC<br/>
              Buildings.Utilities.Psychrometrics.TDewPoi_pW<br/>
              Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi<br/>
              Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi<br/>
              Buildings.Utilities.Psychrometrics.WetBul_pTX<br/>
              Buildings.Utilities.Psychrometrics.pW_TDewPoi
    </td>
    <td valign=\"top\">Replaced wrong attribute <code>quantity=\"Temperature\"</code>
                     with <code>quantity=\"ThermodynamicTemperature\"</code>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Fuels.Generic
    </td>
    <td valign=\"top\">Corrected wrong type for <code>mCO2</code>.
                       It was declared as <code>Modelica.Units.SI.MassFraction</code>,
                       which is incorrect.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.BaseClasses.Bounds
    </td>
    <td valign=\"top\">Corrected wrong type for <code>FRWat_min</code>, <code>FRWat_max</code>
                       and <code>liqGasRat_max</code>.
                       They were declared as <code>Modelica.Units.SI.MassFraction</code>,
                       which is incorrect as, for example, <code>FRWat_max</code> can be larger than one.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.ConstantEffectiveness<br/>
                     Buildings.Fluid.MassExchangers.ConstantEffectiveness
    </td>
    <td valign=\"top\">Corrected error in the documentation that was not updated
                     when the implementation of zero flow rate was revised.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation
    </td>
    <td valign=\"top\">Corrected the syntax error
                       <code>Medium.ExtraProperty C[Medium.nC](each nominal=C_nominal)</code>
                       to
                       <code>Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)</code>
                       because <code>C_nominal</code> is a vector.
                       This syntax error caused a compilation error in OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.LatentEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.MassFraction<br/>
                       Buildings.Fluid.Sensors.MassFractionTwoPort
    </td>
    <td valign=\"top\">Changed medium declaration in the <code>extends</code> statement
                       to <code>replaceable</code> to avoid a translation error in
                       OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstances<br/>
                       Buildings.Fluid.Sensors.TraceSubstancesTwoPort
    </td>
    <td valign=\"top\">Corrected syntax errors in setting nominal value for output signal
                       and for state variable.
                       This eliminates a compilation error in OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.TraceSubstancesFlowSource
    </td>
    <td valign=\"top\">Added missing <code>each</code> in declaration of
                       <code>C_in_internal</code>.
                       This eliminates a compilation error in OpenModelica.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Python27</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Python27.Functions.exchange
    </td>
    <td valign=\"top\">Corrected error in C code that lead to message
                       <code>'module' object has no attribute 'argv'</code>
                       when a python module accessed <code>sys.argv</code>.
    </td>
</tr>



</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Verify mass and species balance</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/165\">#165</a>
    </td>
    <td valign=\"top\">This issue has been addressed by renaming the connectors to avoid an ambiguity
                       in the model equation. The equations were correct.
    </td>
<tr><td colspan=\"2\"><b>Remove flow attribute from radiosity connectors</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>
    </td>
    <td valign=\"top\">This issue has been addressed by reformulating the radiosity models.
                       With the new implementation, incoming and outgoing radiosity are non-negative
                       quantities.
    </td>
</tr>
</table>
</html>"));
end Version_1_5_build1;
