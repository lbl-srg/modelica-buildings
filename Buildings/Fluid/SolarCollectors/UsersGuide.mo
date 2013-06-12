within Buildings.Fluid.SolarCollectors;
package UsersGuide "User's Guide for Buildings.Fluid.SolarCollectors"
  extends Modelica.Icons.Information;

  annotation(preferredview="info",
  Documentation(info="<html>
  <p>
  The package <code>Buildings.Fluid.SolarCollectors</code> contains models used for the simulation 
  of solar thermal systems. Top-level models are available for concentrating, flat plate, and 
  tubular solar collectors. The three models use different models for solar gain, heat loss
  and data packages. Solar gain and heat loss models are available for use with data obtained from
  ASHRAE93 and EN12975 test procedures. Data packages containing default values for several collectors
  are available in packages for concentrating, flat plate and tubular collectors.  
  </p>
  <h4>Use of the <code>Buildings.Fluid.SolarCollectors</code> models</h4>
  <p>
  A model of a solar thermal collector mainly consists of the three following items:<br/>
  <ul>
  <li>A package containing ratings data.</li>
  <li>Models for solar gain and heat loss corresponding to the format of the referenced ratings data.</li>
  <li>Parameters describing the installation of the system.</li>
  </p>
  <p>
  Ratings data describing the parameters of individual collectors are available in 
  <a href=\"modelica://Buildings.Fluid.SolarCollectors.Data\"> Buildings.Fluid.SolarCollectors.Data</a>.
  All ratings data was taken from the <a href=\"http://www.solar-rating.org\"> Solar Rating and Certification
  Corporation</a> (SRCC) website. Data for concentrating, flat plate and tubular collectors are currently
  presented in separate data packages to improve ease of use.
  </p>
  <p>
  Currently there are no concentrating models on the <a href=\"http://www.solar-rating.org\"> SRCC</a>
  website that provide all of the data necessary for accurate use in the models available in 
  <code>Buildings.Fluid.SolarCollectors</code>. Namely, they lack data for <code>dp_nominal</code>, 
  <code>dT_nominal</code> and <code>G_nominal</code>. This data must be obtained from other sources to
  use all capabilities of these models.
  </p>
  <p>
  Currently there are two test methods for solar thermal collectors. The American standard is ASHRAE93 and
  the European standard is EN12975. Models calculating solar gain and heat loss using coefficients from both
  test methods are available in <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses\">
  Buildings.Fluid.SolarCollectors.BaseClasses</a>. Users should be careful to ensure that the solar gain and
  heat loss models used in their simulation match the ratings data entered into the data package. By default
  the concentrating model uses EN12975 models while flat plate and tubular use ASHRAE93 models.
  </p>
  <p>
  Finally, the parameters of the system must be defined. The complex parameters are used as follows:
  <ol>
  <li><code>nSeg</code>: This parameter refers to the number of segments between the inlet and outlet of the system,
  not the number of segments in each solar thermal collector.</li>
  <li><code>nColType</code>: This parameter allows the user to specify how the number of collectors in the system
  is defined. Options are <code>Number</code>, allowing the user to enter a number of panels, or <code>TotalArea</code>, allowing
  the user to enter a system area.</li>
  <ol>
  <li><code>Number</code>: If <code>Number</code> is selected for <code>nColType</code> the user enters a number of panels. The simulation then
  identifies the area of the system and uses that in solar gain and heat loss computations.</li>
  <li><code>TotalArea</code>: If <code>TotalArea</code> is selected for <code>nColType</code> the user enters a desired surface area of panels.
  The model then uses this specified area in the simulation.</li>
  </ol>
  <li><code>SysConfig</code>: This parameter allows the user to specify if the panels in the system are installed in a 
  series or parallel configuration. The handling of <code>dp_nominal</code> is changed depending on the
  selection.</li>
  <ol>
  <li><code>Series</code>: If <code>Series</code> is selected it is assumed that all panels in the system are in series. As a result
  there is a pressure drop corresponding to <code>dp_nominal</code> for each panel and the effective
  <code>dp_nominal</code> for the system is <code>dp_nominal</code> * <code>nPanels</code>.</li>
  <li><code>Parallel</code>: If <code>Parallel</code> is selected it is assumed that all panels in the system are in parallel. As a
  result the fluid flows through only a single panel and the <code>dp_nominal</code> for the system is
  <code>dp_nominal</code> specified in the collector data package.</li>
  </ol>
  </ol>
  </p>
  <h4>References</h4>
  <ul>
  <li>ASHRAE 93-2010 -- Methods of Testing to Determine the Thermal Performance of Solar Collectors (ANSI approved)</li>
  <li>CEN 2006, European Standard 12975-1:2006, European Committee for Standardization </li>
  </ul>
  </html>"));

end UsersGuide;
