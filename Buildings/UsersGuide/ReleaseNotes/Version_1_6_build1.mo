within Buildings.UsersGuide.ReleaseNotes;

class Version_1_6_build1 "Version 1.6 build 1"
  extends Modelica.Icons.ReleaseNotes;
  annotation(Documentation(info = "<html>
  <p>
  Version 1.6 build 1 is ... xxx
  This version updates the <code>Buildings</code> library to the
  Modelica Standard Library 3.2.1 and to <code>Modelica_StateGraph2</code> 2.0.2.
  </p>
  <!-- New libraries -->
  <p>
  The following <b style=\"color:blue\">new libraries</b> have been added:
  </p>
  <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\">xxx
      </td>
      <td valign=\"top\">xxx.
      </td>
      </tr>
  </table>
  <!-- New components for existing libraries -->
  <p>
  The following <b style=\"color:blue\">new components</b> have been added
  to <b style=\"color:blue\">existing</b> libraries:
  </p>
  <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
  <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
      </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPortInterface<br/>
                         Buildings.Fluid.Interfaces.PartialFourPortInterface
      </td>
      <td valign=\"top\">Removed call to homotopy function 
                         in the computation of the connector variables as 
                         these are conditionally enabled variables and 
                         therefore must not be used in any equation. They
                         are only for output reporting.
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
  <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">

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
  <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
  <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
      </td>
  </tr>
  <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.HexInternalElement
      </td>
      <td valign=\"top\">Corrected error in documentation which stated a wrong default value
                         for the pipe spacing.
      </td>
  </tr>
  </table>
  <!-- Github issues -->
  <p>
  The following
  <a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
  have been fixed:
  </p>
  <table border=\"1\" summary=\"github issues\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>xxx</b>
      </td>
  </tr>
  <tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/xxx\">#xxx</a>
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
end Version_1_6_build1;