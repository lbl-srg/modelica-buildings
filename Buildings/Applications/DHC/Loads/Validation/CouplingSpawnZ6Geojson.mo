within Buildings.Applications.DHC.Loads.Validation;
model CouplingSpawnZ6Geojson
  "Example illustrating the coupling of a multizone Spawn model to a fluid loop"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water
    "Source side medium";
  Buildings.Applications.DHC.Loads.Validation.BaseClasses.BuildingSpawnZ6Geojson
    bui annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(redeclare package Medium =
        Medium1, nPorts=1) "Sink for heating water" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,20})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(redeclare package Medium =
        Medium1, nPorts=1) "Sink for chilled water" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-80})));
  Buildings.Fluid.Sources.MassFlowSource_T supHeaWat(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,0})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=max(bui.terUni.T_a1Hea_nominal))
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.RealExpression mHeaWat_flow(y=bui.disFloHea.mReq_flow)
    "Heating water flow rate"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T supChiWat(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Chilled water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-80})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(y=min(bui.terUni.T_a1Coo_nominal))
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Modelica.Blocks.Sources.RealExpression mChiWat_flow(y=bui.disFloCoo.mReq_flow)
    "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
equation
  connect(THeaWatSup.y, supHeaWat.T_in) annotation (Line(points={{-79,0},{-60,0},
          {-60,4},{-42,4}}, color={0,0,127}));
  connect(mHeaWat_flow.y, supHeaWat.m_flow_in) annotation (Line(points={{-79,20},
          {-60,20},{-60,8},{-42,8}}, color={0,0,127}));
  connect(TChiWatSup.y, supChiWat.T_in) annotation (Line(points={{-79,-80},{-60,
          -80},{-60,-76},{-42,-76}}, color={0,0,127}));
  connect(mChiWat_flow.y, supChiWat.m_flow_in) annotation (Line(points={{-79,-60},
          {-60,-60},{-60,-72},{-42,-72}}, color={0,0,127}));
  connect(supHeaWat.ports[1], bui.ports_a1[1]) annotation (Line(points={{-20,0},
          {0,0},{0,-48},{20,-48}}, color={0,127,255}));
  connect(supChiWat.ports[1], bui.ports_a1[2]) annotation (Line(points={{-20,-80},
          {0,-80},{0,-48},{20,-48}}, color={0,127,255}));
  connect(bui.ports_b1[1], sinHeaWat.ports[1]) annotation (Line(points={{80,-48},
          {100,-48},{100,20},{120,20}}, color={0,127,255}));
  connect(bui.ports_b1[2], sinChiWat.ports[1]) annotation (Line(points={{80,-48},
          {100,-48},{100,-80},{120,-80}}, color={0,127,255}));
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
  to transfer heat from a fluid stream to a simplified multizone RC model resulting
  from the translation of a GeoJSON model specified within Urbanopt UI, see
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.GeojsonExportBuilding</a>.
  </p>
  </html>"),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{140,80}}),
        graphics={Text(
          extent={{-98,78},{34,52}},
          lineColor={28,108,200},
          textString="Simulation requires
Hidden.AvoidDoubleComputation=true")}),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Loads/Examples/CouplingSpawnZ6Geojson.mos"
        "Simulate and plot"));
end CouplingSpawnZ6Geojson;
