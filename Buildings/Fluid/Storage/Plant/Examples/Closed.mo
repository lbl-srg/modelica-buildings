within Buildings.Fluid.Storage.Plant.Examples;
model Closed "A two-source three-user network with a closed tank"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource;

  Buildings.Fluid.Sources.Boundary_pT bou1(
    p(final displayUnit="Pa") = 101325 + dp_nominal,
    redeclare final package Medium = Medium,
    nPorts=1) "Pressure boundary" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,90})));
equation
  connect(tanBra.port_aRetNet, parJunPla2.port_c2)
    annotation (Line(points={{-80,-96},{40,-96}}, color={0,127,255}));
  connect(bou1.ports[1], pumSup1.port_a)
    annotation (Line(points={{-60,90},{-20,90}},  color={0,127,255}));
  annotation(experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/Closed.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-180,-240},{160,220}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Closed;
