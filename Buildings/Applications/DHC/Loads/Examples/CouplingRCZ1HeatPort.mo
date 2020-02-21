within Buildings.Applications.DHC.Loads.Examples;
model CouplingRCZ1HeatPort
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
  BaseClasses.BuildingRCZ1HeatPort bui(nPorts_a=2, nPorts_b=2) "Building"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sources.MassFlowSource_T supHeaWat(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,80})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1) "Sink for heating water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,80})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=bui.terUni.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Sources.RealExpression mHeaWat_flow(y=bui.disFloHea.mReqTot_flow)
    "Heating water flow rate"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Fluid.Sources.MassFlowSource_T supChiWat(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Chilled water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,20})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(y=bui.terUni.T_aChiWat_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Sources.RealExpression mChiWat_flow(y=bui.disFloCoo.mReqTot_flow)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1) "Sink for chilled water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,20})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{40,110},{30,110},{30,71.4},{30.1,71.4}},
      color={255,204,51},
      thickness=0.5));
  connect(THeaWatSup.y, supHeaWat.T_in) annotation (Line(points={{-99,80},{-80,
          80},{-80,84},{-62,84}}, color={0,0,127}));
  connect(mHeaWat_flow.y, supHeaWat.m_flow_in) annotation (Line(points={{-99,
          100},{-80,100},{-80,88},{-62,88}}, color={0,0,127}));
  connect(TChiWatSup.y, supChiWat.T_in) annotation (Line(points={{-99,20},{-80,
          20},{-80,24},{-62,24}}, color={0,0,127}));
  connect(mChiWat_flow.y, supChiWat.m_flow_in) annotation (Line(points={{-99,40},
          {-80,40},{-80,28},{-62,28}}, color={0,0,127}));
  connect(supHeaWat.ports[1], bui.ports_a[1]) annotation (Line(points={{-40,80},
          {-20,80},{-20,30},{0,30}}, color={0,127,255}));
  connect(supChiWat.ports[1], bui.ports_a[2]) annotation (Line(points={{-40,20},
          {-20,20},{-20,34},{0,34}}, color={0,127,255}));
  connect(bui.ports_b[1], sinHeaWat.ports[1]) annotation (Line(points={{60,30},
          {80,30},{80,80},{100,80}}, color={0,127,255}));
  connect(bui.ports_b[2], sinChiWat.ports[1]) annotation (Line(points={{60,34},
          {80,34},{80,20},{100,20}}, color={0,127,255}));
  annotation (
  experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  Documentation(info="
<html>
<p>
This example illustrates the use of
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding</a>,
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution</a>
in a configuration with:
</p>
<ul>
<li>
one-zone building model based on one-element reduced order model, 
</li>
<li>
no secondary pump.
</li>
</ul>
</html>
  "),
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-120,-20},{120,120}})),
  __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingRCZ1HeatPort.mos"
        "Simulate and plot"));
end CouplingRCZ1HeatPort;
