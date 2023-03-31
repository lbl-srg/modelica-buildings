within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation;
model HeatingModeEPlusComparison
  "Validation model for heating mode operation of window AC system"
  extends Modelica.Icons.Example;
  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal";
  parameter HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil datCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-9365,
          COP_nominal=3.5,
          SHR_nominal=0.8,
          m_flow_nominal=1.2*0.56578),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.942587793,0.009543347,0.00068377,-0.011042676,0.000005249,-0.00000972},
          capFunFF={0.8,0.2,0},
          EIRFunT={0.342414409,0.034885008,-0.0006237,0.004977216,0.000437951,-0.000728028},
          EIRFunFF={1.1552,-0.1808,0.0256},
          TConInMin=273.15 + 10,
          TConInMax=273.15 + 46.11,
          TEvaInMin=273.15 + 12.78,
          TEvaInMax=273.15 + 23.89,
          ffMin=0.875,
          ffMax=1.125))}, nSta=1)
  annotation (Placement(transformation(extent={{60,106},{80,126}})));
  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = MediumA,
    final use_Xi_in=true,
    use_p_in=false,
    final p(displayUnit="Pa") = 101325 + dpAir_nominal + 50,
    final use_T_in=true,
    final T=279.15,
    final nPorts=1)
    "Source for zone air"
    annotation (Placement(transformation(extent={{50,26},{70,46}})));

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 101325,
    final nPorts=1)
    "Sink for zone air"
    annotation (Placement(transformation(extent={{52,-54},{72,-34}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(final k=0)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "./Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor weather data"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.SizingData
    PTHPSizing "Sizing parameters for PTHP"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.PackagedTerminalHeatPump
    PTHP(
    redeclare package MediumA = MediumA,
    mAirOut_flow_nominal=PTHPSizing.mAirOut_flow_nominal,
    mAir_flow_nominal=PTHPSizing.mAir_flow_nominal,
    dpAir_nominal(displayUnit="Pa") = dpAir_nominal,
    dpDX_nominal(displayUnit="Pa") = dpDX_nominal,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.FanData
      fanPer,
    datCooCoi=datCoi)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Sources.Pulse p(
    nperiod=1,
    offset=101325,
    width=100,
    period=864000,
    startTime=18144000,
    amplitude=1086) "Pressure"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=ModelicaServices.ExternalReferences.loadResource(
        "./Buildings/Resources/Data/Fluid/ZoneEquipment/WindowAC/WindACFanOnOff.dat"),
    final columns=2:20,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"FanCoilAutoSize_ConstantFlowVariableFan.idf\" energy plus example results"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Calculate mass fractions of constituents"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter totMasAir(final p=1)
    "Add 1 to humidity ratio value to find total mass of moist air"
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C(final p=273.15)
    "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  .Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(weaDat.weaBus, PTHP.weaBus) annotation (Line(
      points={{-60,120},{-15.8,120},{-15.8,18}},
      color={255,204,51},
      thickness=0.5));
  connect(damPos.y, PTHP.uEco) annotation (Line(points={{-98,0},{-40,0},{-40,18},
          {-22,18}}, color={0,0,127}));
  connect(souAir.ports[1], PTHP.port_Air_a2) annotation (Line(points={{70,36},{
          78,36},{78,4},{20,4}}, color={0,127,255}));
  connect(sinAir.ports[1], PTHP.port_Air_b2) annotation (Line(points={{72,-44},
          {78,-44},{78,-4},{20,-4}}, color={0,127,255}));
  connect(datRea.y[11], div1.u1) annotation (Line(points={{-99,40},{-82,40},{-82,
          56},{-52,56}}, color={0,0,127}));
  connect(datRea.y[11], totMasAir.u) annotation (Line(points={{-99,40},{-94,40},
          {-94,18},{-82,18}}, color={0,0,127}));
  connect(totMasAir.y, div1.u2) annotation (Line(points={{-58,18},{-56,18},{-56,
          44},{-52,44}}, color={0,0,127}));
  connect(div1.y, souAir.Xi_in[1]) annotation (Line(points={{-28,50},{12,50},{12,
          32},{48,32}}, color={0,0,127}));
  connect(K2C.y, souAir.T_in) annotation (Line(points={{-58,80},{20,80},{20,40},
          {48,40}}, color={0,0,127}));
  connect(datRea.y[7], K2C.u) annotation (Line(points={{-99,40},{-90,40},{-90,80},
          {-82,80}}, color={0,0,127}));
  connect(datRea.y[4], greThr.u) annotation (Line(points={{-99,40},{-92,40},{
          -92,-40},{-82,-40}},
                           color={0,0,127}));
  connect(greThr.y, PTHP.uCooEna) annotation (Line(points={{-58,-40},{-30,-40},
          {-30,-9.8},{-22,-9.8}}, color={255,0,255}));
  connect(datRea.y[4], PTHP.uFan) annotation (Line(points={{-99,40},{-92,40},{-92,
          -18},{-34,-18},{-34,10},{-22,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},
            {120,140}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{120,
            140}})),
    experiment(
      StartTime=18144000,
      StopTime=18230400,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/ZoneEquipment/WindowAC/Validation/CoolingModeEPlusComparison.mos"
        "Simulate and Plot"));
end HeatingModeEPlusComparison;
