within Buildings.Utilities.Math;
block Factorial "Factorial function"
  extends Modelica.Blocks.Interfaces.IntegerSO;
  Modelica.Blocks.Interfaces.IntegerInput u "Connector of integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
equation
  y = Buildings.Utilities.Math.Functions.factorial(n=u);
  annotation (
    defaultComponentName="fac", Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="factorial()")}),
    Documentation(info="<html>
    <p>This block computes the factorial of the integer input, <i>y=n!</i>.</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>First implementation.
</li>
</ul>
</html>"));
end Factorial;
