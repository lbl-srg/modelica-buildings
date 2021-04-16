within Buildings.Templates.BaseClasses.Sensors;
model Wrapper "Wrapper class for sensor models"
  extends Buildings.Templates.Interfaces.Sensor;

  HumidityRatio hum(
    redeclare final package Medium = Medium,
    final loc=loc,
    final m_flow_nominal=m_flow_nominal) if
       typ==Buildings.Templates.Types.Sensor.HumidityRatio
    "Humidity ratio"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  None non(
    redeclare final package Medium = Medium,
    final loc=loc,
    final m_flow_nominal=m_flow_nominal) if
       typ==Buildings.Templates.Types.Sensor.None
    "No sensor"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  SpecificEnthalpy entSpe(
    redeclare final package Medium = Medium,
    final loc=loc,
    final m_flow_nominal=m_flow_nominal) if
       typ==Buildings.Templates.Types.Sensor.SpecificEnthalpy
    "Specific enthalpy"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Temperature tem(
    redeclare final package Medium = Medium,
    final loc=loc,
    final m_flow_nominal=m_flow_nominal) if
       typ==Buildings.Templates.Types.Sensor.Temperature
    "Temperature"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  VolumeFlowRate volFlo(
    redeclare final package Medium = Medium,
    final loc=loc,
    final m_flow_nominal=m_flow_nominal) if
       typ==Buildings.Templates.Types.Sensor.VolumeFlowRate
    "Volume flow rate"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  DifferentialPressure preDif(
    redeclare final package Medium = Medium,
    final loc=loc,
    final m_flow_nominal=m_flow_nominal) if
       typ==Buildings.Templates.Types.Sensor.DifferentialPressure
    "Differential pressure"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(port_a, preDif.port_a) annotation (Line(points={{-100,0},{-90,0},{-90,
          60},{-80,60}}, color={0,127,255}));
  connect(preDif.port_b, port_b) annotation (Line(points={{-60,60},{60,60},{60,0},
          {100,0}}, color={0,127,255}));
  connect(preDif.busCon, busCon) annotation (Line(
      points={{-70,70},{-70,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(hum.busCon, busCon) annotation (Line(
      points={{-40,50},{-40,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(non.busCon, busCon) annotation (Line(
      points={{-10,30},{-10,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(entSpe.busCon, busCon) annotation (Line(
      points={{20,10},{20,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(port_a, hum.port_a) annotation (Line(points={{-100,0},{-60,0},{-60,40},
          {-50,40}}, color={0,127,255}));
  connect(hum.port_b, port_b) annotation (Line(points={{-30,40},{60,40},{60,0},{
          100,0}}, color={0,127,255}));
  connect(port_a, non.port_a) annotation (Line(points={{-100,0},{-40,0},{-40,20},
          {-20,20}}, color={0,127,255}));
  connect(port_a, entSpe.port_a)
    annotation (Line(points={{-100,0},{10,0}}, color={0,127,255}));
  connect(entSpe.port_b, port_b)
    annotation (Line(points={{30,0},{100,0}}, color={0,127,255}));
  connect(preDif.port_bRef, port_bRef) annotation (Line(points={{-70,50},{-70,-80},
          {0,-80},{0,-100}}, color={0,127,255}));
  connect(non.port_b, port_b) annotation (Line(points={{0,20},{60,20},{60,0},{100,
          0}}, color={0,127,255}));
  connect(port_a, tem.port_a) annotation (Line(points={{-100,0},{0,0},{0,-20},{40,
          -20}}, color={0,127,255}));
  connect(port_a, volFlo.port_a) annotation (Line(points={{-100,0},{0,0},{0,-40},
          {70,-40}}, color={0,127,255}));
  connect(tem.busCon, busCon) annotation (Line(
      points={{50,-10},{50,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(volFlo.busCon, busCon) annotation (Line(
      points={{80,-30},{80,80},{0,80},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(volFlo.port_b, port_b) annotation (Line(points={{90,-40},{94,-40},{94,
          0},{100,0}}, color={0,127,255}));
  connect(tem.port_b, port_b) annotation (Line(points={{60,-20},{70,-20},{70,0},
          {100,0}}, color={0,127,255}));
end Wrapper;
