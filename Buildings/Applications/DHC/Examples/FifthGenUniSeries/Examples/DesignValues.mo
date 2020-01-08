within Buildings.Examples.DistrictReservoirNetworks.Examples;
record DesignValues "Record with design values"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.MassFlowRate mDisPip_flow_nominal "Distribution pipe flow rate";
  parameter Real RDisPip(unit="Pa/m") "Pressure drop per meter at m_flow_nominal";

  final parameter Modelica.SIunits.MassFlowRate mPla_flow_nominal = 11.45 "Plant mass flow rate";
  parameter Real epsPla "Plant efficiency";
  final parameter Modelica.SIunits.MassFlowRate mSto_flow_nominal = 105 "Storage mass flow rate";
  final parameter Modelica.SIunits.Temperature TLooMin = 273.15+6 "Minimum loop temperature";
  final parameter Modelica.SIunits.Temperature TLooMax = 273.15+17 "Minimum loop temperature";
annotation(defaultComponentPrefix="parameter");
end DesignValues;
