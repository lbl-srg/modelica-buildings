within Buildings.HeatTransfer.Data;
package Soil
  "Package with solid material for soil, characterized by thermal conductance, density and specific heat capacity"
    extends Modelica.Icons.MaterialPropertiesPackage;
  record Generic "Thermal properties of solids with heat storage"
      extends Buildings.HeatTransfer.Data.BaseClasses.ThermalProperties;
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSoi",
      Documentation(info="<html>
<p>
Generic record for solid materials used as soil.
The material is characterized by its
thermal conductivity, mass density and specific
heat capacity.
</p>
</html>", revisions="<html>
<ul>
<li>
April 24, 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record Granite = Buildings.HeatTransfer.Data.Soil.Generic (
      k=1.9,
      d=1920,
      c=790) "Granite (k=1.9)"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSoi");

  record Concrete = Buildings.HeatTransfer.Data.Soil.Generic (
      k=3.1,
      d=2000,
      c=840) "Concrete (k=3.1)"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSoi");

  record Basalt =
      Buildings.HeatTransfer.Data.Soil.Generic (
      k=2.3,
      d=1140,
      c=1200) "Basalt (k=2.3)"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSoi");

  record Marble =
      Buildings.HeatTransfer.Data.Soil.Generic (
      k=2.7,
      d=2500,
      c=1090) "Marble (k=2.7)"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSoi");

  record Sandstone = Buildings.HeatTransfer.Data.Soil.Generic (
      k=2.8,
      d=540,
      c=1210) "Sandstone (k=2.8)"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSoi");

annotation (preferredView="info",
Documentation(
info="<html>
<p>
Package with records for solid materials.
The material is characterized by its
thermal conductivity, mass density and specific
heat capacity.
</p>
<p>
These properties are used to compute heat conduction in circular coordinates.
Hence, as opposed to
<a href=\"modelica://Buildings.HeatTransfer.Data.Solids\">
Buildings.HeatTransfer.Data.Solids</a>,
they do not include the material thickness and the generation of the
spatial grid.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 9, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Soil;
