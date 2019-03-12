within Buildings.Fluid.HeatPumps.Examples;
model WaterSourceHeatPump_OneRoomRadiator

  extends Modelica.Icons.Example;

replaceable package MediumA =
      Buildings.Media.Air "Medium model for air";
replaceable package MediumW =
      Buildings.Media.Water "Medium model for water";


  // Internal Loads

 parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000;

  Modelica.Blocks.Sources.CombiTimeTable timTab(extrapolation=Modleica.Blocks.Types.Extrapolation.Periodic,
  smoothness= Modelica.Blocks.Types.Smoothness.ConstantSegments,
  table=[-6*3600, 0;
              8*3600, QRooInt_flow;
             18*3600, 0]) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-4,86},{10,100}})));

parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";




  // Heat Pump
  Buildings.Fluid.HeatPumps.WaterSourceHeatPump heaPum
    annotation (Placement(transformation(extent={{56,-36},{76,-16}})));





 parameter Modelica.SIunits.Power Q_flow_nominal = 20000
    "Nominal heating power (positive for heating)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a_nominal = 273.15+45
    "Water inlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b_nominal = 273.15+25
    "Water outlet temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TAir_nominal = 293.15
    "Air temperature at nominal condition"
    annotation(Dialog(group="Nominal condition"));


//Room description



  HeatTransfer.Sources.PrescribedTemperature Tout "outside Drybulb tempearture"
   annotation (Placement(transformation(extent={{-28,66},{-16,78}})));




  HeatTransfer.Sources.PrescribedHeatFlow preHea
    annotation (Placement(transformation(extent={{20,82},{40,102}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCap(C=1000)
    annotation (Placement(transformation(extent={{52,104},{68,120}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/
        40)
    annotation (Placement(transformation(extent={{34,58},{52,76}})));

 Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
  energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{86,48},{98,62}})));

  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*1.2/3600  "Nominal mass flow rate";




  //radiator parameters

  HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = mediumW,
 energyDynamics= Modelica.Fluid.Types.Dynamics.FixedIntial,
   Q_flow_nominal = Q_flow_nominal,
   T_a_nominal = TRadSup_nominal,
   T_b_nominal = TradRet_nominal,
   T_start = TRadSup_nominal,
   TAir_nominal =  TAir_nominal)  "Radiator"
   annotation (Placement(transformation(extent={{74,22},{54,42}})));



Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor rooSen
    annotation (Placement(transformation(extent={{18,48},{8,58}})));

//Weather Data

BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
 BoundaryConditions.WeatherData.Bus weabus annotation (Placement(transformation(extent={{-66,68},{-40,92}}),
        iconTransformation(extent={{-170,142},{-150,162}})));



   Modelica.Fluid.Sensors.TemperatureTwoPort temSup(
    redeclare package Medium = MediumW,
    m_flow_nominal = mHeaPum_flow_nominal,
    T_start=TradSup_nominal)
                            " Heating water supply temperature"
        annotation (
      Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={104,4})));

   Modelica.Fluid.Sensors.TemperatureTwoPort temRet(
   redeclare package Medium = MediumW,
   m_flow_nominal = mHeaPum_flow_nominal) "Heating water return temperature"
   annotation (
      Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={34,24})));



//------------------------------------------------------------------------------------------------------------------------------- start here


  //Chilled water source and sink
  Sources.FixedBoundary bou
    annotation (Placement(transformation(extent={{-246,-102},{-226,-82}})));
  Sources.FixedBoundary bou1
    annotation (Placement(transformation(extent={{-246,-102},{-226,-82}})));
  Sources.FixedBoundary cHW_Supply(nPorts=1)
    annotation (Placement(transformation(extent={{122,-68},{108,-54}})));






  Sources.FixedBoundary cHw_Return(nPorts=1)
    annotation (Placement(transformation(extent={{2,-68},{16,-54}})));


  //Condenser and Evaporator Pumps
  Movers.FlowControlled_m_flow ConPum
   annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,-14})));

  Movers.FlowControlled_m_flow EvaPum
   annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={36,-46})));


  // Control of the heatig system

  Modelica.Blocks.Logical.Hysteresis
  hyst_RoomTemp(uLow=19 + 273.15, uHigh=21 + 273.15)
    annotation (Placement(transformation(extent={{-74,46},{-88,60}})));

  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-114,-66},{-100,-52}})));

  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-58,-86},{-48,-76}})));



  // Condenser pump control
  Modelica.Blocks.Logical.Hysteresis hyst_ConPum(uLow=0.20*mHeaPum_flow_nominal,
      uHigh=0.25*mHeaPum_flow_nominal)
    annotation (Placement(transformation(extent={{-44,-10},{-54,0}})));




  // Evaporator pump control
  Modelica.Blocks.Logical.Hysteresis hyst_EvaPum(uLow=0.20*mHeaPum_flow_nominal,
      uHigh=0.25*mHeaPum_flow_nominal)
    annotation (Placement(transformation(extent={{-38,-42},{-48,-32}})));
  Modelica.Blocks.Logical.And and1 annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=0,
        origin={-77,-27})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{-58,42},{-50,34}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1
    annotation (Placement(transformation(extent={{-60,8},{-50,18}})));





// Heat Pump Nominal Data
 parameter Data.WSHP.Generic                           per
    annotation (Placement(transformation(extent={{58,-80},{80,-58}})));

