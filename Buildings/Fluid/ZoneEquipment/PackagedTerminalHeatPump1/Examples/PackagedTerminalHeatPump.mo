within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump1.Examples;
model PackagedTerminalHeatPump
  "Example model for heating mode operation of packaged terminal heat pump"
  extends Modelica.Icons.Example;
  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";
  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";
  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCooCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          is_CooCoi=true,
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
    annotation (Placement(transformation(extent={{60,92},{80,112}})));
   parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer datHeaCoi(
    is_CooCoi=false,                                                                                              sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          is_CooCoi=false,
          Q_flow_nominal=15000,
          COP_nominal=2.75,
          SHR_nominal=1,
          m_flow_nominal=0.782220983308365,
          TEvaIn_nominal=273.15 + 6,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_Curve_II())},
      nSta=1) "Heating coil data"
    annotation (Placement(transformation(extent={{60,64},{80,84}})));

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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor weather data"
    annotation (Placement(transformation(extent={{-80,68},{-60,88}})));
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump1.PackagedTerminalHeatPump
    PTHP(
    redeclare package MediumA = MediumA,
    mAirOut_flow_nominal=1.225*0.42691,
    mAir_flow_nominal=1.225*0.42691,
    oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses1.Types.OAPorts.oaMix,
    QSup_flow_nominal=5000,
    dpAir_nominal(displayUnit="Pa") = dpAir_nominal,
    dpCooDX_nominal(displayUnit="Pa") = 0,
    dpHeaDX_nominal(displayUnit="Pa") = 0,
    dpSupHea_nominal(displayUnit="Pa") = 0,
    datHeaCoi=datHeaCoi,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump1.Validation.Data.FanData
      fanPer,
    datCooCoi=datCooCoi,
    datDef=datDef)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant onFanCoil(final k=1)
    "on off signal for fan and DX coil"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=86400,
    startTime=18144000,
    height=-5,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{0,68},{20,88}})));
  Modelica.Blocks.Sources.Constant Xi(k=0.0123)
    "Fixed Xi value"
    annotation (Placement(transformation(extent={{0,38},{20,58}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamOut(final k=0.2)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(k=true)
    annotation (Placement(transformation(extent={{-90,-52},{-70,-32}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(k=false)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_DefrostCurve
    datDef(
    defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive,
    defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed,
    tDefRun=0.1666,
    QDefResCap=10500,
    QCraCap=200) "Defrost data"
    annotation (Placement(transformation(extent={{60,114},{80,134}})));

equation
  connect(souAir.ports[1], PTHP.port_Air_a2) annotation (Line(points={{72,36},{78,
          36},{78,4},{20,4}}, color={0,127,255}));
  connect(sinAir.ports[1], PTHP.port_Air_b2) annotation (Line(points={{72,-44},{
          78,-44},{78,-4},{20,-4}}, color={0,127,255}));
  connect(TEvaIn.y, souAir.T_in) annotation (Line(points={{21,78},{36,78},{36,
          40},{50,40}}, color={0,0,127}));
  connect(Xi.y, souAir.Xi_in[1]) annotation (Line(points={{21,48},{36,48},{36,
          32},{50,32}}, color={0,0,127}));
  connect(onFanCoil.y, PTHP.uFan) annotation (Line(points={{-68,-10},{-40,-10},{
          -40,10},{-22,10}}, color={0,0,127}));
  connect(zer.y, PTHP.uSupHea) annotation (Line(points={{-68,20},{-44,20},{-44,-14},
          {-22,-14}}, color={0,0,127}));
  connect(yDamOut.y, PTHP.uEco) annotation (Line(points={{-68,50},{-40,50},{-40,
          18},{-22,18}}, color={0,0,127}));
  connect(tru.y, PTHP.uHeaEna) annotation (Line(points={{-68,-42},{-38,-42},{
          -38,-17.8},{-22,-17.8}},
                               color={255,0,255}));
  connect(fal.y, PTHP.uCooEna) annotation (Line(points={{-68,-70},{-34,-70},{-34,
          -9.8},{-22,-9.8}}, color={255,0,255}));
  connect(weaDat.weaBus, PTHP.weaBus) annotation (Line(
      points={{-60,78},{-15.8,78},{-15.8,18}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,140}})),
    experiment(StopTime=86400, __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>This is an example model for the PTHP model in one heating day with simple inputs.</p>
", revisions="<html>
    <ul>
    <li>
    Mar 30, 2023 by Karthik Devaprasad, Xing Lu:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end PackagedTerminalHeatPump;
