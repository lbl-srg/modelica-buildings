within Buildings.UsersGuide.ReleaseNotes;
class Version_6_0_0 "Version 6.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
    <div class=\"release-summary\">
   <p>
   Version 6.0.0 is a major new release that
   contains various new packages, new models and improvements to existing models.
   The library has been tested with Dymola 2019FD01 and with JModelica (revision 12903).
   </p>
   <p>
     The following major changes have been done:
   <ul>
   <li>
     Various new packages have been added, such as:
     <ul>
       <li>
         A package for simulating occupancy and occupancy that resulted from IEA EBC Annex 66.
       </li>
       <li>
         A package with models for geothermal borefields.
       </li>
       <li>
         A package with blocks for control of shades and of outdoor lights.
       </li>
       <li>
         A package with blocks that allow generating time series and scatter plots,
         and writing these plots to one or several html files.
       </li>
       <li>
         A package with blocks for unit conversion.
       </li>
     </ul>
   </li>
   <li>
     Various new control blocks have been added to <code>Buildings.Controls.OBC.CDL</code>.
   </li>
   </ul>
    </div>
    <!-- New libraries -->
    <p>
    The following <b style=\"color:blue\">new libraries</b> have been added:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
    <tr><td valign=\"top\">Buildings.Controls.OBC.OutdoorLights
        </td>
        <td valign=\"top\">Package with outdoor lighting controllers.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.Shade
        </td>
        <td valign=\"top\">Package with shade controllers.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.UnitConversions
        </td>
        <td valign=\"top\">Package with blocks for unit conversion.
                           Blocks in this package are meant to use when reading
                           data from a building automation system,
                           or writing data to a building automation system,
                           that uses units that are different
                           from the units used by Modelica.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Geothermal
        </td>
        <td valign=\"top\">Package with models for geothermal heat exchangers.
                           This package has models for borefields with vertical boreholes,
                           and for a single vertical borehole with a U-tube heat exchanger.
                           The borefield models can have any geometrical configuration,
                           and either one or two U-tube heat exchangers.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Occupants
       </td>
       <td valign=\"top\">Package with occupant behavior models and functions to
                          simulate the occupancy and the interaction of occupants
                          with air-conditioning and heating systems, windows,
                          blinds, and lighting in residential and office buildings.
       </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Cryptographics
        </td>
        <td valign=\"top\">Package with a function to compute a SHA1 encrypted string.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.Files
    </td>
    <td valign=\"top\">Package with blocks to write CSV files, JSON files or combi time table files.
    </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Plotters
       </td>
       <td valign=\"top\">Package with blocks that allow generating
                          time series and scatter plots, and writing these plots to
                          one or several html files.
                          The plots can be deactivated based on an input signal and a time
                          delay, for example, to plot data only while the HVAC system
                          operates for at least <i>30</i> minutes.
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
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MultiOr
        </td>
        <td valign=\"top\">Block that outputs true boolean signal if and only if any element of the boolean input vector is true.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MatrixMin
        </td>
        <td valign=\"top\">Block that outputs vector of row- or column-wise minimum values.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MatrixMax
        </td>
        <td valign=\"top\">Block that outputs vector of row- or column-wise maximum values.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MatrixGain
        </td>
        <td valign=\"top\">Block that outputs the product of a gain matrix with the input signal vector.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Discrete.MovingMean
        </td>
        <td valign=\"top\">Block that outputs the discrete moving mean of a sampled input signal.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Integers.Change
        </td>
        <td valign=\"top\">Block that outputs whether its Integer input changed its value, and whether it increased or decreased.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.IntegerSwitch
        </td>
        <td valign=\"top\">Block that outputs one of two integer input signals based on a boolean input signal.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Routing.RealExtractor
        </td>
        <td valign=\"top\">Block that extracts a scalar signal from a signal vector dependent on an Integer-valued input.
        </td>
        </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Utilities.SunRiseSet
        </td>
        <td valign=\"top\">Block that outputs sunrise and sunset time for each day.
        </td>
        </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers
        </td>
        <td valign=\"top\">Added <code>Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU</code>
                           which computes the effectiveness of a plate heat exchanger
                           based on design conditions and current mass flow rates.
        </td>
        </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Math
        </td>
        <td valign=\"top\">Added Bessel, exponential integral, factorial, falling factorial and binomial functions.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.X_pTphi
        </td>
        <td valign=\"top\">Added function to compute humidity mass fraction for given pressure, temperature
                         and relative humidity.
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
        <td valign=\"top\">Updated implementation to allow for weather data file that span less than a year and cross New Year,
                         and for weather data files that span more than a year.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-ibpsa/issues/842\">IBPSA, #842</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Timer
        </td>
        <td valign=\"top\">Updated implementation to output accumulated time when input is <code>true</code>.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1212\">issue 1212</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.TrueDelay
        </td>
        <td valign=\"top\">Added parameter <code>delayOnInit</code> to optionally delay the initial <code>true</code> input.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1346\">issue 1346</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36_PR1</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1/AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow
        </td>
        <td valign=\"top\">Made input connector for occupancy conditionally removable to avoid having to set the
                           number of occupants as an input if there is no occupancy sensor.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1270\">issue 1270</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                           Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                           Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
        </td>
        <td valign=\"top\">Changed model so that the volume is no longer fixed at compilation time.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1411\">issue 1411</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Media</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Media.Air<br/>
                           Buildings.Media.Water<br/>
                           Buildings.Media.Antifreeze.PropyleneGlycolWater<br/>
                           Buildings.Media.Specialized.Air.PerfectGas<br/>
        </td>
        <td valign=\"top\">Improved error message when temperature or mass fraction is outside the allowed range.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1045\">IBPSA, issue 1045</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Python27</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.IO.Python27.Functions.exchange<br/>
        </td>
        <td valign=\"top\">Refactored setting the <code>PYTHONPATH</code> environment variable.<br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1421\">issue 1421</a>.
    </td>
    </table>
    <!-- Non-backward compatible changes to existing components -->
    <p>
    The following <b style=\"color:blue\">existing components</b>
    have been <b style=\"color:blue\">improved</b> in a
    <b style=\"color:blue\">non-backward compatible</b> way:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.DoorDiscretizedOperable
        </td>
        <td valign=\"top\">Removed parameter <code>CD</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/971\">IBPSA, #971</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.EffectiveAirLeakageArea
        </td>
        <td valign=\"top\">Removed parameters <code>A</code>, <code>CD</code> and <code>lWet</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/932\">IBPSA, #932</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.MediumColumnDynamic
        </td>
        <td valign=\"top\">Removed parameter <code>m_flow_nominal</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/970\">IBPSA, #970</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.Orifice
        </td>
        <td valign=\"top\">Removed parameter <code>lWet</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/932\">IBPSA, #932</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Airflow.Multizone.MediumColumnDynamic<br/>
                           Buildings.Airflow.Multizone.MediumColumn<br/>
                           Buildings.Airflow.Multizone.EffectiveAirLeakageArea<br/>
                           Buildings.Airflow.Multizone.Orifice
        </td>
        <td valign=\"top\">Removed parameter <code>allowFlowReversal</code> as this is not meaningful
                           for these models.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/877\">IBPSA, #877</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertTime
        </td>
        <td valign=\"top\">Added new parameters needed for weather data files that span multiple years.
                           Models of users are not likely to be affected by this change as this model
                           is part of the weather data file reader that implements all required changes.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">IBPSA, #842</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone<br/>
                         Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone
        </td>
        <td valign=\"top\">Renamed packages to
                           <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV</code>
                           and <code>Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV</code>,
                           and renamed various signals and parameters for consistency.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.RealExtractSignal
        </td>
        <td valign=\"top\">Changed block name from <code>ExtractSignal</code>.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MultiMax
        </td>
        <td valign=\"top\">Changed output variable name from <code>yMax</code> to <code>y</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/\">issue 1252</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.MultiMin
        </td>
        <td valign=\"top\">Changed output variable name from <code>yMin</code> to <code>y</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/\">issue 1252</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryEffectivenessNTU
        </td>
        <td valign=\"top\">Renamed model to
                           <code>Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</code>
                           because the convective heat transfer coefficients are for air.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           Removed variable <code>Z</code> as it is not used.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU
        </td>
        <td valign=\"top\">Removed variable <code>Z</code> as it is not used.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Ground.Boreholes.BaseClasses.factorial
        </td>
        <td valign=\"top\">Renamed function to
                           <code>Buildings.Utilities.Math.Functions.factorial</code>
                           because it is also used by the new Geothermal package.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Ground.Boreholes
        </td>
        <td valign=\"top\">Renamed package to
                           <code>Buildings.Fluid.Geothermal.Boreholes</code>
                           due to the introduction of the new Geothermal package.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.MassFlowRateMultiplier
        </td>
        <td valign=\"top\">Renamed model to
                           <code>Buildings.Fluid.BaseClasses.MassFlowRateMultiplier</code>
                           because it is also used by the new Geothermal package.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Sources.FixedBoundary
        </td>
        <td valign=\"top\">This model is now obsolete and will be removed in future releases.
                           The model has been renamed model to
                           <code>Buildings.Obsolete.Fluid.Sources.FixedBoundary</code>.
                           Use <code>Buildings.Fluid.Sources.Boundary_pT</code> instead.<br/>
                           For Dymola, a conversion script makes this change.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Media</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Media.Refrigerants.R410A
        </td>
        <td valign=\"top\">Removed the function <code>pressureSatLiq_T</code> as it was not used.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/995\">IBPSA, #995</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Utilities.Reports</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Utilities.Reports.Printer<br/>
                           Buildings.Utilities.Reports.printRealArray
        </td>
        <td valign=\"top\">Moved <code>Buildings.Utilities.Reports.Printer</code> to
                           <code>Buildings.Utilities.IO.Files.Printer</code> and moved
                           <code>Buildings.Utilities.Reports.printRealArray</code> to
                           <code>Buildings.Utilities.IO.Files.BaseClasses.printRealArray</code>.<br/>
                           For Dymola, a conversion script makes this change.<br/>
                           This is due to the newly introduced package <code>Buildings.Utilities.IO.Files</code>.
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
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch
        </td>
        <td valign=\"top\">Corrected implementation that causes wrong output at initial stage.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Toggle
        </td>
        <td valign=\"top\">Corrected implementation that causes wrong output at initial stage.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">issue 1402</a>.
        </td>
    </tr>

    <tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.Data.Soil.SandStone
        </td>
        <td valign=\"top\">Corrected wrong thermal properties.<br/>
                         This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1062\">IBPSA, #1062</a>.
        </td>
    </tr>

    <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Heater_T<br/>
                           Buildings.Fluid.HeatExchangers.SensibleCooler_T
        </td>
        <td valign=\"top\">Corrected missing propagation of initial conditions.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1016\">IBPSA, #1016</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
        </td>
        <td valign=\"top\">Propagated parameter <code>mSenFac</code> which
                           increased the thermal capacity of the room air, such as
                           to account for furniture.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1405\">issue 1405</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.ReducedOrder</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder.RC.ThreeElements<br/>
                           Buildings.ThermalZones.ReducedOrder.RC.FourElements
        </td>
        <td valign=\"top\">The RC element of the roof <code>roofRC</code>
                           was flipped to have its <code>port_b</code> on the outside.
                           The resistances <code>RRem</code> and <code>R</code>
                           of the roof and floor have been switched
                           in the documentation.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/997\">IBPSA, #997</a>.
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
    <tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
        </td>
        <td valign=\"top\">Corrected wrong time in the documentation of the parameters.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1409\">issue 1409</a>.
        </td>
    </tr>
    </table>
    </html>"));
end Version_6_0_0;
