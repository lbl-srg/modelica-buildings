within Buildings.UsersGuide.ReleaseNotes;
class Version_9_0_0 "Version 9.0.0"
extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 9.0.0 is a major release that updates the Modelica version from 3.2.3 to 4.0.0.
</p>
<p>
The library has been tested with Dymola 2022x,
OpenModelica 1.19.0-dev (613-gd6e04c0-1),
OPTIMICA (revision 2022-05-09-master-4b0cd2bf71) and recent versions of Impact.
</p>
<p>
The following major changes have been done:
</p>
<ul>
<li>
The Modelica version has been updated from version 3.2.3 to 4.0.0.
</li>
<li>
Most fluid component models have been updated to remove the parameter <code>massDynamics</code>,
which is now set to the same value as the parameter <code>energyDynamics</code>.
</li>
<li>
The models for coupling with EnergyPlus have been moved to the package
<code>Buildings.ThermalZones.EnergyPlus_9_6_0</code> to allow
support for more than one EnergyPlus version
in future releases.
</li>
<li>
The BESTEST validation in the package
<code>Buildings.ThermalZones.Detailed.Validation.BESTEST</code>
has been updated to the latest BESTEST version, and new tests have been added.
</li>
<li>
The package <code>Buildings.Fluid.Geothermal.BuriedPipes</code>
has been added to model heat transfer between buried pipes and the ground,
such as for district energy systems.
</li>
<li>
The package <code>Buildings.Media.Steam</code> for modeling steam has been added.
</li>
<li>
Various new models have been added to the package <code>Buildings.Airflow.Multizone</code>
for modeling multizone air exchange.
</li>
<li>
Models for ice tanks have been added to the package
<code>Buildings.Fluid.Storage.Ice</code>.
</li>
<li>
Various models, such as for PV, solar collectors and thermal zones have been
improved to obtain the latitude of the building from the weather data bus,
rather than requiring the user to specify it.
</li>
<li>
The run-time coupling with Python has been updated to Python version 3.8,
and it has been renamed to <code>Buildings.Utilities.IO.Python_3_8</code>.
</li>
<li>
Various other models have been improved or added, in particular for modeling of
control sequences using the Control Description Language that has been developed
in the OpenBuildingControl project at <a href=\"https://obc.lbl.gov\">https://obc.lbl.gov</a>.
</li>
</ul>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
      </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Geothermal.BuriedPipes
      </td>
      <td valign=\"top\">Package with models for modeling thermal coupling between buried pipes and ground.
      </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
  <tr><td valign=\"top\">Buildings.Media.Steam
      </td>
      <td valign=\"top\">Package with medium model for steam heating applications.
      </td>
  </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Validation.BESTEST</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Validation.BESTEST.Case660<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case670<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case680<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case680FF<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case685<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case695<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case910<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case930<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case980<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case980FF<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case985<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case995
    </td>
    <td valign=\"top\">Added new test cases based on the ASHRAE 140-2020.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3005\">#3005</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Air</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart
    </td>
    <td valign=\"top\">Added example models for the use of the block optimal start controller.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2126\">#2126</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.Coefficient_V_flow<br/>
                     Buildings.Airflow.Multizone.Coefficient_m_flow<br/>
                     Buildings.Airflow.Multizone.Point_m_flow<br/>
                     Buildings.Airflow.Multizone.Points_m_flow<br/>
                     Buildings.Airflow.Multizone.Table_V_flow<br/>
                     Buildings.Airflow.Multizone.Table_m_flow
    </td>
    <td valign=\"top\">Added new component models for multizone air exchange.<br/>
                     This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized
    </td>
    <td valign=\"top\">Added model for multiple plug flow pipes in series,
                     which can be used to vary boundary conditions over the length of a pipe.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.Outside_CpData
    </td>
    <td valign=\"top\">Added new component model that allows specifying a wind pressure profile for an exterior construction.<br/>
                     This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatusDuplicator
    </td>
    <td valign=\"top\">Block that duplicates the zone status to be connected to all zone groups.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2544\">issue 2544</a>.
    </td>
