within Buildings.Templates.Plants.Chillers.Validation;
model AirCooled
  "Validation of air-cooled chiller plant template"
  extends Buildings.Templates.Plants.Chillers.Validation.WaterCooled(
    redeclare Buildings.Templates.Plants.Chillers.Validation.UserProject.Data.AllSystemsAirCooled datAll,
    redeclare Buildings.Templates.Plants.Chillers.AirCooled pla(
      redeclare package MediumCon=MediumAir));

  replaceable package MediumAir = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
annotation(experiment(StartTime=19612800,
  StopTime=19699200,
  Tolerance=1e-06),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Validation/AirCooled.mos"
      "Simulate and plot"),
  Documentation(
    revisions="<html>
<ul>
  <li>
    September 1, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>",
    info="<html>
<p>
  This model validates
  <a href=\"modelica://Buildings.Templates.Plants.Chillers.AirCooled\">
    Buildings.Templates.Plants.Chillers.AirCooled</a> by simulating a
  <i>24</i>-hour period during which the cooling loads reach their peak value.
</p>
<p>
  Two equally sized chillers are modeled. A unique aggregated load is modeled
  on the CHW loop using a heat exchanger component exposed to conditioned
  space air, and a two-way modulating valve. An importance multiplier of
  <i>10</i> is applied to the plant requests and reset requests generated from
  the valve position.
</p>
<p>
  Advanced equipment and control options can be modified via the parameter
  dialog of the plant component.
</p>
</html>"));
end AirCooled;
