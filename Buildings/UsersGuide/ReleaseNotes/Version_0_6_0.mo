within Buildings.UsersGuide.ReleaseNotes;

class Version_0_6_0 "Version 0.6.0"
  extends Modelica.Icons.ReleaseNotes;
  annotation(preferredView = "info", Documentation(info = "<html>
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
  </html>
  "));
end Version_0_6_0;