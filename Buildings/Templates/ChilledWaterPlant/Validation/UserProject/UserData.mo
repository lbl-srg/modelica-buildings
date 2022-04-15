within Buildings.Templates.ChilledWaterPlant.Validation.UserProject;
record UserData
  extends Buildings.Templates.ChilledWaterPlant.Interfaces.Data(
    mCon_flow_nominal=34,
    dpDem_nominal(displayUnit="Pa") = 68900,
    mChiWatPri_flow_nominal=18,
    con(
      TAirOutLoc(displayUnit="K") = 289.15,
      dpChiWatRem_max={10000},
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
      valCooTowInl(each dpValve_nominal=6000),
      valCooTowOut(each dpValve_nominal=0)),
    pumPri(
      pum(
        each dp_nominal=0,
        each dpValve_nominal=0),
      valByp(dpValve_nominal=6000),
      valChiByp(dpValve_nominal=6000),
      valChiWatChi(each dpValve_nominal=6000)),
    pumCon(
      pum(
        each dp_nominal=0,
        each dpValve_nominal=0),
      valConWatChi(each dpValve_nominal=6000)),
    pumSec(
      pum(
        each dp_nominal=0,
        each dpValve_nominal=0)),
    chiSec(
      chi(
        each m1_flow_nominal=14,
        each m2_flow_nominal=9,
        each dp1_nominal=44800,
        each dp2_nominal=46200,
        each Q_flow_nominal=-50000,
        each TChiWatSup_nominal=280.15,
        each per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes())));


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end UserData;
