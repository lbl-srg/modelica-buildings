within Buildings.Experimental.DHC.Examples.Combined.BaseClasses;
record DesignDataSeries "Record with design data for series network"
  extends Modelica.Icons.Record;
  parameter Integer nBui = 3
    "Number of served buildings"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mPumDis_flow_nominal=95
    "Nominal mass flow rate of main distribution pump";
  parameter Modelica.Units.SI.MassFlowRate mPipDis_flow_nominal=
      mPumDis_flow_nominal "Nominal mass flow rate for main pipe sizing";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal[nBui]
    "Nominal mass flow rate in each connection line";
  parameter Modelica.Units.SI.MassFlowRate mPla_flow_nominal=11.45
    "Plant HX nominal mass flow rate (primary = secondary)";
  parameter Modelica.Units.SI.MassFlowRate mSto_flow_nominal=105
    "Storage nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpPla_nominal=50000
    "Plant HX pressure drop at nomninal flow rate (primary = secondary)";
  parameter Real epsPla = 0.935
    "Plant HX effectiveness (constant)";
  parameter Modelica.Units.SI.Temperature TLooMin=273.15 + 6
    "Minimum loop temperature";
  parameter Modelica.Units.SI.Temperature TLooMax=273.15 + 17
    "Maximum loop temperature";
  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";
  parameter Modelica.Units.SI.Length lDis[nBui]=fill(100, nBui)
    "Length of the distribution pipe before each connection";
  parameter Modelica.Units.SI.Length lCon[nBui]=fill(10, nBui)
    "Length of each connection pipe (supply only, not counting return line)";
  parameter Modelica.Units.SI.Length lEnd=sum(lDis)
    "Length of the end of the distribution line (after last connection)";
  annotation (
    defaultComponentName="datDes",
    defaultComponentPrefixes="inner",
    Documentation(info="<html>
<p>
This record contains parameter declarations used in example models of DHC systems.
</p>
</html>"));
end DesignDataSeries;
