within Buildings.Applications.DHC.Loads.Examples;
model CouplingTimeSeries
  "Example illustrating the coupling of a building model to heating water and chilled water loops"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water
    "Source side medium";
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries
    bui(
      filNam=
      "modelica://Buildings/Applications/DHC/Loads/Examples/Resources/SwissResidential_20190916.mos",
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1)
    "Building"
    annotation (Placement(transformation(extent={{10,36},{30,56}})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=0,
      origin={130,80})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=0,
      origin={130,20})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=bui.terUniHea.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(y=bui.terUniCoo.T_aChiWat_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Fluid.Sources.Boundary_pT           supHeaWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Heating water supply" annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-50,80})));
  Fluid.Sources.Boundary_pT           supChiWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Chilled water supply" annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-50,20})));
  Modelica.Blocks.Continuous.Integrator EHeaReq(y(unit="J"))
    "Time integral of heating load"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Modelica.Blocks.Continuous.Integrator EHeaAct(y(unit="J"))
    "Actual energy used for heating"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Modelica.Blocks.Continuous.Integrator ECooReq(y(unit="J"))
    "Time integral of cooling load"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Modelica.Blocks.Continuous.Integrator ECooAct(y(unit="J"))
    "Actual energy used for cooling"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
equation
  connect(supHeaWat.T_in,THeaWatSup. y) annotation (Line(points={{-62,84},{-80,84},
          {-80,80},{-99,80}},     color={0,0,127}));
  connect(TChiWatSup.y,supChiWat. T_in) annotation (Line(points={{-99,20},{-80,20},
          {-80,24},{-62,24}},     color={0,0,127}));
  connect(supHeaWat.ports[1], bui.ports_aHeaWat[1]) annotation (Line(points={{-40,80},
          {0,80},{0,44},{10,44}},     color={0,127,255}));
  connect(supChiWat.ports[1], bui.ports_aChiWat[1]) annotation (Line(points={{-40,20},
          {0,20},{0,40},{10,40}},     color={0,127,255}));
  connect(bui.ports_bHeaWat[1], sinHeaWat.ports[1]) annotation (Line(points={{30,44},
          {60,44},{60,80},{120,80}},     color={0,127,255}));
  connect(sinChiWat.ports[1], bui.ports_bChiWat[1]) annotation (Line(points={{120,20},
          {60,20},{60,40},{30,40}},     color={0,127,255}));
  connect(bui.QHea_flow, EHeaAct.u) annotation (Line(points={{30.6667,54.6667},
          {40,54.6667},{40,100},{90,100},{90,120},{98,120}}, color={0,0,127}));
  connect(bui.QReqHea_flow, EHeaReq.u) annotation (Line(points={{26.6667,
          35.3333},{26.6667,32},{36,32},{36,120},{58,120}}, color={0,0,127}));
  connect(bui.QReqCoo_flow, ECooReq.u) annotation (Line(points={{28.6667,
          35.3333},{28.6667,-20},{58,-20}}, color={0,0,127}));
  connect(bui.QCoo_flow, ECooAct.u) annotation (Line(points={{30.6667,53.3333},
          {40,53.3333},{40,0},{90,0},{90,-20},{98,-20}}, color={0,0,127}));
  annotation (
  experiment(
      StopTime=604800,
      Tolerance=1e-06),
  Documentation(info="<html>
<p>
This example illustrates the use of
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding</a>,
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution</a>
in a configuration with
</p>
<ul>
<li>
space heating and cooling loads provided as time series, and
</li>
<li>
secondary pumps.
</li>
</ul>
</html>",
revisions=
"<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-140,-40},{160,140}})),
  __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingTimeSeries.mos"
        "Simulate and plot"));
end CouplingTimeSeries;
