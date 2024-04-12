within Buildings.UsersGuide.ReleaseNotes;
class Version_9_1_1 "Version 9.1.1"
extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 9.1.1 is backward compatible with 9.1.0, except that the Spawn binaries need to be updated as described
  in <code>Buildings.ThermalZones.EnergyPlus_9_6_0.UsersGuide.Installation</code>.
  </p>
  <p>
  The library has been tested with
  Dymola 2023x,
  OpenModelica 1.22.0-dev (41-g8a5b18f-1),
  OPTIMICA 1.43.4 and recent versions of Impact.
  </p>
  <p>
  The Spawn binaries have been updated from version 0.3.0 to 0.4.3.
  Both use the same EnergyPlus input data files from EnergyPlus 9.6.0.
  The update corrects a bug that caused EnergyPlus to always send
  a heat capacitance multiplier of <i>1</i> to Modelica
  (see <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3481\">#3481</a>).
  </p>
</div>
<!-- New libraries -->
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.PartialConvertTime
    </td>
    <td valign=\"top\">Added model to be extended in solar models that need calendar year for calculation.<br/>
                     See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1716\">IBPSA, #1716</a>.

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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.Utilities.PIDWithInputGains
    </td>
    <td valign=\"top\">Corrected the instance <code>antWinGai2</code> to be conditional.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3423\">#3423</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings/BoundaryConditions/SolarGeometry/BaseClasses/Declination.mo<br/>
                     Buildings/BoundaryConditions/SolarIrradiation/BaseClasses/SkyClearness.mo<br/>
                     Buildings/BoundaryConditions/WeatherData/BaseClasses/ConvertTime.mo<br/>
                     Buildings/BoundaryConditions/WeatherData/BaseClasses/EquationOfTime.mo<br/>
                     Buildings/BoundaryConditions/WeatherData/BaseClasses/LocalCivilTime.mo
    </td>
    <td valign=\"top\">Updated radiation models to use calendar time instead of simulation time.<br/>
                     See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1716\">IBPSA, #1716</a>.

    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi
    </td>
    <td valign=\"top\">Added a constant in order for unit check to pass.<br/>
                     See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1711\">IBPSA, #1711</a>.

    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Validation.MovingAverage<br/>
                     Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSet<br/>
                     Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSetNegativeStartTime<br/>
                     Buildings.Controls.OBC.CDL.Utilities.Validation.SunRiseSetPositiveStartTime
    </td>
    <td valign=\"top\">Changed models to comply with CDL specifications.<br/>
                     This is for
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3301\">#3301</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.Examples.Performance.Example5<br/>
                       Buildings.Fluid.Examples.Performance.Example6<br/>
                       Buildings.Fluid.Examples.Performance.Example7<br/>
                       Buildings.Fluid.Examples.Performance.Example8
    </td>
    <td valign=\"top\">Added a constant in order for unit check to pass.<br/>
                       See  <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1711\">IBPSA, #1711</a>.

    </td>
</tr>
  <tr>
    <td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.convectionResistanceCircularPipe<br/>
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.partialInternalResistances
    </td>
    <td valign=\"top\">Corrected variability of assignment to comply with the Modelica Language Definition.<br/>
                       See  <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1762\">IBPSA, #1762</a>.

    </td>
  </tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.Examples.EpsilonNTUZ
    </td>
    <td valign=\"top\">Added a constant in order for unit check to pass.<br/>
                       See  <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1711\">IBPSA, #1711</a>.

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
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Utilities.Plotters.Examples.Scatter<br/>
                       Buildings.Utilities.Plotters.Examples.TimeSeries<br/>
                       Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi<br/>
                       Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi
    </td>
    <td valign=\"top\">Added a constant in order for unit check to pass.<br/>
                       See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1711\">IBPSA, #1711</a>.

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
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL</b>
  </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime
  </td>
  <td valign=\"top\">Refactored implementation to avoid wrong day number due to rounding errors
                     that caused simultaneous events to not be triggered at the same time.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3199\">issue 3199</a>.
  </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
  </td>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized
    </td>
    <td valign=\"top\">Corrected the modification of <code>hexReg[nReg].m2_flow_nominal</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3441\">#3441</a>.
    </td>
</tr>
  <tr><td colspan=\"2\"><b>Buildings.ThermalZones.EnergyPlus_9_6_0</b>
  </td>
  <tr><td valign=\"top\">Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone
    </td>
    <td valign=\"top\">Corrected bug that caused EnergyPlus to always
                       send <i>1</i> for the heat capacitance multiplier.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3481\">#3481</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.FMI</b>
  </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FMI.Adaptors.Outlet
  </td>
  <td valign=\"top\">Corrected dimension of <code>X</code> in function call, which caused the model to not translate with some tools
                     if the media has only one component such as water.<br/>
                     <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1768\">IBPSA, #1768</a>.
  </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
  </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Evaporation
  </td>
  <td valign=\"top\">Corrected assertion for the condition <code>dX_nominal&lt;0</code>
                     and the documentation.<br/>
                     This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3322\">issue 3322</a>.
  </td>
</tr>
</table>
</html>"));
end Version_9_1_1;
