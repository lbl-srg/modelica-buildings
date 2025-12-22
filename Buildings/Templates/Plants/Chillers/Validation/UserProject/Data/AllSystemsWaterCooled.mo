within Buildings.Templates.Plants.Chillers.Validation.UserProject.Data;
class AllSystemsWaterCooled
  "Design and operating parameters for testing purposes"
  extends Buildings.Templates.Data.AllSystems(
    sysUni=Buildings.Templates.Types.Units.SI,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Zone_3B);
  parameter Buildings.Templates.Plants.Chillers.Data.ChillerPlant pla(
    chi(
      dpChiWatChi_nominal=fill(Buildings.Templates.Data.Defaults.dpChiWatChi,
          pla.cfg.nChi),
      dpConChi_nominal=fill(Buildings.Templates.Data.Defaults.dpConWatChi, pla.cfg.nChi),
      perChi(
        each fileName=Modelica.Utilities.Files.loadResource(
          "modelica://Buildings/Resources/Data/Fluid/Chillers/ModularReversible/Validation/McQuay_WSC_471kW_5_89COP_Vanes.txt"),
        each PLRSup={0.1,0.43,0.75,1.,1.08},
        each devIde="McQuay_WSC_471kW_5_89COP_Vanes",
        each use_TEvaOutForTab=true,
        each use_TConOutForTab=true)),
    ctl(
      TChiWatSupChi_nominal=fill(Buildings.Templates.Data.Defaults.TChiWatSup,
        pla.cfg.nChi),
      dpChiWatLocSet_min=Buildings.Templates.Data.Defaults.dpChiWatSet_min,
      dpChiWatRemSet_min=fill(Buildings.Templates.Data.Defaults.dpChiWatSet_min,
        pla.cfg.nSenDpChiWatRem),
      VChiWatChi_flow_nominal=pla.ctl.capChi_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
        ./ (Buildings.Templates.Data.Defaults.TChiWatRet .- pla.ctl.TChiWatSupChi_nominal)
        /pla.cfg.rhoChiWat_default,
      VChiWatChi_flow_min=0.3*pla.ctl.VChiWatChi_flow_nominal,
      VConWatChi_flow_nominal=pla.ctl.capChi_nominal*(1 + 1/Buildings.Templates.Data.Defaults.COPChiWatCoo)
        /Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/(Buildings.Templates.Data.Defaults.TConWatRet
        - Buildings.Templates.Data.Defaults.TConWatSup)/pla.cfg.rhoCon_default,
      dTLifChi_min=fill(Buildings.Templates.Data.Defaults.dTLifChi_min, pla.cfg.nChi),
      dTLifChi_nominal=pla.ctl.TConWatRetChi_nominal .- pla.ctl.TChiWatSupChi_nominal,
      capChi_nominal=fill(1E6, pla.cfg.nChi),
      VChiWatPri_flow_nominal=sum(pla.ctl.VChiWatChi_flow_nominal),
      VChiWatSec_flow_nominal=fill(
        sum(pla.ctl.VChiWatChi_flow_nominal) / 1.1 / max(1, pla.cfg.nLooChiWatSec),
        pla.cfg.nLooChiWatSec),
      capUnlChi_min=0.15*pla.ctl.capChi_nominal,
      dTAppEco_nominal=Buildings.Templates.Data.Defaults.TChiWatEcoLvg -
        Buildings.Templates.Data.Defaults.TConWatEcoEnt,
      TWetBulCooEnt_nominal=Buildings.Templates.Data.Defaults.TWetBulTowEnt,
      dTAppCoo_nominal=Buildings.Templates.Data.Defaults.TConWatSup - Buildings.Templates.Data.Defaults.TWetBulTowEnt,
      VChiWatEco_flow_nominal=sum(pla.ctl.VChiWatChi_flow_nominal[1:2]),
      VConWatEco_flow_nominal=sum(pla.ctl.VConWatChi_flow_nominal[1:2]),
      dpChiWatEco_nominal=Buildings.Templates.Data.Defaults.dpChiWatEco,
      hLevAlaCoo_max=0.3,
      hLevAlaCoo_min=0.05,
      hLevCoo_min=0.1,
      hLevCoo_max=0.2,
      yPumConWatSta_nominal=fill(1, pla.ctl.nSta),
      yValConWatChiIso_min=0,
      yPumConWat_min=0.1,
      yPumChiWatEco_nominal=1.0,
      yPumChiWatPriSta_nominal=fill(1, pla.ctl.nSta),
      yPumChiWatPriSta_min=fill(0.3, pla.ctl.nSta),
      yPumChiWatPri_min=0.1,
      yPumChiWatSec_min=0.1,
      yFanCoo_min=0,
      staChi=[
        1,0;
        1,1],
      staPumConWat=if pla.cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
      then [
        0,0;
        1,0;
        1,0;
        1,1;
        1,1;
        1,1] else [
        0,0;
        1,0;
        1,1],
      staCoo=if pla.cfg.typEco <> Buildings.Templates.Plants.Chillers.Types.Economizer.None
        then {0,1,1,2,2,2} else {0,1,2},
      TOutChiWatLck=250,
      TConWatRetChi_nominal=fill(Buildings.Templates.Data.Defaults.TConWatRet,
          pla.cfg.nChi),
      TConWatSupChi_nominal=fill(Buildings.Templates.Data.Defaults.TConWatSup,
          pla.cfg.nChi),
      dpChiWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpChiWatRemSet_max,
          pla.cfg.nSenDpChiWatRem),
      dpChiWatLocSet_max=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max),
    pumChiWatPri(dp_nominal=fill((if pla.cfg.typArrChi == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
           then max(pla.chi.dpChiWatChi_nominal) else sum(pla.chi.dpChiWatChi_nominal))
          *1.5, pla.cfg.nPumChiWatPri) + fill((if pla.cfg.typDisChiWat ==
          Buildings.Templates.Plants.Chillers.Types.Distribution.Constant1Only
           or pla.cfg.typDisChiWat == Buildings.Templates.Plants.Chillers.Types.Distribution.Variable1Only
           then pla.ctl.dpChiWatLocSet_max else 0), pla.cfg.nChi)),
    pumChiWatSec(dp_nominal=fill(pla.ctl.dpChiWatLocSet_max, pla.cfg.nPumChiWatSec)),
    coo(
      mAirCoo_flow_nominal=pla.coo.mConWatCoo_flow_nominal/Buildings.Templates.Data.Defaults.ratMFloConWatByMFloAirTow,
      TAirEnt_nominal=Buildings.Templates.Data.Defaults.TOutChi,
      PFanCoo_nominal=Buildings.Templates.Data.Defaults.ratPFanByMFloConWatTow*
          pla.coo.mConWatCoo_flow_nominal,
      dpConWatFriCoo_nominal=fill(if pla.cfg.typCoo == Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
           then Buildings.Templates.Data.Defaults.dpConWatFriTow else Buildings.Templates.Data.Defaults.dpConWatTowClo,
          pla.cfg.nCoo),
      dpConWatStaCoo_nominal=fill(if pla.cfg.typCoo == Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen
           then Buildings.Templates.Data.Defaults.dpConWatStaTow else 0, pla.cfg.nCoo)),
    pumConWat(dp_nominal=1.5*(pla.chi.dpConChi_nominal + pla.coo.dpConWatFriCoo_nominal
           + pla.coo.dpConWatStaCoo_nominal)),
    eco(
      cap_nominal=0.6*sum(pla.ctl.capChi_nominal[1:2]),
      TChiWatEnt_nominal=Buildings.Templates.Data.Defaults.TChiWatEcoEnt,
      TConWatEnt_nominal=Buildings.Templates.Data.Defaults.TConWatEcoEnt,
      dpChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatEco,
      dpConWat_nominal=Buildings.Templates.Data.Defaults.dpConWatEco,
      dpPumChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatEco))
    "CHW plant parameters"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  annotation (Documentation(info="<html>
<p>
This class provides system parameters for the validation
of water-cooled chiller plant models.
</p>
</html>"));
end AllSystemsWaterCooled;
