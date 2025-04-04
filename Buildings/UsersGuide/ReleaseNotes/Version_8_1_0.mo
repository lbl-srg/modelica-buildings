within Buildings.UsersGuide.ReleaseNotes;
class Version_8_1_0 "Version 8.1.0"
  extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
    <div class=\"release-summary\">
    <p>
    Version 8.1.0 is a minor release that is backwards compatible with version 8.0.0.
    The library has been tested with Dymola 2022, JModelica (revision 14023),
    OpenModelica 1.19.0-dev (449+g4f16e6af22),
    and OPTIMICA (revision OCT-stable-r19089_JM-r14295).
    </p>
    <p>
    The following changes have been done:
    <ul>
    <li>
    Added a package to compute undisturbed ground temperatures.
    </li>
    <li>
    Added controller for radiant cooling and heating systems.
    </li>
    <li>
    Added a package for district cooling applications.
    </li>
    <li>
    Added a new boiler model that is suitable for condensing boilers.
    </li>
    <li>
    Corrected various errors and improved compliance with Modelica Language Standard.
    </li>
    </ul>
    </div>
    <!-- New libraries -->
    <p>
    The following <b style=\"color:blue\">new libraries</b> have been added:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.BoundaryConditions.GroundTemperature
        </td>
        <td valign=\"top\">Package with models and climatic data for computing ground temperature.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Controls</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Controls.OBC.RadiantSystems
        </td>
        <td valign=\"top\">Package with controllers for radiant cooling and heating systems
                           such for pipes embedded in the concrete slab.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.DHC</b>
        </td>
    <tr><td valign=\"top\">Buildings.DHC.Plants.Cooling
        </td>
        <td valign=\"top\">Package with models for a chilled water plant adapted to
        district cooling applications.<br/>
        This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2264\">issue 2264</a>
        </td>
    </tr>
    </table>
    <!-- New components for existing libraries -->
    <p>
    The following <b style=\"color:blue\">new components</b> have been added
    to <b style=\"color:blue\">existing</b> libraries:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Boilers</b>
      </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Boilers.BoilerTable<br/>
                         Buildings.Fluid.Boilers.Examples.BoilerTable<br/>
                         Buildings.Fluid.Boilers.Validation.BoilerTableEfficiencyCurves<br/>
                         Buildings.Fluid.Boilers.BaseClasses.PartialBoiler<br/>
                         Buildings.Fluid.Boilers.Data.Generic<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash3001<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash3501<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash4001<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash5001<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash6001<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.FTX400<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.FTX500<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.FTX600<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.FTX725<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.FTXL.FTX850<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0400<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0500<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0650<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash0800<br/>
                         Buildings.Fluid.Boilers.Data.Lochinvar.KnightXL.KBXdash1000
      </td>
      <td valign=\"top\">Classes for modeling boilers whose efficiency curves are provided as a table.
                         Part of the code from the old <code>Buildings.Fluid.Boilers.BoilerPolynomial</code>
                         has been moved to <code>Buildings.Fluid.Boilers.BaseClasses.PartialBoiler</code>
                         to support the new model <code>Buildings.Fluid.Boilers.BoilerTable</code>. <br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">issue 2651</a>.<br/>
                         In the moved code, the boiler's heating power output is now corrected by
                         its loss to the ambient. <br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2725\">#2725</a>.
      </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
      </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled
      </td>
      <td valign=\"top\">Data for air cooled chiller. <br/>
                         This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2770\">issue #2770</a>.
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
    <tr><td colspan=\"2\"><b>Buildings.Examples.ChillerPlant</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Examples.ChillerPlant.BaseClasses.DataCenter
        </td>
        <td valign=\"top\">Set <code>nominalValuesDefaultPressureCurve=true</code> to avoid warnings.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2761\">Buildings, issue #2761</a>.<br/>
                           Changed initialization from steady state initial to fixed initial for some components.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2798\">Buildings, issue #2798</a>.
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
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2713\">Buildings, issue #2713</a>.
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
    </table>
    <!-- Non-backward compatible changes to existing components -->
    <!-- Errors that have been fixed -->
    <p>
    The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
    that can lead to wrong simulation results):
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
        </td>
    </tr>
    <tr><td valign=\"top\"> Buildings.Fluid.Chillers.BaseClasses.PartialElectric
        </td>
        <td valign=\"top\">Corrected calculation of entering condenser temperature
                           when using a moist air media model.
                           This is important for modeling air-cooled chillers using the model
                           <code>Buildings.Fluid.Chillers.ElectricEIR</code>.
                           <br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2770\">issue #2770</a>.
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
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2590\">Buildings, #2590</a>.
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
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1496\">Buildings, issue #1496</a>.
        </td>
    </tr>
    <tr>
      <td colspan=\"2\"><b>Buildings.Applications.DataCenters</b>
      </td>
    </tr>
    <tr>
      <td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimaryLoadSideEconomizer<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Examples.IntegratedPrimarySecondaryEconomizer<br/>
                         Buildings.Applications.DataCenters.ChillerCooled.Examples.NonIntegratedPrimarySecondaryEconomizer
      </td>
      <td valign=\"top\">Corrected weather data bus connection which was structurally incorrect
                         and did not parse in OpenModelica.<br/>
                         This is for
                         <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2706\">Buildings, issue 2706</a>.
       </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Electrical.AC.OnePhase.Storage.Battery<br/>
                           Buildings.Electrical.DC.Storage.BaseClasses.Charge<br/>
                           Buildings.Electrical.DC.Storage.Battery
        </td>
        <td valign=\"top\">Corrected unit string.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2798\">Buildings, issue #2798</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.RadiationTemperature
        </td>
        <td valign=\"top\">Corrected annotation.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2550\">Buildings, issue #2550</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallTwoWindows<br/>
                           Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallWithWindow<br/>
                           Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Electrical</br>
                           Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF
        </td>
        <td valign=\"top\">Added missing parameter declaration.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2556\">Buildings, issue #2556</a>.
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
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2713\">Buildings, issue #2713</a>.
        </td>
    </tr>
    </table>
    <!-- Obsolete components -->
     </html>"));
end Version_8_1_0;
