within Buildings.HeatTransfer.Data;
package Glasses "Package with thermophysical properties for window glas"
  record Generic "Thermal properties of window glass"
      extends Modelica.Icons.Record;
   parameter Modelica.SIunits.Length x=0.003 "Thickness";
   parameter Modelica.SIunits.ThermalConductivity k=1 "Thermal conductivity";
   parameter Modelica.SIunits.TransmissionCoefficient tauSW = 0.6
      "Solar transmittance";
   parameter Modelica.SIunits.ReflectionCoefficient rhoSW_a = 0.075
      "Solar reflectance of surface a (usually outside-facing surface)";
   parameter Modelica.SIunits.ReflectionCoefficient rhoSW_b = 0.075
      "Solar reflectance of surface b (usually room-facing surface)";
   parameter Modelica.SIunits.TransmissionCoefficient tauLW = 0
      "Long-wave transmissivity of glass";
   parameter Modelica.SIunits.Emissivity epsLW_a = 0.84
      "Long-wave emissivity of surface a (usually outside-facing surface)";
   parameter Modelica.SIunits.Emissivity epsLW_b = 0.84
      "Long-wave emissivity of surface b (usually room-facing surface)";
    annotation (Documentation(info="<html>
<p>
This record implements thermophysical properties for window glas.
</p>
<p>
The table below compares the data of this record with the variables used in the WINDOW 5 output file.
</p>
<p>
Note that
<ul>
<li>the surface <code>a</code> is usually the outside-facing surface, and the surface
<code>b</code> is usually the room-facing surface.
</li>
<li>by the term <i>short-wave</i>, we mean the whole solar spectrum.
Data in the short-wave spectrum are used for computing solar heat gains.
</li>
<li>by the term <i>long-wave</i> (or <i>infrared</i>), we mean the infrared spectrum. 
Data in the long-wave spectrum are used for thermal radiation that is emitted by surfaces that are 
around room or ambient temperature.
</li>
<li>WINDOW 5 uses spectral data in the calculation of optical properties of window systems, 
whereas the model in this library uses averages over the whole solar or infrared spectrum.
</li>
</ul>
</p>
<p>
<table border=\"1\">
<thead>
 <tr>
   <th>Buildings library variable name</th>
   <th>WINDOW 5 variable name</th>
 </tr>
</thead>
<tbody>
<tr>
  <td>tauSW</td>  <td>Tsol</td>
</tr>
<tr>
  <td>rhoSW_a</td>  <td>Rsol1</td>
</tr>
<tr>
  <td>rhoSW_b</td>  <td>Rsol2</td>
</tr>
<tr>
  <td>tauLW</td>  <td>Tir</td>
</tr>
<tr>
  <td>epsLW_a</td>  <td>Emis1</td>
</tr>
<tr>
  <td>epsLW_b</td>  <td>Emis2</td>
</tr>
</tbody>
</table>

</html>",
  revisions="<html>
<ul>
<li>
Sep. 3 2010, by Michael Wetter, Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record ID100 =   Buildings.HeatTransfer.Data.Glasses.Generic (
      x=0.0031,
      k=1.0,
      tauSW=0.646,
      rhoSW_a=0.062,
      rhoSW_b=0.063,
      tauLW=0,
      epsLW_a=0.84,
      epsLW_b=0.84) "Generic Bronze Glass 3.1mm. Manufacturer: Generic.";
  record ID101 =   Buildings.HeatTransfer.Data.Glasses.Generic (
      x=0.0057,
      k=1.0,
      tauSW=0.486,
      rhoSW_a=0.053,
      rhoSW_b=0.053,
      tauLW=0,
      epsLW_a=0.84,
      epsLW_b=0.84) "Generic Bronze Glass 5.7mm. Manufacturer: Generic.";
  record ID102 =   Buildings.HeatTransfer.Data.Glasses.Generic (
      x=0.003,
      k=1.0,
      tauSW=0.834,
      rhoSW_a=0.075,
      rhoSW_b=0.075,
      tauLW=0,
      epsLW_a=0.84,
      epsLW_b=0.84) "Generic Clear Glass 3.048mm. Manufacturer: Generic.";
  record ID103 =   Buildings.HeatTransfer.Data.Glasses.Generic (
      x=0.0057,
      k=1.0,
      tauSW=0.771,
      rhoSW_a=0.070,
      rhoSW_b=0.070,
      tauLW=0,
      epsLW_a=0.84,
      epsLW_b=0.84) "Generic Clear Glass 5.7mm. Manufacturer: Generic.";
  annotation(preferedView="info",
            Documentation(info="<html>
This package implements thermophysical properties for window glas.
</p>
<p>
Since the long-wave transmissivity is part of the Window 5 data and since
it depends on the glass thickness, the glass thickness is a parameter
that is set for all glass layers.
This configuration is different from the records fo gas properties, 
which do not yet set the value for the thickness of the gas gap.
</html>",
revisions="<html>
<ul>
<li>
September 9, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Glasses;
