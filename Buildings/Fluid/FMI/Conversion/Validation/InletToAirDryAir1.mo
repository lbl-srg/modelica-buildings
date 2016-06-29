within Buildings.Fluid.FMI.Conversion.Validation;
model InletToAirDryAir1
  "Validation model for inlet to air with dry air medium"
  extends Buildings.Fluid.FMI.Conversion.Validation.InletToAir1(
    redeclare package Medium = Modelica.Media.Air.SimpleAir);
  annotation (Documentation(info="<html>
<p>
This validation test is identical to
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.Validation.InletToAir1\">
Buildings.Fluid.FMI.Conversion.Validation.InletToAir1</a>
except that it uses a medium model without moisture.
Hence, it tests whether the water vapor connectors are correctly removed.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/InletToAirDryAir1.mos"
        "Simulate and plot"),
    experiment(StopTime=1));
end InletToAirDryAir1;
