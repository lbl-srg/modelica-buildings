within Buildings.HeatTransfer.Radiosity.BaseClasses;
model ParametersTwoSurfaces
  "Parameters that are used to model two surfaces with the same area"
  parameter Modelica.SIunits.Emissivity epsLW_a
    "Long wave emissivity of surface a";
  parameter Modelica.SIunits.Emissivity epsLW_b
    "Long wave emissivity of surface b";
  parameter Modelica.SIunits.ReflectionCoefficient rhoLW_a
    "Long wave reflectivity of surface a";
  parameter Modelica.SIunits.ReflectionCoefficient rhoLW_b
    "Long wave reflectivity of surface b";
  parameter Modelica.SIunits.TransmissionCoefficient tauLW
    "Long wave transmissivity of glass pane";
  parameter Boolean linearize = false "Set to true to linearize emissive power"
  annotation (Evaluate=true);
  parameter Modelica.SIunits.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize), Evaluate=true);
protected
 final parameter Real T03(min=0, unit="K3")=T0^3 "3rd power of temperature T0"
 annotation(Evaluate=true);

initial equation
    assert(abs(1-epsLW_a-rhoLW_a-tauLW) < Modelica.Constants.eps,
    "Emissivity, reflectivity and transmissivity of surface a do not add up to one. Check parameters.");
    assert(abs(1-epsLW_b-rhoLW_b-tauLW) < Modelica.Constants.eps,
    "Emissivity, reflectivity and transmissivity of surface b do not add up to one. Check parameters.");
end ParametersTwoSurfaces;
