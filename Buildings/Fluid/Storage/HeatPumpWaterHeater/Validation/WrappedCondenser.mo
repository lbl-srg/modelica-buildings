within Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation;
model WrappedCondenser
  "Validation model for heat pump water heater"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air
    "Medium representing outdoor air";

  package MediumTan = Buildings.Media.Water
    "Medium in the tank";

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
                nSta=1)
                "Coil data"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Storage/HeatPumpWaterHeater/Validation/WrappedCondenser.dat"),
    final tableOnFile=true,
    final columns=2:24,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-130,70},{-110,90}})));

  Modelica.Blocks.Math.RealToBoolean realToBoolean(
    threshold=0.2)
    "Convert real to boolean"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Buildings.Fluid.Storage.HeatPumpWaterHeater.WrappedCondenser heaPumWatHeaWra(
    tan(vol(each T_start=322.14)),
    mAir_flow_nominal=0.2279,
    mWat_flow_nominal=0.1,
    dpAir_nominal(displayUnit="Pa") = 65,
    datHPWH(
      redeclare
        Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation.Data.WaterTank
        datTanWat,
      redeclare Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation.Data.Fan
        datFan,
      datCoi=datCoi))
    "Heat pump water heater"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop res(
    from_dp=true,
    redeclare package Medium = MediumTan,
    dp_nominal=5000,
    m_flow_nominal=0.1)
    "Resistance in the water loop"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = MediumTan,
    T=273.15 + 20,
    nPorts=1)
    "Sink of water"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTemTop
    "Temperature boundary condition for top of tank"
    annotation (Placement(transformation(extent={{-50,-100},{-30,-80}})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTemSid
    "Temperature boundary condition for side of tank"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumAir,
    final p(displayUnit="Pa"),
    final nPorts=1) "Sink of air"
    annotation (Placement(transformation(extent={{50,20},{30,40}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = MediumTan,
    m_flow_nominal=0.1)
      "Water outlet temperature sensor"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = MediumTan,
    m_flow_nominal=0.1)
    "Water inlet temperature sensor"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.Fluid.Sources.Boundary_pT bouAir(
    redeclare package Medium = MediumAir,
    final use_Xi_in=true,
    final use_T_in=true,
    nPorts=1)
    "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));

  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = MediumTan,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1)
    "Mass flow source for DHW"
    annotation (Placement(transformation(extent={{110,-40},{90,-20}})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTemBot
    "Temperature boundary condition for bottom of tank"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));

  Buildings.Utilities.IO.BCVTB.From_degC TOut_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));

  Buildings.Utilities.IO.BCVTB.From_degC TWat_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{150,-40},{130,-20}})));


