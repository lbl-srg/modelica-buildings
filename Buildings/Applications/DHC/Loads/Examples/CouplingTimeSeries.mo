within Buildings.Applications.DHC.Loads.Examples;
model CouplingTimeSeries
  "Example illustrating the coupling of a time series building model to a fluid loop"
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
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.TimeSeriesBuilding bui(
      nPorts1=2)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sources.MassFlowSource_T supHea(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Supply for heating water"          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,90})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1) "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,90})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=bui.terUni.T_a1_nominal[1])
    annotation (Placement(transformation(extent={{-100,74},{-80,94}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Req(y=bui.terUni.m_flow1Req[1])
    annotation (Placement(transformation(extent={{-100,94},{-80,114}})));
  Buildings.Fluid.Sources.MassFlowSource_T supCoo(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Supply for chilled water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,10})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal1(y=bui.terUni.T_a1_nominal[2])
    annotation (Placement(transformation(extent={{-100,-6},{-80,14}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Req1(y=bui.terUni.m_flow1Req[2])
    annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1) "Sink for chilled water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,10})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{40,110},{30,110},{30,60},{30.1,60}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaInlVal.y, supHea.T_in) annotation (Line(points={{-79,84},{-60,84},{-60,94},{-42,94}}, color={0,0,127}));
  connect(m_flow1Req.y, supHea.m_flow_in)
    annotation (Line(points={{-79,104},{-60,104},{-60,98},{-42,98}},
                                                                   color={0,0,127}));
  connect(THeaInlVal1.y, supCoo.T_in) annotation (Line(points={{-79,4},{-60,4},{-60,14},{-42,14}}, color={0,0,127}));
  connect(m_flow1Req1.y, supCoo.m_flow_in)
    annotation (Line(points={{-79,24},{-60,24},{-60,18},{-42,18}}, color={0,0,127}));
  connect(supHea.ports[1], bui.ports_a1[1])
    annotation (Line(points={{-20,90},{4,90},{4,48},{20,48}}, color={0,127,255}));
  connect(supCoo.ports[1], bui.ports_a1[2])
    annotation (Line(points={{-20,10},{4,10},{4,52},{20,52}}, color={0,127,255}));
  connect(bui.ports_b1[1], sinHea.ports[1])
    annotation (Line(points={{40,48},{74,48},{74,90},{100,90}}, color={0,127,255}));
  connect(bui.ports_b1[2], sinCoo.ports[1])
    annotation (Line(points={{40,52},{74,52},{74,10},{100,10}}, color={0,127,255}));
  annotation (
  experiment(
      StopTime=604800,
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
  __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingTimeSeries.mos"
        "Simulate and plot"));
end CouplingTimeSeries;
