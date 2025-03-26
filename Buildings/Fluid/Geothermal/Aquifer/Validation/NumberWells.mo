within Buildings.Fluid.Geothermal.Aquifer.Validation;
model NumberWells
  "Test model for aquifer thermal energy storage with multiple wells"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  model MyWell = MultiWell (
    redeclare package Medium = Buildings.Media.Water,
    nVol=50,
    h=10,
    d=4800,
    length=200,
    THot_start=303.15,
    TGroCol=273.15,
    TGroHot=303.15,
    aquDat=Buildings.Fluid.Geothermal.Aquifer.Data.Rock(),
    m_flow_nominal=0.1,
    dpExt_nominal=0) "Well model";

  MyWell aquWel1(d=4800)
  "ATES with one pair of wells"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  MyWell aquWel2(
    d=4800,
     nPai=2,
     m_flow_nominal=0.2)
    "ATES with two pairs of wells"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Constant uPum(k=1) "Pump control signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=2) "Sink"
           annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression temWel1(
    y=aquWel1.TAquHot[10])
    "Temperature output from aquifer model with one pair of wells"
    annotation (Placement(transformation(extent={{20,72},{40,92}})));
  Modelica.Blocks.Sources.RealExpression temWel2(
    y=aquWel2.TAquHot[10])
    "Temperature output from aquifer model with two pairs of wells"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Utilities.Diagnostics.CheckEquality cheEqu
    "Assertion that checks for equality of results"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(uPum.y, aquWel1.u) annotation (Line(points={{-59,0},{-40,0},{-40,30},
          {-22,30}}, color={0,0,127}));
  connect(aquWel2.u,uPum. y) annotation (Line(points={{-22,-50},{-40,-50},{-40,
          0},{-59,0}}, color={0,0,127}));
  connect(aquWel2.port_Col, aquWel2.port_Hot) annotation (Line(points={{-16,-40},
          {-16,-20},{-4,-20},{-4,-40}}, color={0,127,255}));
  connect(aquWel1.port_Col, aquWel1.port_Hot) annotation (Line(points={{-16,40},
          {-16,60},{-4,60},{-4,40}}, color={0,127,255}));
  connect(bou.ports[1], aquWel1.port_Hot) annotation (Line(points={{40,-1},{6,-1},
          {6,60},{-4,60},{-4,40}},     color={0,127,255}));
  connect(bou.ports[2], aquWel2.port_Hot) annotation (Line(points={{40,1},{26,1},
          {26,0},{6,0},{6,-20},{-4,-20},{-4,-40}}, color={0,127,255}));
  connect(cheEqu.u1, temWel1.y) annotation (Line(points={{58,76},{46,76},{46,82},
          {41,82}}, color={0,0,127}));
  connect(cheEqu.u2, temWel2.y) annotation (Line(points={{58,64},{46,64},{46,50},
          {41,50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, Tolerance=1e-6),
    __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Aquifer/Validation/NumberWells.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that verifies the scalability of
<a href=\"modelica://Buildings.Fluid.Geothermal.Aquifer.MultiWell\">Buildings.Fluid.Geothermal.Aquifer.MultiWell</a>
when multiple wells are used.
</p>
</html>", revisions="<html>
<ul>
<li>
May 2023, by Alessandro Maccarini:<br/>
First Implementation.
</li>
</ul>
</html>"));
end NumberWells;
