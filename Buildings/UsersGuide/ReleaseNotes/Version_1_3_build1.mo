within Buildings.UsersGuide.ReleaseNotes;
class Version_1_3_build1 "Version 1.3 build 1"
  extends Modelica.Icons.ReleaseNotes;
   annotation (preferredView="info", Documentation(info="<html>
<p>
In version 1.3 build 1, models for direct evaporative cooling coils with multiple stages or with
a variable speed compressor have been added.
This version also contains improvements to the fan and pump models to better treat zero mass flow rate.
Various other improvements have been made to improve the numerics and to use consistent variable names.
A detailed list of changes is shown below.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.DXSystems
    </td>
    <td valign=\"top\">Library with direct evaporative cooling coils.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl
    </td>
    <td valign=\"top\">Added chilled water plant model with continuous time control that
                       replaces the discrete time control in
                       <code>Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl</code>.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi
    </td>
    <td valign=\"top\">Function that computes moisture concentration based
                       on saturation pressure, total pressure and relative
                       humidity.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi
    </td>
    <td valign=\"top\">Block that computes the wet bulb temperature for given
                     dry bulb temperature, relative humidity and atmospheric pressure.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.WetBul_pTX
    </td>
    <td valign=\"top\">Block that computes the temperature and mass fraction
                       at the wet bulb state for given dry bulb temperature,
                       species concentration and atmospheric pressure.
    </td>
    </tr>
</table>
<!-- Backward compatbile changes -->
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
    <td valign=\"top\">Added computation of the wet bulb temperature.
                       Computing the wet bulb temperature introduces a nonlinear
                       equation. As we have not observed an increase in computing time
                       because of computing the wet bulb temperature, it is computed
                       by default. By setting the parameter
                       <code>computeWetBulbTemperature=false</code>, the computation of the
                       wet bulb temperature can be removed.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">Added <code>pre</code> operator and relaxed tolerance in <code>assert</code> statement.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.SpeedControlled_y<br/>
    </td>
    <td valign=\"top\">Reformulated implementation of efficiency model
                       to avoid a division by zero at zero mass flow rate
                       for models in which a user specifies
                       a power instead of an efficiency performance curve.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi
    </td>
    <td valign=\"top\">Added option to approximate the wet bulb temperature using an
                     explicit equation.
                     Reformulated the original model to change the dimension of the
                     nonlinear system of equations from two to one.
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
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                       Buildings.BoundaryConditions.Types
    </td>
    <td valign=\"top\">Improved the optional inputs for the radiation data global horizontal, diffuse horizontal and direct normal radiation.
    If a user specifies two of them, the third will be automatically calculated.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody
    </td>
    <td valign=\"top\">Renamed <code>radHor</code> to <code>radHorIR</code>
                       to indicate that the radiation is in the infrared
                       spectrum.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.BaseClasses.DoorDiscretized<br/>
                     Buildings.Airflow.Multizone.DoorDiscretizedOpen<br/>
                     Buildings.Airflow.Multizone.DoorDiscretizedOperable<br/>
                     Buildings.Airflow.Multizone.Orifice<br/>
                     Buildings.Airflow.Multizone.ZonalFlow_ACS<br/>
                     Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential<br/>
                     Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                     Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br/>
                     Buildings.Fluid.BaseClasses.PartialResistance<br/>
                     Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                     Buildings.Fluid.Movers.BaseClasses.PowerInterface<br/>
                     Buildings.Fluid.Storage.BaseClasses.Buoyancy<br/>
                     Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange
    </td>
    <td valign=\"top\">Renamed protected parameters for consistency with the naming conventions.
                     In previous releases, fluid properties had the suffix <code>0</code>
                     or <code>_nominal</code> instead of <code>_default</code> when they
                     where computed based on the medium default properties.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                     Buildings.Fluid.Sensors.LatentEnthalpyFlowRate
    </td>
    <td valign=\"top\">Moved computation of parameter <code>i_w</code> to new base class
                     <code>Buildings.Fluid.BaseClasses.IndexWater</code>
                     The value of this parameter is now assigned dynamically and does not require to be specified
                     by the user.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier
    </td>
    <td valign=\"top\">Removed unused protected parameters <code>sta0</code> and <code>cp0</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl<br/>
                       Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond<br/>
                       Buildings.Examples.ChillerPlant.BaseClasses.Controls.ZeroOrderHold
    </td>
    <td valign=\"top\">Re-implemented the controls for setpoint reset.
    Revised the model <code>TrimAndRespond</code> and deleted the model <code>ZeroOrderHold</code>.
    Improved the documentation.
    </td>
</tr>
</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl
    </td>
    <td valign=\"top\">Fixed error in wet bulb temperature. The previous version used
                     a model to compute the wet bulb temperature that takes as an
                     input the relative humidity, but required mass fraction as an input.
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
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                       Buildings.BoundaryConditions.SkyTemperature.BlackBody
    </td>
    <td valign=\"top\">Renamed <code>radHor</code> to <code>radHorIR</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.Examples.InverseFlowFunction
    </td>
    <td valign=\"top\">Fixed error in the documentation.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger
    </td>
    <td valign=\"top\">Fixed broken link in the documentation.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters
    </td>
    <td valign=\"top\">Fixed wrong <code>displayUnit</code> and
                       <code>max</code> attribute for power.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes
    </td>
    <td valign=\"top\">In documentation, removed reference to the parameter
                       <code>use_HeatTransfer</code> which no longer exists.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.Functions.glassPropertyUncoated
    </td>
    <td valign=\"top\">Improved the documentation for implementation and added comments for model limitations.
    </td>
</tr>
</table>
<!-- Github issues -->
<!-- none -->
</html>"));
end Version_1_3_build1;
