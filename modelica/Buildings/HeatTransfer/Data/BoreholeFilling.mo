within Buildings.HeatTransfer.Data;
package BoreholeFilling
  "Package with materials for borehole fillings"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic =
      Buildings.HeatTransfer.Data.BaseClasses.ThermalProperties
    "Generic filling material";
  record Bentonite =
      Buildings.HeatTransfer.Data.BoreholeFilling.Generic (
      k=1.15,
      d=1600,
      c=800) "Bentonite (k=1.15)";
  record Concrete =
      Buildings.HeatTransfer.Data.BoreholeFilling.Generic (
      k=3.1,
      d=2000,
      c=840) "Concrete (k=3.1)";
  annotation (preferedView="info",
Documentation(info="<html>
<p>
Package with material definitions for borehole fillings.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 9, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end BoreholeFilling;
