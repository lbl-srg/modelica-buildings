within Buildings.Applications.DHC.Loads.Examples;
model CouplingGeojsonRC
  "Example illustrating the coupling of a multizone RC model to a fluid loop"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Fluid in the pipes";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{110,-30},{90,-10}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.GeojsonRCBuilding bui(nPorts1=2)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,30})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,-90})));
  Buildings.Fluid.Sources.MassFlowSource_T supHea(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Supply for heating water"          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-14,20})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=bui.disFloHea.T_a1_nominal)
    annotation (Placement(transformation(extent={{-84,4},{-64,24}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Req(y=bui.disFloHea.m_flow1Req)
    annotation (Placement(transformation(extent={{-84,24},{-64,44}})));
  Buildings.Fluid.Sources.MassFlowSource_T supCoo(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Supply for chilled water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-14,-60})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal1(y=bui.disFloCoo.T_a1_nominal)
    annotation (Placement(transformation(extent={{-84,-76},{-64,-56}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Req1(y=bui.disFloCoo.m_flow1Req)
    annotation (Placement(transformation(extent={{-84,-56},{-64,-36}})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{90,-20},{50.1,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaInlVal.y,supHea. T_in) annotation (Line(points={{-63,14},{-44,14},
          {-44,24},{-26,24}},                                                                       color={0,0,127}));
  connect(m_flow1Req.y,supHea. m_flow_in)
    annotation (Line(points={{-63,34},{-44,34},{-44,28},{-26,28}}, color={0,0,127}));
  connect(THeaInlVal1.y,supCoo. T_in) annotation (Line(points={{-63,-66},{-44,-66},
          {-44,-56},{-26,-56}},                                                                    color={0,0,127}));
  connect(m_flow1Req1.y,supCoo. m_flow_in)
    annotation (Line(points={{-63,-46},{-44,-46},{-44,-52},{-26,-52}},
                                                                   color={0,0,127}));
  connect(supHea.ports[1], bui.ports_a1[1])
    annotation (Line(points={{-4,20},{20,20},{20,-32},{40,-32}},
                                                              color={0,127,255}));
  connect(supCoo.ports[1], bui.ports_a1[2])
    annotation (Line(points={{-4,-60},{20,-60},{20,-28},{40,-28}},
                                                              color={0,127,255}));
  connect(bui.ports_b1[1], sinHea.ports[1]) annotation (Line(points={{60,-32},{74,
          -32},{74,30},{90,30}}, color={0,127,255}));
  connect(bui.ports_b1[2], sinCoo.ports[1]) annotation (Line(points={{60,-28},{74,
          -28},{74,-90},{90,-90}}, color={0,127,255}));
  annotation (
  Documentation(info="<html>
  <p>
  This example illustrates the use of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>
  to transfer heat from a fluid stream to a simplified multizone RC model resulting
  from the translation of a GeoJSON model specified within Urbanopt UI, see
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding</a>.
  </p>
  </html>"),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{140,60}})),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingGeojsonRC.mos"
        "Simulate and plot"));
end CouplingGeojsonRC;
