within Buildings.Fluid.Movers.Data.Fans;
package Greenheck "Package with performance data for fans of Greenheck"
  extends Modelica.Icons.Package;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains performance data for Greenheck fans.
The data points are digitised from
<a href=\"https://content.greenheck.com/public/DAMProd/Original/10002/CentrifugalDWPerfSuppl_catalog.pdf\">
https://content.greenheck.com/public/DAMProd/Original/10002/CentrifugalDWPerfSuppl_catalog.pdf</a>.
The highest available speeds on the graphs were selected as nominal.
The volumetric flow rates and static pressures were extracted by plot digitiser
(<a href=\"https://apps.automeris.io/wpd/\">https://apps.automeris.io/wpd/</a>).
The powers were read from the graphs approximately using
<a href=\"https://eleif.net/photo_measure.html\">
https://eleif.net/photo_measure.html</a>.
For each pressure-flow rate curve, the points to the left of the highest point
were abandoned to ensure convergence.
See <a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Buildings.Fluid.Movers.UsersGuide</a>
and <a href=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide/2013-IBPSA-Wetter.pdf\">Wetter (2013)</a>
for more information on the convergence considerations.
Also note that in the actual names of each fan,
the number precedes the letters (e.g. \"12 BIDW\").
They had to be reversed in class names of the records.
</p>
</html>"));
end Greenheck;
