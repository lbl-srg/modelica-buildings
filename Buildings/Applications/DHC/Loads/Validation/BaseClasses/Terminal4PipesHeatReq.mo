within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model Terminal4PipesHeatReq
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Air,
    final have_watHea=true,
    final have_watCoo=true,
    final have_QReq_flow=true,
    final mHeaWat_flow_nominal=abs(QHea_flow_nominal/cpHeaWat_nominal/(
      T_aHeaWat_nominal - T_bHeaWat_nominal)),
    final mChiWat_flow_nominal=abs(QCoo_flow_nominal/cpChiWat_nominal/(
      T_aChiWat_nominal - T_bChiWat_nominal)));
  parameter Integer nFun = 2
    "Number of HVAC functions: 2 for heating and cooling, 1 for heating only";
  Buildings.Controls.OBC.CDL.Continuous.LimPID conQ_flowReq[nFun](
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction={false,true},
    each yMin=0) "PI controller tracking the required heat flow rate"
    annotation (Placement(transformation(extent={{10,210},{30,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom[nFun](
    k={mHeaWat_flow_nominal,mChiWat_flow_nominal})
    annotation (Placement(transformation(extent={{60,210},{80,230}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nFun](
    redeclare each final package Medium=Medium1)
    annotation (Placement(transformation(extent={{-150,-210},{-130,-190}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo[nFun](
    redeclare each final package Medium = Medium1,
    final m_flow_nominal={mHeaWat_flow_nominal,mChiWat_flow_nominal},
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each final dp_nominal=0,
    each final Q_flow_nominal=-1) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,-210},{80,-190}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FirstOrderODE TLoaODE[nFun](
    each TOutHea_nominal=273.15 - 5,
    TIndHea_nominal={T_aLoaHea_nominal, T_aLoaCoo_nominal},
    each QHea_flow_nominal=QHea_flow_nominal,
    Q_flow_nominal={QHea_flow_nominal, QCoo_flow_nominal})
    annotation (Placement(transformation(extent={{-90,170},{-70,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiWatInl(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=mChiWat_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversal)
    "Chilled water inlet temperature (sensed, steady-state)"
    annotation (Placement(transformation(extent={{-190,-190},{-170,-170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THeaWatInl(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=mHeaWat_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversal)
    "Heating water inlet temperature (sensed, steady-state)"
    annotation (Placement(transformation(extent={{-190,-230},{-170,-210}})));
  Buildings.Applications.DHC.Loads.BaseClasses.EffectivenessNTUUniform
    heaFloEff[nFun](
      redeclare each final package Medium1 = Medium1,
      redeclare each final package Medium2 = Medium2,
      final Q_flow_nominal={QHea_flow_nominal,QCoo_flow_nominal},
      final T_a1_nominal={T_aHeaWat_nominal,T_aChiWat_nominal},
      final T_a2_nominal={T_aLoaHea_nominal,T_aLoaCoo_nominal},
      final m1_flow_nominal={mHeaWat_flow_nominal,mChiWat_flow_nominal})
    annotation (Placement(transformation(extent={{12,-10},{32,10}})));
equation
  connect(conQ_flowReq.y, gaiFloNom.u) annotation (Line(points={{32,220},{58,220}},
                             color={0,0,127}));
  connect(heaCoo[1].port_b, port_bHeaWat) annotation (Line(points={{80,-200},{140,
          -200},{140,-220},{200,-220}}, color={0,127,255}));
  connect(heaCoo[2].port_b, port_bChiWat) annotation (Line(points={{80,-200},{140,
          -200},{140,-180},{200,-180}}, color={0,127,255}));
  connect(TSetHea, TLoaODE[1].TSet) annotation (Line(points={{-220,220},{-180,220},
          {-180,188},{-92,188}}, color={0,0,127}));
  connect(TSetCoo, TLoaODE[2].TSet) annotation (Line(points={{-220,180},{-180,180},
          {-180,188},{-92,188}}, color={0,0,127}));
  connect(port_aChiWat, TChiWatInl.port_a)
    annotation (Line(points={{-200,-180},{-190,-180}}, color={0,127,255}));
  connect(port_aHeaWat, THeaWatInl.port_a)
    annotation (Line(points={{-200,-220},{-190,-220}}, color={0,127,255}));
  connect(TChiWatInl.port_b, senMasFlo[2].port_a) annotation (Line(points={{-170,-180},
          {-160,-180},{-160,-200},{-150,-200}}, color={0,127,255}));
  connect(THeaWatInl.port_b, senMasFlo[1].port_a) annotation (Line(points={{-170,-220},
          {-160,-220},{-160,-200},{-150,-200}}, color={0,127,255}));
  connect(gaiFloNom[1].y,scaMasFloReqHeaWat.u)  annotation (Line(points={{82,
          220},{120,220},{120,100},{158,100}}, color={0,0,127}));
  connect(gaiFloNom[2].y, scaMasFloReqChiWat.u) annotation (Line(points={{82,
          220},{120,220},{120,80},{158,80}}, color={0,0,127}));
  connect(scaQReqHea_flow.y, TLoaODE[1].QReq_flow) annotation (Line(points={{-158,
          140},{-100,140},{-100,180},{-92,180}},      color={0,0,127}));
  connect(scaQReqCoo_flow.y, TLoaODE[2].QReq_flow) annotation (Line(points={{-158,
          100},{-100,100},{-100,180},{-92,180}},      color={0,0,127}));
  connect(scaQReqHea_flow.y, conQ_flowReq[1].u_s) annotation (Line(points={{
          -158,140},{-120,140},{-120,220},{8,220}}, color={0,0,127}));
  connect(scaQReqCoo_flow.y, conQ_flowReq[2].u_s) annotation (Line(points={{
          -158,100},{-120,100},{-120,220},{8,220}}, color={0,0,127}));
  connect(senMasFlo.port_b, heaCoo.port_a)
    annotation (Line(points={{-130,-200},{60,-200}}, color={0,127,255}));
  connect(senMasFlo.m_flow, heaFloEff.m1_flow) annotation (Line(points={{-140,
          -189},{-140,4},{10,4}},     color={0,0,127}));
  connect(heaFloEff.Q2_flow, heaCoo.u) annotation (Line(points={{34,-6},{50,-6},
          {50,-194},{58,-194}}, color={0,0,127}));
  connect(TLoaODE.TInd, heaFloEff.T_in2) annotation (Line(points={{-68,180},{
          -26,180},{-26,-4},{10,-4}},
                                color={0,0,127}));
  connect(THeaWatInl.T, heaFloEff[1].T_in1) annotation (Line(points={{-180,-209},
          {-180,-200},{-166,-200},{-166,0},{10,0}},
                                      color={0,0,127}));
  connect(TChiWatInl.T, heaFloEff[2].T_in1) annotation (Line(points={{-180,-169},
          {-180,0},{10,0}},           color={0,0,127}));
  connect(heaFloEff.Q2_flow, conQ_flowReq.u_m) annotation (Line(points={{34,-6},
          {50,-6},{50,200},{20,200},{20,208}}, color={0,0,127}));
  connect(heaFloEff[1].Q2_flow, scaQActHea_flow.u) annotation (Line(points={{34,-6},
          {140,-6},{140,220},{158,220}},           color={0,0,127}));
  connect(heaFloEff[2].Q2_flow, scaQActCoo_flow.u) annotation (Line(points={{34,-6},
          {140,-6},{140,200},{158,200}},     color={0,0,127}));
  connect(heaFloEff.Q2_flow, TLoaODE.QAct_flow) annotation (Line(points={{34,-6},
          {50,-6},{50,152},{-96,152},{-96,172},{-92,172}},   color={0,0,127}));
end Terminal4PipesHeatReq;
