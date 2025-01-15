within Buildings.UsersGuide.ReleaseNotes;
class Version_8_0_0 "Version 8.0.0"
  extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 8.0.0 is a major release that contains the first version of the Spawn of EnergyPlus coupling.
The library has been tested with Dymola 2021, JModelica (revision 14023),
and OPTIMICA (revision OCT-stable-r19089_JM-r14295).
</p>
<p>
The following major changes have been done:
</p>
<ul>
<li>
The package <code>Buildings.ThermalZones.EnergyPlus</code>
contains the first version of the Spawn of EnergyPlus coupling that is being developed
at <a href=\"https://lbl-srg.github.io/soep\">https://lbl-srg.github.io/soep</a>.
The Spawn coupling allows to model HVAC and controls in Modelica, and graphically connect to
EnergyPlus models for thermal zones, schedules, EMS actuators and output variables.
This allows for example to model HVAC systems, HVAC controls and controls for active facade systems in Modelica,
and use the EnergyPlus envelope model to simulate heat transfer through the building envelope, including the
heat and light transmission through the windows for the current control signal of the active shade.
</li>
<li>
The package
<code>Buildings.DHC</code> contains models for district heating and cooling systems
that are being developed for the URBANopt District Energy System software.
</li>
<li>
The new media <code>Buildings.Media.Antifreeze.PropyleneGlycolWater</code> allows modeling
of propylene-glycol water mixtures.
</li>
<li>
A new cooling coil model <code>Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU</code>
has been added. This model is applicable for fully-dry, partially-wet, and fully-wet regimes.
In contrast to <code>Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</code> and
to <code>Buildings.Fluid.HeatExchangers.WetCoilDiscretized</code>,
this model uses the epsilon-NTU relationship rather than a spatial discretization of the coil.
This leads to fewer state variables and generally to a faster simulation.
</li>
<li>
New simplified door models for bi-directional air exchange between thermal zones are
implemented in <code>Buildings.Airflow.Multizone</code>.
</li>
<li>
Various other models have been improved or added, in particular for modeling of
control sequences using the Control Description Language that has been developed
in the OpenBuildingControl project at <a href=\"https://obc.lbl.gov\">https://obc.lbl.gov</a>.
</li>
</ul>
</div>
<p>
For more details, please see the release notes below.
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.Validation.BESTEST
    </td>
    <td valign=\"top\">Packages with validation models for the weather data BESTEST.<br/>
                     This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1314\">IBPSA, issue 1314</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Experimental</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC
    </td>
    <td valign=\"top\">Packages for modeling district heating
                       and cooling systems.<br/>
                       These packages contain components supporting the integration within
                       the URBANopt SDK. The development is in progress.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Antifreeze.PropyleneGlycolWater
    </td>
    <td valign=\"top\">Package with medium model for propylene glycol water mixtures.
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1410\">IBPSA, issue 1410</a>.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus
    </td>
    <td valign=\"top\">Package for Spawn of EnergyPlus that couples Modelica directly
                     to the EnergyPlus envelope model.<br/>
                     The models in this package allow simulating the envelope heat transfer
                     of one or several buildings in EnergyPlus, and simulating HVAC and controls
                     in Modelica. EnergyPlus objects are represented graphically as any other Modelica
                     models, and the coupling and co-simulation is done automatically based on these models.
    </td>
</tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.DoorOpen<br/>
                       Buildings.Airflow.Multizone.DoorOperable
    </td>
    <td valign=\"top\">Simplified model for large openings with bi-directional, buoyancy-induced air flow, such as open doors.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1353\">IBPSA, issue 1353</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus
    </td>
    <td valign=\"top\">Find minimum and maximum values regarding the status of zones in one group. This is needed
                       for specifying the group operating mode according to ASHRAE Guideline 36, May 2020 version.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\"># 1893</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints
    </td>
    <td valign=\"top\">Moved from Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints,
                       reimplemented to use the operating mode specified according to ASHRAE G36 official release and changed
                       the heating and cooling demand limit level to be inputs.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\"># 1893</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.PID
    </td>
    <td valign=\"top\">New implementation of the PID controller.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2056\"># 2056</a> and
                       for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2182\"># 2182</a>.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.PIDWithReset
    </td>
    <td valign=\"top\">New implementation of the PID controller with output reset based on a boolean trigger.
                       This implementation allows to reset the output of the controller
                       to a parameter value. (Resetting it to an input was never used and is now removed for simplicity.)<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2056\"># 2056</a> and
                       for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2182\"># 2182</a>.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.TimerAccumulating
    </td>
    <td valign=\"top\">New timer that accumulates time. The output will be reset to zero when the reset input
                       becomes <code>true</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2101\"># 2101</a>.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.Sources.Pulse
    </td>
    <td valign=\"top\"><code>Integer</code> pulse source signal.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2125\"># 2125</a>
                       and <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2282\"># 2282</a>.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable
    </td>
    <td valign=\"top\">Time table for <code>Integer</code> outputs.<br/>
                       Each output is held constant between two consecutive entries in each column of the <code>table</code> parameters.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2125\"># 2125</a>.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable
    </td>
    <td valign=\"top\">Time table for <code>Boolean</code> outputs.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2125\"># 2125</a>.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.SupplyAirTemperature
    </td>
    <td valign=\"top\">Control block for tracking the supply air temperature set point.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\"># 2024</a>.</td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.SupplyAirTemperatureSetpoint
    </td>
    <td valign=\"top\">Computation of the supply air temperature set point based on the operation mode.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\"># 2024</a>.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.TwoWayButterfly
    </td>
    <td valign=\"top\">Two way valve with the flow characteristic of a butterfly valve.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/975\">IBPSA, issue 975</a>.</td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU
    </td>
    <td valign=\"top\">Cooling coil model applicable for fully-dry, partially-wet, and fully-wet regimes.
                       In contrast to <code>Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</code> and
                       to <code>Buildings.Fluid.HeatExchangers.WetCoilDiscretized</code>,
                       this model uses the epsilon-NTU relationship rather than a spatial discretization of the coil.
                       This leads to fewer state variables and generally to a faster simulation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\"># 622</a>.</td>
</tr>
</table>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Air</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV.Examples.Guideline36
    </td>
    <td valign=\"top\">Updated AHU controller which applies the sequence of specifying operating mode
                       according to G36 official release.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\"># 1893</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller
    </td>
    <td valign=\"top\">Changed the default heating maximum airflow setpoint to 30% of the zone nominal airflow.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2172\"># 2172</a>.
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MovingMean<br/>
                       Buildings.Controls.OBC.CDL.Continuous.PID<br/>
                       Buildings.Controls.OBC.CDL.Continuous.PIDWithReset<br/>
                       Buildings.Controls.OBC.CDL.Continuous.SlewRateLimiter<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Sources.Sin<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable<br/>
                       Buildings.Controls.OBC.CDL.Discrete.DayType<br/>
                       Buildings.Controls.OBC.CDL.Discrete.FirstOrderHold<br/>
                       Buildings.Controls.OBC.CDL.Discrete.Sampler<br/>
                       Buildings.Controls.OBC.CDL.Discrete.UnitDelay<br/>
                       Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold<br/>
                       Buildings.Controls.OBC.CDL.Logical.Sources.Pulse<br/>
                       Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger<br/>
                       Buildings.Controls.OBC.CDL.Logical.Timer<br/>
                       Buildings.Controls.OBC.CDL.Logical.TimerAccumulating<br/>
                       Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid<br/>
                       Buildings.Controls.OBC.CDL.Logical.TrueDelay<br/>
                       Buildings.Controls.OBC.CDL.Logical.TrueFalseHold<br/>
                       Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset<br/>
                       Buildings.Controls.OBC.CDL.Psychrometrics.DewPoint_TDryBulPhi<br/>
                       Buildings.Controls.OBC.CDL.Psychrometrics.SpecificEnthalpy_TDryBulPhi<br/>
                       Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi<br/>
                       Buildings.Controls.OBC.Utilities.SetPoints.SupplyReturnTemperatureReset<br/>
                       Buildings.Controls.OBC.CDL.Utilities.SunRiseSet

    </td>
    <td valign=\"top\">Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Greater<br/>
                       Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Less<br/>
                       Buildings.Controls.OBC.CDL.Continuous.LessThreshold
    </td>
    <td valign=\"top\">Added option to specify a hysteresis, which by default is set to <i>0</i>.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.OptimalStart

    </td>
    <td valign=\"top\">Refactored sampling of history of temperature slope to only sample when control error requires optimal start up.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2345\">#2345</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.HydronicHeating.TwoRoomsWithStorage
    </td>
    <td valign=\"top\">Changed <code>dpVal_nominal</code> to 6 kPa.
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2378\">issue 2378</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.Floor
    </td>
    <td valign=\"top\">Refactored model to extend from the newly added <code>Buildings.Examples.VAVReheat.BaseClasses.PartialFloor</code> model.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1502\">issue 1502</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop
    <td valign=\"top\">Declared the rooms in a new model <code>Buildings.Examples.VAVReheat.BaseClasses.Floor</code>
                       to allow use of the model with the Modelica or the Spawn envelope model.<br/>
<tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.ClosedLoop<br/>
                       Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone<br/>
                       Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.TwoFloor_TwoZone<br/>
                       Buildings.Examples.VAVReheat.ASHRAE2006<br/>
                       Buildings.Examples.VAVReheat.Guideline36
    </td>
    <td valign=\"top\">Adapted the model to the updated control of supply air temperature.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">issue 2024</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Guideline36
    </td>
    <td valign=\"top\">Upgraded sequence of specifying operating mode according to G36 official release.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Guideline36
    </td>
    <td valign=\"top\">Change component name <code>yOutDam</code> to <code>yExhDam</code>
                       and update documentation graphic to include relief damper.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2399\">#2399</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.ASHRAE2006
    </td>
    <td valign=\"top\">Update documentation graphic to include relief damper.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2399\">#2399</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.PlugFlowPipe
    </td>
    <td valign=\"top\">Improved calculation of time constant to avoid negative values in some special cases.<br/>
                     This is for
                     <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1427\">IBPSA, issue 1427</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU<br/>
                           Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU<br/>
                           Buildings.Fluid.HeatExchangers.PartialEffectivenessNTU
    </td>
    <td valign=\"top\">Added a warning for when <code>Q_flow_nominal</code> is specified with the wrong sign.
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs<br/>
                           Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance
    </td>
    <td valign=\"top\">Corrected inequality test on <code>alpha</code>,
                       and changed print statement to an assertion with assertion level set to warning.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2009\">issue 2009</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU<br/>
                           Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU<br/>
                           Buildings.Fluid.HeatExchangers.PartialEffectivenessNTU
    </td>
    <td valign=\"top\">Added a warning for when <code>Q_flow_nominal</code> is specified with the wrong sign.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance
    </td>
    <td valign=\"top\">Corrected inequality test on <code>alpha</code>,
                       and changed print statement to an assertion with assertion level set to warning.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2009\">issue 2009</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.EnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.EntropyFlowRate<br/>
                       Buildings.Fluid.Sensors.LatentEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.VolumeFlowRate
    </td>
    <td valign=\"top\">Changed parameter values to use as default a steady-state sensor signal.<br/>
                     This is for
                     <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1406\">IBPSA, issue 1406</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Refrigerants.R410A
    </td>
    <td valign=\"top\">Improved implementation, which now works with OpenModelica.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1414\">IBPSA, issue 1414</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Cryptographics.sha
    </td>
    <td valign=\"top\">Corrected memory leak.
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
<tr><td colspan=\"2\"><b>Buildings.Air</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV
    </td>
    <td valign=\"top\">Updated parameters of the two HVAC controllers such as PI gains, damper positions,
                       and supply air temperature limits to make example models comparable.
                       Added CO2 monitoring.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1608</a>.
