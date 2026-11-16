within Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data;
class AirToWaterPolyvalent
  "Top-level (whole building) system parameters"
  extends Buildings.Templates.Plants.HeatPumps.Validation.UserProject.Data.BaseAirToWater(
    pla(
      hp(
        mHeaWatPhp_flow_nominal=pla.hp.capHeaPhp_nominal / abs(
          pla.ctl.THeaWatSup_nominal -
            Buildings.Templates.Data.Defaults.THeaWatRetMed) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        mChiWatPhp_flow_nominal=pla.hp.capCooPhp_nominal / abs(
          pla.ctl.TChiWatSup_nominal -
            Buildings.Templates.Data.Defaults.TChiWatRet) /
          Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
        dpHeaWatPhp_nominal=Buildings.Templates.Data.Defaults.dpHeaWatHp * 0.8,
        dpChiWatPhp_nominal=Buildings.Templates.Data.Defaults.dpChiWatChi * 0.8,
        TSouHeaPhp_nominal=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
        TSouCooPhp_nominal=Buildings.Templates.Data.Defaults.TOutHpCoo,
        perPhp(
          fileNameHea=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Heating.txt"),
          fileNameCoo=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_Cooling.txt"),
          fileNameShc=Modelica.Utilities.Files.loadResource(
            "modelica://Buildings/Resources/Data/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/BaseClasses/Validation/AWHP_SHC.txt")),
        PPhp_min=1.0E3),
      ctl(
        capHeaPhp_nominal=500E3,
        capCooPhp_nominal=500E3,
        capCooShcPhp_nominal=500E3,
        capHeaShcPhp_nominal=500E3,
        yPumHeaWatPriDedPhpSet=0.65,
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
end AirToWaterPolyvalent;
