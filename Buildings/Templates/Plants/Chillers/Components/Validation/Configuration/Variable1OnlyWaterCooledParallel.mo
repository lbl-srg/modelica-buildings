within Buildings.Templates.Plants.Chillers.Components.Validation.Configuration;
record Variable1OnlyWaterCooledParallel
  "Default configuration parameters for primary-only parallel water-cooled chiller plant"
  extends Buildings.Templates.Plants.Chillers.Components.Validation.Configuration.Variable1OnlyAirCooledParallel(
    cpCon_default=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq,
    nCoo=nChi,
    nPumConWat=nChi,
    rhoCon_default=Buildings.Media.Water.d_const,
    typChi=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    typCoo=Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen,
    typValConWatChiIso=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition);
end Variable1OnlyWaterCooledParallel;