</tr>
<tr><td valign=\"top\">Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizerController
    </td>
    <td valign=\"top\">Moved and renamed to
                       <code>Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerChillerDXHeatingEconomizer</code>.
                       Also a bug fix was implemented that enables the fan when cooling needed during unoccupied hours.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2265\">issue 2265</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.Continuous</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.Continuous.LimPID<br/>
                       Buildings.Controls.Continuous.PIDHysteresis<br/>
                       Buildings.Controls.Continuous.PIDHysteresisTimer
    </td>
    <td valign=\"top\">Corrected wrong convention of reverse and direct action.
                       The previous parameter <code>reverseAction</code> with a default of <code>false</code>
                       has been removed, and
                       a new parameter <code>reverseActing</code> with a default of <code>true</code>
                       has been added. This was done because the previous implementation wrongly interpreted reverse action
                       as the control output changing in reverse to the change in control error, but the
                       industry convention is that reverse action means that the control output
                       changes in reverse to the measurement signal.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1365\">IBPSA, #1365</a>.<br/>
                       For Dymola, a conversion script makes this change.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulation
    </td>
    <td valign=\"top\">Removed parameter <code>samplePeriod</code> and removed delay on actuator signal
                       to avoid a large delay in this feedback loop.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue 2454</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller
    </td>
    <td valign=\"top\">Updated the block of specifying operating mode and setpoints.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    </td>
    <td valign=\"top\">Upgraded the sequence according to ASHRAE Guideline 36, May 2020 version.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">issue 1893</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL.Continuous</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.ChangeSign<br/>
                       Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold
    </td>
    <td valign=\"top\">Moved blocks to <code>Obsolete</code> package because they can be implemented with other blocks
                       and have only rarely been used.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2134\">issue 2134</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
    </td>
    <td valign=\"top\">Corrected wrong convention of reverse and direct action.
                       The previous parameter <code>reverseAction</code> with a default of <code>false</code>
                       has been removed, and
                       a new parameter <code>reverseActing</code> with a default of <code>true</code>
                       has been added. This was done because the previous implementation wrongly interpreted reverse action
                       as the control output changing in reverse to the change in control error, but the
                       industry convention is that reverse action means that the control output
                       changes in reverse to the measurement signal.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1365\">IBPSA, #1365</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
    </td>
    <td valign=\"top\">Moved model to <code>Building.Obsolete.Controls.OBC.CDL.Continuous</code>.<br/>
                       Instead of this model, use the new model <code>Buildings.Controls.Continuous.PID</code> or
                       <code>Buildings.Controls.Continuous.PIDWithReset</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2056\">issue 2056</a>.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold<br/>
                       Buildings.Controls.OBC.CDL.Continuous.GreaterEqual<br/>
                       Buildings.Controls.OBC.CDL.Continuous.LessEqualThreshold<br/>
                       Buildings.Controls.OBC.CDL.Continuous.LessEqual
    </td>
    <td valign=\"top\">Moved blocks to obsolete package. Instead of these blocks, use the ones that
                       do not contain the word <code>Equal</code>
                       in their name. This was done because for real-valued, measured quantities, there is
                       no reason to distinguish between weak and strict inequality
                       (due to sensor noise, or within a simulation, due to solver noise or rounding errors).<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2076\">#2076</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold<br/>
                       Buildings.Controls.OBC.CDL.Continuous.LessThreshold<br/>
                       Buildings.Controls.OBC.CDL.Continuous.NumberOfRequests
    </td>
    <td valign=\"top\">Renamed parameter <code>threshold</code> to <code>t</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2076\">#2076</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.NumberOfRequests
    </td>
    <td valign=\"top\">Moved block to obsolete package because this block is not needed,
                       and it would need to be refactored to add hysteresis.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2124\">#2124</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse
    </td>
    <td valign=\"top\">Removed <code>startTime</code> parameter. Introduced <code>shift</code> parameter.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">issue 2170</a>
                       and <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2282\">issue 2282</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse
    </td>
    <td valign=\"top\">Removed parameter <code>nperiod</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">issue 2170</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL.Logical</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch<br/>
                       Buildings.Controls.OBC.CDL.Logical.Toggle
    </td>
    <td valign=\"top\">Removed the parameter <code>pre_y_start</code>, and made the initial output to be equal to
                       latch or toggle input when the clear input is <code>false</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2177\">#2177</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Timer
    </td>
    <td valign=\"top\">Removed <code>reset</code> boolean input and added boolean output <code>passed</code>
                       to show if the time becomes greater than threshold time.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2101\">#2101</a>.
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger<br/>
                       Buildings.Controls.OBC.CDL.Logical.Sources.Pulse
    </td>
    <td valign=\"top\">Removed <code>startTime</code> parameter. Introduced <code>shift</code> parameter.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">issue 2170</a>
                       and <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2282\">issue 2282</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL.Integers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold<br/>
                       Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold<br/>
                       Buildings.Controls.OBC.CDL.Integers.GreaterThreshold<br/>
                       Buildings.Controls.OBC.CDL.Integers.LessThreshold
    </td>
    <td valign=\"top\">Renamed parameter <code>threshold</code> to <code>t</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2076\">#2076</a>.<br/>
                       For Dymola, a conversion script makes this change.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL.Psychrometrics</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Psychrometrics.TDewPoi_TDryBulPhi<br/>
                       Buildings.Controls.OBC.CDL.Psychrometrics.TWetBul_TDryBulPhi<br/>
                       Buildings.Controls.OBC.CDL.Psychrometrics.h_TDryBulPhi
    </td>
    <td valign=\"top\">Renamed blocks and removed input connector for pressure.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2139\">#2139</a>.<br/>
                       For Dymola, a conversion script will rename existing instance to use
                       the old versions which have been moved to the <code>Buildings.Obsolete</code> package.</td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.SetPoints
    </td>
    <td valign=\"top\">Moved package from <code>Buildings.Controls.OBC.CDL.SetPoints</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2355\">#2355</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.UnitConversions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.UnitConversions.From_Btu<br/>
                       Buildings.Controls.OBC.UnitConversions.From_quad<br/>
                       Buildings.Controls.OBC.UnitConversions.To_Btu<br/>
                       Buildings.Controls.OBC.UnitConversions.To_quad
    </td>
    <td valign=\"top\">Corrected quantity from <code>Work</code> to <code>Energy</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2245\">#2245</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.ASHRAE2006<br/>
                     Buildings.Examples.VAVReheat.Guideline36<br/>
                     Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop
    </td>
    <td valign=\"top\">Refactored model to implement the economizer dampers directly in
    <code>Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</code> rather than through the
    model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
    this leads to simpler equations.
    <br/> This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.VAVBranch
    </td>
    <td valign=\"top\">Moved to <code>Buildings.Obsolete.Examples.VAVReheat.BaseClasses.VAVBranch</code>
    and replaced by <code>Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox</code>.
    <br/> This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2059\">issue #2059</a>.
    <br/> For Dymola, a conversion script makes this change.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.Economizer
    </td>
    <td valign=\"top\">Updated the block with an input for enabling outdoor air damper opening and an input for
                     economizer cooling signal.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">issue 2024</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.EconomizerTemperatureControl
    </td>
    <td valign=\"top\">This block is now retired.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">issue 2024</a>.
