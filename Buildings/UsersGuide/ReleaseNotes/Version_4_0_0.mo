within Buildings.UsersGuide.ReleaseNotes;
class Version_4_0_0 "Version 4.0.0"
  extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
   <div class=\"release-summary\">
   <p>
   Version 4.0.0 is a major new release. It is the first release
   that is based on the <i>Modelica IBPSA Library</i>
   (<a href=\"https://github.com/ibpsa/modelica\">https://github.com/ibpsa/modelica</a>).
   All models simulate with Dymola 2017 FD01 and with JModelica,
   and the results of these simulators have been cross-compared and are
   equal within the expected tolerance.
   </p>
   <p>
     The following major changes have been done:
   <ul>
   <li>
   It no longer uses the <code>Modelica_StateGraph2</code>
   library. Instead, it uses <code>Modelica.StateGraph</code> which is part
   of the Modelica Standard Library.
   </li>
   <li>
   The models in <code>Buildings.Fluid.Movers</code> have been refactored to increase
   the numerical robustness at very low speed when the fans or pumps are switched on or off.
   </li>
   <li>
   The following new packages have been added:
   <ul>
   <li>
   <code>Buildings.Obsolete.DistrictHeatingCooling</code>
   with models for district heating and cooling
   with bi-directional flow in the distribution pipes.
   </li>
   <li>
   <code>Buildings.Fluid.FMI.Adaptors</code> and
   <code>Buildings.Fluid.FMI.ExportContainers</code>, which
   allow export of HVAC systems and of thermal zones as
   Functional Mockup Units.
   </li>
   <li>
   <code>Buildings.Fluid.HeatExchangers.ActiveBeams</code>,
   with active beams for cooling and heating.
   </li>
   <li>
   <code>Buildings.Fluid.DXSystems.WaterCooled</code>,
   with water-cooled direct expansion cooling coils.
   </li>
   <li>
   <code>Buildings.ThermalZones.ReducedOrder</code>, with
   reduced order models of thermal zones based on VDI 6007
   that are suitable for district energy simulation.
   </li>
   </ul>
   </li>
   <li>
   The package <code>Buildings.Rooms</code> has been renamed to <code>Buildings.ThermalZones.Detailed</code>.
   This was done because of the introduction of <code>Buildings.ThermalZones.ReducedOrder</code>,
   which is from the <code>Annex60</code> library,
   in order for thermal zones to be in the same top-level package.<br/>
   For Dymola, the conversion script will update models that use any model of the package
   <code>Buildings.Rooms</code>.
   </li>
   <li>
   The model <code>Buildings.Fluid.FixedResistances.FixedResistanceDpM</code> has been refactored. Now, if
   the hydraulic diameter is not yet known, one can use the simpler model
   <code>Buildings.Fluid.FixedResistances.PressureDrop</code>, otherwise the model
   <code>Buildings.Fluid.FixedResistances.HydraulicDiameter</code> may be used.
   With this refactoring, also the model <code>Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM</code> has
   been renamed to <code>Buildings.Fluid.FixedResistances.Junction</code> and
   parameters that use the hydraulic diameter have been removed.
   </li>
   <li>
   The models <code>Buildings.HeatTransfer.Conduction.SingleLayer</code>,
   <code>Buildings.HeatTransfer.Conduction.MultiLayer</code>,
   and <code>Buildings.HeatTransfer.Windows.Window</code> have been refactored
   to add the option to place a state at the surface of a construction.
   This leads in many examples that use the room model to a smaller number
   of non-linear system of equations and a 20% to 40% faster simulation.
   </li>
   <li>
   The models <code>Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater</code>
   and <code>Buildings.Fluid.HeatPumps.ScrollWaterToWater</code> have been added.
   Parameters to these models rely on calibration with tabulated heat pump performance
   data. Python scripts for the calibration of the heat pump models are in
   <code>Buildings/Resources/src/fluid/heatpumps/calibration</code>.
   This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/587\">issue 587</a>.
   </li>
   </ul>
   </div>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">

   <tr><td valign=\"top\">Buildings.Obsolete.DistrictHeatingCooling
       </td>
       <td valign=\"top\">Package with models for district heating and cooling
                          with bi-directional flow in the distribution pipes.

       </td>
       </tr>

   <tr><td valign=\"top\">Buildings.Fluid.FMI.Adaptors<br/>
                          Buildings.Fluid.FMI.ExportContainers
       </td>
       <td valign=\"top\">Library with adaptors to export HVAC systems and thermal zones
                          as a Functional Mockup Unit for Model Exchange.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
       </td>
       </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.ActiveBeams
       </td>
       <td valign=\"top\">Package with models of active beams for space cooling and heating.
       </td>
       </tr>

    <tr><td valign=\"top\">Buildings.Fluid.DXSystems.WaterCooled
       </td>
       <td valign=\"top\">Package with models of water-cooled direct expansion
                          cooling coils with single speed, variable speed
                          or multi-stage compressor.
        </td>
        </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.Compressors
       </td>
       <td valign=\"top\">Package with models of compressors for heat pumps.
       </td>
       </tr>

     <tr><td valign=\"top\">Buildings.ThermalZones.ReducedOrder
       </td>
       <td valign=\"top\">Package with reduced order models of thermal zones based
                        on VDI 6007.
       </td>
       </tr>

   </table>
   <!-- New components for existing libraries -->
   <p>
   The following <b style=\"color:blue\">new components</b> have been added
   to <b style=\"color:blue\">existing</b> libraries:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.Velocity
       </td>
       <td valign=\"top\">Sensor for the flow velocity.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.EvaporatorCondenser
       </td>
       <td valign=\"top\">Model for evaporator/condenser with refrigerant experiencing constant temperature phase change.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater
       </td>
       <td valign=\"top\">Model for water to water heat pump with a reciprocating compressor.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.ScrollWaterToWater
       </td>
       <td valign=\"top\">Model for water to water heat pump with a scroll compressor.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer.Windows.BaseClasses</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.HeatCapacity
       </td>
       <td valign=\"top\">Model for adding a state on the room-facing surface of a window.
This closes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
       </td>
   </tr>


   <tr><td colspan=\"2\"><b>Buildings.Media</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Media.Refrigerants.R410A
       </td>
       <td valign=\"top\">Model for thermodynamic properties of refrigerant R410A.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Media.Specialized.Water.ConstantProperties_pT
       </td>
       <td valign=\"top\">Model for liquid water with constant properties at user-selected temperature.<br/>
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">IBPSA, #511</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Math.IntegratorWithReset
       </td>
       <td valign=\"top\">Integrator with optional input that allows
                          resetting the state if the input changes from <code>false</code>
                          to <code>true</code>.<br/>
                          This closes
                           <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/494\">IBPSA, #494</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Utilities.Time</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Utilities.Time.CalendarTime
       </td>
       <td valign=\"top\">Block that outputs the calendar time, time of the week, hour of the day etc.<br/>
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/501\">IBPSA, #501</a>.
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
   <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples.GetHeaderElement<br/>
                          Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath<br/>
                          Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3<br/>
                          Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                          Buildings.BoundaryConditions.SolarGeometry.ProjectedShadowLength
       </td>
       <td valign=\"top\">Refactored the use of <code>Modelica.Utilities.Files.loadResource</code>
                          to make the model work in JModelica.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">issue 506</a>.
                          <br/>
                          Removed the use of <code>Modelica.Utilities.Files.fullPathName</code>
                          in <code>Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
                          </code> which is implicitly done in <code>Modelica.Utilities.Files.loadResource.
                          </code>
                          <br/>
                          Removed in
                          <code>Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
                          </code>the addition of <code>file://</code> to file names which do not start
                          with <code>file://</code>, or <code>modelica://</code>.
                          This is not required when using
                          <code>Modelica.Utilities.Files.loadResource</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/539\">issue 539</a>.
                          </td>
       </tr>
       <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
       </td>
       <td valign=\"top\">Shifted the computation of the infrared irradiation such that
                          the results in <code>Buildings.BoundaryConditions.SkyTemperature.Examples.BlackBody</code>
                          are consistent for both option of the black-body sky temperature calculation.
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/648\">IBPSA, #648</a>.
       </td>
       </tr>
       <tr>
       <td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.SkyClearness
       </td>
       <td valign=\"top\">Reduced tolerance for regularization if the sky clearness is near one or eight.
                          This closes
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/521\">IBPSA, #521</a>.

       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Controls</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.Continuous.LimPID<br/>
                          Buildings.Controls.Continuous.PIDHysteresis<br/>
                          Buildings.Controls.Continuous.PIDHysteresisTimer<br/>
          </td>
          <td valign=\"top\">Added option to reset the control output when an optional Boolean input signal
                           changes from <code>false</code> to <code>true</code>.<br/>
                           This closes
                           <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/494\">IBPSA, #494</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Electrical</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Electrical.DC.Storage.Examples.Battery
       </td>
       <td valign=\"top\">Replaced <code>Modelica_StateGraph2</code> with
                          <code>Modelica.StateGraph</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Examples</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.ClosedLoop<br/>
                          Buildings.Examples.VAVReheat.ClosedLoop

       </td>
       <td valign=\"top\">Added hysteresis to the economizer control to avoid many events.
                          This change was done in
                          <code>Buildings.Examples.VAVReheat.Controls.EconomizerTemperatureControl</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/502\">issue 502</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.ClosedLoop

       </td>
       <td valign=\"top\">Set <code>filteredSpeed=false</code> in fan models to avoid a large
                          increase in computing time when simulated between <i>t=1.60E7</i>
                          and <i>t=1.66E7</i>.

       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.VAVReheat.ClosedLoop

       </td>
       <td valign=\"top\">Changed chilled water supply temperature to <i>6&deg;C</i>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/509\">issue 509</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.ChillerPlant.BaseClasses.Controls.BatteryControl<br/>
                          Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl<br/>
                          Buildings.Examples.HydronicHeating.TwoRoomsWithStorage<br/>
                          Buildings.Examples.Tutorial.Boiler.System7
       </td>
       <td valign=\"top\">Replaced <code>Modelica_StateGraph2</code> with
                          <code>Modelica.StateGraph</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.SingleLayer
       </td>
       <td valign=\"top\">Added option to place a state at the surface of a construction.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.MultiLayer
       </td>
       <td valign=\"top\">Added option to place a state at the surface of a construction.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.HeatTransfer.Windows.Window
       </td>
       <td valign=\"top\">Added option to place a state at the surface of a construction.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BeamDepthInRoom
       </td>
       <td valign=\"top\">Refactored the use of <code>Modelica.Utilities.Files.loadResource</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">issue 506</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.CFD<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange
       </td>
       <td valign=\"top\">Refactored the use of <code>Modelica.Utilities.Files.loadResource</code>.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">issue 506</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                          Buildings.ThermalZones.Detailed.CFD
       </td>
       <td valign=\"top\">Refactored the distribution of the diffuse solar irradiation.
                          Previously, the model assumed that all diffuse irradiation first hits the floor before it is
                          diffusely reflected to all other surfaces. Now, the incoming diffuse solar irradiation is distributed
                          to all surfaces, proportional to their emissivity plus transmissivity times area.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/451\">issue 451</a>.
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
   <tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3
       </td>
       <td valign=\"top\">This function is used to read location coordinates
                          from the TMY3 weather data file. The call to
                          <code>Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</code>
                          has been removed as it calls the function
                          <code>Modelica.Utilities.Files.loadResource</code>, whose return value needs
                          to be known at compilation time to store the weather data in the FMU.
                          This is not supported by JModelica.
                          Most models should still work as this call has been added at a higher level
                          of the model hierarchy. If models don't work, add a call to <code>loadResource</code>
                          at the top-level.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Controls</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.Continuous.PIDHysteresis
       </td>
       <td valign=\"top\">Set <code>zer(final k=0)</code> and made
                          <code>swi</code>, <code>zer</code> and
                          <code>zer1</code> protected, as they are for
                          <code>Buildings.Controls.Continuous.PIDHysteresis</code>.
                          Only models that access these instances, which typically is not the case,
                          are affected by this change.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.Continuous.LimPID<br/>
                          Buildings.Controls.Continuous.PIDHysteresis<br/>
                          Buildings.Controls.Continuous.PIDHysteresisTimer<br/>
          </td>
          <td valign=\"top\">Removed the parameter <code>limitsAtInit</code> as
                           it is not used.<br/>
                           For Dymola, the conversion script will update models that set this parameter.<br/>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Controls.SetPoints.Table
       </td>
       <td valign=\"top\">Changed protected final parameter <code>nCol</code> to <code>nRow</code>.<br/>
                          For Dymola, the conversion script will update models that access this parameter.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/555\">issue 555</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.Actuators</b>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                          Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                          Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening<br/>
                          Buildings.Fluid.Actuators.Valves.TwoWayTable
       </td>
       <td valign=\"top\">Renamed the parameter
                          <code>filteredOpening</code> to
                          <code>use_inputFilter</code>.<br/>
                          For Dymola, the conversion script will update models that access this parameter.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">IBPSA, #665</a>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                          Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br/>
                          Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow
       </td>
       <td valign=\"top\">Renamed the parameters
                          <code>use_v_nominal</code> and all area related parameters,
                          because <code>m_flow_nominal</code> and <code>v_nominal</code>
                          are used to compute the area.<br/>
                          For Dymola, the conversion script will update models that access this parameter.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/544\">IBPSA, #544</a>
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.Chillers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Chillers.Carnot_TEva<br/>
                          Buildings.Fluid.Chillers.Carnot_y
       </td>
       <td valign=\"top\">Removed the parameters
                          <code>effInpEva</code> and
                          <code>effInpCon</code>.
                          Now, always the leaving water temperatures are used to compute the coefficient
                          of performance (COP). Previously, the
                          entering water temperature could be used, but this can give COPs that are higher than
                          the Carnot efficiency if the temperature lift is small.
                          For Dymola, the conversion script will update models.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">IBPSA, #497</a>
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.FixedResistances</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FixedResistances.FixedResistanceDpM
       </td>
       <td valign=\"top\">Renamed
                          <code>Buildings.Fluid.FixedResistances.FixedResistanceDpM</code> to
                          <code>Buildings.Fluid.FixedResistances.PressureDrop</code>
                          and removed the parameters <code>use_dh</code>, <code>dh</code> and <code>ReC</code>.
                          For Dymola, the conversion script will update models.
                          If a model needs to be used that allows specifying <code>dh</code> and <code>ReC</code>,
                          then the new model
                          <code>Buildings.Fluid.FixedResistances.HydraulicDiameter</code> can be used.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM
       </td>
       <td valign=\"top\">Renamed
                          <code>Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM</code> to
                          <code>Buildings.Fluid.FixedResistances.Junction</code>
                          and removed the parameters <code>use_dh</code>, <code>dh</code> and <code>ReC</code>.
                          For Dymola, the conversion script will update models.
                          If a model needs to be used that allows specifying <code>dh</code> and <code>ReC</code>,
                          then use <code>Buildings.Fluid.FixedResistances.Junction</code> with
                          <code>dp_nominal = 0</code> (which removes the pressure drop) and use
                          <code>Buildings.Fluid.FixedResistances.HydraulicDiameter</code> at each fluid port.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.FMI</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.FMI.InletAdaptor<br/>
                          Buildings.Fluid.FMI.OutletAdaptor<br/>
                          Buildings.Fluid.FMI.TwoPort<br/>
                          Buildings.Fluid.FMI.TwoPortComponent
       </td>
       <td valign=\"top\">Renamed
                          <code>Buildings.Fluid.FMI.InletAdaptor</code> to
                          <code>Buildings.Fluid.FMI.Adaptors.Inlet</code>,<br/>
                          renamed
                          <code>Buildings.Fluid.FMI.OutletAdaptor</code> to
                          <code>Buildings.Fluid.FMI.Adaptors.Outlet</code>,<br/>
                          renamed
                          <code>Buildings.Fluid.FMI.TwoPort</code> to
                          <code>Buildings.Fluid.FMI.ExportContainers.PartialTwoPort</code>,<br/>
                          renamed
                          <code>Buildings.Fluid.FMI.TwoPortComponent</code> to
                          <code>Buildings.Fluid.FMI.ExportContainers.ReplaceableTwoPort</code>.
                          This was due to the restructuring of the <code>Buildings.Fluid.FMI</code>
                          package for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.<br/>
                          For Dymola, the conversion script updates these models.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
       </td>
   </tr>
   <tr><td valign=\"top\">
                          Buildings.Fluid.DXSystems.AirCooled.SingleSpeed<br/>
                          Buildings.Fluid.DXSystems.AirCooled.VariableSpeed<br/>
                          Buildings.Fluid.DXSystems.AirCooled.MultiStage<br/>
                          Buildings.Fluid.DXSystems.Data
       </td>
       <td valign=\"top\">Renamed
                          <code>Buildings.Fluid.DXSystems.AirCooled.SingleSpeed</code> to<br/>
                          <code>Buildings.Fluid.DXSystems.AirCooled.SingleSpeed</code>,<br/>
                          <code>Buildings.Fluid.DXSystems.AirCooled.VariableSpeed</code> to<br/>
                          <code>Buildings.Fluid.DXSystems.AirCooled.VariableSpeed</code>,<br/>
                          <code>Buildings.Fluid.DXSystems.AirCooled.MultiStage</code> to<br/>
                          <code>Buildings.Fluid.DXSystems.AirCooled.MultiStage</code> and<br/>
                          <code>Buildings.Fluid.DXSystems.Data</code> to<br/>
                          <code>Buildings.Fluid.DXSystems.AirCooled.Data</code>.<br/>
                          This was due to the addition of the new package
                          <code>Buildings.Fluid.DXSystems.WaterCooled</code>.
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/635\">Buildings, #635</a>.<br/>
                          For Dymola, the conversion script updates these models.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Fluid.HeatPumps</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatPumps.Carnot_TEva<br/>
                          Buildings.Fluid.HeatPumps.Carnot_y
       </td>
       <td valign=\"top\">Removed the parameters
                          <code>effInpEva</code> and
                          <code>effInpCon</code>.
                          Now, always the leaving water temperatures are used to compute the coefficient
                          of performance (COP). Previously, the
                          entering water temperature could be used, but this can give COPs that are higher than
                          the Carnot efficiency if the temperature lift is small.
                          For Dymola, the conversion script will update models.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">IBPSA, #497</a>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes
       </td>
       <td valign=\"top\">Moved the package <code>Buildings.Fluid.HeatExchangers.Boreholes</code> to
                          <code>Buildings.Fluid.Geothermal.Boreholes</code>.
                          This is for compatibility with an ongoing model development that will include
                          a borefield model.<br/>
                          For Dymola, the conversion script will update models that use any model of the package
                          <code>Buildings.Fluid.HeatExchangers.Boreholes</code>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Movers
       </td>
       <td valign=\"top\">Removed the function
                          <code>Buildings.Fluid.Movers.BaseClasses.Characteristics.flowApproximationAtOrigin</code>
                          and changed the arguments of the function
                          <code>Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</code>.<br/>
                          This was done due to the refactoring of the fan and pump model for low speed. This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/458\">IBPSA, #458</a>.<br/>
                          Users who simply use the existing model in <code>Buildings.Fluid.Movers</code> are not affected by
                          this change as the function are called by a low-level implementation only.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.Movers.
                          Buildings.Fluid.Movers.FlowControlled_dp<br/>
                          Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                          Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                          Buildings.Fluid.Movers.SpeedControlled_y
       </td>
       <td valign=\"top\">Renamed the parameter
                          <code>filteredSpeed</code> to
                          <code>use_inputFilter</code>.<br/>
                          For Dymola, the conversion script will update models that access this parameter.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/665\">IBPSA, #665</a>
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers
       </td>
       <td valign=\"top\">Changed the name of the function
                          <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.efficiency</code>
                          to
                          <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.normalizedPower</code>.
                          Changed the name of the record
                          <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.efficiencyParameters</code>
                          to
                          <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics.fan</code>,
                          and changed the parameter of this record from
                          <code>eta</code> to <code>r_P</code>.
                          This change was done as the performance is for the relative power consumption, and not the fan
                          efficiency, as the old parameter name suggests.
                          Users who use the default parameters are not affected by this change.
                          If the default parameters were changed, then for Dymola,
                          the conversion script will update the model.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
       </td>
   </tr>
       <tr><td valign=\"top\">Buildings.HeatTransfer.BaseClasses.TransmittedRadiation<br/>
                              Buildings.HeatTransfer.BaseClasses.WindowRadiation
       </td>
       <td valign=\"top\">Refactored the model to allow separate treatment for the diffuse and direct irradiation,
                          which is needed for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/451\">issue 451</a>.
       </td>
    </tr>

    <tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.BaseClasses.PartialConstruction
       </td>
       <td valign=\"top\">Removed parameter <code>A</code> as it is already declared in
                          <code>Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor</code>
                          which is often used with this class.
       </td>
    </tr>

   <tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed

       </td>
       <td valign=\"top\">Moved package from <code>Buildings.Rooms</code> to <code>Buildings.ThermalZones.Detailed</code>.
                          This was done because <code>Buildings</code> has a new package
                          <code>Buildings.ThermalZones.ReducedOrder</code> with reduced order building models.
                          Hence, the more detailed room models should be in the same top-level package as they
                          are also for modeling of thermal zones.<br/>
                          For Dymola, the conversion script will update models that use any model of the package
                          <code>Buildings.ThermalZones</code>.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.CFD<br/>
                          Buildings.ThermalZones.Detailed.MixedAir<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.CFDAirHeatMassBalance<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatMassBalance<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.PartialAirHeatMassBalance<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance

       </td>
       <td valign=\"top\">Refactored implementation of latent heat gain for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">Buildings, #515</a>.
                          Users who simply use <code>Buildings.MixedAir.Rooms.CFD</code> or
                          <code>Buildings.MixedAir.Rooms.MixedAir</code> will not be affected by this change,
                          except if they access variables related to the heat gain.

       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.AirHeatMassBalanceMixed<br/>
                          Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatGain
       </td>
       <td valign=\"top\">Removed models as these are no longer needed due after the refactoring
                          of the room model for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">Buildings, #515</a>.
       </td>
    </tr>
    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance<br/>
                           Buildings.ThermalZones.Detailed.BaseClasses.SolarRadiationExchange
       </td>
       <td valign=\"top\">Refactored the distribution of the diffuse solar irradiation, which required replacing the
                          input and output signals.
                          Previously, the model assumed that all diffuse irradiation first hits the floor before it is
                          diffusely reflected to all other surfaces. Now, the incoming diffuse solar irradiation is distributed
                          to all surfaces, proportional to their emissivity plus transmissivity times area.<br/>
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/451\">issue 451</a>.
" +
 "       </td>
    </tr>

   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.CFDHeatGain
       </td>
       <td valign=\"top\">Renamed model from <code>Buildings.ThermalZones.Detailed.BaseClasses.CFDHeatGain</code> to
                          <code>Buildings.ThermalZones.Detailed.BaseClasses.HeatGain</code>.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">Buildings, #515</a>.
       </td>
   </tr>

   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange
       </td>
       <td valign=\"top\">Removed the parameter <code>uStart</code> as it is not required. As this is in a base
                          class, users typically won't need to change their models
                          unless they use this base class directly.<br/>
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/579\">Buildings, #579</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Utilities</b>
       </td>
   </tr>
       <tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.WetBul_pTX
       </td>
       <td valign=\"top\">Deleted the model
                          <code>Buildings.Utilities.Psychrometrics.WetBul_pTX</code>
                          as the same functionality is provided by
                          <code>Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi</code>.
                          Users who use <code>Buildings.Utilities.Psychrometrics.WetBul_pTX</code>
                          need to replace the model manually and reconnect the input and output ports.<br/>
                          This is for
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/475\">IBPSA, #475</a>.
       </td>
    </tr>

   </table>
   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.DXSystems.AirCooled.MultiStage<br/>
                          Buildings.Fluid.DXSystems.AirCooled.SingleSpeed<br/>
                          Buildings.Fluid.DXSystems.AirCooled.VariableSpeed<br/>
                          Buildings.Fluid.DXSystems.AirCooled.BaseClasses.Evaporation
       </td>
       <td valign=\"top\">Corrected the computation of the wet bulb state in the model
                          that computes the reevaporation of water vapor into the air stream when the coil
                          is switched off. The results change slightly.
                          This closes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/520\">issue 520</a>
                          and integrates the change of
                          <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/474\">IBPSA, #474</a>.

       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
       </td>
       <td valign=\"top\">Corrected computation of the heat exchanger location which was wrong
                          if <code>hHex_a &lt; hHex_b</code>, e.g., the port a of the heat exchanger
                          is below the port b.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/531\">issue 531</a>.
       </td>
   </tr>   <tr><td colspan=\"2\"><b>Buildings.Examples</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Examples.VAVReheat.ClosedLoop<br/>
                          Buildings.Examples.DualFanDualDuct.ClosedLoop<br/>
                          Buildings.Examples.VAVReheat.Controls.Economizer
       </td>
       <td valign=\"top\">Corrected the economizer controller which closed
                          the outside air when there was no freeze concern during summer.
                          This closes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/511\">issue 511</a>.
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
   <tr><td valign=\"top\">Buildings.Electrical.AC.OnePhase.Sources.Grid<br/>
                          Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Grid<br/>
                          Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Grid_N
       </td>
       <td valign=\"top\">Corrected sign error in documentation string of
                          variable <code>P</code>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.HeatExchanger.WetCoilCounterFlow<br/>
                          Buildings.Fluid.HeatExchanger.WetCoilDiscretized
       </td>
       <td valign=\"top\">Redeclared <code>Medium2</code> to force it to be a subclass
                          of <code>Modelica.Media.Interfaces.PartialCondensingGases</code>.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/544\">
                          issue 544</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Storage
       </td>
       <td valign=\"top\">Removed medium declaration, which is not needed and inconsistent with
                          the declaration in the base class.<br/>
                          This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/544\">
                          issue 544</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Validation.BESTEST</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900<br/>
                          Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900
       </td>
       <td valign=\"top\">Added missing <code>parameter</code> keyword,
                          which is required as the variable (for the materials) is assigned to a parameter.
                          This is for
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/543\">issue 543</a>.
       </td>
   </tr>
   </table>
   </html>"));
end Version_4_0_0;
