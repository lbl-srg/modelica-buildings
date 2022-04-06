within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
record UserData
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.Data(
    mCon_flow_nominal=34,
    dpDem_nominal(displayUnit="Pa") = 68900,
    mChiWatPri_flow_nominal=18,
    con(
      TAirOutLoc(displayUnit="K") = 289.15,
      dpChiWatRem_max={10000},
      mChiWatChi_flow_min={0.3,0.3},
      dTLif_min=10,
      yPumConWat_min=0.1,
      yPumChiWat_min=0.1,
      yFanTow_min=0),
    cooTowGro(
      cooTow={
        Buildings.Templates.Components.CoolingTower.Interfaces.Data(
          dp_nominal=46200,
          TAirInWB_nominal=298.7,
          TWatIn_nominal=308.15,
          dT_nominal=5.56,
          PFan_nominal=5000),
        Buildings.Templates.Components.CoolingTower.Interfaces.Data(
          dp_nominal=46200,
          TAirInWB_nominal=298.7,
          TWatIn_nominal=308.15,
          dT_nominal=5.56,
          PFan_nominal=5000)},
      dpValInl_nominal(displayUnit="Pa") = {6000,6000},
      dpValOut_nominal(displayUnit="Pa") = {0, 0}),
    pumCon(dpConWatChiValve_nominal(displayUnit="Pa") = 6000),
    pumPri(
      dpChiWatChiValve_nominal(displayUnit="Pa") = 6000,
      dpByp_nominal(displayUnit="Pa") = 6000,
      dpChiByp_nominal(displayUnit="Pa") = 6000),
    chiGro(
      chi={
        Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Data(
          isAirCoo=false,
          m1_flow_nominal=14,
          m2_flow_nominal=9,
          dp1_nominal=44800,
          dp2_nominal=46200,
          Q_flow_nominal=-50000,
          TChiWatSup_nominal=280.15,
          per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes),
        Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Data(
          isAirCoo=false,
          m1_flow_nominal=14,
          m2_flow_nominal=9,
          dp1_nominal=44800,
          dp2_nominal=46200,
          Q_flow_nominal=-50000,
          TChiWatSup_nominal=280.15,
          per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes)},
      dpChiWatChiValve_nominal(displayUnit="Pa") = 6000));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UserData;