</tr>
<tr><td valign=\"top\">
        Buildings.Controls.OBC.CDL.Routing.BooleanVectorFilter<br/>
        Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator<br/>
        Buildings.Controls.OBC.CDL.Routing.IntegerVectorFilter<br/>
        Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator<br/>
        Buildings.Controls.OBC.CDL.Routing.RealVectorFilter<br/>
        Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator
    </td>
    <td valign=\"top\">Blocks for filtering and replicating vectors of signals.<br/>
         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2544\">issue 2544</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Asin<br/>
                     Buildings.Controls.OBC.CDL.Continuous.Acos<br/>
                     Buildings.Controls.OBC.CDL.Continuous.Subtract<br/>
                     Buildings.Controls.OBC.CDL.Integers.Subtract
    </td>
    <td valign=\"top\">Created new blocks based on the discussion from ASHRAE Standard 231P Committee.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">#2865</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Derivative
    </td>
    <td valign=\"top\">Created new block which is required for PID controller with gain scheduling.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3022\">#3022</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.AddParameter
    </td>
    <td valign=\"top\">Created new block based on the discussion from ASHRAE Standard 231P Committee.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2876\">#2876</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.RadiantSystems</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.RadiantSystems.Cooling.HighMassSupplyTemperature_TSurRelHum
    </td>
    <td valign=\"top\">Added controller for radiant cooling that controls the surface temperature
                       using constant mass flow and variable supply temperature.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2823\">#2823</a>.<br/>
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.Utilities</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.PIDWithInputGains
    </td>
    <td valign=\"top\">Added PID controller with anti-windup and control gains exposed as inputs.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2993\">#2993</a>.<br/>
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Storage.Ice</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Ice.ControlledTank<br/>
                     Buildings.Fluid.Storage.Ice.Tank
    </td>
    <td valign=\"top\">Added models for ice storage tank whose performance is characterized by performance curves.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2820\">#2820</a>.
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
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
  </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass
    </td>
    <td valign=\"top\">Changed the gas layer to be conditional.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3026\">#3026</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Validation.BESTEST</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Validation.BESTEST.Case600FF<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case640<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case650<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case650FF<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case950<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Case950FF
    </td>
    <td valign=\"top\">Updated the test cases based on the ASHRAE 140-2020.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3005\">#3005</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Applications.DataCenters</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.AHUParameters<br/>
                       Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialCoolingCoilHumidifyingHeating
    </td>
    <td valign=\"top\">Changed cooling coil model and removed unused parameters.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">#2549</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">The weather data reader is now reading the altitude above sea level from the weather data file.
                       This new version also outputs this altitude and the latitude of the location on the weather data bus.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
    </td>
