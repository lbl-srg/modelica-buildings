within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Examples;
model SeriesConstantFlowRCB3Z1
  "Example of series connection with constant district water mass flow rate, 3 RC building models (1 zone)"
  extends BaseClasses.PartialSeries(
    nBui=3,
    weaPat=
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
    datDes(
      mCon_flow_nominal={
        max(bui[i].ets.m1HexChi_flow_nominal, bui[i].ets.mEva_flow_nominal) for i in 1:nBui},
      epsPla=0.935));
  Modelica.Blocks.Sources.Constant massFlowMainPump(
    k=datDes.mDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-380,-70},{-360,-50}})));
  Loads.BuildingRCZ1WithETS bui[nBui](
    redeclare each final package Medium=Medium)
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup[nBui](
    k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-280,210},{-260,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup[nBui](
    k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    calTSky=Buildings.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(weaPat))
    "Weather data reader"
    annotation (Placement(transformation(extent={{60,210},{40,230}})));
equation
  connect(massFlowMainPump.y, pumpMainRLTN.m_flow_in)
    annotation (Line(points={{-359,-60},{60,-60},{60,-80},{68,-80}},
                                                color={0,0,127}));
  connect(pumpBHS.m_flow_in, massFlowMainPump.y)
    annotation (Line(points={{-160,-108},{-160,-60},{-359,-60}},
    color={0,0,127}));
  connect(TSetHeaWatSup.y,bui. TSetHeaWat)
    annotation (Line(points={{-258,220},{
          -20,220},{-20,188},{-11,188}},
                                     color={0,0,127}));
  connect(TSetChiWatSup.y,bui. TSetChiWat)
    annotation (Line(points={{-258,180},{
          -20,180},{-20,184},{-11,184}},  color={0,0,127}));
  connect(bui.port_b, dis.ports_conRet)
    annotation (Line(points={{10,180},{20,180},
          {20,152},{12,152},{12,150}}, color={0,127,255}));
  connect(dis.ports_conSup, bui.port_a)
    annotation (Line(points={{-12,150},{-20,
          150},{-20,180},{-10,180}}, color={0,127,255}));
  for i in 1:nBui loop
    connect(weaDat.weaBus, bui[i].weaBus)
      annotation (Line(
      points={{40,220},{-0.1,220},{-0.1,190}},
      color={255,204,51},
      thickness=0.5));
  end for;
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-480,-440},{480,440}}),
    graphics={
    Text(
    extent={{-272,-296},{68,-376}},
    lineColor={28,108,200},
    horizontalAlignment=TextAlignment.Left,
    textString="Simulation is faster with

Advanced.SparseActivate=true")}),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir1Constant.mos"
  "Simulate and plot"),
  experiment(
    StopTime=172800,
    Tolerance=1e-06,
    __Dymola_Algorithm="Cvode"));
end SeriesConstantFlowRCB3Z1;
