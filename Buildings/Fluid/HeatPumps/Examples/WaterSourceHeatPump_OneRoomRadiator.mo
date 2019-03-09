within Buildings.Fluid.HeatPumps.Examples;
model WaterSourceHeatPump_OneRoomRadiator
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-58,78},{-42,98}}), iconTransformation(extent={
            {-168,10},{-148,30}})));
  Buildings.Fluid.HeatPumps.WaterSourceHeatPump heaPum
    annotation (Placement(transformation(extent={{32,-40},{52,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(columns=2:size(table, 2))
    annotation (Placement(transformation(extent={{-4,86},{10,100}})));
  HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{-26,60},{-12,74}})));
  HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{20,82},{40,102}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor
    annotation (Placement(transformation(extent={{52,104},{68,120}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor
    annotation (Placement(transformation(extent={{34,58},{52,76}})));
  MixingVolumes.MixingVolume vol annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,80})));
  HeatExchangers.Radiators.RadiatorEN442_2 rad
    annotation (Placement(transformation(extent={{50,18},{30,38}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{-22,36},{-36,50}})));
  Sources.FixedBoundary bou
    annotation (Placement(transformation(extent={{-246,-102},{-226,-82}})));
  Sources.FixedBoundary bou1
    annotation (Placement(transformation(extent={{-246,-102},{-226,-82}})));
  Sources.FixedBoundary cHW_Supply(nPorts=1)
    annotation (Placement(transformation(extent={{98,-72},{84,-58}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort Temp_THeat_supply annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,6})));
  Modelica.Fluid.Sensors.TemperatureTwoPort Temp_THeat_return annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={8,6})));
  Sources.FixedBoundary cHw_Return(nPorts=1)
    annotation (Placement(transformation(extent={{-22,-72},{-8,-58}})));
  Movers.FlowControlled_m_flow fan
    annotation (Placement(transformation(extent={{-46,-12},{-26,8}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-80,88},{-50,88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, prescribedTemperature.T) annotation (Line(
      points={{-50,88},{-30,88},{-30,67},{-27.4,67}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(prescribedHeatFlow.Q_flow, combiTimeTable.y[2])
    annotation (Line(points={{20,92},{20,93},{10.7,93}}, color={0,0,127}));
  connect(prescribedTemperature.port, thermalConductor.port_a)
    annotation (Line(points={{-12,67},{34,67}}, color={191,0,0}));
  connect(prescribedHeatFlow.port, vol.heatPort) annotation (Line(points={{40,
          92},{66,92},{66,80},{80,80}}, color={191,0,0}));
  connect(heatCapacitor.port, vol.heatPort) annotation (Line(points={{60,104},{
          66,104},{66,80},{80,80}}, color={191,0,0}));
  connect(thermalConductor.port_b, vol.heatPort) annotation (Line(points={{52,
          67},{66,67},{66,80},{80,80}}, color={191,0,0}));
  connect(rad.heatPortRad, vol.heatPort)
    annotation (Line(points={{38,35.2},{80,35.2},{80,80}}, color={191,0,0}));
  connect(rad.heatPortCon, vol.heatPort)
    annotation (Line(points={{42,35.2},{80,35.2},{80,80}}, color={191,0,0}));
  connect(temperatureSensor.port, vol.heatPort) annotation (Line(points={{-22,
          43},{72,43},{72,80},{80,80}}, color={191,0,0}));
  connect(heaPum.port_b1, Temp_THeat_supply.port_b)
    annotation (Line(points={{52,-24},{70,-24},{70,-4}}, color={0,127,255}));
  connect(Temp_THeat_supply.port_a, rad.port_a)
    annotation (Line(points={{70,16},{70,28},{50,28}}, color={0,127,255}));
  connect(heaPum.port_a1, Temp_THeat_return.port_a)
    annotation (Line(points={{32,-24},{8,-24},{8,-4}}, color={0,127,255}));
  connect(Temp_THeat_return.port_b, rad.port_b)
    annotation (Line(points={{8,16},{8,28},{30,28}}, color={0,127,255}));
  connect(cHw_Return.ports[1], heaPum.port_b2) annotation (Line(points={{-8,-65},
          {12,-65},{12,-36},{32,-36}}, color={0,127,255}));
  connect(heaPum.port_a2, cHW_Supply.ports[1]) annotation (Line(points={{52,-36},
          {68,-36},{68,-65},{84,-65}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{120,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,
            120}})));






end WaterSourceHeatPump_OneRoomRadiator;
