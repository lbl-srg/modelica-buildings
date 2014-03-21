within Buildings.UsersGuide.ReleaseNotes;

class Version_0_9_0 "Version 0.9.0"
  extends Modelica.Icons.ReleaseNotes;
  annotation(preferredView = "info", Documentation(info = "<html>
  <ul>
  <li>
  Added the following heat exchanger models
  <ul>
  <li> 
  <a href=\"modelica://Buildings.Fluid.HeatExchangers.DryEffectivenessNTU\">
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU</a>
  for a sensible heat exchanger that uses the <code>epsilon-NTU</code>
  relations to compute the heat transfer.
  </li>
  <li>
  <a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a> and
  <a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>
  to model a coil without and with water vapor condensation. These models
  approximate the coil as a counterflow heat exchanger.
  </li>
  </ul>
  <li>
  Revised air damper 
  <a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
  Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>.
  The new implementation avoids warnings and leads to faster convergence
  since the solver does not attempt anymore to solve for a variable that
  needs to be strictly positive.
  </li>
  <li>
  Revised package
  <a href=\"modelica://Buildings.Fluid.Movers\">
  Buildings.Fluid.Movers</a>
  to allow zero flow for some pump or fan models.
  If the input to the model is the control signal <code>y</code>, then
  the flow is equal to zero if <code>y=0</code>. This change required rewriting
  the package to avoid division by the rotational speed.
  </li>
  <li>
  Revised package
  <a href=\"modelica://Buildings.HeatTransfer\">
  Buildings.HeatTransfer</a>
  to include a model for a multi-layer construction, and to
  allow individual material layers to be computed steady-state or
  transient.
  </li>
  <li>
  In package  <a href=\"modelica://Buildings.Fluid\">
  Buildings.Fluid</a>, changed models so that
  if the parameter <code>dp_nominal</code> is set to zero,
  then the pressure drop equation is removed. This allows, for example, 
  to model a heating and a cooling coil in series, and lump there pressure drops
  into a single element, thereby reducing the dimension of the nonlinear system
  of equations.
  </li>
  <li>
  Added model <a href=\"modelica://Buildings.Controls.Continuous.LimPID\">
  Buildings.Controls.Continuous.LimPID</a>, which is identical to 
  <a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">
  Modelica.Blocks.Continuous.LimPID</a>, except that it 
  allows reverse control action. This simplifies use of the controller
  for cooling applications.
  </li>
  <li>
  Added model <a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBox\">
  Buildings.Fluid.Actuators.Dampers.MixingBox</a> for an outside air
  mixing box with air dampers.
  </li>
  <li>
  Changed implementation of flow resistance in
  <a href=\"modelica://Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow\">
  Buildings.Fluid.Actuators.Dampers.MixingBoxMinimumFlow</a>. Instead of using a
  fixed resistance and a damper model in series, only one model is used
  that internally adds these two resistances. This leads to smaller systems
  of nonlinear equations.
  </li>
  <li>
  Changed 
  <a href=\"modelica://Buildings.Media.PerfectGases.MoistAir.T_phX\">
  Buildings.Media.PerfectGases.MoistAir.T_phX</a> (and by inheritance all
  other moist air medium models) to first compute <code>T</code> 
  in closed form assuming no saturation. Then, a check is done to determine
  whether the state is in the fog region. If the state is in the fog region,
  then <code>Internal.solve</code> is called. This new implementation
  can lead to significantly shorter computing
  time in models that frequently call <code>T_phX</code>.
  <li>
  Added package
  <a href=\"modelica://Buildings.Media.GasesConstantDensity\">
  Buildings.Media.GasesConstantDensity</a> which contains medium models
  for dry air and moist air.
  The use of a constant density avoids having pressure as a state variable in mixing volumes. Hence, fast transients
  introduced by a change in pressure are avoided. 
  The drawback is that the dimensionality of the coupled
  nonlinear equation system is typically larger for flow
  networks.
  </li>
  <li>
  In 
  <a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
  Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</a>,
  added default value for parameter <code>A</code> to avoid compilation error
  if the parameter is disabled but not specified.
  </li>
  <li>
  Simplified the mixing volumes in 
  <a href=\"modelica://Buildings.Fluid.MixingVolumes\">
  Buildings.Fluid.MixingVolumes</a> by removing the port velocity, 
  pressure drop and height.
  </li>
  </ul>
  </html>
  "));
end Version_0_9_0;