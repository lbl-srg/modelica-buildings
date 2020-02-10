within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model FanCoil2PipesHeatingValve
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Air,
    final have_fan=true,
    final have_watHea=true,
    final have_watCoo=false,
    final have_QReq_flow=true,
    final mHeaWat_flow_nominal=abs(QHea_flow_nominal/cpHeaWat_nominal/(
      T_aHeaWat_nominal - T_bHeaWat_nominal)));
  import hexConfiguration = Buildings.Fluid.Types.HeatExchangerConfiguration;
  parameter hexConfiguration hexConHea=
    hexConfiguration.CounterFlow
    "Heating heat exchanger configuration";
  parameter hexConfiguration hexConCoo=
    hexConfiguration.CounterFlow
    "Cooling heat exchanger configuration";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 30000
    "Nominal pressure drop on source side";
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium=Medium2,
    energyDynamics=energyDynamics,
    m_flow_nominal=mLoaHea_flow_nominal,
    redeclare Fluid.Movers.Data.Generic per,
    addPowerToMedium=true,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=true,
    dp_nominal=200,
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID con(
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=false,
    yMin=0) "PI controller"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final configuration=hexConHea,
    final m1_flow_nominal=mHeaWat_flow_nominal,
    final m2_flow_nominal=mLoaHea_flow_nominal,
    final dp1_nominal=0,
    dp2_nominal=200,
    final Q_flow_nominal=QHea_flow_nominal,
    final T_a1_nominal=T_aHeaWat_nominal,
    final T_a2_nominal=T_aLoaHea_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-80,4},{-60,-16}})));
  Modelica.Blocks.Sources.RealExpression Q_flowHea(y=hex.Q2_flow)
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom2(k=mLoaHea_flow_nominal)
    annotation (Placement(transformation(extent={{40,170},{60,190}})));
  Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium2,
    use_T_in=false,
    nPorts=1)
    "Sink for supply air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-152,0})));
  Fluid.Sources.Boundary_pT retAir(
    redeclare package Medium = Medium2,
    use_T_in=true,
    nPorts=1)
    "Source for return air"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={150,0})));
  Buildings.Applications.DHC.Loads.BaseClasses.FirstOrderODE TLoaODE(
    TOutHea_nominal=273.15 - 5,
    TIndHea_nominal=T_aLoaHea_nominal,
    QHea_flow_nominal=QHea_flow_nominal,
    Q_flow_nominal=QHea_flow_nominal)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare final package Medium=Medium1,
    m_flow_nominal=mHeaWat_flow_nominal,
    dpValve_nominal=5000,
    use_inputFilter=false,
    final allowFlowReversal=allowFlowReversal,
    dpFixed_nominal=dp_nominal - 5000)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-80})));
  Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal)
  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaFlo(k=1/QHea_flow_nominal)
    annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaFlo1(k=1/QHea_flow_nominal)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,190})));
equation
  if have_fluPor then
  end if;
  if not have_QReq_flow then
  end if;
  connect(gaiFloNom2.y, fan.m_flow_in)
    annotation (Line(points={{62,180},{80,180},{80,12}}, color={0,0,127}));
  connect(port_aHeaWat, hex.port_a1) annotation (Line(points={{-200,-220},{-100,
          -220},{-100,-12},{-80,-12}}, color={0,127,255}));

  connect(fan.P, scaPFan.u) annotation (Line(points={{69,9},{60,9},{60,140},{
          158,140}}, color={0,0,127}));
  connect(Q_flowHea.y, scaQActHea_flow.u) annotation (Line(points={{141,220},
          {150,220},{150,220},{158,220}}, color={0,0,127}));
  connect(fan.port_b, hex.port_a2)
    annotation (Line(points={{70,0},{-60,0}}, color={0,127,255}));
  connect(hex.port_b2, sinAir.ports[1])
    annotation (Line(points={{-80,0},{-142,0}}, color={0,127,255}));
  connect(TSetHea, TLoaODE.TSet)
    annotation (Line(points={{-220,220},{-120,220},{-120,68},{-12,68}},
                                                     color={0,0,127}));
  connect(scaQReqHea_flow.y, TLoaODE.QReq_flow) annotation (Line(points={{-158,100},
          {-100,100},{-100,60},{-12,60}},         color={0,0,127}));
  connect(Q_flowHea.y, TLoaODE.QAct_flow) annotation (Line(points={{141,220},{
          150,220},{150,160},{-20,160},{-20,52},{-12,52}},      color={0,0,127}));
  connect(TLoaODE.TInd, retAir.T_in) annotation (Line(points={{12,60},{180,60},{
          180,4},{162,4}}, color={0,0,127}));
  connect(hex.port_b1, val.port_a) annotation (Line(points={{-60,-12},{-40,-12},
          {-40,-70}}, color={0,127,255}));
  connect(val.port_b, senMasFlo.port_a)
    annotation (Line(points={{-40,-90},{-40,-110}}, color={0,127,255}));
  connect(senMasFlo.port_b, port_bHeaWat) annotation (Line(points={{-40,-130},{-40,
          -220},{200,-220}}, color={0,127,255}));
  connect(con.y, val.y) annotation (Line(points={{12,220},{20,220},{20,-80},{
          -28,-80}},
                 color={0,0,127}));
  connect(senMasFlo.m_flow, scaMasFloReqHeaWat.u) annotation (Line(points={{-29,
          -120},{100,-120},{100,100},{158,100}}, color={0,0,127}));
  connect(scaQReqHea_flow.y, gaiHeaFlo.u) annotation (Line(points={{-158,100},{-100,
          100},{-100,220},{-42,220}},      color={0,0,127}));
  connect(gaiHeaFlo.y, con.u_s)
    annotation (Line(points={{-18,220},{-12,220}}, color={0,0,127}));
  connect(Q_flowHea.y, gaiHeaFlo1.u) annotation (Line(points={{141,220},{150,
          220},{150,160},{0,160},{0,178},{-8.88178e-16,178}}, color={0,0,127}));
  connect(con.u_m, gaiHeaFlo1.y) annotation (Line(points={{0,208},{0,207},{
          6.66134e-16,207},{6.66134e-16,202}}, color={0,0,127}));
  connect(con.y, gaiFloNom2.u) annotation (Line(points={{12,220},{20,220},{20,
          180},{38,180}}, color={0,0,127}));
  connect(retAir.ports[1], fan.port_a)
    annotation (Line(points={{140,0},{90,0}}, color={0,127,255}));
end FanCoil2PipesHeatingValve;
