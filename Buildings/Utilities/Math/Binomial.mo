within Buildings.Utilities.Math;
block Binomial "Binomial function"
  extends Modelica.Blocks.Interfaces.IntegerSO;
  Modelica.Blocks.Interfaces.IntegerInput n "Size of set" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.IntegerInput k "Size of subsets" annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}})));
equation
  y = Buildings.Utilities.Math.Functions.binomial(n=n, k=k);
  annotation (
    defaultComponentName="bin", Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="binomial()")}),
    Documentation(info="<html>
    <p>This block computes the binomial coefficient \"n choose k\".</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2018, by Massimo Cimmino:<br/>First implementation.
</li>
</ul>
</html>"));
end Binomial;
