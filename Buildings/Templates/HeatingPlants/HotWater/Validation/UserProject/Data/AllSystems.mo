within Buildings.Templates.HeatingPlants.HotWater.Validation.UserProject.Data;
class AllSystems
  "Design and operating parameters for testing purposes"
  extends Buildings.Templates.Data.AllSystems;

  // The following instance name matches the system tag.
  outer Buildings.Templates.HeatingPlants.HotWater.BoilerPlant BOI;

  parameter Buildings.Templates.HeatingPlants.HotWater.Data.BoilerPlant _BOI(
    final have_boiCon=BOI.have_boiCon,
    final have_boiNon=BOI.have_boiNon,
    final nBoiCon=BOI.nBoiCon,
    final nBoiNon=BOI.nBoiNon,
    final typPumHeaWatSec=BOI.typPumHeaWatSec,
    final nPumHeaWatPriCon=BOI.nPumHeaWatPriCon,
    final nPumHeaWatPriNon=BOI.nPumHeaWatPriNon,
    final nPumHeaWatSec=BOI.nPumHeaWatSec,
    final have_valHeaWatMinByp=BOI.have_valHeaWatMinByp,
    final have_senDpHeaWatLoc=BOI.ctl.have_senDpHeaWatLoc,
    final nSenDpHeaWatRem=BOI.ctl.nSenDpHeaWatRem,
    final nLooHeaWatSec=BOI.ctl.nLooHeaWatSec,
    final have_senVHeaWatSec=BOI.ctl.have_senVHeaWatSec,
    final typCtl=BOI.typCtl,
    final rho_default=BOI.rho_default,
    boiCon,
    boiNon,
    ctl(
      THeaWatSup_nominal=Buildings.Templates.Data.Defaults.THeaWatSup,
      THeaWatConSup_nominal=Buildings.Templates.Data.Defaults.THeaWatConSup,
      TOutLoc=Buildings.Templates.Data.Defaults.THeaWatSup,
      dpHeaWatLocSet_min=Buildings.Templates.Data.Defaults.dpHeaWatSet_min,
      dpHeaWatRemSet_min=fill(Buildings.Templates.Data.Defaults.dpHeaWatSet_min, _BOI.nSenDpHeaWatRem),
      VHeaWatBoiCon_flow_nominal=_BOI.ctl.capBoiCon_nominal /
        Buildings.Utilities.Psychrometrics.Constants.cpWatLiq ./
        (_BOI.ctl.THeaWatConSup_nominal - Buildings.Templates.Data.Defaults.THeaWatConRet) /
        _BOI.rho_default,
      VHeaWatBoiCon_flow_min=0.1 * _CHI.ctl.VHeaWatBoiCon_flow_nominal,
      VHeaWatBoiNon_flow_nominal=_BOI.ctl.capBoiNon_nominal /
        Buildings.Utilities.Psychrometrics.Constants.cpWatLiq ./
        (_BOI.ctl.THeaWatSup_nominal - Buildings.Templates.Data.Defaults.THeaWatConRet) /
        _BOI.rho_default,
      VHeaWatBoiNon_flow_min=0.1 * _CHI.ctl.VHeaWatBoiNon_flow_nominal,
      capBoiCon_nominal=fill(1E6, _BOI.nBoiCon),
      capBoiNon_nominal=fill(1E6, _BOI.nBoiNon),
      VHeaWatPriCon_flow_nominal=BOI.VHeaWatPriCon_flow_nominal,
      VHeaWatPriNon_flow_nominal=BOI.VHeaWatPriNon_flow_nominal,
      dpHeaWatRemSet_nominal=fill(Buildings.Templates.Data.Defaults.dpHeaWatSet_max, _BOI.nSenDpHeaWatRem),
      dpHeaWatLocSet_nominal=Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
      yPumHeaWatPri_min=0.1,
      yPumHeaWatSec_min=0.1),
    pumHeaWatPriCon(
      dp_nominal=fill(max(_BOI.boiCon.dpHeaWatBoiCon_nominal) * 1.5, _BOI.nPumHeaWatPriCon) +
       fill((if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None then
       _BOI.ctl.dpHeaWatLocSet_nominal else 0), _BOI.nPumHeaWatPriCon)),
    pumHeaWatPriNon(
      dp_nominal=fill(max(_BOI.boiNon.dpHeaWatBoiNon_nominal) * 1.5, _BOI.nPumHeaWatPriNon) +
       fill((if typPumHeaWatSec==Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None then
       _BOI.ctl.dpHeaWatLocSet_nominal else 0), _BOI.nPumHeaWatPriNon)),
    pumHeaWatSec(
      dp_nominal=fill(_BOI.ctl.dpHeaWatLocSet_nominal, _BOI.nPumHeaWatSec),
      m_flow_nominal=1.1 / _BOI.nPumHeaWatSec *
        fill(max(sum(_BOI.pumHeaWatPriCon.m_flow_nominal), sum(_BOI.pumHeaWatPriNon.m_flow_nominal)),
        _BOI.nPumHeaWatSec)))
    "CHW plant parameters";
  annotation (Documentation(info="<html>
<p>
This class provides system parameters for the validation
of air-cooled chiller plant models.
</p>
</html>"));
end AllSystems;
