within Buildings.UsersGuide.ReleaseNotes;
class Version_1_0_build2 "Version 1.0 build 2"
  extends Modelica.Icons.ReleaseNotes;
   annotation (preferredView="info", Documentation(info="<html>
<p>
Version 1.0 build 2 has been released to correct model errors that
were present in version 1.0 build 1. Both versions are compatible.
In addition, version 1.0 build 2 contains improved documentation
of various example models.
<!-- New libraries -->
<!-- New components for existing libraries -->
<!-- Backward compatible changes -->
</p>

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.Continuous<br/>
                       Buildings.Controls.Discrete<br/>
                       Buildings.Controls.SetPoints
    </td>
    <td valign=\"top\">Improved documentation of models and of examples.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.DoorDiscretizedOpen<br/>
                     Buildings.Airflow.Multizone.DoorDiscretizedOperable
    </td>
    <td valign=\"top\">Changed the computation of the discharge coefficient to use the
       nominal density instead of the actual density.
       Computing <code>sqrt(2/rho)</code> sometimes causes warnings from the solver,
       as it seems to try negative values for the density during iterative solutions.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.Examples
    </td>
    <td valign=\"top\">Improved documentation of examples.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples.DualFanDualDuct</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.Controls.RoomMixingBox
    </td>
    <td valign=\"top\">Improved control of minimum air flow rate to avoid overheating.
    </td>
</tr>
</table>

<!-- Non-backward compatbile changes to existing components -->
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Convection.Exterior
    </td>
    <td valign=\"top\">Fixed error in assignment of wind-based convection coefficient.
                     The old implementation did not take into account the surface roughness.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.SolarRadiationExchange
    </td>
    <td valign=\"top\">In the previous version, the radiative properties
     of the long-wave spectrum instead of the solar spectrum have been used
     to compute the distribution of the solar radiation among the surfaces
     inside the room.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.MixedAir
    </td>
    <td valign=\"top\">Added missing connect statement between window frame
     surface and window frame convection model. Prior to this bug fix,
     no convective heat transfer was computed between window frame and
     room air.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.HeatGain
    </td>
    <td valign=\"top\">Fixed bug that caused convective heat gains
     to be removed from the room instead of added to the room.
    </td>
</tr>
</table>
<!-- Uncritical errors -->
<!-- Github issues -->

<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal.Boreholes</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/45\">&#35;45</a>
    </td>
    <td valign=\"top\">Dymola 2012 FD01 hangs when simulating a borehole heat exchanger.
    This was caused by a wrong release of memory in <code>freeArray.c</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/46\">&#35;46</a>
    </td>
    <td valign=\"top\">The convective internal heat gain has the wrong sign.
    </td>
</tr>

</table>
</html>"));
end Version_1_0_build2;
