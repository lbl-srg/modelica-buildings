within Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data;
class AirToWaterReversiblePolyvalent
  "Top-level (whole building) system parameters"
  extends Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data.BaseAirToWater(
    pla(
      hp(
        mHeaWatHp_flow_nominal=pla.hp.capHeaHp_nominal / abs(
          pla.ctl.THeaWatSup_nominal -
            Buildings.Templates.Data.Defaults.THeaWatRetMed) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        mHeaWatPhp_flow_nominal=pla.hp.capHeaPhp_nominal / abs(
          pla.ctl.THeaWatSup_nominal -
            Buildings.Templates.Data.Defaults.THeaWatRetMed) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        mChiWatHp_flow_nominal=pla.hp.capCooHp_nominal / abs(
          pla.ctl.TChiWatSup_nominal -
            Buildings.Templates.Data.Defaults.TChiWatRet) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        mChiWatPhp_flow_nominal=pla.hp.capCooPhp_nominal / abs(
          pla.ctl.TChiWatSup_nominal -
            Buildings.Templates.Data.Defaults.TChiWatRet) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        dpHeaWatHp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp,
        dpHeaWatPhp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp * 0.8,
        dpChiWatPhp_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi * 0.8,
        TSouHeaHp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
        TSouHeaPhp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
        TSouCooHp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
        TSouCooPhp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
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
        PHp_min=1.0E3,
        perPhp(
          fileNameHea=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
          fileNameCoo=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
          fileNameShc=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")),
        PPhp_min=1.0E3),
      ctl(
        capHeaHp_nominal=500E3,
        capCooHp_nominal=500E3,
        capHeaPhp_nominal=500E3,
        capCooPhp_nominal=500E3,
        capCooShcPhp_nominal=500E3,
        capHeaShcPhp_nominal=500E3,
        yPumHeaWatPriDedHpSet=0.57,
        yPumHeaWatPriDedPhpSet=0.65,
        yPumChiWatPriDedHpSet=0.90,
        yPumChiWatPriDedPhpSet=0.69)));
annotation(defaultComponentPrefixes="inner parameter",
  defaultComponentName="datAll",
  Documentation(
    info="<html>
<p>
  This class provides the set of sizing and operating parameters for the whole
  HVAC system. It is aimed for validation purposes only.
</p>
</html>"));
end AirToWaterReversiblePolyvalent;
