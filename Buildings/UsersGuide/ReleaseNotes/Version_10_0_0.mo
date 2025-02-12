within Buildings.UsersGuide.ReleaseNotes;
class Version_10_0_0 "Version 10.0.0"
extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 10.0.0 is a major release that adds various new packages and models.
</p>
<p>
The library has been tested with
Dymola 2023x,
OpenModelica 1.22.0-dev (41-g8a5b18f-1),
OPTIMICA 1.43.4 and recent versions of Impact.
</p>
<p>
The following major changes have been done compared to release 9.1.1:
</p>
<ul>
<li>
A package with configurable template models for variable air volume flow systems
with control based on ASHRAE Guideline 36 has been added to
<code>Buildings.Template</code>.
</li>
<li>
Reduced order building envelope models
based on the ISO 13790:2008 Standard have been added.
This allows modeling of building envelope heat transfer either with a detailed Modelica
multizone model (<code>Buildings.ThermalZones.Detailed</code>),
with EnergyPlus via the Spawn coupling (<code>Buildings.ThermalZones.EnergyPlus_9_6_0</code>),
or with reduced order models based on ISO 13790 (<code>Buildings.ThermalZones.ISO13790</code>)
or based on VDI 6007 (<code>Buildings.ThermalZones.ReducedOrder</code>).
</li>
<li>
Various models for district energy systems have been added to the package
<code>Buildings.Experimental</code>.
This package includes models for
<ul>
<li>
combined heating and cooling district energy systems
that operate near ambient temperature (sometimes called 5th generation district energy systems),
</li>
<li>
Energy Transfer Stations (ETS) with all electric plants with heat recovery chillers,
</li>
<li>
ETS with multiple heat pumps (heat recovery as well as air-source heat pumps) and storage, i.e.,
the so-called Time-Independent Energy Recovery (TIER) plant in
(<code>Buildings.DHC.Plants.Combined.AllElectricCWStorage</code>),
</li>
<li>
direct and indirect ETS for heating or for cooling, and
</li>
<li>
district steam systems.
</li>
</ul>
</li>
<li>
A package with all major hydronic configurations that are encountered in heating and cooling systems
has been added in <code>Buildings.Fluid.HydronicConfigurations</code>.
This package also includes automatic sizing of control valves to obtain suitable valve authority.
</li>
<li>
The fan and pump models have been revised, and can now be configured to compute
the part load efficiency based on the Euler number.
</li>
<li>
Various new elementary control blocks have been added to the <code>Buildings.Controls.OBC.CDL</code> package to
provide a reference implementation of the ASHRAE Standard 231P
<i>Control Description Language</i> that is currently being developed.
See also <a href=\"https://obc.lbl.gov\">obc.lbl.gov</a>.
</li>
</ul>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Templates
    </td>
    <td valign=\"top\">Package that contains templates for HVAC systems with control sequences
                       based on ASHRAE Guideline 36.
                       Currently limited to VAV systems, the package is under active development
                       and will be further expanded with templates for primary systems and various
                       types of zone equipment.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.ThermalZones.ISO13790
    </td>
    <td valign=\"top\">Package that contains models for reduced building physics of thermal zones
                       based on a thermal network consisting of five resistances and one capacity.
                       The models are inspired by the ISO 13790:2008 Standard.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Heating
    </td>
    <td valign=\"top\">Package containing models for energy transfer stations used in district heating systems.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.Combined.Examples
    </td>
    <td valign=\"top\">Package that contains example models of a building
                       with loads provided as time series for heat
                       pump space heating, heat pump domestic hot water heating,
                       and free cooling in an ambient district network.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.Heating
    </td>
    <td valign=\"top\">Package containing models for loads in district heating systems.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Combined
    </td>
    <td valign=\"top\">Package of models for central plants that provide heating and cooling.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.BaseClasses.Steam
    </td>
    <td valign=\"top\">Package for steam systems using the split-medium approach..
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Examples.Steam
    </td>
    <td valign=\"top\">Package of example models for steam district heating systems.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.Steam
    </td>
    <td valign=\"top\">Package with models for loads involving steam systems.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Steam
    </td>
    <td valign=\"top\">Package of models for distribution networks involving steam.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Steam
    </td>
    <td valign=\"top\">Package with models for steam plants.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HydronicConfigurations
    </td>
    <td valign=\"top\">Package that contains models for standard connection
                       configurations used in hydronic circuits for heating or cooling applications.
    </td>
