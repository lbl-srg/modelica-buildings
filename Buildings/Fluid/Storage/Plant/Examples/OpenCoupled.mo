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
        origin={-70,10})));
equation
  connect(tanBra.port_aRetNet, parJunPla2.port_c2)
    annotation (Line(points={{-80,-96},{40,-96}}, color={0,127,255}));
  connect(bou2.ports[1], ideRevConSup.port_a) annotation (Line(points={{-60,10},
          {-10,10},{-10,-70},{0,-70}},   color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/OpenCoupled.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{160,220}})),
        Documentation(info="<html>
<p>
This variant of the two-plant-three-user example model represents the scenario
where the storage plant is open and the pressure is coupled.
This means that the open tank at the storage plant functions as the pressurisation point
for the district system and
the return side of the storage plant is connected to the network with
a direct connection.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end OpenCoupled;
