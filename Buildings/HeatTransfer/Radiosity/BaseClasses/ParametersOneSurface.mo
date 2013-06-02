within Buildings.HeatTransfer.Radiosity.BaseClasses;
model ParametersOneSurface "Parameters that are used to model one surface"
  parameter Modelica.SIunits.Emissivity absIR "Infrared absorptivity";
  parameter Modelica.SIunits.ReflectionCoefficient rhoIR
    "Infrared reflectivity";
  parameter Modelica.SIunits.TransmissionCoefficient tauIR
    "Infrared transmissivity";
  parameter Boolean linearize=false "Set to true to linearize emissive power"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize), Evaluate=true);
protected
 final parameter Real T03(min=0, unit="K3")=T0^3 "3rd power of temperature T0"
 annotation(Evaluate=true);

initial equation
  assert(abs(1-absIR-rhoIR-tauIR) < Modelica.Constants.eps,
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
August 23, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ParametersOneSurface;
