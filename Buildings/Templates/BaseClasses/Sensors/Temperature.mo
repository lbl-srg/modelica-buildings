within Buildings.Templates.BaseClasses.Sensors;
model Temperature
  extends Buildings.Templates.Interfaces.Sensor(
    typ=Types.Sensor.Temperature);

  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal) if typ==Types.Sensor.Temperature
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  PassThroughFluid pas(
    redeclare final package Medium=Medium) if typ==Types.Sensor.None
    "Pass through"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation

  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senTem.T, busCon.T) annotation (Line(points={{0,11},{0,100}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a, pas.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,-40},
          {-10,-40}}, color={0,127,255}));
  connect(pas.port_b, port_b) annotation (Line(points={{10,-40},{80,-40},{80,0},
          {100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Temperature;
