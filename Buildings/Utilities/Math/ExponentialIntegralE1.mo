within Buildings.Utilities.Math;
block ExponentialIntegralE1 "Exponential integral function, E1"
  extends Modelica.Blocks.Interfaces.SISO;
equation
  y = Buildings.Utilities.Math.Functions.exponentialIntegralE1(x=u);
  annotation (defaultComponentName="E1",
  Documentation(info="<html>
  <p>This block computes the exponential integral, E1.</p>
</html>", revisions="<html>
<ul>
<li>July 17, 2018, by Massimo Cimmino:<br/>First implementation. </li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="exponentialIntegralE1()")}));
end ExponentialIntegralE1;
