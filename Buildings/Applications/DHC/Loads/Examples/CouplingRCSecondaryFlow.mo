within Buildings.Applications.DHC.Loads.Examples;
model CouplingRCSecondaryFlow "Example illustrating the coupling of a RC building model to a fluid loop"
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{120,60},{100,80}})));
  package Medium1 = Buildings.Media.Water
    "Source side medium";
  BaseClasses.RCBuildingSecondaryFlow bui
    annotation (Placement(transformation(extent={{28,20},{48,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T supHea(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Supply for heating water"          annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-32,30})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium1,
    p=300000,
    T=bui.couHea.T_b1_nominal,
    nPorts=1) "Sink for heating water"
                                      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,30})));
  Modelica.Blocks.Sources.RealExpression THeaInlVal(y=bui.couHea.T_a1_nominal)
    annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Req(y=bui.couHea.m_flow1Req)
    annotation (Placement(transformation(extent={{-100,34},{-80,54}})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{100,70},{60,70},{60,40},{38.1,40}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaInlVal.y, supHea.T_in) annotation (Line(points={{-79,24},{-60,24},{-60,34},{-44,34}}, color={0,0,127}));
  connect(supHea.ports[1], bui.port_a2) annotation (Line(points={{-22,30},{28,30}},                 color={0,127,255}));
  connect(bui.port_b2, sinHea.ports[1])
    annotation (Line(points={{48,30},{100,30}},                  color={0,127,255}));
  connect(m_flow1Req.y, supHea.m_flow_in)
    annotation (Line(points={{-79,44},{-60,44},{-60,38},{-44,38}}, color={0,0,127}));
  annotation (
  experiment(
    StopTime=604800),
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
  coordinateSystem(preserveAspectRatio=false, extent={{-100,0},{140,100}})),
  __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingRC.mos"
        "Simulate and plot"));
end CouplingRCSecondaryFlow;
