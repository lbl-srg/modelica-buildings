within Buildings.UsersGuide.ReleaseNotes;
class Version_7_0_0 "Version 7.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
    <div class=\"release-summary\">
    <p>
    Version 7.0.0 is a major release that
    contains various new packages, new models and improvements to existing models.
    The library has been tested with
    Dymola 2020x and 2021,
    JModelica (revision 14023), and
    OPTIMICA (revision OCT-stable-r12473_JM-r14295).
    </p>
    <p>
      The following major changes have been done:
    <ul>
    <li>
      New packages have been added to model building controls (<code>Buildings.Controls.OBC.Utilities</code>)
      and to support the creation of emulators that compare the performance of building control sequences in
      the Building Optimization Performance Tests framework
      <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>.
    </li>
    <li>
      Various new control blocks have been added to <code>Buildings.Controls.OBC.CDL</code>.
    </li>
    <li>
      Various new equipment models have been added, such as models of absorption chillers, CHP equipment and heat pumps.
    </li>
    <li>
      The reduced order building models now also allow modeling air moisture and air contaminant balance.
    </li>
    <li>
      A tutorial has been added to explain how to implement control sequences using the Control Description Language
      that is being developed in the <a href=\"https://obc.lbl.gov\">OpenBuildingControl</a> project.
    </li>
    <li>
      The icons of many components have been updated so that they visualize temperatures, flow rates
      or control signals while the simulation is running.
    </li>
    <li>
      Results of the ANSI/ASHRAE Standard 14 validation (BESTEST) are now integrated in the user's guide
      <code>Buildings.ThermalZones.Detailed.Validation.BESTEST.UsersGuide</code>.
    </li>
    </ul>
    </div>
    <!-- New libraries -->
    <p>
    The following <b style=\"color:blue\">new libraries</b> have been added:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
    <tr><td valign=\"top\">Buildings.Controls.OBC.Utilities
        </td>
        <td valign=\"top\">Package with utility blocks, base classes and validation
                           models for the OpenBuildingControl (OBC) library.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.SignalExchange
        </td>
        <td valign=\"top\">Package with blocks that can be used
                           to identify and activate control signal overwrites, and
                           to identify and read sensor signals. This package is used
                           by the Building Optimization Performance Test software
                           <a href=\"https://github.com/ibpsa/project1-boptest\">BOPTEST</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.Python36
        </td>
        <td valign=\"top\">Upgraded from <code>Buildings.Utilities.IO.Python27</code>
                           since Python2.7 has been deprecated.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1760\">issue #1760</a>.
        </td>
    </tr>
    </table>
    <!-- New components for existing libraries -->
    <p>
    The following <b style=\"color:blue\">new components</b> have been added
    to <b style=\"color:blue\">existing</b> libraries:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Controls</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow
        </td>
        <td valign=\"top\">Package of sequences for specifying the minimum outdoor airflow rate.
                           This replaces <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow</code>.
                           The new implemented sequences separate zone level calculation from the system level calculation.
                           It avoids vector-valued calculations.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus
        </td>
        <td valign=\"top\">Block that outputs zone temperature status by comparing it with setpoint temperatures, with the maximum and
                           minimum temperature of the group which the zone is in. This allows separating the vector-valued calculations
                           from control sequences.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>.
        </td>
      </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean
        </td>
        <td valign=\"top\">Block that outputs the triggered discrete moving mean of an input signal.
                           This replaces <code>Buildings.Controls.OBC.CDL.Discrete.MovingMean</code>, which
                           has been moved to <code>Buildings.Obsolete</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1588\">#1588</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.OptimalStart
        </td>
        <td valign=\"top\">Block that outputs optimal start time for an HVAC system prior to the occupancy.
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1589\">#1589</a>.
        </td>
        </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayTable
        </td>
        <td valign=\"top\">Three way valves with opening characteristics based on a user-provided table.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.CHPs
        </td>
        <td valign=\"top\">Package with model for combined heat and power device.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Chillers.AbsorptionIndirectSteam
        </td>
        <td valign=\"top\">Indirect steam heated absorption chiller based on performance curves.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.FixedResistances.CheckValve
        </td>
        <td valign=\"top\">Check valve that prevents backflow, except for a small leakage flow rate.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1198\">IBPSA, #1198</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.EquationFitReversible
        </td>
        <td valign=\"top\">Heat pump model that can be reversed between heating and cooling mode,
                           that takes as a set point the leaving fluid temperature, and that computes
                           its performance based on an equation fit.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples.Tutorial</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.Tutorial.CDL
        </td>
        <td valign=\"top\">Tutorial that explains how to implement control sequences using
                           the <a href=\"https://obc.lbl.gov\">Control Description Language</a>.
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
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
        </td>
        <td valign=\"top\">Refactored weather data reader and changed implementation to allow exactly zero radiation rather
                           than a small positive value.
                           This was required to allow simulating buildings at steady-state, which is needed
                           for some controls design.
                           For examples in which buildings are simulated at steady-state, see
                           <code>Buildings.ThermalZones.Detailed.Validation.MixedAirFreeResponseSteadyState</code>,
                           <code>Buildings.Examples.VAVReheat.Validation.Guideline36SteadyState</code> and
                           <code>Buildings.ThermalZones.ReducedOrder.Validation.RoomSteadyState</code>.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1340\">IBPSA, #1340</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.Continuous</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.Continuous.LimPID
        </td>
        <td valign=\"top\">Removed homotopy that may be used during initialization to ensure that outputs are bounded.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1221\">IBPSA, #1221</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Derivative
        </td>
        <td valign=\"top\">Removed parameter <code>initType</code> and <code>x_start</code>.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1887\">IBPSA, #1887</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset
        </td>
        <td valign=\"top\">Removed parameter <code>initType</code>.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1887\">IBPSA, #1887</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>

    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
        </td>
        <td valign=\"top\">Removed homotopy that may be used during initialization to ensure that outputs are bounded.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1221\">IBPSA, #1221</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime<br/>
                           Buildings.Controls.OBC.CDL.Types.ZeroTime
        </td>
        <td valign=\"top\">Revised implementation such that the meaning of <code>time</code> is better explained
                           and unix time stamps are correctly defined with respect to GMT.
                           Added option unix time stamp GMT.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1232\">IBPSA, #1232</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime<br/>
                           Buildings.Controls.OBC.CDL.Types.ZeroTime
        </td>
        <td valign=\"top\">Revised implementation such that the meaning of <code>time</code> is better explained
                           and unix time stamps are correctly defined with respect to GMT.
                           Added option unix time stamp GMT.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1232\">IBPSA, #1232</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch<br/>
                         Buildings.Controls.OBC.CDL.Logical.Toggle
        </td>
        <td valign=\"top\">Simplified implementation, which makes them work with OpenModelica.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1823\">#1823</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Timer
        </td>
        <td valign=\"top\">Added a boolean input to reset the accumulated timer.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1221\">#1221</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Types.Init
        </td>
        <td valign=\"top\">Removed this enumeration because it is no longer used.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1887\">#1887</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1 </b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond
        </td>
        <td valign=\"top\">Corrected to delay the true initial device status.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1876\">#1876</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves
        </td>
        <td valign=\"top\">Replaced multisum block with add blocks, replaced gain block used for normalization
                           with division block.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1830\">#1830</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller
        </td>
        <td valign=\"top\">Replaced the mode and setpoint calculation block with
                           <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
        </td>
        <td valign=\"top\">Used hysteresis to check occupancy.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1788\">#1788</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutsideAirFlow
        </td>
        <td valign=\"top\">Applied hysteresis for checking ventilation efficiency.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1787\">#1787</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond
        </td>
        <td valign=\"top\">Added assertions and corrected implementation when respond amount is negative.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1530\">#1503</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples.Tutorial</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.Tutorial.Boiler<br/>
                           Buildings.Examples.Tutorial.SpaceCooling
        </td>
        <td valign=\"top\">Updated examples to use the control blocks from the Control Description Language package
                           <code>Buildings.Controls.OBC.CDL</code>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.VAVBranch
        </td>
        <td valign=\"top\">Added output connector for returned damper position.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Actuators.BaseClasses.ActuatorSignal<br/>
                           Buildings.Fluid.Actuators.Dampers.PressureIndependent
        </td>
        <td valign=\"top\">Added the computation of the damper opening.
        </td>
    </tr>
    <tr><td valign=\"top\">
                           Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayPolynomial<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening<br/>
                           Buildings.Fluid.Actuators.Valves.TwoWayTable
        </td>
        <td valign=\"top\">Improved implementation to guard against control input that is negative.
                           The new implementation constrains the input to be bigger than <i>0</i>.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1233\">IBPSA, #1233</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.shaGFunction
        </td>
        <td valign=\"top\">Declared string as a constant due to JModelica's tigther type checking.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1230\">IBPSA, #1230</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.DXSystems.AirCooled.MultiStage<br/>
                           Buildings.Fluid.DXSystems.AirCooled.SingleSpeed<br/>
                           Buildings.Fluid.DXSystems.AirCooled.VariableSpeed<br/>
                           Buildings.Fluid.DXSystems.WaterCooled.MultiStage<br/>
                           Buildings.Fluid.DXSystems.WaterCooled.SingleSpeed<br/>
                           Buildings.Fluid.DXSystems.WaterCooled.VariableSpeed
        </td>
        <td valign=\"top\">Corrected wrong <code>min</code> and <code>max</code> attribute for change in humidity.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1933\">#1933</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Storage.Stratified<br/>
                           Buildings.Fluid.Storage.StratifiedEnhanced<br/>
                           Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
        </td>
        <td valign=\"top\">Provided option to initialize the tank temperature at different values across the height of the tank.<br/>
        This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1246\">IBPSA, #1246</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector
        </td>
        <td valign=\"top\">In volume, set <code>prescribedHeatFlowRate=false</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1636\">#1636</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.HeatTransfer.Convection.Exterior
        </td>
        <td valign=\"top\">Set wind direction modifier to a constant as wind speed approaches zero.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1923\">#1923</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600<br/>
                           Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF
        </td>
        <td valign=\"top\">Changed computation of time averaged values to avoid a time event every hour.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1714\">#1714</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.TwoElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.ThreeElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.FourElements
        </td>
        <td valign=\"top\">Added option to also simulate moisture balance in room air volume.
                           This can be enabled by setting the parameter <code>use_moisture_balance = true</code>.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1209\">IBPSA, #1209</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.Files.CSVWriter<br/>
                           Buildings.Utilities.IO.Files.CombiTimeTableWriter<br/>
                           Buildings.Utilities.IO.Files.CombiTimeTableWriter
        </td>
        <td valign=\"top\">Revised to avoid overflow of string buffer in Dymola.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1219\">IBPSA, #1219</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Math.SmoothHeaviside<br/>
                           Buildings.Utilities.Math.Functions.SmoothHeaviside
        </td>
        <td valign=\"top\">This function is now twice instead of only once Lipschitz continuously differentiable.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1202\">IBPSA, #1202</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Time.CalendarTime<br/>
                           Buildings.Utilities.Time.Types.ZeroTime
        </td>
        <td valign=\"top\">Revised implementation such that the meaning of <code>time</code> is better explained
                           and unix time stamps are correctly defined with respect to GMT.
                           Added option unix time stamp GMT.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1192\">IBPSA, #1192</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Comfort.Fanger
        </td>
        <td valign=\"top\">Updated the model from ASHRAE 1997 to ANSI/ASHRAE 55-2017
                           and added a validation model which compares the PMV
                           with an implementation from the University of California at Berkeley.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1936\">#1936</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.Floor<br/>
                           Buildings.Examples.VAVReheat.ASHRAE2006<br/>
                           Buildings.Examples.VAVReheat.Guideline36<br/>
                           Buildings.Examples.DualFanDualDuct

        </td>
        <td valign=\"top\">Updated core zone geometry parameters related to room heat and mass balance.
                           This change was done in
                           <code>Buildings.Examples.VAVReheat.BaseClasses.Floor</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1719\">#1719</a>.
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
    <tr><td valign=\"top\">Buildings.Airflow.Multizone
        </td>
        <td valign=\"top\">Set parameters <code>m_flow_small</code>, <code>m1_flow_small</code>
                           and <code>m2_flow_small</code> to <code>final</code> so that they do
                           no longer appear on the GUI. These parameters are not used by models
                           in this package.
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1362\">IBPSA, #1362</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
        </td>
        <td valign=\"top\">Refactored model so that it is itself a CDL conformant composite block.
                           This refactoring removes the no longer use parameters <code>xd_start</code> that was
                           used to initialize the state of the derivative term. This state is now initialized
                           based on the requested initial output <code>yd_start</code> which is a new parameter
                           with a default of <code>0</code>.
                           Also, removed the parameters <code>y_start</code> and <code>initType</code> because
                           the initial output of the controller can be set by using <code>xi_start</code>
                           and <code>yd_start</code>.
                           This refactoring also removes the parameter <code>strict</code> that
                           was used in the output limiter. The new implementation enforces a strict check by default.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1878\">#1878</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
        </td>
        <td valign=\"top\">Changed the default values for the output limiter from <code>yMin=-yMax</code> to <code>yMin=0</code>
                           and from <code>yMax</code> being unspecified to <code>yMax=1</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1888\">#1888</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Discrete.MovingMean
        </td>
        <td valign=\"top\">This block became obsolete, use <code>Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean</code> instead.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.SetPoints.SupplyReturnTemperatureReset
        </td>
        <td valign=\"top\">Changed name from <code>HotWaterTemperatureReset</code> to <code>SupplyReturnTemperatureReset</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/860\">#860</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller
        </td>
        <td valign=\"top\">Reimplemented to add new block for specifying the minimum outdoor airfow setpoint.
                           The new block avoids vector-valued calculations.<br/>
                           The reimplemented controller needs to work with
                           <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone</code> and
                           <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone</code>,
                           to calculate the zone level minimum outdoor airflow setpoints and then find the sum, the minimum and
                           the maximum of these setpoints. See
                           <code>Buildings.Examples.VAVReheat.Guideline36</code>.
                           <br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
        </td>
        <td valign=\"top\">Reimplemented to remove the vector-valued calculations.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ModeAndSetPoints
        </td>
        <td valign=\"top\">Removed from the library as it can be replaced by
                           <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">#1709</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller
        </td>
        <td valign=\"top\">Added cooling coil control and the controller validation model.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1265\">#1265</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Enable
        </td>
        <td valign=\"top\">Added the option to allow fixed plus differential dry bulb temperature cutoff.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Subsequences.Modulation
        </td>
        <td valign=\"top\">Added heating coil control sequences.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
        </td>
        <td valign=\"top\">Added a switch for fan control.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ZoneState
        </td>
        <td valign=\"top\">Improved the implementation to avoid issues when heating and cooling controls occur at the same time.
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests
        </td>
        <td valign=\"top\">Changed the actual damper position name from <code>uDam</code> to <code>yDam_actual</code>.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller
        </td>
        <td valign=\"top\">Added actual VAV damper position as the input for generating system request.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves
        </td>
        <td valign=\"top\">Added option to check if the VAV damper is pressure independent.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.SetPoints</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.SetPoints.SupplyReturnTemperatureReset
        </td>
        <td valign=\"top\">Changed name from <code>HotWaterTemperatureReset</code> to <code>SupplyReturnTemperatureReset</code>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/860\">#860</a>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Actuators</b>
        </td>
    </tr>
    <tr><td valign=\"top\">
                           Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential<br/>
                           Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                           Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                           Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                           Buildings.Fluid.Actuators.Dampers.PressureIndependent<br/>
                           Buildings.Fluid.Actuators.Dampers.VAVBoxExponential
        </td>
        <td valign=\"top\">Merged <code>VAVBoxExponential</code> into <code>Exponential</code>.<br/>
                           <code>Exponential</code> now provides all modeling capabilities previously
                           implemented in <code>VAVBoxExponential</code> which is no more needed and
                           has been removed from the library.<br/>
                           New parameters <code>dpDamper_nominal</code> and <code>dpFixed_nominal</code>
                           have been introduced in <code>Exponential</code>, consistent with the
                           valve models.<br/>
                           Parameter <code>k0</code> has been replaced by a leakage coefficient.<br/>
                           For Dymola, a conversion script makes this change. However the script will
                           not make the <code>each</code> keyword persist in array declarations. The
                           keyword will have to be manually reintroduced after applying the script.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1188\">IBPSA, #1188</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
        </td>
    </tr>
    <tr><td valign=\"top\">
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.ThreeElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.ThreeElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.TwoElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.TwoElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.FourElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.FourElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.OneElement<br/>
                           Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses.PartialVDI6007<br/>
                           Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses.PartialVDI6007<br/>
                           Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.VDI6007WithWindow

        </td>
        <td valign=\"top\">Renamed convection coefficient from <code>alpha*</code> to <code>hCon*</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1168\">IBPSA, #1168</a>.
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
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable
        </td>
        <td valign=\"top\">Corrected implementation so that it gives the correct periodicity
                         of the table if the simulation starts at a negative time.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1834\">1834</a>.
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
                           Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimpleOriented<br/>
                           Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimpleOriented_N<br/>
                           Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.PVsimple_N<br/>
                           Buildings.Electrical.Interfaces.PartialPV
        </td>
        <td valign=\"top\">Corrected model so that reported power <code>P</code> also includes the DCAC conversion.
                           Note that the power added to the elecrical system was correct, but the power reported in
                           the output connector <code>P</code> did not include this conversion factor.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1577\">1577</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Electrical.AC.OnePhase.Storage.Battery<br/>
                         Buildings.Electrical.AC.ThreePhasesBalanced.Storage.Battery
    </td>
      <td valign=\"top\">Corrected model and improved the documentation. The previous model extracted from
                       the AC connector the input power <code>P</code> plus the AC/DC conversion losses, but <code>P</code>
                       should be the power exchanged at the AC connector. Conversion losses are now only
                       accounted for in the energy exchange at the battery.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1865\">1865</a>.
      </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.ASHRAE2006<br/>
                           Buildings.Examples.VAVReheat.Guideline36
        </td>
        <td valign=\"top\">Connected actual VAV damper position as the measured input data for
                           defining duct static pressure setpoint.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.DuctStaticPressureSetpoint
        </td>
        <td valign=\"top\">Reverse action changed to <code>true</code> for the pressure set-point controller.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.RoomVAV
        </td>
        <td valign=\"top\">Refactored the model to implement a single maximum control logic.
                           The previous implementation led to a maximum air flow rate in heating demand.<br/>
                           The input connector <code>TDis</code> is removed. This is non backward compatible.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc<br/>
                           Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.normalizedPower
        </td>
        <td valign=\"top\">Corrected error in computing the cooling tower fan power consumption.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1691\">1691</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings/Resources/Python-Sources/KalmanFilter.py<br/>
                           Buildings.Utilities.IO.Python27.Examples.KalmanFilter
        </td>
        <td valign=\"top\">Changed the temporary file format from <code>pickle</code> to <code>json</code> as the former can trigger a
                           segfault with JModelica simulation run in a subprocess.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1587\">Buildings, #1587</a>.
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
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.LimPID
        </td>
        <td valign=\"top\">Removed wrong unit declaration for gain <code>k</code>.<br/>
                           This is for
                           <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1821\">Buildings, #1821</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Sources.Boundary_pT<br/>
                           Buildings.Fluid.Sources.Boundary_ph<br/>
                           Buildings.Fluid.Sources.MassFlowSource_T<br/>
                           Buildings.Fluid.Sources.MassFlowSource_h
        </td>
        <td valign=\"top\">Refactored handling of mass fractions which was needed to handle media such as
                           <code>Modelica.Media.IdealGases.MixtureGases.FlueGasSixComponents</code> and
                           <code>Modelica.Media.IdealGases.MixtureGases.SimpleNaturalGas</code>.<br/>
                           Prior to this change, use of these media led to a translation error.<br/>
                           This is for
                           <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1205\">IBPSA, #1205</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallTwoWindows<br/>
                           Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallWithWindow
        </td>
        <td valign=\"top\">Corrected wrong assignment of a parameter.<br/>
                           This is for
                           <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1766\">IBPSA, #1766</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings/Resources</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings/Resources/C-Sources/cryptographicsHash.c
        </td>
        <td valign=\"top\">Add a <code>#ifndef</code> clause.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1278\">IBPSA, #1278</a>.
        </td>
    </tr>
    </table>
    <!-- Obsolete components -->
    <p>
    The following components have become <b style=\"color:blue\">obsolete</b>:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Obsolete</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Obsolete.Controls.OBC.CDL.Discrete.MovingMean
        </td>
        <td valign=\"top\">The block <code>Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean</code>
                           replaced the original <code>MovingMean</code> block.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-buildings/issues/1588\">#1588</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Obsolete.Utilities.IO.Python27
        </td>
        <td valign=\"top\">The package <code>Buildings.Utilities.IO.Python27</code>
                           has been upgraded to <code>Buildings.Utilities.IO.Python36</code>.<br/>
                           For Dymola, a conversion script moves the Python27 package to here.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-buildings/issues/1760\">issue #1760</a>.
        </td>
    </tr>
    </table>
     </html>"));
end Version_7_0_0;
