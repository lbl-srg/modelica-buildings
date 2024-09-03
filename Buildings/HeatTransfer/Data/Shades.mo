within Buildings.HeatTransfer.Data;
package Shades "Package with thermophysical properties for window shades"
    extends Modelica.Icons.MaterialPropertiesPackage;
  record Generic "Thermal properties of window shades"
      extends Modelica.Icons.Record;
    parameter Modelica.Units.SI.TransmissionCoefficient tauSol_a=0.1
      "Solar transmissivity of shade surface a (surface that faces the outside or the room)";
    parameter Modelica.Units.SI.TransmissionCoefficient tauSol_b=0.1
      "Solar transmissivity of shade surface b (surface that faces the glass)";
    parameter Modelica.Units.SI.ReflectionCoefficient rhoSol_a=0.8
      "Solar reflection coefficient of shade surface a (surface that faces the outside or the room)";
    parameter Modelica.Units.SI.ReflectionCoefficient rhoSol_b=0.8
      "Solar reflection coefficient of shade surface b (surface that faces the glass)";
    parameter Modelica.Units.SI.Emissivity absIR_a=0.84
      "Infrared absorptivity of surface a (surface that faces the outside or the room)";
    parameter Modelica.Units.SI.Emissivity absIR_b=0.84
      "Infrared absorptivity of surface b (surface that faces the glass)";
    parameter Modelica.Units.SI.TransmissionCoefficient tauIR_a=0
      "Infrared transmissivity of surface a (surface that faces the outside or the room)";
    parameter Modelica.Units.SI.TransmissionCoefficient tauIR_b=0
      "Infrared transmissivity of surface b (surface that faces the glass)";

    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSha",
      Documentation(info="<html>
Records that implements thermophysical properties for window shades.
</html>",
  revisions="<html>
<ul>
<li>
Sep. 3 2010, by Michael Wetter, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record Gray=Buildings.HeatTransfer.Data.Shades.Generic (
      tauSol_a = 0.25,
      tauSol_b = 0.25,
      rhoSol_a = 0.25,
      rhoSol_b = 0.25,
      absIR_a = 0.25,
      absIR_b = 0.25) "Gray"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datSha");

annotation (
preferredView="info",
Documentation(info="<html>
Package with records that implement thermophysical properties for window shades.
</html>",
  revisions="<html>
<ul>
<li>
Sep. 3 2010, by Michael Wetter, Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end Shades;
