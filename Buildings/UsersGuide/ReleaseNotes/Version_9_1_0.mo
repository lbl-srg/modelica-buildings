within Buildings.UsersGuide.ReleaseNotes;
class Version_9_1_0 "Version 9.1.0"
extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 9.1.0 is backward compatible with 9.0.0.
</p>
<p>
The library has been tested with Dymola 2023x,
OpenModelica 1.20.0-dev (314-g3033f43-1),
OPTIMICA (revision 2022-05-09-master-4b0cd2bf71) and recent versions of Impact.
</p>
<p>
The following major changes have been done:
</p>
<ul>
<li>
The ASHRAE Guideline 36 air-side sequences have been updated to the official release.
They are in the package <code>Buildings.Controls.OBC.ASHRAE.G36</code>.
The previous public release draft is still distributed with this version.
</li>
<li>
Various new blocks for the Control Description Language have been added to the package
<code>Buildings.Controls.OBC.CDL</code>.
</li>
<li>
The flow rate control in various examples has been improved to avoid large pump or fan heads
if the mass flow rate is prescribed rather than computed based on the pump or fan curve.
</li>
<li>
Various models have been improved for robustness,
for compatibility with the <code>Modelica.Media</code> library,
and to correct errors.
</li>
</ul>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
      </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36
      </td>
      <td valign=\"top\">Package with sequences implemented according to ASHRAE Guideline 36 official release, May 2020.
      </td>
  </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.Examples.GlobalPerezTiltedSurface
    </td>
    <td valign=\"top\">Added model that outputs the global solar irradiation on a tilted surface.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1654\">IBPSA, #1654</a>.
    </td>
 </tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal<br/>
                         Buildings.Controls.OBC.CDL.Routing.BooleanExtractor<br/>
                         Buildings.Controls.OBC.CDL.Routing.IntegerExtractSignal<br/>
                         Buildings.Controls.OBC.CDL.Routing.IntegerExtractor
    </td>
    <td valign=\"top\">Added boolean and integer extract signals.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3125\">#3125</a>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks.Combined.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.Validation.Pipe
    </td>
    <td valign=\"top\">Test for comparing <code>Buildings.DHC.Networks.Combined.BaseClasses.PipeAutosize</code> <br/>
                       initialization of <code>dh</code> to <code>Buildings.DHC.Networks.Combined.BaseClasses.PipeStandard</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2510\">issue #2510</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Applications.DataCenter</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Applications.BaseClasses.Equipment.FlowMachine_m<br/>
                         Buildings.Applications.BaseClasses.Equipment.FlowMachine_y<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialCoolingCoilHumidifyingHeating<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialHeatExchanger<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPumpParallel<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.SignalFilterParameters<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.IntegratedPrimarySecondary<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses.PartialDataCenter<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimaryLoadSideEconomizer<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimarySecondaryEconomizer<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Examples.NonIntegratedPrimarySecondaryEconomizer
    </td>
    <td valign=\"top\">Improved implementation to avoid high pressures due to pump with forced mass flow rate.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1659\">IBPSA, #1659</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU
    </td>
    <td valign=\"top\">Replaced hysteresis with <code>max</code> function to avoid chattering when the fan switches on.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3106\">#3106</a>.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.DHC</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.DHC.ETS.BaseClasses.Validation.CollectorDistributor<br/>
                         Buildings.DHC.ETS.Combined.Subsystems.HeatPump<br/>
                         Buildings.DHC.Examples.Combined.BaseClasses.PartialSeries<br/>
                         Buildings.DHC.Plants.Cooling.ElectricChillerParallel<br/>
                         Buildings.DHC.Plants.Cooling.Examples.ElectricChillerParallel<br/>
                         Buildings.DHC.Plants.Cooling.Subsystems.CoolingTowersParallel<br/>
                         Buildings.DHC.Plants.Cooling.Subsystems.CoolingTowersWithBypass<br/>
                         Buildings.DHC.Plants.Cooling.Subsystems.Examples.BaseClasses.PartialCoolingTowersSubsystem<br/>
                         Buildings.DHC.Plants.Cooling.Subsystems.Examples.CoolingTowersParallel
    </td>
    <td valign=\"top\">Improved implementation to avoid high pressures due to pump with forced mass flow rate.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1659\">IBPSA, #1659</a>.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve
    </td>
    <td valign=\"top\">Propagated parameter <code>riseTime</code> to valves. The value is not used as the filter is disabled,
                       but it will show in the result file. Having a consistent value for all these parameters in the result filter
                       helps during debugging.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1663\">IBPSA, #1663</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction
    </td>
    <td valign=\"top\">Initialized variable which otherwise lead to the simulation to fail in OpenModelica.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1664\">IBPSA, #1664</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                         Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation<br/>
                         Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                         Buildings.Fluid.MixingVolumes.MixingVolume.MoistAir</br>
                         Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort
    </td>
    <td valign=\"top\">Improved implementation so that models also work with certain media from
                       the Modelica Standard Library that may be used to model combustion gases.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1650\">IBPSA, #1650</a>.
    </td>
  <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                         Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                         Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                         Buildings.Fluid.Movers.SpeedControlled_y
    </td>
    <td valign=\"top\">Avoided negative flow work if the flow or pressure is forced in a way that the flow work would be negative.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1621\">IBPSA, #1621</a>.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.Functions.glassTRExteriorIrradiationNoShading<br/>
                       Buildings.HeatTransfer.Windows.Functions.glassTRInteriorIrradiationNoShading
    </td>
    <td valign=\"top\">Added default value for output variables.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3111\">#3111</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.regNonZeroPower
    </td>
    <td valign=\"top\">Improved documentation and assertion.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3135\">Buildings, issue #3135</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
  <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane
    </td>
    <td valign=\"top\">Corrected units of protected variables to avoid warning during model check.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1644\">IBPSA, issue #1644</a>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.spliceFunction<br/>
                         Buildings.Utilities.Math.Functions.BaseClasses.der_spliceFunction
    </td>
    <td valign=\"top\">Improved implementation of transition limits.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1640\">IBPSA, issue #1640</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks.Combined.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.PipeAutosize
    </td>
    <td valign=\"top\"><code>start</code> attribute for parameter <code>dh</code> changed to 0.01.<br/>
                       <code>min</code> attribute for parameter <code>dh</code> changed to 0.001.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2510\">issue #2510</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Examples.SimpleHouse
    </td>
    <td valign=\"top\">Changed <code>conDam.yMin</code> from 0.1 to 0.25.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1624\">
                       IBPSA, #1624</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples.ScalableBenchmarks</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone
    </td>
    <td valign=\"top\">Changed <code>fan[].m_flow_nominal</code> from 10 to 0.1.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3067\">#3067</a>
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Electrical.DC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Electrical.DC.Storage.BaseClasses.Charge
    </td>
    <td valign=\"top\">Corrected calculation of power taken from the battery when it is discharged.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3095\">issue 3095</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Plants.Cooling</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Cooling.ElectricChillerParallel
    </td>
    <td valign=\"top\">Corrected wrong assignments for chiller system <code>mulChiSys</code> which assigned chilled water
                     to condenser water parameters and vice versa.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    </td>
    <td valign=\"top\">Corrected input for enabling freeze protection setback mode.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3084\">issue 3084</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.HydronicHeating.TwoRoomsWithStorage
    </td>
    <td valign=\"top\">Corrected outdoor temperature in instance <code>TOutSwi</code> at which system switches on and off.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3059\">issue 3059</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectivenessNTU
    </td>
    <td valign=\"top\">Corrected wrong temperature in assignment of <code>sta2_default</code>.
                       For <code>Buildings.Media.Air</code> and <code>Buildings.Media.Water</code>
                       this error does not affect the results.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3151\">Buildings, issue 3151</a>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DXSystems.AirCooled.MultiStage<br/>
                       Buildings.Fluid.DXSystems.AirCooled.SingleStage<br/>
                       Buildings.Fluid.DXSystems.AirCooled.VariableSpeed<br/>
                       Buildings.Fluid.DXSystems.WaterCooled.MultiStage<br/>
                       Buildings.Fluid.DXSystems.WaterCooled.SingleStage<br/>
                       Buildings.Fluid.DXSystems.WaterCooled.VariableSpeed<br/>
                       Buildings.Fluid.DXSystems.Cooling.BaseClasses.CapacityWaterCooled<br/>
                       Buildings.Fluid.DXSystems.BaseClasses.PartialCoolingCapacity

    </td>
    <td valign=\"top\">Corrected performance calculation as a function of mass flow rates.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3146\">#3146</a>.
    </td>
</tr>
<tr><td valign=\"top\"> Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                        Buildings.Fluid.HeatExchangers.WetCoilDiscretized</br>
    </td>
    <td valign=\"top\">Reverted the correction on latent heat from component.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3065\">#3065</a>.
    </td>
</tr>
<tr><td valign=\"top\"> Buildings.Fluid.HeatExchangers.Validation.WetCoilCounterFlowLowWaterFlowRate<br/>
    </td>
    <td valign=\"top\">Modify air source boundary condition so air enters coil at 99.5% relative humidity.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3065\">#3065</a>.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
</html>"));
end Version_9_1_0;
