within Buildings.Fluid.Storage.Plant.Validation;
model Coupled "Simplified dual-source network with coupled pressure"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialSimpleNetwork;

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 200000 + preDroRet.dp_nominal,
    nPorts=1) "Pressure boundary" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={90,-90})));
equation
  connect(junRet1.port_1, preDroRet.port_b)
    annotation (Line(points={{-60,-50},{40,-50}}, color={0,127,255}));

  connect(bou.ports[1], idePreSou.port_a) annotation (Line(points={{100,-90},{
          110,-90},{110,-20},{90,-20},{90,-20}}, color={0,127,255}));
    annotation(experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/Coupled.mos"
        "Simulate and plot"));
end Coupled;