</tr>
  </table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Proof
    </td>
    <td valign=\"top\">Added new CDL blocks as suggested by ASHRAE 231p committee.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3256\">issue 3256</a>.
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.VariablePulse
    <td valign=\"top\">Added new CDL blocks as suggested by ASHRAE 231p committee.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3042\">issue 3042</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Ramp
    </td>
    <td valign=\"top\">Added new CDL blocks as suggested by ASHRAE 231p committee.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3141\">issue 3141</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.Stage
    </td>
    <td valign=\"top\">Added new CDL blocks as suggested by ASHRAE 231P committee.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3103\">issue 3103</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Plants.Cooling</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Cooling.StoragePlant<br/>
                       Buildings.DHC.Plants.Cooling.Controls.FlowControl<br/>
                       Buildings.DHC.Plants.Cooling.Controls.SelectMin<br/>
                       Buildings.DHC.Plants.Cooling.Controls.TankStatus<br/>
                       Buildings.DHC.Plants.Cooling.Controls.Validation.TankStatus<br/>
                       Buildings.DHC.Plants.Cooling.Examples.StoragePlantDualSource<br/>
                       Buildings.DHC.Plants.Cooling.BaseClasses.IdealUser<br/>
                       Buildings.DHC.Plants.Cooling.BaseClasses.ParallelJunctions<br/>
                       Buildings.DHC.Plants.Cooling.BaseClasses.ParallelPipes<br/>
                       Buildings.DHC.Plants.Cooling.BaseClasses.ReversibleConnection<br/>
                       Buildings.DHC.Plants.Cooling.BaseClasses.TankBranch<br/>
                       Buildings.DHC.Plants.Cooling.BaseClasses.Validation.IdealUser
    </td>
    <td valign=\"top\">Added models for a district CHW system with two plants,
                       where one of them has a storage tank that can be charged remotely by the other plant.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">issue 2859</a>.
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr><td valign=\"top\">
        Buildings.Fluid.Movers.Examples.Data.EnglanderNorford1992<br/>
        Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW12<br/>
        Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW13<br/>
        Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW15<br/>
        Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW16<br/>
        Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW18<br/>
        Buildings.Fluid.Movers.Examples.StaticReset<br/>
        Buildings.Fluid.Movers.Validation.PowerEuler<br/>
        Buildings.Fluid.Movers.BaseClasses.Euler.computeTables<br/>
        Buildings.Fluid.Movers.BaseClasses.Euler.correlation<br/>
        Buildings.Fluid.Movers.BaseClasses.Euler.getPeak<br/>
        Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables<br/>
        Buildings.Fluid.Movers.BaseClasses.Euler.peak<br/>
        Buildings.Fluid.Movers.BaseClasses.Validation.EulerComparison<br/>
        Buildings.Fluid.Movers.BaseClasses.Validation.EulerCurve<br/>
        Buildings.Fluid.Movers.BaseClasses.Validation.EulerReducedSpeed<br/>
        Buildings.Fluid.Movers.BaseClasses.Validation.HydraulicEfficiencyMethods<br/>
        Buildings.Fluid.Movers.BaseClasses.Validation.TotalEfficiencyMethods
    </td>
    <td valign=\"top\">
    Added package that enables the Euler number method for efficiency computation,
    as well as example models, validation models, and data records to support it.<br/>
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
    </td>
</tr>
<tr><td valign=\"top\">
        Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency_yMot<br/>
        Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot<br/>
        Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve<br/>
        Buildings.Fluid.Movers.BaseClasses.Validation.MotorEfficiencyMethods
    </td>
    <td valign=\"top\">
    Added functions and data records that allow the motor efficiency to be provided
    as a function of part load ratio, and its validation model.<br/>
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
    </td>
