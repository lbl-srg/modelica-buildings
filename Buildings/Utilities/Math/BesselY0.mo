within Buildings.Utilities.Math;
block BesselY0 "Bessel function of the second kind of order 0, Y0"
  extends Modelica.Blocks.Interfaces.SISO;
equation
  y = Buildings.Utilities.Math.Functions.besselY0(x=u);
  annotation (defaultComponentName="Y0",
  Documentation(info="<html>
  <p>This block computes the bessel function of the second kind of order 0, Y0.</p>
</html>", revisions="<html>
<ul>
<li>July 17, 2018, by Massimo Cimmino:<br/>First implementation. </li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="besselY0()")}));
end BesselY0;
