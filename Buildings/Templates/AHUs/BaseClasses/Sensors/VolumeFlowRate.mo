within Buildings.Templates.AHUs.BaseClasses.Sensors;
model VolumeFlowRate
  extends Interfaces.Sensor(
    final typ=Types.Sensor.Temperature);

  Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.RealPassThrough VOut if
    Modelica.Utilities.Strings.find(insNam, "VOut")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,50})));
  Modelica.Blocks.Routing.RealPassThrough VSup if
    Modelica.Utilities.Strings.find(insNam, "VSup")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
  Modelica.Blocks.Routing.RealPassThrough VRet if
    Modelica.Utilities.Strings.find(insNam, "VRet")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,50})));
equation

  connect(port_a, senVolFlo.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senVolFlo.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senVolFlo.V_flow, VOut.u) annotation (Line(points={{0,11},{0,20},{-40,
          20},{-40,38}}, color={0,0,127}));
  connect(senVolFlo.V_flow, VSup.u)
    annotation (Line(points={{0,11},{0,38}}, color={0,0,127}));
  connect(senVolFlo.V_flow, VRet.u)
    annotation (Line(points={{0,11},{0,20},{40,20},{40,38}}, color={0,0,127}));
  connect(VRet.y, ahuBus.ahuI.VRet) annotation (Line(points={{40,61},{40,80},{2,
          80},{2,100.1},{0.1,100.1}},
                        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(VSup.y, ahuBus.ahuI.VSup) annotation (Line(points={{0,61},{0,80},{0,100.1},
          {0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(VOut.y, ahuBus.ahuI.VOut) annotation (Line(points={{-40,61},{-40,80},{
          -2,80},{-2,100.1},{0.1,100.1}},
                        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end VolumeFlowRate;
