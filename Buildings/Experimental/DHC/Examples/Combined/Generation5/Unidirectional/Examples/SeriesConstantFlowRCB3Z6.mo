within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Examples;
model SeriesConstantFlowRCB3Z6
  "Example of series connection with constant district water mass flow rate, 3 RC building models (6 zones)"
  // allowFlowReversal must be true when using a switch box with valve due to leakage flow.
  // Same with allowFlowReversalDis below.
  extends BaseClasses.PartialSeries(
    final allowFlowReversal=allowFlowReversalDis,
    nBui=3,
    datDes(
      mCon_flow_nominal={
        max(bui[i].ets.m1HexChi_flow_nominal, bui[i].ets.mEva_flow_nominal) for i in 1:nBui},
      epsPla=0.935));
  parameter Boolean allowFlowReversalDis = true
    "Set to true to allow flow reversal on the district side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter String weaName = "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"
    "Library path of the weather file";
  Loads.BuildingRCZ6WithETS bui[nBui](
    redeclare each final package Medium = Medium,
    each final allowFlowReversalBui=false,
    each final allowFlowReversalDis=allowFlowReversalDis)
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Modelica.Blocks.Sources.Constant massFlowMainPump(
    k=datDes.mDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
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
    filNam=Modelica.Utilities.Files.loadResource(weaName))
    "Weather data reader"
    annotation (Placement(transformation(extent={{60,210},{40,230}})));
  Modelica.Blocks.Sources.Constant TSewWat(k=273.15 + 17)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));
  Modelica.Blocks.Sources.Constant mDisPla_flow(k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-280,10},{-260,30}})));
equation
  connect(massFlowMainPump.y, pumDis.m_flow_in) annotation (Line(points={{-259,
          -60},{60,-60},{60,-60},{68,-60}}, color={0,0,127}));
  connect(pumSto.m_flow_in, massFlowMainPump.y) annotation (Line(points={{-180,
          -68},{-180,-60},{-259,-60}}, color={0,0,127}));
  connect(TSetHeaWatSup.y,bui. TSetHeaWat)
    annotation (Line(points={{-258,220},{-40,220},{-40,188},{-11,188}},
                                     color={0,0,127}));
  connect(TSetChiWatSup.y,bui. TSetChiWat)
    annotation (Line(points={{-258,180},{-40,180},{-40,184},{-11,184}},
                                          color={0,0,127}));
  connect(bui.port_b, dis.ports_aCon) annotation (Line(points={{10,180},{20,180},
          {20,160},{12,160},{12,150}}, color={0,127,255}));
  connect(dis.ports_bCon, bui.port_a) annotation (Line(points={{-12,150},{-12,
          160},{-20,160},{-20,180},{-10,180}}, color={0,127,255}));
  for i in 1:nBui loop
    connect(weaDat.weaBus, bui[i].weaBus)
      annotation (Line(
      points={{40,220},{-0.1,220},{-0.1,190}},
      color={255,204,51},
      thickness=0.5));
  end for;
  connect(mDisPla_flow.y, pla.mPum_flow) annotation (Line(points={{-259,20},{-180,
          20},{-180,4},{-161,4}}, color={0,0,127}));
  connect(TSewWat.y, pla.TSewWat) annotation (Line(points={{-259,60},{-176,60},
          {-176,8},{-161,8}}, color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}}),
    graphics={
    Text(
    extent={{-338,-176},{2,-256}},
    lineColor={28,108,200},
    horizontalAlignment=TextAlignment.Left,
          textString="Simulation is faster with

Advanced.SparseActivate=true")}),
  __Dymola_Commands,
  experiment(
    StopTime=172800,
    Tolerance=1e-06,
    __Dymola_Algorithm="Cvode"));
end SeriesConstantFlowRCB3Z6;
