within Buildings.Templates.ZoneEquipment.Components.Controls;
block G36VAVBoxCoolingOnly
  "Guideline 36 controller for VAV terminal unit cooling only"
  extends
    Buildings.Templates.ZoneEquipment.Components.Interfaces.ControllerG36VAVBox(
    final typ=Buildings.Templates.ZoneEquipment.Types.Controller.G36VAVBoxCoolingOnly);

  annotation (
    defaultComponentName="ctl",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Description</h4>
<p>
This is an implementation of the control sequence specified in
<a href=\"#ASHRAE2021\">ASHRAE (2021)</a>
for cooling-only VAV terminal units.
It contains the following components.
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Controller</a>:
Main controller for the terminal unit
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.Setpoints</a>:
Computation of the zone temperature setpoints
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus</a>:
Computation of the zone warm-up and cooldown time
</li>
</ul>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));
end G36VAVBoxCoolingOnly;
