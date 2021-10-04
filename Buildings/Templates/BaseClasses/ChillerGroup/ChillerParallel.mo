within Buildings.Templates.BaseClasses.ChillerGroup;
model ChillerParallel
  extends Buildings.Templates.Interfaces.ChillerGroup(
    final typ=Buildings.Templates.Types.ChillerGroup.ChillerParallel);

  parameter Boolean has_chwPum = false "= true if chilled water side flow is controlled by a dedicated pump";
  parameter Boolean has_cwPum = false "= true if condenser water side flow is controlled by a dedicated pump";


  Fluid.Sources.MassFlowSource_T floZer_a(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{-60,-86},{-40,-66}})));
  Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis(
    redeclare final package Medium = Medium,
    final mCon_flow_nominal=fill(m_flow_nominal, num),
    final nCon=num)
    annotation (Placement(transformation(extent={{-20,-80},{20,-60}})));
  Fluid.Sources.MassFlowSource_T floZer_b(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{60,-60},{40,-80}})));
  Fluid.Sources.MassFlowSource_T floZer_a1(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{-60,86},{-40,66}})));
  Experimental.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor colDis1(
    redeclare final package Medium = Medium,
    final mCon_flow_nominal=fill(m_flow_nominal, num),
    final nCon=num)
    annotation (Placement(transformation(extent={{-20,80},{20,60}})));
  Fluid.Sources.MassFlowSource_T floZer_b1(
    redeclare final package Medium = Medium,
    final m_flow=0,
    nPorts=1) "Zero flow boundary condition"
    annotation (Placement(transformation(extent={{60,60},{40,80}})));
              Fluid.Chillers.ElectricEIR                           chi[num](
    final per=per,
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    each final allowFlowReversal1=allowFlowReversal1,
    each final allowFlowReversal2=allowFlowReversal2,
    each final show_T=show_T,
    each final from_dp1=from_dp1,
    each final dp1_nominal=0,
    each final linearizeFlowResistance1=linearizeFlowResistance1,
    each final deltaM1=deltaM1,
    each final from_dp2=from_dp2,
    each final dp2_nominal=0,
    each final linearizeFlowResistance2=linearizeFlowResistance2,
    each final deltaM2=deltaM2,
    each final homotopyInitialization=homotopyInitialization,
    each final m1_flow_nominal=m1_flow_nominal,
    each final m2_flow_nominal=m2_flow_nominal,
    each final m1_flow_small=m1_flow_small,
    each final m2_flow_small=m2_flow_small,
    each final tau1=tau1,
    each final tau2=tau2,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p1_start=p1_start,
    each final T1_start=T1_start,
    each final X1_start=X1_start,
    each final C1_start=C1_start,
    each final C1_nominal=C1_nominal,
    each final p2_start=p2_start,
    each final T2_start=T2_start,
    each final X2_start=X2_start,
    each final C2_start=C2_start,
    each final C2_nominal=C2_nominal)
    "Chillers with identical nominal parameters but different performance curves"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None pum_1[num]
    constrainedby Buildings.Templates.Interfaces.Pump
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={20,30})));
  inner replaceable Buildings.Templates.BaseClasses.Pump.None pum_2[num]
    constrainedby Buildings.Templates.Interfaces.Pump
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-30})));
  inner replaceable Buildings.Templates.BaseClasses.Valve.None val_1[num]
    constrainedby Buildings.Templates.Interfaces.Valve
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,30})));
  inner replaceable Buildings.Templates.BaseClasses.Valve.None val_2[num]
    constrainedby Buildings.Templates.Interfaces.Valve
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={20,-30})));
equation
  connect(floZer_a1.ports[1], colDis1.port_bDisRet)
    annotation (Line(points={{-40,76},{-20,76}}, color={0,127,255}));
  connect(colDis1.port_bDisSup, floZer_b1.ports[1])
    annotation (Line(points={{20,70},{40,70}}, color={0,127,255}));
  connect(port_a1, colDis1.port_aDisSup) annotation (Line(points={{-100,60},{
          -30,60},{-30,70},{-20,70}}, color={0,127,255}));
  connect(colDis1.port_aDisRet, port_b1) annotation (Line(points={{20,76},{30,
          76},{30,60},{100,60}}, color={0,127,255}));
  connect(floZer_a.ports[1], colDis.port_bDisRet)
    annotation (Line(points={{-40,-76},{-20,-76}}, color={0,127,255}));
  connect(colDis.port_bDisSup, floZer_b.ports[1])
    annotation (Line(points={{20,-70},{40,-70}}, color={0,127,255}));
  connect(colDis.port_aDisSup, port_b2) annotation (Line(points={{-20,-70},{-32,
          -70},{-32,-60},{-100,-60}}, color={0,127,255}));
  connect(colDis.port_aDisRet, port_a2) annotation (Line(points={{20,-76},{30,
          -76},{30,-60},{100,-60}}, color={0,127,255}));
  connect(busCon.out.on, chi.on) annotation (Line(
      points={{0.1,100.1},{0.1,96},{0,96},{0,90},{-80,90},{-80,0},{-20,0},{-20,
          5},{-12,5}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(busCon.out.TSet, chi.TSet) annotation (Line(
      points={{0.1,100.1},{0.1,90},{-80,90},{-80,0},{-20,0},{-20,-1},{-12,-1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  connect(colDis.ports_aCon, val_2.port_a) annotation (Line(points={{12,-60},{12,
          -50},{20,-50},{20,-40}}, color={0,127,255}));
  connect(val_2.port_b, chi.port_a2)
    annotation (Line(points={{20,-20},{20,-4},{10,-4}}, color={0,127,255}));
  connect(chi.port_b2, pum_2.port_a)
    annotation (Line(points={{-10,-4},{-20,-4},{-20,-20}}, color={0,127,255}));
  connect(pum_2.port_b, colDis.ports_bCon) annotation (Line(points={{-20,-40},{-20,
          -50},{-12,-50},{-12,-60}}, color={0,127,255}));
  connect(colDis1.ports_bCon, val_1.port_a) annotation (Line(points={{-12,60},{-12,
          50},{-20,50},{-20,40}}, color={0,127,255}));
  connect(val_1.port_b, chi.port_a1)
    annotation (Line(points={{-20,20},{-20,8},{-10,8}}, color={0,127,255}));
  connect(chi.port_b1, pum_1.port_a)
    annotation (Line(points={{10,8},{20,8},{20,20}}, color={0,127,255}));
  connect(pum_1.port_b, colDis1.ports_aCon) annotation (Line(points={{20,40},{20,
          50},{12,50},{12,60}}, color={0,127,255}));
end ChillerParallel;
