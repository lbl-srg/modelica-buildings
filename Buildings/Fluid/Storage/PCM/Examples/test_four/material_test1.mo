within Buildings.Fluid.Storage.PCM.Examples.test_four;
model material_test1
  import Media;
  HexElementSensibleFourPort             hexElementSensibleFourPort(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Water,
    m1_flow_nominal=2,
    m2_flow_nominal=2,
    redeclare Buildings.Fluid.Storage.PCM.Data.PhaseChangeMaterial.PCM58_a
      Material,
    TStart_pcm=298.15)
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));
  Sources.Boundary_pT bou(redeclare package Medium = Buildings.Media.Water,
      nPorts=1)
    annotation (Placement(transformation(extent={{-54,0},{-34,20}})));
  Sources.Boundary_pT bou1(redeclare package Medium = Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-54,-32},{-34,-12}})));
  Sources.Boundary_pT bou2(redeclare package Medium = Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{48,-54},{68,-34}})));
  Sources.Boundary_pT bou3(redeclare package Medium = Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{62,-4},{42,16}})));
equation
  connect(bou.ports[1], hexElementSensibleFourPort.port_a1) annotation (Line(
        points={{-34,10},{-14,10},{-14,8},{-10,8}}, color={0,127,255}));
  connect(bou1.ports[1], hexElementSensibleFourPort.port_b2) annotation (Line(
        points={{-34,-22},{-16,-22},{-16,-4},{-10,-4}}, color={0,127,255}));
  connect(hexElementSensibleFourPort.port_b1, bou3.ports[1])
    annotation (Line(points={{10,8},{42,8},{42,6}}, color={0,127,255}));
  connect(hexElementSensibleFourPort.port_a2, bou2.ports[1]) annotation (Line(
        points={{10,-4},{14,-4},{14,-10},{68,-10},{68,-44}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end material_test1;
