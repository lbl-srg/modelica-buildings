within Buildings.HeatTransfer.Radiosity.BaseClasses;
model ParametersTwoSurfaces
  "Parameters that are used to model two surfaces with the same area"
  parameter Modelica.Units.SI.Emissivity absIR_a
    "Infrared absorptivity of surface a";
  parameter Modelica.Units.SI.Emissivity absIR_b
    "Infrared absorptivity of surface b";
  parameter Modelica.Units.SI.ReflectionCoefficient rhoIR_a
    "Infrared reflectivity of surface a";
  parameter Modelica.Units.SI.ReflectionCoefficient rhoIR_b
    "Infrared reflectivity of surface b";
  parameter Modelica.Units.SI.TransmissionCoefficient tauIR
    "Infrared transmissivity of glass pane";
  parameter Boolean linearize = false "Set to true to linearize emissive power"
  annotation (Evaluate=true);
  parameter Modelica.Units.SI.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize));
protected
 final parameter Real T03(min=0, final unit="K3")=T0^3
    "3rd power of temperature T0";
 final parameter Real T04(min=0, final unit="K4")=T0^4
    "4th power of temperature T0";
initial equation
  assert(abs(1-absIR_a-rhoIR_a-tauIR) < 1E-8,
    "Absorptivity, reflectivity and transmissivity of surface a do not add up to one. Check parameters.");
    assert(abs(1-absIR_b-rhoIR_b-tauIR) < 1E-8,
    "Absorptivity, reflectivity and transmissivity of surface b do not add up to one. Check parameters.");

annotation (
Documentation(
info="<html>
<p>
Parameters that are used for classes with two surfaces.
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
March 20, 2012, by Wangda Zuo:<br/>
Added <code>T04</code> for temperature linearization.
</li>
<li>
August 23, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ParametersTwoSurfaces;
