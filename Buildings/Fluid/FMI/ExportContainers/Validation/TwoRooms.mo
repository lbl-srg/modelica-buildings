within Buildings.Fluid.FMI.ExportContainers.Validation;
model TwoRooms
  extends Examples.FMUs.ThermalZonesConvective(nPorts=3);


  Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=1)
    "Boundary condition for zero mass flow of one exhaust stream for room 1"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Sources.Boundary_pT bou2(
    redeclare package Medium = Medium,
    nPorts=1)
    "Boundary condition for zero mass flow of one exhaust stream for room 2"
    annotation (Placement(transformation(extent={{-142,82},{-122,102}})));

equation
  connect(bou1.ports[1], theZonAda[1].ports[3]) annotation (Line(points={{-120,120},
          {-112,120},{-112,160},{-102,160},{-112,160},{-120,160}},
                                  color={0,127,255}));
  connect(bou2.ports[1], theZonAda[2].ports[3]) annotation (Line(points={{-122,92},
          {-106,92},{-106,160},{-120,160}},
                                  color={0,127,255}));
end TwoRooms;
