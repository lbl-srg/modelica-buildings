within Buildings.Applications.DHC.Loads.Examples;
model CouplingRCZ1Pump
  "Example illustrating the coupling of a single zone RC building model to a fluid loop"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{60,100},{40,120}})));
  package Medium1 = Buildings.Media.Water
    "Source side medium";
  BaseClasses.BuildingRCZ1Pump bui(nPorts1=2)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium1,
    nPorts=1) "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,80})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=bui.terUni.T_a1Hea_nominal)
    annotation (Placement(transformation(extent={{-122,70},{-102,90}})));
  Modelica.Blocks.Sources.RealExpression TCooInlVal(y=bui.terUni.T_a1Coo_nominal)
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = Medium1,
    nPorts=1) "Sink for chilled water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,20})));
  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Source for heating water" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,80})));
  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Source for chilled water" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,20})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{40,110},{30,110},{30,71.4},{30.1,71.4}},
      color={255,204,51},
      thickness=0.5));
  connect(bui.ports_b1[1], sinHea.ports[1])
    annotation (Line(points={{60,30},{80,30},{80,80},{120,80}}, color={0,127,255}));
  connect(bui.ports_b1[2], sinCoo.ports[1])
    annotation (Line(points={{60,34},{80,34},{80,20},{120,20}}, color={0,127,255}));
  connect(souHea.T_in, THeaInlVal.y)
    annotation (Line(points={{-62,84},{-80,84},{-80,80},{-101,80}},
                                                 color={0,0,127}));
  connect(souHea.ports[1], bui.ports_a1[1]) annotation (Line(points={{-40,80},{
          -20,80},{-20,32},{0,32},{0,30}},
                               color={0,127,255}));
  connect(TCooInlVal.y, souCoo.T_in)
    annotation (Line(points={{-99,20},{-80,20},{-80,24},{-62,24}},
                                                 color={0,0,127}));
  connect(souCoo.ports[1], bui.ports_a1[2]) annotation (Line(points={{-40,20},{
          -20,20},{-20,32},{0,32},{0,34}},
                                 color={0,127,255}));
  annotation (
  experiment(
      StopTime=15000000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  Documentation(info="<html>
  <p>
  This example illustrates the use of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>
  to transfer heat from a fluid stream to a simplified building model consisting in two heating loads and one cooling
  load as described in
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.RCBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.RCBuilding</a>.
  </p>
  </html>"),
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-120,-20},{140,120}})),
  __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingRCZ1Pump.mos"
        "Simulate and plot"));
end CouplingRCZ1Pump;
