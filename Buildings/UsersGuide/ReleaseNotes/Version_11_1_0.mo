within Buildings.UsersGuide.ReleaseNotes;
class Version_11_1_0 "Version 11.1.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 11.1.0 is backward compatible with 11.0.0.
</p>
<p>
The library has been tested with
Dymola 2024x Refresh 1,
OpenModelica 1.24.0,
OPTIMICA 1.55.11 and recent versions of Impact.
</p>
<p>
This backward compatible version adds a new package with heat pump models
that can be operated in reversible mode to provide heating or cooling,
and that can be configured to use various approaches to compute performance, such as
data tables or Carnot analogy.
</p>
<p>
Also, many models have been updated to improve performance, to ensure compliance with the Modelica Language Standard and to correct model errors.
</p>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.Chillers.ModularReversible<br/>
                       Buildings.Fluid.HeatPumps.ModularReversible
    </td>
    <td valign=\"top\">Models for both reversible and non-reversible refrigerant machines (heat pumps and chillers) based on grey-box approaches.
                       Either tabulated data or physical equations can be used to model the performance of the refrigerant cycle without
                       modeling of the refrigerant properties.
                       The models can be configured to enable built-in safety control such as minimum on- or off-time,
                       operation within specified envelope, antifreeze protection and minimum flow rate.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
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
<tr><td valign=\"top\">Buildings.Controls.Continuous.Examples.NumberOfRequests
    </td>
    <td valign=\"top\">Changed pulse input from 0 to 1 to 0.01 to 1
                       so that the comparison against zero is robust.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1897\">IBPSA, #1897</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Reals.Sort
    </td>
    <td valign=\"top\">Added an output variable with the indices of the sorted elements.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3809\">issue 3809</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.Latch
    </td>
    <td valign=\"top\">Simplified the implementation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3796\">#3796</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.ETS.Combined.Subsystems</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.HeatPumpDHWTank
    </td>
    <td valign=\"top\">Enabled input filter for pumps to avoid a nonlinear system of equations that causes issues in OpenModelica.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3924\">issue 3924</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples.ChillerSetPointControl<br/>
                       Buildings.Examples.Tutorial.Boiler.System2<br/>
                       Buildings.Examples.Tutorial.Boiler.System3<br/>
                       Buildings.Examples.Tutorial.Boiler.System4<br/>
                       Buildings.Examples.Tutorial.Boiler.System5<br/>
                       Buildings.Examples.Tutorial.Boiler.System6<br/>
                       Buildings.Examples.Tutorial.Boiler.System7<br/>
                       Buildings.Examples.Tutorial.SpaceCooling.System2<br/>
                       Buildings.Examples.Tutorial.SpaceCooling.System3
    </td>
    <td valign=\"top\">Specified <code>nominalValuesDefineDefaultPressureCurve=true</code>
                       in the mover component to suppress a warning.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.Examples.BoilerPolynomialClosedLoop<br/>
                       Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.Fan<br/>
                       Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACZones<br/>
                       Buildings.Fluid.Geothermal.Borefields.Examples.RectangularBorefield<br/>
                       Buildings.Fluid.Movers.Examples.MoverParameter<br/>
                       Buildings.Fluid.Movers.Validation.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.Validation.FlowControlled_dpSystem<br/>
                       Buildings.Fluid.Movers.Validation.FlowControlled_m_flow<br/>
                       Buildings.Fluid.Movers.Validation.Pump_y_stratos<br/>
                       Buildings.Fluid.Movers.Validation.PumpCurveDerivatives
    </td>
    <td valign=\"top\">Specified <code>nominalValuesDefineDefaultPressureCurve=true</code>
                       in the mover component to suppress a warning.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.FMI.ExportContainers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FMI.ExportContainers.Validation.RoomHVAC
    </td>
    <td valign=\"top\">Removed redundant <code>nominalValuesDefineDefaultPressureCurve=true</code>
                       which is now modified in a lower-level model.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.Data.Generic
    </td>
    <td valign=\"top\">Default efficiency method assignments now depend on
                       the availability of pressure curves.
                       This avoids a warning message.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Files</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Files.WeeklySchedule
    </td>
    <td valign=\"top\">Changed syntax for inclusion of C source code to comply
                       with the Modelica Language Specification.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1891\">IBPSA, #1891</a>.

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
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Chillers.BaseClasses.PartialElectric<br/>
                       Buildings.Fluid.HeatPumps.EquationFitReversible
    </td>
    <td valign=\"top\">Added load limit depending on operating mode.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3815\">#3815</a>.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
</html>"));
end Version_11_1_0;
