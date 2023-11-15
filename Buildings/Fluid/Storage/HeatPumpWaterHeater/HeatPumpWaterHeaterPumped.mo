within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model HeatPumpWaterHeaterPumped "Wrapped heat pump water heater model"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;

  DXSystems.Cooling.WaterSource.SingleSpeed singleSpeed
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  StratifiedEnhancedInternalHex tan1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={36,-26})));
  Movers.FlowControlled_m_flow fan
    annotation (Placement(transformation(extent={{24,50},{44,70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSen
    "Temperature tank sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
  Modelica.Blocks.Logical.Hysteresis onOffHea(uLow=273.15 + 50 - 0.05, uHigh=
        273.15 + 50 + 0.05) "Controller for heater"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.BooleanToReal yMov "Boolean to real"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Movers.FlowControlled_m_flow fan1
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] heaPorVol
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}),
        iconTransformation(extent={{-6,-6},{6,6}})));
equation
  connect(port_a1, singleSpeed.port_a)
    annotation (Line(points={{-100,60},{-50,60}}, color={0,127,255}));
  connect(fan.port_b, port_b1)
    annotation (Line(points={{44,60},{100,60}}, color={0,127,255}));
  connect(singleSpeed.port_b, fan.port_a)
    annotation (Line(points={{-30,60},{24,60}}, color={0,127,255}));
  connect(port_a2, tan1.port_b)
    annotation (Line(points={{100,-60},{36,-60},{36,-36}}, color={0,127,255}));
  connect(tan1.port_a, port_b2) annotation (Line(points={{36,-16},{36,-10},{-80,
          -10},{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(tan1.heaPorVol[3], TSen.port) annotation (Line(points={{36,-26},{6,
          -26},{6,0},{-30,0}}, color={191,0,0}));
  connect(onOffHea.y,yMov. u)
    annotation (Line(points={{-59,30},{-42,30}},       color={255,0,255}));
  connect(TSen.T, onOffHea.u) annotation (Line(points={{-51,0},{-94,0},{-94,30},
          {-82,30}}, color={0,0,127}));
  connect(yMov.y, fan.m_flow_in) annotation (Line(points={{-19,30},{0,30},{0,82},
          {34,82},{34,72}}, color={0,0,127}));
  connect(onOffHea.y, singleSpeed.on) annotation (Line(points={{-59,30},{-56,30},
          {-56,68},{-51,68}}, color={255,0,255}));
  connect(fan1.port_b, tan1.portHex_a) annotation (Line(points={{-20,-60},{16,
          -60},{16,-29.8},{26,-29.8}}, color={0,127,255}));
  connect(yMov.y, fan1.m_flow_in) annotation (Line(points={{-19,30},{-8,30},{-8,
          -40},{-30,-40},{-30,-48}}, color={0,0,127}));
  connect(tan1.portHex_b, singleSpeed.portCon_a) annotation (Line(points={{26,
          -34},{-14,-34},{-14,48},{-34,48},{-34,50}}, color={0,127,255}));
  connect(singleSpeed.portCon_b, fan1.port_a) annotation (Line(points={{-46,50},
          {-46,48},{-52,48},{-52,-60},{-40,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-40,60},{40,20}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-20},{40,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,100},{-2,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-60},{-2,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{40,-20}},
          lineColor={255,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{50,68},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,66},{-50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,68},{50,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,-60},{50,-68}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{40,-20}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-40,68},{-50,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,68},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpWaterHeaterPumped;