<tr><td colspan=\"2\"><b>Buildings.Experimental</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Experimental.DistrictHeatingCooling
    </td>
    <td valign=\"top\">Moved package to <code>Buildings.Obsolete.DistrictHeatingCooling</code>.<br/>
                       Generic components for DHC system modeling are now developed under
                       <code>Buildings.DHC</code>.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Applications.DataCenters.ChillerCooled.Equipment</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.FourPortResistanceChillerWSE<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialChillerWSE<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialCoolingCoilHumidifyingHeating<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialHeatExchanger<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialIntegratedPrimary<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPlantParallel<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPumpParallel<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.ThreeWayValveParameters<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryPlantSide<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimarySecondary<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.NonIntegrated<br/>
                        Buildings.Applications.DataCenters.ChillerCooled.Equipment.WatersideEconomizer
    </td>
    <td valign=\"top\">Corrected fixed flow resistance settings and added ideal mixing junctions.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2446\">issue 2446</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL.Integers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.Change
    </td>
    <td valign=\"top\">Corrected initialization of previous value of input to use the current input rather than <code>0</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2294\">issue 2294</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL.Continuous</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Greater<br/>
                       Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold<br/>
                       Buildings.Controls.OBC.CDL.Continuous.Less<br/>
                       Buildings.Controls.OBC.CDL.Continuous.LessThreshold
    </td>
    <td valign=\"top\">Corrected documentation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2246\">issue 2246</a>.
    </td>
</tr>
</table>
<p>
Note:
</p>
<ul>
<li>
This version also corrects a possible memory violation when reading weather data files that have very long lines,
as reported in <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1432\">IBPSA, #1432</a>.
</li>
</ul>
</html>"));
end Version_8_0_0;
