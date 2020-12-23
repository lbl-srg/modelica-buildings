within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Data;
record DesignDataParallel
  "Record with design data for parallel network"
  extends Modelica.Icons.Record;
  parameter Integer nBui = 3
    "Number of served buildings"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 95
    "Nominal mass flow rate of the distribution pump";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nBui]
    "Nominal mass flow rate in each connection line";
  parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal = 11.45
    "Plant HX nominal mass flow rate (primary = secondary)";
  parameter Modelica.SIunits.MassFlowRate mSto_flow_nominal = 105
    "Storage nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpPla_nominal = 50000
    "Plant HX pressure drop at nomninal flow rate (primary = secondary)";
  parameter Real epsPla
    "Plant HX effectiveness (constant)";
  parameter Modelica.SIunits.Temperature TLooMin = 6 + 273.15
    "Minimum loop temperature";
  parameter Modelica.SIunits.Temperature TLooMax = 17 + 273.15
    "Maximum loop temperature";
  parameter Modelica.SIunits.Length lDis[nBui] = fill(100, nBui)
    "Length of distribution pipe (only counting warm or cold line, but not sum)";
  parameter Modelica.SIunits.Length lCon[nBui] = fill(10, nBui)
    "Length of connection pipe (only counting warm or cold line, but not sum)";
  parameter Modelica.SIunits.Length lEnd = 10
    "Length of the end of the distribution line (supply only, not counting return line)";
  parameter Real dpDis_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal mass flow rate, distribution line";
  parameter Real dpCon_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal mass flow rate, connection line";
  parameter Modelica.SIunits.Length dhEnd = dhDis[nBui]
    "Hydraulic diameter of the end of the distribution line";
  annotation (
    defaultComponentPrefix="datDes",
    defaultComponentPrefixes="inner");
end DesignDataParallel;
