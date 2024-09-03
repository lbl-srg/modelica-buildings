within Buildings.Utilities.Math;
block FallingFactorial "Falling factorial function"
  extends Modelica.Blocks.Interfaces.IntegerSO;
  Modelica.Blocks.Interfaces.IntegerInput n "Integer number" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.IntegerInput k "Falling factorial power" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}})));
equation
  y = Buildings.Utilities.Math.Functions.fallingFactorial(n=n, k=k);
  annotation (
    defaultComponentName="falFac", Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="fallingFactorial()")}),
    Documentation(info="<html>
    <p>This block computes the falling factorial, <i>y = n<sup>&#7733;</sup></i>.</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>First implementation.
</li>
</ul>
</html>"));
end FallingFactorial;
