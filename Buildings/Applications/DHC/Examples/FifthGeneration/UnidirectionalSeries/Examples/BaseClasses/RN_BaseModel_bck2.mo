within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples.BaseClasses;
partial model RN_BaseModel_bck2
  package MediumWater = Buildings.Media.Water "Medium model";
  inner parameter Data.DesignDataDHC datDes(
    mCon_flow_nominal={
      max(ets1.m1HexChi_flow_nominal, ets1.mEva_flow_nominal),
      max(ets2.m1HexChi_flow_nominal, ets2.mEva_flow_nominal),
      max(ets3.m1HexChi_flow_nominal, ets3.mEva_flow_nominal)})
    "Design values"
    annotation (Placement(transformation(extent={{-460,280},{-440,300}})));
  Agents.BoreField borFie(redeclare package Medium = MediumWater)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2,-440})));
  Distribution.BaseClasses.Pump_m_flow pumpMainRLTN(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDis_flow_nominal) "Pump"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={80,-360})));
  Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Agents.EnergyTransferStation
    ets1(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui1.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui1.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumWater,
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
        origin={-226,-300})));
  Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-220,-270})));
  Modelica.Blocks.Sources.Constant mFlowInputPlant(final k=datDes.mPla_flow_nominal)
                                                            "kg/s"
    annotation (Placement(transformation(extent={{-158,-298},{-174,-282}})));
  Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
    redeclare package Medium = MediumWater,
    T=290.15,
    nPorts=2) "17°C"
    annotation (Placement(transformation(extent={{-280,-310},{-260,-290}})));
  Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-260,-270})));
  Fluid.Sensors.TemperatureTwoPort tempAfterPlantSecondSide(
      redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDis_flow_nominal,
    tau=0) annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-246,-320})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        MediumWater, nPorts=1)
    "Boundary pressure condition representing the expansion vessel"
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={132,-320})));

  Distribution.BaseClasses.Pump_m_flow pumpBHS(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mSto_flow_nominal) "Pump"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,-440})));
  Distribution.BaseClasses.Junction splSup9(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-400})));
  Distribution.BaseClasses.Junction splSup10(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDis_flow_nominal*{1,1,1},
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-400})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui1(redeclare package
      Medium1 = MediumWater, nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=ets1.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-460,230},{-440,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=ets1.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-460,190},{-440,210}})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui2(
    redeclare package Medium1 = MediumWater,
    idfPath=
        "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
    nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{120,180},{140,200}})));

  Agents.EnergyTransferStation ets2(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui2.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui2.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{100,80},{140,120}})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui3(redeclare package
      Medium1 = MediumWater, nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{120,360},{140,380}})));
  Agents.EnergyTransferStation
    ets3(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui3.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui3.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{100,260},{140,300}})));
  Distribution.BaseClasses.ConnectionSeries conPla(
    redeclare package Medium = MediumWater,
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
        origin={-80,-290})));
  Distribution.UnidirectionalSeries dis(
    redeclare package Medium = MediumWater,
    nCon=3,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=datDes.mCon_flow_nominal,
    lDis=datDes.lDis,
    lCon=datDes.lCon,
    dhDis=datDes.dhDis,
    dhCon=datDes.dhCon)
    annotation (Placement(transformation(extent={{-20,-150},{20,-130}})));
protected
  constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
