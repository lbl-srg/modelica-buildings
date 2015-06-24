within Buildings.Rooms.Validation.BESTEST.Data;
record Glass600 "Thermal properties of window glass"
    extends Modelica.Icons.Record;
 parameter Modelica.SIunits.Length x=0.003175 "Thickness";
 parameter Modelica.SIunits.ThermalConductivity k=1.06 "Thermal conductivity";
 parameter Modelica.SIunits.TransmissionCoefficient tauSol = 0.86156
    "Solar transimittance. It is tauSol in WINDOW5.";
 parameter Modelica.SIunits.ReflectionCoefficient rhoSol_a = 0.0434
    "Solar reflectance of surface a (usually outside-facing surface). It is Rsol1 in WINDOW5.";
 parameter Modelica.SIunits.ReflectionCoefficient rhoSol_b = 0.0434
    "Solar reflectance of surface b (usually room-facing surface). It is Rsol2 in WINDOW5.";
 parameter Modelica.SIunits.TransmissionCoefficient tauIR = 0
    "Infrared infrared transmissivity of glass. It is Tir in WINDOW5.";
 parameter Modelica.SIunits.Emissivity absIR_a = 0.9
    "Infrared infrared absorptivity of surface a (usually outside-facing surface). It is Emis1 in WINDOW5.";
 parameter Modelica.SIunits.Emissivity absIR_b = 0.9
    "Infrared infrared absorptivity of surface b (usually room-facing surface). It is Emis2 in WINDOW5.";
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datGla",
Documentation(info="<html>
<p>
This record declares the glass properties for the BESTEST model.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Glass600;
