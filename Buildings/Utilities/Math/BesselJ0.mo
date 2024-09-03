within Buildings.Utilities.Math;
block BesselJ0 "Bessel function of the first kind of order 0, J0"
  extends Modelica.Blocks.Interfaces.SISO;
equation
  y = Buildings.Utilities.Math.Functions.besselJ0(x=u);
  annotation (defaultComponentName="J0",
  Documentation(info="<html>
  <p>This block computes the bessel function of the first kind of order 0, J0.</p>
</html>", revisions="<html>
<ul>
<li>July 17, 2018, by Massimo Cimmino:<br/>First implementation. </li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="besselJ0()")}));
end BesselJ0;
