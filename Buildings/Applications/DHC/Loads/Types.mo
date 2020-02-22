within Buildings.Applications.DHC.Loads;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;
  type DistributionType = enumeration(
      HeatingWater
      "Heating water distribution system",
      ChilledWater
      "Chilled water distribution system",
      ChangeOver
      "Change-over distribution system")
    "Enumeration for the type of distribution system"
  annotation(Documentation(info="<html>
<p>
Enumeration to define the type of distribution system.
</p>
</html>", revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
  type PumpControlType = enumeration(
      ConstantSpeed
      "Constant speed",
      ConstantFlow
      "Constant flow rate (three-way valves)",
      ConstantHead
      "Constant pump head",
      LinearHead
      "Linear relationship between pump head and mass flow rate",
      ConstantDp
      "Constant pressure difference at given location")
    "Enumeration for the type of distribution pump control"
  annotation(Documentation(info="<html>
<p>
Enumeration to define the type of distribution pump control.
</p>
</html>", revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;
