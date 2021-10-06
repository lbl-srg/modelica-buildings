within Buildings.Templates.BaseClasses.ChillerGroup;
model ChillerParallel
  extends Buildings.Templates.Interfaces.ChillerGroup(
    final typ=Buildings.Templates.Types.ChillerGroup.ChillerParallel);


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
  inner replaceable Buildings.Templates.BaseClasses.Chiller.ElectricChiller chi[num]
    constrainedby Buildings.Templates.Interfaces.Chiller
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=270)));
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

  connect(chi.port_a1, colDis.ports_aCon)
    annotation (Line(points={{12,-20},{12,-60}}, color={0,127,255}));
  connect(chi.port_b2, colDis.ports_bCon)
    annotation (Line(points={{-12,-20},{-12,-60}}, color={0,127,255}));
  connect(chi.port_a2, colDis1.ports_bCon)
    annotation (Line(points={{-12,20},{-12,60}}, color={0,127,255}));
  connect(chi.port_b1, colDis1.ports_aCon)
    annotation (Line(points={{12,20},{12,60}}, color={0,127,255}));
  connect(busCon.chi, chi.busCon) annotation (Line(
      points={{0,100},{0,90},{80,90},{80,0},{50,0},{50,-3.55271e-15},{20,
          -3.55271e-15}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
end ChillerParallel;
