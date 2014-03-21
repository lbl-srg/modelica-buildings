within Buildings.UsersGuide.ReleaseNotes;

class Version_0_8_0 "Version 0.8.0"
  extends Modelica.Icons.ReleaseNotes;
  annotation(preferredView = "info", Documentation(info = "<html>
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
  <a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated\">
  Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated</a>,
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
  <a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas\">
  Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas</a> and its derivative.
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
  </html>
  "));
end Version_0_8_0;