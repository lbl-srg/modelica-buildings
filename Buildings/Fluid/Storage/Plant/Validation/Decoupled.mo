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
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-30})));
  Buildings.Fluid.Storage.Plant.IdealReversibleConnection ideRevConRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.mTan_flow_nominal)
    "Ideal reversable connection on supply side"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 200000,
    nPorts=1) "First pressure boundary" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,10})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=-1)
    "Take additive inverse" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-10})));
equation

  connect(bou2.ports[1], idePreSou.port_a) annotation (Line(points={{100,-30},{90,
          -30},{90,-20}},                    color={0,127,255}));
  connect(junRet1.port_1, ideRevConRet.port_a)
    annotation (Line(points={{-20,-50},{0,-50}},   color={0,127,255}));
  connect(ideRevConRet.port_b, preDroRet.port_b)
    annotation (Line(points={{20,-50},{40,-50}},color={0,127,255}));
  connect(ideRevConRet.mSet_flow, gai.y)
    annotation (Line(points={{-1,-45},{-10,-45},{-10,-22}},  color={0,0,127}));
  connect(add2.y, gai.u)
    annotation (Line(points={{-58,70},{-10,70},{-10,2}}, color={0,0,127}));
  connect(bou1.ports[1], junSup1.port_3)
    annotation (Line(points={{-40,10},{-30,10},{-30,20}}, color={0,127,255}));
    annotation(experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/Decoupled.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model is almost the same as
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Validation.Coupled\">
Buildings.Fluid.Storage.Plant.Validation.Coupled</a>
except that the pressure from the two pressure sources are decoupled
by the use of two reversible connections on both the supply and return line.
</p>
</html>", revisions="<html>
<ul>
<li>
January 9, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end Decoupled;
