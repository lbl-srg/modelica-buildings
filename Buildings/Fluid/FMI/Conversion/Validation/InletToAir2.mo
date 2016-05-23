within Buildings.Fluid.FMI.Conversion.Validation;
model InletToAir2
  "Validation model for inlet to Buildings.Media.Air conversion with C02 trace substances"
  extends InletToAir1(
    redeclare package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}));
  annotation (
    Documentation(info="<html>
<p>
This example validates the conversion model
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.InletToAir\">
Buildings.Fluid.FMI.Conversion.InletToAir
</a>. 
The medium used is 
<a href=\"modelica://Buildings.Media.Air\">
Buildings.Media.Air
</a>
with <code>C02</code> trace substances.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2016 by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/InletToAir2.mos"
        "Simulate and plot"));
end InletToAir2;
