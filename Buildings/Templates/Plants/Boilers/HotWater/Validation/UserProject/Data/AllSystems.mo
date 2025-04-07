within Buildings.Templates.Plants.Boilers.HotWater.Validation.UserProject.Data;
class AllSystems
  "Design and operating parameters for testing purposes"
  extends Buildings.Templates.Data.AllSystems(
    ashCliZon=Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified,
    stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1,
    stdEne=Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1,
    sysUni=Buildings.Templates.Types.Units.SI);

  parameter Buildings.Templates.Plants.Boilers.HotWater.Data.BoilerPlant pla(
    boiCon(
      fue=Buildings.Fluid.Data.Fuels.NaturalGasHigherHeatingValue(),
      dpHeaWatBoi_nominal=fill(Buildings.Templates.Data.Defaults.dpHeaWatBoi,
          pla.cfg.nBoiCon),
      mHeaWatBoi_flow_nominal=pla.ctl.capBoiCon_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
           ./ (pla.ctl.THeaWatConSup_nominal - Buildings.Templates.Data.Defaults.THeaWatRet)),
    boiNon(
      fue=Buildings.Fluid.Data.Fuels.NaturalGasHigherHeatingValue(),
      dpHeaWatBoi_nominal=fill(Buildings.Templates.Data.Defaults.dpHeaWatBoi,
          pla.cfg.nBoiNon),
      mHeaWatBoi_flow_nominal=pla.ctl.capBoiNon_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
           ./ (pla.ctl.THeaWatSup_nominal - Buildings.Templates.Data.Defaults.THeaWatRet)),
    ctl(
      THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSup,
      THeaWatConSup_nominal=Buildings.Templates.Data.Defaults.THeaWatConSup,
      TOutLck=Buildings.Templates.Data.Defaults.TOutHeaWatLck,
      VHeaWatBoiCon_flow_nominal=pla.boiCon.mHeaWatBoi_flow_nominal/pla.cfg.rhoHeaWat_default,
      VHeaWatBoiCon_flow_min=0.1*pla.ctl.VHeaWatBoiCon_flow_nominal,
      VHeaWatBoiNon_flow_nominal=pla.boiNon.mHeaWatBoi_flow_nominal/pla.cfg.rhoHeaWat_default,
      VHeaWatBoiNon_flow_min=0.1*pla.ctl.VHeaWatBoiNon_flow_nominal,
      ratFirBoiCon_min=fill(0.2, pla.cfg.nBoiCon),
      ratFirBoiNon_min=fill(0.2, pla.cfg.nBoiNon),
      capBoiCon_nominal=fill(1E6, pla.cfg.nBoiCon),
      capBoiNon_nominal=fill(1E6, pla.cfg.nBoiNon),
      VHeaWatPriCon_flow_nominal=sum(pla.ctl.VHeaWatBoiCon_flow_nominal),
      VHeaWatPriNon_flow_nominal=sum(pla.ctl.VHeaWatBoiNon_flow_nominal),
      VHeaWatSec_flow_nominal=max(pla.ctl.VHeaWatPriCon_flow_nominal, pla.ctl.VHeaWatPriNon_flow_nominal)
        /1.1,
      dpHeaWatLocSet_max=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
      dpHeaWatRemSet_max=fill(Buildings.Templates.Data.Defaults.dpHeaWatRemSet_max,
        pla.cfg.nSenDpHeaWatRem),
      yPumHeaWatPri_min=0.1,
      yPumHeaWatSec_min=0.1,
      yPumHeaWatPriSta_min=fill(0.1, size(pla.ctl.sta, 1)),
      sta=[0,0; 1,0; 1,1]),
    pumHeaWatPriCon(dp_nominal=fill(max(pla.boiCon.dpHeaWatBoi_nominal)*1.5,
      pla.cfg.nPumHeaWatPriCon) + fill((
      if pla.cfg.typPumHeaWatSec == Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None
       then pla.ctl.dpHeaWatLocSet_max else 0), pla.cfg.nPumHeaWatPriCon)),
    pumHeaWatPriNon(dp_nominal=fill(max(pla.boiNon.dpHeaWatBoi_nominal)*1.5,
      pla.cfg.nPumHeaWatPriNon) + fill((
       if pla.cfg.typPumHeaWatSec == Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None
       then pla.ctl.dpHeaWatLocSet_max else 0), pla.cfg.nPumHeaWatPriNon)),
    pumHeaWatSec(dp_nominal=fill(pla.ctl.dpHeaWatLocSet_max, pla.cfg.nPumHeaWatSec),
        m_flow_nominal=1.1/max(1, pla.cfg.nPumHeaWatSec)*fill(max(sum(pla.pumHeaWatPriCon.m_flow_nominal),
          sum(pla.pumHeaWatPriNon.m_flow_nominal)), pla.cfg.nPumHeaWatSec)))
    "HW plant parameters";
  annotation (Documentation(info="<html>
<p>
This class provides system parameters for the validation
of the boiler plant model.
</p>
</html>"));
end AllSystems;
