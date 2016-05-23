within Buildings.Fluid.FMI.Adaptors.FMUs.Validation;
block RoomConvectiveMoistAir1 "Validation of simple thermal zone"
  extends RoomConvectiveAir1(
    redeclare package Medium = Modelica.Media.Air.MoistAir,
    allowFlowReversal = true);
  annotation (Documentation(info="<html>
<p>
This example validates that 
<a href=\"modelica://Buildings.Fluid.FMI.RoomConvective\">
Buildings.Fluid.FMI.RoomConvective
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/FMUs/Validation/RoomConvectiveMoistAir1.mos"
        "Export FMU"));
end RoomConvectiveMoistAir1;
