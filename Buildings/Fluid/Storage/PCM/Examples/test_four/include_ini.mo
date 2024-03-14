within Buildings.Fluid.Storage.PCM.Examples.test_four;
model include_ini
  import Media;
  ini ini1(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Water,
    m1_flow_nominal=1,
    m2_flow_nominal=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sources.Boundary_pT bou3(redeclare package Medium = Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Sources.Boundary_pT bou1(redeclare package Medium = Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Sources.MassFlowSource_T boundary1(
    redeclare package Medium = Buildings.Media.Water,
    m_flow=1,
    nPorts=1) annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Sources.MassFlowSource_T boundary2(
    redeclare package Medium = Buildings.Media.Water,
    m_flow=1,
    nPorts=1) annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
equation
  connect(bou1.ports[1], ini1.port_b2) annotation (Line(points={{-40,-20},{-20,
          -20},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(ini1.port_b1, bou3.ports[1]) annotation (Line(points={{10,6},{20,6},{
          20,20},{40,20}}, color={0,127,255}));
  connect(boundary1.ports[1], ini1.port_a1) annotation (Line(points={{-40,20},{
          -20,20},{-20,6},{-10,6}}, color={0,127,255}));
  connect(ini1.port_a2, boundary2.ports[1]) annotation (Line(points={{10,-6},{
          20,-6},{20,-20},{40,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end include_ini;
