within Buildings.Fluid.SolarCollectors;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation(preferredView="info",
  Documentation(info="<html>
<p>
This package contains models for solar thermal systems.
Top-level models are available for solar thermal collectors based on the
ASHRAE93 (American) and EN12975 (European) test protocols.
The two models use different models for solar gain, heat loss, and use
different data packages.
The model applied to (un)glazed flat-plate solar thermal collectors, as well as
evacuated tube collectors.
</p>

<h4>Model description</h4>
<p>
The solar thermal collector model is developed based on the
flat-plate solar thermal collector model of EnergyPlus.
The model determines the solar heat gain and heat loss of the collector
seperately, and the difference of both is transferred to the collector.
The ASHRAE93 and EN12975 collector model calculate the heat gain and heat loss
differently.
The details of these calculations can be found in
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses\">
Buildings.Fluid.SolarCollectors.BaseClasses</a>.
Accordingly, data records for both test methods are available in
<a href=\"modelica://Buildings.Fluid.SolarCollectors.Data\">
Buildings.Fluid.SolarCollectors.Data</a>.
</p>
<p>
The computation of the
</p>

<h5>Performance data</h5>
Different sources exist to find ratings data of individual collectors.
However, not all data might be available in one single data sheet.
The table below specifies which input data of the model can be found in several
well-known data sources:
<p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Input data</th>
<th> <a href=\"http://www.solar-rating.org\"> SRCC</a> </th>
<th> <a href=\"https://solarkeymark.eu/\"> Solar Keymark</a> </th>
<th> <a href=\"https://www.spftesting.info/\"> SPF</a> </th>
</tr>
<tr>
<td> A </td>
<td> Gross area </td>
<td> Gross area </td>
<td> Gross, aperture, or absorber area </td>
</tr>
<tr>
<td> C </td>
<td> (mDry*385, V) </td>
<td> C </td>
<td> (CDry or mDry*385, V) </td>
</tr>
<tr>
<td> mperA_flow_nominal </td>
<td> mperA_flow_nominal </td>
<td> mperA_flow_nominal </td>
<td> m_flow_nominal/A </td>
</tr>
<tr>
<td> dp_nominal </td>
<td> / </td>
<td> / </td>
<td> dp_nominal </td>
</tr>
<tr>
<td> b0, b1 </td>
<td> IAM({0°,10°,...,90°}) </td>
<td> IAM({10°,20°,...,90°}) </td>
<td> IAM(angle)-plot </td>
</tr>
<tr>
<td> y_intercept, slope (ASHRAE93) </td>
<td> y_intercept, slope </td>
<td> / </td>
<td> / </td>
</tr>
<tr>
<td> IAMDiff, eta0, a1, a2 (EN12975) </td>
<td> IAM(50°), eta0, a1, a2 </td>
<td> Kd or IAM(50°), eta0, a1, a2 </td>
<td> IAM(50°), eta0, a1, a2 </td>
</tr>
</table>
</p>
<p>
Some extra important remarks regarding the performance data:
<ul>
<li>
Different areas can be defined for a solar collector: the gross, absorber, and
aperture area.
The performance parameters of the solar collector vary depending on the area
for which they are defined.
Therefore, the performance parameters used in the data record should match the
area that is used.
</li>
<li>
When the thermal capacity of the solar collector without fluid is not known,
the thermal capacity is calculated based on the dry mass of the collector
and the specific heat capacity of copper (<i>385 J/kg/k</i>).
</li>
<li>
All data sources report a nominal mass flow rate (per unit area of collector),
but only SPF reports a corresponding nominal pressure drop.
If a specific collector is used that is not included in the SPF database, one
can likely find this via the manufacturer (website or on request).
Some examples of (<code>mperA_flow_nominal</code>, <code>dp_nominal</code> can
be found in <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data\">
Buildings.Fluid.SolarCollectors.BaseClasses</a>.
</li>
<li>
Pressure drops depend on the medium that is used in the collectors.
If the modelled solar thermal collector uses a different medium than the medium
that was used to determine the nominal pressure drop in a data sheet, one should
therefore correctly take this into account (e.g. using an empirical correction
factor).
</li>
<li>
The relation between the incidence angle modifier (IAM) and incidence angle
<code>&theta;</code> is currently approximated in the model by
(Eq 18.298 in the EnergyPlus 23.2.0 Engineering Reference):
<p align=\"center\" style=\"font-style:italic;\">
K<sub>(&tau;&alpha;)</sub>=1+b<sub>0</sub>(1/cos(&theta;)-1)
  +b<sub>1</sub>(1/cos(&theta;)-1)<sup>2</sup>
</p>
<p>
where <i>K<sub>(&tau;&alpha;)</sub></i> is the incidence angle modifier,
<i>b<sub>0</sub></i> is the first incidence angle modifier coefficient,
<i>&theta;</i> is the incidence angle,
and <i>b<sub>1</sub></i> is the second incidence angle modifier coefficient.
</p>
<p>
As reported in the Energyplus Engineering Reference, this relation is only valid
for incident angles of 60 degrees or higher. However, as opposed to the EnergyPlus
approach, the IAM is not set to 0 for incident angles greater than 60 degrees
(see Buildings
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/785\">
issue 785</a>).
Therefore, the simulation results for incident angles greater than 60 degrees
should be interpreted with care.
</p>
</li>
<li>
Recent data sheets do not provide a value for <code>b0</code> or
<code>b1</code>, but report the IAM for several incidence angles.
The values for <code>b0</code> and <code>b1</code> can be determined by fitting
the tabular data (e.g. using the scipy function
<a href=\"https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.curve_fit.html\"> <i>curve_fit</i></a>)
</li>
<li>
Evacuated tube collectors have bi-axial IAMs due to its axisymetric geometry.
Therefore, data sheets report both a longitudinal and transversal IAM.
The model however only allows the definition of one (symmetrical) IAM.
Two possible approaches to deal with this are:
<ul>
<li>
multiplying the longitudinal and transversal IAM;
</li>
<li>
using either the longitudinal or transversal IAM.
</li>
</ul>
The model should therefore be used with extra care when dealing with
evacuated tube collectors.
</li>
<li>
The Solar Keymark database sometimes reports a value for <i>Kd</i> which is
the incident angle modifier for diffuse irradiance.
This value differs from the IAM at an incidence angle of 50 degrees because
the former is determined by integrating the values of the IAM
for all incidence angles over the hemisphere.
</li>
</ul>

<h5> Other model parameters </h5>
<p>
Apart from the performance parameters, several other parameters must be defined.
Most of the parameters are self-explanatory.
The complex parameters are used as follows:
</p>
<ul>
<li>
<code>nSeg</code>: This parameter refers to the number of segments between
the inlet and outlet of the system, not the number of segments in each solar
thermal collector.
</li>
<li>
<code>nColType</code>: This parameter allows the user to specify how the
number of collectors in the system is defined. Options are
<code>Number</code>, allowing the user to enter a number of panels, or
<code>TotalArea</code>, allowing the user to enter a system area.
<ul>
<li>
<code>Number</code>: If <code>Number</code> is selected for
<code>nColType</code> the user enters a number of panels. The simulation then
identifies the area of the system and uses that in solar gain and heat loss
computations.
</li>
<li>
<code>TotalArea</code>: If <code>TotalArea</code> is selected for
<code>nColType</code> the user enters a desired surface area of panels. The
model then uses this specified area in solar gain and heat loss computations.
The number of panels in the system is identified by dividing the specified
area by the area of each panel.
</li>
</ul>
</li>
<li>
<code>SysConfig</code>: This parameter allows the user to specify the
installation configuration of the system. Options are <code>Series</code> and
<code>Parallel</code>. The handling of <code>dp_nominal</code> is changed
depending on the selection.
<ul>
<li>
<code>Series</code>: If <code>Series</code> is selected it is assumed that all
panels in the system are connected in series. As a result there is a pressure
drop corresponding to <code>dp_nominal</code> for each panel and the effective
<code>dp_nominal</code> for the system is <code>dp_nominal</code> *
<code>nPanels</code>.
</li>
<li>
<code>Parallel</code>: If <code>Parallel</code> is selected it is assumed that
all panels in the system are connected in parallel. As a result the fluid
flows through only a single panel and the <code>dp_nominal</code> for the
system is <code>dp_nominal</code> specified in the collector data package if
the collector field has a mass flow rate equal to
<code>m_flow_nominal</code>.
</li>
</ul>
</li>
</ul>

<h4>References</h4>
<p>
ASHRAE 93-2010 -- Methods of Testing to Determine the Thermal Performance of
Solar Collectors (ANSI approved).
</p>
<p>
CEN 2022, European Standard 12975:2022, European Committee for Standardization.
</p>
<p>
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v23.2.0/EngineeringReference.pdf\">
EnergyPlus 23.2.0 Engineering Reference</a>.
</p>
</html>"));

end UsersGuide;
