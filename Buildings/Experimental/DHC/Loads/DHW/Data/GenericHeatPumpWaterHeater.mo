within Buildings.Experimental.DHC.Loads.DHW.Data;
record GenericHeatPumpWaterHeater
  "Equipment specifications for a generic heat pump water heater"
  parameter Modelica.Units.SI.Volume VTan = 0.3 "Tank volume";
  parameter Modelica.Units.SI.Length hTan = 2 "Height of tank (without insulation)";
  parameter Modelica.Units.SI.Length dIns = 0.3 "Thickness of insulation";
  parameter Modelica.Units.SI.ThermalConductivity kIns = 0.04 "Specific heat conductivity of insulation";
  parameter Modelica.Units.SI.PressureDifference dpHex_nominal = 2500 "Pressure drop across the heat exchanger at nominal conditions";
  parameter Modelica.Units.SI.MassFlowRate mHex_flow_nominal = 0.278 "Mass flow rate of heat exchanger";
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_max(min=0) = 1500 "Maximum heating flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(min=0) = 1230.9 "Nominal heating flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QTan_flow_nominal = mHex_flow_nominal*4200*(THex_nominal-TTan_nominal) "Nominal heating flow rate";
  parameter Modelica.Units.SI.Height hHex_a = 1 "Height of portHex_a of the heat exchanger, measured from tank bottom";
  parameter Modelica.Units.SI.Height hHex_b = 0.2 "Height of portHex_b of the heat exchanger, measured from tank bottom";
  parameter Modelica.Units.SI.Temperature TTan_nominal = 313.15 "Temperature of fluid inside the tank at nominal heat transfer conditions";
  parameter Modelica.Units.SI.Temperature THex_nominal = 333.15 "Temperature of fluid inside the heat exchanger at nominal heat transfer conditions";
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal = -5 "Temperature difference evaporator inlet-outlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal = 10 "Temperature difference condenser outlet-inlet";
  parameter Modelica.Units.SI.PressureDifference dp1_nominal = 5000 "Pressure drop across condenser";
  parameter Modelica.Units.SI.PressureDifference dp2_nominal = 5000 "Pressure drop across evaporator";
  parameter Integer nSeg(min=4) = 5 "Number of volume segments";

  annotation (preferredView="info",Documentation(info="<html>
<p>
This record corresponds to a generic heat pump water heater.
</p>
</html>", revisions="<html>
<ul>
<li>
November 22, 2022 by Dre Helmns:<br/>
Created record.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          origin={0,-25},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-75.0},{100.0,75.0}},
          radius=25.0),
        Line(
          origin={0,-25},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64}),
        Line(
          points={{-100,0},{100,0}},
          color={64,64,64}),
        Line(
          origin={0,-50},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Text(
          lineColor={0,0,255},
          extent={{-150,60},{150,100}},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end GenericHeatPumpWaterHeater;
