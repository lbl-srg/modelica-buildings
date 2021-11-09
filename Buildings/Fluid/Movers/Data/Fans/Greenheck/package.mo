within Buildings.Fluid.Movers.Data.Fans;
package Greenheck "Package with performance data for fans of Greenheck"
  extends Modelica.Icons.Package;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains performance data for Greenheck fans.
The data are taken from
<a href=\"https://content.greenheck.com/public/DAMProd/Original/10002/CentrifugalDWPerfSuppl_catalog.pdf\">
https://content.greenheck.com/public/DAMProd/Original/10002/CentrifugalDWPerfSuppl_catalog.pdf</a>.
The highest available speed on the graphs is selected as the nominal speed.
The volumetric flow rates and static pressures are extracted by plot digitiser. 
The powers are read from the graphs approximately. 
Note that in the actual names of each fan,
the number precedes the letters (e.g. \"12 BIDW\"). 
They have to be reversed in class names of the records. 
</p>
</html>"));
end Greenheck;
