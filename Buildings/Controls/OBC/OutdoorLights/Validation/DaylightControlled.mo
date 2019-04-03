within Buildings.Controls.OBC.OutdoorLights.Validation;
model DaylightControlled "Validation model for the outdoor lighting control based on daylight"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.OutdoorLights.DaylightControlled dayCon(
    lat=0.6457718232379,
    lon=-2.1293016874331,
    timZon=-28800) "Controlling the outdoor lighting based on daylight time"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
annotation (
experiment(StopTime=604800.0, Tolerance=1e-06),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/OutdoorLights/Validation/DaylightControlled.mos"
    "Simulate and plot"),
Documentation(
info="<html>
<p>
This example validates the block
<a href=\"modelica://Buildings.Controls.OBC.OutdoorLights.DaylightControlled\">
Buildings.Controls.OBC.OutdoorLights.DaylightControlled</a>.
The parameters are selected for the location of San Francisco.
</p>
</html>", revisions="<html>
<ul>
<li>
Feb 13, 2019, by Kun Zhang:<br/>
First implemenation.
</li>
</ul>
</html>"));
end DaylightControlled;
