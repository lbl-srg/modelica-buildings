within Buildings.HeatTransfer.Data;
package Solids
  "Package with solid material, characterized by thermal conductance, density and specific heat capacity"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Thermal properties of solids with heat storage"
      extends Buildings.HeatTransfer.Data.BaseClasses.Material(final R=x/k);
    annotation (defaultComponentName="mat", Documentation(info=
     "<html>
<p>
Generic record for solid materials.
The material is characterized by its 
thermal conductivity, mass density and specific
heat capacity.
</p>
</html>", revisions=
          "<html>
<ul>
<li>
September 9, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record Brick = Buildings.HeatTransfer.Data.Solids.Generic (
      k=0.89,
      d=1920,
      c=790) "Brick (k=0.89)";
  record Concrete = Buildings.HeatTransfer.Data.Solids.Generic (
      k=1.4,
      d=2240,
      c=840) "Concrete (k=1.4)";
  record InsulationBoard = Buildings.HeatTransfer.Data.Solids.Generic (
      k=0.03,
      d=40,
      c=1200) "Insulation board (k=0.03)";
  record GypsumBoard = Buildings.HeatTransfer.Data.Solids.Generic (
      k=0.16,
      d=800,
      c=1090) "Gypsum board (k=0.58)";
  record Plywood = Buildings.HeatTransfer.Data.Solids.Generic (
      k=0.12,
      d=540,
      c=1210) "Plywood (k=0.12)";
  annotation (
Documentation(
info="<html>
<p>
Package with records for solid materials.
The material is characterized by its 
thermal conductivity, mass density and specific
heat capacity.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 9, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Solids;
