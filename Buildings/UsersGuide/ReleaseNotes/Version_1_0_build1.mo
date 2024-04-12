within Buildings.UsersGuide.ReleaseNotes;
class Version_1_0_build1 "Version 1.0 build 1"
  extends Modelica.Icons.ReleaseNotes;
   annotation (preferredView="info", Documentation(info="<html>
<p>
Version 1.0 is the first official release of the <code>Buildings</code>
library.
Compared to the last pre-release, which is version 0.12, this version contains
new models as well as significant improvements to the model formulation
that leads to faster and more robust simulation. A detailed list of changes is shown below.
</p>
<p>
Version 1.0 is not backward compatible to version 0.12, i.e., models developed with
versions 0.12 will require some changes in their parameters to
work with version 1.0.
The conversion script
<a href=\"modelica://Buildings/Resources/Scripts/Conversion/ConvertBuildings_from_0.12_to_1.0.mos\">
Buildings/Resources/Scripts/Conversion/ConvertBuildings_from_0.12_to_1.0.mos</a> can help
in converting old models to this version of the library.
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes</td>
    <td valign=\"top\">
    This is a library with a model for a borehole heat exchanger.
    </td></tr>
</table>
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b></td></tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.BaseClasses.windPressureLowRise
                      </td>
    <td valign=\"top\">Added a function that computes wind pressure on the facade of low-rise buildings.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.Examples</b></td></tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant
                      </td>
    <td valign=\"top\">Added an example for a chilled water plant model.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.UsersGuide
                      </td>
    <td valign=\"top\">Added a user's guide that describes
                       the main functionality of all base classes.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.Sources</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.Outside_Cp<br/>
                       Buildings.Fluid.Sources.Outside_CpLowRise
                      </td>
    <td valign=\"top\">Added models to compute wind pressure on building
                       facades.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b></td></tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conductor
                      </td>
    <td valign=\"top\">Added a model for heat conduction in circular coordinates.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.ThermalZones.Detailed.Examples</b></td></tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Examples.BESTEST
                      </td>
    <td valign=\"top\">Added BESTEST validation models.
    </td> </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b></td></tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation<br/>
                       Buildings.Utilities.Math.Functions.splineDerivatives.
                      </td>
    <td valign=\"top\">Added functions for cubic hermite spline interpolation, with
                       option for monotone increasing (or decreasing) spline.
    </td> </tr>
</table>

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b></td></tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.BaseClasses.powerLaw</td>
    <td valign=\"top\">This function has been reimplemented to handle zero flow rate
                     in a more robust and more efficient way.
                     This change improves all components that model flow resistance in
                     the package Buildings.Airflow.Multizone.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b></td></tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3</td>
    <td valign=\"top\">This model has now the option of using a constant value,
                     using the data from the weather file, or from an input connector for 7 variables,
                     including atmospheric pressure, relative humidity, dry bulb temperature,
                     global horizontal radiation, diffuse horizontal radiation,
                     wind direction and wind speed.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b></td></tr>
<tr><td valign=\"top\">
                      Buildings.Fluid.Actuators.BaseClasses.PartialActuator<br/>
                      Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential<br/>
                      Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve<br/>
                      Buildings.Fluid.BaseClasses.PartialResistance<br/>
                      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp<br/>
                      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow<br/>
                      Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</td>
    <td valign=\"top\">The computation of the linearized flow resistance has been moved from
                     the functions to the model, i.e., into an equation section.
                     If the linear implementation is in a function body, then a symbolic processor
                     may not invert the equation. This can lead to systems of coupled equations in
                     cases where an explicit solution is possible.
                     In addition, the handling of zero flow rate has been improved for the nonlinear
                     pressure drop model.
                     These improvements affect all models in <code>Buildings.Fluid</code> that compute
                     flow resistance.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</td>
    <td valign=\"top\">This model can now be configured as a steady-state or dynamic model.</td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow<br/>
                     Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br/>
                     Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                     Buildings.Fluid.HeatExchangers.WetCoilDiscretized</td>
    <td valign=\"top\">The implementation for handling zero flow rate, if the models
are used as steady-state models, have been improved.</td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ</td>
    <td valign=\"top\">Changed implementation to use
                     <code>Modelica.Media.Common.OneNonLinearEquation</code> instead of
                     <code>Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</code>,
                     which was removed for this version of the library.
                     </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers.CoolingTowers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc<br/>
                     Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</td>
    <td valign=\"top\">
       These models are now based on a new base class <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower</code>.
       This allows using the models as replaceable models without warning when checking the model.
    </td></tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</td>
    <td valign=\"top\">
       Changed implementation of performance curve to avoid division by zero.
    </td></tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.MassExchangers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.MassExchangers.HumidifierPrescribed</td>
    <td valign=\"top\">This model can now be configured as a steady-state or dynamic model.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.*TwoPort</td>
    <td valign=\"top\">All sensors with two ports, except for the mass flow rate sensor,
                     have been revised to add sensor dynamics.
                     Adding sensor dynamics avoids numerical problems when mass flow
                     rates are close to zero and the sensor is configured to allow
                     flow reversal. See
                     <code>Buildings.Fluid.Sensors.UsersGuide</code> for details.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Storage</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Stratified<br/>
                     Buildings.Fluid.Storage.StratifiedEnhanced</td>
    <td valign=\"top\">Changed the implementation of the model <code>Buoyancy</code>
                     to make it differentiable in the temperatures.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Media</b></td></tr>
<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleMedium<br/>
                     Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</td>
    <td valign=\"top\">Moved the assignment of the <code>stateSelect</code> attribute for
                     the <code>BaseProperties</code> to the model
                     <code>Buildings.Fluid.MixingVolumes.MixingVolume</code>. This allows
                     to handle it differently for steady-state and dynamic models.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities.Psychrometrics</b></td></tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.TDewPoi_pW</td>
    <td valign=\"top\">Changed implementation to use
                     <code>Modelica.Media.Common.OneNonLinearEquation</code> instead of
                     <code>Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</code>,
                     which was removed for this version of the library.
                     </td>
</tr>

</table>

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b></td></tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.MediumColumnDynamic</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow.
This required the introduction of a new parameter <code>m_flow_nominal</code>
that is used for the regularization near zero mass flow rate.</td></tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Examples.Stratified<br/>
                     Buildings.Fluid.MixingVolumes</td>
    <td valign=\"top\">
                     Removed the parameters <code>use_T_start</code> and <code>h_start</code>,
                     as <code>T_start</code> is more convenient to use than <code>h_start</code>
                     for building simulation.
                     </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Boilers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.BoilerPolynomial</td>
    <td valign=\"top\">The parameter <code>dT_nominal</code> has been removed
as it can be computed from the parameter <code>m_flow_nominal</code>.
This change was needed to avoid a non-literal value for the nominal
attribute for the mass flow rate in the pressure drop model.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.MixingVolumes</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                     Buildings.Fluid.MixingVolumes.MixingVolumeDryAir<br/>
                     Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow if the components have exactly two fluid ports connected.
This required the introduction of a new parameter <code>m_flow_nominal</code>
that is used for the regularization near zero mass flow rate.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.SpeedControlled_y<br/>
                     Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                     Buildings.Fluid.Movers.FlowControlled_dp<br/>
                     Buildings.Fluid.Movers.FlowControlled_m_flow</td>
    <td valign=\"top\">
                     The performance data are now defined through records and not
                     through replaceable functions. The performance data now needs to be
                     declared in the form<pre>
 pressure(V_flow_nominal={0,V_flow_nominal,2*V_flow_nominal},
          dp_nominal={2*dp_nominal,dp_nominal,0})</pre>
                     where <code>pressure</code> is an instance of a record. A similar declaration is
                     used for power and efficiency.
                     <br/>
                     The parameter m_flow_nominal has been removed from
                     FlowMachine_y and FlowMachine_Nrpm.
                                <br/>
                     The parameter m_flow_max has been replaced by m_flow_nominal in
                     FlowMachine_m_flow.
                                <br/>
                     The implementation of the pressure drop computation as a function
                     of speed and volume flow rate has been revised to avoid a singularity
                     near zero volume flow rate and zero speed.<br/>
                     The implementation has also been simplified to avoid using two different flow paths
                     if the models are configured for steady-state or dynamic simulation.</td></tr>



<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.FourPortHeatMassExchanger<br/>
                     Buildings.Fluid.Interfaces.PartialDynamicStaticFourPortHeatMassExchanger<br/>
                     Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                     Buildings.Fluid.Interfaces.PartialDynamicStaticTwoPortHeatMassExchanger<br/>
                     Buildings.Fluid.Interfaces.ConservationEquation</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow if the components have exactly two fluid ports connected.</td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TemperatureTwoPortDynamic</td>
    <td valign=\"top\">This model has been deleted since the sensor
                     <code>Buildings.Fluid.Sensors.TemperatureTwoPort</code> has been revised
                     and can now also be used as a dynamic model of a sensor.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Interfaces</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialStaticTwoPortInterface</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.PartialTwoPortInterface</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialStaticStaticTwoPortHeatMassExchanger</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPortHeatMassExchanger</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPort</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.FourPort</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialStaticStaticFourPortHeatMassExchanger</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialStaticFourPortInterface</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.PartialFourPortInterface</td>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPortHeatMassExchanger</td>
    <td valign=\"top\">Renamed to Buildings.Fluid.Interfaces.FourPortHeatMassExchanger</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b></td></tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</td>
    <td valign=\"top\">This package has been removed, and all functions have been
                       revised to use Modelica.Media.Common.OneNonLinearEquation.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities.Reports</b></td></tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Files.Printer<br/>
                     Buildings.Utilities.IO.Files.BaseClasses.printRealArray</td>
    <td valign=\"top\">Changed parameter <code>precision</code> to <code>significantDigits</code> and
                     <code>minimumWidth</code> to <code>minimumLength</code>
                     to use the same terminology as the Modelica Standard Library.</td>
</tr>

</table>

<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">


<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody</td>
    <td valign=\"top\">Fixed error in <code>if-then</code> statement that led to
                       a selection of the wrong branch to compute the sky temperature.</td></tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b></td></tr>
<tr><td valign=\"top\">Buildings.Media.PartialSimpleMedium<br/>
                       Buildings.Media.GasesConstantDensity.SimpleAir</td>
    <td valign=\"top\">Fixed error in assignment of <code>singleState</code> parameter.
                       This change can lead to different initial conditions if the density of
                       water is modeled as a function of pressure, or if the
                       medium model Buildings.Media.GasesConstantDensity.SimpleAir is used.</td></tr>

<tr><td valign=\"top\">Buildings.Media.GasesConstantDensity<br/>
                       Buildings.Media.GasesConstantDensity.MoistAir<br/>
                       Buildings.Media.GasesConstantDensity.MoistAirUnsaturated<br/>
                       Buildings.Media.GasesConstantDensity.SimpleAir</td>
    <td valign=\"top\">Fixed error in the function <code>density</code> which returned a non-constant density,
                     and added a call to <code>ModelicaError(...)</code> in <code>setState_dTX</code> since this
                     function cannot assign the medium pressure based on the density (as density is a constant
                     in this model).
</td></tr>

<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</td>
    <td valign=\"top\">Updated package with a new copy from the Modelica Standard Library, since
                     the Modelica Standard Library fixed a bug in computing the internal energy of the medium.
                     This bug led to very fast temperature transients at the start of the simulation.
</td></tr>

<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleMedium</td>
    <td valign=\"top\">Fixed bug in function density, which always returned <code>d_const</code>,
                       regardless of the value of <code>constantDensity</code>.
</td></tr>

<tr><td valign=\"top\">Buildings.Media.GasesPTDecoupled</td>
    <td valign=\"top\">Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases.
                       For this medium, the function is <code>u=h-pStd/dStp</code>.
</td></tr>

<tr><td valign=\"top\">Buildings.Media.GasesConstantDensity</td>
    <td valign=\"top\">Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases.
                       For this medium, the function is <code>u=h-p/dStp</code>.
</td></tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b></td></tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                     Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditions</td>
    <td valign=\"top\">Fixed bug (<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/35\">issue 35</a>)
                     that leads to the wrong solar heat gain for
                     roofs and for floors. Prior to this bug fix, the outside facing surface
                     of a ceiling received solar irradiation as if it were a floor
                     and vice versa.</td></tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.MixedAir<br/>
                     Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow</td>
    <td valign=\"top\">Fixed bug (<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/36\">issue 36</a>)
                     that leads to too high a surface temperature of the window frame when
                     it receives solar radiation. The previous version did not compute
                     the infrared radiation exchange between the
                     window frame and the sky.</td></tr>

</table>

<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, but, e.g.,
units are wrong or errors in documentation):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation</td>
    <td>Corrected wrong unit label.
    </td>
</tr>
</table>

<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/8\">&#35;8</a></td>
    <td valign=\"top\">
         Add switches for new data.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/19\">&#35;19</a></td>
    <td valign=\"top\">
         Shift the time for the radiation data 30 min forth and output the local civil time in the data reader.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/41\">&#35;41</a></td>
    <td valign=\"top\">
       Using when-then sentences to reduce CPU time.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/43\">&#35;43</a></td>
    <td valign=\"top\">
         Add a ConvertRadiation to convert the unit of radiation from TMY3.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/28\">&#35;28</a></td>
    <td valign=\"top\">
         Move scripts to Buildings\\Resources\\Scripts\\Dymola.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/18\">&#35;18</a></td>
    <td valign=\"top\">
         Add a smooth interpolation function to avoid the event.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Media</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/30\">&#35;30</a></td>
    <td valign=\"top\">
         Removed non-required structurally incomplete annotation.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/35\">&#35;35</a></td>
    <td valign=\"top\">
         Wrong surface tilt for radiation at exterior surfaces of floors and ceilings.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/36\">&#35;36</a></td>
    <td valign=\"top\">
         High window frame temperatures.
    </td>
</tr>
</table>

<p>
Note:
</p>
<ul>
<li>
The version number scheme has been changed. It is now identical to the one used by the Modelica Standard Library.
Versions are identified with two numbers <code>x.y</code> and a build number. The first official
release of each version has the build number <code>1</code>. For each released bug fix,
the build number is incremented.
See
<code>Modelica.UsersGuide.ReleaseNotes.VersionManagement</code> for details.
</li>
<li>
To allow adding scripts for multiple simulation environments,
all scripts have been moved to the directory <code>Buildings/Resources/Scripts/Dymola</code> and the annotation that
generates the entry in the <code>Command</code> pull down menu has been changed to
<code>__Dymola_Commands(file=...)</code>
</li>
</ul>
</html>"));
end Version_1_0_build1;
