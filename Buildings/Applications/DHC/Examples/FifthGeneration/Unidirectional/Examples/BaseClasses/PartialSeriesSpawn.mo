within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Examples.BaseClasses;
partial model PartialSeriesSpawn
  "Partial model for series network and Spawn building models (6 zones)"
  extends Modelica.Icons.Example;
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
    annotation (Placement(transformation(extent={{-286,230},{-266,250}})));
  // COMPONENTS
  Agents.SpawnBuildingWithETS bui[nBui](
    redeclare each final package Medium = Medium,
    idfPath=idfPath,
    each weaPath=weaPath,
    nZon=nZon)
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Agents.BoreField borFie(redeclare package Medium=Medium)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,-80})));
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
        origin={-160,-120})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup[nBui](k=
        bui.THeaWatSup_nominal) "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-286,188},{-266,208}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup[nBui](k=
        bui.TChiWatSup_nominal) "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-286,150},{-266,170}})));
  Distribution.BaseClasses.ConnectionSeries conPla(
    redeclare package Medium=Medium,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=datDes.mPla_flow_nominal,
    lDis=0,
    lCon=10,
    dhDis=datDes.dhDis,
    dhCon=0.10) "Connection to the plant"            annotation (Placement(
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
  Distribution.BaseClasses.ConnectionSeries conSto(
    redeclare package Medium = Medium,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=datDes.mSto_flow_nominal,
    lDis=0,
    lCon=0,
    dhDis=datDes.dhDis,
    dhCon=datDes.dhDis) "Connection to the bore field" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-90})));
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
    annotation (Line(points={{-200,-80},{-260,-80},{-260,-120},{-170,-120}},
                                                  color={0,127,255}));
  connect(conPla.port_conSup, plant.port_a1) annotation (Line(points={{-90,-10},
          {-100,-10},{-100,-40},{-220,-40},{-220,-30}},     color={0,127,255}));
  connect(pumpPrimarySidePlant.port_b, conPla.port_conRet) annotation (Line(
        points={{-220,20},{-220,40},{-100,40},{-100,-4},{-90,-4}},
        color={0,127,255}));
  connect(conPla.port_disOut, dis.port_disInl) annotation (Line(points={{-80,0},
          {-80,140},{-20,140}},   color={0,127,255}));
  connect(dis.port_disOut, pumpMainRLTN.port_a) annotation (Line(points={{20,140},
          {80,140},{80,-70}},   color={0,127,255}));
  connect(dis.ports_b1, bui.port_a) annotation (Line(points={{-12,150},{-14,150},
          {-14,180},{-10,180}}, color={0,127,255}));
  connect(bui.port_b, dis.ports_a1) annotation (Line(points={{10,180},{14,180},
          {14,150},{12,150}},
                            color={0,127,255}));
  connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
    annotation (Line(points={{-252,-40},{-260,-40},{-260,-18}},    color={0,127,255}));
  connect(sewageSourceAtConstTemp.ports[2], pumpSecondarySidePlant.port_a)
    annotation (Line(points={{-260,-22},{-260,0}},     color={0,127,255}));
  connect(TSetHeaWatSup.y, bui.TSetHeaWat) annotation (Line(points={{-264,
          198},{-52,198},{-52,188},{-11,188}},
                                     color={0,0,127}));
  connect(TSetChiWatSup.y, bui.TSetChiWat) annotation (Line(points={{-264,
          160},{-50,160},{-50,184},{-11,184}},
                                          color={0,0,127}));
  connect(conSto.port_disOut, conPla.port_disInl)
    annotation (Line(points={{-80,-80},{-80,-20}}, color={0,127,255}));
  connect(borFie.port_b, conSto.port_conRet) annotation (Line(points={{-180,-80},
          {-100,-80},{-100,-84},{-90,-84}}, color={0,127,255}));
  connect(pumpBHS.port_a, conSto.port_conSup) annotation (Line(points={{-150,
          -120},{-100,-120},{-100,-90},{-90,-90}}, color={0,127,255}));
  connect(pumpMainRLTN.port_b, conSto.port_disInl) annotation (Line(points={{80,
          -90},{80,-120},{-80,-120},{-80,-100}}, color={0,127,255}));
  annotation (Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-320,-380},{320,
            380}})),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760));
end PartialSeriesSpawn;
