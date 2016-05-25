within Buildings.Fluid.FMI.Validation.FMUs;
block HVACConvectiveAir2 "Validation model for the convective HVAC system"
  extends HVACConvectiveAir1(
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Validation/FMUs/HVACConvectiveAir2.mos"
        "Export FMU"));
end HVACConvectiveAir2;
