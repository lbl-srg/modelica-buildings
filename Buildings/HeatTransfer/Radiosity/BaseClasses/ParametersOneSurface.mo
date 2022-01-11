within Buildings.HeatTransfer.Radiosity.BaseClasses;
model ParametersOneSurface "Parameters that are used to model one surface"
  parameter Modelica.Units.SI.Emissivity absIR "Infrared absorptivity";
  parameter Modelica.Units.SI.ReflectionCoefficient rhoIR
    "Infrared reflectivity";
  parameter Modelica.Units.SI.TransmissionCoefficient tauIR
    "Infrared transmissivity";
  parameter Boolean linearize=false "Set to true to linearize emissive power"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize));
protected
 final parameter Real T03(min=0, unit="K3")=T0^3 "3rd power of temperature T0";

initial equation
  assert(abs(1-absIR-rhoIR-tauIR) < 1E-8,
    "Absorptivity, reflectivity and transmissivity do not add up to one. Check parameters.");

annotation (
Documentation(
info="<html>
<p>
Parameters that are used for classes with one surface.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 17, 2014, by Michael Wetter:<br/>
Changed tolerance of the <code>assert</code> statement.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
August 23, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ParametersOneSurface;
