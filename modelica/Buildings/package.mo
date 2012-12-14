within ;
package Buildings "Library with models for building energy and control systems"
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  class Conventions "Conventions"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<p>
This library follows the conventions of the 
<a href=\"modelica://Modelica.UsersGuide.Conventions\">Modelica Standard Library</a>, which are as follows:
</p>
<p>
Note, in the html documentation of any Modelica library,
the headings \"h1, h2, h3\" should not be used,
because they are utilized from the automatically generated documentation/headings.
Additional headings in the html documentation should start with \"h4\".
</p>
<p>
In the Modelica package the following conventions are used:
</p>
<p>
<ol>
<li> Class and instance names are written in upper and lower case
  letters, e.g., \"ElectricCurrent\". An underscore is only used
  at the end of a name to characterize a lower or upper index,
  e.g., \"pin_a\".</li>

<li> <b>Class names</b> start always with an upper case letter.</li>

<li> <b>Instance names</b>, i.e., names of component instances and
  of variables (with the exception of constants),
  start usually with a lower case letter with only
  a few exceptions if this is common sense
  (such as \"T\" for a temperature variable).</li>

<li> <b>Constant names</b>, i.e., names of variables declared with the
  \"constant\" prefix, follow the usual naming conventions
  (= upper and lower case letters) and start usually with an
  upper case letter, e.g. UniformGravity, SteadyState.</li>
<li> The two connectors of a domain that have identical declarations
  and different icons are usually distinguished by \"_a\", \"_b\"
  or \"_p\", \"_n\", e.g., Flange_a/Flange_b, HeatPort_a, HeatPort_b.</li>

<li> The <b>instance name</b> of a component is always displayed in its icon
  (= text string \"%name\") in <b>blue color</b>. A connector class has the instance
  name definition in the diagram layer and not in the icon layer.
  <b>Parameter</b> values, e.g., resistance, mass, gear ratio, are displayed
  in the icon in <b>black color</b> in a smaller font size as the instance name.
 </li>

<li> A main package has usually the following subpackages:
  <ul>
  <li><b>UsersGuide</b> containing an overall description of the library
   and how to use it.</li>
  <li><b>Examples</b> containing models demonstrating the
   usage of the library.</li>
  <li><b>Interfaces</b> containing connectors and partial
   models.</li>
  <li><b>Types</b> containing type, enumeration and choice
   definitions.</li>
  </ul>
  </li>
</ol>
</p>
<p>
The <code>Buildings</code> library uses the following conventions
in addition to the ones of the Modelica Standard Library:
</p>
<ol>
<li>
The nomenclature used in the package
<a href=\"modelica://Buildings.Utilities.Psychrometrics\">
Buildings.Utilities.Psychrometrics</a>
 is as follows, 
<ul>
<li>
Uppercase <code>X</code> denotes mass fraction per total mass.
</li>
<li>
Lowercase <code>x</code> denotes mass fraction per mass of dry air.
</li>
<li>
The notation <code>z_xy</code> denotes that the function or block has output
<code>z</code> and inputs <code>x</code> and <code>y</code>.
</li>
<li>
The symbol <code>pW</code> denotes water vapor pressure, <code>TDewPoi</code> 
denotes dew point temperature, <code>TWetBul</code> denotes wet bulb temperature,
and <code>TDryBul</code> (or simply <code>T</code>) denotes dry bulb temperature.
</li>
</ul>
<li>
Names of models, blocks and packages should start with an upper-case letter and be a
noun or a noun with a combination of adjectives and nouns.
Use camel-case notation to combine multiple words, such as <code>HeatTransfer</code>.
</li>
<li>
Parameter and variables names are usually a character, such as <code>T</code>
for temperature and <code>p</code> for pressure, or a combination of the first three
characters of a word, such as <code>higPreSetPoi</code> for high pressure set point.
</li>
<li>
Comments should be added to each class (package, model, function etc.).
The first character should be upper case.
For one-line comments of parameters, variables and classes, no period should be used at the end of the comment.
</li>
<li>
Where applicable, all variable must have units, also if the variable is protected.
</li>
<li>
To indicate that a class (i.e., a package, model, block etc.) has not been extensively tested or validated,
its class name ends with the string <code>Beta</code>.
</li>
</ol>
</p>
</html>
"));
  end Conventions;

  package ReleaseNotes "Release notes"
    extends Modelica.Icons.ReleaseNotes;

  class Version_1_3_build1 "Version 1.3 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (Documentation(info="<html>
<p>
Version 1.3 build 1 is ... xxx
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DXCoils
    </td>
    <td valign=\"top\">Library with direct evaporative cooling coils.
    </td>
    </tr>
</table>
</p>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td> 
</table>
</p>
<!-- Backward compatbile changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">




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
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowMachine_dp<br>
                       Buildings.Fluid.Movers.FlowMachine_m_flow<br>
                       Buildings.Fluid.Movers.FlowMachine_Nrpm<br>
                       Buildings.Fluid.Movers.FlowMachine_y<br>
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
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
</p>
<!-- Non-backward compatible changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br> 
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
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.BaseClasses.Buoyancy<br>
                     Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange
    </td>
    <td valign=\"top\">Renamed protected parameters for consistency with naming convention.
    </td>
</tr>    
<tr><td valign=\"top\">Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier
    </td>
    <td valign=\"top\">Removed unused protected parameters <code>sta0</code> and <code>cp0</code>.
    </td>
</tr> <tr><td colspan=\"2\"><b>Buildings.Examples</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl<br> 
                       Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespond<br>
                       Buildings.Examples.ChillerPlant.BaseClasses.Controls.ZeroOrderHold
    </td>
    <td valign=\"top\">Re-implemented the controls for setpoint reset. 
    Revised the model <code>TrimAndRespond</code> and deleted the model <code>ZeroOrderHold</code>.
    Improved the documentation.
    </td>
</tr>
</table>
</p>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
</p>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br>
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
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
</p>
<!-- Trac tickets -->
<p>
The following
<a href=\"https://corbu.lbl.gov/trac/bie\">trac tickets</a>
have been fixed:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/xxx\">#xxx</a>
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
</p>
</html>"));
  end Version_1_3_build1;

  class Version_1_2_build1 "Version 1.2 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (Documentation(info="<html>
<p>
In version 1.2 build 1, models for radiant slabs and window overhangs and sidefins have been added.
This version also contains various improvements to existing models.
A detailed list of changes is shown below. 
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs
    </td>
    <td valign=\"top\">Package with models for radiant slabs
                       with pipes or a capillary heat exchanger 
                       embedded in the construction.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Pipes
    </td>
    <td valign=\"top\">Package with records for pipes.
    </td>
    </tr>
</table>
</p>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.FixedShade<br>
                       Buildings.HeatTransfer.Windows.Overhang<br>
                       Buildings.HeatTransfer.Windows.SideFins
    </td>
    <td valign=\"top\">For windows with either an overhang or side fins,
                       these blocks output the fraction of the area
                       that is sun exposed.
    </td> 
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Rooms.Examples.BESTEST
    </td>
    <td valign=\"top\">Added BESTEST validation models for case 610, 620, 630, 640,
                       650FF, 650, 920, 940, 950FF, 950, and 960.
    </td> 
    </tr>
</table>
</p>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Removed assignment of <code>HGloHor_in</code> in its declaration,
                       because this gives an overdetermined system if the input connector
                       is used.<br/>
                       Added new sub-bus that contains the solar position. 
                       This allows reusing the solar position in various other models.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarIrradiation.DiffuseIsotropic<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.DiffusePerez<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffuseIsotropic<br/>
                       Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffusePerez<br/>
    </td>
    <td valign=\"top\">Added optional output of diffuse radiation from the sky and ground. 
                       This allows reusing the diffuse radiation in solar thermal collector.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth
    </td>
    <td valign=\"top\">Changed implementation to avoid an event at solar noon.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.BoreholeFillings
    </td>
    <td valign=\"top\">
                       Renamed class to <code>BoreholeFillings</code> 
                       to be consistent with data records being plural.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.GasesPTDecoupled.MoistAir<br/>
                       Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated<br/>
                       Buildings.Media.PerfectGases.MoistAir<br/>
                       Buildings.Media.PerfectGases.MoistAirUnsaturated<br/>
                       Buildings.Media.GasesConstantDensity.MoistAir<br/>
                       Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    </td>
    <td valign=\"top\">Added redeclaration of <code>ThermodynamicState</code> 
                       to avoid a warning
                       during model check and translation.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.MixedAir
    </td>
    <td valign=\"top\">Added a check that ensures that the number of surfaces
                       are equal to the length of the parameter that contains
                       the surface area, and added a check to ensure that no surface area
                       is equal to zero. These checks help detecting erroneous declarations
                       of the room model. The changes were done in 
                       <code>Buildings.Rooms.MixedAir.PartialSurfaceInterface</code>.
    </td>
</tr>
</table>
</p>
<!-- Non-backward compatbile changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.MixedAir
    </td>
    <td valign=\"top\">Added optional modeling of window overhangs and side fins.
                       The modeling of window overhangs and side fins required the 
                       introduction of the new parameters 
                       <code>hWin</code> for the window height and
                       <code>wWin</code> for the window width, in addition to the
                       parameters <code>ove</code> and <code>sidFin</code> which are used
                       to declare the geometry of overhangs and side fins.
                       The parameters <code>hWin</code> and <code>wWin</code>
                       replace the previously used parameter <code>AWin</code> for the
                       window area.
                       Users need to manually replace <code>AWin</code> with <code>hWin</code>
                       and <code>wWin</code> when updating models
                       from a previous version of the library.<br/>
                       See the information section in
                       <a href=\"modelica://Buildings.Rooms.MixedAir\">
                       Buildings.Rooms.MixedAir</a> for how to use these models.
    </td>
</tr>
</table>
</p>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">
                      Fixed a bug that caused an error in the schedule if the simulation start time was negative or equal to the first entry in the schedule.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.BaseClass.ThirdOrderStratifier
    </td>
    <td valign=\"top\">Revised the implementation to reduce the temperature overshoot.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Fixed the bug in the temperature linearization and 
                       in the heat flow through the glass layer if the transmissivity of glass
                       in the infrared regime is non-zero.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.CenterOfGlass
    </td>
    <td valign=\"top\">Fixed a bug in the parameter assignment of the instance <code>glass</code>.
                       Previously, the infrared emissivity of surface a was assigned to the surface b.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.BCVTB
    </td>
    <td valign=\"top\">Added a call to <code>Buildings.Utilities.IO.BCVTB.BaseClasses.exchangeReals</code>
                       in the <code>initial algorithm</code> section.
                       This is needed to propagate the initial condition to the server.
                       It also leads to one more data exchange, which is correct and avoids the
                       warning message in Ptolemy that says that the simulation reached its stop time
                       one time step prior to the final time.
    </td>
</tr>
</table>
</p>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Corrected the documentation of the unit requirement for 
                       input files, parameters and connectors.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialFourPortInterface<br/>
                       Buildings.Fluid.Interfaces.PartialTwoPortInterface
    </td>
    <td valign=\"top\">Replaced the erroneous function call <code>Medium.density</code> with 
                       <code>Medium1.density</code> and <code>Medium2.density</code> in
                        <code>PartialFourPortInterface</code>.
                       Changed condition to remove <code>sta_a1</code> and
                       <code>sta_a2</code> in <code>PartialFourPortInterface</code>, and
                       <code>sta_a</code> in <code>PartialTwoPortInterface</code>, to also
                       compute the state at the inlet port if <code>show_V_flow=true</code>.<br/>
                       The previous implementation resulted in a translation error
                       if <code>show_V_flow=true</code>, but worked correctly otherwise
                       because the erroneous function call is removed if  <code>show_V_flow=false</code>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric
    </td>
    <td valign=\"top\">Corrected the nominal mass flow rate used in the mass flow source.
    </td>
</tr>
</table>
</p>
<!-- Trac tickets -->
<p>
The following
<a href=\"https://corbu.lbl.gov/trac/bie\">trac tickets</a>
have been fixed:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Heat transfer in glass layer</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/56\">#56</a>
    </td>
    <td valign=\"top\">Fixed bug in heat flow through the glass layer if the infrared transmissivity is non-zero.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/57\">#57</a>
    </td>
    <td valign=\"top\">Fixed bug in temperature linearization of window glass.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Overshooting in enhanced stratified tank</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/15\">#15</a>
    </td>
    <td valign=\"top\">Revised the implementation to reduce the temperature over-shoot.
    </td>
</tr>
</table>
</html>"));
  end Version_1_2_build1;

  class Version_1_1_build1 "Version 1.1 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (Documentation(info="<html>
<p>
Version 1.1 build 1 contains improvements to models that address numerical problems.
In particular, flow machines and actuators now have an optional filter
that converts step changes in the input signal to a smooth change in 
speed or actuator position.
Also, (<a href=\"modelica://Buildings.Examples.Tutorial\">
Buildings.Examples.Tutorial</a>)
has been added to provide step-by-step instruction for how to build
system models.
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2>
<tr><td valign=\"top\">Buildings.Examples.Tutorial
    </td>
    <td valign=\"top\">Tutorial with step by step instructions for how to
                       build system models.
    </td>
    </tr>
</table>
</p>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.Pipe
    </td>
    <td valign=\"top\">Added a model for a pipe with transport delay and optional heat
                       exchange with the environment.
    </td> 
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.UsersGuide
    </td>
    <td valign=\"top\">Added a user's guide for actuator models.
    </td> 
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                     Buildings.Fluid.Interfaces.StaticConservationEquation
    </td>
    <td valign=\"top\">These base classes have been added to simplify the implementation
                     of dynamic and steady-state thermofluid models.
    </td> 
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Fuels
    </td>
    <td valign=\"top\">Package with physical properties of fuels that are used by the
                     boiler model.
    </td> 
    </tr>
</table>
</p>
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br>
                       Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br>
                       Buildings.Fluid.Actuators.Dampers.MixingBox<br>
                       Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br>
                       Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br>
                       Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br>
                       Buildings.Fluid.Actuators.Valves.TwoWayLinear<br>
                       Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening
    </td>
    <td valign=\"top\">Added an optional 2nd order lowpass filter for the input signal. 
                       The filter approximates the travel time of the actuators. 
                       It also makes the system of equations easier to solve
                       because a step change in the input signal causes a gradual change in the actuator
                       position.<br>
                       Note that this filter affects the time response of closed loop control.
                       Therefore, enabling the filter may require retuning of control loops.
                       See the user's guide of the Buildings.Fluid.Actuators package.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Boilers.BoilerPolynomial
    </td>
    <td valign=\"top\">Added computation of fuel usage and improved the documentation.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowMachine_y<br>
                       Buildings.Fluid.Movers.FlowMachine_Nrpm<br>
                       Buildings.Fluid.Movers.FlowMachine_dp<br>
                       Buildings.Fluid.Movers.FlowMachine_m_flow
    </td>
    <td valign=\"top\">Added a 2nd order lowpass filter to the input signal. 
                       The filter approximates the startup and shutdown transients of fans or pumps.
                       It also makes the system of equations easier to solve
                       because a step change in the input signal causes a gradual change in the
                       mass flow rate.<br>
                       Note that this filter affects the time response of closed loop control.
                       Therefore, enabling the filter may require retuning of control loops.
                       See the user's guide of the Buildings.Fluid.Movers package.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger
    </td>
    <td valign=\"top\">Changed model to use graphical implementation of models for
                       pressure drop and conservation equations.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.PartialResistance<br/>
                       Buildings.Fluid.FixedResistances.FixedResistanceDpM<br/>
                       Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve<br/>
                       Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential
    </td>
    <td valign=\"top\">Revised base classes and models to simplify object inheritance tree.
                       Set <code>m_flow_small</code> to <code>final</code> in Buildings.Fluid.BaseClasses.PartialResistance,
                       and removed its assignment in the other classes.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.FixedResistanceDpM<br/>
                       Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM
    </td>
    <td valign=\"top\">Improved documentation.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.Functions.glassProperty
    </td>
    <td valign=\"top\">Added the function <code>glassPropertyUncoated</code> that calculates the property for uncoated glass.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.MixedAir
    </td>
    <td valign=\"top\">Changed model to use new implementation of
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity
                       in its base classes.
                       This change leads to the use of the same equations for the radiative
                       heat transfer between window and ambient as is used for 
                       the opaque constructions.
    </td>
</tr>
</table>
</p>
<!-- Non-backward compatible changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br>
                       Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br>
                       Buildings.Fluid.Actuators.Valves.TwoWayLinear<br>
                       Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening
    </td>
    <td valign=\"top\">Changed models to allow modeling of a fixed resistance that is 
                       within the controlled flow leg. This allows in some cases
                       the avoidance of a nonlinear equation if a flow resistance is
                       in series to the valve.
                       This change required changing the parameter for the valve resistance
                       <code>dp_nominal</code> to <code>dpValve_nominal</code>, 
                       and introducing the parameter
                       <code>dpFixed_nominal</code>, with <code>dpFixed_nominal=0</code>
                       as its default value.
                       Previous models that instantiate these components need to change the
                       assignment of <code>dp_nominal</code> to an assignment of
                       <code>dpValve_nominal</code>.
                       See also <a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
                       Buildings.Fluid.Actuators.UsersGuide</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Radiosity.OutdoorRadiosity<br>
                       Buildings.HeatTransfer.Windows.ExteriorHeatTransfer
    </td>
    <td valign=\"top\">Changed model to use new implementation of
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity.
                       This change leads to the use of the same equations for the radiative
                       heat transfer between window and ambient as is used for 
                       the opaque constructions.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">Changed model to fix a bug that caused the output of the block 
                       to be incorrect when the simulation started
                       at a time different from zero.
                       When fixing this bug, the parameter <code>startTime</code> was removed,
                       and the parameter <code>endTime</code> was renamed to <code>period</code>.
                       The period always starts at <i>t=0</i> seconds.
    </td>
</tr>
</table>
</p>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.OccupancySchedule
    </td>
    <td valign=\"top\">The output of the block was incorrect when the simulation started
                       at a time different from zero.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow<br>
                       Buildings.Fluid.HeatExchangers.WetCoilCounterFlow
    </td>
    <td valign=\"top\">Corrected error in assignment of <code>dp2_nominal</code>.
                       The previous assignment caused a pressure drop in all except one element,
                       instead of the opposite. This caused too high a flow resistance
                       of the heat exchanger.
    </td>
</tr>
</table>
</p>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody
    </td>
    <td valign=\"top\">Fixed error in BlackBody model that was causing a translation error when <code>calTSky</code> was set to <code>Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger
    </td>
    <td valign=\"top\">Fixed wrong class reference in information section.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.BCVTB.Examples.MoistAir
    </td>
    <td valign=\"top\">Updated fan parameters, which were still for 
                       version 0.12 of the Buildings library and hence caused 
                       a translation error with version 1.0 or higher.
    </td>
</tr>
</table>
</p>
<!-- Trac tickets -->
<p>
The following
<a href=\"https://corbu.lbl.gov/trac/bie\">trac tickets</a>
have been fixed:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Exterior longwave radiation exchange in window model</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/51\">#51</a>
    </td>
    <td valign=\"top\">Changed model to use new implementation of
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity.
                       This change leads to the use of the same equations for the radiative
                       heat transfer between window and ambient as is used for 
                       the opaque constructions.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/53\">#53</a>
    </td>
    <td valign=\"top\">Fixed bug in Buildings.Controls.SetPoints.OccupancySchedule that 
                       led to wrong results when the simulation started at a time different from zero.
    </td>
</tr>
</table>
<p>
Note:
</p>
<ul>
<li> 
The use of filters for actuator and flow machine input
signals changes the dynamic response of feedback control loops.
Therefore, control gains may need to be retuned.
See <a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>
and
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
Buildings.Fluid.Movers.UsersGuide</a> for recommended control
gains and further details.
</li>
</ul>
</p>
</html>"));
  end Version_1_1_build1;

  class Version_1_0_build2 "Version 1.0 build 2"
    extends Modelica.Icons.ReleaseNotes;
     annotation (Documentation(info="<html>
<p>
Version 1.0 build 2 has been released to correct model errors that
were present in version 1.0 build 1. Both versions are compatible.
In addition, version 1.0 build 2 contains improved documentation
of various example models.
</p>
<!-- New libraries -->
<!-- New components for existing libraries -->
<!-- Backward compatible changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.Continuous<br/>
                       Buildings.Controls.Discrete<br/>
                       Buildings.Controls.SetPoints
    </td>
    <td valign=\"top\">Improved documentation of models and of examples.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.DoorDiscretizedOpen<br/>
                     Buildings.Airflow.Multizone.DoorDiscretizedOperable
    </td>
    <td valign=\"top\">Changed the computation of the discharge coefficient to use the 
       nominal density instead of the actual density. 
       Computing <code>sqrt(2/rho)</code> sometimes causes warnings from the solver,
       as it seems to try negative values for the density during iterative solutions.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.Examples
    </td>
    <td valign=\"top\">Improved documentation of examples.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Examples.DualFanDualDuct</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.DualFanDualDuct.Controls.RoomMixingBox
    </td>
    <td valign=\"top\">Improved control of minimum air flow rate to avoid overheating.
    </td>
</tr>
</table>
</p>
<!-- Non-backward compatbile changes to existing components -->
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Convection.Exterior
    </td>
    <td valign=\"top\">Fixed error in assignment of wind-based convection coefficient. 
                     The old implementation did not take into account the surface roughness.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.BaseClasses.SolarRadiationExchange
    </td>
    <td valign=\"top\">In the previous version, the radiative properties 
     of the long-wave spectrum instead of the solar spectrum have been used 
     to compute the distribution of the solar radiation among the surfaces 
     inside the room.
    </td>
<tr><td valign=\"top\">Buildings.Rooms.BaseClasses.MixedAir
    </td>
    <td valign=\"top\">Added missing connect statement between window frame
     surface and window frame convection model. Prior to this bug fix,
     no convective heat transfer was computed between window frame and
     room air.
    </td>
<tr><td valign=\"top\">Buildings.Rooms.BaseClasses.HeatGain
    </td>
    <td valign=\"top\">Fixed bug that caused convective heat gains 
     to be removed from the room instead of added to the room.
    </td>
</tr>
</table>
</p>
<!-- Uncritical errors -->
<!-- Trac tickets -->
<p>
The following
<a href=\"https://corbu.lbl.gov/trac/bie\">trac tickets</a>
have been fixed:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers.Boreholes</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/45\">#45</a>
    </td>
    <td valign=\"top\">Dymola 2012 FD01 hangs when simulating a borehole heat exchanger.
    This was caused by a wrong release of memory in <code>freeArray.c</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/46\">#46</a>
    </td>
    <td valign=\"top\">The convective internal heat gain has the wrong sign.
    </td>
</tr>

</table>
</p>
</html>"));
  end Version_1_0_build2;

  class Version_1_0_build1 "Version 1.0 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (Documentation(info="<html>
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
<a href=\"modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos\">
Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos</a> can help
in converting old models to this version of the library.
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes</td>
    <td valign=\"top\">
    This is a library with a model for a borehole heat exchanger.
    </td></tr>
</table>
</p>
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
<tr><td colspan=\"2\"><b>Buildings.Rooms.Examples</b></td></tr>
<tr><td valign=\"top\">Buildings.Rooms.Examples.BESTEST
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
</p>
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">

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
                      Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</br>
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
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow<br>
                     Buildings.Fluid.HeatExchangers.WetCoilCounterFlow<br>
                     Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br>
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
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc<br>
                     Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</td>
    <td valign=\"top\">
       These models are now based on a new base class <code>Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower</code>.
       This allows using the models as replaceable models without warning when checking the model.
    </td>
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
                     <a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
                     Buildings.Fluid.Sensors.UsersGuide</a> for details.</td>
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
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Airflow.Multizone</b></td></tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.MediumColumnDynamic</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow.
This required the introduction of a new parameter <code>m_flow_nominal</code>
that is used for the regularization near zero mass flow rate.</td></tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Examples.Stratified<br>
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
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.MixingVolume<br>
                     Buildings.Fluid.MixingVolumes.MixingVolumeDryAir<br>
                     Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow if the components have exactly two fluid ports connected.
This required the introduction of a new parameter <code>m_flow_nominal</code>
that is used for the regularization near zero mass flow rate.</td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid.Movers</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowMachine_y<br>
                     Buildings.Fluid.Movers.FlowMachine_Nrpm<br>
                     Buildings.Fluid.Movers.FlowMachine_dp<br>
                     Buildings.Fluid.Movers.FlowMachine_m_flow</td>
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
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.FourPortHeatMassExchanger<br>
                     Buildings.Fluid.Interfaces.PartialDynamicStaticFourPortHeatMassExchanger<br>
                     Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br>
                     Buildings.Fluid.Interfaces.PartialDynamicStaticTwoPortHeatMassExchanger<br>
                     Buildings.Fluid.Interfaces.ConservationEquation</td>
    <td valign=\"top\">The implementation has been changed to better handle mass flow rates
near zero flow if the components have exactly two fluid ports connected.</td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid.Sensors</b></td></tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TemperatureTwoPortDynamic</td>
    <td valign=\"top\">This model has been deleted since the sensor                  
                     <a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
                     Buildings.Fluid.Sensors.TemperatureTwoPort</a> has been revised
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
<tr><td valign=\"top\">Buildings.Utilities.Reports.Printer<br>
                     Buildings.Utilities.Reports.printRealArray</td>
    <td valign=\"top\">Changed parameter <code>precision</code> to <code>significantDigits</code> and 
                     <code>minimumWidth</code> to <code>minimumLength</code> 
                     to use the same terminology as the Modelica Standard Library.</td>
</tr>

</table>
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">


<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody</td>
    <td valign=\"top\">Fixed error in <code>if-then</code> statement that led to
                       a selection of the wrong branch to compute the sky temperature.</td></tr>
<tr><td colspan=\"2\"><b>Buildings.Media</b></td></tr>
<tr><td valign=\"top\">Buildings.Media.PartialSimpleMedium</br>
                       Buildings.Media.GasesConstantDensity.SimpleAir</td>
    <td valign=\"top\">Fixed error in assignment of <code>singleState</code> parameter. 
                       This change can lead to different initial conditions if the density of 
                       water is modeled as a function of pressure, or if the
                       medium model Buildings.Media.GasesConstantDensity.SimpleAir is used.</td></tr>

<tr><td valign=\"top\">Buildings.Media.GasesConstantDensity</br>
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

<tr><td colspan=\"2\"><b>Buildings.Rooms</b></td></tr>
<tr><td valign=\"top\">Buildings.Rooms.MixedAir</br>
                     Buildings.Rooms.BaseClasses.ExteriorBoundaryConditions</td>
    <td valign=\"top\">Fixed bug (<a href=\"https://corbu.lbl.gov/trac/bie/ticket/35\">ticket 35</a>) 
                     that leads to the wrong solar heat gain for
                     roofs and for floors. Prior to this bug fix, the outside facing surface
                     of a ceiling received solar irradiation as if it were a floor 
                     and vice versa.</td></tr>
</td></tr>
<tr><td valign=\"top\">Buildings.Rooms.MixedAir</br>
                     Buildings.Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow</td>
    <td valign=\"top\">Fixed bug (<a href=\"https://corbu.lbl.gov/trac/bie/ticket/36\">ticket 36</a>) 
                     that leads to too high a surface temperature of the window frame when
                     it receives solar radiation. The previous version did not compute 
                     the infrared radiation exchange between the
                     window frame and the sky.</td></tr>
</td></tr>

</table>
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, but, e.g.,
units are wrong or errors in documentation):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.ConvertRadiation</td>
    <td>Corrected wrong unit label.
    </td>
</tr>
</table>
<p>
The following
<a href=\"https://corbu.lbl.gov/trac/bie\">trac tickets</a>
have been fixed:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/8\">#8</a></td>
    <td valign=\"top\">
         Add switches for new data.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/19\">#19</a></td>
    <td valign=\"top\">
         Shift the time for the radiation data 30 min forth and output the local civil time in the data reader. 
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/41\">#41</a></td>
    <td valign=\"top\">
       Using when-then sentences to reduce CPU time.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/43\">#43</a></td>
    <td valign=\"top\">
         Add a ConvertRadiation to convert the unit of radiation from TMY3.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/28\">#28</a></td>
    <td valign=\"top\">
         Move scripts to Buildings\\Resources\\Scripts\\Dymola.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/18\">#18</a></td>
    <td valign=\"top\">
         Add a smooth interpolation function to avoid the event.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Media</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/30\">#30</a></td>
    <td valign=\"top\">
         Removed non-required structurally incomplete annotation.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Rooms</b></td></tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/35\">#35</a></td>
    <td valign=\"top\">
         Wrong surface tilt for radiation at exterior surfaces of floors and ceilings.
    </td>
</tr>
<tr><td valign=\"top\">
    <a href=\"https://corbu.lbl.gov/trac/bie/ticket/36\">#36</a></td>
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
<a href=\"modelica://Modelica.UsersGuide.ReleaseNotes.VersionManagement\">
Modelica.UsersGuide.ReleaseNotes.VersionManagement</a> for details. 
</li>
<li>
To allow adding scripts for multiple simulation environments,
all scripts have been moved to the directory <code>Buildings/Resources/Scripts/Dymola</code> and the annotation that
generates the entry in the <code>Command</code> pull down menu has been changed to 
<code>__Dymola_Commands(file=...</code>
</li>
</ul>
</p>
</html>"));
  end Version_1_0_build1;

  class Version_0_12_0 "Version 0.12.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<p>
<b>Note:</b> The packages whose name ends with <code>Beta</code>
are still being validated.
</p>
The following <b style=\"color:red\">critical error</b> has been fixed (i.e. error
that can lead to wrong simulation results):
</p>
<p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>Buildings.Rooms</b></td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Rooms.BaseClasses.InfraredRadiationExchange\">
  Buildings.Rooms.BaseClasses.InfraredRadiationExchange</a></td>
      <td valign=\"top\">The model <code>Buildings.Rooms.BaseClasses.InfraredRadiationExchange</code>
      had an error in the view factor approximation. 
      The error caused too much radiosity to flow from large to small surfaces because the law of reciprocity 
      for view factors was not satisfied. This led to low surface temperatures if a surface had a large area 
      compared to other surfaces.
      The bug has been fixed by rewriting the view factor calculation.
      </td>
  </tr>
</table>
</p>
<p>
The following improvements and additions have been made:
</p>
<ul>
<li>
Updated library to Modelica 3.2.
</li>
<li>
Added <code>homotopy</code> operator.
</li>
<li>
Restructured package <a href=\"modelica://Buildings.HeatTransfer\">
Buildings.HeatTransfer</a>.
</li>
<li>
Rewrote the models in <a href=\"modelica://Buildings.Fluid.Actuators\">
Buildings.Fluid.Actuators</a> to avoid having the flow coefficient
<code>k</code> as an algebraic variable.
This increases robustness.
</li>
<li>
Rewrote energy, species and trace substance balance in 
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>
to better handle zero mass flow rate.
</li>
<li>
Implemented functions <code>enthalpyOfCondensingGas</code> and <code>saturationPressure</code>
in single substance media 
to allow use of the room model with media that do not contain water vapor.
</li>
<li>
Revised <a href=\"modelica://Buildings.Fluid.Sources.Outside\">
Buildings.Fluid.Sources.Outside</a>
to allow use of the room model with media that do not contain water vapor.
</li>
</ul>
</p>
</html>
"));
  end Version_0_12_0;

  class Version_0_11_0 "Version 0.11.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<p>
<b>Note:</b> The packages whose name ends with <code>Beta</code>
are still being validated.
</p>
<ul>
<li>
Added the package 
<a href=\"modelica://Buildings.Rooms\">
Buildings.Rooms</a> to compute heat transfer in rooms
and through the building envelope. 
Multiple instances of these models can be connected to create
a multi-zone building model.
</li>
<li>
Added the package
<a href=\"modelica://Buildings.HeatTransfer.Windows\">
Buildings.HeatTransfer.Windows</a>
to compute heat transfer (solar radiation, infrared radiation,
convection and conduction) through glazing systems.
</li>
<li>
In package
<a href=\"modelica://Buildings.Fluid.Chillers\">
Buildings.Fluid.Chillers</a>, added the chiller models
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>
and
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Cphillers.ElectricEIR</a>, and added
the package 
<a href=\"modelica://Buildings.Fluid.Chillers.Data\">
Buildings.Fluid.Chillers.Data</a>
that contains data sets of chiller performance data.
</li>
<li>
Added package 
<a href=\"modelica://Buildings.BoundaryConditions\">
Buildings.BoundaryConditions</a>
with models to compute boundary conditions, such as
solar irradiation and sky temperature.
</li>
<li>
Added package 
<a href=\"modelica://Buildings.Utilities.IO.WeatherData\">
Buildings.Utilities.IO.WeatherData</a>
with models to read weather data in the TMY3 format.
</li>
<li>
Revised the package 
<a href=\"modelica://Buildings.Fluid.Sensors\">Buildings.Fluid.Sensors</a>.
</li>
<li>
Revised the package 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers\">
Buildings.Fluid.HeatExchangers.CoolingTowers</a>.
</li>
<li>
In 
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</a>
and
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger</a>,
fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream. 
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at 
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
<li>
In 
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a> and in
<a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleMedium\">
Buildings.Media.Interfaces.PartialSimpleMedium</a>, set
nominal attribute for medium to provide consistent normalization.
Without this change, Dymola 7.4 uses different values for the nominal attribute
based on the value of <code>Advanced.OutputModelicaCodeWithJacobians=true/false;</code>
in the model 
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
</li>
<li>
Fixed bug in energy balance of 
<a href=\"modelica://Buildings.Fluid.Chillers.Carnot\">
Buildings.Fluid.Chillers.Carnot</a>.
</li>
<li>
Fixed bug in efficiency curves in package 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
</li>
</ul>
</p>
</html>
"));
  end Version_0_11_0;

  class Version_0_10_0 "Version 0.10.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<p>
<ul>
<li>
Added package 
<a href=\"modelica://Buildings.Airflow.Multizone\">
Buildings.Airflow.Multizone</a>
with models for multizone airflow and contaminant transport.
</li>
<li>
Added the model
<a href=\"modelica://Buildings.Utilities.Comfort.Fanger\">
Buildings.Utilities.Comfort.Fanger</a>
for thermal comfort calculations.
</li>
<li>
Rewrote 
<a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier\">
Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier</a>, which is used in 
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>,
to avoid state events when the flow reverses.
This leads to faster and more robust simulation.
</li>
<li>
In models of package 
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>,
added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
Fixed bug in fan and pump models that led to too small an enthalpy
increase across the flow device.
</li>
<li>
In model <a href=\"modelica://Buildings.Fluid.Movers.FlowMachine_dp\">
Buildings.Fluid.Movers.FlowMachine_dp</a>, 
changed <code>assert(dp_in >= 0, ...)</code> to <code>assert(dp_in >= -0.1, ...)</code>.
The former implementation triggered the assert if <code>dp_in</code> was solved for
in a nonlinear equation since the solution can be slightly negative while still being
within the solver tolerance.
</li>
<li>
Added model
<a href=\"modelica://Buildings.Controls.SetPoints.Table\">
Buildings.Controls.SetPoints.Table</a>
that allows the specification of a floating setpoint using a table of values.
</li>
<li>
Revised model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2\">
Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</a>.
The new version has exactly the same nominal power during the simulation as specified 
by the parameters. This also required a change in the parameters.
</li>
</ul>
</p>
</html>
"));
  end Version_0_10_0;

  class Version_0_9_1 "Version 0.9.1"
    extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<p>
The following <b style=\"color:red\">critical error</b> has been fixed (i.e. error
that can lead to wrong simulation results):
</p>
<p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
  <tr><td colspan=\"2\"><b>Buildings.Fluid.Storage.</b></td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
  Buildings.Fluid.Storage.StratifiedEnhanced</a></td>
      <td valign=\"top\">The model <code>Buildings.Fluid.Storage.BaseClasses.Stratifier</code>
      had a sign error that lead to a wrong energy balance.
      The model that was affected by this error is
      <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
      Buildings.Fluid.Storage.StratifiedEnhanced</a>.
      The model 
      <a href=\"modelica://Buildings.Fluid.Storage.Stratified\">
      Buildings.Fluid.Storage.Stratified</a> was not affected.<br>
      The bug has been fixed by using the newly introduced model
      <a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier\">
        Buildings.Fluid.Storage.BaseClasses.ThirdOrderStratifier</a>. This model
      uses a third-order upwind scheme to reduce the numerical dissipation instead of the
      correction term that was used in <code>Buildings.Fluid.Storage.BaseClasses.Stratifier</code>.
      The model <code>Buildings.Fluid.Storage.BaseClasses.Stratifier</code> has been removed since it
      also led to significant overshoot in temperatures when the stratification was pronounced.
      </td>
  </tr>
</table>
</p>
</html>
"));
  end Version_0_9_1;

  class Version_0_9_0 "Version 0.9.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (Documentation(info="<html>
<p>
<ul>
<li>
Added the following heat exchanger models
<ul>
<li> 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</a>
for a sensible heat exchanger that uses the <code>epsilon-NTU</code>
relations to compute the heat transfer.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>
to model a coil without and with water vapor condensation. These models
approximate the coil as a counterflow heat exchanger.
</li>
</ul>
<li>
Revised air damper 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>.
The new implementation avoids warnings and leads to faster convergence
since the solver does not attempt anymore to solve for a variable that
needs to be strictly positive.
</li>
<li>
Revised package
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a>
to allow zero flow for some pump or fan models.
If the input to the model is the control signal <code>y</code>, then
the flow is equal to zero if <code>y=0</code>. This change required rewriting
the package to avoid division by the rotational speed.
</li>
<li>
Revised package
<a href=\"modelica://Buildings.HeatTransfer\">
Buildings.HeatTransfer</a>
to include a model for a multi-layer construction, and to
allow individual material layers to be computed steady-state or
transient.
</li>
<li>
In package  <a href=\"modelica://Buildings.Fluid\">
Buildings.Fluid</a>, changed models so that
if the parameter <code>dp_nominal</code> is set to zero,
then the pressure drop equation is removed. This allows, for example, 
to model a heating and a cooling coil in series, and lump there pressure drops
into a single element, thereby reducing the dimension of the nonlinear system
of equations.
</li>
<li>
Added model <a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
Buildings.Controls.Continuous.LimPID</a>, which is identical to 
<a href=\"Modelica:Modelica.Blocks.Continuous.LimPID\">
Modelica.Blocks.Continuous.LimPID</a>, except that it 
allows reverse control action. This simplifies use of the controller
for cooling applications.
</li>
<li>
Added model <a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBox\">
Buildings.Fluid.Actuators.Dampers.MixingBox</a> for an outside air
mixing box with air dampers.
</li>
<li>
Changed implementation of flow resistance in
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow\">
Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow</a>. Instead of using a
fixed resistance and a damper model in series, only one model is used
that internally adds these two resistances. This leads to smaller systems
of nonlinear equations.
</li>
<li>
Changed 
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAir.T_phX\">
Buildings.Media.PerfectGases.MoistAir.T_phX</a> (and by inheritance all
other moist air medium models) to first compute <code>T</code> 
in closed form assuming no saturation. Then, a check is done to determine
whether the state is in the fog region. If the state is in the fog region,
then <code>Internal.solve</code> is called. This new implementation
can lead to significantly shorter computing
time in models that frequently call <code>T_phX</code>.
<li>
Added package
<a href=\"modelica://Buildings.Media.GasesConstantDensity\">
Buildings.Media.GasesConstantDensity</a> which contains medium models
for dry air and moist air.
The use of a constant density avoids having pressure as a state variable in mixing volumes. Hence, fast transients
introduced by a change in pressure are avoided. 
The drawback is that the dimensionality of the coupled
nonlinear equation system is typically larger for flow
networks.
</li>
<li>
In 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</a>,
added default value for parameter <code>A</code> to avoid compilation error
if the parameter is disabled but not specified.
</li>
<li>
Simplified the mixing volumes in 
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a> by removing the port velocity, 
pressure drop and height.
</li>
</ul>
</p>
</html>
"));
  end Version_0_9_0;

  class Version_0_8_0 "Version 0.8.0"
    extends Modelica.Icons.ReleaseNotes;
              annotation (Documentation(info="<html>
<p>
<ul>
<li>
In 
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>,
added to <code>Medium.BaseProperties</code> the initialization 
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li>
Renamed <code>Buildings.Media.PerfectGases.MoistAirNonSaturated</code>
to 
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAirUnsaturated\">
Buildings.Media.PerfectGases.MoistAirUnsaturated</a>
and <code>Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid</code>
to 
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated\">
Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated</a>,
and added <code>assert</code> statements if saturation occurs.
</li>
<li>
Added regularizaation near zero flow to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ConstantEffectiveness\">
Buildings.Fluid.HeatExchangers.ConstantEffectiveness</a>
and
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>.
</li>
<li>
Fixed bug regarding temperature offset in 
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAirUnsaturated.T_phX\">
Buildings.Media.PerfectGases.MoistAirUnsaturated.T_phX</a>.
</li>
<li>
Added implementation of function
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas\">
Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas</a> and its derivative.
</li>
<li>
In <a href=\"modelica://Buildings.Media.PerfectGases.MoistAir\">
Buildings.Media.PerfectGases.MoistAir</a>, fixed
bug in implementation of <a href=\"modelica://Buildings.Media.PerfectGases.MoistAir.T_phX\">
Buildings.Media.PerfectGases.MoistAir.T_phX</a>. In the 
previous version, it computed the inverse of its parent class,
which gave slightly different results.
</li>
<li>
In <a href=\"modelica://Buildings.Utilities.IO.BCVTB.BCVTB\">
Buildings.Utilities.IO.BCVTB.BCVTB</a>, added parameter to specify
the value to be sent to the BCVTB at the first data exchange,
and added parameter that deactivates the interface. Deactivating 
the interface is sometimes useful during debugging. 
</li>
<li>
In <a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAir\">
Buildings.Media.GasesPTDecoupled.MoistAir</a> and in
<a href=\"modelica://Buildings.Media.PerfectGases.MoistAir\">
Buildings.Media.PerfectGases.MoistAir</a>, added function
<code>enthalpyOfNonCondensingGas</code> and its derivative.
<li>
In <a href=\"modelica://Buildings.Media\">
Buildings.Media</a>, 
fixed bug in implementations of derivatives.
</li>
<li>
Added model 
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
</li>
<li>
Added Wrapper function <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.solve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.solve</a> for 
<a href=\"Modelica:Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a>. This is currently needed since 
<a href=\"Modelica:Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a> does not specify a 
derivative.
</li>
<li>
Fixed bug in 
<a href=\"Buildings.Fluid.Storage.Stratified\">
Buildings.Fluid.Storage.Stratified</a>. 
In the previous version, 
for computing the heat conduction between the top (or bottom) segment and
the outside, 
the whole thickness of the water volume was used
instead of only half the thickness.
<li>
In <a href=\"Buildings.Media.ConstantPropertyLiquidWater\">
Buildings.Media.ConstantPropertyLiquidWater</a>, added the option to specify a compressibility.
This can help reducing the size of the coupled nonlinear system of equations, at
the expense of introducing stiffness. This change required to change the inheritance 
tree of the medium. Its base class is now
<a href=\"Buildings.Media.Interfaces.PartialSimpleMedium\">
Buildings.Media.Interfaces.PartialSimpleMedium</a>,
which contains the equation for the compressibility. The default setting will model 
the flow as incompressible.
</li>
<li>
In <a href=\"modelica://Buildings.Controls.Continuous.Examples.PIDHysteresis\">
Buildings.Controls.Continuous.Examples.PIDHysteresis</a>
and <a href=\"modelica://Buildings.Controls.Continuous.Examples.PIDHysteresisTimer\">
Buildings.Controls.Continuous.Examples.PIDHysteresisTimer</a>,
fixed error in default parameter <code>eOn</code>.
Fixed error by introducing parameter <code>Td</code>, 
which used to be hard-wired in the PID controller.
</li>
<li>
Added more models for fans and pumps to the package 
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a>.
The models are similar to the ones in
<a href=\"modelica://Modelica.Fluid.Machines\">
Modelica.Fluid.Machines</a> but have been adapted for 
air-based systems, and to include more characteristic curves
in 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics\">
Buildings.Fluid.Movers.BaseClasses.Characteristics</a>.
The new models are better suited than the existing fan model
<a href=\"modelica://Buildings.Fluid.Movers.FlowMachinePolynomial\">
Buildings.Fluid.Movers.FlowMachinePolynomial</a> for zero flow rate.
</li>
<li>
Added an optional mixing volume to <a href=\"modelica://Buildings.Fluid.BaseClasses.PartialThreeWayResistance\">
Buildings.Fluid.BaseClasses.PartialThreeWayResistance</a>
and hence to the flow splitter and to the three-way valves. This often breaks algebraic loops and provides a state for the temperature if the mass flow rate goes to zero.
</li>
</ul>
</p>
</html>
"));
  end Version_0_8_0;

  class Version_0_7_0 "Version 0.7.0"
    extends Modelica.Icons.ReleaseNotes;
              annotation (Documentation(info="<html>
<p>
<ul>
<li>
Updated library from Modelica_Fluid to Modelica.Fluid 1.0
<li>
Merged sensor and source models from Modelica.Fluid to Buildings.Fluid.
</li>
<li> Added sensor for sensible and latent enthalpy flow rate,
<a href=\"modelica://Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate\">
Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate</a> and
<a href=\"modelica://Buildings.Fluid.Sensors.LatentEnthalpyFlowRate\">
Buildings.Fluid.Sensors.LatentEnthalpyFlowRate</a>.
These sensors are needed, for example, to interface air-conditioning
systems that are modeled with Modelica with the Building Controls
Virtual Test Bed.
</li>
</ul>
</p>
</html>
"));
  end Version_0_7_0;

  class Version_0_6_0 "Version 0.6.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<p>
<ul>
<li>
Added the package
<a href=\"modelica://Buildings.Utilities.IO.BCVTB\">
Buildings.Utilities.IO.BCVTB</a>
which contains an interface to the 
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">Building Controls Virtual Test Bed.</a>
<li> 
Updated license to Modelica License 2.
<li>
Replaced 
<a href=\"modelica://Buildings.Utilities.Psychrometrics.HumidityRatioPressure.mo\">
Buildings.Utilities.Psychrometrics.HumidityRatioPressure.mo</a>
by
<a href=\"modelica://Buildings.Utilities.Psychrometrics.HumidityRatio_pWat.mo\">
Buildings.Utilities.Psychrometrics.HumidityRatio_pWat.mo</a>
and
<a href=\"modelica://Buildings.Utilities.Psychrometrics.VaporPressure_X.mo\">
Buildings.Utilities.Psychrometrics.VaporPressure_X.mo</a>
because the old model used <code>RealInput</code> ports, which are obsolete
in Modelica 3.0.
</li>
<li>
Changed the base class 
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>
to enable computation of pressure drop of mechanical equipment.
</li>
<li>
Introduced package
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels\">
Buildings.Fluid.BaseClasses.FlowModels</a> to model pressure drop,
and rewrote 
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\">
Buildings.Fluid.BaseClasses.PartialResistance</a>.
</li>
<li>
Redesigned package
<a href=\"modelica://Buildings.Utilities.Math\">
Buildings.Utilities.Math</a> to allow having blocks and functions
with the same name. Functions are now in 
<a href=\"modelica://Buildings.Utilities.Math.Functions\">
Buildings.Utilities.Math.Functions</a>.
</li>
<li>
Fixed sign error in
<a href=\"modelica://Buildings.Fluid.Storage.BaseClasses.Stratifier\">
Buildings.Fluid.Storage.BaseClasses.Stratifier</a>
which caused a wrong energy balance in
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</li>
<li>
Renamed 
<code>Buildings.Fluid.HeatExchangers.HeaterCoolerIdeal</code> to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</a>
to have the same nomenclatures as is used for
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>
</li>
<li>
In 
<a href=\"modelica://Buildings.Fluid/Actuators/BaseClasses/PartialDamperExponential\">
Buildings.Fluid/Actuators/BaseClasses/PartialDamperExponential</a>,
added option to compute linearization near zero based on 
the fraction of nominal flow instead of the Reynolds number.
This was set as the default, as it leads most reliably to a model 
parametrization that leads to a derivative <code>d m_flow/d p</code> 
near the origin that is not too steep for a Newton-based solver.
</li>
<li>
In damper and VAV box models, added optional parameters
to allow specifying the nominal face velocity instead of the area.
</li>
<li>
Set nominal attribute for pressure drop <code>dp</code> in 
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\"</a>
Buildings.Fluid.BaseClasses.PartialResistance</a> and in its
child classes.
</li>
<li>
Added models for chiller
(<a href=\"modelica://Buildings.Fluid.Chillers.Carnot\">
Buildings.Fluid.Chillers.Carnot</a>),
for occupancy
(<a href=\"modelica://Buildings.Controls.SetPoints.OccupancySchedule\">
Buildings.Controls.SetPoints.OccupancySchedule</a>) and for
blocks that take a vector as an argument
(<a href=\"modelica://Buildings.Utilities.Math.Min\">
Buildings.Utilities.Math.Min</a>,
<a href=\"modelica://Buildings.Utilities.Math.Max\">
Buildings.Utilities.Math.Max</a>, and
<a href=\"modelica://Buildings.Utilities.Math.Average\">
Buildings.Utilities.Math.Average</a>).
</li>
<li>
Changed various variable names to be consistent with naming
convention used in Modelica.Fluid 1.0.
</li>
</ul>
</p>
</html>
"));
  end Version_0_6_0;

  class Version_0_5_0 "Version 0.5.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<p>
<ul>
<li>
Updated library to Modelica.Fluid 1.0.
</li>
<li>
Moved most examples from package <a href=\"modelica://Buildings.Fluid.Examples\">
Buildings.Fluid.Examples</a> to the example directory in the package of the
individual model.
</li>
<li>
Renamed package <a href=\"modelica://Buildings.Utilites.Controls\">
Buildings.Utilites.Controls</a> to 
<a href=\"modelica://Buildings.Utilites.Diagnostics\">
Buildings.Utilites.Diagnostics</a>.
</li>
<li>
Introduced packages 
<a href=\"modelica://Buildings.Controls\">Buildings.Controls</a>,
<a href=\"modelica://Buildings.HeatTransfer\">Buildings.HeatTransfer</a>
(which contains models for heat transfer that generally does not involve 
modeling of the fluid flow),
<a href=\"modelica://Buildings.Fluid.Boilers\">Buildings.Fluid.Boilers</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators\">
Buildings.Fluid.HeatExchangers.Radiators</a>.
</li>
<li>
Changed valve models in <a href=\"modelica://Buildings.Fluid.Actuators.Valves\">
Buildings.Fluid.Actuators.Valves</a> so that <code>Kv</code> or <code>Cv</code> can
be used as the flow coefficient (in [m3/h] or [USG/min]).
</li>
</ul>
</p>
</html>
"));
  end Version_0_5_0;

  class Version_0_4_0 "Version 0.4.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<p>
<ul>
<li>
Added package <a href=\"modelica://Buildings.Fluid.Storage\">
Buildings.Fluid.Storage</a>
with models for thermal energy storage.
<li>
Added a steady-state model for a heat and moisture exchanger with
constant effectiveness. 
See <a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>
<li>
Added package <a href=\"modelica://Buildings.Utilities.Reports\">Buildings.Utilities.Reports</a>.
The package contains models that facilitate reporting.
</li>
</ul>
</p>
</html>
"));
  end Version_0_4_0;

  class Version_0_3_0 "Version 0.3.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<p>
<ul>
<li>
Added package <a href=\"modelica://Buildings.Fluid.Sources\">Buildings.Fluid.Sources</a>.
The package contains models for modeling species that
do not affect the medium balance of volumes. This can be used to track
for example carbon dioxide or other species that have a small concentration.
</li>
<li>
The package <a href=\"modelica://Buildings.Fluid.Actuators.Motors\">Buildings.Fluid.Actuators.Motors</a> has been added.
The package contains a motor model for valves and dampers.
</li>
<li>
The package <a href=\"modelica://Buildings.Media\">Buildings.Media</a> has been reorganized and
the new medium model 
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAir\">
Buildings.Media.GasesPTDecoupled.MoistAir</a>
has been added.
<br>
In addition, this package now contains a bug fix that is needed for Modelica 2.2.1 and 2.2.2.
The bugs are fixed by using a new
base class
<a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleIdealGasMedium\">
Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</a>
 (that fixes the bugs) instead of
<a href=\"Modelica:Modelica.Media.Interfaces.PartialSimpleIdealGasMedium\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</a>.
In the original implementation, initial states of fluid volumes can be far away from
the steady-state value because of an inconsistent implementation of the the enthalpy
and internal energy.
When the <code>Buildings</code> library is upgraded to
to Modelica 3.0.0, it should be safe to remove this bug fix.
</li>
<li>
The package <a href=\"modelica://Buildings.Fluid.HeatExchangers\">Buildings.Fluid.HeatExchangers</a> 
has been revised and several models have been renamed.
The heat exchanger models have been revised to allow computing the fluid volumes either
dynamically, or in steady-state.
</li>
<li>
The damper with exponential opening characteristic has been revised to allow control signals
over the whole range between <code>0</code> and <code>1</code>. This was in earlier versions restricted.
In the same model, a bug was fixed that caused the flow to be largest for <code>y=0</code>, i.e., when the damper is closed.
</li>
<li>
Additional models for psychrometric equations have been added. The new models contain equations
that convert dew point temperature and water vapor pressure, as well
as water vapor concentration and water vapor pressure.
</li>
<li>
A new mixing volume has been added that allows latent heat exchange with the volume.
This model can be used to model a volume of moist air with water vapor condensation 
inside the volume. The condensate is removed from the volume in its liquid phase.
</li>
</ul>
</p>
</html>
"));
  end Version_0_3_0;

  class Version_0_2_0 "Version 0.2.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<p>
New in this version are models for two and three way valves.
In addition, the <code>Fluids</code> package has been slightly revised.
The package <code>Fluid.BaseClasses</code> has been added because in
the previous version, partial models for fixed resistances 
where part of the <code>Actuator</code> package.
</p>
</html>
"));
  end Version_0_2_0;

  class Version_0_1_0 "Version 0.1.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (Documentation(info="<html>
<p>
First release of the library.
</p>
<p>This version contains basic models for modeling building HVAC systems.
It also contains new medium models in the package
<a href=\"modelica://Buildings.Media\">Buildings.Media</a>. These medium models
have simpler property functions than the ones from
<a href=\"modelica://Modelica.Media\">Modelica.Media</a>. For example,
there is medium model with constant heat capacity which is often sufficiently 
accurate for building HVAC simulation, in contrast to the more detailed models
from <a href=\"modelica://Modelica.Media\">Modelica.Media</a> that are valid in 
a larger temperature range, at the expense of introducing non-linearities due
to the medium properties.
</html>
"));
  end Version_0_1_0;

    annotation (Documentation(info="<html>
<p>
This section summarizes the changes that have been performed
on the Buildings library
</p>
<p>
<ul>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_2_build1\">
Version 1.2 build1</a>(July 26, 2012)</li>
</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_1_build1\">
Version 1.1 build1</a>(February 29, 2012)</li>
</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_0_build2\">
Version 1.0 build2</a>(December 8, 2011)</li>
</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_0_build1\">
Version 1.0 build1</a>(November 4, 2011)</li>
</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_12_0\">
Version 0.12.0 </a>(May 6, 2011)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_11_0\">
Version 0.11.0 </a>(March 17, 2011)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_10_0\">
Version 0.10.0 </a>(July 30, 2010)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_9_1\">
Version 0.9.1 </a>(June 24, 2010)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_9_0\">
Version 0.9.0 </a>(June 11, 2010)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_8_0\">
Version 0.8.0 </a>(February 6, 2010)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_7_0\">
Version 0.7.0 </a>(September 29, 2009)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_6_0\">
Version 0.6.0 </a>(May 15, 2009)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_5_0\">
Version 0.5.0 </a>(February 19, 2009)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_4_0\">
Version 0.4.0 </a>(October 31, 2008)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_3_0\">
Version 0.3.0 </a>(September 30, 2008)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_2_0\">
Version 0.2.0 </a>(June 17, 2008)</li>
<li> 
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_1_0\">
Version 0.1.0 </a>(May 27, 2008)</li>
</ul>
</p>
<p></p>
</html>
"));
  end ReleaseNotes;

  class Contact "Contact"
    extends Modelica.Icons.Contact;
    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>Contact</font></h4>
<p>
The development of the Buildings library is organized by<br>
<a href=\"http://simulationresearch.lbl.gov/wetter\">Michael Wetter</a><br>
    Lawrence Berkeley National Laboratory (LBNL)<br>
    One Cyclotron Road<br> 
    Bldg. 90-3147<br>
    Berkeley, CA 94720<br>
    USA<br>
    email: <A HREF=\"mailto:MWetter@lbl.gov\">MWetter@lbl.gov</A><br>
</p>
</html>
"));
  end Contact;

  class Acknowledgements "Acknowledgements"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>Acknowledgements</font></h4>
<p>
 The development of this library was supported
 <ul>
 <li>by the Assistant Secretary for
  Energy Efficiency and Renewable Energy, Office of Building
  Technologies of the U.S. Department of Energy, under
  contract No. DE-AC02-05CH11231, and
 </li>
 <li>
  by the California Energy Commission, Public Interest Energy Research Program, Buildings End Use Energy Efficiency Program, award number 500-10-052.
 </li>
 </ul>
</p>
<p>
  The <a href=\"modelica://Buildings.Airflow.Multizone\">package for multizone airflow modeling</a>
  and the <a href=\"modelica://Buildings.Utilities.Comfort.Fanger\">model for thermal comfort</a>
  was contributed by the United Technologies Research Center, which also contributed to the
  validation of the <a href=\"modelica://Buildings.Rooms.MixedAir\">room heat transfer model</a>.
</p>
<p>
We thank Dietmar Winkler from Telemark University College for the various feedback that 
helped improve the organization and structure of the library.
</p>
<p>
The following people have directly contributed to the implementation of the Buildings library
(many others have contributed by other means than model implementation):
<ul>
<li>Rainer Czetina, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Sebastian Giglmayr, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Brandon M. Hencey, Cornell University, USA
</li>
<li>Roman Ilk, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Thierry S. Nouidui, Lawrence Berkeley National Laboratory, USA
</li>
<li>Markus Nurschinger, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Xiufeng Pang, Lawrence Berkeley National Laboratory, USA
</li>
<li>Kaustubh Phalak, Lawrence Berkeley National Laboratory, USA
</li>
<li>Rafael Velazquez, University of Seville, Spain
</li>
<li>Pierre Vigouroux, Institut National des Sciences Appliquees, France
</li>
<li>Sebastian Vock, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Vladimir Vukovic, Austrian Institute of Technology, Austria
</li>
<li>Michael Wetter, Lawrence Berkeley National Laboratory, USA
</li>
<li>Wangda Zuo, Lawrence Berkeley National Laboratory, USA
</li>
</ul>
</p>
</html>
"));
  end Acknowledgements;

  class License "Modelica License 2"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>The Modelica License 2</font></h4>
<p>
<strong>Preamble.</strong> The goal of this license is that Modelica related model libraries, software, images, documents, data files etc. can be used freely in the original or a modified form, in open source and in commercial environments (as long as the license conditions below are fulfilled, in particular sections 2c) and 2d). The Original Work is provided free of charge and the use is completely at your own risk. Developers of free Modelica packages are encouraged to utilize this license for their work. 
<p>
The Modelica License applies to any Original Work that contains the following licensing notice adjacent to the copyright notice(s) for this Original Work: 
<p>
<strong>Note.</strong> This is the standard Modelica License 2, except for the following changes: the parenthetical in paragraph 7., paragraph 5., and the addition of paragraph 15.d). 
<p>
<strong>Licensed by The Regents of the University of California, through Lawrence Berkeley National Laboratory under the Modelica License 2 </strong> 
 
<h4>1. Definitions</h4>
<ol type=\"a\"><li>
\"License\" is this Modelica License.
</li><li>
\"Original Work\" is any work of authorship, including software, images, documents, data files, that contains the above licensing notice or that is packed together with a licensing notice referencing it. 
</li><li>
\"Licensor\" is the provider of the Original Work who has placed this licensing notice adjacent to the copyright notice(s) for the Original Work. The Original Work is either directly provided by the owner of the Original Work, or by a licensee of the owner. 
</li><li>
\"Derivative Work\" is any modification of the Original Work which represents, as a whole, an original work of authorship. For the matter of clarity and as examples:
<ol type=\"A\">
<li>
Derivative Work shall not include work that remains separable from the Original Work, as well as merely extracting a part of the Original Work without modifying it. 
</li><li>
Derivative Work shall not include (a) fixing of errors and/or (b) adding vendor specific Modelica annotations and/or (c) using a subset of the classes of a Modelica package, and/or (d) using a different representation, e.g., a binary representation. 
</li><li>
Derivative Work shall include classes that are copied from the Original Work where declarations, equations or the documentation are modified. 
</li><li>
Derivative Work shall include executables to simulate the models that are generated by a Modelica translator based on the Original Work (of a Modelica package). </li>
</ol>
</li>
<li>
\"Modified Work\" is any modification of the Original Work with the following exceptions: (a) fixing of errors and/or (b) adding vendor specific Modelica annotations and/or (c) using a subset of the classes of a Modelica package, and/or (d) using a different representation, e.g., a binary representation. 
</li><li>
\"Source Code\" means the preferred form of the Original Work for making modifications to it and all available documentation describing how to modify the Original Work. 
</li><li>
\"You\" means an individual or a legal entity exercising rights under, and complying with all of the terms of, this License. 
</li><li>
\"Modelica package\" means any Modelica library that is defined with the
 <b>package</b> &lt;Name&gt; ... <b>end</b> &lt;Name&gt;<b>;</b> Modelica language element.
</li>
</ol>
 
<h4>2. Grant of Copyright License</h4>
<p>
Licensor grants You a worldwide, royalty-free, non-exclusive, sublicensable license, for the duration of the copyright, to do the following: 
<ol type=\"a\">
<li>
To reproduce the Original Work in copies, either alone or as part of a collection. 
</li><li>
To create Derivative Works according to Section 1d) of this License. 
</li><li>
To distribute or communicate to the public copies of the <u>Original Work</u> or a <u>Derivative Work</u> under <u>this License</u>. No fee, neither as a copyright-license fee, nor as a selling fee for the copy as such may be charged under this License. Furthermore, a verbatim copy of this License must be included in any copy of the Original Work or a Derivative Work under this License. 
<br>
For the matter of clarity, it is permitted A) to distribute or communicate such copies as part of a (possible commercial) collection where other parts are provided under different licenses and a license fee is charged for the other parts only and B) to charge for mere printing and shipping costs. 
</li><li>
To distribute or communicate to the public copies of a <u>Derivative Work</u>, alternatively to Section 2c), under <u>any other license</u> of your choice, especially also under a license for commercial/proprietary software, as long as You comply with Sections 3, 4 and 8 below. 
<br>
For the matter of clarity, no restrictions regarding fees, either as to a copyright-license fee or as to a selling fee for the copy as such apply. 
</li><li>
To perform the Original Work publicly. 
</li><li>
To display the Original Work publicly. 
</li></ol><p>
<h4>3. Acceptance</h4>
<p>
Any use of the Original Work or a Derivative Work, or any action according to either Section 2a) to 2f) above constitutes Your acceptance of this License. 
<p>
<h4>4. Designation of Derivative Works and of Modified Works</h4>
 
