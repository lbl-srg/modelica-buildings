within Buildings.UsersGuide.ReleaseNotes;
class Version_1_4_build1 "Version 1.4 build 1"
  extends Modelica.Icons.ReleaseNotes;
   annotation (preferredView="info",
   Documentation(info="<html>
<p>
Version 1.4 build 1 contains the new package <code>Buildings.Utilities.IO.Python27</code>
that allows calling Python functions from Modelica.
It also contains in the package <code>Buildings.HeatTransfer.Conduction.SingleLayer</code>
a new model for heat conduction in phase change material. This model can be used as a layer
of the room heat transfer model.
</p>

<p>
Non-backward compatible changes had to be introduced
in the valve models
<code>Buildings.Fluid.Actuators.Valves</code> to fully comply with the Modelica
language specification, and in the models in the package
<code>Buildings.Utilities.Diagnostics</code>
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
<tr><td colspan=\"2\"><b>Buildings.ThermalZones</b>
    </td>
</tr>
<tr><td valign=\"top\">Buildings.ThermalZones.Detailed.BaseClasses.InfraredRadiationExchange
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
                       Therefore, now all input signals must be connected.
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
                       <i>Fraction Kv(port_1 &rarr; port_2)/Kv(port_3 &rarr; port_2)</i> instead of
                       <i>Fraction Kv(port_3 &rarr; port_2)/Kv(port_1 &rarr; port_2)</i>.
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
    <code>Buildings.HeatTransfer.Data.Solids</code>
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