</tr>
<tr><td valign=\"top\">
        Buildings.Fluid.Movers.Preconfigured.FlowControlled_dp<br/>
        Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow<br/>
        Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y<br/>
        Buildings.Fluid.Movers.Preconfigured.Validation.ControlledFlowMachinePreconfigured
    </td>
    <td valign=\"top\">
    Added preconfigured versions for the mover models that only require the user
    to provide nominal conditions.<br/>
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
    </td>
</tr>
<tr><td valign=\"top\">
        Buildings.Fluid.Movers.Validation.PressureCurve
    </td>
    <td valign=\"top\">
    Added a validation model that displays the pressure curve.<br/>
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3371\">#3371</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.BaseClasses.PartialAirSource
    </td>
    <td valign=\"top\">Added new base class that only provides moist air as a medium selection.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1681\">IBPSA, #1681</a>.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Files</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Utilities.IO.Files.WeeklySchedule
    </td>
    <td valign=\"top\">Added model to read weekly time schedules from a file.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1601\">IBPSA, #1601</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Alarms
    </td>
    <td valign=\"top\">Added delay triggering alarms after enabling AHU supply fan, to allow the system becoming stabilized.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">issue 3257</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Plants.Cooling</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Cooling.Controls.ChilledWaterPumpSpeed
    </td>
    <td valign=\"top\">Set <code>final totPum.nin = numPum</code> so that this block is restricted
                       to a two-pump configuration as intended.
                       Also corrected the \"up to two pumps\" language in documentation.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3470\">issue 3470</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Validation.BESTEST</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Validation.BESTEST.UsersGuide<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx<br/>
                       Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx
    </td>
    <td valign=\"top\">Added test acceptance criteria limits.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.PIDWithInputGains
    </td>
    <td valign=\"top\">Correted the instance <code>antWinGai2</code> to be conditional.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3423\">#3423</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Improved error message in Java application that converts weather file.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3380\">#3380</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36.AHUs</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.FreezeProtection<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection
    </td>
    <td valign=\"top\">Added flag to disable freeze protection.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">#3139</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Switch
    </td>
    <td valign=\"top\">Added <code>smoothOrder(0, ...)</code> as this is required for some solvers
                     that assume otherwise the output of the block to be differentiable.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Routing.RealExtractSignal
    </td>
    <td valign=\"top\">Added assertion when the extract index is out of range.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3125\">#3125</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Electrical</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Electrical.Interfaces.PartialTwoPort
    </td>
    <td valign=\"top\">Added constraining clause for terminal as models that extend from this model
                     access a component that is not in the base class, and Optimica 1.40
                     issues a warning for this.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3236\">#3236</a>.
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
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.Guideline36
    </td>
    <td valign=\"top\">Changed the indication of the status when window is closed.<br/>
                       In default, it should be true (closed dry contact) rather than false.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">#3257</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC
    </td>
    <td valign=\"top\">Added junction to mix the return and outdoor air.<br/>
                       Set the value of parameter <code>transferHeat</code> to true for the mixed air temperature sensor.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3230\">#3230</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox
    </td>
    <td valign=\"top\">Changed the pressure independent damper to exponential damper.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">#3139</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV
    </td>
    <td valign=\"top\">Added flag to choose different damper type and added control for the boxes with the exponential damper.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">#3139</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Experimental</b>
