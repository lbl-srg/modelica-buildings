within Buildings.HeatTransfer.Data;
package Shades "Package with thermophysical properties for window shades"
    extends Modelica.Icons.MaterialPropertiesPackage;
  record Generic "Thermal properties of window shades"
      extends Modelica.Icons.Record;
   parameter Modelica.SIunits.TransmissionCoefficient tauSW_a=0.1
      "Short wave transmissivity of shade surface a (surface that faces the outside or the room)";
   parameter Modelica.SIunits.TransmissionCoefficient tauSW_b=0.1
      "Short wave transmissivity of shade surface b (surface that faces the glass)";
   parameter Modelica.SIunits.ReflectionCoefficient rhoSW_a=0.8
      "Short wave reflection coefficient of shade surface a (surface that faces the outside or the room)";
   parameter Modelica.SIunits.ReflectionCoefficient rhoSW_b=0.8
      "Short wave reflection coefficient of shade surface b (surface that faces the glass)";
   parameter Modelica.SIunits.Emissivity epsLW_a=0.84
      "Long wave emissivity of surface a (surface that faces the outside or the room)";
   parameter Modelica.SIunits.Emissivity epsLW_b=0.84
      "Long wave emissivity of surface b (surface that faces the glass)";
   parameter Modelica.SIunits.TransmissionCoefficient tauLW_a=0
      "Long wave transmissivity of surface a (surface that faces the outside or the room)";
   parameter Modelica.SIunits.TransmissionCoefficient tauLW_b=0
      "Long wave transmissivity of surface b (surface that faces the glass)";

    annotation (
defaultComponentName="sha",
Documentation(info=
                               "<html>
Records that implements thermophysical properties for window shades.
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

  record Gray=Buildings.HeatTransfer.Data.Shades.Generic (
      tauSW_a = 0.25,
      tauSW_b = 0.25,
      rhoSW_a = 0.25,
      rhoSW_b = 0.25,
      epsLW_a = 0.25,
      epsLW_b = 0.25) "Gray";

annotation (Documentation(info="<html>
Package with records that implement thermophysical properties for window shades.
</html>",
  revisions="<html>
<ul>
<li>
Sep. 3 2010, by Michael Wetter, Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),   preferedView="info",
            Documentation(info="<html>
This package implements thermophysical properties for window shades.
</html>"));
end Shades;
