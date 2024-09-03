within Buildings.Utilities.Math;
block BesselJ1 "Bessel function of the first kind of order 1, J1"
  extends Modelica.Blocks.Interfaces.SISO;
equation
  y = Buildings.Utilities.Math.Functions.besselJ1(x=u);
  annotation (defaultComponentName="J1",
  Documentation(info="<html>
  <p>This block computes the bessel function of the first kind of order 1, J1.</p>
</html>", revisions="<html>
<ul>
<li>July 17, 2018, by Massimo Cimmino:<br/>First implementation. </li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="besselJ1()")}));
end BesselJ1;
