within Buildings.Fluid.FMI.Conversion.Validation;
model InletToAirDryAirCO2
  "Validation model for inlet to air with dry air medium and CO2"
  extends Buildings.Fluid.FMI.Conversion.Validation.InletToAirMoistAirCO2(
    redeclare replaceable package Medium = Modelica.Media.Air.SimpleAir(extraPropertiesNames={"CO2"}));
  annotation (Documentation(info="<html>
<p>
This validation test is identical to
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.Validation.InletToAirMoistAirCO2\">
Buildings.Fluid.FMI.Conversion.Validation.InletToAirMoistAirCO2</a>
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/InletToAirDryAirCO2.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0));
end InletToAirDryAirCO2;
