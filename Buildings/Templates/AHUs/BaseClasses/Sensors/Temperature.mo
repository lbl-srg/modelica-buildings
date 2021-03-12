within Buildings.Templates.AHUs.BaseClasses.Sensors;
model Temperature
  extends Interfaces.Sensor(
    final typ=Types.Sensor.Temperature);

  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.RealPassThrough THea if
    Modelica.Utilities.Strings.find(insNam, "THea")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,50})));
  Modelica.Blocks.Routing.RealPassThrough TCoo if
    Modelica.Utilities.Strings.find(insNam, "TCoo")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,50})));
  Modelica.Blocks.Routing.RealPassThrough TMix if
    Modelica.Utilities.Strings.find(insNam, "TMix")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,50})));
  Modelica.Blocks.Routing.RealPassThrough TSup if
    Modelica.Utilities.Strings.find(insNam, "TSup")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,50})));
  Modelica.Blocks.Routing.RealPassThrough TOut if
    Modelica.Utilities.Strings.find(insNam, "TOut")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,50})));
equation

  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senTem.T, THea.u) annotation (Line(points={{0,11},{0,20},{-50,20},{-50,
          38}}, color={0,0,127}));
  connect(senTem.T, TCoo.u) annotation (Line(points={{0,11},{0,20},{-20,20},{-20,
          38}}, color={0,0,127}));
  connect(senTem.T, TMix.u)
    annotation (Line(points={{0,11},{0,20},{20,20},{20,38}}, color={0,0,127}));
  connect(senTem.T, TSup.u)
    annotation (Line(points={{0,11},{0,20},{50,20},{50,38}}, color={0,0,127}));
  connect(THea.y, ahuBus.ahuI.THea) annotation (Line(points={{-50,61},{-50,82},{
          -2,82},{-2,100.1},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCoo.y, ahuBus.ahuI.TCoo) annotation (Line(points={{-20,61},{-20,80},{
          0,80},{0,100.1},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TMix.y, ahuBus.ahuI.TMix) annotation (Line(points={{20,61},{20,80},{2,
          80},{2,100.1},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TSup.y, ahuBus.ahuI.TSup) annotation (Line(points={{50,61},{50,82},{4,
          82},{4,100.1},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TOut.y, ahuBus.ahuI.TOut) annotation (Line(points={{-80,61},{-80,84},{
          0.1,84},{0.1,100.1}}, color={0,0,127}));
  connect(senTem.T, TOut.u) annotation (Line(points={{0,11},{0,20},{-80,20},{-80,
          38}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Temperature;
