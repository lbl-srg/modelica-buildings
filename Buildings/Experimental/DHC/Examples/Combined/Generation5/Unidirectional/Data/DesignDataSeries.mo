within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Data;
record DesignDataSeries "Record with design data for series network"
  extends Modelica.Icons.Record;
  parameter Integer nBui = 3
    "Number of served buildings"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 95
    "Nominal mass flow rate in the distribution line";
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
  parameter Modelica.SIunits.Temperature TLooMin = 273.15 + 6
    "Minimum loop temperature";
  parameter Modelica.SIunits.Temperature TLooMax = 273.15 + 17
    "Maximum loop temperature";
  parameter Modelica.SIunits.Length dhDis = 0.25
    "Hydraulic diameter of the distribution pipe";
  parameter Modelica.SIunits.Length dhCon[nBui] = fill(0.15, nBui)
    "Hydraulic diameter of connection pipe";
  parameter Modelica.SIunits.Length lDis[nBui] = fill(100, nBui)
    "Length of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length lCon[nBui] = fill(10, nBui)
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length lEnd = sum(lDis)
    "Length of the end of the distribution line (after last connection)";
  annotation (
    defaultComponentPrefix="datDes",
    defaultComponentPrefixes="inner");
end DesignDataSeries;
