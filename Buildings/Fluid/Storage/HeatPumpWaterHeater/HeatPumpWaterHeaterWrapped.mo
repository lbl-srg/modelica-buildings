within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model HeatPumpWaterHeaterWrapped
    "Wrapped heat pump water heater model"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;




  DXSystems.Cooling.AirSource.SingleSpeed sinSpeDXCoo
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  StratifiedEnhanced tan1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={36,-26})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow hea
    "Heat input to the hot water tank"
    annotation (Placement(transformation(extent={{-26,-36},{-6,-16}})));
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
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] heaPorVol
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}),
        iconTransformation(extent={{-6,-6},{6,6}})));
protected
  Modelica.Blocks.Sources.RealExpression QCon(final y=sinSpeDXCoo.dxCoi.Q_flow
         + sinSpeDXCoo.P) "Signal of total heat flow removed by condenser"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={
            -50,-26})));
equation
  connect(QCon.y, hea.Q_flow)
    annotation (Line(points={{-39,-26},{-26,-26}}, color={0,0,127}));
  connect(port_a1, sinSpeDXCoo.port_a)
    annotation (Line(points={{-100,60},{-50,60}}, color={0,127,255}));
  connect(fan.port_b, port_b1)
    annotation (Line(points={{44,60},{100,60}}, color={0,127,255}));
  connect(sinSpeDXCoo.port_b, fan.port_a)
    annotation (Line(points={{-30,60},{24,60}}, color={0,127,255}));
  connect(port_a2, tan1.port_b)
    annotation (Line(points={{100,-60},{36,-60},{36,-36}}, color={0,127,255}));
  connect(tan1.port_a, port_b2) annotation (Line(points={{36,-16},{36,-10},{-80,
          -10},{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(hea.port, tan1.heaPorVol[3])
    annotation (Line(points={{-6,-26},{36,-26}}, color={191,0,0}));
  connect(tan1.heaPorVol[3], TSen.port) annotation (Line(points={{36,-26},{6,
          -26},{6,0},{-30,0}}, color={191,0,0}));
  connect(onOffHea.y,yMov. u)
    annotation (Line(points={{-59,30},{-42,30}},       color={255,0,255}));
  connect(TSen.T, onOffHea.u) annotation (Line(points={{-51,0},{-94,0},{-94,30},
          {-82,30}}, color={0,0,127}));
  connect(yMov.y, fan.m_flow_in) annotation (Line(points={{-19,30},{0,30},{0,82},
          {34,82},{34,72}}, color={0,0,127}));
  connect(onOffHea.y, sinSpeDXCoo.on) annotation (Line(points={{-59,30},{-56,30},
          {-56,68},{-51,68}}, color={255,0,255}));
  connect(TSen.T, sinSpeDXCoo.TOut) annotation (Line(points={{-51,0},{-88,0},{
          -88,63},{-51,63}}, color={0,0,127}));
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
end HeatPumpWaterHeaterWrapped;
