within Buildings.Templates.ChilledWaterPlants.Validation;
model BaseAirCooled "Base model for validating CHW plant template with water-cooled chillers"
  extends Buildings.Templates.ChilledWaterPlants.Validation.BaseWaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystemsAirCooled datAll,
    redeclare Buildings.Templates.ChilledWaterPlants.AirCooled CHI(
      redeclare package MediumCon = MediumAir,
      typArrChi_select=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
      typArrPumChiWatPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only,
      chi(typValChiWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
          typValConWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayModulating)));

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

end BaseAirCooled;
