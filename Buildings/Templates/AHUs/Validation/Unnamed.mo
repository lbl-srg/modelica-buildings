within Buildings.Templates.AHUs.Validation;
model Unnamed
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  Fluid.Sources.Boundary_pT bou(
    redeclare package Medium=MediumAir,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sources.Boundary_pT bou1(
  redeclare package Medium=MediumAir,
  nPorts=2)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Fluid.Sensors.RelativePressure senRelPre(
   redeclare package Medium=MediumAir)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sources.MassFlowSource_T
                            boundary(
    redeclare package Medium = MediumAir,
    m_flow=0,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
equation
  connect(bou.ports[1], senRelPre.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(senRelPre.port_b, bou1.ports[1]) annotation (Line(points={{10,0},{20,
          0},{20,-38},{-40,-38}},
                               color={0,127,255}));
  connect(boundary.ports[1], bou1.ports[2]) annotation (Line(points={{-40,-80},
          {-20,-80},{-20,-42},{-40,-42}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Unnamed;
