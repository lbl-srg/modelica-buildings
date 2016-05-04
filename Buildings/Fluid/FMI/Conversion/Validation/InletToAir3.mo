within Buildings.Fluid.FMI.Conversion.Validation;
model InletToAir3
  "Validation model for inlet to Modelica.Media.Air.SimpleAir conversion without trace substances"
  extends InletToAir1( redeclare package Medium = Modelica.Media.Air.SimpleAir);
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
without trace substances.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2016 by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/InletToAir3.mos"
        "Simulate and plot"));
end InletToAir3;
