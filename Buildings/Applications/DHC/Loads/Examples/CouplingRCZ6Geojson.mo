within Buildings.Applications.DHC.Loads.Examples;
model CouplingRCZ6Geojson
  "Example illustrating the coupling of a multizone RC model to a fluid loop"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Fluid in the pipes";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.BuildingRCZ6Geojson bui(
      nPorts1=2)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium1, nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,0})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = Medium1, nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-60})));
  Buildings.Fluid.Sources.MassFlowSource_T supHea(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Supply for heating water"          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,0})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=max(bui.terUni.T_a1Hea_nominal))
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.RealExpression mHea_flow(y=bui.disFloHea.mReq_flow)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T supCoo(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Supply for chilled water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-60})));
  Modelica.Blocks.Sources.RealExpression TCooInlVal(y=min(bui.terUni.T_a1Coo_nominal))
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Blocks.Sources.RealExpression mCoo_flow(y=bui.disFloCoo.mReq_flow)
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{40,30},{30,30},{30,-8.6},{50.1,-8.6}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaInlVal.y,supHea. T_in) annotation (Line(points={{-79,0},{-60,0},{
          -60,4},{-42,4}},                                                                          color={0,0,127}));
  connect(mHea_flow.y, supHea.m_flow_in) annotation (Line(points={{-79,20},{-60,
          20},{-60,8},{-42,8}},   color={0,0,127}));
  connect(TCooInlVal.y, supCoo.T_in) annotation (Line(points={{-79,-60},{-60,
          -60},{-60,-56},{-42,-56}},
                                color={0,0,127}));
  connect(mCoo_flow.y, supCoo.m_flow_in) annotation (Line(points={{-79,-40},{
          -60,-40},{-60,-52},{-42,-52}},
                                     color={0,0,127}));
  connect(supHea.ports[1], bui.ports_a1[1])
    annotation (Line(points={{-20,0},{0,0},{0,-46},{20,-46},{20,-50}},
                                                              color={0,127,255}));
  connect(supCoo.ports[1], bui.ports_a1[2])
    annotation (Line(points={{-20,-60},{0,-60},{0,-50},{20,-50},{20,-46}},
                                                              color={0,127,255}));
  connect(bui.ports_b1[1], sinHea.ports[1]) annotation (Line(points={{80,-50},{
          100,-50},{100,0},{120,0}}, color={0,127,255}));
  connect(bui.ports_b1[2], sinCoo.ports[1]) annotation (Line(points={{80,-46},{
          100,-46},{100,-60},{120,-60}}, color={0,127,255}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{140,60}})),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingGeojsonRC.mos"
        "Simulate and plot"),
    experiment(
      StopTime=15000000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end CouplingRCZ6Geojson;
