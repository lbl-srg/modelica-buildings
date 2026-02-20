within Buildings.Examples.DemandFlexibility.ThermalZones;
block building_3_zone
            package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);
  parameter Integer nZones=3;
  Subsequences.ModelicaRoom modelicaRoom[nZones]
    annotation (Placement(transformation(extent={{-24,18},{18,48}})));
  Modelica.Blocks.Sources.CombiTimeTable customHeatAddition1(
    table=[0,0; 12,150; 14,250; 16,150; 18,0.0; 24,0.0],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-76,8},{-56,28}})));
  Modelica.Blocks.Interfaces.RealOutput TZon[nZones] annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,2})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a[nZones](redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{-108,48},{-88,68}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b[nZones](redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{92,48},{112,68}})));
  Modelica.Blocks.Sources.CombiTimeTable customHeatAddition2(
    table=[0,200; 12,350; 14,450; 16,350; 18,200; 24,200],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-54,-40},{-34,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable customHeatAddition3(
    table=[0,-100; 12,50; 14,150; 16,50; 18,-100; 24,-100],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-56,-82},{-36,-62}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{-112,-70},{-92,-50}}),
        iconTransformation(extent={{-116,-46},{-96,-26}})));
equation
  connect(modelicaRoom.TZon, TZon) annotation (Line(points={{-0.6,49},{-0.6,54},
          {96,54},{96,2},{110,2}}, color={0,0,127}));
  connect(port_a, modelicaRoom.port_a) annotation (Line(points={{-98,58},{-30,
          58},{-30,36.4},{-24.6,36.4}}, color={0,127,255}));
  connect(modelicaRoom.port_b, port_b) annotation (Line(points={{18.4,36.8},{
          102,36.8},{102,58}}, color={0,127,255}));
  connect(customHeatAddition1.y[1], modelicaRoom[1].CustomHeatFlow) annotation (
     Line(points={{-55,18},{-30,18},{-30,21.8},{-25,21.8}}, color={0,0,127}));
  connect(customHeatAddition2.y[1], modelicaRoom[2].CustomHeatFlow) annotation (
     Line(points={{-33,-30},{-30,-30},{-30,21.8},{-25,21.8}}, color={0,0,127}));
  connect(customHeatAddition3.y[1], modelicaRoom[3].CustomHeatFlow) annotation (
     Line(points={{-35,-72},{-30,-72},{-30,21.8},{-25,21.8}}, color={0,0,127}));
  connect(weaBus, modelicaRoom[1].weaBus) annotation (Line(
      points={{-102,-60},{-80,-60},{-80,42},{-28,42},{-28,52},{-4.4,52},{-4.4,
          39.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, modelicaRoom[2].weaBus) annotation (Line(
      points={{-102,-60},{-80,-60},{-80,42},{-28,42},{-28,52},{-4.4,52},{-4.4,
          39.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, modelicaRoom[3].weaBus) annotation (Line(
      points={{-102,-60},{-80,-60},{-80,42},{-28,42},{-28,52},{-4.4,52},{-4.4,
          39.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end building_3_zone;
