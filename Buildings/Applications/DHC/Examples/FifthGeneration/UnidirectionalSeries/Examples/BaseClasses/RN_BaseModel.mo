within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples.BaseClasses;
partial model RN_BaseModel
  package Medium = Buildings.Media.Water "Medium model";
  parameter Integer nBui = 3
    "Number of buildings connected to DHC system"
    annotation (Evaluate=true);
  parameter String idfPath[nBui] = {
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf",
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/RefBldgSmallOfficeNew2004_Chicago.idf"}
    "Paths of the IDF files";
  parameter String weaPath=
    "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94020090/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"
    "Path of the weather file";
  parameter Integer nZon[nBui] = fill(6, nBui)
    "Number of thermal zones"
    annotation(Evaluate=true);
  inner parameter Data.DesignDataDHC datDes(
    mCon_flow_nominal={
      max(bui[i].ets.m1HexChi_flow_nominal, bui[i].ets.mEva_flow_nominal) for i in 1:nBui})
    "Design values"
    annotation (Placement(transformation(extent={{-320,240},{-300,260}})));
  // COMPONENTS
  Agents.BuildingWithETS bui[nBui](
    redeclare each final package Medium = Medium,
    idfPath=idfPath,
    each weaPath=weaPath,
    nZon=nZon)
    annotation (Placement(transformation(extent={{-10,180},{10,200}})));
  Agents.BoreField borFie(redeclare package Medium=Medium)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2,-160})));
  Distribution.BaseClasses.Pump_m_flow pumpMainRLTN(
    redeclare package Medium=Medium,
    m_flow_nominal=datDes.mDis_flow_nominal) "Pump"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={80,-80})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
    redeclare package Medium1=Medium,
    redeclare package Medium2=Medium,
    allowFlowReversal2=false,
    final m1_flow_nominal=datDes.mPla_flow_nominal,
    final m2_flow_nominal=datDes.mPla_flow_nominal,
    show_T=true,
    final dp1_nominal(displayUnit="bar") = 50000,
    final dp2_nominal(displayUnit="bar") = 50000,
    final eps=datDes.epsPla)
    "Heat exchanger" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-226,-20})));
  Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
    redeclare package Medium=Medium,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-220,10})));
  Modelica.Blocks.Sources.Constant mFlowInputPlant(
    final k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-158,-18},{-174,-2}})));
  Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
    redeclare package Medium=Medium,
    T=290.15,
    nPorts=2) "17°C"
    annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));
  Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
    redeclare package Medium=Medium,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-260,10})));
  Fluid.Sensors.TemperatureTwoPort tempAfterPlantSecondSide(
      redeclare package Medium=Medium,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDis_flow_nominal,
    tau=0) annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-246,-40})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium=Medium,
    nPorts=1)
    "Boundary pressure condition representing the expansion vessel"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={112,-40})));
  Distribution.BaseClasses.Pump_m_flow pumpBHS(
    redeclare package Medium=Medium,
    m_flow_nominal=datDes.mSto_flow_nominal) "Pump"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,-160})));
  Distribution.BaseClasses.Junction splSup9(
    redeclare package Medium=Medium,
    m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-120})));
  Distribution.BaseClasses.Junction splSup10(
    redeclare package Medium=Medium,
    m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-120})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup[nBui](k=
        bui.THeaWatSup_nominal) "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-320,190},{-300,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup[nBui](k=
        bui.TChiWatSup_nominal) "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-320,150},{-300,170}})));
  Distribution.BaseClasses.ConnectionSeries conPla(
    redeclare package Medium=Medium,
    havePum=false,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=datDes.mPla_flow_nominal,
    lDis=datDes.lDis[1],
    lCon=datDes.lCon[1],
    dhDis=datDes.dhDis,
    dhCon=datDes.dhCon[1]) "Connection to the plant" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-10})));
  Distribution.UnidirectionalSeries dis(
    redeclare package Medium=Medium,
    nCon=nBui,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=datDes.mCon_flow_nominal,
    lDis=datDes.lDis,
    lCon=datDes.lCon,
    dhDis=datDes.dhDis,
    dhCon=datDes.dhCon)
    annotation (Placement(transformation(extent={{-20,130},{20,150}})));
