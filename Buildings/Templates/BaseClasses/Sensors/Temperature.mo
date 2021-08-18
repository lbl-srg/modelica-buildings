within Buildings.Templates.BaseClasses.Sensors;
model Temperature
  extends Buildings.Templates.Interfaces.Sensor(
    final typ=Types.Sensor.Temperature);

  Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.RealPassThrough THea
 if Modelica.Utilities.Strings.find(insNam, "THea")<>0 or
    Modelica.Utilities.Strings.find(insNam, "coiHea.TLvg")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-54,50})));
  Modelica.Blocks.Routing.RealPassThrough TCoo
 if Modelica.Utilities.Strings.find(insNam, "TCoo")<>0 or
    Modelica.Utilities.Strings.find(insNam, "coiCoo.TLvg")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-28,50})));
  Modelica.Blocks.Routing.RealPassThrough TMix
 if Modelica.Utilities.Strings.find(insNam, "TMix")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={28,50})));
  Modelica.Blocks.Routing.RealPassThrough TSup
 if Modelica.Utilities.Strings.find(insNam, "TSup")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={54,50})));
  Modelica.Blocks.Routing.RealPassThrough TOut
 if Modelica.Utilities.Strings.find(insNam, "TOut")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,50})));
  Modelica.Blocks.Routing.RealPassThrough TRet
 if Modelica.Utilities.Strings.find(insNam, "TRet")<>0
    "Pass through to connect with specific control signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={82,50})));
  Modelica.Blocks.Routing.RealPassThrough TDis
 if Modelica.Utilities.Strings.find(insNam, "TDis")<>0 or
    Modelica.Utilities.Strings.find(insNam, "coiReh.TLvg")<>0
    "Pass through to connect with specific control signal"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
equation

  connect(port_a, senTem.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(senTem.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(senTem.T, THea.u) annotation (Line(points={{0,11},{0,20},{-54,20},{-54,
          38}}, color={0,0,127}));
  connect(senTem.T, TCoo.u) annotation (Line(points={{0,11},{0,20},{-28,20},{-28,
          38}}, color={0,0,127}));
  connect(senTem.T, TMix.u)
    annotation (Line(points={{0,11},{0,20},{28,20},{28,38}}, color={0,0,127}));
  connect(senTem.T, TSup.u)
    annotation (Line(points={{0,11},{0,20},{54,20},{54,38}}, color={0,0,127}));
  connect(THea.y,busCon.inp.THea)  annotation (Line(points={{-54,61},{-54,82},{-2,
          82},{-2,100.1},{0.1,100.1}},    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCoo.y,busCon.inp.TCoo)  annotation (Line(points={{-28,61},{-28,80},{0,
          80},{0,100.1},{0.1,100.1}},   color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TMix.y,busCon.inp.TMix)  annotation (Line(points={{28,61},{28,80},{2,80},
          {2,100.1},{0.1,100.1}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSup.y,busCon.inp.TSup)  annotation (Line(points={{54,61},{54,82},{4,82},
          {4,100.1},{0.1,100.1}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TOut.y,busCon.inp.TOut)  annotation (Line(points={{-80,61},{-80,84},{
          -4,84},{-4,100},{0.1,100},{0.1,100.1}},
                                color={0,0,127}),Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTem.T, TOut.u) annotation (Line(points={{0,11},{0,20},{-80,20},{-80,
          38}}, color={0,0,127}));
  connect(senTem.T, TRet.u)
    annotation (Line(points={{0,11},{0,20},{82,20},{82,38}}, color={0,0,127}));
  connect(TRet.y, busCon.inp.TRet) annotation (Line(points={{82,61},{82,84},{6,84},
          {6,100.1},{0.1,100.1}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TDis.y, busCon.inp.TDis) annotation (Line(points={{6.66134e-16,61},{6.66134e-16,
          100.1},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTem.T, TDis.u) annotation (Line(points={{0,11},{0,38},{-8.88178e-16,
          38}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Temperature;
