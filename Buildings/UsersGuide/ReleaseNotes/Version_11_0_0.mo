within Buildings.UsersGuide.ReleaseNotes;
class Version_11_0_0 "Version 11.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 11.0.0 is a major release that adds various new packages and models.
</p>
<p>
The library has been tested with
Dymola 2024x,
OpenModelica 1.22.1-1,
OPTIMICA 1.48.2 and recent versions of Impact.
</p>
<p>
The following major changes have been done compared to release 10.1.0:
</p>
<ul>
<li>
A package for central plants with reversible air-to-water heat pumps has been added to <code>Buildings.Templates.Plants.HeatPumps</code>.
The package allows configuration of the type of hydronic integration.
</li>
<li>
The models for 1st to 5th generation district heating and cooling systems have been expanded and revised,
a user guide has been added, and the models have been
moved from the package <code>Buildings.Experimental.DHC</code> to <code>Buildings.DHC</code>.
</li>
<li>
A package for domestic hot water generation and loads that are served by a district system has been added to
<code>Buildings.DHC.Loads.HotWater</code>.
</li>
<li>
The initialization of the Spawn model has been refactored to avoid an iteration between Modelica and EnergyPlus as this
caused numerical problems for some model configurations.
</li>
<li>
The implementation of the blocks for the Control Description Language (CDL), which is being standardized through
ASHRAE Standard 231P, has been revised to comply with the latest draft of the standard.
</li>
<li>
A tutorial for how to build a simple system model has been added to <code>Buildings.Examples.Tutorial.SimpleHouse</code>.
</li>
</ul>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Templates.Plants
    </td>
    <td valign=\"top\">Package with template models for central plants with air-to-water reversible heat pumps, including the plant closed loop control.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.Tutorial.SimpleHouse
    </td>
    <td valign=\"top\">Tutorial for how to build a simple system model.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.HotWater
    </td>
    <td valign=\"top\">Package of models for domestic hot water generation and loads served by district networks.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.DHC.ETS.Combined</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.BaseClasses.PartialHeatPumpHeatExchanger
    </td>
    <td valign=\"top\">Created partial base class to support two versions of the
                       energy transfer station.  One that heats domestic hot
                       water with a heat pump, and one that heats domestic
                       hot water with a heat pump plus storage tank and heat exchanger.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.HeatPumpHeatExchangerDHWTank
    </td>
    <td valign=\"top\">Version of
                       <a href=\"Modelica://Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger\">
                       Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger</a>
                       that heats domestic hot water with a heat pump plus storage tank and heat exchanger.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.BaseClasses.PartialHeatPump
    </td>
    <td valign=\"top\">Partial base class to support two versions of heat pump subsystem.
                       One which directly heats water through condenser, and
                       one which uses the heat pump to heat water in a storage tank,
                       which can be circulated to heat water through a heat exchanger.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.HeatPumpDHWTank
    </td>
    <td valign=\"top\">Uses a heat pump to heat water in a storage tank,
                       which can be circulated to heat domestic hot water through a heat exchanger,
                       modeled with
                       <a href=\"Modelica://Buildings.DHC.Loads.HotWater.StorageTankWithExternalHeatExchanger\">
                       Buildings.DHC.Loads.HotWater.StorageTankWithExternalHeatExchanger</a>.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETSWithDHWTank
    </td>
    <td valign=\"top\">Similar to <a href=\"Modelica://Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETS\">
                       Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETS</a>,
                       but uses <a href=\"Modelica://Buildings.DHC.ETS.Combined.HeatPumpHeatExchangerDHWTank\">
                       Buildings.DHC.ETS.Combined.HeatPumpHeatExchangerDHWTank</a>
                       as the ETS.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.Combined.Examples.BuildingTimeSeriesWithETSDHWTank
    </td>
    <td valign=\"top\">Example model for use of <a href=\"Modelica://Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETSWithDHWTank\">
                       Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETSWithDHWTank</a>.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling
    </td>
    <td valign=\"top\">Ground coupling model <a href=\"Modelica://Buildings.Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling\">
                       Buildings.Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling</a>.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Distribution1Pipe_R
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Distribution1Pipe_R\">
    Buildings.DHC.Networks.Distribution1Pipe_R</a>. One pipe distribution network that uses autosize
    pipes for supply and lossless for connection. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Distribution1PipePlugFlow_v
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Distribution1PipePlugFlow_v\">
    Buildings.DHC.Networks.Distribution1PipePlugFlow_v</a>. One pipe distribution network that uses plugflow
    pipes for supply and lossless for connection. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Distribution2Pipe_R
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Distribution2Pipe_R\">
    Buildings.DHC.Networks.Distribution2Pipe_R</a>. Two pipes network that uses autosize pipes for
    supply and return, and lossless for connection. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks.Connections</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connections.Connection1Pipe_R
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Connections.Connection1Pipe_R\">
    Buildings.DHC.Networks.Connections.Connection1Pipe_R</a>. One pipe connection model using autosize pipes for supply
    and lossless for connection. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connections.Connection1PipePlugFlow_v
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Connections.Connection1PipePlugFlow_v\">
    Buildings.DHC.Networks.Connections.Connection1PipePlugFlow_v</a>. One pipe connection model using plugflow pipes for supply
    and lossless for connection. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connections.Connection2Pipe_R
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Connections.Connection2Pipe_R\">
    Buildings.DHC.Networks.Connections.Connection2Pipe_R</a>. Two pipes connection model using autosize pipes for supply
    and return, lossless for connection. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connections.Examples.Connection1PipeExample
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Connections.Examples.Connection1PipeExample\">
    Buildings.DHC.Networks.Connections.Examples.Connection1PipeExample</a>. Example model for one pipe connections.
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connections.Examples.Connection2PipeExample
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Connections.Examples.Connection2PipeExample\">
    Buildings.DHC.Networks.Connections.Examples.Connection2PipeExample</a>. Example model for two pipes connections.
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Controls.AgentPump1Pipe
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Controls.AgentPump1Pipe\">
    Buildings.DHC.Networks.Controls.AgentPump1Pipe</a>. Agent controller (i.e. borefield, waste heat plant)
    for one pipe networks. This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Controls.Examples.AgentPump1PipeExample
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Controls.Examples.AgentPump1PipeExample\">
    Buildings.DHC.Networks.Controls.Examples.AgentPump1PipeExample</a>. Example model for AgentPump1Pipe.
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Controls.Examples.MainPump1PipeExample
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Networks.Controls.Examples.MainPump1PipeExample\">
    Buildings.DHC.Networks.Controls.Examples.MainPump1PipeExample</a>. Example model for MainPump1PipeExample.
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Examples.Combined</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Examples.Combined.SeriesVariableFlowAgentControl
    </td>
    <td valign=\"top\"> Added <a href=\"Modelica://Buildings.DHC.Examples.Combined.SeriesVariableFlowAgentControl\">
    Buildings.DHC.Examples.Combined.SeriesVariableFlowAgentControl</a>. This example model showcases a more sophisticated way
    of controlling district agent pumps. This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Interpolate<br/>
                       Buildings.Utilities.Math.Examples.Interpolate
    </td>
    <td valign=\"top\">Created a block with an example model for
                       <a href=\"modelica://Buildings.Utilities.Math.Functions.interpolate\">
                       Buildings.Utilities.Math.Functions.interpolate</a>.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1844\">IBPSA, #1844</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller
    </td>
    <td valign=\"top\">Added 2-position relief damper position output <code>y1RelDam</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3526\">issue 3526</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">All classes
    </td>
    <td valign=\"top\">Expanded interface class names to full class names for all classes within <code>Buildings.Controls.OBC.CDL</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3746\">#3746</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Discrete.Examples
    </td>
    <td valign=\"top\">Changed the package name from <code>Examples</code> to <code>Validation</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3517\">issue 3517</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPort<br/>
                       Buildings.Fluid.Interfaces.EightPort
    </td>
    <td valign=\"top\">Corrected dropdown media choice.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1924\">IBPSA #1924</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPort<br/>
                     Buildings.Fluid.Interfaces.PartialTwoPort<br/>
                     Buildings.Fluid.Interfaces.PartialTwoPortVector
    </td>
    <td valign=\"top\">Changed implementation to allow moving fluid connector.
                     This accomodates implementation of models that should have connectors on the top and bottom (such as a tank)
                     and moving of connectors for models that need larger icons.<br/>
                     This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1781\">IBPSA, #1781</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.ETS.Heating</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Heating.Direct
    </td>
    <td valign=\"top\">Documentation corrected for heating.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3628\">issue 3628</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Heating.Indirect
    </td>
    <td valign=\"top\">Documentation corrected for heating.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3628\">issue 3628</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Components.Fans.ArrayVariable
    </td>
    <td valign=\"top\">Refactored with flow rate multiplier.<br/>
                  This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3536\">#3536</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.Building
    </td>
    <td valign=\"top\">Introduced parameter <code>setInitialRadiativeHeatGainToZero</code> and refactored
                     radiative heat exchange between Modelica and EnergyPlus.
                     This was done to avoid iterative solutions between Modelica and EnergyPlus
                     for some coupled simulations that exchange radiative heat transfer, such as from
                     a hydronic radiator.
                     For details, see info section in
                     <code>Buildings.ThermalZones.EnergyPlus_9_6_0.Building</code>.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3707\">Buildings, #3707</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.AirHeating<br/>
                     Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer<br/>
                     Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TRoom<br/>
                     Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.RadiantHeatingCooling_TSurface<br/>
                     Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse.Radiator
    </td>
    <td valign=\"top\">Added insulation to EnergyPlus input data file and resized the system.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3707\">#3707</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone
    </td>
    <td valign=\"top\">Changed radiative heat flow rate sent to EnergyPlus to be the average over the last
                     synchronization time step rather than the instantaneuous value, and set it by default
                     to zero during the initialization. This avoids a
                     nonlinear system of equation during the time integration for models in which
                     the radiative heat gain is a function of the room radiative temperature, such as
                     when a radiator is connected to the room model.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3707\">Buildings, #3707</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007<br/>
                     Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007
    </td>
    <td valign=\"top\">Changed implementation to allow ground temperature to be taken from an input rather than using
                     a constant value.<br/>
                     This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1744\">IBPSA, #1744</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.ETS.BaseClasses  </b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.BaseClasses.Pump_m_flow
    </td>
    <td valign=\"top\"> Updated pump model to use
    to <a href=\"Modelica://Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow\">
    Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow </a>. This change allows to have a better
    estimation of pump default curve using euler number. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.BaseClasses.PartialHeatPumpHeatExchanger
    </td>
    <td valign=\"top\"> Reduced <code>swiFlo.dpValve_nominal</code> to numerically zero to avoid reverse flow. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.ETS.Combined.Subsystems.BaseClasses  </b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.BaseClasses.PartialHeatPump
    </td>
    <td valign=\"top\"> Converted heat pump model to dynamic by changing <code>heaPum.energyDynamics</code> to
    <code>Modelica.Fluid.Types.Dynamics.FixedInitial</code> and added junction on recirculation loop. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Examples.Combined  </b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Examples.Combined.SeriesConstantFlow
    </td>
    <td valign=\"top\"> Added connections that were removed in
    <a href=\"Modelica://Buildings.DHC.Examples.Combined.BaseClasses.PartialSeries\">
    Buildings.DHC.Examples.Combined.BaseClasses.PartialSeries </a>. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Examples.Combined.SeriesVariableFlow
    </td>
    <td valign=\"top\"> Added connections that were removed in
    <a href=\"Modelica://Buildings.DHC.Examples.Combined.BaseClasses.PartialSeries\">
    Buildings.DHC.Examples.Combined.BaseClasses.PartialSeries </a>. This is for
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Sources.ModelTime
    </td>
    <td valign=\"top\">Renamed the block to <code>CivilTime</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3596\">issue 3596</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset
    </td>
    <td valign=\"top\">Renamed the block to <code>TrueHold</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3689\">issue 3689</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Or3<br/>
                       Buildings.Controls.OBC.CDL.Logical.ZeroCrossing<br/>
                       Buildings.Controls.OBC.CDL.Logical.OnOffController<br/>
                       Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid
    </td>
    <td valign=\"top\">Moved the block to the <code>Obsolete</code> package.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">issue 3595</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits
    </td>
    <td valign=\"top\">Added coil type enumeration and removed the coil type flags.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3526\">issue 3526</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller
    </td>
    <td valign=\"top\">Removed the connectors <code>uCooCoi_actual</code> and <code>uHeaCoi_actual</code>,
                       added coil type enumeration and removed the coil type flags.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3526\">issue 3526</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Experimental.DHC
    </td>
    <td valign=\"top\">The package was renamed to <code>Buildings.DHC</code>,
                       and the package <code>DHC.EnergyTransferStations</code> was renamed to
                       <code>DHC.ETS</code>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.BaseClasses.PartialDirect
    </td>
    <td valign=\"top\">Change input <code>TSetDisRet</code> to <code>TDisRetSet</code>.
    </td>
