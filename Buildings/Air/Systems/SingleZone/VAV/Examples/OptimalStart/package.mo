within Buildings.Air.Systems.SingleZone.VAV.Examples;
package OptimalStart "Example models of the block OptimalStart"
extends Modelica.Icons.ExamplesPackage;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains example models that integrate the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a> with a single-zone VAV system.
The two example models use the same single-zone building model
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor\">
Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor</a> and the
same single-zone VAV system
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer\">
Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer</a>.
For the control system, one example uses a conventional controller
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizerController\">
Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizerController</a>,
while the other uses a controller based on Guideline36
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller</a>.
</p>
</html>"));
end OptimalStart;
