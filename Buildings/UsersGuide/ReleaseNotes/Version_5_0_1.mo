within Buildings.UsersGuide.ReleaseNotes;
class Version_5_0_1 "Version 5.0.1"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 5.0.1 corrects an error in <code>Buildings.Fluid.SolarCollectors</code>
   that led to too small heat losses if a collector has more than one panel.
   Also, Dymola specific annotations to load data files in a GUI have been replaced
   for compatibility with other tools.
   Otherwise, version 5.0.1 is identical to 5.0.0.
   </p>
   <p>
   All models simulate with Dymola 2017FD01, Dymola 2018 and JModelica (revision 10374).
   </p>
   </div>
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                          Buildings.Fluid.SolarCollectors.EN12975
       </td>
       <td valign=\"top\">Corrected error in parameterization of heat loss calculation
                          that led to too small heat losses if a collector has more than one panel.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1073\">issue 1073</a>.
       </td>
   </tr>
   </table>
   </html>"));
end Version_5_0_1;
