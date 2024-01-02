within Buildings.Fluid.SolarCollectors;
package UsersGuide "User's Guide for Buildings.Fluid.SolarCollectors"
  extends Modelica.Icons.Information;

  annotation(preferredView="info",
  Documentation(info="<html>
<p>
The package <a href=\"modelica://Buildings.Fluid.SolarCollectors\">
Buildings.Fluid.SolarCollectors</a> contains models used for simulation of
solar thermal systems. Top-level models are available for solar collectors
based on the ASHRAE93 (American) and EN12975 (European) test protocols.
The two models use different models for solar gain, heat loss, and data
packages. Solar gain and heat loss models are available for use with data
obtained from ASHRAE93 and EN12975 test procedures. Data packages containing
default values for several collectors are available in packages for 
concentrating, flat plate and tubular collectors.
</p>
<h4>Use of the <code>Buildings.Fluid.SolarCollectors</code> models</h4>
<p>
A model of a solar thermal collector mainly consists of the three following
items:
</p>
<ul>
<li>
A package containing ratings data.
</li>
<li>
Models for solar gain and heat loss corresponding to the format of the
referenced ratings data.
</li>
<li>
Parameters describing the installation of the system.
</li>
</ul>
<p>
Different sources exist to find ratings data of individual collectors.
Some examples are:
<ul>
<li>
<a href=\"http://www.solar-rating.org\"> Solar Rating and
Certification Corporation (SRCC)</a> (data for both ASHRAE93 and EN12975)
</li>
<li>
<a href=\"https://solarkeymark.eu/\"> Solar Keymark</a> (data for EN12975)
</li>
<li>
<a href=\"https://www.spftesting.info/\"> SPF</a> (data for EN12975)
</li>
</ul>
It is possible that not all data is available via one source (especially
<code>dp_nominal</code> and <code>dT_nominal</code>). This data can then be
found by consulting multiple sources and/or the manufacturer data sheet.
</p>
<p>
Data for concentrating, flat plate and
tubular collectors are currently presented in separate data packages to
improve ease of use. The name of any given collector data package begins
with a code stating what type of collector it is. The codes are as follows:
</p>
<ul>
<li>C: Concentrating</li>
<li>FP: Flat Place</li>
<li>T: Tubular</li>
</ul>
<p>
There are two test methods for solar thermal collectors. The American standard
is ASHRAE93 and the European standard is EN12975. Models calculating solar
gain and heat loss using coefficients from both test methods are available in
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses\">
Buildings.Fluid.SolarCollectors.BaseClasses</a>. Accordingly, data records for
both test methods are available in 
<a href=\"modelica://Buildings.Fluid.SolarCollectors.Data\">
Buildings.Fluid.SolarCollectors.Data</a>
</p>
<p>
Finally, the parameters of the system must be defined. Most of the parameters
are self-explanatory. The complex parameters are used as follows:
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
<code>per.m_flow_nominal</code>.
</li>
</ul>
</li>
</ul>
<h4>References</h4>
<ul>
<li>
ASHRAE 93-2010 -- Methods of Testing to Determine the Thermal Performance
of Solar Collectors (ANSI approved)
</li>
<li>
CEN 2022, European Standard 12975:2022, European Committee for
Standardization
</li>
</ul>
</html>"));
end UsersGuide;
