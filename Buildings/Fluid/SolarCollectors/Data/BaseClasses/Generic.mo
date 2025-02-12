within Buildings.Fluid.SolarCollectors.Data.BaseClasses;
record Generic
  "Generic data record providing common inputs for ASHRAE93 and EN12975 solar collector models"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Area A "Area";
  parameter Buildings.Fluid.SolarCollectors.Types.HeatCapacity CTyp
    "Total thermal capacity or fluid volume and 'dry' thermal capacity or mass";
  parameter Modelica.Units.SI.HeatCapacity C
    "Dry or total thermal capacity of the solar thermal collector";
  parameter Modelica.Units.SI.Volume V "Fluid volume ";
  parameter Modelica.Units.SI.Mass mDry "Dry mass";
  parameter Real mperA_flow_nominal(final unit="kg/(s.m2)")
    "Nominal mass flow rate per unit area of collector";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Nominal pressure drop";
  parameter Modelica.Units.SI.Angle[:] incAngDat=Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,80,90})
    "Incident angle data";
  parameter Real[size(incAngDat,1)] incAngModDat(
    each final min=0,
    each final unit="1")
    "Incident angle modifier data";

  final parameter Boolean validated = validateAngles(
    incAngDat=incAngDat,
    incAngModDat=incAngModDat)
    "True if data are valid, otherwise an assertion is issued";

annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info="<html>
<p>
Partial record containing common performance parameters for ASHRAE93 and EN12975
solar collector models.
</p>
<p>
Depending on the data source that is used, different parameters are available to
model the thermal capacity of the solar collector.
The choice of CTyp determines which parameters are used to calculate the
representative heat capacity of the entire solar collector (including fluid).
When the dry mass of the solar collector is used to calculate the heat capacity,
the collector is assumed to be made fully out of copper
(specific heat capacity of <i>385 J/kg/K</i>).
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>CTyp</th>
<th> C </th>
<th> V </th>
<th> mDry </th>
</tr>
<tr>
<td> TotalCapacity </td>
<td> CTot </td>
<td> / </td>
<td> / </td>
</tr>
<tr>
<td> DryCapacity </td>
<td> CDry </td>
<td> V </td>
<td> / </td>
</tr>
<tr>
<td> DryMass </td>
<td> / </td>
<td> V </td>
<td> mDry </td>
</tr>
</table>
</html>", revisions="<html>
<ul>
<li>
February 28, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
January 4, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
