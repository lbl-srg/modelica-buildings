within Buildings.UsersGuide.ReleaseNotes;
class Version_1_2_build1 "Version 1.2 build 1"
  extends Modelica.Icons.ReleaseNotes;
   annotation (preferredView="info", Documentation(info="<html>
<p>
In version 1.2 build 1, models for radiant slabs and window overhangs and sidefins have been added.
This version also contains various improvements to existing models.
A detailed list of changes is shown below.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs
    </td>
    <td valign=\"top\">Package with models for radiant slabs
                       with pipes or a capillary heat exchanger
                       embedded in the construction.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Pipes
    </td>
    <td valign=\"top\">Package with records for pipes.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->

<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.FixedShade<br/>
                       Buildings.HeatTransfer.Windows.Overhang<br/>
                       Buildings.HeatTransfer.Windows.SideFins
    </td>
    <td valign=\"top\">For windows with either an overhang or side fins,
                       these blocks output the fraction of the area
                       that is sun exposed.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Examples.BESTEST
    </td>
    <td valign=\"top\">Added BESTEST validation models for case 610, 620, 630, 640,
                       650FF, 650, 920, 940, 950FF, 950, and 960.
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
    <td valign=\"top\">Removed assignment of <code>HGloHor_in</code> in its declaration,
                       because this gives an overdetermined system if the input connector
                       is used.<br/>
                       Added new sub-bus that contains the solar position.
                       This allows reusing the solar position in various other models.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffuseIsotropic<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffusePerez<br/>
    </td>
    <td valign=\"top\">Added optional output of diffuse radiation from the sky and ground.
                       This allows reusing the diffuse radiation in solar thermal collector.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth
    </td>
    <td valign=\"top\">Changed implementation to avoid an event at solar noon.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.BoreholeFillings
    </td>
    <td valign=\"top\">
                       Renamed class to <code>BoreholeFillings</code>
                       to be consistent with data records being plural.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.GasesPTDecoupled.MoistAir<br/>
                       Buildings.Media.Air<br/>
                       Buildings.Media.PerfectGases.MoistAir<br/>
                       Buildings.Media.PerfectGases.MoistAirUnsaturated<br/>
                       Buildings.Media.GasesConstantDensity.MoistAir<br/>
                       Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    </td>
    <td valign=\"top\">Added redeclaration of <code>ThermodynamicState</code>
                       to avoid a warning
                       during model check and translation.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Added a check that ensures that the number of surfaces
                       are equal to the length of the parameter that contains
                       the surface area, and added a check to ensure that no surface area
                       is equal to zero. These checks help detecting erroneous declarations
                       of the room model. The changes were done in
                       <code>Buildings.ThermalZones.Detailed.MixedAir.PartialSurfaceInterface</code>.
    </td>
</tr>
</table>
<!-- Non-backward compatbile changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
    </td>
    <td valign=\"top\">Added optional modeling of window overhangs and side fins.
                       The modeling of window overhangs and side fins required the
                       introduction of the new parameters
                       <code>hWin</code> for the window height and
                       <code>wWin</code> for the window width, in addition to the
                       parameters <code>ove</code> and <code>sidFin</code> which are used
                       to declare the geometry of overhangs and side fins.
                       The parameters <code>hWin</code> and <code>wWin</code>
                       replace the previously used parameter <code>AWin</code> for the
                       window area.
                       Users need to manually replace <code>AWin</code> with <code>hWin</code>
                       and <code>wWin</code> when updating models
                       from a previous version of the library.<br/>
                       See the information section in
                       <code>Buildings.ThermalZones.Detailed.MixedAir</code> for how to use these models.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">
                      Fixed a bug that caused an error in the schedule if the simulation start time was negative or equal to the first entry in the schedule.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.BaseClass.ThirdOrderStratifier
    </td>
    <td valign=\"top\">Revised the implementation to reduce the temperature overshoot.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Fixed the bug in the temperature linearization and
                       in the heat flow through the glass layer if the transmissivity of glass
                       in the infrared regime is non-zero.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass
    </td>
    <td valign=\"top\">Fixed a bug in the parameter assignment of the instance <code>glass</code>.
                       Previously, the infrared emissivity of surface a was assigned to the surface b.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.BCVTB
    </td>
    <td valign=\"top\">Added a call to <code>Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals</code>
                       in the <code>initial algorithm</code> section.
                       This is needed to propagate the initial condition to the server.
                       It also leads to one more data exchange, which is correct and avoids the
                       warning message in Ptolemy that says that the simulation reached its stop time
                       one time step prior to the final time.
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
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Corrected the documentation of the unit requirement for
                       input files, parameters and connectors.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPortInterface<br/>
                       Buildings.Fluid.Interfaces.PartialTwoPortInterface
    </td>
    <td valign=\"top\">Replaced the erroneous function call <code>Medium.density</code> with
                       <code>Medium1.density</code> and <code>Medium2.density</code> in
                        <code>PartialFourPortInterface</code>.
                       Changed condition to remove <code>sta_a1</code> and
                       <code>sta_a2</code> in <code>PartialFourPortInterface</code>, and
                       <code>sta_a</code> in <code>PartialTwoPortInterface</code>, to also
                       compute the state at the inlet port if <code>show_V_flow=true</code>.<br/>
                       The previous implementation resulted in a translation error
                       if <code>show_V_flow=true</code>, but worked correctly otherwise
                       because the erroneous function call is removed if  <code>show_V_flow=false</code>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric
    </td>
    <td valign=\"top\">Corrected the nominal mass flow rate used in the mass flow source.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Heat transfer in glass layer</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/56\">&#35;56</a>
    </td>
    <td valign=\"top\">Fixed bug in heat flow through the glass layer if the infrared transmissivity is non-zero.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/57\">&#35;57</a>
    </td>
    <td valign=\"top\">Fixed bug in temperature linearization of window glass.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Overshooting in enhanced stratified tank</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/15\">&#35;15</a>
    </td>
    <td valign=\"top\">Revised the implementation to reduce the temperature over-shoot.
    </td>
</tr>
</table>
</html>"));
end Version_1_2_build1;
