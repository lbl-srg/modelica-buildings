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
          Q_flow_nominal=-4500,
          COP_nominal=2.4,
          SHR_nominal=0.981,
          m_flow_nominal=0.2279,
          TEvaIn_nominal=13.5 + 273.15,
          TConIn_nominal=48.89 + 273.15),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.AirSource.Examples.PerformanceCurves.Curve_II(
          capFunT={0.563,0.0437,0.000039,0.0055,-0.000148,-0.000145},
          capFunFF={1,0,0,0},
          EIRFunT={0.868453145646,-0.026843107274,0.000494875272,0.001441161396,
            0.000209142038,-0.000248411628},
          EIRFunFF={1,0,0,0},
          TConInMax=333.15,
          TEvaInMin=280.35,
          TEvaInMax=322.04))},
                nSta=1) "Coil data"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WaterTankData
    datWT(
    hTan=1.59,
    dIns=0.05,
    kIns=0.04,
    nSeg=12,
    hSegBot=0.066416667,
    hSegTop=0.863416667)
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterWrapped
    heaPumWatHeaWra(
    mAir_flow_nominal=0.2279,
    mWat_flow_nominal=0.1,
    dpAir_nominal(displayUnit="Pa") = 65,
    datCoi=datCoi,
    datWT=datWT,
    redeclare Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.FanData fanPer,
    tan1(vol(T_start=322.14)),
    overwrite(activate(y=false), uExt(y=TConCoi_K.Kelvin)))
    annotation (Placement(transformation(extent={{-32,-6},{-12,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop res_1(
    from_dp=true,
    redeclare package Medium = MediumTan,
    dp_nominal=5000,
    m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{20,-14},{40,6}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = MediumTan,
    T=273.15 + 20,
    nPorts=1)
    annotation (Placement(transformation(extent={{-108,-14},{-88,6}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop1
    "Boundary condition for tank" annotation (Placement(transformation(extent={{-80,-80},
            {-68,-68}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid1
    "Boundary condition for tank" annotation (Placement(transformation(extent={{-80,-62},
            {-68,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumAir,
    final p(displayUnit="Pa"),
    final nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{40,20},{20,40}})));

  Sensors.TemperatureTwoPort senTemOut(redeclare package Medium = MediumTan,
      m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{-74,-14},{-54,6}})));
  Sensors.TemperatureTwoPort senTemIn(redeclare package Medium = MediumTan,
      m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{-4,-14},{16,6}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Storage/HeatPumpWaterHeater/Validation/HeatPumpWaterHeaterWrapped/WaterHeaterHeatPumpWrappedCondenser.dat"),
    final tableOnFile=true,
    final columns=2:31,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,76},{-80,96}})));
  Sources.Boundary_pT      bouAir(
    redeclare package Medium = MediumAir,
    final use_Xi_in=true,
    final use_T_in=true,
    nPorts=1) "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-68,30},{-48,50}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{-110,26},{-90,46}})));
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = MediumTan,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1) "Mass flow source for DHW"
    annotation (Placement(transformation(extent={{70,-14},{50,6}})));
  Controls.OBC.CDL.Discrete.UnitDelay PCoiEPlu(final samplePeriod=
        3600) "Heat pump water heater power consumption from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Modelica.Blocks.Math.Mean PMea(final f=1/3600)
    "Mean of power"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  HeatTransfer.Sources.PrescribedTemperature TBCBot
    "Boundary condition for tank"
    annotation (Placement(transformation(extent={{-80,-100},{-68,-88}})));
  Controls.OBC.CDL.Discrete.UnitDelay TTanOutEPlu(final samplePeriod=3600)
    "Water tank temperature from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=0.2)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Utilities.IO.BCVTB.From_degC TOut_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-110,-86},{-90,-66}})));
  Buildings.Utilities.IO.BCVTB.From_degC TWat_K "Converts degC to K"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Buildings.Utilities.IO.BCVTB.From_degC TConCoi_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
equation
  connect(heaPumWatHeaWra.port_b1, sin1.ports[1]) annotation (Line(points={{-12,8},
          {0,8},{0,30},{20,30}},   color={0,127,255}));
  connect(TBCSid1.port, heaPumWatHeaWra.heaPorSid1)
    annotation (Line(points={{-68,-56},{-6,-56},{-6,2},{-16,2}},
                                                       color={191,0,0}));
  connect(TBCTop1.port, heaPumWatHeaWra.heaPorTop1) annotation (Line(points={{-68,-74},
          {-38,-74},{-38,10},{-22,10}},        color={191,0,0}));
  connect(senTemIn.port_b, res_1.port_a)
    annotation (Line(points={{16,-4},{20,-4}}, color={0,127,255}));
  connect(senTemIn.port_a, heaPumWatHeaWra.port_a2) annotation (Line(points={{-4,-4},
          {-12,-4}},                            color={0,127,255}));
  connect(sin_1.ports[1], senTemOut.port_a)
    annotation (Line(points={{-88,-4},{-74,-4}}, color={0,127,255}));
  connect(res_1.port_b, boundary.ports[1])
    annotation (Line(points={{40,-4},{50,-4}}, color={0,127,255}));
  connect(heaPumWatHeaWra.port_a1, bouAir.ports[1]) annotation (Line(points={{-32,8},
          {-40,8},{-40,40},{-48,40}},        color={0,127,255}));
  connect(senTemOut.port_b, heaPumWatHeaWra.port_b2)
    annotation (Line(points={{-54,-4},{-32,-4}}, color={0,127,255}));
  connect(datRea.y[8], toTotAirIn.XiDry) annotation (Line(points={{-119,70},{
          -114,70},{-114,36},{-111,36}}, color={0,0,127}));
  connect(toTotAirIn.XiTotalAir, bouAir.Xi_in[1])
    annotation (Line(points={{-89,36},{-70,36}}, color={0,0,127}));
  connect(datRea.y[6], TEvaIn_K.Celsius) annotation (Line(points={{-119,70},{
          -108,70},{-108,85.6},{-102,85.6}}, color={0,0,127}));
  connect(TEvaIn_K.Kelvin, bouAir.T_in) annotation (Line(points={{-79,85.8},{
          -80,85.8},{-80,86},{-76,86},{-76,44},{-70,44}}, color={0,0,127}));
  connect(TBCBot.port, heaPumWatHeaWra.heaPorBot1) annotation (Line(points={{
          -68,-94},{-36,-94},{-36,-6},{-22,-6}}, color={191,0,0}));
  connect(datRea.y[3], boundary.m_flow_in) annotation (Line(points={{-119,70},{
          80,70},{80,4},{72,4}}, color={0,0,127}));
  connect(heaPumWatHeaWra.P, PMea.u) annotation (Line(points={{-11,-2},{-6,-2},
          {-6,50},{98,50}}, color={0,0,127}));
  connect(PCoiEPlu.u, datRea.y[23]) annotation (Line(points={{98,-10},{90,-10},
          {90,70},{-119,70}}, color={0,0,127}));
  connect(TTanOutEPlu.u, datRea.y[11]) annotation (Line(points={{98,-50},{88,
          -50},{88,70},{-119,70}}, color={0,0,127}));
  connect(realToBoolean.y, heaPumWatHeaWra.on) annotation (Line(points={{-79,
          -30},{-46,-30},{-46,2},{-34,2}}, color={255,0,255}));
  connect(realToBoolean.u, datRea.y[7]) annotation (Line(points={{-102,-30},{
          -116,-30},{-116,70},{-119,70}}, color={0,0,127}));
  connect(TOut_K.Celsius, datRea.y[1]) annotation (Line(points={{-112,-76.4},{
          -112,-76},{-116,-76},{-116,70},{-119,70}}, color={0,0,127}));
  connect(TOut_K.Kelvin, TBCSid1.T) annotation (Line(points={{-89,-76.2},{-89,
          -76},{-86,-76},{-86,-56},{-81.2,-56}}, color={0,0,127}));
  connect(TOut_K.Kelvin, TBCTop1.T) annotation (Line(points={{-89,-76.2},{-85.5,
          -76.2},{-85.5,-74},{-81.2,-74}}, color={0,0,127}));
  connect(TOut_K.Kelvin, TBCBot.T) annotation (Line(points={{-89,-76.2},{-90,
          -76.2},{-90,-76},{-86,-76},{-86,-94},{-81.2,-94}}, color={0,0,127}));
  connect(TWat_K.Kelvin, boundary.T_in) annotation (Line(points={{61,89.8},{82,
          89.8},{82,0},{72,0}}, color={0,0,127}));
  connect(TWat_K.Celsius, datRea.y[2]) annotation (Line(points={{38,89.6},{36,
          89.6},{36,90},{30,90},{30,70},{-119,70}}, color={0,0,127}));
  connect(datRea.y[28], TConCoi_K.Celsius) annotation (Line(points={{-119,70},{-114,
          70},{-114,120},{-102,120},{-102,119.6}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{140,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,
            100}})),
    experiment(
      StartTime=18316800,
      StopTime=19526400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Storage/HeatPumpWaterHeater/Validation/HeatPumpWaterHeaterWrapped.mos"
        "Simulate and Plot", file="Resources/Scripts/Dymola/Fluid/Storage/HeatPumpWaterHeater/Validation/Debug.mos"
        "Debug"));
end HeatPumpWaterHeaterWrapped;
