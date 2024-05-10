within Buildings.Fluid.CHPs.OrganicRankine.Data;
record Generic "Generic data record for working fluid properties"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.ThermodynamicTemperature T[:]
    "Thermodynamic temperature";
  parameter Modelica.Units.SI.AbsolutePressure p[n]
    "Saturation pressure";
  parameter Modelica.Units.SI.Density rhoLiq[n]
    "Density of saturated liquid";
  parameter Modelica.Units.SI.TemperatureDifference dTRef
    "Superheating temperature difference";
  parameter Modelica.Units.SI.SpecificEntropy sSatLiq[n]
    "Specific entropy of saturated liquid";
  parameter Modelica.Units.SI.SpecificEntropy sSatVap[n]
    "Specific entropy of saturated vapour";
  parameter Modelica.Units.SI.SpecificEntropy sRef[n]
    "Specific entropy of superheated vapour reference line";
  parameter Modelica.Units.SI.SpecificEnthalpy hSatLiq[n]
    "Specific enthalpy of saturated liquid";
  parameter Modelica.Units.SI.SpecificEnthalpy hSatVap[n]
    "Specific enthalpy of saturated vapour";
  parameter Modelica.Units.SI.SpecificEnthalpy hRef[n]
    "Specific enthalpy of superheated vapour reference line";

  final parameter Integer n = size(T,1)
    "Array length";
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
