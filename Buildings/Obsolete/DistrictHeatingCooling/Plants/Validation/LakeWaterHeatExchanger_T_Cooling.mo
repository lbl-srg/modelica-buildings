within Buildings.Obsolete.DistrictHeatingCooling.Plants.Validation;
model LakeWaterHeatExchanger_T_Cooling
  "Validation model for lake water heat exchanger in which it provides cooling"
  extends LakeWaterHeatExchanger_T_Heating(
    redeclare Modelica.Blocks.Sources.Ramp TWatWar(
      height=16,
      duration=900,
      offset=273.15 + 4),
    m_flow(height=2*m_flow_nominal, offset=-m_flow_nominal),
    redeclare Modelica.Blocks.Sources.Constant TWatCol(k=273.15 + 20));

  annotation (
  experiment(Tolerance=1e-6, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/DistrictHeatingCooling/Plants/Validation/LakeWaterHeatExchanger_T_Cooling.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation model in which the inlet water temperature on the warm side of the
heat exchanger is gradually increased.
Toward the end of the simulation, the water flow through the heat exchanger
reverses its direction.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LakeWaterHeatExchanger_T_Cooling;