protected
  constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
equation
  connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
      Line(points={{-174.8,-10},{-204,-10},{-204,10},{-208,10}},       color={0,
          0,127}));
  connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
        points={{-240,-40},{-232,-40},{-232,-30}},   color={0,127,255}));
  connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
      Line(points={{-174.8,-10},{-200,-10},{-200,10},{-272,10}},       color={0,0,127}));
  connect(pumpPrimarySidePlant.port_a, plant.port_b1)
    annotation (Line(points={{-220,0},{-220,-10}},     color={0,127,255}));
  connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
        points={{-260,20},{-260,40},{-232,40},{-232,-10}},        color={0,127,
          255}));
  connect(bou.ports[1], pumpMainRLTN.port_a)
    annotation (Line(points={{102,-40},{80,-40},{80,-70}},
                                      color={0,127,255}));
  connect(borFie.port_a, pumpBHS.port_b)
    annotation (Line(points={{8,-160},{40,-160}}, color={0,127,255}));
  connect(splSup10.port_2, borFie.port_b)
    annotation (Line(points={{-80,-130},{-80,-160},{-12,-160}},
                                        color={0,127,255}));
  connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-160},{
          80,-160},{80,-130}}, color={0,127,255}));
  connect(splSup9.port_1, pumpMainRLTN.port_b)
    annotation (Line(points={{80,-110},{80,-90}},  color={0,127,255}));
  connect(splSup10.port_3, splSup9.port_3)
    annotation (Line(points={{-70,-120},{70,-120}}, color={0,127,255}));
  connect(conPla.port_conSup, plant.port_a1) annotation (Line(points={{-90,-10},
          {-100,-10},{-100,-40},{-220,-40},{-220,-30}},     color={0,127,255}));
  connect(pumpPrimarySidePlant.port_b, conPla.port_conRet) annotation (Line(
        points={{-220,20},{-220,40},{-100,40},{-100,-4},{-90,-4}},
        color={0,127,255}));
  connect(splSup10.port_1, conPla.port_disInl) annotation (Line(points={{-80,
          -110},{-80,-20}},                  color={0,127,255}));
  connect(conPla.port_disOut, dis.port_disInl) annotation (Line(points={{-80,0},
          {-80,140},{-20,140}},   color={0,127,255}));
  connect(dis.port_disOut, pumpMainRLTN.port_a) annotation (Line(points={{20,140},
          {80,140},{80,-70}},   color={0,127,255}));
  connect(dis.ports_b1, bui.port_a) annotation (Line(points={{-12,150},{-14,150},
          {-14,190},{-10,190}}, color={0,127,255}));
  connect(bui.port_b, dis.ports_a1) annotation (Line(points={{10,190},{14,190},
          {14,150},{12,150}},
                            color={0,127,255}));
  connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
    annotation (Line(points={{-252,-40},{-260,-40},{-260,-18}},    color={0,127,255}));
  connect(sewageSourceAtConstTemp.ports[2], pumpSecondarySidePlant.port_a)
    annotation (Line(points={{-260,-22},{-260,0}},     color={0,127,255}));
  connect(TSetHeaWatSup.y, bui.TSetHeaWat) annotation (Line(points={{-298,200},
          {-20,200},{-20,198},{-11,198}},
                                     color={0,0,127}));
  connect(TSetChiWatSup.y, bui.TSetChiWat) annotation (Line(points={{-298,160},
          {-20,160},{-20,194},{-11,194}}, color={0,0,127}));
  annotation (Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-480,-380},{480,380}}),
                graphics={
        Text(
      extent={{-478,-140},{-138,-220}},
      lineColor={28,108,200},
      horizontalAlignment=TextAlignment.Left,
          textString="Simulation requires the first setting and is faster with the  second one

Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
    Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
end RN_BaseModel;
