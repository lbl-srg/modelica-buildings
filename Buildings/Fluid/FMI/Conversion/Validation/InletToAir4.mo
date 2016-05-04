within Buildings.Fluid.FMI.Conversion.Validation;
model InletToAir4
  "Validation model for inlet to Modelica.Media.Air.SimpleAir air conversion with C02 trace substances"
  extends InletToAir1( redeclare package Medium =  Modelica.Media.Air.SimpleAir(extraPropertiesNames={"CO2"}));
    annotation (
    Documentation(info="<html>
<p>
This example validates the conversion model
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.InletToAir\">
Buildings.Fluid.FMI.Conversion.InletToAir
</a>. 
The medium used is 
<a href=\"modelica://Modelica.Media.Air.SimpleAir\">
Modelica.Media.Air.SimpleAir
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/InletToAir4.mos"
        "Simulate and plot"));
end InletToAir4;
