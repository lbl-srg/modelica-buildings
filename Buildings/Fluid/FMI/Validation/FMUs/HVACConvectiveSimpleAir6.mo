within Buildings.Fluid.FMI.Validation.FMUs;
block HVACConvectiveSimpleAir6
  "Validation model for the convective HVAC system"
  extends HVACConvectiveAir1(
    redeclare package Medium = Modelica.Media.Air.SimpleAir(extraPropertiesNames={"CO2", "VOC"}),
    allowFlowReversal = false);
annotation (
    Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACConvective\">
Buildings.Fluid.FMI.ExportContainers.HVACConvective</a>
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Validation/FMUs/HVACConvectiveSimpleAir6.mos"
        "Export FMU"));
end HVACConvectiveSimpleAir6;
