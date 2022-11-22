within Buildings.Experimental.DHC.Loads.Heating.DHW.Data;
record DirectHeatExchangerWaterHeater
  "Equipment specifications for a typical direct heat exchanger water heater"
  parameter Boolean havePEle = true "Flag that specifies whether electric power is required for water heating";
  parameter Modelica.Units.SI.Efficiency eps(max=1) = 0.8 "Heat exchanger effectiveness";
  parameter Modelica.Units.SI.HeatFlowRate QMax_flow(min=0) = Modelica.Constants.inf "Maximum heat flow rate for heating (positive)";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
end DirectHeatExchangerWaterHeater;
