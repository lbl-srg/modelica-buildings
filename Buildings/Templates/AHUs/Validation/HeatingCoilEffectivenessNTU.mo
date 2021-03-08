within Buildings.Templates.AHUs.Validation;
model HeatingCoilEffectivenessNTU
  extends BaseNoEquipment(redeclare
    UserProject.AHUs.HeatingCoilEffectivenessNTU ahu);

  Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = MediumCoo, nPorts=1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Fluid.Sources.Boundary_pT bou3(redeclare final package Medium = MediumCoo,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(bou2.ports[1], ahu.port_coiHea2Sup) annotation (Line(points={{-40,-50},
          {-7,-50},{-7,-19.8}}, color={0,127,255}));
  connect(bou3.ports[1], ahu.port_coiHea2Ret) annotation (Line(points={{-40,-80},
          {-3,-80},{-3,-19.8}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end HeatingCoilEffectivenessNTU;
