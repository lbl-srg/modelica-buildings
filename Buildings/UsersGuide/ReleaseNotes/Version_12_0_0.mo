within Buildings.UsersGuide.ReleaseNotes;
<<<<<<< HEAD
<<<<<<<< HEAD:Buildings/UsersGuide/ReleaseNotes/Version_12_0_0.mo
class Version_12_0_0 "Version 12.0.0"
========
class Version_11_1_0 "Version 11.1.0"
>>>>>>>> master:Buildings/UsersGuide/ReleaseNotes/Version_11_1_0.mo
=======
class Version_12_0_0 "Version 12.0.0"
>>>>>>> master
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
<<<<<<< HEAD
<<<<<<<< HEAD:Buildings/UsersGuide/ReleaseNotes/Version_12_0_0.mo
Version 12.0.0 is ... xxx
========
Version 11.1.0 is ... xxx
>>>>>>>> master:Buildings/UsersGuide/ReleaseNotes/Version_11_1_0.mo
=======
Version 12.0.0 is ... xxx
>>>>>>> master
</p>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<<<<<<< HEAD
<tr><td valign=\"top\">Buildings.Fluid.Chillers.ModularReversible<br/>
                       Buildings.Fluid.HeatPumps.ModularReversible
    </td>
    <td valign=\"top\">Models for both reversible and non-reversible refrigerant machines (heat pumps and chillers) based on grey-box approaches.
                       Either tabulated data or physical equations can be used to model the performance of the refrigerant cycle without
                       modeling of the refrigerant properties.
                       The models can be configured to enable built-in safety control such as minimum on- or off-time,
                       operation within specified envelope, antifreeze protection and minimum flow rate.
=======
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
>>>>>>> master
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
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
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
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
<<<<<<< HEAD
<<<<<<<< HEAD:Buildings/UsersGuide/ReleaseNotes/Version_12_0_0.mo
=======
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.OneUTube<br/>
                       Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.TwoUTube<br/>
                       Buildings.Fluid.Geothermal.Borefields.BaseClasses.PartialBorefield

    </td>
    <td valign=\"top\">Removed parameter <code>dynFil</code> to avoid allowing an inconsistent
                       declaration of the energy balance configuration for the borehole filling.<br/>
                       This is for
                       <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1885\">IBPSA, #1885</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
    </td>
</tr>
<tr>
    <td valign=\"top\">Buildings.Fluid.SolarCollectors
    </td>
    <td valign=\"top\">Refactored solar collector models to allow modeling of arrays of collectors,
                       to facilitate use of rating data to parameterize the collector, and
                       to improve calculation of performance for shallow solar incidence angles.<br/>
                       The former models have been moved to <code>Buildings.Obsolete</code>.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">#3604</a>.
    </td>
</tr>

>>>>>>> master
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Plants.Controls.Utilities.SortWithIndices
    </td>
    <td valign=\"top\">Moved to the <code>Obsolete</code> package.<br/>
                       This is for
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3809\">#3809</a>.
    </td>
</tr>
<<<<<<< HEAD
========
>>>>>>>> master:Buildings/UsersGuide/ReleaseNotes/Version_11_1_0.mo
=======
>>>>>>> master
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
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
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
<p>
Note:
</p>
<ul>
<li>
xxx
</li>
</ul>
</html>"));
<<<<<<< HEAD
<<<<<<<< HEAD:Buildings/UsersGuide/ReleaseNotes/Version_12_0_0.mo
end Version_12_0_0;
========
end Version_11_1_0;
>>>>>>>> master:Buildings/UsersGuide/ReleaseNotes/Version_11_1_0.mo
=======
end Version_12_0_0;
>>>>>>> master
