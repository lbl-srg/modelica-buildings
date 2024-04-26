within Buildings.DHC.ETS.Combined.Subsystems.Validation;
model HeatExchanger
  "Validation of the base subsystem model with district heat exchanger"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT bou1Pum(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Primary boundary conditions" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={150,-82})));
  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=4) "Secondary boundary conditions" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-20})));
  Modelica.Blocks.Sources.BooleanExpression uHeaRej(
    y=time >= 3000) "Heat rejection enable signal"
    annotation (Placement(transformation(extent={{-190,90},{-170,110}})));
  Modelica.Blocks.Sources.BooleanExpression uEnaColRej(
    y=time >= 1000 and time < 3000)
    "Cold rejection enable signal"
    annotation (Placement(transformation(extent={{-190,70},{-170,90}})));
  Buildings.DHC.ETS.Combined.Subsystems.HeatExchanger hexPum(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    show_T=true,
    conCon=Buildings.DHC.ETS.Types.ConnectionConfiguration.Pump,
    dp1Hex_nominal=20E3,
    dp2Hex_nominal=20E3,
    Q_flow_nominal=1E6,
    T_a1_nominal=281.15,
    T_b1_nominal=277.15,
    T_a2_nominal=275.15,
    T_b2_nominal=279.15)
    "Heat exchanger with primary pump"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch secondary temperature value depending on heat/cold rejection mode"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1OutPum(redeclare final
      package Medium = Medium, m_flow_nominal=hexPum.m1_flow_nominal)
    "Primary outlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-100})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1InlPum(redeclare final
      package Medium = Medium, m_flow_nominal=hexPum.m1_flow_nominal)
    "Primary inlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2OutPum(redeclare final
      package Medium = Medium, m_flow_nominal=hexPum.m2_flow_nominal)
    "Secondary outlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2InlPum(redeclare final
      package Medium = Medium, m_flow_nominal=hexPum.m2_flow_nominal)
    "Secondary inlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-100})));
  Buildings.DHC.ETS.Combined.Subsystems.HeatExchanger hexVal(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    show_T=true,
    conCon=Buildings.DHC.ETS.Types.ConnectionConfiguration.TwoWayValve,
    dp1Hex_nominal=20E3,
    dp2Hex_nominal=20E3,
    Q_flow_nominal=1E6,
    T_a1_nominal=281.15,
    T_b1_nominal=277.15,
    T_a2_nominal=275.15,
    T_b2_nominal=279.15)
    "Heat exchanger with primary control valve"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Fluid.Sources.Boundary_pT bou1InlVal(
    redeclare package Medium = Medium,
    p=Medium.p_default + 30E3,
    use_T_in=true,
    nPorts=1) "Primary boundary conditions" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={152,20})));
  Buildings.Fluid.Sources.Boundary_pT bou1OutVal(redeclare package Medium =
        Medium, nPorts=1) "Primary boundary conditions" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={150,-20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1InlVal(redeclare final
      package Medium = Medium, m_flow_nominal=hexVal.m1_flow_nominal)
    "Primary inlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT1OutVal(redeclare final
      package Medium = Medium, m_flow_nominal=hexVal.m1_flow_nominal)
    "Primary outlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2OutVal(redeclare final
      package Medium = Medium, m_flow_nominal=hexVal.m2_flow_nominal)
    "Secondary outlet temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2InlVal(redeclare final
      package Medium = Medium, m_flow_nominal=hexVal.m2_flow_nominal)
    "Secondary inlet temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-20})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Compute enable signal for heat/cold rejection"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Sources.RealExpression yValIsoCon(
    y=if time >= 2500 then
        1
      else
        0)
    "Condenser loop isolation valve opening"
    annotation (Placement(transformation(extent={{-190,50},{-170,70}})));
  Modelica.Blocks.Sources.RealExpression yValIsoEva(
    y=if time >= 500 then
        1
      else
        0)
    "Evaporator loop isolation valve opening"
    annotation (Placement(transformation(extent={{-190,30},{-170,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin1(
    amplitude=0.5,
    freqHz=1e-3,
    offset=0.5)
    "Control signal"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Activate heat/cold rejection"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    k=0) "Zero"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Modelica.Blocks.Sources.TimeTable TColVal(
    y(final unit="K",
      displayUnit="degC"),
    table=[
      0,6;
      2,6;
      3,16;
      4.5,16;
      5,6;
      10,6],
    timeScale=1000,
    offset=273.15) "Cold side temperature values"
    annotation (Placement(transformation(extent={{-190,-70},{-170,-50}})));
  Modelica.Blocks.Sources.TimeTable THotVal(
    y(final unit="K",
      displayUnit="degC"),
    table=[
      0,45;
      2,45;
      3,55;
      4.5,55;
      5,25;
      10,25],
    timeScale=1000,
    offset=273.15)
    "Hot side temperature values"
    annotation (Placement(transformation(extent={{-190,-110},{-170,-90}})));
  Modelica.Blocks.Sources.TimeTable TSerWat(
    y(final unit="K",
      displayUnit="degC"),
    table=[
      0,8;
      1,8;
      2,13;
      3,18;
      4,6;
      5,18],
    timeScale=1000,
    offset=273.15) "Service water temperature values"
    annotation (Placement(transformation(extent={{210,-90},{190,-70}})));
equation
  connect(swi.y, bou2.T_in) annotation (Line(points={{-98,-80},{-90,-80},{-90,
          -16},{-82,-16}}, color={0,0,127}));
  connect(uEnaColRej.y,swi.u2)
    annotation (Line(points={{-169,80},{-140,80},{-140,20},{-120,20},{-120,-60},
          {-130,-60},{-130,-80},{-122,-80}},                                                                        color={255,0,255}));
  connect(hexPum.port_b1,senT1OutPum.port_a)
    annotation (Line(points={{50,-74},{80,-74},{80,-100},{100,-100}},
                                                                  color={0,127,255}));
  connect(senT1OutPum.port_b, bou1Pum.ports[1]) annotation (Line(points={{120,
          -100},{140,-100},{140,-83}},
                                 color={0,127,255}));
  connect(hexPum.port_a1,senT1InlPum.port_b)
    annotation (Line(points={{30,-74},{20,-74},{20,-60},{100,-60}},  color={0,127,255}));
  connect(senT1InlPum.port_a, bou1Pum.ports[2]) annotation (Line(points={{120,-60},
          {140,-60},{140,-81}}, color={0,127,255}));
  connect(hexPum.port_b2,senT2OutPum.port_a)
    annotation (Line(points={{30,-86},{0,-86},{0,-60},{-20,-60}},     color={0,127,255}));
  connect(senT2OutPum.port_b, bou2.ports[1]) annotation (Line(points={{-40,-60},
          {-50,-60},{-50,-24},{-60,-24},{-60,-21.5}},
                                                    color={0,127,255}));
  connect(bou2.ports[2], senT2InlPum.port_a) annotation (Line(points={{-60,
          -20.5},{-60,-100},{-40,-100}},
                                  color={0,127,255}));
  connect(senT2InlPum.port_b,hexPum.port_a2)
    annotation (Line(points={{-20,-100},{60,-100},{60,-86},{50,-86}},
                                                                   color={0,127,255}));
  connect(hexVal.port_a1,senT1InlVal.port_b)
    annotation (Line(points={{30,6},{20,6},{20,20},{100,20}},    color={0,127,255}));
  connect(senT1InlVal.port_a, bou1InlVal.ports[1])
    annotation (Line(points={{120,20},{142,20}}, color={0,127,255}));
  connect(bou1OutVal.ports[1], senT1OutVal.port_b)
    annotation (Line(points={{140,-20},{120,-20}}, color={0,127,255}));
  connect(senT1OutVal.port_a,hexVal.port_b1)
    annotation (Line(points={{100,-20},{70,-20},{70,6},{50,6}},
                                                            color={0,127,255}));
  connect(hexVal.port_a2,senT2InlVal.port_b)
    annotation (Line(points={{50,-6},{60,-6},{60,-20},{-20,-20}},
                                                             color={0,127,255}));
  connect(senT2OutVal.port_a,hexVal.port_b2)
    annotation (Line(points={{-20,20},{0,20},{0,-6},{30,-6}},     color={0,127,255}));
  connect(uEnaColRej.y,or2.u2)
    annotation (Line(points={{-169,80},{-140,80},{-140,72},{-122,72}},  color={255,0,255}));
  connect(uHeaRej.y,or2.u1)
    annotation (Line(points={{-169,100},{-130,100},{-130,80},{-122,80}},  color={255,0,255}));
  connect(yValIsoCon.y,hexVal.yValIso_actual[1])
    annotation (Line(points={{-169,60},{8,60},{8,-2.5},{28,-2.5}}, color={0,0,127}));
  connect(yValIsoCon.y,hexPum.yValIso_actual[1])
    annotation (Line(points={{-169,60},{8,60},{8,-82.5},{28,-82.5}}, color={0,0,127}));
  connect(yValIsoEva.y,hexVal.yValIso_actual[2])
    annotation (Line(points={{-169,40},{4,40},{4,-1.5},{28,-1.5}}, color={0,0,127}));
  connect(yValIsoEva.y,hexPum.yValIso_actual[2])
    annotation (Line(points={{-169,40},{4,40},{4,-81.5},{28,-81.5}}, color={0,0,127}));
  connect(or2.y,swi1.u2)
    annotation (Line(points={{-98,80},{-22,80}},   color={255,0,255}));
  connect(sin1.y,swi1.u1)
    annotation (Line(points={{-58,140},{-40,140},{-40,88},{-22,88}},  color={0,0,127}));
  connect(zer.y,swi1.u3)
    annotation (Line(points={{-58,100},{-50,100},{-50,72},{-22,72}},color={0,0,127}));
  connect(swi1.y,hexVal.u)
    annotation (Line(points={{2,80},{12,80},{12,2},{28,2}},         color={0,0,127}));
  connect(swi1.y,hexPum.u)
    annotation (Line(points={{2,80},{12,80},{12,-78},{28,-78}},       color={0,0,127}));
  connect(TColVal.y,swi.u1)
    annotation (Line(points={{-169,-60},{-140,-60},{-140,-72},{-122,-72}},color={0,0,127}));
  connect(THotVal.y,swi.u3)
    annotation (Line(points={{-169,-100},{-140,-100},{-140,-88},{-122,-88}},
                                                                          color={0,0,127}));
  connect(TSerWat.y, bou1Pum.T_in) annotation (Line(points={{189,-80},{180,-80},
          {180,-78},{162,-78}}, color={0,0,127}));
  connect(TSerWat.y, bou1InlVal.T_in) annotation (Line(points={{189,-80},{180,-80},
          {180,24},{164,24}}, color={0,0,127}));
  connect(senT2OutVal.port_b, bou2.ports[3])
    annotation (Line(points={{-40,20},{-60,20},{-60,-19.5}},
                                                           color={0,127,255}));
  connect(bou2.ports[4], senT2InlVal.port_a) annotation (Line(points={{-60,
          -18.5},{-60,-20},{-40,-20}},
                                color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-220,-160},{220,160}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Subsystems/Validation/HeatExchanger.mos" "Simulate and plot"),
    experiment(
      StopTime=5000,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.HeatExchanger\">
Buildings.DHC.ETS.Combined.Subsystems.HeatExchanger</a>
in a configuration where the primary flow rate is modulated by means of a
two-way valve (see <code>hexVal</code>), and in a configuration where the
primary flow rate is modulated by means of a variable speed pump
(see <code>hexPum</code>).
</p>
</html>"));
end HeatExchanger;
