within Buildings.Templates.ChilledWaterPlants.Validation;
model AirCooledOpenLoop
  "Validation of air-cooled chiller plant template with open-loop controls"
  extends Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop(
    redeclare Buildings.Templates.ChilledWaterPlants.Validation.UserProject.Data.AllSystemsAirCooled datAll,
    redeclare Buildings.Templates.ChilledWaterPlants.AirCooled CHI(
      redeclare package MediumCon = MediumAir,
      typArrChi_select=Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel,
      typArrPumChiWatPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated,
      typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only,
      chi(typValChiWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayModulating,
          typValConWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayModulating)),
    bou(T=Buildings.Templates.Data.Defaults.TChiWatRet));

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  annotation (
  experiment(
    StartTime=19612800,
    StopTime=19615000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/ChilledWaterPlants/Validation/AirCooledOpenLoop.mos"
  "Simulate and plot"),
  Documentation(revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a validation model for the air-cooled chiller plant model
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.AirCooled\">
Buildings.Templates.ChilledWaterPlants.AirCooled</a>
with open-loop controls.
</p>
<p>
It is intended to check that the plant model is well-defined for
various plant configurations.
However, due to the open-loop controls a correct physical behavior
is not expected.
</p>
</html>"));
end AirCooledOpenLoop;
