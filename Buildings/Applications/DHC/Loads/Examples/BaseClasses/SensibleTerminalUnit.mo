within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model SensibleTerminalUnit
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    haveFanPum=true,
    haveEleHeaCoo=false,
    final m_flow1_nominal=abs(Q_flow_nominal ./ cp1_nominal ./ (T_a1_nominal - T_b1_nominal)), nPorts1=2);
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMinT(
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=false,
    yMin=0) "PID controller for minimum temperature"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Modelica.Blocks.Sources.RealExpression m_flow2(y=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,40})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare each final package Medium = Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=max(m_flow2_nominal),
    redeclare Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=max(dp2_nominal),
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THexInlMes(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m_flow2_nominal[1],
    final allowFlowReversal=allowFlowReversal) annotation (Placement(transformation(extent={{150,-10},
            {130,10}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexHea(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final configuration=hexCon[1],
    final m1_flow_nominal=m_flow1_nominal[1],
    final m2_flow_nominal=m_flow2_nominal[1],
    final dp1_nominal=0,
    final dp2_nominal=dp2_nominal[1],
    final Q_flow_nominal=Q_flow_nominal[1],
    final T_a1_nominal=T_a1_nominal[1],
    final T_a2_nominal=T_a2_nominal[1],
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal) annotation (Placement(transformation(extent={{-80,4},
            {-60,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiNom[nPorts1](k=m_flow1_nominal)
    annotation (Placement(transformation(extent={{160,200},{180,220}})));
  Modelica.Blocks.Sources.RealExpression Q_flowHea(y=hexHea.Q1_flow)
    annotation (Placement(transformation(extent={{160,160},{180,180}})));
  Fluid.HeatExchangers.DryCoilEffectivenessNTU hexCoo(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final configuration=hexCon[2],
    final m1_flow_nominal=m_flow1_nominal[2],
    final m2_flow_nominal=m_flow2_nominal[2],
    final dp1_nominal=0,
    final dp2_nominal=dp2_nominal[2],
    final Q_flow_nominal=Q_flow_nominal[2],
    final T_a1_nominal=T_a1_nominal[2],
    final T_a2_nominal=T_a2_nominal[2],
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal) annotation (Placement(transformation(extent={{0,4},{
            20,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMaxT(
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0) "PID controller for maximum temperature"
    annotation (Placement(transformation(extent={{-40,150},{-20,170}})));
  Modelica.Blocks.Sources.RealExpression Q_flowCoo(y=hexCoo.Q1_flow)
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal[nPorts1] = Medium1.specificHeatCapacityCp(
    Medium1.setState_pTX(Medium1.p_default, T_a1_nominal))
    "Source side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal[nPorts1] = Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(Medium2.p_default, T_a2_nominal))
    "Load side specific heat capacity at nominal conditions";
equation
  connect(THexInlMes.T, conPIDMinT.u_m)
    annotation (Line(points={{140,11},{140,180},{-30,180},{-30,188}}, color={0,0,127}));
  connect(m_flow2.y, fan.m_flow_in) annotation (Line(points={{-19,40},{80,40},{
          80,12}},                                                                        color={0,0,127}));
  connect(fan.P, PFanPum) annotation (Line(points={{69,9},{60,9},{60,130},{220,
          130}},                                                                        color={0,0,127}));
  connect(ports_a1[1], hexHea.port_a1)
    annotation (Line(points={{-200,-220},{-100,-220},{-100,-12},{-80,-12}},
                                                                        color={0,127,255}));
  connect(conPIDMinT.y, gaiNom[1].u) annotation (Line(points={{-18,200},{62,200},{62,210},{158,210}},
                                                                                   color={0,0,127}));
  connect(gaiNom.y, m_flow1Req)
    annotation (Line(points={{182,210},{202,210},{202,210},{220,210}}, color={0,0,127}));
  connect(hexCoo.port_b2, hexHea.port_a2) annotation (Line(points={{0,0},{-60,0}},     color={0,127,255}));
  connect(hexHea.port_b1, ports_b1[1])
    annotation (Line(points={{-60,-12},{-40,-12},{-40,-220},{200,-220}},
                                                                     color={0,127,255}));
  connect(ports_a1[2], hexCoo.port_a1)
    annotation (Line(points={{-200,-180},{-20,-180},{-20,-12},{0,-12}},
                                                            color={0,127,255}));
  connect(hexCoo.port_b1, ports_b1[2])
    annotation (Line(points={{20,-12},{40,-12},{40,-180},{200,-180}},
                                                               color={0,127,255}));
  connect(hexHea.port_b2, port_b2)
    annotation (Line(points={{-80,0},{-200,0}},                       color={0,127,255}));
  connect(conPIDMaxT.y, gaiNom[2].u)
    annotation (Line(points={{-18,160},{140,160},{140,210},{158,210}}, color={0,0,127}));
  connect(THexInlMes.T, conPIDMaxT.u_m)
    annotation (Line(points={{140,11},{140,140},{-30,140},{-30,148}}, color={0,0,127}));
  connect(fan.port_a, THexInlMes.port_b) annotation (Line(points={{90,0},{130,0}},   color={0,127,255}));
  connect(port_a2, THexInlMes.port_a) annotation (Line(points={{200,0},{150,0}},                   color={0,127,255}));
  connect(fan.port_b, hexCoo.port_a2) annotation (Line(points={{70,0},{20,0}},                  color={0,127,255}));
  connect(uSet[1], conPIDMinT.u_s)
    annotation (Line(points={{-220,200},{-42,200}},                       color={0,0,127}));
  connect(uSet[2], conPIDMaxT.u_s)
    annotation (Line(points={{-220,220},{-132,220},{-132,160},{-42,160}}, color={0,0,127}));
  connect(Q_flowHea.y, Q_flow1Act[1])
    annotation (Line(points={{181,170},{192,170},{192,160},{220,160}}, color={0,0,127}));
  connect(Q_flowCoo.y, Q_flow1Act[2])
    annotation (Line(points={{181,150},{192,150},{192,180},{220,180}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-220},{200,220}})));
end SensibleTerminalUnit;
