within Buildings.UsersGuide.ReleaseNotes;
class Version_5_0_0 "Version 5.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 5.0.0 is a major new release that
   contains new packages to model control sequences,
   a package with control sequences from ASHRAE Guideline 36 and
   a package with pre-configured models for data center chilled water plants.
   All models simulate with Dymola 2017FD01, Dymola 2018 and with JModelica (revision 10374).
   </p>
   <p>
     The following major changes have been done:
   <ul>
   <li>
   The package <code>Buildings.Controls.OBC.CDL</code> has been added.
   This package provides elementary blocks to implemented control sequences.
   The blocks conform to the Control Description Language specification
   published at <a href=\"https://obc.lbl.gov\">https://obc.lbl.gov</a>.
   </li>
   <li>
   The package <code>Buildings.Controls.OBC.ASHRAE.G36_PR1</code> has been added.
   This package contains control sequences for variable air volume flow systems
   according to ASHRAE Guideline 36, public review draft 1.
   The implementation uses blocks from the above described
   <code>Buildings.Controls.OBC.CDL</code> package, and conforms to the
   Control Description Language specification.
   </li>
   <li>
   New models for ideal heaters and sensible coolers, and ideal
   humidifiers have been added.
   </li>
   <li>
   Various models have been improved.
   </li>
   </ul>
   </div>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
   <tr><td valign=\"top\">Buildings.Applications.DataCenter
       </td>
       <td valign=\"top\">Library with component models and pre-configured
                          system models for data centers.
       </td>
       </tr>
   <tr><td valign=\"top\">Buildings.Controls.OBC
       </td>
       <td valign=\"top\">Library with basic control blocks and ready-to-use control sequences
                          from the OpenBuildingControl project
                          (<a href=\"https://obc.lbl.gov\">https://obc.lbl.gov</a>).<br/>
                          The subpackage <code>Buildings.Controls.OBC.ASHRAE</code>
                          contains control sequences
                          for HVAC systems as described in ASHRAE Guideline 36.<br/>
                          The subpackage <code>Buildings.Controls.OBC.CDL</code>
                          contains libraries with basic control blocks.
                          These are a part of a Control Description Language (CDL)
                          currently being developed, which is used to compose
                          the sequences in <code>Buildings.Controls.OBC.ASHRAE</code>.
                          The intent of this implementation is that
                          Modelica models that are conformant with the CDL
                          can be translated to product lines of different control vendors.
       </td>
       </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Humidifiers
       </td>
       <td valign=\"top\">Package with spray air washer, steam humidifier and a humidifer
                          that adds a water vapor mass flow rate that is proportional to the control input.
       </td>
       </tr>
   </table>
   <!-- New components for existing libraries -->
   <p>
   The following <b style=\"color:blue\">new components</b> have been added
   to <b style=\"color:blue\">existing</b> libraries:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Heater_T<br/>
                        Buildings.Fluid.HeatExchangers.SensibleCooler_T
       </td>
       <td valign=\"top\">Added these new components to allow modeling a heater
                        and a sensible-only cooler that use an input signal to
                        ideally control their outlet temperature,
                        with optional capacity limitation
                        and optional first order dynamics.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.MassExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Humidifiers.SprayAirWasher_X<br/>
                          Buildings.Fluid.Humidifiers.SteamHumidifier_X
       </td>
       <td valign=\"top\">Added component which allows setting the outlet water vapor
                        mass fraction using an input signal, and controlling it ideally
                        with optional capacity limitation
                        and optional first order dynamics.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sources.MassFlowSource_WeatherData
       </td>
       <td valign=\"top\">Added component which allows prescribing
                          a mass flow rate that has thermal properties
                          obtained from weather data.
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
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot_TEva<br/>
                          Buildings.Fluid.Chillers.Carnot_y
       </td>
       <td valign=\"top\">Added approach temperature to avoid
                          too large COPs if the temperature lift is small.<br/>
                          This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/698\">IBPSA, #698</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow<br/>
                          Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                          Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                          Buildings.Fluid.HeatExchangers.WetCoilDiscretized
       </td>
       <td valign=\"top\">Improved model so that for certain parameters (dynamic balance,
                          or steady-state balance and no reverse flow,
                          or <i>hA</i>-calculation that is independent of temperature),
                          two fast state variables can be removed.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/678\">Buildings, #678</a>.
                          <br/><br/>
                          Added approximation of diffusion, which is needed for very small
                          flow rates which can happen if fans are off but wind pressure
                          entrains cold air through the HVAC system.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1038\">Buildings, #1038</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.Carnot_TCon<br/>
                          Buildings.Fluid.HeatPumps.Carnot_y
       </td>
       <td valign=\"top\">Added approach temperature to avoid
                          too large COPs if the temperature lift is small.<br/>
                          This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/698\">IBPSA, #698</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp
       </td>
       <td valign=\"top\">Added optional input signal for
                          differential pressure measurement,
                          which will then be tracked by the model.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.TemperatureTwoPort
       </td>
       <td valign=\"top\">Improved optional heat loss model.<br/>
                          This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/840\">IBPSA, #840</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.SolarCollectors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                          Buildings.Fluid.SolarCollectors.EN12975
       </td>
       <td valign=\"top\">Changed models for incidence angles below 60&deg;
                          in order to increase the accuracy near sunrise and sunset.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/785\">#785</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir
       </td>
       <td valign=\"top\">Added an optional input that allows injecting
                          trace substances, such as CO2 release from people,
                          to the room air.
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
    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCooler_T
       </td>
       <td valign=\"top\">Renamed <code>Buildings.Fluid.HeatExchangers.HeaterCooler_T</code>
                        to <code>Buildings.Fluid.HeatExchangers.PrescribedOutlet</code>
                        as it now also allows to set the outlet water vapor mass fraction.<br/>
                        For Dymola, a conversion script makes this change.<br/>
                        This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">IBPSA, #763</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.MassExchangers.Humidifier_u
       </td>
       <td valign=\"top\">Moved model to <code>Buildings.Fluid.Humidifiers.Humidifier_u</code>.<br/>
                          Removed parameters <code>use_T_in</code> and <code>T</code>,
                          and removed input connector <code>T_in</code>, as these are no
                          longer needed.<br/>
                          For Dymola, the conversion script will remove the parameter
                          settings.<br/>
                          For Dymola, a conversion script makes this change.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">#704</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces
       </td>
       <td valign=\"top\">Renamed <code>PrescribedOutletState</code> to <code>PrescribedOutlet</code>
                        and removed <code>PrescribedOutletStateParameters</code>.<br/>
                        This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">IBPSA, #763</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers
       </td>
       <td valign=\"top\">Removed the function
                        <code>Buildings.Fluid.HeatExchangers.BaseClasses.appartusDewPoint</code>
                        as it was nowhere used, and it also has no validation test.<br/>
                        This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/724\">Buildings, #724</a>.
       </td>
   </tr>


   </table>
   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Airflow</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Airflow.Multizone.EffectiveAirLeakageArea
       </td>
       <td valign=\"top\">Corrected error in computation of <code>A</code> which was
                          <code>A=CD/CDRat * L * dpRat^(0.5-m))</code> rather than
                          <code>A=CDRat/CD * L * dpRat^(0.5-m))</code>.<br/>
                          See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/743\">#743</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Controls</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.Continuous.OffTimer
       </td>
       <td valign=\"top\">Corrected implementation as the timer had the wrong
                          if the simulation did not start at <code>time = 0</code>.
                          After the first reset, the value was correct.<br/>
                          See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/743\">IBPSA, #743</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                          Buildings.Fluid.Interfaces.FourPortHeatMassExchanger
       </td>
       <td valign=\"top\">Corrected assignment of <code>Q_flow</code> (or <code>Q1_flow</code>
                          and <code>Q2_flow</code>).
                          Previously, these variables were assigned only the sensible heat flow rate,
                          but they should include the latent heat exhange to be consistent with
                          the variable naming, and because the cooling coils interpret these variables
                          as if they contain the latent heat flow rate.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">#704</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                          Buildings.Fluid.HeatExchangers.WetCoilDiscretized<br/>
                          Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent
       </td>
       <td valign=\"top\">Added heat of condensation to coil surface heat balance
                          and removed it from the air stream.
                          This gives higher coil surface temperature and avoids
                          overestimating the latent heat ratio that was
                          observed in the previous implementation.
                          The code change was in
                          <code>Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent</code><br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/711\">#711</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil
       </td>
       <td valign=\"top\">Corrected coefficient for temperature-dependency correction
                          of air-side convection coefficient.
                          By default, the convection coefficient
                          is assumed to be temperature-independent, in which cases this
                          correction has no effect on the results.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/698\">#698</a>.
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
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.MultiLayer
       </td>
       <td valign=\"top\">Corrected wrong result variable <code>R</code> and <code>UA</code>.
                          These variables are only used for reporting.
                          All other calculations are not affected by this error.
       </td>
   </tr>
   </table>
   </html>"));
end Version_5_0_0;
