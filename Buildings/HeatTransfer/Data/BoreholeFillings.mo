within Buildings.HeatTransfer.Data;
package BoreholeFillings
  "Package with materials for borehole fillings"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic =
      Buildings.HeatTransfer.Data.BaseClasses.ThermalProperties
    "Generic filling material"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datFil");

  record Bentonite =
      Buildings.HeatTransfer.Data.BoreholeFillings.Generic (
      k=1.15,
      d=1600,
      c=800) "Bentonite (k=1.15)"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datFil");

  record Concrete =
      Buildings.HeatTransfer.Data.BoreholeFillings.Generic (
      k=3.1,
      d=2000,
      c=840) "Concrete (k=3.1)"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datFil");

  annotation (preferredView="info",
Documentation(info="<html>
<p>
Package with material definitions for borehole fillings.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 7, 2012, by Michael Wetter:<br/>
Renamed class to <code>BoreholeFillings</code> to be
consistent with data records being plural.
</li>
<li>
September 9, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoreholeFillings;
