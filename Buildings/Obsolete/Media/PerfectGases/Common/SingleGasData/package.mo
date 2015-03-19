within Buildings.Obsolete.Media.PerfectGases.Common;
package SingleGasData "Package with data records for single gases"
  extends Modelica.Icons.MaterialPropertiesPackage;
 constant PerfectGases.Common.DataRecord Air(
   name = Modelica.Media.IdealGases.Common.SingleGasesData.Air.name,
   R =    Modelica.Media.IdealGases.Common.SingleGasesData.Air.R,
   MM =   Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM,
   cp =   1006,
   cv =   1006 - Modelica.Media.IdealGases.Common.SingleGasesData.Air.R);
constant PerfectGases.Common.DataRecord H2O(
   name = Modelica.Media.IdealGases.Common.SingleGasesData.H2O.name,
   R =    Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R,
   MM =   Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM,
   cp =   1860,
   cv =   1860 - Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R);


  annotation (Documentation(preferredView="info", info="<html>
<p>
This package contains the coefficients for perfect gases.
</p>
</html>"), revisions="<html>
<ul>
<li>
May 12, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>");
end SingleGasData;
