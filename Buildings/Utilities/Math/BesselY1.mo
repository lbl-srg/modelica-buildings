within Buildings.Utilities.Math;
block BesselY1 "Bessel function of the second kind of order 1, Y1"
  extends Modelica.Blocks.Interfaces.SISO;
equation
  y = Buildings.Utilities.Math.Functions.besselY1(x=u);
  annotation (defaultComponentName="Y1",
  Documentation(info="<html>
  <p>This block computes the bessel function of the second kind of order 1, Y1.</p>
</html>", revisions="<html>
<ul>
<li>July 17, 2018, by Massimo Cimmino:<br/>First implementation. </li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="besselY1()")}));
end BesselY1;