<tr><td colspan=\"2\"><b>Buildings.Controls.Continuous</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.Continuous.SignalRanker
    </td>
    <td valign=\"top\">Changed implementation to use sort function from Modelica Standard Library,
                       and updated its example to avoid simultaneous state and time events.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1534\">IBPSA, #1534</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus
    </td>
    <td valign=\"top\">Added filters to select which zones are used in group.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2544\"># 2544</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime
    </td>
    <td valign=\"top\">Increased number of years that block will output the calendar time.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2942\">issue 2942</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger<br/>
                       Buildings.Controls.OBC.CDL.Conversions.BooleanToReal<br/>
    </td>
    <td valign=\"top\">Corrected documentation texts where the variables were described with wrong types.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3016\">issue 3016</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean<br/>
    </td>
    <td valign=\"top\">Added missing <code>discrete</code> keyword to sampled variable.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2942\">issue 2942</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Utilities.SunRiseSet
    </td>
    <td valign=\"top\">Changed implementation to avoid NaN in OpenModelica.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2835\">issue 2835</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Electrical.AC.ThreePhasesUnbalanced</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line_N<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRLC<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRLC_N<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortMatrixRL_N<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortRLC<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.TwoPortRLC_N
    </td>
    <td valign=\"top\">Set nominal attribute for voltage at terminal.
                       This change enables Dymola 2023 beta3 to solve
                       <code>Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepDown.DY</code>
                       and
                       <code>Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.UnbalancedStepUp.DD</code>
                       which otherwise fail during the initialization as the homotopy steps
                       obtain unreasonable values for the voltages.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.Fluid.Boilers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.Data.Lochinvar
  </td>
  <td valign=\"top\">Added annotation <code>defaultComponentPrefixes = \"parameter\"</code>.
  </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.Polynomial
    </td>
    <td valign=\"top\">Moved part of the code to <code>Buildings.Fluid.Boilers.BaseClasses.PartialBoiler</code>
                       to support the new model <code>Buildings.Fluid.Boilers.BoilerTable</code>. <br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\"># 2651</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU
    </td>
    <td valign=\"top\">Exposed ratio of convection coefficients, set its default values based on fluid properties and flow rates,
                       and exposed exponents for convective heat transfer coefficients.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2918\">#2918</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic
    </td>
    <td valign=\"top\">Removed <code>protected</code> declaration inside the record as the Modelica Language Specification
                       only allows public sections in a record.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3009\">#3009</a>.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.DuctStaticPressureSetpoint
    </td>
    <td valign=\"top\">Removed hysteresis that disabled duct static pressure reset based on outdoor air temperature.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2545\">#2545</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Validation.BaseClasses.Floor
    </td>
    <td valign=\"top\">Update CO2 generation expressions.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2781\">#2781</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.Controls.FreezeStat
    </td>
    <td valign=\"top\">Added hysteresis. Without it, models can stall due to state events.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2975\">#2975</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.ClosedLoop<br/>
                       Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone<br/>
                       Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop
    </td>
    <td valign=\"top\">Changed cooling coil model.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">#2549</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.Tutorial.Boiler.System7
    </td>
    <td valign=\"top\">Changed block downstream of <code>greThrTRoo</code> from <code>and</code> to <code>or</code> block.
                       This ensures that the system is off when the outdoor air or room air is sufficiently warm.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.Tutorial.SpaceCooling.System2<br/>
                       Buildings.Examples.Tutorial.SpaceCooling.System3<br/>
    </td>
    <td valign=\"top\">Correct supply and return water parameterization.<br/>
                       Use design conditions for UA parameterization in cooling coil.<br/>
                       Use explicit calculation of sensible and latent load to determine design load
                       on cooling coil.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2624\">#2624</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.BaseClasses.DataCenter
    </td>
    <td valign=\"top\">Set <code>nominalValuesDefaultPressureCurve=true</code> to avoid warnings.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2761\">Buildings, #2761</a>.
<tr><td colspan=\"2\"><b>Buildings.DHC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Cooling
    </td>
    <td valign=\"top\">Revised the model for extensibility. <br/>
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2749\">#2749</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Actuators</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.SpeedControlled_y
    </td>
    <td valign=\"top\">Changed implementation of the filter.
                       The new implementation uses a simpler model.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">IBPSA #1498</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.FMI</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FMI.ExportContainers.HVACZone<br/>
                       Buildings.Fluid.FMI.ExportContainers.HVACZones<br/>
    </td>
    <td valign=\"top\">Correct supply and return water parameterization.<br/>
                       Use explicit calculation of sensible and latent load to determine design load
                       on cooling coil.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2624\">#2624</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC
    </td>
    <td valign=\"top\">Changed cooling coil model.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">#2549</a>.<br/>
                       Correct supply and return water parameterization.<br/>
                       Use explicit calculation of sensible and latent load to determine design load
                       on cooling coil.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2624\">#2624</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTower
    </td>
    <td valign=\"top\">Added a temperature sensor for better measurement of the entering water temperature.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2866\">#2866</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Air
    </td>
    <td valign=\"top\">Made the <code>BaseProperties</code> replaceable.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1516\">IBPSA #1516</a>.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
      </td>
  </tr>
  <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder.Validation.VDI6007.BaseClasses.VerifyDifferenceThreePeriods
  </td>
  <td valign=\"top\">Improved model to guard against approximation errors of event handling.
                     With this change, the models in <code>Buildings.ThermalZones.ReducedOrder.Validation.VDI6007</code>
                     all simulate with OpenModelica.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2713\">Buidings, #2713</a>.
  </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.IO</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Utilities.IO.Files.Examples.CSVReader
    </td>
    <td valign=\"top\">Updated example so it works with future versions of the Modelica Standard Library which
                       supports reading csv files.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1572\">IBPSA #1572</a>.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.BaseClasses.der_spliceFunction
    </td>
    <td valign=\"top\">Reimplemented function to avoid a potential overflow caused by the <code>cosh</code> function.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1531\">IBPSA #1531</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Cooling.Subsystems.Examples.BaseClasses.PartialCoolingTowersSubsystem
    </td>
    <td valign=\"top\">Added a temperature sensor for better measurement of the entering water temperature.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2866\">#2866</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Applications</b>
    </td>