</td>
<tr><td valign=\"top\">Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingTimeSeries
    </td>
    <td valign=\"top\">Compute the scaling parameters based on the peak loads
                        and revise documentation.<br/>
                        This is for
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2302\">#2302</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connection2Pipe
    </td>
    <td valign=\"top\">Removed renamed model redeclare to solve error and allow separate pipe
                       declarations on sup/ret of DHC networks.<br/>
                        This is for
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2905\">#2905</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connection2PipePlugFlow
    </td>
    <td valign=\"top\">Fix redeclare of dis pipe models in connections.<br/>
                        This is for
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2905\">#2905</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Actuators</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve
    </td>
    <td valign=\"top\">Removed start value for <code>dp</code>.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3231\">#3231</a>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.BaseClasses</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.BaseClasses.MassFlowRateMultiplier
    </td>
    <td valign=\"top\">Added option to use input connector as multiplier factor.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1684\">IBPSA, #1684</a>.
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
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Chillers.BaseClasses.PartialElectric
    </td>
    <td valign=\"top\">Added optional switchover mode for heat recovery chillers.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3211\">#3211</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Chillers.BaseClasses.Carnot
  </td>
  <td valign=\"top\">Changed parameter binding
                     <code>etaCarnot_nominal(unit=\"1\") =
                     COP_nominal/(TUseAct_nominal/(TCon_nominal+TAppCon_nominal - (TEva_nominal-TAppEva_nominal)))</code>
                     to
                     <code>etaCarnot_nominal(unit=\"1\") = 0.3</code> to avoid a circular assignment.<br/>
                     Improved documentation.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3226\">#3226</a>.
  </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.OneUTube<br/>
                       Buildings.Fluid.Geothermal.Borefields.TwoUTubes
    </td>
    <td valign=\"top\">Enabled calculation of bore fields with hundreds of bore holes. This is
                       accomplished by updating the calculation of the ground temperature response in the model
                       <code>Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.GroundTemperatureResponse</code>
                       using clustering of bore holes as described in
                       <a href=\"https://doi.org/10.1080/19401493.2021.1968953\">
                       doi:10.1080/19401493.2021.1968953</a>.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1577\">IBPSA, #1577</a>.
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU<br/>
                       Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectivenessNTU
    </td>
    <td valign=\"top\">Set <code>flowRegime</code> to be equal to <code>flowRegime_nominal</code>
                       by default. Added an assertion warning to inform the user about how to change
                       this behaviour if the flow direction does need to change.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1682\">IBPSA, #1682</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
  </td>
</tr>
  <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                         Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                         Buildings.Fluid.Movers.SpeedControlled_y
    </td>
    <td valign=\"top\">Avoided negative flow work if the flow or pressure is forced in a way that the flow work would be negative.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1621\">IBPSA, #1621</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                         Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                         Buildings.Fluid.Movers.SpeedControlled_y<br/>
                         Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y<br/>
                         Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    </td>
    <td valign=\"top\">Changed the way the nominal flow rate is declared
                       so that it can be modified in <code>PartialFlowMachine</code>
                       by a higher-level model, but not the other way around.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1705\">IBPSA, #1705</a>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU
    </td>
    <td valign=\"top\">Replaced hysteresis with <code>max</code> function to avoid chattering when the fan switches on.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3106\">#3106</a>.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU
    </td>
    <td valign=\"top\">Replaced hysteresis with <code>max</code> function to avoid chattering when the fan switches on.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3106\">#3106</a>.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.BaseClasses.Outside<br/>
                       Buildings.Fluid.Sources.MassFlowSource_WeatherData
    </td>
    <td valign=\"top\">Changed base class to constrain medium to moist air.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1681\">IBPSA, #1681</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Media</b>
  </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Examples.BaseClasses.PartialProperties
    </td>
    <td valign=\"top\">Removed a self-dependent default binding of a function input.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3384\">#3384</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Steam
    </td>
    <td valign=\"top\">Changed the variable type definition of <code>pHat</code> and <code>THat</code>
                       from absolute to <code>Modelica.Units.SI.PressureDifference</code> and
                       <code>Modelica.Units.SI.TemperatureDifference</code> to prevent min/max
                       assertion erros during initilization.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2905\">#2905</a>.<br/>
                       In function <code>rho_pT</code>, created and used new function extending
                       <code>Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g2</code> with an
                       annotation <code>smoothOrder=2</code>.  This is to specifcally pass on the
                       <code>smoothOrder=2</code> annotion placed on <code>rho_pT</code> to
                       the <code>g2</code> function.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2905\">#2905</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU
    </td>
    <td valign=\"top\">Replaced hysteresis with <code>max</code> function to avoid chattering when the fan switches on.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3106\">#3106</a>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse</b>
    </td>
</tr><tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TRoom<br/>
                          Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TSurface<br/>
                          Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer
    </td>
    <td valign=\"top\">Changed pipe spacing and insulation of radiant slab.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder.SolarGain.CorrectionGDoublePane
    </td>
    <td valign=\"top\">Corrected units of protected variables to avoid warning during model check.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1644\">IBPSA, issue #1644</a>.
    </td>
  </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
    </td>
</tr>
  <tr><td valign=\"top\">Buildings.Utilities.Math.Functions.regNonZeroPower
    </td>
    <td valign=\"top\">Improved documentation and assertion.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3135\">Buildings, issue #3135</a>.
    </td>
  </tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.spliceFunction<br/>
                         Buildings.Utilities.Math.Functions.BaseClasses.der_spliceFunction
    </td>
    <td valign=\"top\">Improved implementation of transition limits.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1640\">IBPSA, issue #1640</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Alarms
    </td>
    <td valign=\"top\">Added zone operation mode input to limit triggering alarms only in occupied mode.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">issue 3257</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves
    </td>
    <td valign=\"top\">Added AHU supply fan status input for damper position reset.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">issue 3257</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Air</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer
    </td>
    <td valign=\"top\">Refactored the model for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">issue 2668</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36.AHUs</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Limits.SeparateWithDP<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences.Limits
    </td>
    <td valign=\"top\">Because of the removal of <code>Logical.And3</code> based on ASHRAE 231P,
                       replaced it with a stack of two <code>Logical.And</code> blocks.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2465\">#2465</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.Alarms<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.Alarms<br/>
    </td>
    <td valign=\"top\">Because of the removal of <code>Logical.And3</code> based on ASHRAE 231P,
                       replaced it with a stack of two <code>Logical.And</code> blocks.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2465\">#2465</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences.Dampers<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Subsequences.Dampers<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConDischargeSensor.Subsequences.Dampers<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences.Dampers<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersDualSensors<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctSnapActing.Subsequences.DampersSingleSensors<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanCVF.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.ParallelFanVVF.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.Reheat.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves<br/>
    </td>
    <td valign=\"top\">Removed the parameter <code>have_preIndDam</code> to exclude the option of using pressure independant damper.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">#3139</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36.Types</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes
    </td>
    <td valign=\"top\">Removed the option of using return fan with tracking calculated supply and return airflow.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">#3139</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection
    </td>
    <td valign=\"top\">Removed the no-economizer option.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">#3139</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous<br/>
    </td>
    <td valign=\"top\">Renamed package <code>Continuous</code> to <code>Reals</code>
                       due to changes in ASHRAE Standard 231P.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3483\">#3483</a>.<br/>
                       This change is supported in the conversion script.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.And3<br/>
                         Buildings.Controls.OBC.CDL.Logical.Validation.And3
    </td>
    <td valign=\"top\">Moved to the <code>Obsolete</code> package based on ASHRAE 231P.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2465\">#2465</a>.
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Acos<br/>
                       Buildings.Controls.OBC.CDL.Reals.Asin<br/>
                       Buildings.Controls.OBC.CDL.Reals.Atan<br/>
                       Buildings.Controls.OBC.CDL.Reals.Atan2
    </td>
    <td valign=\"top\">Added unit <code>rad</code> to the output.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3277\">#3277</a>.<br/>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Cos<br/>
                       Buildings.Controls.OBC.CDL.Reals.Sin<br/>
                       Buildings.Controls.OBC.CDL.Reals.Tan
    </td>
    <td valign=\"top\">Added unit <code>rad</code> to the input.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3277\">#3277</a>.<br/>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Routing.RealExtractor
    </td>
    <td valign=\"top\">Removed parameter <code>allowOutOfRange</code> and <code>outOfRangeValue</code> and output the element with the nearest valid index
                       when the index input is out of range.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3125\">#3125</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.ClosedLoop<br/>
                       Buildings.Examples.HydronicHeating.TwoRoomsWithStorage<br/>
                       Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone<br/>
                       Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC
    </td>
    <td valign=\"top\">Replaced fan and pump models that have simple two-point
                       pressure curve assignments with preconfigured models.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.HydronicHeating.TwoRoomsWithStorage
    </td>
    <td valign=\"top\">Changed control that enables the heating system.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Plants</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Combined.Controls.BaseClasses.ModeCondenserLoop
    </td>
    <td valign=\"top\">Because of the removal of <code>Logical.And3</code> based on ASHRAE 231P,
                       replaced it with a stack of two <code>Logical.And</code> blocks.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2465\">#2465</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Loads</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.BaseClasses.FlowDistribution<br/>
                       Buildings.DHC.Loads.BaseClasses.Validation.FlowDistributionPumpControl
    </td>
    <td valign=\"top\">Swapped the pump models for preconfigured versions.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3099\">#3099</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DXCoils</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DXCoils.AirCooled<br/>
                       Buildings.Fluid.DXCoils.WaterCooled
    </td>
    <td valign=\"top\">Renamed packages to <code>AirSource</code> and <code>WaterSource</code>
                       as DX coils for heating are added, and hence cooled is not an appropriate package name.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3288\">issue 3288</a>.
    </td>
</tr>
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine
    </td>
    <td valign=\"top\">Removed the block that was used to support fan or pump models with an rpm input.
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, issue 1704</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine<br/>
                       Buildings.Fluid.Movers.Data.Generic<br/>
                       Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW12<br/>
                       Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW13<br/>
                       Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW15<br/>
                       Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW16<br/>
                       Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW18<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.CronolineIL80slash220dash4slash4<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to8<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to4<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to12<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to8<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos50slash1to12<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos80slash1to12<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS25slash10<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS30slash10<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS30slash5<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS40slash10<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS40slash7<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine50slash150dash4slash2<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine80slash115dash2comma2slash2<br/>
                       Buildings.Fluid.Movers.Examples.MoverContinuous<br/>
                       Buildings.Fluid.Movers.Examples.MoverParameter<br/>
                       Buildings.Fluid.Movers.Examples.MoverStages<br/>
                       Buildings.Fluid.Movers.Preconfigured.Validation.ControlledFlowMachinePreconfigured<br/>
                       Buildings.Fluid.Movers.SpeedControlled_y<br/>
                       Buildings.Fluid.Movers.Validation.BaseClasses.ControlledFlowMachine<br/>
                       Buildings.Fluid.Movers.Validation.BaseClasses.FlowMachine_ZeroFlow<br/>
                       Buildings.Fluid.Movers.Validation.ControlledFlowMachine<br/>
                       Buildings.Fluid.Movers.Validation.ControlledFlowMachineDynamic<br/>
                       Buildings.Fluid.Movers.Validation.PowerSimplified<br/>
                       Buildings.Fluid.Movers.Validation.PumpCurveDerivatives<br/>
                       Buildings.Fluid.Movers.Validation.Pump_stratos<br/>
                       Buildings.Fluid.Movers.Validation.Pump_y_stratos
    </td>
    <td valign=\"top\">Removed or replaced parameters, blocks, and components that were
                       used to support fan or pump models with an rpm input.
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, issue 1704</a>.
    </td>
</tr>
<tr><td valign=\"top\">
                       Buildings.Fluid.Movers.Preconfigured.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.Validation.SpeedControlled_Nrpm
    </td>
    <td valign=\"top\">Moved to the <code>Obsolete</code> package.
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, issue 1704</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface<br/>
                       Buildings.Fluid.Movers.BaseClasses.PowerInterface<br/>
                       Buildings.Fluid.Movers.BaseClasses.Types
    </td>
    <td valign=\"top\">Added computation paths for power and efficiency variables
                       for the Euler number or as a function of part load ratio.
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">issue 2668</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.BaseClasses.Validation.NegativePressureOrFlow
    </td>
    <td valign=\"top\">Remade this model with
                       <a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
                       Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
                       instead of using a full mover model so that forcing a flow
                       rate and a pressure rise is more straightforward.
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">issue 2668</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.Data.Generic<br/>
                       Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface<br/>
                       Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine<br/>
                       Buildings.Fluid.Movers.BaseClasses.Validation.FlowMachineInterface
    </td>
    <td valign=\"top\">Moved the assignment of <code>V_flow_max</code> and <code>haveVMax</code>
                       from <code>Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine</code>
                       to lower-level models.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">issue 2668</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                       Buildings.Fluid.Movers.SpeedControlled_y<br/>
                       Buildings.Fluid.Movers.Data.Generic<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.CronolineIL80slash220dash4slash4<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to8<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to4<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to12<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to8<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos50slash1to12<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos80slash1to12<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS25slash10<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS30slash10<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS30slash5<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS40slash10<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS40slash7<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine50slash150dash4slash2<br/>
                       Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine80slash115dash2comma2slash2<br/>
                       Buildings.Fluid.Movers.Validation.PowerSimplified<br/>
                       Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface
    </td>
    <td valign=\"top\">Refactored the models and data recoreds for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">issue 2668</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_m_flow
    </td>
    <td valign=\"top\">Added assertion to avoid using the model with a head that is
                       significantly higher than the head specified by its performance curve.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1659\">IBPSA, #1659</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
    </td>
</tr><tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.Controls.CollectorPump
    </td>
    <td valign=\"top\">Corrected implementation to make comparison based on total irradiation on tilted surface
                       rather than the direct normal irradiation.
                       This required adding parameters for the azimuth, tilt and ground reflectance.<br/>
                       Added hysteresis to the controller, and changed output signal to be boolean-valued on/off
                       rather than a continuous signal.<br/>
                       Moved the old implementation to <code>Buildings.Obsolete.Fluid.SolarCollectors.Controls</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3074\">#3074</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse</b>
    </td>
</tr><tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer
    </td>
    <td valign=\"top\">Replaced ideal heater with a geothermal heat pump.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Obsolete</b>
    </td>
</tr><tr><td valign=\"top\">Buildings.Obsolete.DistrictHeatingCooling
    </td>
    <td valign=\"top\">Removed package which is no longer supported.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Plotters</b>
    </td>
</tr><tr><td valign=\"top\">Buildings.Utilities.Plotters.Examples.BaseClasses.CoolingCoilValve
    </td>
    <td valign=\"top\">Because of the removal of <code>Logical.And3</code> based on ASHRAE 231P,
                       replaced it with a stack of two <code>Logical.And</code> blocks.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2465\">#2465</a>.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    </td>
    <td valign=\"top\">Corrected input for enabling freeze protection setback mode.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3084\">issue 3084</a>.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Sources.CalendarTime
    </td>
    <td valign=\"top\">Refactored implementation to avoid wrong day number due to rounding errors
                       that caused simultaneous events to not be triggered at the same time.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3199\">issue 3199</a>.
    </td>
  </tr>
  <tr><td colspan=\"2\"><b>Buildings.Electrical.DC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Electrical.DC.Storage.BaseClasses.Charge
    </td>
    <td valign=\"top\">Corrected calculation of power taken from the battery when it is discharged.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3095\">issue 3095</a>.
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
  <tr><td colspan=\"2\"><b>Buildings.Experimental</b>
    </td>
  </tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger
  </td>
  <td valign=\"top\">Assigned dp_nominal to <code>pum1HexChi</code>.<br/>
                     Corrected calculation of heat pump evaporator mass flow control.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3379\">
                     issue 3379</a>.
  </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.HeatPump
  </td>
  <td valign=\"top\">Assigned dp_nominal to condenser pump.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3379\">
                     issue 3379</a>.
  </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Cooling.Indirect
  </td>
  <td valign=\"top\">Fixed building supply temperature controller parameter <code>reverseActing</code>
                     by changing from <code>true</code> to <code>false</code>.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3299\">
                     issue 3299</a>.
  </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Cooling.Direct
  </td>
  <td valign=\"top\">Removed assignment of check valve <code>allowFlowReversal=false</code>.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3389\">#3389</a>.
  </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingTimeSeries
  </td>
  <td valign=\"top\">Applied <code>facMul</code> to domestic hot water load.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3379\">
                     issue 3379</a>.
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
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilDiscretized
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
  <tr><td colspan=\"2\"><b>Buildings.Utilities.Time</b>
    </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Utilities.Time.CalendarTime
    </td>
    <td valign=\"top\">Refactored implementation to avoid wrong day number due to rounding errors
                       that caused simultaneous events to not be triggered at the same time.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3199\">issue 3199</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation
    </td>
    <td valign=\"top\">Corrected assertion for the condition <code>dX_nominal&lt;0</code> and the documentation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3322\">issue 3322</a>.
    </td>
</tr>
</table>
</html>"));
end Version_10_0_0;
