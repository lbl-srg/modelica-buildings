within Buildings.Experimental.DistrictHeatingCooling.Plants.Validation;
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
  experiment(StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Plants/Validation/LakeWaterHeatExchanger_T_Cooling.mos"
        "Simulate and plot"));
end LakeWaterHeatExchanger_T_Cooling;