</tr>
<tr><td valign=\"top\">
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_y<br/>
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.FlowMachine_m<br/>
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.ElectricChillerParallel<br/>
    Buildings.Applications.DataCenters.ChillerCooled.Controls.VariableSpeedPumpStage
    </td>
    <td valign=\"top\">Moved to <code>Buildings.Applications.BaseClasses</code>.<br/>
                This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2264\"># 2264</a>.<br/>
                This change is supported in the conversion script.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarGeometry.IncidenceAngle<br/>
                       Buildings.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle<br/>
                       Buildings.BoundaryConditions.SolarGeometry.ZenithAngle<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.DirectTiltedSurface<br/>
                       Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth
    </td>
    <td valign=\"top\">Removed parameter <code>lat</code> for the latitude as this is now obtained from the weather data bus.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.RelativeAirMass
    </td>
    <td valign=\"top\">Introduced altitude attenuation for relative air mass calculation.
                       This required adding a new input.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness
    </td>
    <td valign=\"top\">Changed input connector <code>HGloHor</code> to <code>HDirHor</code>.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.Continuous</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.Continuous.PIDHysteresisTimer<br/>
                       Buildings.Controls.Continuous.PIDHysteresis
    </td>
    <td valign=\"top\">Moved blocks to <code>Buildings.Obsolete.Controls.Continuous</code>.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1522\">IBPSA, #1522</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Add<br/>
                       Buildings.Controls.OBC.CDL.Integers.Add<br/>
                       Buildings.Controls.OBC.CDL.Continuous.AddParameter
    </td>
    <td valign=\"top\">Moved classes to <code>Obsolete</code> package and created new blocks to avoid using input gain factor.
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">#2865</a> and
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2876\">#2876</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Feedback
    </td>
    <td valign=\"top\">Moved the class to <code>Obsolete</code> package.
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">#2865</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Division<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Gain<br/>
                       Buildings.Controls.OBC.CDL.Continuous.MovingMean<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Product<br/>
                       Buildings.Controls.OBC.CDL.Integers.Product<br/>
                       Buildings.Controls.OBC.CDL.Continuous.SlewRateLimiter
    </td>
    <td valign=\"top\">Renamed the blocks to <code>Divide</code>, <code>MultiplyByParameter</code>, <code>MovingAverage</code>,
                       <code>Multiply</code>, <code>LimitSlewRate</code>.
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">#2865</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Interfaces.DayTypeInput<br/>
                       Buildings.Controls.OBC.CDL.Interfaces.DayTypeOutput<br/>
                       Buildings.Controls.OBC.CDL.Discrete.DayType<br/>
                       Buildings.Controls.OBC.CDL.Conversions.IsHoliday<br/>
                       Buildings.Controls.OBC.CDL.Conversions.IsWorkingDay<br/>
                       Buildings.Controls.OBC.CDL.Conversions.IsNonWorkingDay<br/>
                       Buildings.Controls.OBC.CDL.Discrete.Examples.DayType<br/>
                       Buildings.Controls.OBC.CDL.Conversions.Validation.DayTypeCheck<br/>
                       Buildings.Controls.OBC.CDL.Types.Day
    </td>
    <td valign=\"top\">Moved classes to <code>Obsolete</code> package.
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2839\">#2839</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.MultiAnd<br/>
                       Buildings.Controls.OBC.CDL.Logical.MultiOr
    </td>
    <td valign=\"top\">Renamed parameter <code>nu</code> to <code>nin</code>.
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2580\">#2580</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Routing.BooleanReplicator<br/>
                       Buildings.Controls.OBC.CDL.Routing.IntegerReplicator<br/>
                       Buildings.Controls.OBC.CDL.Routing.RealReplicator
    </td>
    <td valign=\"top\">Renamed to include <code>BooleanScalarReplicator</code>, <code>IntegerScalarReplicator</code>,
                       and <code>RealScalarReplicator</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2544\">#2544</a>.
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.IntegerSwitch<br/>
                       Buildings.Controls.OBC.CDL.Logical.LogicalSwitch<br/>
                       Buildings.Controls.OBC.CDL.Logical.Switch
    </td>
    <td valign=\"top\">Moved the blocks to <code>CDL.Integers.Switch</code>, <code>CDL.Logical.Switch</code>,
                       and <code>CDL.Continuous.Switch</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2650\">#2650</a>.
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.Change
    </td>
    <td valign=\"top\">Renamed parameter for start value from <code>y_start</code> to <code>pre_u_start</code>
                       for consistency with <code>Buildings.Controls.OBC.CDL.Logical.Change</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2990\">#2990</a>.
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Electrical</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimpleOriented<br/>
                       Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimpleOriented_N<br/>
                       Buildings.Electrical.DC.Sources.PVSimpleOriented<br/>
                       Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented<br/>
                       Buildings.Electrical.AC.ThreePhasesBalanced.Sources.PVSimpleOriented<br/>
                       Buildings.Electrical.DC.Sources.PVSimpleOriented<br/>
                       Buildings.Electrical.Interfaces.PartialPVOriented
    </td>
    <td valign=\"top\">Removed parameter <code>lat</code> for the latitude as this is now obtained from the weather data bus.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.ASHRAE2006<br/>
                       Buildings.Examples.VAVReheat.Guideline36<br/>
                       Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop
    </td>
    <td valign=\"top\">Changed models to include the hydraulic configurations of the cooling coil,
                       heating coil and VAV terminal box.<br/>
                       Changed heating supply water temperature at design condition to <i>45</i>&deg;C.<br/>
                       Corrected implementation of freeze protection for ASHRAE 2006 models.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">#2594</a>.<br/>
                       Changed model structure to separate building and HVAC system.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">#2652</a>.<br/>
                       Changed parameter declarations and added to Guideline 36 models the optimal start up calculation.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
    </td>
