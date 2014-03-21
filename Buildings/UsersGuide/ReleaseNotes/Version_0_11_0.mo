within Buildings.UsersGuide.ReleaseNotes;

class Version_0_11_0 "Version 0.11.0"
  extends Modelica.Icons.ReleaseNotes;
  annotation(preferredView = "info", Documentation(info = "<html>
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
  </html>
  "));
end Version_0_11_0;