<p>
The identifying designation of Derivative Work and of Modified Work must be different to the corresponding identifying designation of the Original Work. This means especially that the (root-level) name of a Modelica package under this license must be changed if the package is modified (besides fixing of errors, adding vendor specific Modelica annotations, using a subset of the classes of a Modelica package, or using another representation, e.g. a binary representation). <p>
 
<h4>5. [reserved]</h4>
<p>
<h4>6. Provision of Source Code</h4>
<p>Licensor agrees to provide You with a copy of the Source Code of the Original Work but reserves the right to decide freely on the manner of how the Original Work is provided. For the matter of clarity, Licensor might provide only a binary representation of the Original Work. In that case, You may (a) either reproduce the Source Code from the binary representation if this is possible (e.g., by performing a copy of an encrypted Modelica package, if encryption allows the copy operation) or (b) request the Source Code from the Licensor who will provide it to You. 
<p>
<h4>7. Exclusions from License Grant</h4>
<p>
Neither the names of Licensor (including, but not limited to, University of California, Lawrence Berkeley National Laboratory, U.S. Dept. of Energy, UC, LBNL, LBL, and DOE), nor the names of any contributors to the Original Work, nor any of their trademarks or service marks, may be used to endorse or promote products derived from this Original Work without express prior permission of the Licensor. Except as otherwise expressly stated in this License and in particular in Sections 2 and 5, nothing in this License grants any license to Licensor's trademarks, copyrights, patents, trade secrets or any other intellectual property, and no patent license is granted to make, use, sell, offer for sale, have made, or import embodiments of any patent claims. 
<p>
No license is granted to the trademarks of Licensor even if such trademarks are included in the Original Work, except as expressly stated in this License. Nothing in this License shall be interpreted to prohibit Licensor from licensing under terms different from this License any Original Work that Licensor otherwise would have a right to license. 
<p>
<h4>8. Attribution Rights</h4>
<p>
You must retain in the Source Code of the Original Work and of any Derivative Works that You create, all author, copyright, patent, or trademark notices, as well as any descriptive text identified therein as an \"Attribution Notice\". The same applies to the licensing notice of this License in the Original Work. For the matter of clarity, \"author notice\" means the notice that identifies the original author(s). 
<p>
You must cause the Source Code for any Derivative Works that You create to carry a prominent Attribution Notice reasonably calculated to inform recipients that You have modified the Original Work. 
<p>In case the Original Work or Derivative Work is not provided in Source Code, the Attribution Notices shall be appropriately displayed, e.g., in the documentation of the Derivative Work. <p>
 
