within Buildings.Applications.DHC.Loads.Examples;
model CouplingRCZ6GeojsonPump
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
  BaseClasses.BuildingRCZ6GeojsonPump bui
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
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=max(bui.terUni.T_a1Hea_nominal))
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.RealExpression TCooInlVal(y=min(bui.terUni.T_a1Coo_nominal))
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Fluid.Sources.Boundary_pT           souHea(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Source for heating water" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,0})));
  Fluid.Sources.Boundary_pT           souCoo(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Source for chilled water" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-60})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{40,30},{30,30},{30,-8.6},{50.1,-8.6}},
      color={255,204,51},
      thickness=0.5));
  connect(bui.ports_b1[1], sinHea.ports[1]) annotation (Line(points={{80,-48},{
          100,-48},{100,0},{120,0}}, color={0,127,255}));
  connect(bui.ports_b1[2], sinCoo.ports[1]) annotation (Line(points={{80,-48},{
          100,-48},{100,-60},{120,-60}}, color={0,127,255}));
  connect(souHea.T_in,THeaInlVal. y)
    annotation (Line(points={{-42,4},{-60,4},{-60,0},{-79,0}},
                                                 color={0,0,127}));
  connect(souHea.ports[1], bui.ports_a1[1]) annotation (Line(points={{-20,0},{0,
          0},{0,-48},{20,-48}},color={0,127,255}));
  connect(TCooInlVal.y,souCoo. T_in)
    annotation (Line(points={{-79,-60},{-60,-60},{-60,-56},{-42,-56}},
                                                 color={0,0,127}));
  connect(souCoo.ports[1], bui.ports_a1[2]) annotation (Line(points={{-20,-60},
          {0,-60},{0,-48},{20,-48}},
                                 color={0,127,255}));
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
end CouplingRCZ6GeojsonPump;
