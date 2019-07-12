within Buildings.HeatTransfer.Data;
package SolidsPCM
  "Package with solid material, characterized by thermal conductance, density and specific heat capacity"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Thermal properties of solids with heat storage"
      extends Buildings.HeatTransfer.Data.BaseClasses.Material(final R=x/k,
                                                               final phasechange=true);

    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSolPCM",
      Documentation(info=
     "<html>
<p>
Generic record for phase change materials.
The record extends from
<a href=\"modelica://Buildings.HeatTransfer.Data.BaseClasses.Material\">
Buildings.HeatTransfer.Data.BaseClasses.Material</a>
and declares parameters and constants for phase change materials.
</p>
</html>", revisions="<html>
<ul>
<li>
March 9, 2013, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
February 20, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  end Generic;

  record PCM020 =Buildings.HeatTransfer.Data.SolidsPCM.Generic (
      k=0.204,
      d=800,
      c=1341,
      TSol=273.15+23,
      TLiq=273.15+27,
      LHea=38900) "Wallboard with 20% of microencapsulated paraffin"
    annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datSolPCM",
    Documentation(info=
                   "<html>
<p>
This material record is for PCM treated wallboard. The data source is Feustel (1995).
</p>
<h4>References</h4>
<p>
Feustel, Helmut E.
Simplified numerical description of latent storage characteristics for phase change wallboard.
<i>LBNL-Technical Report 36933</i>. 1995.
<a href=\"http://dx.doi.org/10.2172/70723\">DOI: 10.2172/70723</a>.
</p>
</html>",
  revisions="<html>
<ul>
<li>
March 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  record PCM030 =Buildings.HeatTransfer.Data.SolidsPCM.Generic (
      k=0.232,
      d=998,
      c=1467,
      TSol=273.15+24,
      TLiq=273.15+26,
      LHea=58300) "Wallboard with 30% of microencapsulated paraffin"
        annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datSolPCM",
    Documentation(info=
                   "<html>
<p>
This material record is for PCM treated wallboard. The data source is Feustel (1995).
</p>
<h4>References</h4>
<p>
Feustel, Helmut E.
Simplified numerical description of latent storage characteristics for phase change wallboard.
<i>LBNL-Technical Report 36933</i>. 1995.
<a href=\"http://dx.doi.org/10.2172/70723\">DOI: 10.2172/70723</a>.
</p>
</html>",
  revisions="<html>
<ul>
<li>
March 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

  record MicronalSmartBoard23 =
    Buildings.HeatTransfer.Data.SolidsPCM.Generic (
      k=0.18,
      d=767,
      c=1200,
      TSol=273.15+22.99,
      TLiq=273.15+23.01,
      LHea=28696) "Micronal PCM SmartBoard 23"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSolPCM");

  record MicronalSmartBoard26 =
    Buildings.HeatTransfer.Data.SolidsPCM.Generic (
      k=0.18,
      d=767,
      c=1200,
      TSol=273.15+25.99,
      TLiq=273.15+26.01,
      LHea=28696) "Micronal PCM SmartBoard 26"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSolPCM");

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
<p>
For a description of the parameter <code>nStaRef</code>, which is
used to generate the spatial grid, see the documentation of the package
<a href=\"modelica://Buildings.HeatTransfer.Data.Solids\">
Buildings.HeatTransfer.Data.Solids</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 20, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SolidsPCM;