<h4>9. Disclaimer of Warranty</h4>
<p><u><strong>The Original Work is provided under this License on an \"as is\" basis and without warranty, either express or implied, including, without limitation, the warranties of non-infringement, merchantability or fitness for a particular purpose. The entire risk as to the quality of the Original Work is with You.</strong></u> This disclaimer of warranty constitutes an essential part of this License. No license to the Original Work is granted by this License except under this disclaimer. 
<p>
<h4>10. Limitation of Liability</h4>
<p>Under no circumstances and under no legal theory, whether in tort (including negligence), contract, or otherwise, shall the Licensor, the owner or a licensee of the Original Work be liable to anyone for any direct, indirect, general, special, incidental, or consequential damages of any character arising as a result of this License or the use of the Original Work including, without limitation, damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses. This limitation of liability shall not apply to the extent applicable law prohibits such limitation. 
<p>
<h4>11. Termination</h4>
<p>
This License conditions your rights to undertake the activities listed in Section 2 and 5, including your right to create Derivative Works based upon the Original Work, and doing so without observing these terms and conditions is prohibited by copyright law and international treaty. Nothing in this License is intended to affect copyright exceptions and limitations. This License shall terminate immediately and You may no longer exercise any of the rights granted to You by this License upon your failure to observe the conditions of this license. 
<p>
<h4>12. Termination for Patent Action</h4>
<p>
This License shall terminate automatically and You may no longer exercise any of the rights granted to You by this License as of the date You commence an action, including a cross-claim or counterclaim, against Licensor, any owners of the Original Work or any licensee alleging that the Original Work infringes a patent. This termination provision shall not apply for an action alleging patent infringement through combinations of the Original Work under combination with other software or hardware.
<p>
<h4>13. Jurisdiction</h4>
<p>
Any action or suit relating to this License may be brought only in the courts of a jurisdiction wherein the Licensor resides and under the laws of that jurisdiction excluding its conflict-of-law provisions. The application of the United Nations Convention on Contracts for the International Sale of Goods is expressly excluded. Any use of the Original Work outside the scope of this License or after its termination shall be subject to the requirements and penalties of copyright or patent law in the appropriate jurisdiction. This section shall survive the termination of this License. 
<p>
<h4>14. Attorneys' Fees</h4>
<p>
In any action to enforce the terms of this License or seeking damages relating thereto, the prevailing party shall be entitled to recover its costs and expenses, including, without limitation, reasonable attorneys' fees and costs incurred in connection with such action, including any appeal of such action. This section shall survive the termination of this License. 
<p>
<h4>15. Miscellaneous</h4>
<ol type=\"a\">
<li>If any provision of this License is held to be unenforceable, such provision shall be reformed only to the extent necessary to make it enforceable. 
</li><li>
No verbal ancillary agreements have been made. Changes and additions to this License must appear in writing to be valid. This also applies to changing the clause pertaining to written form. 
</li><li>
You may use the Original Work in all ways not otherwise restricted or conditioned by this License or by law, and Licensor promises not to interfere with or be responsible for such uses by You. 
</li><li>
You are under no obligation whatsoever to provide any bug fixes, patches, or upgrades to the features, functionality or performance of the source code (\"Enhancements\") to anyone; however, if you choose to make your Enhancements available either publicly, or directly to Lawrence Berkeley National Laboratory, without imposing a separate written license agreement for such Enhancements, then you hereby grant the following license: a non-exclusive, royalty-free perpetual license to install, use, modify, prepare derivative works, incorporate into other computer software, distribute, and sublicense such enhancements or derivative works thereof, in binary and source code form. 
</li></ol>
<p>
<h4>How to Apply the Modelica License 2</h4>
<p>
At the top level of your Modelica package and at every important subpackage, add the following notices in the info layer of the package: 
<ul><li style=\"list-style-type:none\">
Licensed by The Regents of the University of California, through Lawrence Berkeley National Laboratory under the Modelica License 2 Copyright (c) 2009-2012, The Regents of the University of California, through Lawrence Berkeley National Laboratory. 
<p>
<li style=\"list-style-type:none\"><i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) here or at </em><a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html</a>. 
</i>
</li></ul>
<p>
Include a copy of the Modelica License 2 under <strong>&lt;library&gt;.UsersGuide.ModelicaLicense2</strong> 
(use <a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.mo\">
http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.mo</a>) 
Furthermore, add the list of authors and contributors under 
<strong>&lt;library&gt;.UsersGuide.Contributors</strong> or <strong>&lt;library&gt;.UsersGuide.Contact</strong> 
<p>
For example, sublibrary Modelica.Blocks of the Modelica Standard Library may have the following notices: 
<p>
<ul><li style=\"list-style-type:none\">
Licensed by Modelica Association under the Modelica License 2 Copyright (c) 1998-2008, Modelica Association. 
<p>
<li style=\"list-style-type:none\"><i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) here or at 
<a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html</a>. 
</i>
</li></ul>
<p>For C-source code and documents, add similar notices in the corresponding file.
<p>
For images, add a \"readme.txt\" file to the directories where the images are stored and include a similar notice in this file. 
<p>
In these cases, save a copy of the Modelica License 2 in one directory of the distribution, e.g., 
<a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2-standalone.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2-standalone.html</a> in directory <strong>&lt;library&gt;/help/documentation/ModelicaLicense2.html</strong>. 
</p>
</html>
"));
  end License;

  class Copyright "Copyright"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>Copyright</font></h4>
<p>
Copyright (c) 2009-2012, The Regents of the University of California, through Lawrence Berkeley National Laboratory (subject to receipt of any required approvals from the U.S. Dept. of Energy). All rights reserved.
</p><p>
If you have questions about your rights to use or distribute this software, please contact Berkeley Lab's Technology Transfer Department at 
<A HREF=\"mailto:TTD@lbl.gov\">TTD@lbl.gov</A>
</p><p>
NOTICE. This software was developed under partial funding from the U.S. Department of Energy. As such, the U.S. Government has been granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, and perform publicly and display publicly. Beginning five (5) years after the date permission to assert copyright is obtained from the U.S. Department of Energy, and subject to any subsequent five (5) year renewals, the U.S. Government is granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, distribute copies to the public, perform publicly and display publicly, and to permit others to do so. 
</p>
</html>
"));
  end Copyright;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free open-source library for modeling of building energy and control systems. 
Many models are based on models from the package
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a> and use
the same ports to ensure compatibility with models from that library.
</p><p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>. 
We welcome contributions from different users to further advance this library, 
whether it is through collaborative model development, through model use and testing
or through requirements definition or by providing feedback regarding the model applicability
to solve specific problems.
</p>
<p>
The library has the following <i>User's Guides</i>:
</p>
<ol>
<li>
<p>
General information about the use of the <code>Buildings</code> library
is available at
<a href=\"http://simulationresearch.lbl.gov/modelica/userGuide\">
http://simulationresearch.lbl.gov/modelica/userGuide</a>.
This web site covers general information that is not specific to the 
use of individual sublibraries or models.
Discussed topics include 
how to get started, best practices, how to post-process results using Python,
work-around for problems and how to develop models.
</p>
</li>
<li>
<p>
Some of the main sublibraries have their own
User's Guides that can be accessed by the links below.
These User's Guides are discussing items that are specific to the
individual libraries.
</p>
<p>
<table border=1 cellspacing=0 cellpadding=2>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Airflow.Multizone.UsersGuide\">Airflow.Multizone</a>
   </td>
   <td valign=\"top\">Library for multizone airflow and contaminant transport.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">BoundaryConditions</a>
   </td>
   <td valign=\"top\">Library for computing boundary conditions, such as solar irradiation.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.BoundaryConditions.WeatherData.UsersGuide\">BoundaryConditions.WeatherData</a>
   </td>
   <td valign=\"top\">Library for reading weather data.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.UsersGuide\">Fluid</a>
   </td>
   <td valign=\"top\">Library for one-dimensional fluid in piping networks with heat exchangers, valves, etc.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">Fluid.Actuators</a>
   </td>
   <td valign=\"top\">Library with valves and air dampers.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">Fluid.HeatExchangers.DXCoils</a>
   </td>
   <td valign=\"top\">Library with direct evaporative cooling coils.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Fluid.Movers</a>
   </td>
   <td valign=\"top\">Library with fans and pumps.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">Fluid.Sensors</a>
   </td>
   <td valign=\"top\">Library with sensors.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Interfaces.UsersGuide\">Fluid.Interfaces</a>
   </td>
   <td valign=\"top\">Base models that can be used by developers to implement new models.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.HeatTransfer.UsersGuide\">HeatTransfer</a>
   </td>
   <td valign=\"top\">Library heat transfer in building constructions.</td>
</tr>
</table>
</p>
</li>
<li>
<p>
There is also a tutorial available at 
<a href=\"modelica://Buildings.Examples.Tutorial\">
Buildings.Examples.Tutorial</a>.
The tutorial contains step by step instructions for how to build system models.
</p>
</li>
</ol>
</p>
</html>"));
end UsersGuide;


annotation (
version="1.3",
versionBuild=0,
versionDate="2012-07-26",
dateModified = "$Date$",
uses(Modelica(version="3.2")),
conversion(
 from(version="1.2",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.2_to_1.3fixme.mos"),
 from(version="1.1",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.1_to_1.2.mos"),
 from(version="1.0",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.0_to_1.1.mos"),
 from(version="0.12",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos")),
revisionId="$Id$",
preferredView="info",
Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free library
for modeling building energy and control systems. 
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The figure below shows a section of the schematic view of the model 
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
In the lower part of the figure, there is a dynamic model of a boiler, a pump and a stratified energy storage tank. Based on the temperatures of the storage tank, a finite state machine switches the boiler and its pump on and off. 
The heat distribution is done using a hydronic heating system with a three way valve and a pump with variable revolutions. The upper right hand corner shows a room model that is connected to a radiator whose flow is controlled by a thermostatic valve.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/UsersGuide/HydronicHeating.png\" border=\"1\">
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>. 
Contributions from different users to further advance this library are
welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Buildings;
