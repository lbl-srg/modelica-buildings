within ;
package Buildings "Library with models for building energy and control systems"
  extends Modelica.Icons.Package;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  class Conventions "Conventions"
    extends Modelica.Icons.Information;
    annotation (preferredView="info",
    Documentation(info="<html>
<p>
This library follows the conventions of the
<a href=\"modelica://Modelica.UsersGuide.Conventions\">
Modelica Standard Library</a>, which are as follows:
</p>

<p>
Note, in the html documentation of any Modelica library,
the headings \"h1, h2, h3\" should not be used,
because they are utilized from the automatically generated
documentation and headings.
Additional headings in the html documentation should start with \"h4\".
</p>

<p>
In the Modelica package the following conventions are used:
</p>

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
</html>"));
  end Conventions;

  package ReleaseNotes "Release notes"
    extends Modelica.Icons.ReleaseNotes;

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
       Electrochromic windows have been added. See <code>Buildings.Rooms.Examples.ElectroChromicWindow</code>.
     </li>
     <li>
       The models in <code>Buildings.Fluid.Movers</code> can now be configured to use
       three different control input signals: a continuous signal (depending on the model either
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
       Various models, in particular in the package <code>Buildings.Electrical</code>
       were reformulated to comply with the Modelica Language Definition.
       All models comply with the pedantic Modelica check of Dymola.
     </li>
   </ul>
   </div>
   <!-- New libraries -->
   <p>
   The following <b style=\"color:blue\">new libraries</b> have been added:
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
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
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
                          <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/426\">#426</a>.
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
                          <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/353\">Annex 60, #353</a>.
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
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>xxx</b>
       </td>
   </tr>
   <tr><td valign=\"top\">xxx
       </td>
       <td valign=\"top\">xxx
       </td>
   </tr>
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

    <tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes.UTube
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
                       to set the input as an integer input signal that selects the stage of the mover,
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
                          <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/305\">Annex 60 issue 305</a>.
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp<br/>
                        Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow

       </td>
       <td valign=\"top\">Refactored for a more efficient implementation.
                        Removed double declaration of <code>smooth(..)</code> and <code>smoothOrder</code>
                        and changed <code>Inline=true</code> to <code>LateInline=true</code>.
                        This is for
                        <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/301\">Annex 60 issue 301</a>
                        and for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/279\">Annex 60 issue 279</a>.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Rooms</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Rooms.BaseClasses.CFDExchange
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
   <tr><td valign=\"top\">Buildings.Rooms.CFD
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
                          <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/302\">Annex 60 issue 302</a>.
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
    <tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody<br/>
                          Buildings.BoundaryConditions.WeatherData.Bus
     </td>
       <td valign=\"top\">Renamed the connector from <code>radHorIR</code> to <code>HHorIR</code>
                          This is for
                          <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/376\">Annex 60 issue 376</a>.
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
                        that can be used to add water to the conservation equation..
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
                        <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/353\">Annex 60 issue 353</a>.
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
                        <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">Annex 60 issue 417</a>.                        For Dymola, the conversion script will remove
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
                        <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">Annex 60 issue 417</a>.
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
                        <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">Annex 60 issue 396</a>.
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
                        <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/411\">
                        Annex 60, issue 411</a>.
                        For Dymola, the conversion script updates the models.
     </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.PartialTwoPort
     </td>
     <td valign=\"top\">Renamed the protected parameters
                        <code>port_a_exposesState</code>, <code>port_b_exposesState</code> and
                        <code>showDesignFlowDirection</code>.
                        This is for
                        <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/349\">Annex 60 issue 349</a>
                        and
                        <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/351\">Annex 60 issue 351</a>.
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
                        See <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/299\">Annex 60 issue 299</a>
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
                        This is for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/281\">Annex 60 issue 281</a>.
                        Also, revised implementation so that equations are always consistent
                        and do not lead to division by zero,
                        also when connecting a <code>prescribedHeatFlowRate</code>
                        to <code>MixingVolume</code> instances.
                        Renamed <code>use_safeDivision</code> to <code>prescribedHeatFlowRate</code>.
                        See <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/282\">Annex 60 issue 282</a>
                        for a discussion.
                        For users who simply instantiate existing component models, this change is backward
                        compatible.
                        However, developers who implement component models that extend from
                        <code>Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</code> may need to update
                        the parameter <code>use_safeDivision</code> and use instead <code>prescribedHeatFlowRate</code>.
                        See the model documentation.
       </td>
   </tr>
   <tr><td colspan=\"2\"><b>Buildings.Rooms</b>
       </td>
   <tr><td valign=\"top\">Buildings.Rooms.MixedAir<br/>
                          Buildings.Rooms.CFD
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
   </table>
   <!-- Errors that have been fixed -->
   <p>
   The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
   that can lead to wrong simulation results):
   </p>
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
                          <a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/476\">
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
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
                          <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/303\">Annex 60 issue 303</a>.
       </td>
   </tr>

   <tr><td colspan=\"2\"><b>Buildings.Rooms</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Rooms.BaseClasses.MixedAirHeatGain
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
                          <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/303\">Annex 60 issue 303</a>.

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
                         <a href=\"modelica://Buildings.Utilities.Math.Functions.spliceFunction\">
                         Buildings.Utilities.Math.Functions.spliceFunction</a> is only once
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
                          32 bit code was generated. This is now corrected.
                          This closes
                          <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/287\">issue 287</a>.
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
   <p>
   Note:
   </p>
   <ul>
   <li>
   xxx
   </li>
   </ul>
   </html>"));
   end Version_3_0_0;

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
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
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
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
                          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil<br/>
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
   <table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
   <tr><td colspan=\"2\"><b>Buildings.Fluid</b>
       </td>
   </tr>
   <tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstanceTwoPort
       </td>
       <td valign=\"top\">Corrected wrong sensor signal if <code>allowFlowReversal=false</code>.
                          For this setting, the sensor output was for the wrong flow direction.
                          This corrects
                          <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/249\">issue 249</a>.
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
   <tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                          Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
       </td>
       <td valign=\"top\">Corrected documentation.
       </td>
   </tr>
   </table>
   </html>"));
   end Version_2_1_0;

    class Version_2_0_0 "Version 2.0.0"
      extends Modelica.Icons.ReleaseNotes;
        annotation (Documentation(info="<html>
<p>
Version 2.0.0 is a major release that contains various new packages, models
and improvements.
</p>
<p>
The following major additions have been done in version 2.0:
</p>
<ul>
<li>
A CFD model
that is embedded in a thermal zone has been added.
This model is implemented in <a href=\"modelica://Buildings.Rooms.CFD\">Buildings.Rooms.CFD</a>.
The CFD model is an implementation of the Fast Fluid Dynamics code
that allows three-dimensional CFD inside a thermal zone,
coupled to building heat transfer, HVAC components and feedback control loops.
</li>
<li>
A new package
<a href=\"modelica://Buildings.Electrical\">Buildings.Electrical</a>
has been added.
This package allows studying
buildings to electrical grid integration. It includes models for loads, transformers,
cables, batteries, PV and wind turbines.
Models exist for DC and AC systems with two- or three-phase that can be balanced and unbalanced.
The models compute voltage, current, active and reactive power
based on the quasi-stationary assumption or using the dynamic phasorial representation.
</li>
<li>
The new package
<a href=\"modelica://Buildings.Controls.DemandResponse\">
Buildings.Controls.DemandResponse</a>
contains models for demand response simulation.
</li>
<li>
The new package
<a href=\"modelica://Buildings.Controls.Predictors\">
Buildings.Controls.Predictors</a>
contains a data-driven model that predicts the electrical load
of a building. The prediction can be done
either using an average baseline or
a linear regression with respect to outside temperature.
For both, optionally a day-of adjustment can be made.
</li>
</ul>
<p>
The tables below give more detailed information to the revisions
of this library compared to the previous release 1.6 build 1.
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Electrical
    </td>
    <td valign=\"top\">Library for electrical grid simulation that
                       allows to study building to electrical grid integration.
                       The library contains models of loads, generation and transmission
                       for DC and AC systems.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Controls.DemandResponse
    </td>
    <td valign=\"top\">Library with a model for demand response prediction.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Controls.Predictors
    </td>
    <td valign=\"top\">Library with a data-driven model that predicts the electrical load
                     of a building. The prediction can be done
                     either using an average baseline or
                     a linear regression with respect to outside temperature.
                     For both, optionally a day-of adjustment can be made.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    </td>
    <td valign=\"top\">Model of a pressure-independent two way valve.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCooler_T
    </td>
    <td valign=\"top\">Model of a heater or cooler that takes as an input
                       the set point for the temperature of the fluid that leaves
                       the component. The set point is tracked exactly
                       if the component has sufficient capacity.
                       Optionally, the component can be configured to compute
                       a dynamic rather than a steady-state response.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Phi_pTX<br/>
                       Buildings.Utilities.Psychrometrics.Functions.phi_pTX
    </td>
    <td valign=\"top\">Block and function that computes the relative humidity
                       for given pressure, temperature and water vapor mass fraction.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.CFD
    </td>
    <td valign=\"top\">Room model that computes the room air flow
                       using computational fluid dynamics (CFD).
                       The CFD simulation is coupled to the thermal simulation of the room
                       and, through the fluid port, to the air conditioning system.
                       Currently, the supported CFD program is the
                       Fast Fluid Dynamics (FFD) program.
                       See
                       <a href=\"modelica://Buildings.Rooms.UsersGuide.CFD\">Buildings.Rooms.UsersGuide.CFD</a>
                       for detailed explanations.
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
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Added option to obtain the black body sky temperature
                       from a parameter or an input signal rather than
                       computing it in the weather data reader.<br/><br/>
                       Removed redundant connection
                       <code>connect(conHorRad.HOut, cheHorRad.HIn);</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Chillers.ElectricEIR<br/>
                       Buildings.Chillers.ElectricReformulatedEIR
    </td>
    <td valign=\"top\">Changed implementation so that the model
                       is continuously differentiable.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/373\">373</a>.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow
    </td>
    <td valign=\"top\">Changed assignment of <code>T_m</code> to avoid using the conditionally
                       enabled model <code>ele[:].mas.T</code>, which is only
                       valid in a connect statement.
                       Moved assignments of
                       <code>Q1_flow</code>, <code>Q2_flow</code>, <code>T1</code>,
                       <code>T2</code> and <code>T_m</code> outside of equation section
                       to avoid mixing graphical and textual modeling within the same model.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized
    </td>
    <td valign=\"top\">Removed parameter <code>m1_flow_nominal</code>, as this parameter is already
                    declared in its base class
                    <a href=\"modelica://Buildings.Fluid.Interfaces.PartialFourPortInterface\">
                    Buildings.Fluid.Interfaces.PartialFourPortInterface</a>.
                    This change avoids an error in OpenModelica as the two declarations
                    had a different value for the <code>min</code> attribute, which is not valid
                    in Modelica.
    </td>
    </tr>
    <tr>
    <td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.CoilRegister<br/>
                       Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldDistributor
    </td>
    <td valign=\"top\">Reformulated the multiple iterators in the <code>sum</code> function
                       as this language construct is not supported in OpenModelica.
    </td>
    </tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
    </td>
    <td valign=\"top\">Set start value for <code>hPip(fluid(T))</code> to avoid
                       a warning about conflicting start values.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.Movers.SpeedControlled_y<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow

    </td>
    <td valign=\"top\">For the parameter setting <code>use_powerCharacteristic=true</code>,
                     changed the computation of the power consumption at
                     reduced speed to properly account for the
                     affinity laws. This is in response to
                     <a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>.
    </td>
</tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.SolarCollectors.ASHRAE93<br/>
                       Buildings.Fluid.SolarCollectors.EN12975
    </td>
    <td valign=\"top\">Reformulated the model to avoid a translation error
                       if glycol is used.<br/>
                       Propagated parameters for initialization in base class
                       <code>Buildings.Fluid.SolarCollectors.BaseClasses.PartialSolarCollector</code>
                       and set <code>prescribedHeatFlowRate=true</code>.
    </td>
    </tr>

    <tr>
    <td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Replaced the <code>abs()</code> function in the assignment of the parameter
                       <code>nSegHexTan</code> as the return value of <code>abs()</code>
                       is a <code>Real</code> which causes a type error during model check.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.MultiLayer
    </td>
    <td valign=\"top\">Changed the assignment of <code>_T_a_start</code>,
                       <code>_T_b_start</code> and <code>RTot</code> to be
                       in the initial equation section as opposed to
                       the parameter declaration.
                       This is needed to avoid an error during model check
                       and translation in Dymola 2015 FD01 beta1.
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective
    </td>
    <td valign=\"top\">Changed model to allow a temperature dependent convective heat transfer
                       on the room side.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
    </td>
    </tr>

<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media.Interfaces.PartialSimpleIdealGasMedium<br/>
                       Buildings.Media.Interfaces.PartialSimpleMedium
    </td>
    <td valign=\"top\">Set <code>T(start=T_default)</code> and
                       <code>p(start=p_default)</code> in the
                       <code>ThermodynamicState</code> record. Setting the start value for
                       <code>T</code> is required to avoid an error due to
                       conflicting start values when translating
                       <a href=\"modelica://Buildings.Examples.VAVReheat.ClosedLoop\">
                       Buildings.Examples.VAVReheat.ClosedLoop</a> in pedantic mode.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Rooms.MixedAir
    </td>
    <td valign=\"top\">Changed model to allow a temperature dependent convective heat transfer
                       on the room side for windows.
                       This is for issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
    </td>
    </tr>

<tr><td valign=\"top\">Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow
    </td>
    <td valign=\"top\">Conditionally removed the shade model if no shade is present.
                       This corrects
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/234\">#234</a>.
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
<tr><td colspan=\"2\"><b>Buildings.Airflow</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.ZonalFlow_ACS<br/>
                       Buildings.Airflow.Multizone.ZonalFlow_m_flow
   </td>
   <td valign=\"top\">Removed parameter <code>forceErrorControlOnFlow</code> as it was not used.
                       For Dymola, the conversion script will automatically
                       update existing models.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
   </td>
   <td valign=\"top\">Changed the following signals for compatibility with OpenModelica:<br/>
                      <code>weaBus.sol.zen</code> to <code>weaBus.solZen</code>.<br/>
                      <code>weaBus.sol.dec</code> to <code>weaBus.solDec</code>.<br/>
                      <code>weaBus.sol.alt</code> to <code>weaBus.solAlt</code>.<br/>
                      <code>weaBus.sol.solHouAng</code> to <code>weaBus.solHouAng</code>.<br/>
                      For Dymola, the conversion script will automatically
                      update existing models.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Examples</b>
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.IntegerSum
   </td>
   <td valign=\"top\">Removed block as it is not used in any model.
                      Models that require an integer sum can use
                      <code>Modelica.Blocks.MathInteger.Sum</code>.
   </td>
</tr>
<tr><td valign=\"top\">Buildings.Examples.VAVReheat.Controls.UnoccupiedOn
   </td>
   <td valign=\"top\">Removed block as it is not used in any model.
   </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Data.GlazingSystems.Generic
    </td>
    <td valign=\"top\">Removed parameter <code>nLay</code> as OpenModelica
                       could not assign it during translation.
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u
    </td>
    <td valign=\"top\">Changed the input argument for this function from type
                       <code>Buildings.HeatTransfer.Data.BaseClasses.Material</code>
                       to the elements of this type as OpenModelica fails to translate the
                       model if the input to this function is a record.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Types.Azimuth<br/>
                       Buildings.HeatTransfer.Types.Tilt
    </td>
    <td valign=\"top\">Moved these types from <code>Buildings.HeatTransfer</code>
                       to the top-level package <code>Buildings</code> because
                       they are used in <code>Buildings.BoundaryConditions</code>,
                       <code>Buildings.HeatTransfer</code> and <code>Buildings.Rooms</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
    </tr>

<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.Pipe<br/>
                       Buildings.Fluid.FixedResistances.BaseClasses.Pipe<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab
    </td>
    <td valign=\"top\">Renamed pressure drop from <code>res</code> to
                       <code>preDro</code> to use the same name as in other models.
                       This corrects
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">#271</a>.
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilDiscretized
    </td>
    <td valign=\"top\">Reformulated flow splitter in the model to reduce
                       the dimension of the coupled linear or nonlinear
                       system of equations. With this revision, the optional
                       control volume in the duct inlet has been removed
                       as it is no longer needed. Therefore, the parameter
                       <code>dl</code> has also been removed.
                       Replaced the parameters <code>energyDynamics1</code>
                       and  <code>energyDynamics2</code> with
                       <code>energyDynamics</code>.
                       Removed the parameter <code>ductConnectionDynamics</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed
    </td>
    <td valign=\"top\">Renamed the model to <code>HeaterCooler_u</code> due to
                       the introduction of the new model <code>HeaterCooler_T</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab
    </td>
    <td valign=\"top\">Changed the models to use by default an <i>&epsilon;-NTU</i>
                       approach for the heat transfer between the fluid and the slab
                       rather than a finite difference scheme along the
                       flow path.
                       Optionally, the finite difference scheme can also be used
                       as this is needed for some control design applications.<br/>
                       The new <i>&epsilon;-NTU</i> formulation has shown to lead to
                       about five times faster
                       computation on several test cases including the models in
                       <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.Examples\">
                       Buildings.Rooms.FLEXLAB.Rooms.Examples</a>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
 </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.DuctManifoldFixedResistance
    </td>
    <td valign=\"top\">Reformulated flow splitter in the model to reduce
                       the dimension of the coupled linear or nonlinear
                       system of equations. With this revision, the optional
                       control volume in the duct inlet has been removed
                       as it is no longer needed. Therefore, the parameters
                       <code>dl</code> and <code>energyDynamics</code> have
                       also been removed.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.CoilRegister
    </td>
    <td valign=\"top\">Replaced the parameters <code>energyDynamics1</code>
                       and <code>energyDynamics2</code> with
                       the new parameter <code>energyDynamics</code>.
                       Removed the parameters <code>steadyState_1</code>
                       and <code>steadyState_2</code> as this information
                       is already contained in <code>energyDynamics</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.
    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.MassExchangers.HumidifierPrescribed
    </td>
    <td valign=\"top\">Renamed the model to <code>Humidifier_u</code> due to
                       the introduction of the new model <code>HeaterCooler_T</code>
                       and to use the same naming pattern as <code>HeaterCooler_u</code>.<br/>
                       For Dymola, the conversion script will automatically
                       update existing models.

    </td>
</tr>

<tr><td valign=\"top\">Buildings.Fluid.Movers
    </td>
    <td valign=\"top\">This package has been redesigned.
                       The models have been renamed as follows:<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_dp</code>
                       is now called
                       <code>Buildings.Fluid.Movers.FlowControlled_dp</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_m_flow</code>
                       is now called
                       <code>Buildings.Fluid.Movers.FlowControlled_m_flow</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_Nrpm</code>
                       is now called
                       <code>Buildings.Fluid.Movers.SpeedControlled_Nrpm</code>.<br/>
                       <code>Buildings.Fluid.Movers.FlowMachine_y</code>
                       is now called
                       <code>Buildings.Fluid.Movers.SpeedControlled_y</code>.<br/><br/>
                       In addition, the performance
                       data of all movers are now stored in a record.
                       These records are in
                       <a href=\"modelica://Buildings.Fluid.Movers.Data\">
                       Buildings.Fluid.Movers.Data</a>.
                       For most existing instances, it should be sufficient to enclose
                       the existing performance data in a record called <code>per</code>.
                       For example,
                       <code><br/>
                       Buildings.Fluid.Movers.FlowMachine_y fan(<br/>
                       &nbsp;redeclare package Medium = Medium,<br/>
                       &nbsp;pressure(<br/>
                       &nbsp;&nbsp;V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,<br/>
                       &nbsp;&nbsp;dp={2*dp_nominal,dp_nominal,0})));<br/>
                       </code>
                       becomes
                       <code><br/>
                       Buildings.Fluid.Movers.SpeedControlled_y fan(<br/>
                       &nbsp;redeclare package Medium = Medium,<br/>
                       &nbsp;per(<br/>
                       &nbsp;&nbsp;pressure(<br/>
                       &nbsp;&nbsp;&nbsp;V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,<br/>
                       &nbsp;&nbsp;&nbsp;dp={2*dp_nominal,dp_nominal,0})));<br/>
                       </code>
                       <br/>
                       See the <a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
                       User's Guide</a> for more information about these records.
                       <br/><br/>
                       For Dymola, the conversion script will
                       update existing models to use the old implementations
                       which are now in the package <code>Buildings.Obsolete.Fluid.Movers</code>.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Media</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Media
    </td>
<td>
                       Renamed all media to simplify the media selection.
                       For typical building energy simulation,
                       <a href=\"modelica://Buildings.Media.Air\">Buildings.Media.Air</a> and
                       <a href=\"modelica://Buildings.Media.Water\">Buildings.Media.Water</a>
                       should be used.<br/><br/>
                       The following changes were made.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated</code><br/>
                       to <code>Buildings.Media.Air</code>.<br/><br/>
                       Renamed <code>Buildings.Media.ConstantPropertyLiquidWater</code><br/>
                       to <code>Buildings.Media.Water</code>.<br/><br/>
                       Renamed <code>Buildings.Media.PerfectGases.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.PerfectGases.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.MoistAirUnsaturated</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesConstantDensity.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesConstantDensity.SimpleAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.IdealGases.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.IdealGases.SimpleAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.MoistAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesPTDecoupled.MoistAir</code>.<br/><br/>
                       Renamed <code>Buildings.Media.GasesPTDecoupled.SimpleAir</code><br/>
                       to <code>Buildings.Obsolete.Media.GasesPTDecoupled.SimpleAir</code>.<br/><br/>
                       For Dymola, the conversion script will
                       update existing models according to the above list.

</td>
</tr>


<tr><td valign=\"top\">Buildings.Media.Water
    </td>
    <td valign=\"top\">Removed option to model water as a compressible medium as
                       this option was not useful.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.BaseClasses.ParameterConstructionWithWindow
    </td>
    <td valign=\"top\">Removed the keyword <code>replaceable</code> for the parameters
                       <code>ove</code> and <code>sidFin</code>.<br/>
                       Models that instantiate <code>Buildings.Rooms.MixedAir</code> are
                       not affected by this change.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.Examples.BESTEST
    </td>
    <td valign=\"top\">Moved the package to <code>Buildings.Rooms.Validation.BESTEST</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.SimulationTime
    </td>
    <td valign=\"top\">Moved the block <code>Buildings.Utilities.SimulationTime</code>
                       to <code>Buildings.Utilities.Time.ModelTime</code>.<br/>
                       For Dymola, the conversion script will
                       update existing models according to the above list.
    </td>
</tr>

</table>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    </td>
    <td valign=\"top\">Corrected error that led the total and opaque sky cover to be ten times
                       too low if its value was obtained from the parameter or the input connector.
                       For the standard configuration in which the sky cover is obtained from
                       the weather data file, the model was correct. This error only affected
                       the other two possible configurations.
    </td>
</tr><tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Pipes
    </td>
    <td valign=\"top\">Corrected wrong entries for inner and outer diameter
                       of PEX pipes.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.singleUTubeResistances
    </td>
    <td valign=\"top\">Corrected error in function that used <code>beta</code>
                       before it was assigned a value.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.Stratified<br/>
                       Buildings.Fluid.Storage.StratifiedEnhanced<br/>
                       Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Replaced the use of <code>Medium.lambda_const</code> with
                       <code>Medium.thermalConductivity(sta_default)</code> as
                       <code>lambda_const</code> is not declared for all media.
                       This avoids a translation error if certain media are used.
    </td>
</tr><tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Corrected issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/271\">#271</a>
                       which led to a compilation error if the heat exchanger
                       and the tank had different media.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>

<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Corrected issue
                       <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/304\">#304</a>
                       that led to an error in the glass temperatures if the glass conductance
                       is very small.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.MixedAir
    </td>
    <td valign=\"top\">Added propagation of the parameter value <code>linearizeRadiation</code>
                       to the window model. Prior to this change, the radiation
                       was never linearized for computing the glass long-wave radiation.
    </td>
<tr><td valign=\"top\">Buildings.Rooms.FLEXLAB.Rooms.Examples.TestBedX3WithRadiantFloor<br/>
                            Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor<br/>
                            Buildings.Rooms.FLEXLAB.Rooms.Examples.X3BWithRadiantFloor
    </td>
    <td valign=\"top\">Corrected wrong entries for inner and outer diameter
                       of PEX pipes.
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
<tr><td valign=\"top\">Buildings.Fluid.FixedResistances.FixedResistanceDpM
    </td>
    <td valign=\"top\">Corrected error in documentation of computation of <code>k</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer
    </td>
    <td valign=\"top\">Changed type of <code>tauIR</code> from
                       <code>Modelica.SIunits.Emissivity</code> to
                       <code>Modelica.SIunits.TransmissionCoefficient</code>.
                       This avoids a type error in OpenModelica.
    </td>
</tr>

</table>

<p>
<b>Note:</b>
</p>
<p>
With version 2.0, we start using semantic versioning as described at <a href=\"http://semver.org/\">http://semver.org/</a>.
</p>
</html>"));
    end Version_2_0_0;

    class Version_1_6_build1 "Version 1.6 build 1"
      extends Modelica.Icons.ReleaseNotes;
        annotation (Documentation(info="<html>
<p>
Version 1.6 build 1 updates the <code>Buildings</code> library to the
Modelica Standard Library 3.2.1 and to <code>Modelica_StateGraph2</code> 2.0.2.
</p>
<p>
This is the first version of the <code>Buildings</code> library
that contains models from the
<a href=\"https://github.com/iea-annex60/modelica-annex60\">
IEA EBC Annex 60 library</a>,
a Modelica library for building and community energy systems that is
collaboratively developed within the project
<a href=\"http://www.iea-annex60.org\">
\"New generation computational tools for building and community energy systems
based on the Modelica and Functional Mockup Interface standards\"</a>,
a project that is conducted under the
Energy in Buildings and Communities Programme (EBC) of the
International Energy Agency (IEA).
</p>
<!-- New libraries -->
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.TwoWayTable
    </td>
    <td valign=\"top\">Two way valve for which the opening characteristics
                       is specified by a table.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Math</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Examples.Average
                       Buildings.Utilities.Math.Examples.InverseXRegularized
                       Buildings.Utilities.Math.Examples.Polynominal
                       Buildings.Utilities.Math.Examples.PowerLinearized
                       Buildings.Utilities.Math.Examples.QuadraticLinear
                       Buildings.Utilities.Math.Examples.RegNonZeroPower
                       Buildings.Utilities.Math.Examples.SmoothExponential
                       Buildings.Utilities.Math.Functions.average
                       Buildings.Utilities.Math.Functions.booleanReplicator
                       Buildings.Utilities.Math.Functions.Examples.IsMonotonic
                       Buildings.Utilities.Math.Functions.Examples.TrapezoidalIntegration
                       Buildings.Utilities.Math.Functions.integerReplicator
                       Buildings.Utilities.Math.InverseXRegularized
                       Buildings.Utilities.Math.Polynominal
                       Buildings.Utilities.Math.PowerLinearized
                       Buildings.Utilities.Math.QuadraticLinear
                       Buildings.Utilities.Math.RegNonZeroPower
                       Buildings.Utilities.Math.SmoothExponential
                       Buildings.Utilities.Math.TrapezoidalIntegration
    </td>
    <td valign=\"top\">Various functions and blocks for mathematical operations.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Psychrometrics</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Examples.SaturationPressureLiquid
                       Buildings.Utilities.Psychrometrics.Examples.SaturationPressure
                       Buildings.Utilities.Psychrometrics.Examples.SublimationPressureIce
                       Buildings.Utilities.Psychrometrics.Functions.BaseClasses.der_saturationPressureLiquid
                       Buildings.Utilities.Psychrometrics.Functions.BaseClasses.der_sublimationPressureIce
                       Buildings.Utilities.Psychrometrics.Functions.BaseClasses.Examples.SaturationPressureDerivativeCheck
                       Buildings.Utilities.Psychrometrics.Functions.Examples.SaturationPressure
                       Buildings.Utilities.Psychrometrics.Functions.saturationPressureLiquid
                       Buildings.Utilities.Psychrometrics.Functions.saturationPressure
                       Buildings.Utilities.Psychrometrics.Functions.sublimationPressureIce
                       Buildings.Utilities.Psychrometrics.SaturationPressureLiquid
                       Buildings.Utilities.Psychrometrics.SaturationPressure
                       Buildings.Utilities.Psychrometrics.SublimationPressureIce
    </td>
    <td valign=\"top\">Various functions and blocks for psychrometric calculations.
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
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential
    </td>
    <td valign=\"top\">Improved documentation of the flow resistance.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
    </td>
    <td valign=\"top\">Added the option to use a constant, an input signal or the weather file as the source
                       for the ceiling height, the total sky cover, the opaque sky cover, the dew point temperature,
                       and the infrared horizontal radiation <code>HInfHor</code>.
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
<tr><td valign=\"top\">Buildings.Fluid.Movers.FlowMachinePolynomial
    </td>
    <td valign=\"top\">Moved the model to the package
                       <code>Buildings.Obsolete</code>,
                       as this model is planned to be removed in future versions.
                       The conversion script should update old instances of
                       this model automatically in Dymola.
                       Users should change their models to use a flow machine from
                       the package <code>Buildings.Fluid.Movers</code>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.ExpansionVessel
    </td>
    <td valign=\"top\">Simplified the model to have a constant pressure.
                       The following non-backward compatible changes
                       have been made.
                       <ol>
                       <li>The parameter <code>VTot</code> was renamed to <code>V_start</code>.</li>
                       <li>The following parameters were removed: <code>VGas0</code>,
                           <code>pMax</code>, <code>energyDynamics</code> and <code>massDynamics</code>.</li>
                       </ol>
                       The conversion script should update old instances of
                       this model automatically in Dymola.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Revised the model as the old version required the port<sub>a</sub>
                       of the heat exchanger to be located higher than port<sub>b</sub>.
                       This makes sense if the heat exchanger is used to heat up the tank,
                       but not if it is used to cool down a tank, such as in a cooling plant.
                       The following parameters were changed:
                       <ol>
                         <li>Changed <code>hexTopHeight</code> to <code>hHex_a</code>.</li>
                         <li>Changed <code>hexBotHeight</code> to <code>hHex_b</code>.</li>
                         <li>Changed <code>topHexSeg</code> to <code>segHex_a</code>,
                          and made it protected as this is deduced from <code>hHex_a</code>.</li>
                         <li>Changed <code>botHexSeg</code> to <code>segHex_b</code>,
                          and made it protected as this is deduced from <code>hHex_b</code>.</li>
                       </ol>
                       The names of the following ports have been changed:
                       <ol>
                         <li>Changed <code>port_a1</code> to <code>portHex_a</code>.</li>
                         <li>Changed <code>port_b1</code> to <code>portHex_b</code>.</li>
                       </ol>
                       The conversion script should update old instances of
                       this model automatically in Dymola for all of the above changes.
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
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes.UTube
    </td>
    <td valign=\"top\">Reimplemented the resistor network inside the borehole
                       as the old implementation led to too slow a transient
                       response. This change also led to the removal of the
                       parameters <code>B0</code> and <code>B1</code>
                       as the new implementation does not require them.
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
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.HexInternalElement
    </td>
    <td valign=\"top\">Corrected error in documentation which stated a wrong default value
                       for the pipe spacing.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ()
    </td>
    <td valign=\"top\">Added dummy argument to function call of <code>Internal.solve</code>
                       to avoid a warning during model check in Dymola 2015.
    </td>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryEffectivenessNTU
    </td>
    <td valign=\"top\">Changed <code>assert</code> statement to avoid comparing
                       enumeration with an integer, which triggers a warning
                       in Dymola 2015.
    </td>

    </tr>    <tr><td valign=\"top\">Buildings.Rooms.Constructions.Examples.ExteriorWall<br/>
                           Buildings.Rooms.Constructions.Examples.ExteriorWallWithWindow<br/>
                           Buildings.Rooms.Constructions.Examples.ExteriorWallTwoWindows
    </td>
    <td valign=\"top\">Corrected wrong assignment of parameter in instance <code>bouConExt(conMod=...)</code>
                       which was set to an interior instead of an exterior convection model.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.Psychrometrics.Functions.TDewPoi_pW()
    </td>
    <td valign=\"top\">Added dummy argument to function call of <code>Internal.solve</code>
                       to avoid a warning during model check in Dymola 2015.
    </td>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table border=\"1\" summary=\"github issues\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/196\">#196</a>
    </td>
    <td valign=\"top\">Change capacity location in borehole grout.
    </td>
</tr>
</table>
</html>"));
    end Version_1_6_build1;

    class Version_1_5_build3 "Version 1.5 build 3"
      extends Modelica.Icons.ReleaseNotes;
        annotation (preferredView="info",
        Documentation(info="<html>
<p>
Version 1.5 build 3 is a maintenance release that corrects an error in
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>.
It is fully compatible with version 1.5 build 2.
</p>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MassExchangers.HumidifierPrescribed
    </td>
    <td valign=\"top\">
           Corrected the enthalpy balance, which caused the latent heat flow rate to be added
           twice to the fluid stream.
           This closes issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>HumidifierPrescribed accounts twice for latent heat gain</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>
    </td>
    <td valign=\"top\">This issue has been addressed by correcting the latent heat added to the
                       fluid stream.
    </td>
</tr>
</table>
</html>"));
    end Version_1_5_build3;

    class Version_1_5_build2 "Version 1.5 build 2"
      extends Modelica.Icons.ReleaseNotes;
        annotation (preferredView="info",
        Documentation(info="<html>
<p>
Version 1.5 build 2 is a maintenance release that corrects an error in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilDiscretized\">
Buildings.Fluid.HeatExchangers.DryCoilDiscretized</a> and in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilDiscretized\">
Buildings.Fluid.HeatExchangers.WetCoilDiscretized</a>.
It is fully compatible with version 1.5 build 1.
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilDiscretized<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilDiscretized
    </td>
    <td valign=\"top\">
           Corrected wrong connect statements that caused the last register to have
           no liquid flow.
           This closes issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/194\">#194</a>.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>DryCoilDiscretized model not using last register, liquid flow path</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/194\">#194</a>
    </td>
    <td valign=\"top\">This issue has been addressed by correcting the connect statements.
    </td>
</tr>
</table>
</html>"));
    end Version_1_5_build2;

    class Version_1_5_build1 "Version 1.5 build 1"
      extends Modelica.Icons.ReleaseNotes;
        annotation (preferredView="info",
        Documentation(info="<html>
<p>
Version 1.5 build 1 is a major release that contains new packages with models for
solar collectors and for the Facility for Low Energy Experiments (FLEXLAB)
at the Lawrence Berkeley National Laboratory.
</p>
<p>
This release also contains a major revision of all info sections to correct invalid html syntax.
The package <code>Buildings.HeatTransfer.Radiosity</code> has been revised to comply
with the Modelica language specification.
The package <code>Buildings.Rooms</code> has been revised to aid implementation of
non-uniformly mixed room air models.
This release also contains various corrections that avoid warnings during translation
when used with Modelica 3.2.1.
Various models have been revised to increase compatibility with OpenModelica.
However, currently only a subset of the models work with OpenModelica.
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.SolarCollectors
    </td>
    <td valign=\"top\">Library with solar collectors.
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Rooms.FLEXLAB
    </td>
    <td valign=\"top\">Package with models for test cells of LBNL's FLEXLAB
                       (Facility for Low Energy Experiments in Buildings).
    </td>
    </tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.FLEXLAB
    </td>
    <td valign=\"top\">Package that demonstrates two-way data exchange
                       between Modelica and LBNL's FLEXLAB (Facility for
                       Low Energy Experiments in Buildings).
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.Storage</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Storage.StratifiedEnhancedInternalHex
    </td>
    <td valign=\"top\">Added a model of a tank with built-in heat exchanger.
                       This model may be used together with solar thermal plants.
    </td>
    </tr>
<tr><td colspan=\"2\"><b>Buildings.Resources</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Resources.Include
    </td>
    <td valign=\"top\">Added an <code>Include</code> folder and the <code>bcvtb.h</code>
    header file to it to fix compilation errors in BCVTB example files.
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
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
                       Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
    </td>
    <td valign=\"top\">Improved the algorithm that determines the absolute path of the file.
                       Now weather files are searched in the path specified, and if not found, the urls
                       <code>file://</code>, <code>modelica://</code> and <code>modelica://Buildings</code>
                       are added in this order to search for the weather file.
                       This allows using the data reader without having to specify an absolute path,
                       as long as the <code>Buildings</code> library
                       is on the <code>MODELICAPATH</code>.
    </td>
</tr>


<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation
    </td>
    <td valign=\"top\">Reformulated computation of outlet properties to avoid an event at zero mass flow rate.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc
    </td>
    <td valign=\"top\">Simplified the implementation for the situation if
                       <code>allowReverseFlow=false</code>.
                       Avoided the use of the conditionally enabled variables <code>sta_a</code> and
                       <code>sta_b</code> as this was not proper use of the Modelica syntax.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.Examples.ReverseFlowHumidifier
    </td>
    <td valign=\"top\">Changed one instance of <code>Modelica.Fluid.Sources.MassFlowSource_T</code>,
                       that was connected to the two fluid streams,
                       to two instances, each having half the mass flow rate.
                       This is required for the model to work with Modelica 3.2.1 due to the
                       change introduced in
                       ticket <a href=\"https://trac.modelica.org/Modelica/ticket/739\">#739</a>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.EnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.LatentEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.VolumeFlowRate
    </td>
    <td valign=\"top\">Removed default value <code>tau=0</code> as the base class
                       already sets <code>tau=1</code>.
                       This change was made so that all sensors use the same default value.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstancesTwoPort
    </td>
    <td valign=\"top\">Added default value <code>C_start=0</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
    </td>
    <td valign=\"top\">Changed the annotation of the
                       instance <code>material</code> from
                       <code>Evaluate=true</code> to <code>Evaluate=false</code>.
                       This is required to allow changing the
                       material properties after compilation.
                       Note, however, that the number of state variables in
                       <a href=\"modelica://Buildings.HeatTransfer.Data.BaseClasses.Material\">
                       Buildings.HeatTransfer.Data.BaseClasses.Material</a>
                       are only computed when the model is translated, because
                       the number of state variables is fixed
                       at compilation time.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Diagnostics.AssertEquality<br/>
                       Buildings.Utilities.Diagnostics.AssertInequality
    </td>
    <td valign=\"top\">Added <code>time</code> in print statement as OpenModelica,
                       in its error message, does not output the time
                       when the assert is triggered.
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

<tr><td colspan=\"2\"><b>Buildings.Airflow</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Airflow.Multizone.Orifice<br/>
                       Buildings.Airflow.Multizone.EffectiveAirLeakageArea<br/>
                       Buildings.Airflow.Multizone.ZonalFlow_ACS
    </td>
    <td valign=\"top\">Changed the parameter <code>useConstantDensity</code> to
                       <code>useDefaultProperties</code> to use consistent names
                       within this package.
                       A conversion script in <code>Resources/Scripts/Dymola</code>
                       can be used to update old models that use this parameter.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.BaseClasses.IndexWater
    </td>
    <td valign=\"top\">Renamed class to
                       <code>Buildings.Fluid.BaseClasses.IndexMassFraction</code>
                       as it is applicable for all mass fraction sensors.
    </td>
</tr>
<tr><td valign=\"top\">
                       Buildings.Fluid.HeatExchangers.ConstantEffectiveness<br/>
                       Buildings.Fluid.HeatExchangers.DryEffectivenessNTU<br/>
                       Buildings.Fluid.Interfaces.ConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.MassExchangers.ConstantEffectiveness<br/>
                       Buildings.Fluid.MassExchangers.HumidifierPrescribed<br/>
                       Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolume<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolumeDryAir<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir<br/>
                       Buildings.Fluid.Storage.ExpansionVessel
    </td>
    <td valign=\"top\">Changed the input connector <code>mXi_flow</code> (or <code>mXi1_flow</code>
                       and <code>mXi2_flow</code>) to <code>mWat_flow</code> (or <code>mWat1_flow</code>
                       and <code>mWat2_flow</code>).
                       This change has been done as declaring <code>mXi_flow</code> is ambiguous
                       because it does not specify what other species are added unless a mass flow rate
                       <code>m_flow</code> is also known. To avoid this confusion, the connector variables
                       have been renamed.
                       The equations that were used were, however, correct.
                       This addresses issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/165\">#165</a>.
    </td>
</tr>
<tr><td valign=\"top\">
                       Buildings.Fluid.Storage.BaseClasses.IndirectTankHeatExchanger<br/>
                       Buildings.Fluid.BaseClasses.PartialResistance<br/>
                       Buildings.Fluid.FixedResistances.BaseClasses.Pipe<br/>
                       Buildings.Fluid.FixedResistances.FixedResistanceDpM<br/>
                       Buildings.Fluid.FixedResistances.LosslessPipe<br/>
                       Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.BoreholeSegment<br/>
                       Buildings.Fluid.HeatExchangers.Boreholes.UTube<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab<br/>
                       Buildings.Fluid.Interfaces.FourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.PartialFourPortInterface<br/>
                       Buildings.Fluid.Interfaces.PartialTwoPortInterface<br/>
                       Buildings.Fluid.Interfaces.StaticFourPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger<br/>
                       Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume<br/>
                       Buildings.Fluid.Movers.BaseClasses.FlowControlled<br/>
                       Buildings.Fluid.Movers.BaseClasses.IdealSource<br/>
                       Buildings.Fluid.Movers.BaseClasses.PrescribedFlowMachine<br/>
    </td>
    <td valign=\"top\">Removed the computation of <code>V_flow</code> and removed the parameter
                       <code>show_V_flow</code>.
                       The reason is that the computation of <code>V_flow</code> required
                       the use of <code>sta_a</code> (to compute the density),
                       but <code>sta_a</code> is also a variable that is conditionally
                       enabled. However, this was not correct Modelica syntax as conditional variables
                       can only be used in a <code>connect</code>
                       statement, not in an assignment. Dymola 2014 FD01 beta3 is checking
                       for this incorrect syntax. Hence, <code>V_flow</code> was removed as its
                       conditional implementation would require a rather cumbersome implementation
                       that uses a new connector that carries the state of the medium.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes
    </td>
    <td valign=\"top\">Removed <code>Buildings.Fluid.MixingVolumes.MixingVolumeDryAir</code>
                       as this model is no longer used. The model
                       <code>Buildings.Fluid.MixingVolumes.MixingVolume</code>
                       can be used instead of.<br/>
                       Removed base class <code>Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</code>
                       as this model is no longer used.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.Examples.TraceSubstances
    </td>
    <td valign=\"top\">Renamed example from <code>ExtraProperty</code> to
                     <code>TraceSubstances</code> in order to use the same name
                     as the sensor.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.PrescribedExtraPropertyFlowRate
    </td>
    <td valign=\"top\">Renamed model to<code>TraceSubstancesFlowRate</code> to
                     use the same terminology than the Modelica Standard Library.<br/>
                     The conversion script updates existing models that instantiate
                     this model.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.Examples.PrescribedExtraPropertyFlow
    </td>
    <td valign=\"top\">Renamed example to<code>TraceSubstancesFlowRate</code>
                     in order to use the same name as the source model.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume<br/>
                       Buildings.Fluid.FixedResistances.Pipe<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitsSlab<br/>
                       Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab<br/>
                       Buildings.Fluid.Movers.BaseClasses.FlowControlled
    </td>
    <td valign=\"top\">Renamed <code>X_nominal</code> to <code>X_default</code>
                       or <code>X_start</code>, where <code>X</code> may be
                       <code>state</code>, <code>rho</code>, or <code>mu</code>,
                       depending on whether the medium default values or the start values
                       are used in the computation of the state
                       and derived quantities.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer<br/>
                         Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Interfaces.RadiosityInflow<br/>
                       Buildings.HeatTransfer.Interfaces.RadiosityOutflow<br/>
                       Buildings.HeatTransfer.Radiosity.BaseClasses.ParametersTwoSurfaces<br/>
                       Buildings.HeatTransfer.Radiosity.Constant<br/>
                       Buildings.HeatTransfer.Radiosity.Examples.OpaqueSurface<br/>
                       Buildings.HeatTransfer.Radiosity.Examples.OutdoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.IndoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.OpaqueSurface<br/>
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity<br/>
                       Buildings.HeatTransfer.Radiosity.RadiositySplitter<br/>
                       Buildings.HeatTransfer.Radiosity.package<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.CenterOfGlass<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.GlassLayer<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Examples.Shade<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.GlassLayer<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Shade<br/>
                       Buildings.HeatTransfer.Windows.Examples.BoundaryHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.ExteriorHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransfer<br/>
                       Buildings.Rooms.BaseClasses.InfraredRadiationExchange<br/>
                       Buildings.Rooms.BaseClasses.InfraredRadiationGainDistribution<br/>
                       Buildings.Rooms.BaseClasses.MixedAir<br/>
                       Buildings.Rooms.BaseClasses.Overhang<br/>
                       Buildings.Rooms.BaseClasses.SideFins
    </td>
    <td valign=\"top\">Changed the connectors for the radiosity model.
                       The previous implemenation declared the radiosity as a
                       <code>flow</code> variables, but the implementation did not use
                       a potential variable.<br/>
                       Therefore, the radiosity was the only variable in the connector,
                       which is not allowed for <code>flow</code> variables.
                       This change required a reformulation of models because with the new formulation,
                       the incoming and outcoming radiosity are both non-negative values.
                       This addresses issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer<br/>
                         Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.BaseClasses.PartialConvection<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.PartialWindowBoundaryCondition<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.Shade<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.ShadeConvection<br/>
                       Buildings.HeatTransfer.Windows.BaseClasses.ShadeRadiation<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransfer<br/>
                       Buildings.HeatTransfer.Windows.InteriorHeatTransferConvective<br/>
                       Buildings.Rooms.ExteriorBoundaryConditionsWithWindow<br/>
                       Buildings.Rooms.PartialSurfaceInterface<br/>
                       Buildings.Rooms.InfraredRadiationExchange<br/>
                       Buildings.Rooms.AirHeatMassBalanceMixed<br/>
                       Buildings.Rooms.SolarRadiationExchange<br/>
                       Buildings.Rooms.RadiationTemperature<br/>
                       Buildings.Rooms.InfraredRadiationGainDistribution
    </td>
    <td valign=\"top\">Redesigned the implementation of the room model and its base classes.
                       This redesign separates convection from radiation, and it provides
                       one composite model for the convection and the heat and mass balance in
                       the room. This change was done to allow an implementation of the room air
                       heat and mass balance that does not assume uniformly mixed room air.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Convection.Functions.HeatFlux.rayleigh
    </td>
    <td valign=\"top\">Renamed function from <code>raleigh</code> to <code>rayleigh</code>.
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
<tr><td valign=\"top\">Buildings.Fluid.Sensors.SpecificEntropyTwoPort
    </td>
    <td valign=\"top\">
           Corrected wrong computation of the dynamics used for the sensor signal.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear
    </td>
    <td valign=\"top\">
           Corrected the glass layer thickness, which was <i>5.7</i> mm instead of
           <i>3</i> mm, as the documentation states.
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
<tr><td colspan=\"2\"><b>Buildings</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.SkyTemperature.BlackBody<br/>
              Buildings.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature<br/>
              Buildings.BoundaryConditions.WeatherData.ReaderTMY3<br/>
              Buildings.Controls.SetPoints.HotWaterTemperatureReset<br/>
              Buildings.Examples.ChillerPlant.BaseClasses.Controls.ChillerSwitch<br/>
              Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl<br/>
              Buildings.Fluid.Boilers.BoilerPolynomial<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.HexElement<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange<br/>
              Buildings.Fluid.HeatExchangers.BaseClasses.MassExchangeDummy<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacity<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DXCooling<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetSelector<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Evaporation<br/>
              Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil<br/>
              Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort<br/>
              Buildings.Fluid.Sensors.RelativeTemperature<br/>
              Buildings.Fluid.Sensors.Temperature<br/>
              Buildings.Fluid.Sensors.TemperatureTwoPort<br/>
              Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort<br/>
              Buildings.Fluid.SolarCollectors.BaseClasses.PartialHeatLoss<br/>
              Buildings.Utilities.Comfort.Fanger<br/>
              Buildings.Utilities.IO.BCVTB.From_degC<br/>
              Buildings.Utilities.IO.BCVTB.To_degC<br/>
              Buildings.Utilities.Psychrometrics.TDewPoi_pW<br/>
              Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi<br/>
              Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi<br/>
              Buildings.Utilities.Psychrometrics.WetBul_pTX<br/>
              Buildings.Utilities.Psychrometrics.pW_TDewPoi
    </td>
    <td valign=\"top\">Replaced wrong attribute <code>quantity=\"Temperature\"</code>
                     with <code>quantity=\"ThermodynamicTemperature\"</code>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Fluid</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Data.Fuels.Generic
    </td>
    <td valign=\"top\">Corrected wrong type for <code>mCO2</code>.
                       It was declared as <code>Modelica.SIunits.MassFraction</code>,
                       which is incorrect.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.BaseClasses.Bounds
    </td>
    <td valign=\"top\">Corrected wrong type for <code>FRWat_min</code>, <code>FRWat_max</code>
                       and <code>liqGasRat_max</code>.
                       They were declared as <code>Modelica.SIunits.MassFraction</code>,
                       which is incorrect as, for example, <code>FRWat_max</code> can be larger than one.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.ConstantEffectiveness<br/>
                     Buildings.Fluid.MassExchangers.ConstantEffectiveness
    </td>
    <td valign=\"top\">Corrected error in the documentation that was not updated
                     when the implementation of zero flow rate was revised.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation
    </td>
    <td valign=\"top\">Corrected the syntax error
                       <code>Medium.ExtraProperty C[Medium.nC](each nominal=C_nominal)</code>
                       to
                       <code>Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)</code>
                       because <code>C_nominal</code> is a vector.
                       This syntax error caused a compilation error in OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.SensibleEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.LatentEnthalpyFlowRate<br/>
                       Buildings.Fluid.Sensors.MassFraction<br/>
                       Buildings.Fluid.Sensors.MassFractionTwoPort
    </td>
    <td valign=\"top\">Changed medium declaration in the <code>extends</code> statement
                       to <code>replaceable</code> to avoid a translation error in
                       OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sensors.TraceSubstances<br/>
                       Buildings.Fluid.Sensors.TraceSubstancesTwoPort
    </td>
    <td valign=\"top\">Corrected syntax errors in setting nominal value for output signal
                       and for state variable.
                       This eliminates a compilation error in OpenModelica.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Sources.TraceSubstancesFlowSource
    </td>
    <td valign=\"top\">Added missing <code>each</code> in declaration of
                       <code>C_in_internal</code>.
                       This eliminates a compilation error in OpenModelica.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities.Python27</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.IO.Python27.Functions.exchange
    </td>
    <td valign=\"top\">Corrected error in C code that lead to message
                       <code>'module' object has no attribute 'argv'</code>
                       when a python module accessed <code>sys.argv</code>.
    </td>
</tr>



</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Verify mass and species balance</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/165\">#165</a>
    </td>
    <td valign=\"top\">This issue has been addressed by renaming the connectors to avoid an ambiguity
                       in the model equation. The equations were correct.
    </td>
<tr><td colspan=\"2\"><b>Remove flow attribute from radiosity connectors</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>
    </td>
    <td valign=\"top\">This issue has been addressed by reformulating the radiosity models.
                       With the new implementation, incoming and outgoing radiosity are non-negative
                       quantities.
    </td>
</tr>
</table>
</html>"));
    end Version_1_5_build1;

  class Version_1_4_build1 "Version 1.4 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info",
     Documentation(info="<html>
<p>
Version 1.4 build 1 contains the new package <a href=\"modelica://Buildings.Utilities.IO.Python27\">
Buildings.Utilities.IO.Python27</a> that allows calling Python functions from Modelica.
It also contains in the package <a href=\"modelica://Buildings.HeatTransfer.Conduction.SingleLayer\">
Buildings.HeatTransfer.Conduction.SingleLayer</a>
a new model for heat conduction in phase change material. This model can be used as a layer
of the room heat transfer model.
</p>

<p>
Non-backward compatible changes had to be introduced
in the valve models
<a href=\"modelica://Buildings.Fluid.Actuators.Valves\">
Buildings.Fluid.Actuators.Valves</a> to fully comply with the Modelica language specification,
and in the models in the package
<a href=\"modelica://Buildings.Utilities.Diagnostics\">
Buildings.Utilities.Diagnostics</a>
as they used the <code>cardinality</code> function which is deprecated in the Modelica
Language Specification.
</p>

<p>
See below for details.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Utilities.IO.Python27
    </td>
    <td valign=\"top\">
         Package that contains blocks and functions that embed Python 2.7 in Modelica.
         Data can be sent to Python functions and received from Python functions.
         This allows for example data analysis in Python as part of a Modelica model,
         or data exchange as part of a hardware-in-the-loop simulation in which
         Python is used to communicate with hardware.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.BoundaryConditions.WeatherData</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath
    </td>
    <td valign=\"top\">This function is used by the weather data reader to set
                       the path to the weather file relative to the root directory
                       of the Buildings library.
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
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume
    </td>
    <td valign=\"top\">Removed the check of multiple connections to the same element
                       of a fluid port, as this check required the use of the deprecated
                       <code>cardinality</code> function.
    </td>
</tr><tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Conduction.SingleLayer
    </td>
    <td valign=\"top\">Added option to model layers with phase change material.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Rooms.BaseClasses.InfraredRadiationExchange
    </td>
    <td valign=\"top\">Removed the use of the <code>cardinality</code> function
                       as this function is deprecated in the Modelica Language Specification.
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
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves
    </td>
    <td valign=\"top\">All valves now require the declaration of <code>dp_nominal</code>
                       if the parameter assignment is
                       <code>CvData = Buildings.Fluid.Types.CvTypes.OpPoint</code>.
                       This change was needed because in the previous version,
                       <code>dp_nominal</code> had
                       a default value of <i>6000</i> Pascals. However, if
                       <code>CvData &gt;&lt; Buildings.Fluid.Types.CvTypes.OpPoint</code>, then
                       <code>dp_nominal</code> is computed in the initial algorithm section and hence
                       providing a default value is not allowed according to
                       the Modelica Language Specification.
                       Hence, it had to be removed.<br/>
                       As part of this change, we set <code>dp(nominal=6000)</code> for all valves,
                       because the earlier formulation uses a value that is not known during compilation,
                       and hence leads to an error in Dymola 2014.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.MixingVolumes.MixingVolumeDryAir<br/>
                       Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
    </td>
    <td valign=\"top\">Removed the use of the deprecated
                       <code>cardinality</code> function.
                       Therefore, now all input signals must be connected..
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Diagnostics.AssertEquality<br/>
                       Buildings.Utilities.Diagnostics.AssertInequality
    </td>
    <td valign=\"top\">Removed the option to not connect input signals, as this
                       required the use of the <code>cardinality</code> function which
                       is deprecated in the MSL, and not correctly implemented in OpenModelica.
                       Therefore, if using these models, both input signals must be connected.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Math.Functions.splineDerivatives
    </td>
    <td valign=\"top\">Removed the default value
                       <code>input Boolean ensureMonotonicity=isMonotonic(y, strict=false)</code>
                       as the Modelica language specification is not clear whether defaults can be computed
                       or must be constants.
    </td>
</tr></table>
<!-- Errors that have been fixed -->

<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>Buildings.Controls</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Controls.SetPoints.HotWaterTemperatureReset
    </td>
    <td valign=\"top\">Corrected error that led to wrong results if the room air temperature is
                     different from its nominal value <code>TRoo_nominal</code>.
                     This fixes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/74\">issue 74</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab<br/>
                     Buildings.Fluid.HeatExchangers.RadiantSlabs.ParallelCircuitSlab
    </td>
    <td valign=\"top\">Fixed bug in the assignment of the fictitious thermal resistance by replacing
                     <code>RFic[nSeg](each G=A/Rx)</code> with
                     <code>RFic[nSeg](each G=A/nSeg/Rx)</code>.
                     This fixes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/79\">issue 79</a>.
    </td>
</tr>

<tr><td colspan=\"2\"><b>Buildings.Utilities</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Utilities.Diagnostics.AssertEquality<br/>
                       Buildings.Utilities.Diagnostics.AssertInequality
    </td>
    <td valign=\"top\">Replaced <code>when</code> test with <code>if</code> test as
                       equations within a <code>when</code> section are only evaluated
                       when the condition becomes true.
                       This fixes <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/72\">issue 72</a>.
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
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear
    </td>
    <td valign=\"top\">The documenation was
                       <i>Fraction Kv(port_1->port_2)/Kv(port_3->port_2)</i> instead of
                       <i>Fraction Kv(port_3->port_2)/Kv(port_1->port_2)</i>.
                       Because the parameter set correctly its attributes
                       <code>min=0</code> and <code>max=1</code>,
                       instances of these models used the correct value.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Actuators.BaseClasses.ValveParameters
    </td>
    <td valign=\"top\">Removed stray backslash in write statement.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.Interfaces.ConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation<br/>
                       Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger
    </td>
    <td valign=\"top\">Removed wrong unit attribute of <code>COut</code>.
    </td>
</tr>
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.BaseClasses.HexElement
    </td>
    <td valign=\"top\">Changed the redeclaration of <code>vol2</code> to be replaceable,
                     as <code>vol2</code> is replaced in some models.
    </td>
</tr>
</table>
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Add explanation of nStaRef.</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/70\">&#35;70</a>
    </td>
    <td valign=\"top\">
    Described in
    <a href=\"modelica://Buildings.HeatTransfer.Data.Solids\">
    Buildings.HeatTransfer.Data.Solids</a>
    how the parameter <code>nStaRef</code> is used
    to compute the spatial grid that is used for simulating transient heat conduction.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Assert statement does not fire.</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/72\">&#35;72</a>
    </td>
    <td valign=\"top\">
    The blocks <code>Buildings.Utilities.Diagnostics.AssertEquality</code> and
    <code>Buildings.Utilities.Diagnostics.AssertInequality</code> did not fire because
    the test on the time was in a <code>when</code> instead of an <code>if</code> statement.
    This was wrong because <code>when</code> sections are only evaluated
    when the condition becomes true.
    </td>
</tr>
<tr><td colspan=\"2\"><b><code>HotWaterTemperatureReset</code> computes wrong results if room temperature differs from nominal value.</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/74\">&#35;74</a>
    </td>
    <td valign=\"top\">The equation
<pre>TSup = TRoo_in_internal
          + ((TSup_nominal+TRet_nominal)/2-TRoo_in_internal) * qRel^(1/m)
          + (TSup_nominal-TRet_nominal)/2 * qRel;</pre>
should be formulated as
<pre>TSup = TRoo_in_internal
          + ((TSup_nominal+TRet_nominal)/2-TRoo_nominal) * qRel^(1/m)
          + (TSup_nominal-TRet_nominal)/2 * qRel;</pre>
    </td>
</tr>
<tr><td colspan=\"2\"><b>Bug in <code>RadiantSlabs.SingleCircuitSlab</code> fictitious resistance RFic.</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/79\">&#35;79</a>
    </td>
    <td valign=\"top\">This bug has been fixed in the assignment of the fictitious thermal resistance by replacing
                     <code>RFic[nSeg](each G=A/Rx)</code> with
                     <code>RFic[nSeg](each G=A/nSeg/Rx)</code>.
                     The bug also affected <code>RadiantSlabs.ParallelCircuitSlab</code>.
    </td>
</tr>
</table>

<p>
Note:
</p>
<ul>
<li>
This version contains various updates that allow
the syntax of the example models to be checked in the pedantic mode
in Dymola 2014.
</li>
</ul>
</html>"));
  end Version_1_4_build1;

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
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DXCoils
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

  class Version_1_2_build1 "Version 1.2 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info", Documentation(info="<html>
<p>
In version 1.2 build 1, models for radiant slabs and window overhangs and sidefins have been added.
This version also contains various improvements to existing models.
A detailed list of changes is shown below.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
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
<!-- New components for existing libraries -->

<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.HeatTransfer</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.HeatTransfer.Windows.FixedShade<br/>
                       Buildings.HeatTransfer.Windows.Overhang<br/>
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
                       Buildings.Media.Air<br/>
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
<!-- Non-backward compatbile changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
<!-- Github issues -->
<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Heat transfer in glass layer</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/56\">&#35;56</a>
    </td>
    <td valign=\"top\">Fixed bug in heat flow through the glass layer if the infrared transmissivity is non-zero.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/57\">&#35;57</a>
    </td>
    <td valign=\"top\">Fixed bug in temperature linearization of window glass.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Overshooting in enhanced stratified tank</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/15\">&#35;15</a>
    </td>
    <td valign=\"top\">Revised the implementation to reduce the temperature over-shoot.
    </td>
</tr>
</table>
</html>"));
  end Version_1_2_build1;

  class Version_1_1_build1 "Version 1.1 build 1"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info", Documentation(info="<html>
<p>
Version 1.1 build 1 contains improvements to models that address numerical problems.
In particular, flow machines and actuators now have an optional filter
that converts step changes in the input signal to a smooth change in
speed or actuator position.
Also, (<a href=\"modelica://Buildings.Examples.Tutorial\">
Buildings.Examples.Tutorial</a>)
has been added to provide step-by-step instruction for how to build
system models.
<!-- New libraries -->
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Examples.Tutorial
    </td>
    <td valign=\"top\">Tutorial with step by step instructions for how to
                       build system models.
    </td>
    </tr>
</table>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Dampers.Exponential<br/>
                       Buildings.Fluid.Actuators.Dampers.VAVBoxExponential<br/>
                       Buildings.Fluid.Actuators.Dampers.MixingBox<br/>
                       Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening
    </td>
    <td valign=\"top\">Added an optional 2nd order lowpass filter for the input signal.
                       The filter approximates the travel time of the actuators.
                       It also makes the system of equations easier to solve
                       because a step change in the input signal causes a gradual change in the actuator
                       position.<br/>
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
<tr><td valign=\"top\">Buildings.Fluid.Movers.SpeedControlled_y<br/>
                       Buildings.Fluid.Movers.SpeedControlled_Nrpm<br/>
                       Buildings.Fluid.Movers.FlowControlled_dp<br/>
                       Buildings.Fluid.Movers.FlowControlled_m_flow
    </td>
    <td valign=\"top\">Added a 2nd order lowpass filter to the input signal.
                       The filter approximates the startup and shutdown transients of fans or pumps.
                       It also makes the system of equations easier to solve
                       because a step change in the input signal causes a gradual change in the
                       mass flow rate.<br/>
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
<tr><td valign=\"top\">Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear<br/>
                       Buildings.Fluid.Actuators.Valves.ThreeWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayLinear<br/>
                       Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening
    </td>
    <td valign=\"top\">Changed models to allow modeling of a fixed resistance that is
                       within the controlled flow leg. This allows in some cases
                       to avoid a nonlinear equation if a flow resistance is
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
<tr><td valign=\"top\">Buildings.HeatTransfer.Radiosity.OutdoorRadiosity<br/>
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
<!-- Errors that have been fixed -->

<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.DryCoilCounterFlow<br/>
                       Buildings.Fluid.HeatExchangers.WetCoilCounterFlow
    </td>
    <td valign=\"top\">Corrected error in assignment of <code>dp2_nominal</code>.
                       The previous assignment caused a pressure drop in all except one element,
                       instead of the opposite. This caused too high a flow resistance
                       of the heat exchanger.
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
<!-- Github issues -->

<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Exterior longwave radiation exchange in window model</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/51\">&#35;51</a>
    </td>
    <td valign=\"top\">Changed model to use new implementation of
                       Buildings.HeatTransfer.Radiosity.OutdoorRadiosity.
                       This change leads to the use of the same equations for the radiative
                       heat transfer between window and ambient as is used for
                       the opaque constructions.
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/53\">&#35;53</a>
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
</html>"));
  end Version_1_1_build1;

  class Version_1_0_build2 "Version 1.0 build 2"
    extends Modelica.Icons.ReleaseNotes;
     annotation (preferredView="info", Documentation(info="<html>
<p>
Version 1.0 build 2 has been released to correct model errors that
were present in version 1.0 build 1. Both versions are compatible.
In addition, version 1.0 build 2 contains improved documentation
of various example models.
<!-- New libraries -->
<!-- New components for existing libraries -->
<!-- Backward compatible changes -->
</p>

<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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

<!-- Non-backward compatbile changes to existing components -->
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">

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
<!-- Uncritical errors -->
<!-- Github issues -->

<p>
The following
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues\">issues</a>
have been fixed:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>Buildings.Fluid.HeatExchangers.Boreholes</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/45\">&#35;45</a>
    </td>
    <td valign=\"top\">Dymola 2012 FD01 hangs when simulating a borehole heat exchanger.
    This was caused by a wrong release of memory in <code>freeArray.c</code>.
    </td>
</tr>
<tr><td colspan=\"2\"><b>Buildings.Rooms</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://github.com/lbl-srg/modelica-buildings/issues/46\">&#35;46</a>
    </td>
    <td valign=\"top\">The convective internal heat gain has the wrong sign.
    </td>
</tr>

</table>
</html>"));
  end Version_1_0_build2;

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
<a href=\"modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos\">
Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos</a> can help
in converting old models to this version of the library.
</p>
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\">Buildings.Fluid.HeatExchangers.Boreholes</td>
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
<tr><td valign=\"top\">Buildings.Utilities.Reports.Printer<br/>
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

<tr><td colspan=\"2\"><b>Buildings.Rooms</b></td></tr>
<tr><td valign=\"top\">Buildings.Rooms.MixedAir<br/>
                     Buildings.Rooms.BaseClasses.ExteriorBoundaryConditions</td>
    <td valign=\"top\">Fixed bug (<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/35\">issue 35</a>)
                     that leads to the wrong solar heat gain for
                     roofs and for floors. Prior to this bug fix, the outside facing surface
                     of a ceiling received solar irradiation as if it were a floor
                     and vice versa.</td></tr>
<tr><td valign=\"top\">Buildings.Rooms.MixedAir<br/>
                     Buildings.Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow</td>
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

<tr><td colspan=\"2\"><b>Buildings.Rooms</b></td></tr>
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
</html>"));
  end Version_1_0_build1;

  class Version_0_12_0 "Version 0.12.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info="<html>
<p>
<b>Note:</b> The packages whose name ends with <code>Beta</code>
are still being validated.
</p>
<p>
The following <b style=\"color:red\">critical error</b> has been fixed (i.e. error
that can lead to wrong simulation results):
</p>

<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
</html>"));
  end Version_0_12_0;

  class Version_0_11_0 "Version 0.11.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info="<html>
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
</html>"));
  end Version_0_11_0;

  class Version_0_10_0 "Version 0.10.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info=
                   "<html>
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
In model <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>,
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
</html>"));
  end Version_0_10_0;

  class Version_0_9_1 "Version 0.9.1"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info="<html>
<p>
The following <b style=\"color:red\">critical error</b> has been fixed (i.e. error
that can lead to wrong simulation results):
</p>

<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
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
      Buildings.Fluid.Storage.Stratified</a> was not affected.<br/>
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
</html>"));
  end Version_0_9_1;

  class Version_0_9_0 "Version 0.9.0"
    extends Modelica.Icons.ReleaseNotes;
  annotation (preferredView="info", Documentation(info=
                   "<html>
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
<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">
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
</html>"));
  end Version_0_9_0;

  class Version_0_8_0 "Version 0.8.0"
    extends Modelica.Icons.ReleaseNotes;
              annotation (preferredView="info", Documentation(info=
                   "<html>
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
<a href=\"modelica://Buildings.Media.Air\">
Buildings.Media.Air</a>,
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
<a href=\"modelica://Buildings.Media.Air.enthalpyOfNonCondensingGas\">
Buildings.Media.Air.enthalpyOfNonCondensingGas</a> and its derivative.
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
<a href=\"modelica://Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a>. This is currently needed since
<a href=\"modelica://Modelica.Math.Matrices.solve\">
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
</html>"));
  end Version_0_8_0;

  class Version_0_7_0 "Version 0.7.0"
    extends Modelica.Icons.ReleaseNotes;
              annotation (preferredView="info", Documentation(info=
                   "<html>
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
</html>"));
  end Version_0_7_0;

  class Version_0_6_0 "Version 0.6.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
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
<a href=\"modelica://Buildings.Fluid.BaseClasses.PartialResistance\">
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
</html>"));
  end Version_0_6_0;

  class Version_0_5_0 "Version 0.5.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
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
</html>"));
  end Version_0_5_0;

  class Version_0_4_0 "Version 0.4.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
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
</html>"));
  end Version_0_4_0;

  class Version_0_3_0 "Version 0.3.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
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
<br/>
In addition, this package now contains a bug fix that is needed for Modelica 2.2.1 and 2.2.2.
The bugs are fixed by using a new
base class
<a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleIdealGasMedium\">
Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</a>
 (that fixes the bugs) instead of
<a href=\"modelica://Modelica.Media.Interfaces.PartialSimpleIdealGasMedium\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</a>.
In the original implementation, initial states of fluid volumes can be far away from
the steady-state value because of an inconsistent implementation of the enthalpy
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
</html>"));
  end Version_0_3_0;

  class Version_0_2_0 "Version 0.2.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info=
                   "<html>
<p>
New in this version are models for two and three way valves.
In addition, the <code>Fluids</code> package has been slightly revised.
The package <code>Fluid.BaseClasses</code> has been added because in
the previous version, partial models for fixed resistances
where part of the <code>Actuator</code> package.
</p>
</html>"));
  end Version_0_2_0;

  class Version_0_1_0 "Version 0.1.0"
    extends Modelica.Icons.ReleaseNotes;
      annotation (preferredView="info", Documentation(info="<html>
<p>
First release of the library.
</p>
<p>
This version contains basic models for modeling building HVAC systems.
It also contains new medium models in the package
<a href=\"modelica://Buildings.Media\">Buildings.Media</a>. These medium models
have simpler property functions than the ones from
<a href=\"modelica://Modelica.Media\">Modelica.Media</a>. For example,
there is medium model with constant heat capacity which is often sufficiently
accurate for building HVAC simulation, in contrast to the more detailed models
from <a href=\"modelica://Modelica.Media\">Modelica.Media</a> that are valid in
a larger temperature range, at the expense of introducing non-linearities due
to the medium properties.
</p>
</html>"));
  end Version_0_1_0;

    annotation (preferredView="info",
    Documentation(info="<html>
<p>
This section summarizes the changes that have been performed
on the Buildings library.
</p>
<ul>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_3_0_0\">Version 3.0.0</a> (xxx, 2015)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_2_1_0\">Version 2.1.0</a> (July 13, 2015)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_2_0_0\">Version 2.0.0</a> (May 4, 2015)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_6_build1\">Version 1.6 build1</a> (June 19, 2014)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_5_build3\">Version 1.5 build3</a> (February 12, 2014)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_5_build2\">Version 1.5 build2</a> (December 13, 2013)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_5_build1\">Version 1.5 build1</a> (October 24, 2013)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_4_build1\">Version 1.4 build1</a> (May 15, 2013)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_3_build1\">Version 1.3 build1</a> (January 8, 2013)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_2_build1\">Version 1.2 build1</a> (July 26, 2012)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_1_build1\">Version 1.1 build1</a> (February 29, 2012)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_0_build2\">Version 1.0 build2</a> (December 8, 2011)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_1_0_build1\">Version 1.0 build1</a> (November 4, 2011)
</li>
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_12_0\">Version 0.12.0 </a> (May 6, 2011)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_11_0\">Version 0.11.0 </a> (March 17, 2011)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_10_0\">Version 0.10.0 </a> (July 30, 2010)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_9_1\">Version 0.9.1 </a> (June 24, 2010)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_9_0\">Version 0.9.0 </a> (June 11, 2010)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_8_0\">Version 0.8.0 </a> (February 6, 2010)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_7_0\">Version 0.7.0 </a> (September 29, 2009)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_6_0\">Version 0.6.0 </a> (May 15, 2009)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_5_0\">Version 0.5.0 </a> (February 19, 2009)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_4_0\">Version 0.4.0 </a> (October 31, 2008)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_3_0\">Version 0.3.0 </a> (September 30, 2008)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_2_0\">Version 0.2.0 </a> (June 17, 2008)
<li>
<a href=\"modelica://Buildings.UsersGuide.ReleaseNotes.Version_0_1_0\">Version 0.1.0 </a> (May 27, 2008)
</li>
</ul>

</html>"));
  end ReleaseNotes;

  class Contact "Contact"
    extends Modelica.Icons.Contact;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4><font color=\"#008000\" size=\"5\">Contact</font></h4>
<p>
The development of the Buildings library is organized by<br/>
<a href=\"http://simulationresearch.lbl.gov/wetter\">Michael Wetter</a><br/>
    Lawrence Berkeley National Laboratory (LBNL)<br/>
    One Cyclotron Road<br/>
    Bldg. 90-3147<br/>
    Berkeley, CA 94720<br/>
    USA<br/>
    email: <a href=\"mailto:MWetter@lbl.gov\">MWetter@lbl.gov</a><br/>
</p>
</html>"));
  end Contact;

  class Acknowledgements "Acknowledgements"
    extends Modelica.Icons.Information;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4><font color=\"#008000\" size=\"5\">Acknowledgements</font></h4>
<p>
 The development of this library was supported
</p>
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
<p>
The core of this library is the Annex 60 library,
a free open-source library with basic models that codify best practices for
the implementation of models for building and community energy and control systems.
The Annex 60 library is developed at
<a href=\"https://github.com/iea-annex60/modelica-annex60\">
https://github.com/iea-annex60/modelica-annex60</a>
within the Annex 60 project
(<a href=\"http://www.iea-annex60.org\">http://www.iea-annex60.org</a>)
of the International Energy Agency's
<a href=\"http://www.iea-ebc.org/\">Energy in Buildings and Communities</a> Programme.
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
</p>
<ul>
<li>Marco Bonvini, Lawrence Berkeley National Laboratory, USA
</li>
<li>Rainer Czetina, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Sebastian Giglmayr, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Peter Grant, Lawrence Berkeley National Laboratory, USA
</li>
<li>Brandon M. Hencey, Cornell University, USA
</li>
<li>Roman Ilk, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Dan Li, University of Miami, Florida, USA
</li>
<li>Filip Mathadon, KU Leuven, Belgium
</li>
<li>Thierry S. Nouidui, Lawrence Berkeley National Laboratory, USA
</li>
<li>Markus Nurschinger, University of Applied Sciences Technikum Wien, Austria
</li>
<li>Xiufeng Pang, Lawrence Berkeley National Laboratory, USA
</li>
<li>Damien Picard, KU Leuven, Belgium
</li>
<li>Kaustubh Phalak, Lawrence Berkeley National Laboratory, USA
</li>
<li>Thomas Sevilla, University of Miami, Florida, USA
</li>
<li>Martin Sj&ouml;lund, Link&ouml;ping University, Sweden
</li>
<li>Matthis Thorade, Berlin University of the Arts, Germany
</li>
<li>Wei Tian, University of Miami, Florida, USA
</li>
<li>Armin Teskeredzic, Mechanical Engineering Faculty Sarajevo and GIZ, Bosnia and Herzegovina
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
<li>Wangda Zuo, University of Miami, Florida, USA
</li>
</ul>
</html>"));
  end Acknowledgements;

  class License "Modelica License 2"
    extends Modelica.Icons.Information;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4><font color=\"#008000\" size=\"5\">The Modelica License 2</font></h4>
<p>
<strong>Preamble.</strong> The goal of this license is that Modelica related model libraries, software, images, documents, data files etc. can be used freely in the original or a modified form, in open source and in commercial environments (as long as the license conditions below are fulfilled, in particular sections 2c) and 2d). The Original Work is provided free of charge and the use is completely at your own risk. Developers of free Modelica packages are encouraged to utilize this license for their work.
</p>
<p>
The Modelica License applies to any Original Work that contains the following licensing notice adjacent to the copyright notice(s) for this Original Work:
</p>
<p>
<strong>Note.</strong> This is the standard Modelica License 2, except for the following changes: the parenthetical in paragraph 7., paragraph 5., and the addition of paragraph 15.d).
</p>
<p>
<strong>Licensed by The Regents of the University of California, through Lawrence Berkeley National Laboratory under the Modelica License 2 </strong>
</p>

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
</p>
<ol type=\"a\">
<li>
To reproduce the Original Work in copies, either alone or as part of a collection.
</li><li>
To create Derivative Works according to Section 1d) of this License.
</li><li>
To distribute or communicate to the public copies of the <u>Original Work</u> or a <u>Derivative Work</u> under <u>this License</u>. No fee, neither as a copyright-license fee, nor as a selling fee for the copy as such may be charged under this License. Furthermore, a verbatim copy of this License must be included in any copy of the Original Work or a Derivative Work under this License.
<br/>
For the matter of clarity, it is permitted A) to distribute or communicate such copies as part of a (possible commercial) collection where other parts are provided under different licenses and a license fee is charged for the other parts only and B) to charge for mere printing and shipping costs.
</li><li>
To distribute or communicate to the public copies of a <u>Derivative Work</u>, alternatively to Section 2c), under <u>any other license</u> of your choice, especially also under a license for commercial/proprietary software, as long as You comply with Sections 3, 4 and 8 below.
<br/>
For the matter of clarity, no restrictions regarding fees, either as to a copyright-license fee or as to a selling fee for the copy as such apply.
</li><li>
To perform the Original Work publicly.
</li><li>
To display the Original Work publicly.
</li></ol>

<h4>3. Acceptance</h4>
<p>
Any use of the Original Work or a Derivative Work, or any action according to either Section 2a) to 2f) above constitutes Your acceptance of this License.
</p>

<h4>4. Designation of Derivative Works and of Modified Works</h4>
<p>
The identifying designation of Derivative Work and of Modified Work must be different to the corresponding identifying designation of the Original Work. This means especially that the (root-level) name of a Modelica package under this license must be changed if the package is modified (besides fixing of errors, adding vendor specific Modelica annotations, using a subset of the classes of a Modelica package, or using another representation, e.g. a binary representation).
</p>

<h4>5. [reserved]</h4>
<h4>6. Provision of Source Code</h4>
<p>
Licensor agrees to provide You with a copy of the Source Code of the Original Work but reserves the right to decide freely on the manner of how the Original Work is provided. For the matter of clarity, Licensor might provide only a binary representation of the Original Work. In that case, You may (a) either reproduce the Source Code from the binary representation if this is possible (e.g., by performing a copy of an encrypted Modelica package, if encryption allows the copy operation) or (b) request the Source Code from the Licensor who will provide it to You.
</p>

<h4>7. Exclusions from License Grant</h4>
<p>
Neither the names of Licensor (including, but not limited to, University of California, Lawrence Berkeley National Laboratory, U.S. Dept. of Energy, UC, LBNL, LBL, and DOE), nor the names of any contributors to the Original Work, nor any of their trademarks or service marks, may be used to endorse or promote products derived from this Original Work without express prior permission of the Licensor. Except as otherwise expressly stated in this License and in particular in Sections 2 and 5, nothing in this License grants any license to Licensor's trademarks, copyrights, patents, trade secrets or any other intellectual property, and no patent license is granted to make, use, sell, offer for sale, have made, or import embodiments of any patent claims.
No license is granted to the trademarks of Licensor even if such trademarks are included in the Original Work, except as expressly stated in this License. Nothing in this License shall be interpreted to prohibit Licensor from licensing under terms different from this License any Original Work that Licensor otherwise would have a right to license.
</p>

<h4>8. Attribution Rights</h4>
<p>
You must retain in the Source Code of the Original Work and of any Derivative Works that You create, all author, copyright, patent, or trademark notices, as well as any descriptive text identified therein as an \"Attribution Notice\". The same applies to the licensing notice of this License in the Original Work. For the matter of clarity, \"author notice\" means the notice that identifies the original author(s).
</p>
<p>
You must cause the Source Code for any Derivative Works that You create to carry a prominent Attribution Notice reasonably calculated to inform recipients that You have modified the Original Work.
</p>
<p>
In case the Original Work or Derivative Work is not provided in Source Code, the Attribution Notices shall be appropriately displayed, e.g., in the documentation of the Derivative Work.
</p>

<h4>9. Disclaimer of Warranty</h4>
<p>
<u><strong>The Original Work is provided under this License on an \"as is\" basis and without warranty, either express or implied, including, without limitation, the warranties of non-infringement, merchantability or fitness for a particular purpose. The entire risk as to the quality of the Original Work is with You.</strong></u> This disclaimer of warranty constitutes an essential part of this License. No license to the Original Work is granted by this License except under this disclaimer.
</p>

<h4>10. Limitation of Liability</h4>
<p>
Under no circumstances and under no legal theory, whether in tort (including negligence), contract, or otherwise, shall the Licensor, the owner or a licensee of the Original Work be liable to anyone for any direct, indirect, general, special, incidental, or consequential damages of any character arising as a result of this License or the use of the Original Work including, without limitation, damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses. This limitation of liability shall not apply to the extent applicable law prohibits such limitation.
</p>

<h4>11. Termination</h4>
<p>
This License conditions your rights to undertake the activities listed in Section 2 and 5, including your right to create Derivative Works based upon the Original Work, and doing so without observing these terms and conditions is prohibited by copyright law and international treaty. Nothing in this License is intended to affect copyright exceptions and limitations. This License shall terminate immediately and You may no longer exercise any of the rights granted to You by this License upon your failure to observe the conditions of this license.
</p>

<h4>12. Termination for Patent Action</h4>
<p>
This License shall terminate automatically and You may no longer exercise any of the rights granted to You by this License as of the date You commence an action, including a cross-claim or counterclaim, against Licensor, any owners of the Original Work or any licensee alleging that the Original Work infringes a patent. This termination provision shall not apply for an action alleging patent infringement through combinations of the Original Work under combination with other software or hardware.
</p>

<h4>13. Jurisdiction</h4>
<p>
Any action or suit relating to this License may be brought only in the courts of a jurisdiction wherein the Licensor resides and under the laws of that jurisdiction excluding its conflict-of-law provisions. The application of the United Nations Convention on Contracts for the International Sale of Goods is expressly excluded. Any use of the Original Work outside the scope of this License or after its termination shall be subject to the requirements and penalties of copyright or patent law in the appropriate jurisdiction. This section shall survive the termination of this License.
</p>

<h4>14. Attorneys' Fees</h4>
<p>
In any action to enforce the terms of this License or seeking damages relating thereto, the prevailing party shall be entitled to recover its costs and expenses, including, without limitation, reasonable attorneys' fees and costs incurred in connection with such action, including any appeal of such action. This section shall survive the termination of this License.
</p>

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

<h4>How to Apply the Modelica License 2</h4>
<p>
At the top level of your Modelica package and at every important subpackage, add the following notices in the info layer of the package:
</p>
<ul><li style=\"list-style-type:none\">
Licensed by The Regents of the University of California, through Lawrence Berkeley National Laboratory under the Modelica License 2 Copyright (c) 2009-2015, The Regents of the University of California, through Lawrence Berkeley National Laboratory.
</li>
<li style=\"list-style-type:none\"><i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) here or at <a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html</a>.
</i></li></ul>

<p>
Include a copy of the Modelica License 2 under <strong>&lt;library&gt;.UsersGuide.ModelicaLicense2</strong>
(use <a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.mo\">
http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.mo</a>)
Furthermore, add the list of authors and contributors under
<strong>&lt;library&gt;.UsersGuide.Contributors</strong> or <strong>&lt;library&gt;.UsersGuide.Contact</strong>
</p>
<p>
For example, sublibrary Modelica.Blocks of the Modelica Standard Library may have the following notices:</p>
<ul><li style=\"list-style-type:none\">
Licensed by Modelica Association under the Modelica License 2 Copyright (c) 1998-2008, Modelica Association.
<li style=\"list-style-type:none\"><i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) here or at
<a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html</a>.
</i>
</li></ul>

<p>For C-source code and documents, add similar notices in the corresponding file.</p>
<p>
For images, add a \"readme.txt\" file to the directories where the images are stored and include a similar notice in this file.
</p>

<p>
In these cases, save a copy of the Modelica License 2 in one directory of the distribution, e.g.,
<a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2-standalone.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2-standalone.html</a> in directory <strong>&lt;library&gt;/help/documentation/ModelicaLicense2.html</strong>.
</p>

</html>"));
  end License;

  class Copyright "Copyright"
    extends Modelica.Icons.Information;
    annotation (preferredView="info",
    Documentation(info="<html>
<h4><font color=\"#008000\" size=\"5\">Copyright</font></h4>
<p>
Copyright (c) 2009-2015, The Regents of the University of California, through Lawrence Berkeley National Laboratory (subject to receipt of any required approvals from the U.S. Dept. of Energy). All rights reserved.
</p>
<p>
If you have questions about your rights to use or distribute this software, please contact Berkeley Lab's Technology Transfer Department at
<a href=\"mailto:TTD@lbl.gov\">TTD@lbl.gov</a>
</p>
<p>
NOTICE. This software was developed under partial funding from the U.S. Department of Energy. As such, the U.S. Government has been granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, and perform publicly and display publicly. Beginning five (5) years after the date permission to assert copyright is obtained from the U.S. Department of Energy, and subject to any subsequent five (5) year renewals, the U.S. Government is granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, distribute copies to the public, perform publicly and display publicly, and to permit others to do so.
</p>
</html>"));
  end Copyright;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free open-source library for modeling of building energy and control systems.
Many models are based on models from the package
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a> and use
the same ports to ensure compatibility with models from that library.
</p>
<p>
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
General information about the use of the <code>Buildings</code> library
is available at
<a href=\"http://simulationresearch.lbl.gov/modelica/userGuide\">
http://simulationresearch.lbl.gov/modelica/userGuide</a>.
This web site covers general information that is not specific to the
use of individual packages or models.
Discussed topics include
how to get started, best practices, how to post-process results using Python,
work-around for problems and how to develop models.<br/>
</li>
<li>
Some of packages have their own
User's Guides that can be accessed by the links below.
These User's Guides are explaining items that are specific to the
particular package.<br/>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Airflow.Multizone.UsersGuide\">Airflow.Multizone</a>
   </td>
   <td valign=\"top\">Package for multizone airflow and contaminant transport.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">BoundaryConditions</a>
   </td>
   <td valign=\"top\">Package for computing boundary conditions, such as solar irradiation.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.UsersGuide\">Fluid</a>
   </td>
   <td valign=\"top\">Package for one-dimensional fluid in piping networks with heat exchangers, valves, etc.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">Fluid.Actuators</a>
   </td>
   <td valign=\"top\">Package with valves and air dampers.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">Fluid.FMI</a>
   </td>
   <td valign=\"top\">Package with blocks to export thermofluid flow models as Functional Mockup Units.</td>
</tr><tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">Fluid.HeatExchangers.DXCoils</a>
   </td>
   <td valign=\"top\">Package with direct evaporative cooling coils.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.UsersGuide\">Fluid.HeatExchangers.RadiantSlabs</a>
   </td>
   <td valign=\"top\">Package with radiant slabs.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Fluid.Movers</a>
   </td>
   <td valign=\"top\">Package with fans and pumps.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">Fluid.Sensors</a>
   </td>
   <td valign=\"top\">Package with sensors.</td>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Storage.UsersGuide\">Fluid.Storage</a>
   </td>
   <td valign=\"top\">Package with storage tanks and an expansion vessel.</td>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.SolarCollectors.UsersGuide\">Fluid.SolarCollectors</a>
   </td>
   <td valign=\"top\">Package with solar collectors.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Interfaces.UsersGuide\">Fluid.Interfaces</a>
   </td>
   <td valign=\"top\">Base models that can be used by developers to implement new models.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.HeatTransfer.UsersGuide\">HeatTransfer</a>
   </td>
   <td valign=\"top\">Package for heat transfer in building constructions.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Rooms.UsersGuide.MixedAir\">Rooms.MixedAir</a>
   </td>
   <td valign=\"top\">Package for heat transfer in rooms and through the building envelope with the
                      room air being modeled using the mixed air assumption.</td>
</tr>
<tr><td valign=\"top\"><a href=\"modelica://Buildings.Rooms.UsersGuide.MixedAir\">Rooms.CFD</a>
   </td>
   <td valign=\"top\">Package for heat transfer in rooms and through the building envelope with the
                      room air being modeled using computational fluid dynamics.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.Rooms.Examples.FFD.UsersGuide\">Rooms.Examples.FFD</a>
   </td>
   <td valign=\"top\">Package with examples that use the Fast Fluid Dynamics program for
                      the computational fluid dynamics.</td>
</tr>

<tr><td valign=\"top\"><a href=\"modelica://Buildings.Utilities.IO.Python27.UsersGuide\">Utilities.IO.Python27</a>
   </td>
   <td valign=\"top\">Package to call Python functions from Modelica.</td>
</tr></table><br/>
</li>
<li>
There is also a tutorial available at
<a href=\"modelica://Buildings.Examples.Tutorial\">
Buildings.Examples.Tutorial</a>.
The tutorial contains step by step instructions for how to build system models.
</li>
</ol>
</html>"));
end UsersGuide;


annotation (
preferredView="info",
version="3.0.0",
versionDate="2015-07-13",
dateModified = "2015-07-13",
uses(Modelica(version="3.2.1"),
     Modelica_StateGraph2(version="2.0.2")),
conversion(
 from(version={"2.0.0", "2.1.0"},
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_2.1_to_3.0.mos")),
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
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/UsersGuide/HydronicHeating.png\" border=\"1\"/>
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>,
and the development page is
<a href=\"https://github.com/lbl-srg/modelica-buildings\">https://github.com/lbl-srg/modelica-buildings</a>.
Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Buildings;
