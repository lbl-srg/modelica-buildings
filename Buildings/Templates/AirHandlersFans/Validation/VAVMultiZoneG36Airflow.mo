within Buildings.Templates.AirHandlersFans.Validation;
model VAVMultiZoneG36Airflow
  extends BaseNoEconomizer(redeclare UserProject.AHUs.ControlsGuideline36 VAV_1);

  Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = MediumHea, nPorts=1)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Fluid.Sources.Boundary_pT bou3(redeclare final package Medium = MediumHea,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Fluid.Sources.Boundary_pT bou4(redeclare final package Medium = MediumCoo,
      nPorts=1)
    annotation (Placement(transformation(extent={{60,-60},{40,-40}})));
  Fluid.Sources.Boundary_pT bou5(redeclare final package Medium = MediumCoo,
      nPorts=1)
    annotation (Placement(transformation(extent={{60,-90},{40,-70}})));
  UserProject.DummyControlPointsVAVBox sigVAVBox[VAV_1.nZon]
    "Control signals from VAV box"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(bou2.ports[1], VAV_1.port_coiHeaPreSup) annotation (Line(points={{-40,
          -50},{-7,-50},{-7,-19.8}}, color={0,127,255}));
  connect(VAV_1.port_coiHeaPreRet, bou3.ports[1]) annotation (Line(points={{-3,
          -19.8},{-3,-80},{-40,-80}}, color={0,127,255}));
  connect(bou4.ports[1], VAV_1.port_coiCooRet)
    annotation (Line(points={{40,-50},{6,-50},{6,-19.8}}, color={0,127,255}));
  connect(VAV_1.port_coiCooSup, bou5.ports[1])
    annotation (Line(points={{2,-19.8},{2,-80},{40,-80}}, color={0,127,255}));
  connect(sigVAVBox.bus, VAV_1.busTer) annotation (Line(
      points={{-40,70},{19.8,70},{19.8,16}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneG36Airflow;
