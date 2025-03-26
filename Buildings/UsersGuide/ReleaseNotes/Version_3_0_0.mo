within Buildings.UsersGuide.ReleaseNotes;
class Version_3_0_0 "Version 3.0.0"
  extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 3.0.0 is a major new release.
   </p>
   <p>
     The following major changes have been done:
   <ul>
     <li>
       Electrochromic windows have been added. See <code>Buildings.ThermalZones.Detailed.Examples.ElectroChromicWindow</code>.
     </li>
     <li>
       The models in <code>Buildings.Fluid.Movers</code> can now be configured to use
       three different control input signals: a continuous signal (depending on the model
       either normalized speed, speed in rpm, prescribed mass flow rate or prescribed head),
       discrete stages of these quantities, or on/off.
       The models also have been refactored to make their implementation clearer.
     </li>
     <li>
       The new package <code>Buildings.Fluid.HeatPumps</code> has been added.
       This package contains models for idealized heat pumps
       whose COP changes proportional to the change in COP of a Carnot cycle,
       with an optional correction for the part load efficiency.
     </li>
     <li>
       Various models, in particular in the package <code>Buildings.Electrical</code>,
       have been reformulated to comply with the Modelica Language Definition.
       All models comply with the pedantic Modelica check of Dymola.
     </li>
   </ul>
   </div>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps
       </td>
       <td valign=\"top\">Library with heat pump models.
                          This library contains models for idealized heat pumps
                          whose COP changes proportional to the change in COP of a Carnot cycle.
                          Optionally, a part load efficiency curve can be specified.
                          The model <code>Buildings.Fluid.HeatPumps.Carnot_TCon</code>
                          takes as a control input the leaving
                          condenser fluid temperature, and the model
                          <code>Buildings.Fluid.HeatPumps.Carnot_y</code> takes as
                          a control signal the compressor speed.
       </td>
       </tr>
   </table>
   <!-- New components for existing libraries -->
   <p>
   The following <b style=\"color:blue\">new components</b> have been added
   to <b style=\"color:blue\">existing</b> libraries:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.SolarGeometry</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength
       </td>
       <td valign=\"top\">Block that computes the length of a shadow projected onto a horizontal plane
                          into the direction that is perpendicular to the azimuth of a surface.
       </td>
       </tr>
   <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Adapter3to3<br/>
                        Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Connection3to3Ground_n<br/>
                        Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Connection3to3Ground_p
       </td>
       <td valign=\"top\">Adapters for unbalanced three phase systems which are required because
                        the previous formulation used connect statements that violate the Modelica
                        Language Definition. This change was required to enable pedantic model check and translation
                        in Dymola 2016 FD01.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/426\">#426</a>.
       </td>
       </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot_TEva
       </td>
       <td valign=\"top\">Chiller model whose efficiency changes with temperatures
                          similarly to a change in Carnot efficiency. The control input signal
                          is the evaporator leaving fluid temperature.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/353\">IBPSA, #353</a>.
       </td>
       </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.PPM<br/>
                          Buildings.Fluid.Sensors.PPMTwoPort
       </td>
       <td valign=\"top\">Sensors that measure trace substances in parts per million.
       </td>
       </tr>
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BeamDepthInRoom
       </td>
       <td valign=\"top\">Block that computes the maximum distance at which
                          a solar beam that enters the window hits the workplane.
       </td>
       </tr>
   <tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Math.Functions.smoothInterpolation
       </td>
       <td valign=\"top\">Function that interpolates for vectors <code>xSup[]</code>, <code>ySup[]</code>
                          and independent variable <code>x</code>.
                          The interpolation is done using a cubic Hermite spline with linear extrapolation.
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
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayLinear
    </td>
    <td valign=\"top\">Changed the default value for valve leakage
                       parameter <code>l</code> from <code>0</code> to <code>0.0001</code>.
                       This is the same value as is used for the two-way valves,
                       and avoids an assertion that would be triggered if <code>l=0</code>.
    </td>
    </tr>

    <tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes.UTube
       </td>
       <td valign=\"top\">Updated code for 64 bit on Linux and Windows.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/485\">issue 485</a>.
       </td>
    </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryEffectivenessNTU
    </td>
    <td valign=\"top\">Reformulated model to allow translation in OpenModelica.
                       This is for issue
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/490\">#490</a>.
    </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot
    </td>
    <td valign=\"top\">Changed the sign convention for <code>dTEva_nominal</code>.
                       Now, this quantity needs to be negative.
                       This change was done to be consistent with other models.
                       In this version, a warning will be written if the sign
                       is not updated, but the results will be the same.
                       In future versions the warning will be
                       changed to an error.<br/>
                       The parameters <code>dTEva_nominal</code> and
                       <code>dTCon_nominal</code> are now used
                       to assign default values for the nominal mass flow rates.
    </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                          Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
    </td>
    <td valign=\"top\">Added the parameter <code>use_C_flow</code>. If set
                       to <code>true</code>, an input connector will be enabled that can be used
                       to add a trace substance flow rate, such as CO2, to the volume.
    </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.FlowControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.FlowControlled_y
    </td>
    <td valign=\"top\">Added the parameter <code>inputType</code> which allows
                       to set the input as an continuous input signal,
                       to set the input as an Integer input signal that selects the stage of the mover,
                       or to remove the input connector and use a parameter
                       to assign the control signal.
    </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
       </td>
       <td valign=\"top\">Added option to set dynamics of heat exchanger material
                        separately from the dynamics of the fluid inside the heat
                        exchanger.
                        This is for issue
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/434\">#434</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.FourPortHeatMassExchanger<br/>
                          Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger

       </td>
       <td valign=\"top\">Propagated parameter <code>allowFlowReversal</code>
                          which can cause a simpler energy balance to be used.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPortTransport

       </td>
       <td valign=\"top\">Implemented more efficient computation of <code>port_a.Xi_outflow</code>
                          and <code>port_a.C_outflow</code> when <code>allowFlowReversal=false</code>.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/305\">IBPSA issue 305</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp<br/>
                        Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow

       </td>
       <td valign=\"top\">Refactored for a more efficient implementation.
                        Removed double declaration of <code>smooth(..)</code> and <code>smoothOrder</code>
                        and changed <code>Inline=true</code> to <code>LateInline=true</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/301\">IBPSA issue 301</a>
                        and for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/279\">IBPSA issue 279</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange
       </td>
       <td valign=\"top\">Set <code>start</code> and <code>fixed</code>
                          attributes in
                          <code>u[nWri](start=_uStart, each fixed=true)</code>
                          to avoid a warning in Dymola 2016 about unspecified initial conditions.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/422\">issue 422</a>.<br/>
                          Set <code>start</code> and <code>fixed</code>
                          attributes in
                          <code>firstTrigger(start=false, fixed=true)</code>,
                          <code>retVal(start=0, fixed=true)</code> and <code>modTimRea(fixed=false)</code>
                          to avoid such a warning in the pedantic Modelica check in Dymola 2016.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/459\">issue 459</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.CFD
       </td>
       <td valign=\"top\">Updated code for 64 bit on Linux and Windows.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/485\">issue 485</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Math.Functions
       </td>
       <td valign=\"top\">Refactored <code>Buildings.Utilities.Math.Functions.inverseXRegularized</code>
                        to make it more efficient as it is used in many steady-state energy balances.
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/302\">IBPSA issue 302</a>.
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
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody<br/>
                          Buildings.BoundaryConditions.WeatherData.Bus
     </td>
       <td valign=\"top\">Renamed the connector from <code>radHorIR</code> to <code>HHorIR</code>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">IBPSA issue 376</a>.
                          For Dymola, the conversion script updates these connections.
                          However, this also results in a renaming of the weather bus variable
                          <code>weaBus.radHorIR</code> to <code>HHorIR</code>, which may
                          require a manual update.
       </td>
     </tr>

    <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
     </td>
     <td valign=\"top\">Removed the constant <code>sensibleOnly</code> and
                        introduced instead the parameter <code>use_mWat_flow</code>.
                        The new parameter, if set to <code>true</code>, will enable an input connector
                        that can be used to add water to the conservation equation.
                        For Dymola, the conversion script updates the model for these changes.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot
     </td>
     <td valign=\"top\">Renamed the model to  <code>Buildings.Fluid.Chillers.Carnot_y</code>
                        due to the addition of the new model <code>Buildings.Fluid.Chillers.Carnot_TEva</code>.
                        In addition, the following parameter names were changed:
                        <code>use_eta_Carnot</code> was changed to <code>use_eta_Carnot_nominal</code>, and
                        <code>etaCar</code> was changed to <code>etaCarnot_nominal</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/353\">IBPSA issue 353</a>.
                        For Dymola, the conversion script removes these parameters.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.FlowControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.FlowControlled_y
     </td>
     <td valign=\"top\">Removed the parameters <code>use_powerCharacteristics</code>
                        and <code>motorCooledByFluid</code> as these are already
                        declared in the performance data record <code>per</code>.
                        This is for issue
                        <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/434\">#457</a>.
                        For Dymola, the conversion script removes these parameters.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.FlowControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.FlowControlled_y
     </td>
     <td valign=\"top\">Removed the public variable <code>r_N</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">IBPSA issue 417</a>.
                        For Dymola, the conversion script removes
                        assignments of <code>r_N(start)</code>.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow
   </td>
   <td valign=\"top\">Write a warning if no pressure curve is provided because
                     the efficiency calculation can only be done correctly if a pressure curve
                     is provided. The warning can be suppressed by providing a pressure curve, or
                     by setting <code>nominalValuesDefineDefaultPressureCurve=true</code>.
     </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Movers.Data
     </td>
     <td valign=\"top\">Replaced the parameters
                        <code>Buildings.Fluid.Movers.Data.FlowControlled</code>,
                        <code>Buildings.Fluid.Movers.Data.SpeedControlled_y</code>, and
                        <code>Buildings.Fluid.Movers.Data.SpeedControlled_Nrpm</code> by
                        the parameter
                        <code>Buildings.Fluid.Movers.Data.Generic</code>
                        which is used for all four types of movers.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">IBPSA issue 417</a>.
                        This change allows to correctly compute the fan or pump power also for the models
                        <code>Buildings.Fluid.Movers.FlowControlled_dp</code>,
                        <code>Buildings.Fluid.Movers.FlowControlled_m_flow</code>
                        for speeds that are different from the nominal speed, provided that the user
                        specifies the pressure curve.
                        For Dymola, the conversion script updates this parameter.<br/><br/>
                        In the previous record
                        <code>Buildings.Fluid.Movers.Data.SpeedControlled_Nrpm</code>,
                        changed the parameter <code>N_nominal</code> to <code>speed_rpm_nominal</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">IBPSA issue 396</a>.
                        For Dymola, the conversion script updates this parameter.
     </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.BaseClasses.PartialThreeWayResistance<br/>
                          Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine<br/>
                          Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.FlowControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.FlowControlled_y<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage
     </td>
     <td valign=\"top\">Removed parameter <code>dynamicBalance</code> that overwrote the setting
                        of <code>energyDynamics</code> and <code>massDynamics</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/411\">
                        IBPSA, issue 411</a>.
                        For Dymola, the conversion script updates the models.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPort
     </td>
     <td valign=\"top\">Renamed the protected parameters
                        <code>port_a_exposesState</code>, <code>port_b_exposesState</code> and
                        <code>showDesignFlowDirection</code>.
                        This is for
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/349\">IBPSA issue 349</a>
                        and
                        <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/351\">IBPSA issue 351</a>.
                        For Dymola, the conversion script updates models
                        that extend from <code>Buildings.Fluid.Interfaces.PartialTwoPort</code>.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.FourPort
     </td>
     <td valign=\"top\">Renamed model to <code>Buildings.Fluid.Interfaces.PartialFourPort</code> and
                        removed the parameters
                        <code>h_outflow_a1_start</code>,
                        <code>h_outflow_b1_start</code>,
                        <code>h_outflow_a2_start</code> and
                        <code>h_outflow_b2_start</code>
                        to make the model similar to <code>Buildings.Fluid.Interfaces.PartialTwoPort</code>.
                        See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/299\">IBPSA issue 299</a>
                        for a discussion.
                        For Dymola, the conversion script updates models
                        that extend from <code>Buildings.Fluid.Interfaces.FourPort</code>.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
       </td>
       <td valign=\"top\">
                        Revised implementation of conservation equations and
                        added default values for outlet quantities at <code>port_a</code>
                        if <code>allowFlowReversal=false</code>.
                        This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/281\">IBPSA issue 281</a>.
                        Also, revised implementation so that equations are always consistent
                        and do not lead to division by zero,
                        also when connecting a <code>prescribedHeatFlowRate</code>
                        to <code>MixingVolume</code> instances.
                        Renamed <code>use_safeDivision</code> to <code>prescribedHeatFlowRate</code>.
                        See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">IBPSA issue 282</a>
                        for a discussion.
                        For users who simply instantiate existing component models, this change is backward
                        compatible.
                        However, developers who implement component models that extend from
                        <code>Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</code> may need to update
                        the parameter <code>use_safeDivision</code> and use instead <code>prescribedHeatFlowRate</code>.
                        See the model documentation.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                          Buildings.ThermalZones.Detailed.CFD
       </td>
       <td valign=\"top\">These models can now be used with electrochromic windows.
                          This required to change the glass properties
                          <code>tauSol</code>, <code>rhoSol_a</code> and <code>rhoSol_b</code>
                          to be arrays. For example, to convert an existing model, use
                          <code>tauSol={0.6}</code> instead of <code>tauSol=0.6</code>.
                          For Dymola, the conversion script will automatically
                          update existing models.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Obsolete</b>
       </td>
   <tr><td valign=\"top\">Buildings.Obsolete.Fluid.Movers<br/>
                          Buildings.Obsolete.Media
       </td>
       <td valign=\"top\">Removed these packages which have models from
                          release 2.0.0.
       </td>
   </tr>
   </table>
   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot
       </td>
       <td valign=\"top\">Corrected wrong computation of state of leaving fluid
                          <code>staB1</code> and <code>staB2</code>
                          for the configuration without flow reversal.
                          The previous implementation mistakenly used the <code>inStream</code> operator.
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/476\">
                          issue 476</a>
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
   <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Electrical.Interfaces.PartialWindTurbine
       </td>
       <td valign=\"top\">Reformulated test for equality of <code>Real</code> variables. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.SingleLayer<br/>
                          Buildings.HeatTransfer.Data.BaseClasses
       </td>
       <td valign=\"top\">Reformulated test for equality of <code>Real</code> variables. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FMI.FlowSplitter_u
       </td>
       <td valign=\"top\">Corrected wrong assert statement. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/442\">issue 442</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot
       </td>
       <td valign=\"top\">Corrected wrong assert statement for test on the efficiency function. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/468\">issue 468</a>.
       </td>
   </tr>


   <tr><td colspan=\"2\"><b>Buildings.Media</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Media.Specialized.Water.TemperatureDependentDensity
       </td>
       <td valign=\"top\">Removed dublicate entry of <code>smooth</code> and <code>smoothOrder</code>.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">IBPSA issue 303</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatGain
       </td>
       <td valign=\"top\">Reformulated test for equality of <code>Real</code> variables. This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
       </td>
   </tr>


   <tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Math.Functions.BaseClasses.der_2_regNonZeroPower<br/>
                          Buildings.Utilities.Math.Functions.BaseClasses.der_polynomial<br/>
                          Buildings.Utilities.Math.Functions.BaseClasses.der_regNonZeroPower

       </td>
       <td valign=\"top\">Corrected wrong derivative implementation and improved their regression tests.
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">IBPSA issue 303</a>.

       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Utilities.Psychrometrics</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Density_pTX
       </td>
       <td valign=\"top\">Corrected wrong default component name.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.saturationPressure
       </td>
       <td valign=\"top\">Changed <code>smoothOrder</code> from <i>5</i> to <i>1</i> as
                         <code>Buildings.Utilities.Math.Functions.spliceFunction</code> is only once
                         continuously differentiable.
                         Inlined the function.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Utilities.IO.Python27</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.IO.Python27.exchange
       </td>
       <td valign=\"top\">Updated Python implementation to allow compiling code
                          on 64 bit Linux. Previously, on Linux a segmentation fault
                          occurred during run-time if 64 bit code rather than
                          32 bit code was generated. This is now corrected.<br/>
                          Also, Windows 64 bit binaries have been added.<br/>
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/287\">issue 287</a>.
       </td>
   </tr>

   </table>
   </html>"));
end Version_3_0_0;
