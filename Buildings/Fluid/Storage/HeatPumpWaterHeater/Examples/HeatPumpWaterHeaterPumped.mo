within Buildings.Fluid.Storage.HeatPumpWaterHeater.Examples;
model HeatPumpWaterHeaterPumped
    extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.Air "Medium of the air";
  package MediumTan = Buildings.Media.Water "Medium in the tank";

   parameter
    Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.DXCoil
    datCoi(nSta=1, sta={
        Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4500,
          COP_nominal=2.4,
          SHR_nominal=0.981,
          m_flow_nominal=0.2279,
          TEvaIn_nominal=273.15 + 13.5,
          TConIn_nominal=273.15 + 48.89,
          mCon_flow_nominal=0.28),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.WaterSource.Examples.PerformanceCurves.Curve_I())})
                "Coil data"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WaterHeaterData
    datWT(
    hTan=1.59,
    dIns=0.05,
    kIns=0.04,
    nSeg=12,
    hSegBot=0.066416667,
    hSegTop=0.863416667) "Heat pump water heater data"
    annotation (Placement(transformation(extent={{70,80},{90,100}})));

  Modelica.Blocks.Sources.TimeTable P(table=[0,310000; 1800,310000; 1800,305000;
        7200,305000; 7200,310000; 10800,310000; 10800,310000])
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    final duration=600,
    final startTime=2400,
    final height=-5,
    final offset=273.15 + 23)
    "Evaporator temperature"
    annotation (Placement(transformation(extent={{-100,54},{-80,74}})));
  Modelica.Blocks.Logical.Not not1
    "Not block to negate control action of upper level control"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.Blocks.Logical.Hysteresis onOffHea(uLow=273.15 + 43.89 - 3.89, uHigh=
       273.15 + 43.89) "On/off controller for heat pump water heater"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));
    Modelica.Blocks.Sources.Sine sine(
    f=1/86400,
    amplitude=10,
    offset=273.15 + 20) "Sine signal for the outdoor temperature"
    annotation (Placement(transformation(extent={{-74,-70},{-54,-50}})));

  Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterPumped
    heaPumWatHeaPum(
    mAir_flow_nominal=0.2279,
    mWat_flow_nominal=0.1,
    dpAir_nominal(displayUnit="Pa") = 65,
    datCoi=datCoi,
    datWT=datWT,
    redeclare Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.FanData fanPer,
    Q_flow_nominal=4500,
    dpCon_nominal(displayUnit="Pa") = 45000,
    redeclare Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.PumpData pumPer,
    mHex_flow_nominal=0.3)
    "Heat pump water heater"
    annotation (Placement(transformation(extent={{-10,-6},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    p=300000 + 5000,
    redeclare package Medium = MediumTan,
    nPorts=1) "Sink of water"
    annotation (Placement(transformation(extent={{-70,-14},{-50,6}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    from_dp=true,
    redeclare package Medium = MediumTan,
    dp_nominal=5000,
    m_flow_nominal=0.1) "Resistance in the water loop"
    annotation (Placement(transformation(extent={{36,-14},{56,6}})));
  Buildings.Fluid.Sources.Boundary_pT souWat(
    redeclare package Medium = MediumTan,
    T=273.15 + 20,
    use_p_in=true,
    p=300000,
    nPorts=1) "Source of water"
    annotation (Placement(transformation(extent={{84,-14},{64,6}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop
    "Boundary condition for top of tank"
    annotation (Placement(transformation(extent={{-40,-66},{-28,-54}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid
    "Boundary condition for side of tank"
    annotation (Placement(transformation(extent={{-40,-48},{-28,-36}})));
  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = MediumAir,
    p(displayUnit="Pa") = 101325,
    final use_T_in=true,
    final T=299.85,
    nPorts=1) "Source of air"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir,
    final p(displayUnit="Pa") = 101325,
    final nPorts=1) "Sink of air"
    annotation (Placement(transformation(extent={{50,50},{30,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(redeclare package Medium
      =                                                                           MediumTan,
      m_flow_nominal=0.1) "Water outlet temperature sensor"
    annotation (Placement(transformation(extent={{-42,-14},{-22,6}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(redeclare package Medium
      =                                                                          MediumTan,
      m_flow_nominal=0.1) "Water inlet temperature sensor"
    annotation (Placement(transformation(extent={{14,-14},{34,6}})));

equation
  connect(P.y, souWat.p_in)
    annotation (Line(points={{81,40},{92,40},{92,4},{86,4}}, color={0,0,127}));
  connect(res.port_b, souWat.ports[1])
    annotation (Line(points={{56,-4},{64,-4}}, color={0,127,255}));
  connect(sine.y, TBCSid.T) annotation (Line(points={{-53,-60},{-47.5,-60},{-47.5,
          -42},{-41.2,-42}}, color={0,0,127}));
  connect(sine.y, TBCTop.T)
    annotation (Line(points={{-53,-60},{-41.2,-60}}, color={0,0,127}));
  connect(TEvaIn.y, souAir.T_in) annotation (Line(
      points={{-79,64},{-72,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaPumWatHeaPum.port_b1, sinAir.ports[1]) annotation (Line(points={{10,8},{
          16,8},{16,60},{30,60}},           color={0,127,255}));
  connect(TBCSid.port,heaPumWatHeaPum. heaPorSid) annotation (Line(points={{-28,-42},
          {6,-42},{6,2}},                color={191,0,0}));
  connect(TBCTop.port,heaPumWatHeaPum. heaPorTop) annotation (Line(points={{-28,-60},
          {-20,-60},{-20,10},{0,10}},       color={191,0,0}));
  connect(not1.u,onOffHea. y)
    annotation (Line(points={{58,-60},{51,-60}}, color={255,0,255}));
  connect(heaPumWatHeaPum.TWat, onOffHea.u) annotation (Line(points={{11,1},{16,
          1},{16,-60},{28,-60}}, color={0,0,127}));
  connect(not1.y,heaPumWatHeaPum.on)  annotation (Line(points={{81,-60},{94,-60},
          {94,-26},{-28,-26},{-28,2},{-12,2}},             color={255,0,255}));
  connect(heaPumWatHeaPum.port_a1, souAir.ports[1]) annotation (Line(points={{-10,8},
          {-28,8},{-28,60},{-50,60}},          color={0,127,255}));
  connect(senTemOut.port_b,heaPumWatHeaPum. port_b2) annotation (Line(points={{-22,-4},
          {-10,-4}},                                 color={0,127,255}));
  connect(senTemOut.port_a,sinWat. ports[1])
    annotation (Line(points={{-42,-4},{-50,-4}}, color={0,127,255}));
  connect(senTemIn.port_b, res.port_a)
    annotation (Line(points={{34,-4},{36,-4}}, color={0,127,255}));
  connect(senTemIn.port_a,heaPumWatHeaPum. port_a2) annotation (Line(points={{14,-4},
          {10,-4}},                             color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Storage/HeatPumpWaterHeater/Examples/HeatPumpWaterHeaterPumped.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This model tests a wrapped heat pump water heater. An on-off controller keeps the tank temperature in the range of 40-43.89 degC.</p>
</html>"));
end HeatPumpWaterHeaterPumped;
