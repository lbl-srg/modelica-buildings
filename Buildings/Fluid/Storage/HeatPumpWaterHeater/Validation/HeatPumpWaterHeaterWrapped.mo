within Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation;
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
          Q_flow_nominal=-2349.6,
          COP_nominal=2.4,
          SHR_nominal=0.981,
          m_flow_nominal=0.2279,
          TEvaIn_nominal=13.5 + 273.15,
          TConIn_nominal=48.89 + 273.15),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_II(
          capFunT={0.563,0.0437,0.000039,0.0055,-0.000148,-0.000145},
          capFunFF={1,0,0,0},
          EIRFunT={1.1332,0.063,-0.0000979,-0.00972,-0.0000214,-0.000686},
          EIRFunFF={1,0,0,0},
          TConInMax=333.15,
          TEvaInMin=280.35,
          TEvaInMax=322.04))},
                nSta=1) "Coil data"
    annotation (Placement(transformation(extent={{76,80},{96,100}})));

  parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WaterTankData
    datWT(
    hTan=1.59,
    dIns=0.05,
    kIns=0.04,
    nSeg=12,
    hSegBot=0.066416667,
    hSegTop=0.863416667)
    annotation (Placement(transformation(extent={{100,80},{120,100}})));

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
    datCoi=datCoi,
    datWT=datWT,
    redeclare Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.FanData fanPer)
    annotation (Placement(transformation(extent={{-14,-6},{8,12}})));

  Buildings.Fluid.FixedResistances.PressureDrop res_1(
    from_dp=true,
    redeclare package Medium = MediumTan,
    dp_nominal=5000,
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{38,-14},{58,6}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = MediumTan,
    T=273.15 + 20,
    nPorts=1)
    annotation (Placement(transformation(extent={{-90,-14},{-70,6}})));
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
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumAir,
    final p(displayUnit="Pa") = 101325,
    final nPorts=1,
    final T=303.15)
    "Sink"
    annotation (Placement(transformation(extent={{52,58},{32,78}})));

  Sensors.TemperatureTwoPort senTemOut(redeclare package Medium = MediumTan,
      m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{-56,-14},{-36,6}})));
  Sensors.TemperatureTwoPort senTemIn(redeclare package Medium = MediumTan,
      m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{14,-14},{34,6}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/DXSystems/Heating/AirSource/Validation/SingleSpeedHeating_OnDemandResistiveDefrost/DXCoilSystemAuto.dat"),

    final tableOnFile=true,
    final columns=2:18,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-152,60},{-132,80}})));
  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Sources.MassFlowSource_T                 boundary1(
    redeclare package Medium = Medium,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1)
    "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-80,58},{-60,78}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Sources.MassFlowSource_T                 boundary(
    redeclare package Medium = Medium,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1) "Mass flow source for DHW"
    annotation (Placement(transformation(extent={{98,-14},{78,6}})));
  Controls.OBC.CDL.Discrete.UnitDelay           TOutEPlu(final samplePeriod=
        3600)
    "Outlet temperature from EnergyPlus"
    annotation (Placement(transformation(extent={{78,40},{98,60}})));
  Modelica.Blocks.Math.Mean PMea(final f=1/3600)
    "Mean of power"
    annotation (Placement(transformation(extent={{112,20},{132,40}})));
equation
  connect(sine.y,TBCSid1. T) annotation (Line(points={{-53,-60},{-47.5,-60},{-47.5,
          -42},{-41.2,-42}},     color={0,0,127}));
  connect(sine.y,TBCTop1. T) annotation (Line(points={{-53,-60},{-41.2,-60}},
        color={0,0,127}));
  connect(heaPumWatHeaWra.port_b1, sin1.ports[1]) annotation (Line(points={{8,9.75},
          {16,9.75},{16,68},{32,68}},
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
  connect(senTemOut.port_b, heaPumWatHeaWra.port_b2) annotation (Line(points={{
          -36,-4},{-18,-4},{-18,-3.75},{-14,-3.75}}, color={0,127,255}));
  connect(senTemIn.port_b, res_1.port_a)
    annotation (Line(points={{34,-4},{38,-4}}, color={0,127,255}));
  connect(senTemIn.port_a, heaPumWatHeaWra.port_a2) annotation (Line(points={{
          14,-4},{12,-4},{12,-3.75},{8,-3.75}}, color={0,127,255}));
  connect(heaPumWatHeaWra.port_a1, boundary1.ports[1]) annotation (Line(points=
          {{-14,9.75},{-28,9.75},{-28,10},{-40,10},{-40,68},{-60,68}}, color={0,
          127,255}));
  connect(sin_1.ports[1], senTemOut.port_a)
    annotation (Line(points={{-70,-4},{-56,-4}}, color={0,127,255}));
  connect(res_1.port_b, boundary.ports[1])
    annotation (Line(points={{58,-4},{78,-4}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -100},{140,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{140,
            100}})),
    experiment(
      StopTime=10800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Storage/HeatPumpWaterHeater/Examples/HeatPumpWaterHeaterWrapped.mos"
        "Simulate and Plot"));
end HeatPumpWaterHeaterWrapped;
