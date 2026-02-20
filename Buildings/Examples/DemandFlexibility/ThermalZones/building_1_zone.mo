within Buildings.Examples.DemandFlexibility.ThermalZones;
block building_1_zone
            package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);

  Subsequences.ModelicaRoom modelicaRoom(
    C=3500*1014.54*1.2,
    hRoo=2.74,
    AFlo=160)
    annotation (Placement(transformation(extent={{-24,18},{18,48}})));
  Modelica.Blocks.Sources.CombiTimeTable customHeatAddition1(
    table=[0,0; 12,300; 14,500; 16,300; 18,0.0; 24,0.0],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  Modelica.Blocks.Interfaces.RealOutput TZon annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,2})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{-108,48},{-88,68}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{92,48},{112,68}})));
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
  connect(customHeatAddition1.y[1], modelicaRoom.CustomHeatFlow) annotation (
      Line(points={{-49,10},{-30,10},{-30,21.8},{-25,21.8}}, color={0,0,127}));

  connect(weaBus, modelicaRoom.weaBus) annotation (Line(
      points={{-102,-60},{-4,-60},{-4,-4},{-4.4,-4},{-4.4,39.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end building_1_zone;
