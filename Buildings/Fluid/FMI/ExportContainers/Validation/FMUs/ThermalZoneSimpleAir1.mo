within Buildings.Fluid.FMI.ExportContainers.Validation.FMUs;
block ThermalZoneSimpleAir1 "Validation of simple thermal zone"
  extends Buildings.Fluid.FMI.ExportContainers.Validation.FMUs.ThermalZoneAir1(
    redeclare package Medium = Modelica.Media.Air.SimpleAir);
  annotation (Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZone\">
Buildings.Fluid.FMI.ExportContainers.ThermalZone
</a>
exports correctly as an FMU.
</p>
</html>", revisions="<html>
<ul>
<li>
May 03, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/ThermalZoneSimpleAir1.mos"
        "Export FMU"));
end ThermalZoneSimpleAir1;
