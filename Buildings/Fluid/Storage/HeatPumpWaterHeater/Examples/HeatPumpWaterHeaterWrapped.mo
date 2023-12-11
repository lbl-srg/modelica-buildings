within Buildings.Fluid.Storage.HeatPumpWaterHeater.Examples;
model HeatPumpWaterHeaterWrapped
    extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.Air;
  package MediumTan = Buildings.Media.Water "Medium in the tank";

  parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil
    datCoi(sta={
        Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=0.2279),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_II())},
                nSta=1) "Coil data"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));

  Modelica.Blocks.Sources.TimeTable P(table=[0,300000; 4200,300000; 4200,305000;
        7200,305000; 7200,310000; 10800,310000; 10800,305000])
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Modelica.Blocks.Sources.TimeTable TWat(table=[0,273.15 + 40; 3600,273.15 + 40;
        3600,273.15 + 20; 7200,273.15 + 20]) "Water temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    final duration=600,
    final startTime=2400,
    final height=-5,
    final offset=273.15 + 23)
    "Temperature"
    annotation (Placement(transformation(extent={{-100,54},{-80,74}})));
  Modelica.Blocks.Logical.Not not1
    "Not block to negate control action of upper level control"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.Blocks.Logical.Hysteresis onOffHea(uLow=273.15 + 43.89 - 3.89, uHigh=
       273.15 + 43.89) "On/off controller for heat pump water heater"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));

  Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterWrapped
    heaPumWatHeaWra(
    mAir_flow_nominal=0.2279,
    mWat_flow_nominal=0.1,
    dpAir_nominal(displayUnit="Pa") = 65,
    VTan=0.287691,
    hTan=1.594,
    dIns=0.05,
    kIns=0.04,
    datCoi=datCoi,
    redeclare Buildings.Fluid.Storage.HeatPumpWaterHeater.Examples.Data.FanData
      fanPer) annotation (Placement(transformation(extent={{-14,-6},{8,12}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    p=300000 + 5000,
    T=273.15 + 50,
    redeclare package Medium = MediumTan,
    use_T_in=true,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,-14},
            {-40,6}})));

  Buildings.Fluid.FixedResistances.PressureDrop res_1(
    from_dp=true,
    redeclare package Medium = MediumTan,
    dp_nominal=5000,
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{28,-14},{48,6}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = MediumTan,
    T=273.15 + 20,
    use_p_in=true,
    p=300000,
    nPorts=1)
    annotation (Placement(transformation(extent={{82,-14},
            {62,6}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop1
    "Boundary condition for tank" annotation (Placement(transformation(extent={{-40,-66},
            {-28,-54}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid1
    "Boundary condition for tank" annotation (Placement(transformation(extent={{-40,-48},
            {-28,-36}})));
  Modelica.Blocks.Sources.Sine sine(
    f=1/86400,
    amplitude=10,
    offset=273.15 + 20)
    annotation (Placement(transformation(extent={{-74,-70},{-54,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumAir,
    p(displayUnit="Pa") = 101325,
    final use_T_in=true,
    final T=299.85,
    nPorts=1)
    "Source"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumAir,
    final p(displayUnit="Pa") = 101325,
    final nPorts=1,
    final T=303.15)
    "Sink"
    annotation (Placement(transformation(extent={{52,50},{32,70}})));

equation
  connect(TWat.y,sou_1. T_in) annotation (Line(
      points={{-79,0},{-62,0}},
      color={0,0,127}));
  connect(heaPumWatHeaWra.port_a2, res_1.port_a)
    annotation (Line(points={{8,-3.75},{18,-3.75},{18,-4},{28,-4}},
                                               color={0,127,255}));
  connect(P.y,sin_1. p_in) annotation (Line(
      points={{81,40},{92,40},{92,4},{84,4}},
      color={0,0,127}));
  connect(res_1.port_b, sin_1.ports[1])
    annotation (Line(points={{48,-4},{62,-4}}, color={0,127,255}));
  connect(sine.y,TBCSid1. T) annotation (Line(points={{-53,-60},{-47.5,-60},{-47.5,
          -42},{-41.2,-42}},     color={0,0,127}));
  connect(sine.y,TBCTop1. T) annotation (Line(points={{-53,-60},{-41.2,-60}},
        color={0,0,127}));
  connect(TEvaIn.y,sou. T_in) annotation (Line(
      points={{-79,64},{-62,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaPumWatHeaWra.port_b1, sin1.ports[1]) annotation (Line(points={{8,9.75},
          {16,9.75},{16,60},{32,60}},
                                   color={0,127,255}));
  connect(TBCSid1.port, heaPumWatHeaWra.heaPorSid1)
    annotation (Line(points={{-28,-42},{12,-42},{12,3},{3.6,3}},
                                                       color={191,0,0}));
  connect(TBCTop1.port, heaPumWatHeaWra.heaPorTop1) annotation (Line(points={{-28,-60},
          {-20,-60},{-20,11.775},{-3.22,11.775}},
                                               color={191,0,0}));
  connect(not1.u,onOffHea. y)
    annotation (Line(points={{58,-60},{51,-60}}, color={255,0,255}));
  connect(heaPumWatHeaWra.TWat, onOffHea.u) annotation (Line(points={{9.1,3},{
          16,3},{16,-60},{28,-60}},
                                 color={0,0,127}));
  connect(not1.y,heaPumWatHeaWra.on)  annotation (Line(points={{81,-60},{94,-60},
          {94,-26},{-28,-26},{-28,3},{-16.2,3}},           color={255,0,255}));
  connect(sou_1.ports[1], heaPumWatHeaWra.port_b2)
    annotation (Line(points={{-40,-4},{-28,-4},{-28,-3.75},{-14,-3.75}},
                                                 color={0,127,255}));
  connect(heaPumWatHeaWra.port_a1, sou.ports[1]) annotation (Line(points={{-14,
          9.75},{-28,9.75},{-28,60},{-40,60}},
                                      color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Storage/HeatPumpWaterHeater/Examples/HeatPumpWaterHeaterWrapped.mos"
        "Simulate and Plot"));
end HeatPumpWaterHeaterWrapped;
