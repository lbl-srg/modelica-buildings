within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
record UserData
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.Data(
    mCon_flow_nominal=34,
    dpDem_nominal = 68900,
    mPri_flow_nominal=18,
    con(
      TAirOutLoc = 289.15,
      dpChiWatLoc_max=10000,
      mChiWatChi_flow_min={0.3,0.3},
      dTLif_min=10,
      yPumConWat_min=0.1,
      yPumChiWat_min=0.1,
      yFanTow_min=0,
      yValIsoCon_min=0.1),
    cooTowSec(
      cooTow(
        each dp_nominal=46200,
        each TAirInWB_nominal=298.7,
        each TWatIn_nominal=308.15,
        each dT_nominal=5.56,
        each PFan_nominal=5000),
      valCooTowInlIso(each dpValve_nominal=6000),
      valCooTowOutIso(each dpValve_nominal=0)),
    pumPri(
      m_flow_nominal=9,
      pum(
        each dp_nominal=12000,
        each dpValve_nominal=2000),
      valPriMinFloByp(dpValve_nominal=6000),
      valChiWatChiByp(dpValve_nominal=6000),
      valChiWatChiIso(each dpValve_nominal=6000)),
    pumCon(
      m_flow_nominal=14,
      pum(
        each dp_nominal=12000,
        each dpValve_nominal=2000),
      valConWatChiIso(each dpValve_nominal=6000)),
    pumSec(
      m_flow_nominal=9,
      pum(
        each dp_nominal=12000,
        each dpValve_nominal=2000)),
    chiSec(
      chi(
        each m1_flow_nominal=14,
        each m2_flow_nominal=9,
        each dp1_nominal=44800,
        each dp2_nominal=46200,
        each Q_flow_nominal=-50000,
        each TChiWatSup_nominal=280.15,
        each per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes())),
    eco(
      valConWatEcoIso(dpValve_nominal=6000),
      valChiWatEcoByp(dpValve_nominal=6000),
      pumEco(
        dp_nominal=12000,
        dpValve_nominal=2000),
      T_ChiWatHexEnt_nominal=280.15,
      T_ConWatHexEnt_nominal=308.15,
      dpChiWatHex_nominal=3000,
      dpConWatHex_nominal=3000,
      QHex_flow_nominal=10000));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UserData;
