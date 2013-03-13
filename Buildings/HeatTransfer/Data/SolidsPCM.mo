within Buildings.HeatTransfer.Data;
package SolidsPCM
  "Package with solid material, characterized by thermal conductance, density and specific heat capacity"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Thermal properties of solids with heat storage"
      extends Buildings.HeatTransfer.Data.BaseClasses.Material(final R=x/k,
                                                               final phasechange=true);

    annotation (defaultComponentName="mat", Documentation(info=
     "<html>
<p>
Generic record for phase change materials.
The record extends from 
<a href=\"modelica:Buildings.HeatTransfer.Data.BaseClasses.Material\">
Buildings.HeatTransfer.Data.BaseClasses.Material</a>
and declares parameters and constants for phase change materials.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2013, by Michael Wetter:<br>
Revised implementation.
</li>
<li>
February 20, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  end Generic;

  record PCM020 =Buildings.HeatTransfer.Data.SolidsPCM.Generic (
      k=0.0337,
      d=29,
      c=960,
      TSol=273.15+29.49,
      TLiq=273.15+29.51,
      LHea=34000)
    "Material with 20% weight of microencapsulated PCM in wall layer";
  record PCM030 =Buildings.HeatTransfer.Data.SolidsPCM.Generic (
      k=0.23,
      d=1000,
      c=1400,
      TSol=273.15+29.49,
      TLiq=273.15+29.51,
      LHea=33000)
    "Material with 30% weight of microencapsulated PCM in wall layer. fixme: LHea is lower than for PCM020";
  record PCM100 =Buildings.HeatTransfer.Data.SolidsPCM.Generic (
      k=0.16,
      d=850,
      c=2500,
      TSol=273.15+29.49,
      TLiq=273.15+29.51,
      LHea=130000) "PCM material, 100%";
  annotation (
Documentation(
info="<html>
<p>
Package with records for solid materials with embedded phase change material.
The material is characterized by its 
thermal conductivity, mass density and specific
heat capacity, as well as the solidus and liquidus temperatures, and 
the latent heat.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 20, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end SolidsPCM;
