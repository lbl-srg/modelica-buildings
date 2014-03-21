within Buildings;

package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  annotation(preferredView = "info", Documentation(info = "<html>
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
  use of individual sublibraries or models.
  Discussed topics include 
  how to get started, best practices, how to post-process results using Python,
  work-around for problems and how to develop models.<br/>
  </li>
  <li>
  Some of the main sublibraries have their own
  User's Guides that can be accessed by the links below.
  These User's Guides are discussing items that are specific to the
  individual libraries.<br/>
  <table summary=\"summary\" border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Airflow.Multizone.UsersGuide\">Airflow.Multizone</a>
     </td>
     <td valign=\"top\">Package for multizone airflow and contaminant transport.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">BoundaryConditions</a>
     </td>
     <td valign=\"top\">Package for computing boundary conditions, such as solar irradiation.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.BoundaryConditions.WeatherData.UsersGuide\">BoundaryConditions.WeatherData</a>
     </td>
     <td valign=\"top\">Package for reading weather data.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.UsersGuide\">Fluid</a>
     </td>
     <td valign=\"top\">Package for one-dimensional fluid in piping networks with heat exchangers, valves, etc.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">Fluid.Actuators</a>
     </td>
     <td valign=\"top\">Package with valves and air dampers.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">Fluid.HeatExchangers.DXCoils</a>
     </td>
     <td valign=\"top\">Package with direct evaporative cooling coils.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Fluid.Movers</a>
     </td>
     <td valign=\"top\">Package with fans and pumps.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">Fluid.Sensors</a>
     </td>
     <td valign=\"top\">Package with sensors.</td>
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
  <tr><td valign=\"top\"><a href=\"modelica://Buildings.Rooms.UsersGuide\">Rooms</a>
     </td>
     <td valign=\"top\">Package for heat transfer in rooms and through the building envelope.</td>
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