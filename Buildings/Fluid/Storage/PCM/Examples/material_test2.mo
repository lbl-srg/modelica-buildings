within Buildings.Fluid.Storage.PCM.Examples;
model material_test2
  import Media;
  Sources.Boundary_pT bou(redeclare package Medium = Buildings.Media.Water,
      nPorts=1)
    annotation (Placement(transformation(extent={{-54,0},{-34,20}})));
  Sources.Boundary_pT bou1(redeclare package Medium = Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-54,-32},{-34,-12}})));
  Sources.Boundary_pT bou2(redeclare package Medium = Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{48,-54},{68,-34}})));
  Sources.Boundary_pT bou3(redeclare package Medium = Media.Water)
    annotation (Placement(transformation(extent={{62,-4},{42,16}})));
  CoilRegisterFourPort coilRegisterFourPort(
    redeclare Buildings.Fluid.Storage.PCM.Data.HeatExchanger.Generic Design,
    redeclare Buildings.Fluid.Storage.PCM.Data.PhaseChangeMaterial.PCM11_a
      Material,
    m1_flow_nominal=3,
    m2_flow_nominal=3,
    TStart_pcm=288.15,
    redeclare package Medium = Buildings.Media.Water)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
equation
  connect(bou.ports[1], coilRegisterFourPort.port_a1) annotation (Line(points={
          {-34,10},{-32,10},{-32,12},{-22,12},{-22,2.2},{-10,2.2}}, color={0,
          127,255}));
  connect(coilRegisterFourPort.port_a2, bou2.ports[1]) annotation (Line(points=
          {{10,-6.2},{12,-6.2},{12,-6},{30,-6},{30,-44},{68,-44}}, color={0,127,
          255}));
  connect(coilRegisterFourPort.port_b2, bou1.ports[1]) annotation (Line(points=
          {{-10,-6.2},{-12,-6.2},{-12,-18},{-36,-18},{-36,-22},{-34,-22}},
        color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end material_test2;
