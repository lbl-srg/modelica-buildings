within Buildings.UsersGuide.ReleaseNotes;
class Version_15_0_0 "Version 15.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<div class=\"release-summary\">
<p>
Version 15.0.0 is ... xxx
</p>
</div>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
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
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Templates</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Templates.Plants.Chillers
    </td>
    <td valign=\"top\">Added chiller plant templates.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.BaseClasses.FlowModels</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der2<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der2<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv_der<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv_der2<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv_der<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow_inv_der2
    </td>
    <td valign=\"top\">Added exact inverse functions and their first and second order derivatives.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Examples.VAVReheat</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.BaseClasses.ASHRAE2006
    </td>
    <td valign=\"top\">Corrected wrong value assignment of <code>ratVMinVAV_flow</code>.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4863\">Buildings, #4863</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.ASHRAE.G36</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.ModeAndSetPoints<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctColdDuctMin.Controller<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Controller<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanCVF.Subsequences.DamperValves<br/>
                       Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.SeriesFanVVF.Subsequences.DamperValves
    </td>
    <td valign=\"top\">Added missing and corrected wrong parameter and connector attributes.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4844\">Buildings, #4844</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.DHC.ETS</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.DHC.ETS.Combined.Subsystems.BaseClasses.PartialHeatPump
    </td>
    <td valign=\"top\">Corrected medium specification in the condenser water pump.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4845\">Buildings. #4845</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls.OBC.CDL.Logical</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.OBC.CDL.Logical.TrueFalseHold
    </td>
    <td valign=\"top\">Refactored the relational expression in the <code>elsewhen</code> condition into a
                       Boolean variable declared outside the <code>when</code> clause so that the event-generating
                       condition and the <code>if</code> condition inside the <code>when</code> body are guaranteed
                       to evaluate identically.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4836\">Buildings, #4836</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.BaseClasses.FlowModels</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow
    </td>
    <td valign=\"top\">Updated the <code>inverse</code> annotation to use the exact inverse functions,
                       and set <code>Inline=false</code> on the power law functions so that OpenModelica
                       applies the <code>inverse</code> annotation.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.Generic_2MW
    </td>
    <td valign=\"top\">Added default values for <code>TApp_nominal</code>, <code>mPla_flow_nominal</code>,
                       <code>mRac_flow_nominal</code>, <code>medPla</code>, <code>medRac</code>, and
                       <code>phiGlyRac</code>, and updated <code>pumpExtHead</code> so that the total pump
                       head decreases monotonically with flow rate.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Air</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Air.Rack_P
    </td>
    <td valign=\"top\">Added minimum fan speed parameter <code>yMin</code> for outlet temperature control.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.FanControllers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.FanControllers.OutletTemperature
    </td>
    <td valign=\"top\">Exposed parameters <code>yMin</code> and <code>xi_start</code> for the PI controller.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.Air<br/>
                       Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.AirLiquid
    </td>
    <td valign=\"top\">Exposed minimum fan speed parameter <code>yMin</code> for outlet temperature control.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Liquid.Data</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Liquid.Data.Generic<br/>
                       Buildings.Fluid.DataCenters.Racks.Liquid.Data.OCP_1kW_OAM_PG25<br/>
                       Buildings.Fluid.DataCenters.Racks.Liquid.Data.OCP_1kW_OAM_Water
    </td>
    <td valign=\"top\">Added optional parameter <code>PColPla_nominal</code> to specify the nominal heat
                       flow rate of a single cold plate, and set <code>PColPla_nominal=1000</code> in the
                       1 kW Open Accelerator Module data records.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation
    </td>
    <td valign=\"top\">Corrected the species mass balance by adding the term
                       <code>-medium.Xi*der(m)</code> to account for the change in total fluid mass.
                       For typical HVAC applications, the change in results is small.<br/>
                       This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2168\">IBPSA, #2168</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Geothermal</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Borefields.TOUGH.BaseClasses.GroundResponse
    </td>
    <td valign=\"top\">Improved the python interface code to avoid permission error.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4783\">issue 4783</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.TableData2DLoadDepSHC
    </td>
    <td valign=\"top\">Refactored the relational expression in the <code>when</code> condition into a
                       Boolean variable declared outside the <code>when</code> clause so that the event-generating
                       condition and the <code>if</code> condition inside the <code>when</code> body are guaranteed
                       to evaluate identically.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4836\">Buildings, #4836</a>.
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
 <tr><td colspan=\"2\"><b>Buildings.Fluid.Boilers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.BoilerPolynomial<br/>
                       Buildings.Fluid.Boilers.BoilerTable
    </td>
    <td valign=\"top\">Corrected calculation of heat loss.
                       This change requires the <code>heatPort</code> to be connected; otherwise
                       the translation stops with an error message. Besides this change,
                       the model is backward compatible.<br/>
                       This is for <a href=\"https://www.github.com/lbl-srg/modelica-buildings/issues/4475\">issue #4475</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.CDUs.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.BaseClasses.PartialCDU
    </td>
    <td valign=\"top\">Removed the unused parameters <code>computeFlowResistancePla</code> and
                       <code>computeFlowResistanceRac</code>.
                       This change is not backward compatible, and a conversion script is provided.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.CDU_epsNTU
    </td>
    <td valign=\"top\">Removed the inherited unused parameters <code>computeFlowResistancePla</code> and
                       <code>computeFlowResistanceRac</code>.
                       This change is not backward compatible, and a conversion script is provided.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Active.Generic
    </td>
    <td valign=\"top\">Removed the inherited unused parameters <code>cpCoo_nominal</code> and
                       <code>cpAir_nominal</code>.
                       This change is not backward compatible, and a conversion script is provided.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Data.Passive.Generic
    </td>
    <td valign=\"top\">Removed the unused parameters <code>cpCoo_nominal</code> and
                       <code>cpAir_nominal</code>.
                       This change is not backward compatible, and a conversion script is provided.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.VertivLiebertXDU1350
    </td>
    <td valign=\"top\">Corrected the nominal mass flow rates (<code>mRac_flow_nominal</code> and <code>mPla_flow_nominal</code>),
                       the nominal external pump head and pump head curve (<code>dpPumpExt_nominal</code> and <code>pumpExtHead</code>),
                       and the rack-side filter design pressure drop (<code>dpFilRac_nominal</code>)
                       to match the manufacturer data sheet.<br/>
                       This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4872\">Buildings, #4872</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.CDUs.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.BaseClasses.PartialCDU
    </td>
    <td valign=\"top\">Propagated <code>mPla_flow_small</code> and <code>mRac_flow_small</code> to <code>hex</code>,
                       propagated <code>from_dpRac</code>, <code>linearizeFlowResistanceRac</code>, and
                       <code>dat.deltaMRac</code> to <code>fil</code>, aligned controller initial integrator states
                       with <code>yVal_start</code> and <code>yPum_start</code>, set <code>senTemRacSup.tau=0</code>,
                       and enforced strict monotonicity in <code>pumpDP_isMonotonicDecreasing</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.Generic_epsNTU<br/>
                       Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.GoogleProjectDeschutes_2MW<br/>
                       Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.VertivLiebertXDU1350
    </td>
    <td valign=\"top\">Evaluated plant-side fluid properties at <code>TPlaIn_nominal</code> instead of
                       <code>TRacOut_nominal</code> in <code>Generic_epsNTU</code>, aligned nominal temperatures,
                       heat flow rates, and external pump heads with specification tables in
                       <code>GoogleProjectDeschutes_2MW</code> and <code>VertivLiebertXDU1350</code>, and updated
                       pump head parameters so that the total pump head decreases monotonically without unphysical
                       shutoff heads.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.BaseClasses.density_TX_a<br/>
                       Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.BaseClasses.dynamicViscosity_TX_a<br/>
                       Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.BaseClasses.prandtlNumber_TX_a<br/>
                       Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.BaseClasses.specificHeatCapacityCp_TX_a<br/>
                       Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.BaseClasses.thermalConductivity_TX_a
    </td>
    <td valign=\"top\">Ignored the glycol mass fraction <code>X_a</code> when <code>medium</code> is set to water.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.BaseClasses.Fan
    </td>
    <td valign=\"top\">Set <code>per.peak.eta=eta_nominal</code> so that <code>eta_nominal</code> sets the peak
                       combined fan and motor efficiency instead of defaulting to <i>0.7</i>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Hybrid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Hybrid.AirLiquidRearDoorHexActive<br/>
                       Buildings.Fluid.DataCenters.Racks.Hybrid.AirRearDoorHexActive
    </td>
    <td valign=\"top\">Propagated <code>dat.reaDooHex.PFan_nominal</code> and <code>dat.reaDooHex.eta_nominal</code>
                       to <code>reaDooHex</code>, and exposed <code>energyDynamicsReaDooHex</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses.AirLiquid
    </td>
    <td valign=\"top\">Computed <code>nColPla</code> using <code>dat.liq.PColPla_nominal</code> when positive and
                       <code>MediumLiq</code> density instead of a hardcoded water density.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Liquid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Liquid.ColdPlateR_P
    </td>
    <td valign=\"top\">Propagated <code>linearized</code> and <code>dat.deltaM</code> to <code>preDro</code>,
                       and computed <code>nColPla</code> from <code>dat.PColPla_nominal</code> when positive.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Liquid.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Liquid.BaseClasses.CaseTemperature
    </td>
    <td valign=\"top\">Scaled <code>deltaX</code> in <code>smoothMax</code> by <code>V_flow_small</code> instead of
                       <code>delta</code> to avoid distorting the thermal resistance <code>R</code> at operating flow
                       rates and to avoid a division-by-zero singularity near zero flow, and corrected
                       <code>relErrR</code> to compute the relative error instead of the ratio.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.Active
    </td>
    <td valign=\"top\">Set <code>senTAirReaDooHexOut.tau=0</code> to avoid an unintended dynamic state in
                       steady-state mode.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.BaseClasses</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.RearDoorHeatExchangers.BaseClasses.PartialRearDoorHeatExchanger
    </td>
    <td valign=\"top\">Set <code>senTAirReaDooHexIn.tau=0</code> to avoid an unintended dynamic state in
                       steady-state mode, and added mass flow rate bounds on the fluid ports when flow reversal
                       is disabled.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.FixedResistances</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.PressureDrop<br/>
                       Buildings.Fluid.BaseClasses.FlowModels.powerLawData
    </td>
    <td valign=\"top\">Corrected the pressure difference where the flow becomes turbulent
                       for flow exponents <code>1 &lt; n &lt; 2</code>.
                       <code>powerLaw_dp</code>, which is used with <code>from_dp=true</code>
                       and as the inverse of <code>powerLaw_m_flow</code>, applied the regularization for
                       <code>abs(m_flow) &lt; k^(1-1/n)*m_flow_turbulent</code>
                       rather than for <code>abs(m_flow) &lt; m_flow_turbulent</code>.<br/>
                       This is for <a href=\"https://www.github.com/lbl-srg/modelica-buildings/issues/4800\">issue #4800</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters
    </td>
    <td valign=\"top\">Fixed typos and grammatical errors in documentation and parameter descriptions.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Examples.CDU_epsNTU
    </td>
    <td valign=\"top\">Aligned <code>dpSet</code> with <code>dpRac_nominal</code>, updated <code>MediumRac</code>
                       reference temperatures, and updated <code>datCDU.pumpExtHead</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Air.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Air.Examples.Rack_P
    </td>
    <td valign=\"top\">Set boundary air temperature <code>sou.T</code> to <code>dat.TIn_nominal</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Liquid.BaseClasses.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Liquid.BaseClasses.Examples.CaseTemperature
    </td>
    <td valign=\"top\">Scaled <code>casTem.V_flow_nominal</code> by <code>nPar</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.DataCenters.Racks.Liquid.Data</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.DataCenters.Racks.Liquid.Data.OCP_1kW_OAM_Water
    </td>
    <td valign=\"top\">Corrected <code>defaultComponentName</code> from <code>datTheRes</code> to <code>dat</code>.
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
end Version_15_0_0;
