within Buildings.Templates.AirHandlersFans.Validation;
model CoilWaterBasedCooling
  extends BaseNoEconomizer(redeclare
      UserProject.AirHandlersFans.CoilWaterBasedCooling VAV_1);

  Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = MediumCoo,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Fluid.Sources.Boundary_pT bou3(redeclare final package Medium = MediumCoo,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(bou2.ports[1], VAV_1.port_coiCooSup)
    annotation (Line(points={{-40,-50},{3,-50},{3,-19.8}}, color={0,127,255}));
  connect(bou3.ports[1], VAV_1.port_coiCooRet)
    annotation (Line(points={{-40,-80},{-3,-80},{-3,-20}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoilWaterBasedCooling;
