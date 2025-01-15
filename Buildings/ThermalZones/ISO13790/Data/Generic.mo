within Buildings.ThermalZones.ISO13790.Data;
record Generic "Generic data record for building thermal mass"
   extends Modelica.Icons.Record;

   parameter Real heaC(final unit="J/(K.m2)")
    "Heat capacity per unit area of the floor"
    annotation (Dialog(group="Thermal mass"));
   parameter Real facMas(final unit="1")
    "Effective mass area factor"
    annotation (Dialog(group="Thermal mass"));
  annotation (defaultComponentName="theMas",
Documentation(revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Generic record for the internal heat capacity of the building zone per unit area of the floor.
</p>
</html>"));
end Generic;
