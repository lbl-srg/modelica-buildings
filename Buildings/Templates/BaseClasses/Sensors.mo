within Buildings.Templates.BaseClasses;
package Sensors
  extends Modelica.Icons.Package;
  model DifferentialPressure
    extends Buildings.Templates.Interfaces.Sensor(
      final typ=AHUs.Types.Sensor.DifferentialPressure);

    Fluid.Sensors.RelativePressure senRelPre(
      redeclare final package Medium=Medium)
      "Relative pressure sensor"
      annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
    Modelica.Blocks.Routing.RealPassThrough pSup_rel if
      Modelica.Utilities.Strings.find(insNam, "pSup")<>0
      "Pass through to connect with specific control signal" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,50})));
    Modelica.Blocks.Routing.RealPassThrough dpOut if
      Modelica.Utilities.Strings.find(insNam, "dpOut")<>0
      "Pass through to connect with specific control signal" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={40,50})));
    Modelica.Blocks.Routing.RealPassThrough pRet_rel if
      Modelica.Utilities.Strings.find(insNam, "pRet")<>0
      "Pass through to connect with specific control signal" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-40,50})));
  equation
    connect(port_a, senRelPre.port_a) annotation (Line(points={{-100,0},{-80,0},{-80,
            -40},{-50,-40}}, color={0,127,255}));
    connect(port_a, port_b)
      annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
    connect(senRelPre.port_b, port_bRef)
      annotation (Line(points={{-30,-40},{-20,-40},{-20,-90},{0,-90},{0,-100}},
                                                            color={0,127,255}));
    connect(senRelPre.p_rel, pSup_rel.u)
      annotation (Line(points={{-40,-31},{-40,-20},{-8.88178e-16,-20},{
            -8.88178e-16,38}},                      color={0,0,127}));
    connect(senRelPre.p_rel, dpOut.u) annotation (Line(points={{-40,-31},{-40,-20},
            {40,-20},{40,38}}, color={0,0,127}));
    connect(dpOut.y,busCon.inp.dpOut)
      annotation (Line(points={{40,61},{40,80},{2,80},{2,100.1},{0.1,100.1}},
                                          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(pSup_rel.y,busCon.inp.pSup_rel)  annotation (Line(points={{6.66134e-16,
            61},{6.66134e-16,80},{0,80},{0,100},{0,100.1},{0.1,100.1}},
                                                         color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(senRelPre.p_rel, pRet_rel.u) annotation (Line(points={{-40,-31},{-40,
            38}}, color={0,0,127}));
    connect(pRet_rel.y,busCon.inp.pRet_rel)  annotation (Line(points={{-40,61},{-40,
            80},{-2,80},{-2,100},{0.1,100},{0.1,100.1}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
  end DifferentialPressure;

  model HumidityRatio
    extends Buildings.Templates.Interfaces.Sensor(
      final typ=AHUs.Types.Sensor.HumidityRatio);

    Fluid.Sensors.MassFractionTwoPort senMasFra(
      redeclare final package Medium=Medium,
      final m_flow_nominal=m_flow_nominal)
      "Mass fraction sensor"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Utilities.Psychrometrics.ToDryAir toDryAir
      "Conversion into kg/kg dry air"
      annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,30})));
    Modelica.Blocks.Routing.RealPassThrough xSup if
      Modelica.Utilities.Strings.find(insNam, "xSup")<>0
      "Pass through to connect with specific control signal" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,70})));

  equation
    connect(port_a, senMasFra.port_a)
      annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
    connect(senMasFra.port_b, port_b)
      annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
    connect(senMasFra.X, toDryAir.XiTotalAir)
      annotation (Line(points={{0,11},{0,19}}, color={0,0,127}));

    connect(toDryAir.XiDry, xSup.u) annotation (Line(points={{6.66134e-16,41},{0,
            41},{0,44},{-8.88178e-16,44},{-8.88178e-16,58}},
                                    color={0,0,127}));
    connect(xSup.y,busCon.inp.xSup)  annotation (Line(points={{0,81},{0,90},{0,
            100.1},{0.1,100.1}},
                          color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
  end HumidityRatio;

  model None
    extends Buildings.Templates.Interfaces.Sensor(
      final typ=AHUs.Types.Sensor.None);
  equation
    connect(port_a, port_b)
      annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
    annotation (
      defaultComponentName="sen",
      Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                                                Line(
            points={{-100,0},{100,0}},
            color={28,108,200},
            thickness=1)}),                                        Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end None;

  model Temperature
    extends Buildings.Templates.Interfaces.Sensor(
      final typ=AHUs.Types.Sensor.Temperature);

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
    connect(THea.y,busCon.inp.THea)  annotation (Line(points={{-50,61},{-50,82},{
            -2,82},{-2,100.1},{0.1,100.1}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TCoo.y,busCon.inp.TCoo)  annotation (Line(points={{-20,61},{-20,80},{
            0,80},{0,100.1},{0.1,100.1}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TMix.y,busCon.inp.TMix)  annotation (Line(points={{20,61},{20,80},{2,
            80},{2,100.1},{0.1,100.1}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    connect(TSup.y,busCon.inp.TSup)  annotation (Line(points={{50,61},{50,82},{4,
            82},{4,100.1},{0.1,100.1}}, color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(TOut.y,busCon.inp.TOut)  annotation (Line(points={{-80,61},{-80,84},{
            0.1,84},{0.1,100.1}}, color={0,0,127}));
    connect(senTem.T, TOut.u) annotation (Line(points={{0,11},{0,20},{-80,20},{-80,
            38}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
  end Temperature;

  model VolumeFlowRate
    extends Buildings.Templates.Interfaces.Sensor(
      final typ=AHUs.Types.Sensor.Temperature);

    Fluid.Sensors.VolumeFlowRate senVolFlo(
      redeclare final package Medium=Medium,
      final m_flow_nominal=m_flow_nominal)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Routing.RealPassThrough VOut_flow if
      Modelica.Utilities.Strings.find(insNam, "VOut")<>0
      "Pass through to connect with specific control signal" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-40,50})));
    Modelica.Blocks.Routing.RealPassThrough VSup_flow if
      Modelica.Utilities.Strings.find(insNam, "VSup")<>0
      "Pass through to connect with specific control signal" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,50})));
    Modelica.Blocks.Routing.RealPassThrough VRet_flow if
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
    connect(senVolFlo.V_flow, VOut_flow.u) annotation (Line(points={{0,11},{0,20},
            {-40,20},{-40,38}}, color={0,0,127}));
    connect(senVolFlo.V_flow, VSup_flow.u)
      annotation (Line(points={{0,11},{0,38}}, color={0,0,127}));
    connect(senVolFlo.V_flow, VRet_flow.u)
      annotation (Line(points={{0,11},{0,20},{40,20},{40,38}}, color={0,0,127}));
    connect(VRet_flow.y,busCon.inp.VRet_flow)  annotation (Line(points={{40,61},{
            40,80},{2,80},{2,100.1},{0.1,100.1}},
                                           color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(VSup_flow.y,busCon.inp.VSup_flow)  annotation (Line(points={{0,61},{0,
            80},{0,100.1},{0.1,100.1}},
                                    color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    connect(VOut_flow.y,busCon.inp.VOut_flow)  annotation (Line(points={{-40,61},
            {-40,80},{-2,80},{-2,100.1},{0.1,100.1}},
                                                 color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{-3,6},{-3,6}},
        horizontalAlignment=TextAlignment.Right));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)));
  end VolumeFlowRate;
end Sensors;
