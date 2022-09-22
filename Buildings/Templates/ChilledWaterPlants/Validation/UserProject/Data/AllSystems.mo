within Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data;
record AllSystems
  "Top-level (while building) record for testing purposes"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.PressureDifference dpChiWatDis_nominal=10E4
    "Design CHW distribution system pressure drop (consumer side only, plant excluded)"
    annotation (Dialog(group="Nominal condition"));

  parameter Buildings.Templates.ChilledWaterPlants.Data.ChilledWaterPlant CHI(
    chi(
      mChiWatChi_flow_nominal=
        CHI.chi.capChi_nominal / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq ./
        (Buildings.Templates.Data.Defaults.TChiWatRet .-
         CHI.chi.TChiWatChiSup_nominal),
      mConChi_flow_nominal=
        if CHI.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled then
        CHI.chi.capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiWatCoo)/
        Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
        (Buildings.Templates.Data.Defaults.TConWatRet-
        Buildings.Templates.Data.Defaults.TConWatSup)
        else CHI.chi.capChi_nominal * Buildings.Templates.Data.Defaults.mConAirByCapChi,
      dpChiWatChi_nominal=fill(Buildings.Templates.Data.Defaults.dpChiWatChi, CHI.nChi),
      dpConChi_nominal=fill(Buildings.Templates.Data.Defaults.dpConWatChi, CHI.nChi),
      capChi_nominal=fill(1e6, CHI.nChi),
      TChiWatChiSup_nominal=fill(Buildings.Templates.Data.Defaults.TChiWatSup, CHI.nChi),
      TConChiEnt_nominal=fill(if CHI.typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
        then Buildings.Templates.Data.Defaults.TConWatSup else
        Buildings.Templates.Data.Defaults.TConAirEnt, CHI.nChi),
      PLRUnlChi_min=fill(0.15, CHI.nChi),
      PLRChi_min=fill(0.15, CHI.nChi),
      redeclare each Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHE_1442kW_6_61COP_VSD per),
    ctr(
      mChiWatChi_flow_min=0.3 * CHI.chi.mChiWatChi_flow_nominal),
    pumChiWatPri(
      dp_nominal=fill(1.5*sum(CHI.chi.dpChiWatChi_nominal), CHI.nChi) +
       fill((if CHI.typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only or
       CHI.typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only then
       dpChiWatDis_nominal else 0), CHI.nChi)),
    pumChiWatSec(
      m_flow_nominal=1.1*CHI.chi.mChiWatChi_flow_nominal,
      dp_nominal=fill(dpChiWatDis_nominal, CHI.nChi)),
    coo(
      mConWatCoo_flow_nominal=CHI.chi.mConChi_flow_nominal,
      mAirCoo_flow_nominal=CHI.coo.mConWatCoo_flow_nominal / Buildings.Templates.Data.Defaults.ratFloWatByAirTow,
      TAirEnt_nominal=Buildings.Templates.Data.Defaults.TAirDryCooEnt,
      TWetBulEnt_nominal=Buildings.Templates.Data.Defaults.TWetBulTowEnt,
      TConWatRet_nominal=Buildings.Templates.Data.Defaults.TConWatRet,
      TConWatSup_nominal=Buildings.Templates.Data.Defaults.TConWatSup,
      PFanCoo_nominal=Buildings.Templates.Data.Defaults.PFanByFloConWatTow * CHI.coo.mConWatCoo_flow_nominal,
      dpConWatFriCoo_nominal=fill(if CHI.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen then
       Buildings.Templates.Data.Defaults.dpConWatFriTow else
       Buildings.Templates.Data.Defaults.dpConWatTowClo, CHI.nCoo),
      dpConWatStaCoo_nominal=fill(if CHI.typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen then
        Buildings.Templates.Data.Defaults.dpConWatStaTow else 0, CHI.nCoo)),
    pumConWat(
      dp_nominal=1.5*(CHI.chi.dpConChi_nominal + CHI.coo.dpConWatFriCoo_nominal + CHI.coo.dpConWatStaCoo_nominal)))
    "CHW plant parameters - SERIES arrangement";
end AllSystems;
