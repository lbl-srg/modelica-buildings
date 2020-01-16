within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Examples;
model SeriesConstantFlowSpawn
  "Example of series connection with constant district water mass flow rate, Spawn building models (6 zones)"
  extends BaseClasses.PartialSeries(
    nBui=3,
    nZon=fill(6, nBui),
    weaPat=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
    datDes(
      mCon_flow_nominal={
        max(bui[i].ets.m1HexChi_flow_nominal, bui[i].ets.mEva_flow_nominal) for i in 1:nBui},
      epsPla=0.935));
  parameter String idfPat[nBui] = {
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf",
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"}
    "Paths of the IDF files";
  Modelica.Blocks.Sources.Constant massFlowMainPump(
    k=datDes.mDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-380,-70},{-360,-50}})));
  Agents.SpawnBuildingWithETS bui[nBui](
    redeclare each package Medium=Medium,
    idfPat=idfPat,
    each weaPat=weaPat,
    nZon=nZon)
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup[nBui](
    k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-280,190},{-260,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup[nBui](
    k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-280,150},{-260,170}})));
equation
  connect(massFlowMainPump.y, pumpMainRLTN.m_flow_in)
    annotation (Line(points={{-359,-60},{60,-60},{60,-80},{68,-80}},
                                                color={0,0,127}));
  connect(pumpBHS.m_flow_in, massFlowMainPump.y)
    annotation (Line(points={{-160,-108},{-160,-60},{-359,-60}},
    color={0,0,127}));
  connect(TSetHeaWatSup.y, bui.TSetHeaWat)
    annotation (Line(points={{-258,200},{
          -20,200},{-20,188},{-11,188}},
                                     color={0,0,127}));
  connect(TSetChiWatSup.y, bui.TSetChiWat)
    annotation (Line(points={{-258,160},{
          -20,160},{-20,184},{-11,184}},  color={0,0,127}));
  connect(dis.ports_conSup, bui.port_a)
    annotation (Line(points={{-12,150},{-14,
          150},{-14,180},{-10,180}}, color={0,127,255}));
  connect(bui.port_b, dis.ports_conRet)
    annotation (Line(points={{10,180},{12,180},{12,150}}, color={0,127,255}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-480,-440},{480,440}}),
        graphics={
        Text(
      extent={{-272,-296},{68,-376}},
      lineColor={28,108,200},
      horizontalAlignment=TextAlignment.Left,
          textString="Simulation requires the first setting and is faster with the  second one

Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Reservoir1Constant.mos"
  "Simulate and plot"),
  experiment(
    StopTime=172800,
    Tolerance=1e-06,
    __Dymola_Algorithm="Cvode"));
end SeriesConstantFlowSpawn;
