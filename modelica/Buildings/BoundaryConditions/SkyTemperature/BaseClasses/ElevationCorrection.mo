within Buildings.BoundaryConditions.SkyTemperature.BaseClasses;
block ElevationCorrection "Elevation correction for emissivity"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput p(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar") "Air pressure"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput eleCor "Elevation correction"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  eleCor = 0.00012*(p/100 - 1000);
  annotation (
    defaultComponentName="elecor",
    Documentation(info="<HTML>
<p>
This component computes the elevation correction.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255})}));
end ElevationCorrection;
