within Buildings.Air.Systems.SingleZone.VAV.Examples;
package OptimalStart "Example models of the block OptimalStart"
extends Modelica.Icons.ExamplesPackage;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains example models that integrate the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a> with a single-zone VAV system,
and base classes used by the example models.
</p>
<p>
There are two sets of example models: one set uses a conventional controller
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerChillerDXHeatingEconomizer\">
Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerChillerDXHeatingEconomizer</a>;
the other set uses a controller based on Guideline36
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller</a>.
</p>
<p>
Both sets of examples use the same single-zone building model
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor\">
Buildings.ThermalZones.Detailed.Validation.BaseClasses.SingleZoneFloor</a> and the
same single-zone VAV system
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer\">
Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer</a>.
</p>
<p>
Each set of example models validates three different seasonal conditions: spring,
summer and winter.
</p>
</html>"));
end OptimalStart;
