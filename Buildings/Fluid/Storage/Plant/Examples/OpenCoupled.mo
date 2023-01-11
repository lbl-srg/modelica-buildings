within Buildings.Fluid.Storage.Plant.Examples;
model OpenCoupled
  "A two-source three-user network with an open tank, pressure is coupled"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PartialDualSource;

  Buildings.Fluid.Sources.Boundary_pT bou2(
    p(final displayUnit="Pa") = 101325 + dp_nominal,
    redeclare final package Medium = Medium,
    nPorts=1) "Pressure boundary" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,10})));
equation
  connect(tanBra.port_aFroNet, parJunPla2.port_c2)
    annotation (Line(points={{-60,-96},{40,-96}}, color={0,127,255}));
  connect(bou2.ports[1], ideRevConSup.port_a) annotation (Line(points={{-40,10},
          {-34,10},{-34,-70},{-20,-70}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/OpenCoupled.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{160,220}})));
end OpenCoupled;
