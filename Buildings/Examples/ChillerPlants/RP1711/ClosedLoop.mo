within Buildings.Examples.ChillerPlants.RP1711;
model ClosedLoop

  BaseClasses.RP1711 rP1711_1
    annotation (Placement(transformation(extent={{-16,40},{16,80}})));
  Fluid.HeatExchangers.WetCoilEffectivenessNTU hexWetNtu
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Fluid.Sources.Boundary_pT           sinAir(
    redeclare package Medium = Medium_A,
    use_p_in=false,
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Fluid.Sources.MassFlowSource_T retAir(
    redeclare package Medium = Medium_A,
    use_Xi_in=false,
    m_flow=0.7*m_flow_nominal,
    use_T_in=false,
    T=301.15,
    nPorts=1) "Return air"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-50,80},{-30,100}}),
        iconTransformation(extent={{-120,160},{-100,180}})));
  Fluid.Actuators.Valves.TwoWayLinear           chwIsoVal2
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,20})));
  Fluid.FixedResistances.Junction           jun7 annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={40,-40})));
  Fluid.Sources.MassFlowSource_T outAir(
    redeclare package Medium = Medium_A,
    use_Xi_in=false,
    m_flow=0.3*m_flow_nominal,
    use_T_in=true,
    T=T_a2_nominal,
    nPorts=1) "Outdoor air"
    annotation (Placement(transformation(extent={{120,-50},{100,-30}})));
  Fluid.Sensors.TemperatureTwoPort senTem annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-60})));
equation
  connect(weaDat.weaBus, rP1711_1.weaBus) annotation (Line(
      points={{-60,60},{-40,60},{-40,77},{-11,77}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-60,60},{-40,60},{-40,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(rP1711_1.portCooCoiSup, chwIsoVal2.port_a) annotation (Line(points={{
          -12,40},{-12,34},{-40,34},{-40,30}}, color={0,127,255}));
  connect(chwIsoVal2.port_b, hexWetNtu.port_a1)
    annotation (Line(points={{-40,10},{-40,-4},{-10,-4}}, color={0,127,255}));
  connect(rP1711_1.portCooCoiRet, hexWetNtu.port_b1)
    annotation (Line(points={{12,40},{12,-4},{10,-4}}, color={0,127,255}));
  connect(retAir.ports[1], jun7.port_1)
    annotation (Line(points={{100,-80},{40,-80},{40,-50}}, color={0,127,255}));
  connect(outAir.ports[1], jun7.port_3)
    annotation (Line(points={{100,-40},{50,-40}}, color={0,127,255}));
  connect(jun7.port_2, hexWetNtu.port_a2)
    annotation (Line(points={{40,-30},{40,-16},{10,-16}}, color={0,127,255}));
  connect(weaBus.TDryBul, outAir.T_in) annotation (Line(
      points={{-40,90},{130,90},{130,-36},{122,-36}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(hexWetNtu.port_b2, senTem.port_a) annotation (Line(points={{-10,-16},
          {-40,-16},{-40,-50}}, color={0,127,255}));
  connect(senTem.port_b, sinAir.ports[1]) annotation (Line(points={{-40,-70},{
          -40,-80},{-110,-80}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-140,-140},{140,140}})), Icon(
        coordinateSystem(extent={{-140,-140},{140,140}})));
end ClosedLoop;
