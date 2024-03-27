within Buildings.DHC.Loads.BaseClasses.Examples;
model CouplingRCZ6
  "Example illustrating the coupling of a building model to heating water and chilled water loops"
  extends Modelica.Icons.Example;
  package Medium1=Buildings.Media.Water
    "Fluid in the pipes";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
  Buildings.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingRCZ6 bui(
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1)
    "Building"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare final package Medium=Medium1,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={130,0})));
  Buildings.Fluid.Sources.Boundary_pT sinChilWat(
    redeclare final package Medium=Medium1,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={130,-60})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(
    y=max(
      bui.terUni.T_aHeaWat_nominal))
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(
    y=min(
      bui.terUni.T_aChiWat_nominal))
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-30,0})));
  Fluid.Sources.Boundary_pT supChiWat(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=1)
    "Chilled water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-30,-60})));
equation
  connect(weaDat.weaBus,bui.weaBus)
    annotation (Line(points={{40,30},{30,30},{30,-22.8667},{50.0333,-22.8667}},color={255,204,51},thickness=0.5));
  connect(supHeaWat.T_in,THeaWatSup.y)
    annotation (Line(points={{-42,4},{-60,4},{-60,0},{-79,0}},color={0,0,127}));
  connect(TChiWatSup.y,supChiWat.T_in)
    annotation (Line(points={{-79,-60},{-60,-60},{-60,-56},{-42,-56}},color={0,0,127}));
  connect(supHeaWat.ports[1],bui.ports_aHeaWat[1])
    annotation (Line(points={{-20,0},{20,0},{20,-32},{40,-32}},color={0,127,255}));
  connect(supChiWat.ports[1],bui.ports_aChiWat[1])
    annotation (Line(points={{-20,-60},{20,-60},{20,-36},{40,-36}},color={0,127,255}));
  connect(bui.ports_bHeaWat[1],sinHeaWat.ports[1])
    annotation (Line(points={{60,-32},{80,-32},{80,0},{120,0}},color={0,127,255}));
  connect(bui.ports_bChiWat[1],sinChilWat.ports[1])
    annotation (Line(points={{60,-36},{80,-36},{80,-60},{120,-60}},color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
This example illustrates the use of
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.DHC.Loads.BaseClasses.PartialBuilding</a>,
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.DHC.Loads.BaseClasses.FlowDistribution</a>
in a configuration with
</p>
<ul>
<li>
a six-zone building model based on a two-element reduced order model (from
GeoJSON export), and
</li>
<li>
secondary pumps.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-100},{160,60}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Loads/BaseClasses/Examples/CouplingRCZ6.mos" "Simulate and plot"),
    experiment(
      StopTime=604800,
      Tolerance=1e-06));
end CouplingRCZ6;
