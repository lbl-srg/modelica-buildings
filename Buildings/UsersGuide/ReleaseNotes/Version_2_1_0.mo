within Buildings.UsersGuide.ReleaseNotes;
class Version_2_1_0 "Version 2.1.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
   <p>
   Version 2.1.0 is fully compatible with version 2.0.0.
   It adds the package <code>Buildings.Fluid.FMI</code> that provides containers
   for exporting thermofluid flow components as FMUs.
   It also updates the temperature sensor to optionally simulate heat losses,
   and it contains bug fixes for the trace substance sensor if used without flow reversal.
   Improvements have been made to various models to reduce the simulation time, and
   to <code>Buildings.Examples.Tutorial.Boiler</code> to simplify the control implementation.
   </p>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
   <tr><td valign=\"top\">Buildings.Fluid.FMI
       </td>
       <td valign=\"top\">This package contains blocks that serve as containers for exporting
                          models from <code>Buildings.Fluid</code> as a Functional Mockup Unit (FMU).<br/>
                          This allows using models from <code>Buildings.Fluid</code>, add them
                          to a block that only has input and output signals, but no acausal connectors,
                          and then export the model as a Functional Mockup Unit.
                          Models can be individual models or systems that are composed of various
                          models.
                          For more information, see the
                          <a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">User's Guide</a>.
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
   <tr><td colspan=\"2\"><b>Buildings.Examples</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.Tutorial.Boiler.System5<br/>
                        Buildings.Examples.Tutorial.Boiler.System6<br/>
                        Buildings.Examples.Tutorial.Boiler.System7
       </td>
       <td valign=\"top\">Changed control input for <code>conPIDBoi</code> and set
                        <code>reverseAction=true</code>
                        to address issue
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/436\">#436</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot<br/>
                          Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialDXCoil<br/>
                          Buildings.Fluid.HeatExchangers.HeaterCooler_u<br/>
                          Buildings.Fluid.MassExchangers.Humidifier_u
       </td>
       <td valign=\"top\">Set parameter <code>prescribedHeatFlowRate=true</code>
                          which causes a simpler energy balance to be used.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.TemperatureTwoPort
       </td>
       <td valign=\"top\">Added option to simulate thermal loss, which is
                        useful if the sensor is used to measure
                        the fluid temperature in a system with on/off control
                        for the mass flow rate.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                          Buildings.Fluid.SolarCollectors.EN12975
       </td>
       <td valign=\"top\">Corrected sign error in computation of heat loss
                          that prevents the medium to exceed <code>Medium.T_min</code>
                          or <code>Medium.T_max</code>. With the previous implementation,
                          an assertion may be generated unnecessarily rather than
                          the model guiding against the violation of these bounds.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume


       </td>
       <td valign=\"top\">Added test on <code>allowFlowReversal</code> in criteria
                          about what energy balance implementation to use.
                          This causes simpler models, for example when exporting
                          <code>Buildings.Fluid.HeatExchangers.HeaterCooler_u</code>
                          as an FMU.
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
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstanceTwoPort
       </td>
       <td valign=\"top\">Corrected wrong sensor signal if <code>allowFlowReversal=false</code>.
                          For this setting, the sensor output was for the wrong flow direction.
                          This corrects
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/249\">issue 249</a>.
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
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                          Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
       </td>
       <td valign=\"top\">Corrected documentation.
       </td>
   </tr>
   </table>
   </html>"));
end Version_2_1_0;
