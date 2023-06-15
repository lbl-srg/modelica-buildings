within Buildings.Fluid.ZoneEquipment.WindowAC.Validation;
model CoolingModeSimpleInput
  "Validation model for cooling mode operation of window AC system"
  extends Modelica.Icons.Example;
  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal";
  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-9365,
          COP_nominal=3.5,
          SHR_nominal=0.8,
          m_flow_nominal=1.2*0.56578),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.PerformanceCurve(
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
  annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = MediumA,
    final use_Xi_in=true,
    use_p_in=false,
    final p(displayUnit="Pa") = 101325 + dpAir_nominal + 50,
    final use_T_in=true,
    final T=279.15,
    final nPorts=1)
    "Source for zone air"
    annotation (Placement(transformation(extent={{52,26},{72,46}})));

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 101325,
    final nPorts=1)
    "Sink for zone air"
    annotation (Placement(transformation(extent={{52,-54},{72,-34}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(final k=0)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor weather data"
    annotation (Placement(transformation(extent={{-80,68},{-60,88}})));
  Buildings.Fluid.ZoneEquipment.WindowAC.Validation.Data.SizingData winACSizing
    "Sizing parameters for window AC"
    annotation (Placement(transformation(extent={{60,92},{80,112}})));
  Buildings.Fluid.ZoneEquipment.WindowAC.WindowAC winAC(
    redeclare package MediumA = MediumA,
    mAirOut_flow_nominal=winACSizing.mAirOut_flow_nominal,
    mAir_flow_nominal=winACSizing.mAir_flow_nominal,
    oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaMix,
    dpAir_nominal(displayUnit="Pa") = dpAir_nominal,
    dpDX_nominal(displayUnit="Pa") = dpDX_nominal,
    redeclare Buildings.Fluid.ZoneEquipment.WindowAC.Validation.Data.FanData fanPer,
    datCoi=datCoi)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant onFanCoil(final k=1)
    "on off signal for fan and DX coil"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=86400,
    startTime=18144000,
    height=-5,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{0,68},{20,88}})));
  Modelica.Blocks.Sources.Constant Xi(k=0.0123)
    "Fixed Xi value"
    annotation (Placement(transformation(extent={{0,38},{20,58}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uCooEna(k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(weaDat.weaBus, winAC.weaBus) annotation (Line(
      points={{-60,78},{-15.8,78},{-15.8,18}},
      color={255,204,51},
      thickness=0.5));
  connect(damPos.y, winAC.uEco)
    annotation (Line(points={{-58,18},{-22,18}}, color={0,0,127}));
  connect(souAir.ports[1], winAC.port_Air_a2) annotation (Line(points={{72,36},
          {78,36},{78,4},{20,4}}, color={0,127,255}));
  connect(sinAir.ports[1], winAC.port_Air_b2) annotation (Line(points={{72,-44},
          {78,-44},{78,-4},{20,-4}}, color={0,127,255}));
  connect(TEvaIn.y, souAir.T_in) annotation (Line(points={{21,78},{36,78},{36,
          40},{50,40}}, color={0,0,127}));
  connect(Xi.y, souAir.Xi_in[1]) annotation (Line(points={{21,48},{36,48},{36,
          32},{50,32}}, color={0,0,127}));
  connect(onFanCoil.y, winAC.uFan) annotation (Line(points={{-58,-30},{-42,-30},
          {-42,10},{-22,10}}, color={0,0,127}));
  connect(uCooEna.y, winAC.uCooEna) annotation (Line(points={{-58,-70},{-38,-70},
          {-38,-9.8},{-22,-9.8}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,140}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,140}})),
    experiment(
      StartTime=18144000,
      StopTime=18230400,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/ZoneEquipment/WindowAC/Validation/CoolingModeSimpleInput.mos"
        "Simulate and Plot"));
end CoolingModeSimpleInput;