</tr>
 <tr><td colspan=\"2\"><b>Buildings.Examples.ScalableBenchmarks</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.ThermalZone
    </td>
    <td valign=\"top\">Reimplemented computation of energy provided by HVAC system to also include the latent load.
                     The new implementation uses the enthalpy sensor, and therefore the mass flow rate and temperature
                     sensors have been removed. Also, rather than load in Watts, it outputs the energy in Joules.<br/>
                     This version also improves the infiltration. Now, exactly the same amount of air in infiltrated and
                     exfiltrated. This was not the case previously because the infiltration was a prescribed air flow rate,
                     and the exfiltration was based on pressure difference. This caused an inbalance in the HVAC supply and
                     return air flow rate.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Actuators</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                       Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                       Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                       Buildings.Fluid.Actuators.Dampers.PressureIndependent<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayTable<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayPolynomial<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayTable
    </td>
    <td valign=\"top\">Changed implementation of the filter and changed the parameter <code>order</code> to be a constant
                       because typical users have no need to change this value.
                       The new implementation uses a simpler model.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">IBPSA #1498</a>.<br/>
                       This change is only backwards incompatible if a user
                       propagated the value of <code>order</code> to a high-level parameter.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.FixedResistances</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.PlugFlowPipe<br/>
                       Buildings.Fluid.FixedResistances.BaseClasses.PlugFlowCore
    </td>
    <td valign=\"top\">In <code>Buildings.Fluid.FixedResistances.PlugFlowPipe</code>, changed <code>ports_b</code>,
                       which was a vectorized port, to <code>port_b</code> which is a scalar port.
                       This has been done in order for the model to have the same connectors as
                       are used for other pipe models.<br/>
                       Refactored implementation and made various classes in this model protected.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1494\">IBPSA #1494</a>.<br/>
                       For Dymola, a conversion script renames existing models to
                       <code>Buildings.Obsolete.Fluid.FixedResistances.PlugFlowPipe</code> and
                       <code>Buildings.Obsolete.Fluid.FixedResistances.BaseClasses.PlugFlowCore</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.EN12975<br/>
                       Buildings.Fluid.SolarCollectors.ASHRAE93
    </td>
    <td valign=\"top\">Removed parameter <code>lat</code> for the latitude as this is now obtained from the weather data bus.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
                       This change is supported in the conversion script.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.Fluid.Storage</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Storage.ExpansionVessel
    </td>
    <td valign=\"top\">Removed parameter <code>p</code> which was not used.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1614\">IBPSA, #1614</a>.
                       This change is supported in the conversion script.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.FixedShade<br/>
                       Buildings.HeatTransfer.Windows.Overhang<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Overhang
    </td>
    <td valign=\"top\">Removed parameter <code>lat</code> for the latitude as this is now obtained from the weather data bus.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Obsolete</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Obsolete.Utilities.IO.Python27
    </td>
    <td valign=\"top\">Removed support for Python 27. Use instead <code>Buildings.Utilities.IO.Python36</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                       Buildings.ThermalZones.Detailed.CFD<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditions<br/>
                       Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow<br/>
                       Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor
    </td>
    <td valign=\"top\">Removed parameter <code>lat</code> for the latitude as this is now obtained from the weather data bus.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Set <code>final massDynamics=energyDynamic</code>.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">IBPSA, #1542</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0
    </td>
    <td valign=\"top\">Renamed package to add the version number for EnergyPlus. This will allow supporting more than
                       one version of EnergyPlus.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2851\">#2851</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.Building
    </td>
    <td valign=\"top\">This model, which needs to be part of every model that uses EnergyPlus, now
                       requires the specification of the EnergyPlus weather data file (<code>.epw</code> file)
                       through the parameter <code>epwName</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2443\">#2443</a>.<br/>
                       <br/>
                       Removed the parameters <code>showWeatherData</code> and <code>generatePortableFMU</code>.
                       Now, the weather data bus is always enabled as it is used in almost all simulations.
                       This change is supported in the conversion script.<br/>
                       Converted <code>usePrecompiledFMU</code> and the associated <code>fmuName</code> from
                       parameter to a constant as these are only used for debugging by developers.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2759\">#2759</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.ASHRAE2006Spring<br/>
                       Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.ASHRAE2006Summer<br/>
                       Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.ASHRAE2006Winter<br/>
                       Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.Guideline36Spring<br/>
                       Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.Guideline36Summer<br/>
                       Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SmallOffice.Guideline36Winter
    </td>
    <td valign=\"top\">Changed models to include the hydraulic configurations of the cooling coil,
                       heating coil and VAV terminal box.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">#2594</a>.<br/>
                       Changed model structure to separate building and HVAC system.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">#2652</a>.<br/>
                       Changed parameter declarations and added to Guideline 36 models the optimal start up calculation.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.Utilities.IO</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Utilities.IO.Python36
    </td>
    <td valign=\"top\">Replaced package with <code>Buildings.Utilities.IO.Python_3_8</code>
                       and moved the old package to <code>Buildings.Obsolete.Utilities.IO.Python36</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2599\">#2599</a>.<br/>
                       For Dymola, a conversion script will rename models that use <code>Python36</code>
                       to use <code>Python_3_8</code>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Polynominal<br/>
                         Buildings.Utilities.Math.Examples.Polynominal
    </td>
    <td valign=\"top\">Corrected name to <code>Polynomial</code>.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1524\">IBPSA, #1524</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Greater<br/>
                       Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Less<br/>
                       Buildings.Controls.OBC.CDL.Continuous.LessThreshold
    </td>
    <td valign=\"top\">Corrected the condition of switching true back to false. It is caused by the wrong inequality check.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2981\">#2981</a>.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.DHC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Examples.Combined.ParallelConstantFlow
    </td>
    <td valign=\"top\">Removed the model that represented an incorrect hydronic configuration. <br/>
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2967\">#2967</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
    </td>
