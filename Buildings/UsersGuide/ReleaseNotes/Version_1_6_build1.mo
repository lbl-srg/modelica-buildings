within Buildings.UsersGuide.ReleaseNotes;
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
<a href=\"https://github.com/ibpsa/modelica\">
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
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes.UTube
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
<tr><td valign=\"top\">Buildings.Fluid.Geothermal.Boreholes.BaseClasses.HexInternalElement
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

    </tr>    <tr><td valign=\"top\">Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWall<br/>
                           Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallWithWindow<br/>
                           Buildings.ThermalZones.Detailed.Constructions.Examples.ExteriorWallTwoWindows
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
The followings
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
