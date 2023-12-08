within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model HeatPumpWaterHeaterWrapped
    "Wrapped heat pump water heater model"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
  redeclare package Medium1 = MediumAir,
  redeclare package Medium2 = MediumTan);

  package MediumAir = Buildings.Media.Air;
  package MediumTan = Buildings.Media.Water "Medium in the tank";

  Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed sinSpeDXCoo(
    datCoi=datCoi,
      redeclare package Medium = MediumAir,
    dp_nominal=65)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Fluid.Storage.StratifiedEnhanced tan1(
    redeclare package Medium = MediumTan,
    m_flow_nominal=0.1,
    VTan=0.287691,
    hTan=1.594,
    dIns=0.05)            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={36,-26})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow hea
    "Heat input to the hot water tank"
    annotation (Placement(transformation(extent={{-26,-36},{-6,-16}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.2279,
    dp_nominal=65)
    annotation (Placement(transformation(extent={{24,50},{44,70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSen
    "Temperature tank sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-50,10}})));
  Modelica.Blocks.Logical.Hysteresis onOffHea(uLow=273.15 + 43.89 - 3.89, uHigh=
       273.15 + 43.89)      "Controller for heater"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.BooleanToReal yMov "Boolean to real"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  parameter
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil
    datCoi(nSta=1, sta={
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-10500,
          COP_nominal=3,
          SHR_nominal=0.798655,
          m_flow_nominal=1.72),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_II())})
    "Coil data"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
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
  connect(onOffHea.y,yMov. u)
    annotation (Line(points={{-59,30},{-42,30}},       color={255,0,255}));
  connect(TSen.T, onOffHea.u) annotation (Line(points={{-51,0},{-88,0},{-88,30},
          {-82,30}}, color={0,0,127}));
  connect(yMov.y, fan.m_flow_in) annotation (Line(points={{-19,30},{0,30},{0,82},
          {34,82},{34,72}}, color={0,0,127}));
  connect(onOffHea.y, sinSpeDXCoo.on) annotation (Line(points={{-59,30},{-54,30},
          {-54,68},{-51,68}}, color={255,0,255}));
  connect(TSen.T, sinSpeDXCoo.TOut) annotation (Line(points={{-51,0},{-88,0},{
          -88,63},{-51,63}}, color={0,0,127}));
  connect(TSen.port, tan1.heaPorVol[3]) annotation (Line(points={{-30,0},{4,0},{
          4,-26},{36,-26}}, color={191,0,0}));
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
