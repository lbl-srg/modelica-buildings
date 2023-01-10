within Buildings.Fluid.Storage.Plant.Validation;
model Decoupled
  "Simplified dual-source network with decoupled pressure"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialSimpleNetwork;

  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 200000 + preDroRet.dp_nominal,
    nPorts=1) "Second pressure boundary" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={90,-90})));
  IdealReversibleConnection ideRevConRet(redeclare final package Medium =
        Medium, final nom=nom) "Ideal reversable connection on supply side"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Sources.Boundary_pT bou1(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 200000,
    nPorts=1) "First pressure boundary" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-90})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=-1)
    "Take additive inverse" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,-10})));
equation

  connect(bou2.ports[1], idePreSou.port_a) annotation (Line(points={{100,-90},{110,
          -90},{110,-20},{90,-20},{90,-20}}, color={0,127,255}));
  connect(junRet1.port_1, ideRevConRet.port_a)
    annotation (Line(points={{-60,-50},{-20,-50}}, color={0,127,255}));
  connect(ideRevConRet.port_b, preDroRet.port_b)
    annotation (Line(points={{0,-50},{40,-50}}, color={0,127,255}));
  connect(ideRevConRet.mSet_flow, gai.y)
    annotation (Line(points={{-21,-45},{-30,-45},{-30,-22}}, color={0,0,127}));
  connect(add2.y, gai.u)
    annotation (Line(points={{-98,90},{-30,90},{-30,2}}, color={0,0,127}));
  connect(bou1.ports[1], mTanSup_flow.port_a) annotation (Line(points={{-60,-90},
          {-50,-90},{-50,0},{-70,0},{-70,10}}, color={0,127,255}));
    annotation(experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/Decoupled.mos"
        "Simulate and plot"));
end Decoupled;