equation
  connect(heaPumWatHeaWra.port_b1, sin.ports[1])
    annotation (Line(points={{10,6},{20,6},{20,30},{30,30}},  color={0,127,255}));

  connect(preTemSid.port, heaPumWatHeaWra.heaPorSid)
    annotation (Line(points={{-30,-60},{6,-60},{6,0}},   color={191,0,0}));

  connect(senTemIn.port_b, res.port_a)
    annotation (Line(points={{50,-30},{60,-30}},
                                               color={0,127,255}));

  connect(senTemIn.port_a, heaPumWatHeaWra.port_a2)
    annotation (Line(points={{30,-30},{20,-30},{20,-6},{10,-6}},
                                              color={0,127,255}));

  connect(sin_1.ports[1], senTemOut.port_a)
    annotation (Line(points={{-70,-30},{-50,-30}},
                                                 color={0,127,255}));

  connect(res.port_b, boundary.ports[1])
    annotation (Line(points={{80,-30},{90,-30}},
                                               color={0,127,255}));

  connect(heaPumWatHeaWra.port_a1, bouAir.ports[1])
    annotation (Line(points={{-10,6},{-20,6},{-20,30},{-30,30}},
                                                            color={0,127,255}));

  connect(senTemOut.port_b, heaPumWatHeaWra.port_b2)
    annotation (Line(points={{-30,-30},{-20,-30},{-20,-6},{-10,-6}},
                                                 color={0,127,255}));

  connect(datRea.y[8], toTotAirIn.XiDry)
    annotation (Line(points={{-109,80},{-100,80},{-100,30},{-91,30}},     color={0,0,127}));

  connect(toTotAirIn.XiTotalAir, bouAir.Xi_in[1])
    annotation (Line(points={{-69,30},{-60,30},{-60,26},{-52,26}},
                                                 color={0,0,127}));

  connect(datRea.y[6], TEvaIn_K.Celsius)
    annotation (Line(points={{-109,80},{-100,80},{-100,59.6},{-92,59.6}},
                                                                      color={0,0,127}));

  connect(TEvaIn_K.Kelvin, bouAir.T_in)
    annotation (Line(points={{-69,59.8},{-69,60},{-60,60},{-60,34},{-52,34}},            color={0,0,127}));

  connect(preTemBot.port, heaPumWatHeaWra.heaPorBot) annotation (Line(points={{-30,
          -120},{0,-120},{0,-8}},                     color={191,0,0}));

  connect(datRea.y[3], boundary.m_flow_in)
    annotation (Line(points={{-109,80},{120,80},{120,-22},{112,-22}},
                                                                color={0,0,127}));

  connect(realToBoolean.y, heaPumWatHeaWra.on)
    annotation (Line(points={{-69,0},{-12,0}},                   color={255,0,255}));

  connect(realToBoolean.u, datRea.y[7])
    annotation (Line(points={{-92,0},{-100,0},{-100,80},{-109,80}}, color={0,0,127}));

  connect(TOut_K.Celsius, datRea.y[1])
    annotation (Line(points={{-92,-90.4},{-100,-90.4},{-100,80},{-109,80}},     color={0,0,127}));

  connect(TOut_K.Kelvin, preTemSid.T) annotation (Line(points={{-69,-90.2},{-60,
          -90.2},{-60,-60},{-52,-60}}, color={0,0,127}));

  connect(TOut_K.Kelvin, preTemTop.T) annotation (Line(points={{-69,-90.2},{-60,
          -90.2},{-60,-90},{-52,-90}}, color={0,0,127}));

  connect(TOut_K.Kelvin, preTemBot.T) annotation (Line(points={{-69,-90.2},{-60,
          -90.2},{-60,-120},{-52,-120}}, color={0,0,127}));

  connect(TWat_K.Kelvin, boundary.T_in)
    annotation (Line(points={{129,-30.2},{124,-30.2},{124,-30},{120,-30},{120,-26},
          {112,-26}},                                              color={0,0,127}));

  connect(TWat_K.Celsius, datRea.y[2])
    annotation (Line(points={{152,-30.4},{156,-30.4},{156,80},{-109,80}},color={0,0,127}));

  connect(preTemTop.port, heaPumWatHeaWra.heaPorTop) annotation (Line(points={{-30,-90},
          {-6,-90},{-6,20},{0,20},{0,8}},                          color={191,0,
          0}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
            Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},
            {160,100}})),
      experiment(
        StartTime=18316800,
        StopTime=19526400,
        Tolerance=1e-06,
        __Dymola_Algorithm="Cvode"),
      __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Storage/HeatPumpWaterHeater/Validation/WrappedCondenser.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
    <p>
    This model validates the model Buildings.Fluid.Storage.HeatPumpWaterHeater.WrappedCondenser. </p>
    <p>
    The EnergyPlus results were generated using the example file WaterHeaterHeatPumpWrappedCondenser.idf
    from EnergyPlus 9.6. The results were then used to set-up the boundary conditions
    for the model as well as the input signals.</p>
</html>", revisions="<html>
    <ul>
    <li>
    September 24, 2024 by Xing Lu, Karthik Devaprasad and Cerrina Mouchref:</br>
    First implementation.
    </li>
    </ul>
</html>"));
end WrappedCondenser;
