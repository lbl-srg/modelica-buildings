within Buildings.Templates.AHUs.BaseClasses.Sensors;
model Temperature
  extends Interfaces.Sensor(
    final typ=Types.Sensor.Temperature);
  extends Data.Temperature
    annotation (IconMap(primitivesVisible=false));
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
        origin={-60,50})));
  Modelica.Blocks.Routing.RealPassThrough TCoo if insNam=="TCoo"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,50})));
  Modelica.Blocks.Routing.RealPassThrough TMix if insNam=="TMix"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,50})));
  Modelica.Blocks.Routing.RealPassThrough TSup if insNam=="TSup"
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,50})));
equation

  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senTem.T, THea.u) annotation (Line(points={{0,11},{0,20},{-60,20},{
          -60,38}},
                color={0,0,127}));
  connect(senTem.T, TCoo.u) annotation (Line(points={{0,11},{0,20},{-30,20},{
          -30,38}},
                color={0,0,127}));
  connect(senTem.T, TMix.u)
    annotation (Line(points={{0,11},{0,20},{20,20},{20,38}}, color={0,0,127}));
  connect(senTem.T, TSup.u)
    annotation (Line(points={{0,11},{0,20},{50,20},{50,38}}, color={0,0,127}));
  connect(THea.y, ahuBus.ahuI.TAirLvgCoiHea) annotation (Line(points={{-60,61},
          {-60,100.1},{0.1,100.1}}, color={0,0,127}));
  connect(TCoo.y, ahuBus.ahuI.TAirLvgCoiCoo) annotation (Line(points={{-30,61},
          {-30,100.1},{0.1,100.1}}, color={0,0,127}));
  connect(TMix.y, ahuBus.ahuI.TAirMix) annotation (Line(points={{20,61},{20,
          100.1},{0.1,100.1}}, color={0,0,127}));
  connect(TSup.y, ahuBus.ahuI.TAirSup) annotation (Line(points={{50,61},{50,100},
          {0.1,100},{0.1,100.1}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Temperature;
