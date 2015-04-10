within Buildings.HeatTransfer.Data;
package Glasses "Package with thermophysical properties for window glas"
    extends Modelica.Icons.MaterialPropertiesPackage;
  record Generic "Thermal properties of window glass"
      extends Modelica.Icons.Record;
   parameter Modelica.SIunits.Length x=0.003 "Thickness";
   parameter Modelica.SIunits.ThermalConductivity k=1 "Thermal conductivity";
   parameter Modelica.SIunits.TransmissionCoefficient tauSol = 0.6
      "Solar transmittance";
   parameter Modelica.SIunits.ReflectionCoefficient rhoSol_a = 0.075
      "Solar reflectance of surface a (usually outside-facing surface)";
   parameter Modelica.SIunits.ReflectionCoefficient rhoSol_b = 0.075
      "Solar reflectance of surface b (usually room-facing surface)";
   parameter Modelica.SIunits.TransmissionCoefficient tauIR = 0
      "Infrared transmissivity of glass";
   parameter Modelica.SIunits.Emissivity absIR_a = 0.84
      "Infrared absorptivity of surface a (usually outside-facing surface)";
   parameter Modelica.SIunits.Emissivity absIR_b = 0.84
      "Infrared absorptivity of surface b (usually room-facing surface)";
    annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datGla",
    Documentation(info=
"<html>
<p>
This record implements thermophysical properties for window glas.
</p>
<p>
The table below compares the data of this record with the variables used in the WINDOW 6 output file.
</p>
Note that
<ul>
<li>the surface <code>a</code> is usually the outside-facing surface, and the surface
<code>b</code> is usually the room-facing surface.
</li>
<li>by the term <i>solar</i>, we mean the whole solar spectrum.
Data in the solar spectrum are used for computing solar heat gains.
</li>
<li>by the term <i>infrared</i> (or <i>infrared</i>), we mean the infrared spectrum.
Data in the infrared spectrum are used for thermal radiation that is emitted by surfaces that are
around room or ambient temperature.
</li>
<li>WINDOW 6 uses spectral data in the calculation of optical properties of window systems,
whereas the model in this library uses averages over the whole solar or infrared spectrum.
</li>
</ul>

<table summary=\"summary\" border=\"1\">
<thead>
 <tr>
   <th>Buildings library variable name</th>
   <th>WINDOW 6 variable name</th>
 </tr>
</thead>
<tbody>
<tr>
  <td>tauSol</td>  <td>Tsol</td>
</tr>
<tr>
  <td>rhoSol_a</td>  <td>Rsol1</td>
</tr>
<tr>
  <td>rhoSol_b</td>  <td>Rsol2</td>
</tr>
<tr>
  <td>tauIR</td>  <td>Tir</td>
</tr>
<tr>
  <td>absIR_a</td>  <td>Emis1</td>
</tr>
<tr>
  <td>absIR_b</td>  <td>Emis2</td>
</tr>
</tbody>
</table>

</html>",
  revisions="<html>
<ul>
<li>
December 09, 2011, by Wangda Zuo:<br/>
Compare the variable names with those in Window 6 and correct the variable names <i>Emis1</i> and <i>Emis2</i> in documentation.
</li>
<li>
Sep. 3 2010, by Michael Wetter, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record ID100 = Buildings.HeatTransfer.Data.Glasses.Generic (
      x=0.0031,
      k=1.0,
      tauSol=0.646,
      rhoSol_a=0.062,
      rhoSol_b=0.063,
      tauIR=0,
      absIR_a=0.84,
      absIR_b=0.84) "Generic Bronze Glass 3.1mm. Manufacturer: Generic."
    annotation(
      defaultComponentPrefixes="parameter",
      defaultComponentName="datGla");

  record ID101 = Buildings.HeatTransfer.Data.Glasses.Generic (
      x=0.0057,
      k=1.0,
      tauSol=0.486,
      rhoSol_a=0.053,
      rhoSol_b=0.053,
      tauIR=0,
      absIR_a=0.84,
      absIR_b=0.84) "Generic Bronze Glass 5.7mm. Manufacturer: Generic."
    annotation(
      defaultComponentPrefixes="parameter",
      defaultComponentName="datGla");

  record ID102 = Buildings.HeatTransfer.Data.Glasses.Generic (
      x=0.003,
      k=1.0,
      tauSol=0.834,
      rhoSol_a=0.075,
      rhoSol_b=0.075,
      tauIR=0,
      absIR_a=0.84,
      absIR_b=0.84) "Generic Clear Glass 3.048mm. Manufacturer: Generic."
    annotation(
      defaultComponentPrefixes="parameter",
      defaultComponentName="datGla");

  record ID103 = Buildings.HeatTransfer.Data.Glasses.Generic (
      x=0.0057,
      k=1.0,
      tauSol=0.771,
      rhoSol_a=0.070,
      rhoSol_b=0.070,
      tauIR=0,
      absIR_a=0.84,
      absIR_b=0.84) "Generic Clear Glass 5.7mm. Manufacturer: Generic."
    annotation(
      defaultComponentPrefixes="parameter",
      defaultComponentName="datGla");

annotation(preferredView="info",
Documentation(info="<html>
<p>
This package implements thermophysical properties for window glas.
</p>
<p>
Since the infrared transmissivity is part of the Window 5 data and since
it depends on the glass thickness, the glass thickness is a parameter
that is set for all glass layers.
This configuration is different from the records fo gas properties,
which do not yet set the value for the thickness of the gas gap.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 9, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Glasses;
