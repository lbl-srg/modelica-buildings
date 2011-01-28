within Buildings.HeatTransfer.Data;
package Glasses "Package with thermophysical properties for window glas"

  record Generic "Thermal properties of window glass"
      extends Modelica.Icons.Record;
   parameter Modelica.SIunits.Length x=0.03 "Thickness";
   parameter Modelica.SIunits.ThermalConductivity k=1 "Thermal conductivity";
   parameter Modelica.SIunits.TransmissionCoefficient tauSW = 0.6
      "Solar infrared transimittance. It is tauSol in WINDOW5.";
   parameter Modelica.SIunits.ReflectionCoefficient rhoSW_a = 0.075
      "Solar infrared reflectance of surface a (usually outside-facing surface). It is Rsol1 in WINDOW5.";
   parameter Modelica.SIunits.ReflectionCoefficient rhoSW_b = 0.075
      "Solar infrared reflectance of surface b (usually room-facing surface). It is Rsol2 in WINDOW5.";
   parameter Modelica.SIunits.TransmissionCoefficient tauLW = 0
      "Long-wave infrared transmissivity of glass. It is Tir in WINDOW5.";
   parameter Modelica.SIunits.Emissivity epsLW_a = 0.84
      "Long-wave infrared emissivity of surface a (usually outside-facing surface). It is Emis1 in WINDOW5.";
   parameter Modelica.SIunits.Emissivity epsLW_b = 0.84
      "Long-wave infrared emissivity of surface b (usually room-facing surface). It is Emis2 in WINDOW5.";

    annotation (Documentation(info="<html>
This record implements thermophysical properties for window glas.
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
</html>"));
end Glasses;
