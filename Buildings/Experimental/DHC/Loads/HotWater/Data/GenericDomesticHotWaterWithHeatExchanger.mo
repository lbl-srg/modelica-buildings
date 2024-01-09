within Buildings.Experimental.DHC.Loads.HotWater.Data;
record GenericDomesticHotWaterWithHeatExchanger
  "Equipment specifications for a heating water tank with external heat exchanger to heat domestic hot water"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Volume VTan "Tank volume"
    annotation (Dialog(group="Tank"));
  parameter Modelica.Units.SI.Length hTan = 2 "Height of tank (without insulation)"
    annotation (Dialog(group="Tank", tab="Advanced"));
  parameter Modelica.Units.SI.Length dIns = 0.3 "Thickness of insulation"
    annotation (Dialog(group="Tank", tab="Advanced"));
  parameter Modelica.Units.SI.ThermalConductivity kIns = 0.04
    "Specific heat conductivity of insulation"
    annotation (Dialog(group="Tank", tab="Advanced"));
  parameter Modelica.Units.SI.PressureDifference dpHexHea_nominal(displayUnit="Pa")=5000
    "Pressure drop across the heat exchanger at nominal conditions on heating water side"
    annotation (Dialog(group="Heat exchanger", tab="Advanced"));
  parameter Modelica.Units.SI.PressureDifference dpHexDom_nominal(displayUnit="Pa")=
      dpHexHea_nominal*(mDom_flow_nominal/mHex_flow_nominal)^2
    "Pressure drop across the heat exchanger at nominal conditions on domestic hot water side"
    annotation (Dialog(group="Heat exchanger", tab="Advanced"));
  parameter Modelica.Units.SI.MassFlowRate mHex_flow_nominal = QHex_flow_nominal/
      dTHexHea_nominal                                                                   /4200
  "Mass flow rate of heat exchanger on heating side"
    annotation (Dialog(group="Heat exchanger", tab="Advanced"));
  parameter Modelica.Units.SI.MassFlowRate mDom_flow_nominal
  "Design mass flow rate of domestic hot water"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.HeatFlowRate QHex_flow_nominal(min=0) = mDom_flow_nominal*4200*(TDom_nominal-TCol_nominal)
  "Nominal heating flow rate at heat exchanger"
    annotation (Dialog(group="Heat exchanger"));
  parameter Modelica.Units.SI.Temperature TDom_nominal = 318.15
    "Temperature of domestic hot water leaving heater at nominal conditions"
    annotation (Dialog(group="Domestic hot water"));
  parameter Modelica.Units.SI.Temperature TCol_nominal = 288.15
    "Temperature of cold water at nominal conditions"
    annotation (Dialog(group="Domestic hot water", tab="Advanced"));
  parameter Integer nSeg(min=4) = 5 "Number of volume segments used to discretize tank"
    annotation (Dialog(group="Tank", tab="Advanced"));
  parameter Modelica.Units.SI.TemperatureDifference dTHexHea_nominal(min=2) = 5
    "Temperature difference across heat exchanger on heating water side (inlet-outlet)"
    annotation (Dialog(group="Heat exchanger", tab="Advanced"));
  parameter Modelica.Units.SI.TemperatureDifference dTHexApp_nominal(min=1) = 2
    "Heat exchanger approach temperature"
    annotation (Dialog(group="Heat exchanger", tab="Advanced"));

  annotation (preferredView="info",Documentation(info="<html>
<p>
This record corresponds to a hot water tank that is filled with heating water, and that has
an external heat exchanger to heat domestic hot water.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2023 by David Blum:<br/>
Updated for release.
</li>
<li>
November 22, 2022 by Dre Helmns:<br/>
Initial implementation.
</li>
</ul>
</html>"));
end GenericDomesticHotWaterWithHeatExchanger;
