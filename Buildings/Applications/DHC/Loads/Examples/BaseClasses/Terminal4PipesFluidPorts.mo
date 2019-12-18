within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model Terminal4PipesFluidPorts
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    final heaFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
    final cooFunSpe=Buildings.Applications.DHC.Loads.Types.TerminalFunctionSpec.Water,
    final haveHeaPor=false,
    final haveFluPor=true,
    final haveWeaBus=false,
    final haveFan=true,
    final havePum=false,
    final show_TLoa=true,
    final m1Hea_flow_nominal=abs(QHea_flow_nominal / cp1Hea_nominal / (T_a1Hea_nominal - T_b1Hea_nominal)),
    final m1Coo_flow_nominal=abs(QCoo_flow_nominal / cp1Coo_nominal / (T_a1Coo_nominal - T_b1Coo_nominal)));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTMin(
    each Ti=120,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=false,
    each yMin=0) "PI controller for minimum indoor temperature"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare each final package Medium = Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=max({m2Hea_flow_nominal,m2Coo_flow_nominal}),
    redeclare Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=200,
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexHea(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final configuration=hexConHea,
    final m1_flow_nominal=m1Hea_flow_nominal,
    final m2_flow_nominal=m2Hea_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=100,
    final Q_flow_nominal=QHea_flow_nominal,
    final T_a1_nominal=T_a1Hea_nominal,
    final T_a2_nominal=T_a2Hea_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-80,4}, {-60,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaFloNom(k=m1Hea_flow_nominal)
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Modelica.Blocks.Sources.RealExpression Q_flowHea(y=hexHea.Q2_flow)
    annotation (Placement(transformation(extent={{160,210},{180,230}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexCoo(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final configuration=hexConCoo,
    final m1_flow_nominal=m1Coo_flow_nominal,
    final m2_flow_nominal=m2Coo_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=100,
    final Q_flow_nominal=QCoo_flow_nominal,
    final T_a1_nominal=T_a1Coo_nominal,
    final T_a2_nominal=T_a2Coo_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{0,4},{20,-16}})));
  Modelica.Blocks.Sources.RealExpression Q_flowCoo(y=hexCoo.Q2_flow)
    annotation (Placement(transformation(extent={{160,190},{180,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom2(k=max({
        m2Hea_flow_nominal,m2Coo_flow_nominal}))
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sigFlo2(k=1)
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTMax(
    each Ti=120,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=true,
    each yMin=0) "PI controller for maximum indoor temperature"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiCooFloNom(k=m1Coo_flow_nominal)
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Modelica.Blocks.Sources.RealExpression T_a2Val(y=sta_a2.T)
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
equation
  connect(hexCoo.port_b2, hexHea.port_a2)
    annotation (Line(points={{0,0},{-60,0}},     color={0,127,255}));
  connect(hexHea.port_b2, port_b2)
    annotation (Line(points={{-80,0},{-90,0},{-90,0},{-200,0}},       color={0,127,255}));
  connect(fan.port_b, hexCoo.port_a2)
    annotation (Line(points={{70,0},{20,0}}, color={0,127,255}));
  connect(gaiFloNom2.u, sigFlo2.y)
    annotation (Line(points={{18,100},{-58,100}},
                                                color={0,0,127}));
  connect(gaiFloNom2.y, fan.m_flow_in)
    annotation (Line(points={{42,100},{80,100},{80,12}},
                                                       color={0,0,127}));
  connect(port_a1Coo, hexCoo.port_a1) annotation (Line(points={{-200,-180},{-20,
          -180},{-20,-12},{0,-12}}, color={0,127,255}));
  connect(hexCoo.port_b1, port_b1Coo) annotation (Line(points={{20,-12},{40,-12},
          {40,-180},{200,-180}}, color={0,127,255}));
  connect(port_a1Hea, hexHea.port_a1) annotation (Line(points={{-200,-220},{
          -100,-220},{-100,-12},{-80,-12}},
                                       color={0,127,255}));
  connect(hexHea.port_b1, port_b1Hea) annotation (Line(points={{-60,-12},{-40,
          -12},{-40,-220},{200,-220}},
                                  color={0,127,255}));
  connect(TSetHea, conTMin.u_s)
    annotation (Line(points={{-220,220},{-12,220}}, color={0,0,127}));
  connect(conTMin.y, gaiHeaFloNom.u)
    annotation (Line(points={{12,220},{18,220}}, color={0,0,127}));
  connect(gaiHeaFloNom.y, m1ReqHea_flow) annotation (Line(points={{42,220},{122,
          220},{122,100},{220,100}}, color={0,0,127}));
  connect(conTMax.y, gaiCooFloNom.u)
    annotation (Line(points={{12,180},{18,180}}, color={0,0,127}));
  connect(TSetCoo, conTMax.u_s)
    annotation (Line(points={{-220,180},{-12,180}}, color={0,0,127}));
  connect(gaiCooFloNom.y, m1ReqCoo_flow) annotation (Line(points={{42,180},{140,
          180},{140,80},{220,80}},   color={0,0,127}));
  connect(Q_flowHea.y, QActHea_flow)
    annotation (Line(points={{181,220},{220,220}}, color={0,0,127}));
  connect(Q_flowCoo.y, QActCoo_flow)
    annotation (Line(points={{181,200},{220,200}}, color={0,0,127}));
  connect(fan.P, PFan) annotation (Line(points={{69,9},{60,9},{60,140},{220,140}},
        color={0,0,127}));
  connect(port_a2, fan.port_a)
    annotation (Line(points={{200,0},{90,0}}, color={0,127,255}));
  connect(T_a2Val.y, conTMax.u_m)
    annotation (Line(points={{-59,140},{0,140},{0,168}}, color={0,0,127}));
  connect(T_a2Val.y, conTMin.u_m) annotation (Line(points={{-59,140},{-28,140},
          {-28,200},{0,200},{0,208}}, color={0,0,127}));
end Terminal4PipesFluidPorts;
