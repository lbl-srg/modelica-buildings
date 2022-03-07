within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
record UserData
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.Data(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Configuration.WaterCooled,
    cooTowGro(
      cooTow={
        Buildings.Templates.Components.CoolingTower.Interfaces.Data(
          TAirInWB_nominal=298.7,
          TWatIn_nominal=308.15,
          dT_nominal=5.56,
          PFan_nominal=5000,
          dp_nominal=46200),
        Buildings.Templates.Components.CoolingTower.Interfaces.Data(
          TAirInWB_nominal=298.7,
          TWatIn_nominal=308.15,
          dT_nominal=5.56,
          PFan_nominal=5000,
          dp_nominal=46200)},
      nCooTow = 2,
      dpValInl_nominal(displayUnit="Pa") = 6000,
      dpValOut_nominal(displayUnit="Pa") = 0),
    mCon_flow_nominal=34.7,
    pumCon(nPum=2, dpValve_nominal(displayUnit="Pa") = 6000),
    con(
      TAirOutLoc(displayUnit="K") = 289.15,
      dpCHWLoc_max=20000,
      dpCHWRem_max={10000},
      mCHWChi_flow_min={0.3,0.3},
      dTLif_min=10,
      yPumCW_min=0.1,
      yValIsoCon_min=0.0,
      yPumCHW_min=0.1,
      yFanTow_min=0.0,
      TCWSup_nominal=576.3,
      TCWRet_nominal=308.15),
    pumSec(nPum=2, dpValve_nominal(displayUnit="Pa") = 6000),
    pumPri(
      nPum=2,
      dpValve_nominal(displayUnit="Pa") = 6000,
      dpByp_nominal(displayUnit="Pa") = 6000),
    chiGro(
      nChi=2,
      chi={
          Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Data(
          dp1_nominal=44800,
          dp2_nominal=46200,
          Q_flow_nominal=-50000,
          TCHWSup_nominal=553.3,
          per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes),
          Buildings.Templates.ChilledWaterPlant.Components.Chiller.Interfaces.Data(
          dp1_nominal=44800,
          dp2_nominal=46200,
          Q_flow_nominal=-50000,
          TCHWSup_nominal=553.3,
          per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes)},
      dpCHWValve_nominal(displayUnit="Pa") = 6000,
      dpCWValve_nominal(displayUnit="Pa") = 6000),
    mCHWChi_flow_nominal={9.15,9.15},
    dpDem_nominal(displayUnit="Pa") = 68900,
    mCHWSec_flow_nominal=18.3);


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UserData;
