within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Data;
record DesignDataDHC "Record with design data for DHC system"
  extends Modelica.Icons.Record;
  parameter Integer nBui = 3
    "Number of served buildings"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 95
    "Distribution pipe flow rate";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nBui]
    "Connection pipe flow rate";
  parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal = 11.45
    "Plant HX mass flow rate (primary = secondary)";
  parameter Modelica.SIunits.MassFlowRate mSto_flow_nominal = 105
    "Storage mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpPla_nominal = 50000
    "Plant HX pressure drop at nomninal flow rate (primary = secondary)";
  parameter Real epsPla
    "Plant HX effectiveness (constant)";
  parameter Modelica.SIunits.Temperature TLooMin = 273.15 + 6
    "Minimum loop temperature";
  parameter Modelica.SIunits.Temperature TLooMax = 273.15 + 17
    "Maximum loop temperature";
  parameter Modelica.SIunits.Length dhDis = 0.25
    "Hydraulic diameter of distribution pipe";
  parameter Modelica.SIunits.Length dhCon[nBui] = fill(0.15, nBui)
    "Hydraulic diameter of connection pipe";
  parameter Modelica.SIunits.Length lDis[nBui] = fill(100, nBui)
    "Length of distribution pipe (only counting warm or cold line, but not sum)";
  parameter Modelica.SIunits.Length lCon[nBui] = fill(10, nBui)
    "Length of connection pipe (only counting warm or cold line, but not sum)";
  annotation (
    defaultComponentPrefix="datDes",
    defaultComponentPrefixes="inner");
end DesignDataDHC;
