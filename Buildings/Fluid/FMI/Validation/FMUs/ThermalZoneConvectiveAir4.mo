within Buildings.Fluid.FMI.Validation.FMUs;
block ThermalZoneConvectiveAir4 "Validation of simple thermal zone"
  extends Buildings.Fluid.FMI.Validation.FMUs.ThermalZoneConvectiveAir1(
    redeclare package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}),
    allowFlowReversal = false);
  annotation (Documentation(info="<html>
<p>
This example validates that 
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective\">
Buildings.Fluid.FMI.ExportContainers.ThermalZoneConvective
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Validation/FMUs/ThermalZoneConvectiveAir4.mos"
        "Export FMU"));
end ThermalZoneConvectiveAir4;
