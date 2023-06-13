within Buildings.Fluid.CHPs.Rankine.Data;
record Generic "Generic data record for working fluid properties"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.ThermodynamicTemperature T[:]
    "Thermodynamic temperature";
  parameter Modelica.Units.SI.AbsolutePressure p[size(T,1)]
    "Saturation pressure";
  parameter Modelica.Units.SI.TemperatureDifference dTSup
    "Superheating differential temperature";
  parameter Modelica.Units.SI.SpecificEntropy sSatLiq[size(T,1)]
    "Specific entropy of saturated vapour";
  parameter Modelica.Units.SI.SpecificEntropy sSatVap[size(T,1)]
    "Specific entropy of saturated vapour";
  parameter Modelica.Units.SI.SpecificEntropy sSupVap[size(T,1)]
    "Specific entropy of superheated vapour";
  parameter Modelica.Units.SI.SpecificEnthalpy hSatLiq[size(T,1)]
    "Specific enthalpy of saturated liquid";
  parameter Modelica.Units.SI.SpecificEnthalpy hSatVap[size(T,1)]
    "Specific enthalpy of saturated vapour";
  parameter Modelica.Units.SI.SpecificEnthalpy hSupVap[size(T,1)]
    "Specific enthalpy of superheated vapour";
end Generic;
