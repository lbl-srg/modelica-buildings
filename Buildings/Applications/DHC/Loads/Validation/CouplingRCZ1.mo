within Buildings.Applications.DHC.Loads.Validation;
model CouplingRCZ1
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
  BaseClasses.BuildingRCZ1 bui(nPorts_a1=2, nPorts_b1=2)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(redeclare package Medium =
        Medium1, nPorts=1) "Sink for heating water" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,80})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(redeclare package Medium =
        Medium1, nPorts=1) "Sink for chilled water" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,20})));
  Fluid.Sources.MassFlowSource_T supHeaWat(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,80})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=bui.terUni.T_a1Hea_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Sources.RealExpression mHeaWat_flow(y=bui.disFloHea.mReq_flow)
    "Heating water flow rate"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Fluid.Sources.MassFlowSource_T supChiWat(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Chilled water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,20})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(y=bui.terUni.T_a1Coo_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Sources.RealExpression mChiWat_flow(y=bui.disFloCoo.mReq_flow)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
equation
  connect(weaDat.weaBus, bui.weaBus)
  annotation (Line(
      points={{40,110},{30,110},{30,71.4},{30.1,71.4}},
      color={255,204,51},
      thickness=0.5));
  connect(bui.ports_b1[1], sinHeaWat.ports[1]) annotation (Line(points={{60,30},
          {80,30},{80,80},{120,80}}, color={0,127,255}));
  connect(bui.ports_b1[2], sinChiWat.ports[1]) annotation (Line(points={{60,34},
          {80,34},{80,20},{120,20}}, color={0,127,255}));
  connect(THeaWatSup.y, supHeaWat.T_in) annotation (Line(points={{-99,80},{-80,
          80},{-80,84},{-62,84}}, color={0,0,127}));
  connect(mHeaWat_flow.y, supHeaWat.m_flow_in) annotation (Line(points={{-99,
          100},{-80,100},{-80,88},{-62,88}}, color={0,0,127}));
  connect(TChiWatSup.y, supChiWat.T_in) annotation (Line(points={{-99,20},{-80,
          20},{-80,24},{-62,24}}, color={0,0,127}));
  connect(mChiWat_flow.y, supChiWat.m_flow_in) annotation (Line(points={{-99,40},
          {-80,40},{-80,28},{-62,28}}, color={0,0,127}));
  connect(supHeaWat.ports[1], bui.ports_a1[1]) annotation (Line(points={{-40,80},
          {-20,80},{-20,30},{0,30}}, color={0,127,255}));
  connect(supChiWat.ports[1], bui.ports_a1[2]) annotation (Line(points={{-40,20},
          {-20,20},{-20,34},{0,34}}, color={0,127,255}));
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
  __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Loads/Validation/CouplingRCZ1.mos"
        "Simulate and plot"));
end CouplingRCZ1;
