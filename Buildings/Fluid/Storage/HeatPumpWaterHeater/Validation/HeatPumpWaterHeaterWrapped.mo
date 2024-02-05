within Buildings.Fluid.Storage.HeatPumpWaterHeater.Validation;
model HeatPumpWaterHeaterWrapped "Validation model for heat pump water heater"
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
    annotation (Placement(transformation(extent={{-18,80},{2,100}})));
  parameter Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.WaterHeaterData
    datWT(
    hTan=1.594,
    VTan=0.287691,
    dIns=0.05,
    kIns=0.03939,
    nSeg=12,
    hSegBot=0.066416667,
    hSegTop=0.863416667) "Heat pump water heater data"
    annotation (Placement(transformation(extent={{22,80},{42,100}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Storage/HeatPumpWaterHeater/Validation/HeatPumpWaterHeaterWrapped/WaterHeaterHeatPumpWrappedCondenser.dat"),
    final tableOnFile=true,
    final columns=2:31,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-118,60},{-98,80}})));
  Modelica.Blocks.Math.Mean PMea(final f=1/3600)
    "Mean of power"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=0.2)
    "Convert real to boolean"
    annotation (Placement(transformation(extent={{-80,-38},{-60,-18}})));

  Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterWrapped
    heaPumWatHeaWra(
    tan(vol(each T_start=322.14)),
    mAir_flow_nominal=0.2279,
    mWat_flow_nominal=0.1,
    dpAir_nominal(displayUnit="Pa") = 65,
    datCoi=datCoi,
    datWT=datWT,
    redeclare Buildings.Fluid.Storage.HeatPumpWaterHeater.Data.FanData fanPer)
    "Heat pump water heater"
    annotation (Placement(transformation(extent={{-10,-6},{10,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    from_dp=true,
    redeclare package Medium = MediumTan,
    dp_nominal=5000,
    m_flow_nominal=0.1) "Resistance in the water loop"
    annotation (Placement(transformation(extent={{42,-14},{62,6}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
    redeclare package Medium = MediumTan,
    T=273.15 + 20,
    nPorts=1) "Sink of water"
    annotation (Placement(transformation(extent={{-122,-14},{-102,6}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCTop
    "Boundary condition for top of tank"
    annotation (Placement(transformation(extent={{-58,-80},{-46,-68}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCSid
    "Boundary condition for side of tank"
    annotation (Placement(transformation(extent={{-58,-62},{-46,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumAir,
    final p(displayUnit="Pa"),
    final nPorts=1) "Sink of air"
    annotation (Placement(transformation(extent={{60,14},{40,34}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(redeclare package Medium
      =                                                                           MediumTan,
      m_flow_nominal=0.1) "Water outlet temperature sensor"
    annotation (Placement(transformation(extent={{-52,-14},{-32,6}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(redeclare package Medium
      =                                                                          MediumTan,
      m_flow_nominal=0.1) "Water inlet temperature sensor"
    annotation (Placement(transformation(extent={{18,-14},{38,6}})));
  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.Sources.Boundary_pT bouAir(
    redeclare package Medium = MediumAir,
    final use_Xi_in=true,
    final use_T_in=true,
    nPorts=1) "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-46,14},{-26,34}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = MediumTan,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1) "Mass flow source for DHW"
    annotation (Placement(transformation(extent={{90,-14},{70,6}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay PCoiEPlu(final samplePeriod=
        3600) "Heat pump water heater power consumption from EnergyPlus"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TBCBot
    "Boundary condition for bottom of tank"
    annotation (Placement(transformation(extent={{-58,-100},{-46,-88}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TTanOutEPlu(final samplePeriod=3600)
    "Water tank temperature from EnergyPlus"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Buildings.Utilities.IO.BCVTB.From_degC TOut_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-88,-86},{-68,-66}})));
  Buildings.Utilities.IO.BCVTB.From_degC TWat_K "Converts degC to K"
    annotation (Placement(transformation(extent={{62,80},{82,100}})));
  Buildings.Utilities.IO.BCVTB.From_degC TConCoi_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

equation
  connect(heaPumWatHeaWra.port_b1, sin.ports[1]) annotation (Line(points={{10,8},
          {22,8},{22,24},{40,24}}, color={0,127,255}));
  connect(TBCSid.port, heaPumWatHeaWra.heaPorSid) annotation (Line(points={{-46,-56},
          {8,-56},{8,2},{6,2}},        color={191,0,0}));
  connect(TBCTop.port, heaPumWatHeaWra.heaPorTop) annotation (Line(points={{-46,
          -74},{-16,-74},{-16,10},{0,10}}, color={191,0,0}));
  connect(senTemIn.port_b, res.port_a)
    annotation (Line(points={{38,-4},{42,-4}}, color={0,127,255}));
  connect(senTemIn.port_a, heaPumWatHeaWra.port_a2) annotation (Line(points={{18,-4},
          {10,-4}},                             color={0,127,255}));
  connect(sin_1.ports[1], senTemOut.port_a)
    annotation (Line(points={{-102,-4},{-52,-4}},color={0,127,255}));
  connect(res.port_b, boundary.ports[1])
    annotation (Line(points={{62,-4},{70,-4}}, color={0,127,255}));
  connect(heaPumWatHeaWra.port_a1, bouAir.ports[1]) annotation (Line(points={{-10,8},
          {-18,8},{-18,24},{-26,24}},        color={0,127,255}));
  connect(senTemOut.port_b, heaPumWatHeaWra.port_b2)
    annotation (Line(points={{-32,-4},{-10,-4}}, color={0,127,255}));
  connect(datRea.y[8], toTotAirIn.XiDry) annotation (Line(points={{-97,70},{-92,
          70},{-92,20},{-81,20}},        color={0,0,127}));
  connect(toTotAirIn.XiTotalAir, bouAir.Xi_in[1])
    annotation (Line(points={{-59,20},{-48,20}}, color={0,0,127}));
  connect(datRea.y[6], TEvaIn_K.Celsius) annotation (Line(points={{-97,70},{-86,
          70},{-86,49.6},{-82,49.6}},        color={0,0,127}));
  connect(TEvaIn_K.Kelvin, bouAir.T_in) annotation (Line(points={{-59,49.8},{
          -58,49.8},{-58,50},{-54,50},{-54,28},{-48,28}}, color={0,0,127}));
  connect(TBCBot.port, heaPumWatHeaWra.heaPorBot) annotation (Line(points={{-46,
          -94},{-14,-94},{-14,-6},{0,-6}}, color={191,0,0}));
  connect(datRea.y[3], boundary.m_flow_in) annotation (Line(points={{-97,70},{
          102,70},{102,4},{92,4}},
                                 color={0,0,127}));
  connect(heaPumWatHeaWra.P, PMea.u) annotation (Line(points={{11,-2},{16,-2},{
          16,50},{118,50}}, color={0,0,127}));
  connect(PCoiEPlu.u, datRea.y[23]) annotation (Line(points={{118,-10},{112,-10},
          {112,70},{-97,70}}, color={0,0,127}));
  connect(TTanOutEPlu.u, datRea.y[11]) annotation (Line(points={{118,-50},{110,
          -50},{110,70},{-97,70}}, color={0,0,127}));
  connect(realToBoolean.y, heaPumWatHeaWra.on) annotation (Line(points={{-59,-28},
          {-24,-28},{-24,2},{-12,2}},      color={255,0,255}));
  connect(realToBoolean.u, datRea.y[7]) annotation (Line(points={{-82,-28},{-94,
          -28},{-94,70},{-97,70}},        color={0,0,127}));
  connect(TOut_K.Celsius, datRea.y[1]) annotation (Line(points={{-90,-76.4},{
          -90,-76},{-94,-76},{-94,70},{-97,70}},     color={0,0,127}));
  connect(TOut_K.Kelvin, TBCSid.T) annotation (Line(points={{-67,-76.2},{-67,-76},
          {-64,-76},{-64,-56},{-59.2,-56}}, color={0,0,127}));
  connect(TOut_K.Kelvin, TBCTop.T) annotation (Line(points={{-67,-76.2},{-63.5,-76.2},
          {-63.5,-74},{-59.2,-74}}, color={0,0,127}));
  connect(TOut_K.Kelvin, TBCBot.T) annotation (Line(points={{-67,-76.2},{-68,
          -76.2},{-68,-76},{-64,-76},{-64,-94},{-59.2,-94}}, color={0,0,127}));
  connect(TWat_K.Kelvin, boundary.T_in) annotation (Line(points={{83,89.8},{104,
          89.8},{104,0},{92,0}},color={0,0,127}));
  connect(TWat_K.Celsius, datRea.y[2]) annotation (Line(points={{60,89.6},{58,
          89.6},{58,90},{52,90},{52,70},{-97,70}},  color={0,0,127}));
  connect(datRea.y[28], TConCoi_K.Celsius) annotation (Line(points={{-97,70},{
          -92,70},{-92,90},{-82,90},{-82,89.6}},   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{160,
            100}})),
    experiment(
      StartTime=18316800,
      StopTime=19526400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Storage/HeatPumpWaterHeater/Validation/HeatPumpWaterHeaterWrapped.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>This model validates the model Buildings.Fluid.Storage.HeatPumpWaterHeater.HeatPumpWaterHeaterWrapped. </p>
<p>The EnergyPlus results were generated using the example file WaterHeaterHeatPumpWrappedCondenser.idf from EnergyPlus 9.6. The results were then used to set-up the boundary conditions for the model as well as the input signals.</p>
</html>"));
end HeatPumpWaterHeaterWrapped;
