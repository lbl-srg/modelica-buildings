within Buildings.Fluid.FMI.ExportContainers.Validation.FMUs;
block HVACConvectiveSingleZoneSimpleAir6
  "Validation model for the convective HVAC system"
  extends HVACConvectiveAir1(
    redeclare package Medium = Modelica.Media.Air.SimpleAir(extraPropertiesNames={"CO2", "VOC"}),
    allowFlowReversal = false);
annotation (
    Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone\">
Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone</a>
exports correctly as an FMU.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2016 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/HVACConvectiveSingleZoneSimpleAir6.mos"
        "Export FMU"));
end HVACConvectiveSingleZoneSimpleAir6;