equation
  connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
      Line(points={{-174.8,-290},{-204,-290},{-204,-270},{-208,-270}}, color={0,
          0,127}));
  connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
        points={{-240,-320},{-232,-320},{-232,-310}},color={0,127,255}));
  connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
    annotation (Line(points={{-252,-320},{-260,-320},{-260,-298}},color={0,
          127,255}));
  connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
      Line(points={{-174.8,-290},{-200,-290},{-200,-270},{-272,-270}}, color={0,0,127}));
  connect(pumpPrimarySidePlant.port_a, plant.port_b1)
    annotation (Line(points={{-220,-280},{-220,-290}}, color={0,127,255}));
  connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
        points={{-260,-260},{-260,-240},{-232,-240},{-232,-290}}, color={0,127,
          255}));
  connect(pumpSecondarySidePlant.port_a, sewageSourceAtConstTemp.ports[2])
    annotation (Line(points={{-260,-280},{-260,-302}}, color={0,127,255}));
  connect(bou.ports[1], pumpMainRLTN.port_a)
    annotation (Line(points={{122,-320},{80,-320},{80,-350}},
                                      color={0,127,255}));
  connect(borFie.port_a, pumpBHS.port_b)
    annotation (Line(points={{8,-440},{40,-440}}, color={0,127,255}));
  connect(splSup10.port_2, borFie.port_b)
    annotation (Line(points={{-80,
          -410},{-80,-440},{-12,-440}}, color={0,127,255}));
  connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-440},
          {80,-440},{80,-410}},color={0,127,255}));
  connect(splSup9.port_1, pumpMainRLTN.port_b)
    annotation (Line(points={{80,-390},{80,-370}}, color={0,127,255}));
  connect(splSup10.port_3, splSup9.port_3)
    annotation (Line(points={{-70,-400},{70,-400}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, ets1.TSetHeaWat) annotation (Line(points={{-438,240},
          {60,240},{60,-62.8571},{98.5714,-62.8571}},      color={0,0,127}));
  connect(TSetChiWatSup.y, ets1.TSetChiWat) annotation (Line(points={{-438,200},
          {60,200},{60,-68.5714},{98.5714,-68.5714}},      color={0,0,127}));
  connect(TSetHeaWatSup.y, ets2.TSetHeaWat) annotation (Line(points={{-438,240},
          {88,240},{88,117.143},{98.5714,117.143}},   color={0,0,127}));
  connect(TSetChiWatSup.y, ets2.TSetChiWat) annotation (Line(points={{-438,200},
          {84,200},{84,111.429},{98.5714,111.429}},   color={0,0,127}));
  connect(TSetHeaWatSup.y, ets3.TSetHeaWat) annotation (Line(points={{-438,240},
          {88,240},{88,297.143},{98.5714,297.143}},     color={0,0,127}));
  connect(TSetChiWatSup.y, ets3.TSetChiWat) annotation (Line(points={{-438,200},
          {84,200},{84,294},{102,294},{102,291.429},{98.5714,291.429}},
        color={0,0,127}));
  connect(conPla.port_conSup, plant.port_a1) annotation (Line(points={{-90,-290},
          {-100,-290},{-100,-320},{-220,-320},{-220,-310}}, color={0,127,255}));
  connect(pumpPrimarySidePlant.port_b, conPla.port_conRet) annotation (Line(
        points={{-220,-260},{-220,-240},{-100,-240},{-100,-284},{-90,-284}},
        color={0,127,255}));
  connect(splSup10.port_1, conPla.port_disInl) annotation (Line(points={{-80,
          -390},{-80,-300}},                 color={0,127,255}));
  connect(conPla.port_disOut, dis.port_disInl) annotation (Line(points={{-80,
          -280},{-80,-140},{-20,-140}},
                                  color={0,127,255}));
  connect(dis.port_disOut, pumpMainRLTN.port_a) annotation (Line(points={{20,-140},
          {80,-140},{80,-350}}, color={0,127,255}));
  connect(dis.ports_b1[1], ets1.port_a) annotation (Line(points={{-6.66667,-130},
          {-20,-130},{-20,-80},{100,-80}}, color={0,127,255}));
  connect(ets1.port_b, dis.ports_a1[1]) annotation (Line(points={{140,-80},{160,
          -80},{160,-120},{20,-120},{20,-130},{17.3333,-130}},color={0,127,255}));
  connect(dis.ports_b1[2], ets2.port_a) annotation (Line(points={{-12,-130},{-20,
          -130},{-20,100},{100,100}}, color={0,127,255}));
  connect(ets2.port_b, dis.ports_a1[2]) annotation (Line(points={{140,100},{160,
          100},{160,40},{20,40},{20,-128},{12,-128},{12,-130}},
                                                color={0,127,255}));
  connect(dis.ports_b1[3], ets3.port_a) annotation (Line(points={{-17.3333,-130},
          {-20,-130},{-20,280},{100,280}}, color={0,127,255}));
  connect(ets3.port_b, dis.ports_a1[3]) annotation (Line(points={{140,280},{160,
          280},{160,234},{20,234},{20,-130},{6.66667,-130}},color={0,127,255}));
  connect(bui3.ports_b1[1:2], ets3.ports_a1) annotation (Line(points={{160,354},
          {180,354},{180,250},{94,250},{94,267.143},{100,267.143}}, color={0,
          127,255}));
  connect(ets3.ports_b1, bui3.ports_a1[1:2]) annotation (Line(points={{140,
          267.143},{154,267.143},{154,320},{80,320},{80,354},{100,354}}, color=
          {0,127,255}));
  connect(bui2.ports_b1[1:2], ets2.ports_a1) annotation (Line(points={{160,174},
          {180,174},{180,60},{80,60},{80,87.1429},{100,87.1429}}, color={0,127,
          255}));
  connect(ets2.ports_b1, bui2.ports_a1[1:2]) annotation (Line(points={{140,
          87.1429},{152,87.1429},{152,140},{92,140},{92,174},{100,174}}, color=
          {0,127,255}));
  connect(bui1.ports_b1[1:2], ets1.ports_a1) annotation (Line(points={{160,-26},
          {180,-26},{180,-114},{80,-114},{80,-92.8571},{100,-92.8571}}, color={
          0,127,255}));
  connect(ets1.ports_b1, bui1.ports_a1[1:2]) annotation (Line(points={{140,
          -92.8571},{150,-92.8571},{150,-52},{80,-52},{80,-26},{100,-26}},
        color={0,127,255}));
  annotation (Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-480,-500},{480,
        500}}), graphics={
        Text(
      extent={{-478,-420},{-138,-500}},
      lineColor={28,108,200},
      horizontalAlignment=TextAlignment.Left,
          textString="Simulation requires the first setting and is faster with the  second one

Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
    Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
end RN_BaseModel_bck2;
