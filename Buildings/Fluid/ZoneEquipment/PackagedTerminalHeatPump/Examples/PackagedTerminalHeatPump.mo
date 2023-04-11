within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Examples;
model PackagedTerminalHeatPump
  "Example model for heating mode operation of packaged terminal heat pump"
  extends Modelica.Icons.Example;
  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCooCoi(
    sta={
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
    "Cooling coil data"
    annotation (Placement(transformation(extent={{60,92},{80,112}})));

   parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer datHeaCoi(
    is_CooCoi=false,
    sta={
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
      nSta=1)
    "Heating coil data"
    annotation (Placement(transformation(extent={{60,64},{80,84}})));

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.PackagedTerminalHeatPump
    pthp(
    redeclare package MediumA = MediumA,
    final mAirOut_flow_nominal=1.225*0.42691,
    final mAir_flow_nominal=1.225*0.42691,
    final oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaMix,
    final QSup_flow_nominal=5000,
    final dpAir_nominal=dpAir_nominal,
    final dpCooDX_nominal= 0,
    final dpHeaDX_nominal= 0,
    final dpSupHea_nominal= 0,
    datHeaCoi=datHeaCoi,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.FanData
      fanPer,
    datCooCoi=datCooCoi,
    datDef=datDef)
    "Packaged terminal heat pump instance"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = MediumA,
    final use_Xi_in=true,
    final use_p_in=false,
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant supHea(
    final k=0)
    "Supplementary heating signal"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor weather data"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant onFanCoil(
    final k=1)
    "Enable signal for fan"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));

  Modelica.Blocks.Sources.Ramp TEvaIn(
    final duration=86400,
    final startTime=18144000,
    final height=-5,
    final offset=273.15 + 23)
    "Temperature"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Modelica.Blocks.Sources.Constant Xi(
    final k=0.0123)
    "Fixed Xi value"
    annotation (Placement(transformation(extent={{0,38},{20,58}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yDamOut(
    final k=0.2)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant heaEna(
    k=true)
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-90,-52},{-70,-32}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cooDis(
    final k=false)
    "Cooling disable signal"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_DefrostCurve
    datDef(
    final defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive,
    final defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed,
    final tDefRun=0.1666,
    final QDefResCap=10500,
    final QCraCap=200)
    "Defrost data"
    annotation (Placement(transformation(extent={{60,114},{80,134}})));

equation
  connect(souAir.ports[1],pthp. port_Air_a2) annotation (Line(points={{72,36},{78,
          36},{78,4},{20,4}}, color={0,127,255}));
  connect(sinAir.ports[1],pthp. port_Air_b2) annotation (Line(points={{72,-44},{
          78,-44},{78,-4},{20,-4}}, color={0,127,255}));
  connect(TEvaIn.y, souAir.T_in) annotation (Line(points={{21,80},{40,80},{40,40},
          {50,40}},     color={0,0,127}));
  connect(Xi.y, souAir.Xi_in[1]) annotation (Line(points={{21,48},{30,48},{30,32},
          {50,32}},     color={0,0,127}));
  connect(onFanCoil.y,pthp. uFan) annotation (Line(points={{-68,-10},{-40,-10},{
          -40,10},{-22,10}}, color={0,0,127}));
  connect(supHea.y, pthp.uSupHea) annotation (Line(points={{-68,20},{-44,20},{-44,
          -14},{-22,-14}}, color={0,0,127}));
  connect(yDamOut.y,pthp. uEco) annotation (Line(points={{-68,50},{-40,50},{-40,
          18},{-22,18}}, color={0,0,127}));
  connect(heaEna.y, pthp.uHeaEna) annotation (Line(points={{-68,-42},{-38,-42},{
          -38,-17.8},{-22,-17.8}}, color={255,0,255}));
  connect(cooDis.y, pthp.uCooEna) annotation (Line(points={{-68,-70},{-34,-70},{
          -34,-9.8},{-22,-9.8}}, color={255,0,255}));
  connect(weaDat.weaBus,pthp. weaBus) annotation (Line(
      points={{-70,80},{-15.8,80},{-15.8,18}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,140}})),
    experiment(Tolerance=1e-6),
    Documentation(info="<html>
<p>This is an example model for the PTHP model in one heating day with simple inputs.</p>
</html>", revisions="<html>
    <ul>
    <li>
    April 10, 2023, by Xing Lu and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalHeatPump/Examples/PackagedTerminalHeatPump.mos"
        "Simulate and plot"));
end PackagedTerminalHeatPump;
