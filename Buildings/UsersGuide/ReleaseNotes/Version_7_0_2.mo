within Buildings.UsersGuide.ReleaseNotes;
class Version_7_0_2 "Version 7.0.2"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
    <div class=\"release-summary\">
    <p>
    Version 7.0.2 is a bug fix release.
    The library has been tested with Dymola 2022, JModelica (revision 14023),
    OpenModelica 1.19.0-dev (449+g4f16e6af22)
    and OPTIMICA (revision OCT-stable-r19089_JM-r14295).
    </p>
    <p>
    The following changes have been done:
    <ul>
    <li>
    Improved models to comply with Modelica Language Standard. Now all models translate with OpenModelica.
    </li>
    <li>
    Corrected chiller models for situation where condenser is air cooled.
    </li>
    <li>
    Corrected occupancy models for simulations that do not start at time equal to zero.
    </li>
    <li>
    Implemtend various other improvements.
    </li>
    </ul>
    </div>
    <!-- New libraries -->
    <!-- New components for existing libraries -->
    <p>
    The following <b style=\"color:blue\">new components</b> have been added
    to <b style=\"color:blue\">existing</b> libraries:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled
        </td>
        <td valign=\"top\">Data for air cooled chiller. <br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2770\">Buildings, issue #2770</a>.
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
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2770\">Buildings, issue #2770</a>.
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
                           Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3B.Electrical</br/>
                           Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF
        </td>
        <td valign=\"top\">Added missing parameter declaration.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2556\">Buildings, issue #2556</a>.
        </td>
    </tr>
    </table>
    <!-- Obsolete components -->
     </html>"));
end Version_7_0_2;
