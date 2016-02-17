within Buildings.Fluid.HeatExchangers.ActiveBeams.Examples;
model ActiveBeam
  import Buildings;
  extends Modelica.Icons.Example;

  Buildings.Fluid.Sources.FixedBoundary bou(redeclare package Medium =
        Buildings.Media.Air, nPorts=1)
    annotation (Placement(transformation(extent={{-82,-32},{-62,-12}})));
  Buildings.Fluid.Sources.FixedBoundary bou1(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{80,24},{60,44}})));
  Buildings.Fluid.Sources.MassFlowSource_T SourceAir(
    redeclare package Medium = Buildings.Media.Air,
    nPorts=1,
    m_flow=0.0792,
    use_m_flow_in=true,
    T=285.85) annotation (Placement(transformation(extent={{56,-42},{36,-22}})));
  Buildings.Fluid.Sources.MassFlowSource_T SourceWater(
    redeclare package Medium = Buildings.Media.Water,
    m_flow=0.094,
    nPorts=1,
    use_m_flow_in=true,
    T=288.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-46,42})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         fixedTemperature
    annotation (Placement(transformation(extent={{-24,-48},{-12,-36}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water, m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{36,28},{48,40}})));

  Buildings.Fluid.Sources.FixedBoundary bou2(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{80,-2},{60,18}})));
  Buildings.Fluid.HeatExchangers.ActiveBeams.ActiveBeam beam(
    m1_flow_nominal=0.1,
    m2_flow_nominal=0.1,
    m3_flow_nominal=0.1,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.TroxDID632A_nozzleH_lenght6ft_coo
      per_coo,
    redeclare
      Buildings.Fluid.HeatExchangers.ActiveBeams.Data.TroxDID632A_nozzleH_lenght6ft_hea
      per_hea,
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Water,
    redeclare package Medium3 = Buildings.Media.Air,
    nBeams=1) annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
  Buildings.Fluid.Sources.FixedBoundary bou3(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{-82,-2},{-62,18}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=0.094,
    startTime=50,
    duration=100)
    annotation (Placement(transformation(extent={{-94,40},{-74,60}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    offset=0.0792,
    startTime=250,
    height=0.0226,
    duration=100)
    annotation (Placement(transformation(extent={{92,-34},{72,-14}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    offset=273.15 + 25,
    startTime=450,
    height=-5,
    duration=100)
    annotation (Placement(transformation(extent={{-56,-52},{-36,-32}})));
equation
  connect(senTem.port_b, bou1.ports[1]) annotation (Line(points={{48,34},{48,34},
          {60,34}},                         color={0,127,255}));
  connect(SourceWater.ports[1], beam.port_a1) annotation (Line(points={{-36,42},
          {-30,42},{-30,12},{-10,12}}, color={0,127,255}));
  connect(beam.port_b1, senTem.port_a) annotation (Line(points={{10,12},{26,12},
          {26,34},{36,34}}, color={0,127,255}));
  connect(bou.ports[1], beam.port_b3) annotation (Line(points={{-62,-22},{-42,
          -22},{-42,0},{-10,0}}, color={0,127,255}));
  connect(SourceAir.ports[1], beam.port_a3) annotation (Line(points={{36,-32},{
          26,-32},{26,0},{10,0}}, color={0,127,255}));
  connect(fixedTemperature.port, beam.port_b4) annotation (Line(points={{-12,-42},
          {-12,-42},{0,-42},{0,-2.8}},     color={191,0,0}));
  connect(ramp.y, SourceWater.m_flow_in)
    annotation (Line(points={{-73,50},{-56,50}}, color={0,0,127}));
  connect(SourceAir.m_flow_in, ramp1.y)
    annotation (Line(points={{56,-24},{71,-24}}, color={0,0,127}));
  connect(ramp2.y, fixedTemperature.T)
    annotation (Line(points={{-35,-42},{-25.2,-42}}, color={0,0,127}));
  connect(bou3.ports[1], beam.port_a2)
    annotation (Line(points={{-62,8},{-36,8},{-10,8}}, color={0,127,255}));
  connect(bou2.ports[1], beam.port_b2)
    annotation (Line(points={{60,8},{36,8},{10,8}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),experiment(StopTime=1000),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ActiveBeams/Examples/ActiveBeam.mos"
        "Simulate and plot"));
end ActiveBeam;