</tr>
    <tr><td valign=\"top\">Buildings.DHC.ETS.BaseClasses.PartialIndirect
    </td>
    <td valign=\"top\">Change input <code>TSetBuiSup</code> to <code>TBuiSupSet</code>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger
    </td>
    <td valign=\"top\">Extend from new partial base class
                       <a href=\"Modelica://Buildings.DHC.ETS.Combined.BaseClasses.PartialHeatPumpHeatExchanger\">
                       Buildings.DHC.ETS.Combined.BaseClasses.PartialHeatPumpHeatExchanger</a>.
                       Evaporator water flow through space heating and domestic how water heat
                       pumps is constant, with dT across district supply and return controlled by three-way mixing valve.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.HeatPump
    </td>
    <td valign=\"top\">Extend from new partial base class
                       <a href=\"Modelica://Buildings.DHC.ETS.Combined.Subsystems.BaseClasses.PartialHeatPump\">
                       Buildings.DHC.ETS.Combined.Subsystems.BaseClasses.PartialHeatPump</a>.
                       Evaporator water flow through heat pump
                       is constant, with dT across district supply and return controlled by three-way mixing valve.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.Validation.HeatPump
    </td>
    <td valign=\"top\">Validation test for
                       <a href=\"Modelica://Buildings.DHC.ETS.Combined.Subsystems.HeatPump\">
                       Buildings.DHC.ETS.Combined.Subsystems.HeatPump</a>.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.Validation.HeatPumpDHWTank
    </td>
    <td valign=\"top\">Validation test for
                       <a href=\"Modelica://Buildings.DHC.ETS.Combined.Subsystems.HeatPumpDHWTank\">
                       Buildings.DHC.ETS.Combined.Subsystems.HeatPumpDHWTank</a>.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETS
    </td>
    <td valign=\"top\">Updated to use new version of
                       <a href=\"Modelica://Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger\">
                       Buildings.DHC.ETS.Combined.HeatPumpHeatExchanger</a>
                       as the ETS.
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3063\">issue 3063</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Combined.Subsystems.BaseClasses.MultipleCommands
    </td>
    <td valign=\"top\">The class has been moved to Buildings.Templates.Components.Controls.MultipleCommands.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3536\">#3536</a>.<br/>
                     This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Plants.Reservoir.Borefield
    </td>
    <td valign=\"top\">Moved to Buildings.DHC.Examples.Combined.BaseClasses.Borefield
                       <a href=\"Modelica://Buildings.DHC.Examples.Combined.BaseClasses.Borefield\"></a>.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3628\">#3628</a>.<br/>
                     This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                       Buildings.Fluid.SolarCollectors.EN12975
    </td>
    <td valign=\"top\">Changed assignment of <code>computeFlowResistance</code> to <code>final</code> based on
                       <code>dp_nominal</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3597\">Buildings, #3597</a>.<br/>
                       This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Obsolete</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Obsolete.Utilities.IO.Python36
    </td>
    <td valign=\"top\">Removed package.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3506\">#3506</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.AirHandlersFans.Data.PartialAirHandler<br/>
                     Buildings.Templates.AirHandlersFans.Data.VAVMultiZone<br/>
                     Buildings.Templates.AirHandlersFans.Interfaces.PartialAirHandler<br/>
                     Buildings.Templates.AirHandlersFans.VAVMultiZone<br/>
                     Buildings.Templates.ZoneEquipment.Data.PartialAirTerminal<br/>
                     Buildings.Templates.ZoneEquipment.Data.VAVBox<br/>
                     Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal<br/>
                     Buildings.Templates.ZoneEquipment.Interfaces.VAVBox<br/>
                     Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly<br/>
                     Buildings.Templates.ZoneEquipment.VAVBoxReheat
    </td>
    <td valign=\"top\">Refactored with a record class for configuration parameters.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3500\">#3500</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Components.Dampers<br/>
                     Buildings.Templates.Components.Valves
    </td>
    <td valign=\"top\">The models in these packages have been retired and replaced
                with two container classes within <code>Buildings.Templates.Components.Actuators</code>
                that cover all equipment types, and allow the flow characteristic to be specified
                with one parameter.<br/>
                             This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3539\">#3539</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.BuriedPipes
    </td>
    <td valign=\"top\">Moved to Buildings.Fluid.FixedResistances.BuriedPipes
                       <a href=\"Modelica://Buildings.Fluid.FixedResistances.BuriedPipes\"></a>.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">#3431</a>.<br/>
                     This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connection2Pipe
    </td>
    <td valign=\"top\">Removed <code>Buildings.DHC.Networks.Connection2Pipe</code>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">#3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connection2PipePlugFlow
    </td>
    <td valign=\"top\"> Moved and renamed <code>Buildings.DHC.Networks.Connection2PipePlugFlow</code>
                     to <a href=\"Modelica://Buildings.DHC.Networks.Connections.Connection2PipePlugFlow_v\">
                     Buildings.DHC.Networks.Connections.Connection2PipePlugFlow_v </a>. Also updated available paremeters
                     for sizing and heatport configuration. This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.<br/>
                     This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Distribution2Pipe
    </td>
    <td valign=\"top\">Removed <code>Buildings.DHC.Networks.Distribution2Pipe</code>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">#3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connection2PipePlugFlow
    </td>
    <td valign=\"top\"> Renamed <code>Buildings.DHC.Networks.Distribution2PipePlugFlow</code>
                     to <a href=\"Modelica://Buildings.DHC.Networks.Distribution2PipePlugFlow_v\">
                     Buildings.DHC.Networks.Distribution2PipePlugFlow_v </a>. Also updated available paremeters
                     for sizing and heatport configuration. This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.<br/>
                     This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Connection2PipePlugFlow
    </td>
    <td valign=\"top\"> Renamed <code>Buildings.DHC.Networks.Controls.MainPump</code>
                     to <a href=\"Modelica://Buildings.DHC.Networks.Controls.MainPump1Pipe\">
                     Buildings.DHC.Networks.Controls.MainPump1Pipe </a>. Also updated available paremeters
                     and documentation. This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.<br/>
                     This change is supported in the conversion script.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks.Combined </b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.UnidirectionalParallel
    </td>
    <td valign=\"top\">Removed <code>Buildings.DHC.Networks.Combined.UnidirectionalParallel</code>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">#3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.UnidirectionalSeries
    </td>
    <td valign=\"top\">Removed <code>Buildings.DHC.Networks.Combined.UnidirectionalSeries</code>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">#3694</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Networks.Combined.BaseClasses </b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.ConnectionParallelAutosize
    </td>
    <td valign=\"top\">Removed <code>Buildings.DHC.Networks.Combined.BaseClasses.ConnectionParallelAutosize</code>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">#3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.ConnectionParallelStandard
    </td>
    <td valign=\"top\">Removed <code>Buildings.DHC.Networks.Combined.BaseClasses.ConnectionParallelStandard</code>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">#3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.ConnectionSeriesAutosize
    </td>
    <td valign=\"top\">Removed <code>Buildings.DHC.Networks.Combined.BaseClasses.ConnectionSeriesAutosize</code>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">#3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.ConnectionSeriesStandard
    </td>
    <td valign=\"top\">Removed <code>Buildings.DHC.Networks.Combined.BaseClasses.ConnectionSeriesStandard</code>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">#3694</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.PipeAutosize
    </td>
    <td valign=\"top\"> Moved <code>Buildings.DHC.Networks.Combined.BaseClasses.PipeAutosize</code>
                     to <a href=\"Modelica://Buildings.DHC.Networks.Pipes.PipeAutosize\">
                     Buildings.DHC.Networks.Pipes.PipeAutosize</a>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.<br/>
                     This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.PipeStandard
    </td>
    <td valign=\"top\"> Moved <code>Buildings.DHC.Networks.Combined.BaseClasses.PipeStandard</code>
                     to <a href=\"Modelica://Buildings.DHC.Networks.Pipes.PipeStandard\">
                     Buildings.DHC.Networks.Pipes.PipeStandard</a>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.<br/>
                     This change is supported in the conversion script.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Networks.Combined.BaseClasses.Validation.Pipe
    </td>
    <td valign=\"top\"> Moved <code>Buildings.DHC.Networks.Combined.BaseClasses.Validation.Pipe</code>
                     to <a href=\"Modelica://Buildings.DHC.Networks.Pipes.Validation.Pipe\">
                     Buildings.DHC.Networks.Pipes.Validation.Pipe</a>.
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3694\">issue 3694</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.Examples.Combined.BaseClasses </b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.Examples.Combined.BaseClasses.PartialSeries
    </td>
    <td valign=\"top\"> Removed several connections to implement
    to <a href=\"Modelica://Buildings.DHC.Examples.Combined.SeriesVariableFlowAgentControl\">
    Buildings.DHC.Examples.Combined.SeriesVariableFlowAgentControl</a>.
    This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.interpolate<br/>
                       Buildings.Utilities.Math.Functions.Examples.Interpolate
    </td>
    <td valign=\"top\">Moved these classes to
                       <a href=\"modelica://Buildings.Utilities.Math.Functions\">
                       Buildings.Utilities.Math.Functions</a>
                       from
                       <a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses\">
                       Buildings.Airflow.Multizone.BaseClasses</a>.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1844\">IBPSA, #1844</a>.<br/>
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
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.AirHandlersFans.Components.Controls.G36VAVMultiZone<br/>
                       Buildings.Templates.AirHandlersFans.Components.Data.OutdoorReliefReturnSection<br/>
                       Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialOutdoorReliefReturnSection<br/>
                       Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialReliefReturnSection<br/>
                       Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.MixedAirWithDamper<br/>
                       Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.NoRelief<br/>
                       Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.NoReturn<br/>
                       Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefDamper<br/>
                       Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefFan<br/>
                       Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan<br/>
                       Buildings.Templates.AirHandlersFans.Configuration.PartialAirHandler<br/>
                       Buildings.Templates.AirHandlersFans.Data.VAVMultiZone<br/>
                       Buildings.Templates.AirHandlersFans.VAVMultiZone
    </td>
    <td valign=\"top\">Added support for additional configurations.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3526\">#3526</a>
                       and <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3520\">#3520</a>.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
</html>"));
end Version_11_0_0;
