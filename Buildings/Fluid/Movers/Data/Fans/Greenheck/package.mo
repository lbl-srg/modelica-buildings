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
The volumetric flow rates and static pressures were extracted by plot digitiser. 
The powers were read from the graphs approximately. 
Note that in the actual names of each fan,
the number precedes the letters (e.g. \"12 BIDW\"). 
They had to be reversed in class names of the records. 
</p>
</html>"));
end Greenheck;
