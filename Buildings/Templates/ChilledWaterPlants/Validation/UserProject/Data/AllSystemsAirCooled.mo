within Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data;
class AllSystemsAirCooled
  "Design and operating parameters for testing purposes"
  extends Buildings.Templates.Data.AllSystems(
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.Not_Specified,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    sysUni=Buildings.Templates.Types.Units.SI);

  // The following instance name matches the system tag.
  outer Buildings.Templates.ChilledWaterPlants.AirCooled CHI;

  parameter Buildings.Templates.ChilledWaterPlants.Data.ChilledWaterPlant _CHI(
    final typCtl=CHI.ctl.typ,
    final typChi=CHI.typChi,
    final nChi=CHI.nChi,
    final nPumChiWatPri=CHI.nPumChiWatPri,
    final typArrPumChiWatPri=CHI.typArrPumChiWatPri,
    final have_varPumChiWatPri=CHI.have_varPumChiWatPri,
    final nPumConWat=CHI.nPumConWat,
    final typDisChiWat=CHI.typDisChiWat,
    final nPumChiWatSec=CHI.nPumChiWatSec,
    final typCoo=CHI.typCoo,
    final nCoo=CHI.nCoo,
    final have_varPumConWat=CHI.have_varPumConWat,
    final typEco=CHI.typEco,
    final typCtlHea=CHI.ctl.typCtlHea,
    final typMeaCtlChiWatPri=CHI.ctl.typMeaCtlChiWatPri,
    final have_senDpChiWatLoc=CHI.ctl.have_senDpChiWatLoc,
    final nSenDpChiWatRem=CHI.ctl.nSenDpChiWatRem,
    final nLooChiWatSec=CHI.ctl.nLooChiWatSec,
    final have_senVChiWatSec=CHI.ctl.have_senVChiWatSec,
    final have_senLevCoo=CHI.ctl.have_senLevCoo,
    final rhoChiWat_default=CHI.rhoChiWat_default,
    final rhoConWat_default=CHI.rhoCon_default,
    chi(
      mConAirChi_flow_nominal=_CHI.ctl.capChi_nominal * Buildings.Templates.Data.Defaults.mConAirByCapChi,
      dpChiWatChi_nominal=fill(Buildings.Templates.Data.Defaults.dpChiWatChi, _CHI.nChi),
      TConAirChiEnt_nominal=fill(Buildings.Templates.Data.Defaults.TConAirEnt, _CHI.nChi),
      redeclare Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled per),
    ctl(
      TChiWatChiSup_nominal=fill(Buildings.Templates.Data.Defaults.TChiWatSup, _CHI.nChi),
      TConWatChiRet_nominal=fill(Buildings.Templates.Data.Defaults.TConWatRet, _CHI.nChi),
      TConWatChiSup_nominal=fill(Buildings.Templates.Data.Defaults.TConWatSup, _CHI.nChi),
      TOutLoc=250,
      dpChiWatLocSet_min=Buildings.Templates.Data.Defaults.dpChiWatSet_min,
      dpChiWatRemSet_min=fill(Buildings.Templates.Data.Defaults.dpChiWatSet_min, _CHI.nSenDpChiWatRem),
      VChiWatChi_flow_nominal=
        _CHI.ctl.capChi_nominal / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq ./
        (Buildings.Templates.Data.Defaults.TChiWatRet .- _CHI.ctl.TChiWatChiSup_nominal) /
        _CHI.rhoChiWat_default,
      VChiWatChi_flow_min=0.3 * _CHI.ctl.VChiWatChi_flow_nominal,
      VConWatChi_flow_nominal=
        _CHI.ctl.capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiWatCoo) /
        Buildings.Utilities.Psychrometrics.Constants.cpWatLiq /
        (Buildings.Templates.Data.Defaults.TConWatRet-
        Buildings.Templates.Data.Defaults.TConWatSup) / _CHI.rhoConWat_default,
      dTLifChi_min=fill(Buildings.Templates.Data.Defaults.dTLifChi_min, _CHI.nChi),
      dTLifChi_nominal=_CHI.ctl.TConWatChiRet_nominal .- _CHI.ctl.TChiWatChiSup_nominal,
      capChi_nominal=fill(1E6, _CHI.nChi),
      VChiWatPri_flow_nominal=sum(_CHI.ctl.VChiWatChi_flow_nominal),
      VChiWatSec_flow_nominal={1.1 * _CHI.ctl.VChiWatPri_flow_nominal},
      capUnlChi_min=0.15 * _CHI.ctl.capChi_nominal,
      dTAppEco_nominal=Buildings.Templates.Data.Defaults.TChiWatEcoLvg-
        Buildings.Templates.Data.Defaults.TConWatEcoEnt,
      TWetBulCooEnt_nominal=Buildings.Templates.Data.Defaults.TWetBulTowEnt,
      dTAppCoo_nominal=Buildings.Templates.Data.Defaults.TConWatSup-
        Buildings.Templates.Data.Defaults.TWetBulTowEnt,
      VChiWatEco_flow_nominal=sum(_CHI.ctl.VChiWatChi_flow_nominal[1:2]),
      VConWatEco_flow_nominal=sum(_CHI.ctl.VConWatChi_flow_nominal[1:2]),
      dpChiWatEco_nominal=Buildings.Templates.Data.Defaults.dpChiWatEco,
      hLevAlaCoo_max=0.3,
      hLevAlaCoo_min=0.05,
      hLevCoo_min=0.1,
      hLevCoo_max=0.2,
      dpChiWatRemSet_nominal=fill(Buildings.Templates.Data.Defaults.dpChiWatSet_max, _CHI.nSenDpChiWatRem),
      dpChiWatLocSet_nominal=Buildings.Templates.Data.Defaults.dpChiWatLocSet_max,
      yPumConWatSta_nominal=fill(1, _CHI.ctl.nSta),
      yValConWatChiIso_min=0,
      yPumConWat_min=0.1,
      yPumChiWatEco_nominal=1.0,
      yPumChiWatPriSta_nominal=fill(1, _CHI.ctl.nSta),
      yPumChiWatPriSta_min=fill(0.3, _CHI.ctl.nSta),
      yPumChiWatPri_min=0.1,
      yPumChiWatSec_min=0.1,
      yFanCoo_min=0,
      sta=if _CHI.typEco<>Buildings.Templates.ChilledWaterPlants.Types.Economizer.None then
      [0,0,0; 0,0,1; 1,0,0; 1,0,1; 1,1,0; 1,1,1] else
      [0,0; 1,0; 1,1]),
    pumChiWatPri(
      dp_nominal=fill((if CHI.typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
       then max(_CHI.chi.dpChiWatChi_nominal) else sum(_CHI.chi.dpChiWatChi_nominal)) * 1.5, _CHI.nPumChiWatPri) +
       fill((if _CHI.typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only or
       _CHI.typDisChiWat==Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only then
       _CHI.ctl.dpChiWatLocSet_nominal else 0), _CHI.nChi)),
    pumChiWatSec(
      dp_nominal=fill(_CHI.ctl.dpChiWatLocSet_nominal, _CHI.nPumChiWatSec)),
    eco(
      cap_nominal=0.6 * sum(_CHI.ctl.capChi_nominal[1:2]),
      TChiWatEnt_nominal=Buildings.Templates.Data.Defaults.TChiWatEcoEnt,
      TConWatEnt_nominal=Buildings.Templates.Data.Defaults.TConWatEcoEnt,
      dpChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatEco,
      dpConWat_nominal=Buildings.Templates.Data.Defaults.dpConWatEco,
      dpPumChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatEco))
    "CHW plant parameters";
  annotation (Documentation(info="<html>
<p>
This class provides system parameters for the validation
of air-cooled chiller plant models.
</p>
</html>"));
end AllSystemsAirCooled;
