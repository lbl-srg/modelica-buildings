within Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation;
model HeatPumpWaterHeaterPumped
  "Validation model for heat pump water heater"
    extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.Air;
  package MediumTan = Buildings.Media.Water "Medium in the tank";

  parameter Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.DXCoil
    datCoi(sta={
        Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-4500,
          COP_nominal=2.4,
          SHR_nominal=0.981,
          m_flow_nominal=0.2279,
          TEvaIn_nominal=13.5 + 273.15,
          TConIn_nominal=48.89 + 273.15,
          mCon_flow_nominal=0.28),
        perCur=
          Buildings.Fluid.DXSystems.Cooling.WaterSource.Examples.PerformanceCurves.Curve_I(
          capFunT={0.563,0.0437,0.000039,0.0055,-0.000148,-0.000145},
          capFunFF={1,0,0,0},
          EIRFunT={0.868453145646,-0.026843107274,0.000494875272,0.001441161396,
            0.000209142038,-0.000248411628},
          EIRFunFF={1,0,0,0},
          TConInMax=333.15,
          TEvaInMin=280.35,
          TEvaInMax=322.04))},
                nSta=1) "Coil data"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));


  parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WaterHeaterData
    datWT(
    hTan=1.594,
    VTan=0.287691,
    dIns=0.05,
    kIns=0.03939,
    nSeg=12,
    hSegBot=0.066416667,
    hSegTop=0.863416667) "Heat pump water heater data"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/Storage/HeatPumpWaterHeater/Validation/HeatPumpWaterHeaterPumped/WaterHeaterHeatPumpStratifiedTank.dat"),
    final tableOnFile=true,
    final columns=2:31,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=0.2)
    "Convert real to boolean"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));

  Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterPumped
    heaPumWatHeaPum(
    mAir_flow_nominal=0.2279,
    mWat_flow_nominal=0.1,
    dpAir_nominal(displayUnit="Pa") = 65,
    datCoi=datCoi,
    datWT=datWT,
    redeclare Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.FanData fanPer,
    dpCon_nominal(displayUnit="Pa") = 45000,
    Q_flow_nominal=4500,
    mHex_flow_nominal=0.3)
    "Heat pump water heater"
    annotation (Placement(transformation(extent={{0,-6},{20,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    from_dp=true,
    redeclare package Medium = MediumTan,
    dp_nominal=5000,
    m_flow_nominal=0.1) "Resistance in the water loop"
    annotation (Placement(transformation(extent={{50,-14},{70,6}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = MediumTan,
    T=273.15 + 20,
    nPorts=1) "Sink of water"
    annotation (Placement(transformation(extent={{-70,-14},{-50,6}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop
    "Boundary condition for top of tank"
    annotation (Placement(transformation(extent={{-48,-74},{-36,-62}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid
    "Boundary condition for side of tank"
    annotation (Placement(transformation(extent={{-48,-56},{-36,-44}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumAir,
    final p(displayUnit="Pa"),
    final nPorts=1) "Sink of air"
    annotation (Placement(transformation(extent={{70,14},{50,34}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(redeclare package Medium = MediumTan,
      m_flow_nominal=0.1) "Water outlet temperature sensor"
    annotation (Placement(transformation(extent={{-42,-14},{-22,6}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(redeclare package Medium = MediumTan,
      m_flow_nominal=0.1) "Water inlet temperature sensor"
    annotation (Placement(transformation(extent={{28,-14},{48,6}})));
  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Buildings.Fluid.Sources.Boundary_pT bouAir(
    redeclare package Medium = MediumAir,
    final use_Xi_in=true,
    final use_T_in=true,
    nPorts=1) "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-36,14},{-16,34}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = MediumTan,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1) "Mass flow source for DHW"
    annotation (Placement(transformation(extent={{100,-14},{80,6}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCBot
    "Boundary condition for bottom of tank"
    annotation (Placement(transformation(extent={{-48,-94},{-36,-82}})));
  Buildings.Utilities.IO.BCVTB.From_degC TOut_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-78,-80},{-58,-60}})));
  Buildings.Utilities.IO.BCVTB.From_degC TWat_K "Converts degC to K"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));

equation
  connect(heaPumWatHeaPum.port_b1, sin.ports[1]) annotation (Line(points={{20,8},{
          32,8},{32,24},{50,24}},  color={0,127,255}));
  connect(TBCSid.port,heaPumWatHeaPum. heaPorSid) annotation (Line(points={{-36,-50},
          {16,-50},{16,2}},            color={191,0,0}));
  connect(TBCTop.port,heaPumWatHeaPum. heaPorTop) annotation (Line(points={{-36,-68},
          {-6,-68},{-6,10},{10,10}},       color={191,0,0}));
  connect(senTemIn.port_b, res.port_a)
    annotation (Line(points={{48,-4},{50,-4}}, color={0,127,255}));
  connect(senTemIn.port_a,heaPumWatHeaPum. port_a2) annotation (Line(points={{28,-4},
          {20,-4}},                             color={0,127,255}));
  connect(sin_1.ports[1], senTemOut.port_a)
    annotation (Line(points={{-50,-4},{-42,-4}}, color={0,127,255}));
  connect(res.port_b, boundary.ports[1])
    annotation (Line(points={{70,-4},{80,-4}}, color={0,127,255}));
  connect(heaPumWatHeaPum.port_a1, bouAir.ports[1]) annotation (Line(points={{0,8},{
          -8,8},{-8,24},{-16,24}},           color={0,127,255}));
  connect(senTemOut.port_b,heaPumWatHeaPum. port_b2)
    annotation (Line(points={{-22,-4},{0,-4}},   color={0,127,255}));
  connect(datRea.y[8], toTotAirIn.XiDry) annotation (Line(points={{-89,70},{-82,
          70},{-82,20},{-71,20}},        color={0,0,127}));
  connect(toTotAirIn.XiTotalAir, bouAir.Xi_in[1])
    annotation (Line(points={{-49,20},{-38,20}}, color={0,0,127}));
  connect(datRea.y[6], TEvaIn_K.Celsius) annotation (Line(points={{-89,70},{-80,
          70},{-80,49.6},{-72,49.6}},        color={0,0,127}));
  connect(TEvaIn_K.Kelvin, bouAir.T_in) annotation (Line(points={{-49,49.8},{
          -48,49.8},{-48,50},{-44,50},{-44,28},{-38,28}}, color={0,0,127}));
  connect(TBCBot.port,heaPumWatHeaPum. heaPorBot) annotation (Line(points={{-36,-88},
          {-4,-88},{-4,-6},{10,-6}},       color={191,0,0}));
  connect(datRea.y[3], boundary.m_flow_in) annotation (Line(points={{-89,70},{
          110,70},{110,4},{102,4}},
                                 color={0,0,127}));
  connect(realToBoolean.y,heaPumWatHeaPum. on) annotation (Line(points={{-49,-30},
          {-14,-30},{-14,2},{-2,2}},       color={255,0,255}));
  connect(realToBoolean.u, datRea.y[7]) annotation (Line(points={{-72,-30},{-84,
          -30},{-84,70},{-89,70}},        color={0,0,127}));
  connect(TOut_K.Celsius, datRea.y[1]) annotation (Line(points={{-80,-70.4},{
          -80,-70},{-84,-70},{-84,70},{-89,70}},     color={0,0,127}));
  connect(TOut_K.Kelvin, TBCSid.T) annotation (Line(points={{-57,-70.2},{-58,
          -70.2},{-58,-70},{-54,-70},{-54,-50},{-49.2,-50}},
                                            color={0,0,127}));
  connect(TOut_K.Kelvin, TBCTop.T) annotation (Line(points={{-57,-70.2},{-54,
          -70.2},{-54,-68},{-49.2,-68}},
                                    color={0,0,127}));
  connect(TOut_K.Kelvin, TBCBot.T) annotation (Line(points={{-57,-70.2},{-58,
          -70.2},{-58,-70},{-54,-70},{-54,-88},{-49.2,-88}}, color={0,0,127}));
  connect(TWat_K.Kelvin, boundary.T_in) annotation (Line(points={{91,49.8},{112,
          49.8},{112,0},{102,0}},
                                color={0,0,127}));
  connect(TWat_K.Celsius, datRea.y[2]) annotation (Line(points={{68,49.6},{68,
          50},{62,50},{62,70},{-89,70}},            color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{120,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,
            100}})),
    experiment(
      StartTime=18316800,
      StopTime=19526400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Storage/HeatPumpWaterHeater/Validation/HeatPumpWaterHeaterPumped.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This model validates the model Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterPumped. </p>
<p>The EnergyPlus results were generated using the example file WaterHeaterHeatPumpStratifiedTank.idf from EnergyPlus 9.6. The results were then used to set-up the boundary conditions for the model as well as the input signals.</p>
</html>"));
end HeatPumpWaterHeaterPumped;
