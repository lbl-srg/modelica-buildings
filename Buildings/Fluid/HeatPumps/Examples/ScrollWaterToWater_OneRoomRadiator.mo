within Buildings.Fluid.HeatPumps.Examples;
model ScrollWaterToWater_OneRoomRadiator
  "Heat pump with scroll compressor connected to a simple room model with radiator"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air "Medium model for air";
  replaceable package MediumW =
      Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.SIunits.Temperature TRadSup_nominal = 273.15+50
    "Radiator nominal supply water temperature";
  parameter Modelica.SIunits.Temperature TRadRet_nominal = 273.15+45
    "Radiator nominal return water temperature";

  parameter Modelica.SIunits.MassFlowRate mHeaPum_flow_nominal=
    Q_flow_nominal/4200/5
    "Heat pump nominal mass flow rate";
//------------------------------------------------------------------------------//

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/40)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000
    "Internal heat gains of the room";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[-6*3600, 0;
              8*3600, QRooInt_flow;
             18*3600, 0]) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal,
    m_flow_nominal=mHeaPum_flow_nominal,
    T_start=TRadSup_nominal)     "Radiator"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaPum_flow_nominal,
    T_start=TRadSup_nominal)            "Supply water temperature"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-20})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temRoo
    "Room temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-40,30})));

//----------------------------------------------------------------------------//

  Buildings.Fluid.Movers.FlowControlled_m_flow pumHeaPum(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaPum_flow_nominal,
    y_start=1,
    m_flow_start=0.85,
    T_start=TRadSup_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for radiator side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-100})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Sources.FixedBoundary preSou(redeclare package Medium = MediumW,
      nPorts=1,
    T=TRadSup_nominal)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{90,-140},{70,-120}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(redeclare package Medium =
        MediumW, m_flow_nominal=mHeaPum_flow_nominal,
    T_start=TRadSup_nominal)                          "Return water temperature"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={58,-20})));

//------------------------------------------------------------------------------------//

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

//--------------------------------------------------------------------------------------//

  ScrollWaterToWater heaPum(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    redeclare package ref = Media.Refrigerants.R410A,
    dp1_nominal=2000,
    dp2_nominal=2000,
    tau1=15,
    tau2=15,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m1_flow_nominal=mHeaPum_flow_nominal,
    m2_flow_nominal=mHeaPum_flow_nominal,
    datHeaPum=Data.ScrollWaterToWater.Heating.Daikin_WRA072_24kW_4_30COP_R410A(),
    T1_start=TRadSup_nominal)
    "Heat pump"
    annotation (Placement(transformation(extent={{34,-146},{14,-126}})));

  Sources.FixedBoundary sou(
    redeclare package Medium = MediumW,
    use_T=true,
    nPorts=1,
    T=281.15) "Fluid source on source side"
    annotation (Placement(transformation(extent={{-38,-208},{-18,-188}})));
  Sources.FixedBoundary sin(
    redeclare package Medium = MediumW,
    use_T=true,
    nPorts=1,
    T=283.15) "Fluid sink on source side"
    annotation (Placement(transformation(extent={{88,-210},{68,-190}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumHeaPumSou(
    redeclare package Medium = MediumW,
    y_start=1,
    m_flow_start=0.85,
    m_flow_nominal=mHeaPum_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for heat pump source side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={2,-178})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(
    uLow=273.15 + 19,
    uHigh=273.15 + 21) "Hysteresis controller"
            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-190,-50})));
  Modelica.Blocks.Logical.Not not2 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-150,-50})));
  Modelica.Blocks.Math.BooleanToReal booToReaPum(realTrue=1, y(start=0))
    "Pump signal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-100})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{6,-82},{16,-72}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{26,-56},{38,-44}})));
  Modelica.Blocks.Math.BooleanToReal booToReaPum1(
    realTrue=1,
    y(start=0))
    "Pump signal" annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=90,
        origin={41,-79})));
  Modelica.Blocks.Logical.Hysteresis tesConHea(
    uHigh=0.25*mHeaPum_flow_nominal,
    uLow=0.20*mHeaPum_flow_nominal) "Test for flow rate of condenser pump"
    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-31,-77})));
  Modelica.Blocks.Logical.Hysteresis tesEvaPum(
    uLow=0.20*mHeaPum_flow_nominal,
    uHigh=0.25*mHeaPum_flow_nominal) "Test for flow rate of evaporator pump"
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=-90,
        origin={0,-102})));
equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{70,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1], preHea.Q_flow) annotation (Line(
      points={{1,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.port_b, rad.port_a) annotation (Line(
      points={{-50,-10},{-5.55112e-016,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRoo.port, vol.heatPort) annotation (Line(
      points={{-30,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortCon, vol.heatPort) annotation (Line(
      points={{8,-2.8},{8,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad, vol.heatPort) annotation (Line(
      points={{12,-2.8},{12,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-200,50},{-150,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-150,50},{-22,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{0,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(temRet.port_b, heaPum.port_a1) annotation (Line(points={{58,-30},{58,-30},
          {58,-130},{34,-130}},       color={0,127,255}));
  connect(preSou.ports[1], temRet.port_b) annotation (Line(points={{70,-130},{58,
          -130},{58,-30}},     color={0,127,255}));
  connect(sou.ports[1], pumHeaPumSou.port_a) annotation (Line(points={{-18,-198},
          {2,-198},{2,-188}},                      color={0,127,255}));
  connect(pumHeaPumSou.port_b, heaPum.port_a2) annotation (Line(points={{2,-168},
          {2,-168},{2,-142},{14,-142}},                    color={0,127,255}));
  connect(sin.ports[1], heaPum.port_b2) annotation (Line(points={{68,-200},{42,-200},
          {42,-142},{34,-142}},       color={0,127,255}));
  connect(hysteresis.y, not2.u) annotation (Line(points={{-179,-50},{-179,-50},{
          -162,-50}}, color={255,0,255}));
  connect(temRoo.T, hysteresis.u)
    annotation (Line(points={{-50,30},{-220,30},{-220,30},{-220,-50},{-202,-50},
          {-202,-50}},                                      color={0,0,127}));
  connect(pumHeaPum.port_b, temSup.port_a)
    annotation (Line(points={{-50,-90},{-50,-30}}, color={0,127,255}));
  connect(temRet.port_a, rad.port_b)
    annotation (Line(points={{58,-10},{42,-10},{20,-10}}, color={0,127,255}));
  connect(and2.u2, and1.y) annotation (Line(points={{24.8,-54.8},{18,-54.8},{18,
          -77},{16.5,-77}},
                       color={255,0,255}));
  connect(booToReaPum1.y, heaPum.y) annotation (Line(points={{41,-84.5},{41,
          -84.5},{41,-133},{36,-133}}, color={0,0,127}));
  connect(booToReaPum1.u, and2.y) annotation (Line(points={{41,-73},{41,-73},{41,
          -50},{38.6,-50}},    color={255,0,255}));
  connect(tesConHea.y, and1.u1)
    annotation (Line(points={{-25.5,-77},{5,-77}}, color={255,0,255}));
  connect(tesEvaPum.y, and1.u2) annotation (Line(points={{1.11022e-15,-95.4},{0,
          -95.4},{0,-81},{5,-81}}, color={255,0,255}));
  connect(pumHeaPum.m_flow_actual, tesConHea.u) annotation (Line(points={{-52,-89},
          {-52,-89},{-52,-78},{-52,-77},{-44,-77},{-37,-77}}, color={0,0,127}));
  connect(pumHeaPumSou.m_flow_actual, tesEvaPum.u) annotation (Line(points={{6.66134e-16,
          -167},{0,-167},{0,-109.2},{-1.33227e-15,-109.2}}, color={0,0,127}));
  connect(heaPum.port_b1, pumHeaPum.port_a) annotation (Line(points={{14,-130},{
          -10,-130},{-50,-130},{-50,-110}}, color={0,127,255}));
  connect(booToReaPum.y, pumHeaPum.m_flow_in) annotation (Line(points={{-99,-100},
          {-62,-100},{-62,-100.2}}, color={0,0,127}));
  connect(booToReaPum.y, pumHeaPumSou.m_flow_in) annotation (Line(points={{-99,-100},
          {-80,-100},{-80,-178.2},{-10,-178.2}}, color={0,0,127}));
  connect(not2.y, and2.u1) annotation (Line(points={{-139,-50},{24.8,-50},{24.8,
          -50}}, color={255,0,255}));
  connect(not2.y, booToReaPum.u) annotation (Line(points={{-139,-50},{-130,-50},
          {-130,-100},{-122,-100}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
Example that simulates one room equipped with a radiator. Hot water is produced
by a <i>24</i> kW nominal capacity heat pump. The source side water temperature to the
heat pump is constant at <i>10</i>&deg;C.
</p>
<p>
The heat pump is turned on when the room temperature falls below
<i>19</i>&deg;C and turned
off when the room temperature rises above <i>21</i>&deg;C.
</p>
</html>", revisions="<html>
<ul>
<li>
March 3, 2017, by Michael Wetter:<br/>
Changed mass flow test to use a hysteresis as a threshold test
can cause chattering.
</li>
<li>
January 27, 2017, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-240,-220},{100,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/ScrollWaterToWater_OneRoomRadiator.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-08));
end ScrollWaterToWater_OneRoomRadiator;