equation
  connect(prescribedHeatFlow.Q_flow, combiTimeTable.y[2])
    annotation (Line(points={{20,92},{20,93},{10.7,93}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, vol.heatPort) annotation (Line(points={{40,92},{86,92},{86,55}},
                                        color={191,0,0}));
  connect(heatCapacitor.port, vol.heatPort) annotation (Line(points={{60,104},{86,104},{86,55}},
                                    color={191,0,0}));
  connect(thermalConductor.port_b, vol.heatPort) annotation (Line(points={{52,67},{86,67},{86,55}},
                                        color={191,0,0}));
  connect(rad.heatPortRad, vol.heatPort)
    annotation (Line(points={{62,39.2},{62,55},{86,55}},   color={191,0,0}));
  connect(rad.heatPortCon, vol.heatPort)
    annotation (Line(points={{66,39.2},{66,55},{86,55}},   color={191,0,0}));
  connect(temperatureSensor.port, vol.heatPort) annotation (Line(points={{18,53},{40,53},{40,54},{64,54},{64,
          55},{86,55}},                 color={191,0,0}));
  connect(heaPum.port_b1, Temp_THeat_supply.port_b)
    annotation (Line(points={{76,-20},{104,-20},{104,-4}},
                                                         color={0,127,255}));
  connect(Temp_THeat_supply.port_a, rad.port_a)
    annotation (Line(points={{104,12},{104,32},{74,32}},
                                                       color={0,127,255}));
  connect(heaPum.port_a1, Temp_THeat_return.port_a)
    annotation (Line(points={{56,-20},{34,-20},{34,16}},
                                                       color={0,127,255}));
  connect(Temp_THeat_return.port_b, rad.port_b)
    annotation (Line(points={{34,32},{54,32}},       color={0,127,255}));
  connect(heaPum.port_a2, cHW_Supply.ports[1]) annotation (Line(points={{76,-32},
          {92,-32},{92,-61},{108,-61}},color={0,127,255}));
  connect(Temp_THeat_return.port_a,ConPum. port_a) annotation (Line(points={{34,16},
          {1.77636e-15,16},{1.77636e-15,-4}},
                                            color={0,127,255}));
  connect(cHw_Return.ports[1],EvaPum. port_a)
    annotation (Line(points={{16,-61},{36,-61},{36,-56}}, color={0,127,255}));
  connect(EvaPum.port_b, heaPum.port_b2)
    annotation (Line(points={{36,-36},{36,-32},{56,-32}}, color={0,127,255}));
  connect(temperatureSensor.T, hyst_RoomTemp.u) annotation (Line(points={{8,53},{-72.6,53}},
                                         color={0,0,127}));
  connect(hyst_RoomTemp.y, not1.u) annotation (Line(points={{-88.7,53},{-88.7,53.5},{-115.4,53.5},{-115.4,-59}},
                                       color={255,0,255}));
  connect(booleanToReal.u, not1.y) annotation (Line(points={{-59,-81},{-70,-81},
          {-70,-84},{-78,-84},{-78,-59},{-99.3,-59}}, color={255,0,255}));
  connect(booleanToReal.y, ConPum.m_flow_in) annotation (Line(points={{-47.5,-81},
          {-14,-81},{-14,-14},{-12,-14}}, color={0,0,127}));
  connect(booleanToReal.y, EvaPum.m_flow_in) annotation (Line(points={{-47.5,-81},
          {-14,-81},{-14,-46},{24,-46}}, color={0,0,127}));
  connect(ConPum.m_flow_in, hyst_ConPum.u) annotation (Line(points={{-12,-14},{-36,
          -14},{-36,-5},{-43,-5}}, color={0,0,127}));
  connect(EvaPum.m_flow_in, hyst_EvaPum.u) annotation (Line(points={{24,-46},{-14,
          -46},{-14,-37},{-37,-37}}, color={0,0,127}));
  connect(hyst_EvaPum.y, and1.u1) annotation (Line(points={{-48.5,-37},{-62.25,-37},
          {-62.25,-27},{-71,-27}}, color={255,0,255}));
  connect(and1.u2, hyst_ConPum.y) annotation (Line(points={{-71,-23},{-60.5,-23},
          {-60.5,-5},{-54.5,-5}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{-99.3,-59},{-99.3,41.2},{-58.8,
          41.2}}, color={255,0,255}));
  connect(and1.y, and2.u1) annotation (Line(points={{-82.5,-27},{-88,-27},{-88,38},
          {-58.8,38}}, color={255,0,255}));
  connect(and2.y, heaPum.on) annotation (Line(points={{-49.6,38},{48,38},{48,-23},
          {54,-23}}, color={255,0,255}));
  connect(not1.y, booleanToReal1.u) annotation (Line(points={{-99.3,-59},{-99.3,
          -34},{-92,-34},{-92,6},{-68,6},{-68,13},{-61,13}}, color={255,0,255}));
  connect(booleanToReal1.y, heaPum.TSet) annotation (Line(points={{-49.5,13},{-26,
          13},{-26,8},{24,8},{24,-29},{54,-29}}, color={0,0,127}));
  connect(weaDat.weaBus, weabus) annotation (Line(
      points={{-80,88},{-64,88},{-64,80},{-53,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weabus, weabus) annotation (
    Line(
      points={{-53,80},{-53,80}},
      color={255,204,51},
      thickness=0.5),
    Text(
      string="%first",
      index=3,
      extent={{3,0},{3,0}}),
    Text(
      string="%second",
      index=-3,
      extent={{-3,0},{-3,0}}));
  connect(weabus.TDryBul, Tout.T) annotation (Line(
      points={{-53,80},{-44,80},{-44,72},{-29.2,72}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(Tout.port, theCon.port_a)
    annotation (Line(points={{-16,72},{14,72},{14,67},{34,67}}, color={191,0,0}));
 annotation (Placement(transformation(extent={{-100,-98},{-80,-78}})),
                Placement(transformation(extent={{-28,72},{-14,86}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end WaterSourceHeatPump_OneRoomRadiator;
