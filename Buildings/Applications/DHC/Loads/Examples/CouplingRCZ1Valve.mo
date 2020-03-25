within Buildings.Applications.DHC.Loads.Examples;
model CouplingRCZ1Valve
  "Example illustrating the coupling of a building model to heating water and chilled water loops"
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
  BaseClasses.BuildingRCZ1Valve bui(nPorts_a=2, nPorts_b=2) "Building"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(redeclare package Medium =
        Medium1, nPorts=1) "Sink for heating water" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,80})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=bui.terUni.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(y=bui.terUni.T_aChiWat_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(redeclare package Medium =
        Medium1, nPorts=1) "Sink for chilled water" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,20})));
  Buildings.Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,80})));
  Buildings.Fluid.Sources.Boundary_pT supChiWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Chilled water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,20})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{40,110},{30,110},{30,57.1333},{30.0333,57.1333}},
      color={255,204,51},
      thickness=0.5));
  connect(bui.ports_b[1], sinHeaWat.ports[1]) annotation (Line(points={{40,
          43.3333},{80,43.3333},{80,80},{120,80}},
                                     color={0,127,255}));
  connect(bui.ports_b[2], sinChiWat.ports[1]) annotation (Line(points={{40,
          44.6667},{80,44.6667},{80,20},{120,20}},
                                     color={0,127,255}));
  connect(supHeaWat.T_in, THeaWatSup.y) annotation (Line(points={{-62,84},{-80,
          84},{-80,80},{-99,80}}, color={0,0,127}));
  connect(supHeaWat.ports[1], bui.ports_a[1]) annotation (Line(points={{-40,80},
          {-20,80},{-20,32},{20,32},{20,43.3333}},
                                            color={0,127,255}));
  connect(TChiWatSup.y, supChiWat.T_in) annotation (Line(points={{-99,20},{-80,
          20},{-80,24},{-62,24}}, color={0,0,127}));
  connect(supChiWat.ports[1], bui.ports_a[2]) annotation (Line(points={{-40,20},
          {-20,20},{-20,32},{20,32},{20,44.6667}},
                                            color={0,127,255}));
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
a one-zone building model based on a one-element reduced order model, and
</li>
<li>
secondary pumps and mixing valves controlling the heating and chilled water
supply temperature.
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
  coordinateSystem(preserveAspectRatio=false, extent={{-140,-20},{160,140}})),
  __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingRCZ1Valve.mos"
        "Simulate and plot"));
end CouplingRCZ1Valve;
