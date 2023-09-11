within Buildings.Fluid.CHPs.OrganicRankine.Data;
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
annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "pro",
  Documentation(info="<html>
<p>
Record containing parameters for working fluid properties.
A figure in the documentation of
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BottomingCycle\">
Buildings.Fluid.CHPs.OrganicRankine.BottomingCycle</a>
shows which lines these arrays represent.
</p>
</html>"));
end Generic;
