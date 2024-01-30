within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
partial model LargeScaleWaterToWaterDeclarations
  "Model with parameters for large scale water-to-water heat pump"

  //Automatic calculation of mass flow rates and volumes of the evaporator
  // and condenser using linear regressions from data sheets of
  // heat pumps and chillers (water to water)

protected
  parameter Modelica.Units.SI.MassFlowRate autCalMMin_flow=0.3
    "Realistic mass flow minimum for simulation plausibility";
  parameter Modelica.Units.SI.Volume autCalVMin=0.003
    "Realistic volume minimum for simulation plausibility";

  parameter Modelica.Units.SI.MassFlowRate autCalMasEva_flow
    "Automatically calculated evaporator mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate autCalMasCon_flow
    "Automatically calculated condenser mass flow rate";
  parameter Modelica.Units.SI.Volume autCalVEva
    "Automatically calculated evaporator volume";
  parameter Modelica.Units.SI.Volume autCalVCon
    "Automatically calculated condenser volume";

initial equation
  //Control and feedback for the auto-calculation of condenser and evaporator data
  assert(
    autCalMasEva_flow > autCalMMin_flow and autCalMasEva_flow < 90,
    "In " + getInstanceName() + ": Given nominal heat output for auto-calculation of
    evaporator and condenser data is outside the range of data sheets
    considered. Verify the auto-calculated mass flows.",
    level=AssertionLevel.warning);
  assert(
    autCalVEva > autCalVMin and autCalVEva < 0.43,
  "In " + getInstanceName() + ": Given nominal heat output for auto-calculation of evaporator
  and condenser data is outside the range of data sheets considered.
  Verify the auto-calculated volumes.",
    level=AssertionLevel.warning);


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  This model provides declarations that auto-populate nominal mass flow rates
  and time constants (i.e. volumes) of the heat exchange based on
  the nominal electric power consumption of the chiller or heat pump.
  It is based on more than 20 datasets of water-to-water heat pumps
  from multiple manufacturers ranging from about <i>25</i> kW
  to <i>1</i> MW in nominal electric power consumption. The linear regressions with coefficients
  of determination above <i>91</i>% give a good approximation of these
  parameters. Nevertheless, estimates for machines outside
  the given range should be checked for plausibility during simulation.
</p>
<p>
For more information, see
<a href=\"modelica://Buildings/Resources/Data/Fluid/HeatPumps/BaseClasses/LargeScaleWaterToWaterParameters.xlsx\">
Buildings/Resources/Data/Fluid/HeatPumps/BaseClasses/LargeScaleWaterToWaterParameters.xlsx</a>.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>Novemeber 11, 2022</i> by Fabian Wuellhorst:<br/>
    First implemented based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end LargeScaleWaterToWaterDeclarations;