</tr>
<tr><td valign=\"top\"> Buildings.Fluid.Chillers.BaseClasses.PartialElectric
    </td>
    <td valign=\"top\">Corrected calculation of entering condenser temperature
                       when using a moist air media model.
                       This is important for modeling air-cooled chillers using the model
                       <code>Buildings.Fluid.Chillers.ElectricEIR</code>
                       <br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2770\">#2770</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\"> Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                        Buildings.Fluid.HeatExchangers.WetCoilDiscretized</br>
    </td>
    <td valign=\"top\">Corrected removal of latent heat from component.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3027\">#3027</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Occupants</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Occupants.Office.Occupancy.Wang2005Occupancy
    </td>
    <td valign=\"top\">Reformulated model so it works also if the simulation does not start at <i>0</i>.<br/>
                       To improve efficiency, this reformulation also changes the event triggering function so that
                       it leads to time events rather than state events.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2590\">#2590</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Airflow</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Airflow.Multizone.DoorOperable
    </td>
    <td valign=\"top\">Removed duplicate declaration of <code>VABp_flow</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1496\">Buildings, #1496</a>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Applications.DataCenters</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.IntegratedPrimaryLoadSide
    </td>
    <td valign=\"top\">Removed duplicate instances of blocks that generate control signals.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2963\">Buildings, issue 2963</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimaryLoadSideEconomizer<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimarySecondaryEconomizer<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Examples.NonIntegratedPrimarySecondaryEconomizer
    </td>
    <td valign=\"top\">Corrected weather data bus connection which was structurally incorrect
                       and did not parse in OpenModelica.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2706\">Buildings, issue 2706</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
  </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.PID<br/>
                         Buildings.Controls.OBC.CDL.PIDWithReset
  </td>
  <td valign=\"top\">Corrected wrong documentation in how the derivative of the control error is approximated.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2994\">Buildings, issue 2994</a>.
  </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Electrical.AC.OnePhase.Sources.PVSimple<br/>
                         Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented<br/>
                         Buildings.Electrical.AC.ThreePhasesBalanced.Sources.PVSimple<br/>
                         Buildings.Electrical.AC.ThreePhasesBalanced.Sources.PVSimpleOriented<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimple<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimple<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimpleOriented<br/>
                         Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimpleOriented_N<br/>
                         Buildings.Electrical.DC.Sources.PVSimple<br/>
                         Buildings.Electrical.DC.Sources.PVSimpleOriented<br/>
                         Buildings.Electrical.Interfaces.PartialPvBase
    </td>
    <td valign=\"top\">Corrected wrong documentation string for surface area which
                       should be gross rather than net area.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.Experimental</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Cooling.Controls.ChillerStage
    </td>
    <td valign=\"top\">Corrected parameter value for <code>twoOn.nOut</code>.
                       This correction is required to simulate the model in Dymola 2022
                       if the model has been updated to MSL 4.0.0. With MSL 3.2.3, the simulation
                       works without this correction.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1563\">Buildings, #1563</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Media.Specialized.Water.TemperatureDependentDensity
    </td>
    <td valign=\"top\">Corrected assignment of gas constant which lead to a unit error.
                       This change does not affect the results as the value is not used for this liquid medium.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1603\">IBPSA, #1603</a>.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.RadiationTemperature
    </td>
    <td valign=\"top\">Corrected annotation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2550\">Buildings, #2550</a>.
    </td>
</tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallTwoWindows<br/>
                           Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallWithWindow<br/>
                           Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Electrical<br/>
                           Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF
        </td>
        <td valign=\"top\">Added missing parameter declaration.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2556\">Buildings, #2556</a>.
        </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Python_3_8</b>
   </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.IO.Python_3_8.Functions.Examples.Exchange
   </td>
   <td valign=\"top\">Removed call to impure function <code>removeFile</code>.
                      This removal is required for MSL 4.0.0.<br/>
                      This is for
                      <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1563\">Buildings, #1563</a>.
   </td>
</tr>
</table>
</html>"));
end Version_9_0_0;
