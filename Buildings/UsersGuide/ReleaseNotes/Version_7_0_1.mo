within Buildings.UsersGuide.ReleaseNotes;
class Version_7_0_1 "Version 7.0.1"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
    <div class=\"release-summary\">
    <p>
    Version 7.0.1 is a bug fix release.
    The library has been tested with
    Dymola 2021 and 2022,
    JModelica (revision 14023), and
    OPTIMICA (revision OCT-stable-r12473_JM-r14295).
    </p>
    <p>
    The following changes have been done:
    <ul>
    <li>
    Corrected memory violation on Windows for weather data file with long header lines.
    </li>
    <li>
    Corrected various misplaced or missing <code>each</code> declarations.
    </li>
    <li>
    Corrected access to protected classes.
    </li>
    <li>
    Reformulated replaceable class to avoid access of components that are not in the constraining type.
    </li>
    <li>
    Added missing parameter declarations for records.
    </li>
    </ul>
    </div>
    <!-- New libraries -->
    <!-- New components for existing libraries -->
    <!-- Backward compatible changes -->
    <p>
    The following <b style=\"color:blue\">existing components</b>
    have been <b style=\"color:blue\">improved</b> in a
    <b style=\"color:blue\">backward compatible</b> way:
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Applications</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation
        </td>
        <td valign=\"top\">Changed boundary condition model to prescribed pressure rather than prescribed mass flow rate.
                           Prescribing the mass flow rate caused
                           unreasonably large pressure drop because the mass flow rate was forced through a closed valve.<br/>
                           This is for
                           <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2488\">#2488</a>.
        </td>
    </tr>
    <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Electrical.AC.ThreePhasesUnbalanced.Validation.IEEETests.Test4NodesFeeder.BalancedStepUp.YD
        </td>
        <td valign=\"top\">Set better start values for algebraic variables.<br/>
                           This is for
                           <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2432\">#2432</a>.
        </td>
    </tr>
    </table>
    <!-- Non-backward compatible changes to existing components -->
    <!-- Errors that have been fixed -->
    <!-- Uncritical errors -->
    <p>
    The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
    that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
    units are wrong or errors in documentation):
    </p>
    <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.CHPs.BaseClasses.EnergyConversionNormal<br/>
                           Buildings.Fluid.CHPs.ThermalElectricalFollowing
        </td>
        <td valign=\"top\">Reformulated replaceable class to avoid access of components that are not in the constraining type.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.PartialBorefield
        </td>
        <td valign=\"top\">Corrected placement of <code>each</code> keyword.
                           See <a href=\"https://github.com/lbl-srg/modelica-buildings/pull/2440\">Buildings, #2440</a>.
                           <br/>
                           Switched port connections for <code>masFloDiv</code>.
                           See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/41\">IBPSA, #41</a>.
                           <br/>
                           Propagated flowReversal into <code>masFloDiv</code> and <code>masFloMul</code>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.Examples.Borefields<br/>
                           Buildings.Fluid.Geothermal.Borefields.Validation.ConstantHeatInjection_100Boreholes</br>
                           Buildings.Fluid.Geothermal.Borefields.Validation.Sandbox
        </td>
        <td valign=\"top\">Added missing parameter keyword for data records.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.CoilRegister<br/>
                           Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent
        </td>
        <td valign=\"top\">Changed constant <code>simplify_mWat_flow</code> from protected to public because it is assigned by
                           <a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
                           Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2387\">#2387</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.PartialPrescribedOutlet
        </td>
        <td valign=\"top\">Removed duplicate declaration of <code>m_flow_nominal</code> which is already
                           declared in the base class.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.DXSystems.AirCooled.Examples.MultiStage<br/>
                           Buildings.Fluid.DXSystems.AirCooled.Examples.PerformanceCurves.Curve_I<br/>
                           Buildings.Fluid.DXSystems.AirCooled.Examples.PerformanceCurves.Curve_II<br/>
                           Buildings.Fluid.DXSystems.AirCooled.Examples.PerformanceCurves.Curve_III<br/>
                           Buildings.Fluid.DXSystems.AirCooled.Examples.SingleSpeed<br/>
                           Buildings.Fluid.DXSystems.AirCooled.Examples.SpaceCooling<br/>
                           Buildings.Fluid.DXSystems.AirCooled.Examples.VariableSpeed<br/>
                           Buildings.Fluid.DXSystems.AirCooled.Validation.SingleSpeedEnergyPlus<br/>
                           Buildings.Fluid.DXSystems.AirCooled.Validation.SingleSpeedPLREnergyPlus<br/>
                           Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.WetCoil<br/>
                           Buildings.Fluid.DXSystems.WaterCooled.Examples.MultiStage<br/>
                           Buildings.Fluid.DXSystems.WaterCooled.Examples.SingleSpeed<br/>
                           Buildings.Fluid.DXSystems.WaterCooled.Examples.VariableSpeed<br/>
                           Buildings.Fluid.DXSystems.WaterCooled.Validation.VariableSpeedEnergyPlus<br/>
                           Buildings.Fluid.DXSystems.WaterCooled.Validation.VariableSpeedEnergyPlusPartLoad<br/>
        </td>
        <td valign=\"top\">Corrected placement of <code>each</code> keyword.<br/>
                           See <a href=\"https://github.com/lbl-srg/modelica-buildings/pull/2440\">Buildings, PR #2440</a>.<br/>
                           Added missing parameter declaration for data record.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.WetCoilCounterFlow
        </td>
        <td valign=\"top\">Removed <code>final</code> declaration in redeclaration.<br/>
                           This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2392\">#2392</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Interfaces.PrescribedOutlet
        </td>
        <td valign=\"top\">Removed duplicate declaration of <code>m_flow_nominal</code> which is already
                           declared in the base class.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.Fluid.Sources.BaseClasses.PartialSource<br/>
                           Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger
        </td>
        <td valign=\"top\">Corrected misplaced <code>each</code> and added missing instance comment.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1462\">IBPSA, #1462</a>.
        </td>
    </tr>
    <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3
        </td>
        <td valign=\"top\">Corrected memory access violation on Windows for files with long header.<br/>
                           This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1432\">IBPSA, #1432</a>.
        </td>
     </tr>
    <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3<br/>
                           Buildings.Utilities.Cryptographics.sha
        </td>
        <td valign=\"top\">Corrected memory leak in C function.
        </td>
     </tr>
     <tr><td valign=\"top\">Buildings.Utilities.IO.BCVTB.BaseClasses.FluidInterface
        </td>
        <td valign=\"top\">Corrected missing <code>each</code> keyword.
        </td>
     </tr>
    </table>
    <!-- Obsolete components -->
     </html>"));
end Version_7_0_1;
