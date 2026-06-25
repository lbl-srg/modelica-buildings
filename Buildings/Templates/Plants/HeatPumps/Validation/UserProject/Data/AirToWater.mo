within Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data;
class AirToWater
  "Top-level (whole building) system parameters"
  extends Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data.BaseAirToWater(
    pla(
      hp(
        dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
        mHeaWatHp_flow_nominal=pla.hp.capHeaHp_nominal / abs(
          pla.ctl.THeaWatSup_nominal -
            Buildings.Templates.Data.Defaults.THeaWatRetMed) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        mChiWatHp_flow_nominal=pla.hp.capCooHp_nominal / abs(
          pla.ctl.TChiWatSup_nominal -
            Buildings.Templates.Data.Defaults.TChiWatRet) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
        TSouCooHp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
        perHeaHp(
          fileName=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Heating.txt"),
          PLRSup={1},
          use_TEvaOutForTab=false,
          use_TConOutForTab=true,
          tabUppBou=[263.15, 325.15; 313.15, 325.15]),
        perCooHp(
          fileName=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Templates/Components/HeatPumps/Validation/AWHP_Cooling.txt"),
          PLRSup={1},
          use_TEvaOutForTab=true,
          use_TConOutForTab=false),
        PHp_min=1.0E3),
      hrc(
        cap_nominal=500E3,
        dpChiWat_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi,
        dpCon_nominal=Buildings.Templates.Data.Defaults.dpConWatChi,
        mChiWat_flow_nominal=pla.hrc.cap_nominal / abs(
          pla.ctl.TChiWatSup_nominal -
            Buildings.Templates.Data.Defaults.TChiWatRet) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        mCon_flow_nominal=pla.hrc.cap_nominal * (1 + 1 /
          (pla.ctl.COPHeaHrc_nominal - 1)) / abs(
          pla.ctl.THeaWatSup_nominal -
            Buildings.Templates.Data.Defaults.THeaWatRetMed) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        TCon_nominal=pla.ctl.THeaWatSup_nominal,
        per(
          fileName=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/Examples/TableData2DLoadDep_Chiller.txt"),
          PLRSup={0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.9, 1.0},
          PLRCyc_min=0.2,
          use_TEvaOutForTab=true,
          use_TConOutForTab=true),
        P_min=50),
      ctl(
        capHeaHp_nominal=500E3,
        capCooHp_nominal=500E3,
        TChiWatSupHrc_min=Buildings.Templates.Data.Defaults.TChiWatSup_min,
        THeaWatSupHrc_max=pla.ctl.THeaWatSup_nominal + 5,
        COPHeaHrc_nominal=4.6,
        capCooHrc_min=pla.hrc.cap_nominal * pla.hrc.per.PLRCyc_min,
        capHeaHrc_min=(1 + 1 / (pla.ctl.COPHeaHrc_nominal - 1)) *
          pla.ctl.capCooHrc_min,
        staHp={fill(i / pla.cfg.nHp, pla.cfg.nHp) for i in 1:pla.cfg.nHp},
        yPumHeaWatPriDedHpSet=0.57,
        yPumChiWatPriDedHpSet=0.90)));
annotation(defaultComponentPrefixes="inner parameter",
  defaultComponentName="datAll",
  Documentation(
    info="<html>
<p>
  This class provides the set of sizing and operating parameters for the whole
  HVAC system. It is aimed for validation purposes only.
</p>
</html>"));
end AirToWater;
