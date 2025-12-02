within Buildings.Templates.Plants.Chillers.Validation;
model AirCooled
  "Validation of air-cooled chiller plant template"
  extends Buildings.Templates.Plants.Chillers.Validation.WaterCooled(
    redeclare Buildings.Templates.Plants.Chillers.Validation.UserProject.Data.AllSystemsAirCooled datAll,
    redeclare Buildings.Templates.Plants.Chillers.AirCooled pla(
      redeclare package MediumCon = MediumAir));

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  annotation (
  experiment(
    StartTime=19612800,
    StopTime=19615000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Chillers/Validation/AirCooled.mos"
  "Simulate and plot"),
  Documentation(revisions="<html>
<ul>
<li>
August 8, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Chillers.AirCooled\">
Buildings.Templates.Plants.Chillers.AirCooled</a>
by simulating a <i>24</i>-hour period during which the cooling loads reach
their peak value.
</p>
<p>
Two equally sized chillers are modeled.
A unique aggregated load is modeled on the CHW loop by means of a heating
component controlled to maintain a constant <i>&Delta;T</i>,
and a modulating valve controlled to track a prescribed flow rate.
An importance multiplier of <i>10</i> is applied to the plant requests
and reset requests generated from the valve position.
</p>
<p>
Advanced equipment and control options can be modified via the parameter
dialog of the plant component.
</p>
</html>"));
end AirCooled;
