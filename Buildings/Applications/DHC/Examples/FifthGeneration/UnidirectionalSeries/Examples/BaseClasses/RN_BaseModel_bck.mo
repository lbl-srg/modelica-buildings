within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples.BaseClasses;
partial model RN_BaseModel_bck
  package MediumWater = Buildings.Media.Water "Medium model";
  inner parameter Data.DesignDataDHC datDes "Design values"
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
    annotation (Placement(transformation(extent={{-360,-40},{-320,0}})));
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
        origin={-226,-240})));
  Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-220,-210})));
  Modelica.Blocks.Sources.Constant mFlowInputPlant(final k=datDes.mPla_flow_nominal)
                                                            "kg/s"
    annotation (Placement(transformation(extent={{-158,-238},{-174,-222}})));
  Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
    redeclare package Medium = MediumWater,
    T=290.15,
    nPorts=2) "17°C"
    annotation (Placement(transformation(extent={{-280,-250},{-260,-230}})));
  Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-260,-210})));
  Fluid.Sensors.TemperatureTwoPort tempAfterPlantSecondSide(
      redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDis_flow_nominal,
    tau=0) annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-246,-260})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        MediumWater, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-340})));

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
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
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
    annotation (Placement(transformation(extent={{320,180},{340,200}})));

  Agents.EnergyTransferStation ets2(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui2.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui2.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{320,80},{360,120}})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui3(redeclare package
      Medium1 = MediumWater, nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{320,-20},{340,0}})));
  Agents.EnergyTransferStation
    ets3(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui3.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui3.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{320,-120},{360,-80}})));
  Distribution.BaseClasses.ConnectionSeries junBui1(
    redeclare package Medium = MediumWater,
    havePum=false,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=max(ets1.m1HexChi_flow_nominal, ets1.mEva_flow_nominal),
    lDis=datDes.lDis[1],
    lCon=datDes.lCon[1],
    dhDis=datDes.dhDis[1],
    dhCon=datDes.dhCon[1]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-84,-30})));
  Distribution.BaseClasses.ConnectionSeries junBui2(
    redeclare package Medium = MediumWater,
    havePum=false,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=max(ets2.m1HexChi_flow_nominal, ets2.mEva_flow_nominal),
    lDis=datDes.lDis[2],
    lCon=datDes.lCon[2],
    dhDis=datDes.dhDis[2],
    dhCon=datDes.dhCon[2]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={84,102})));
  Distribution.BaseClasses.ConnectionSeries junBui3(
    redeclare package Medium = MediumWater,
    havePum=false,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=max(ets2.m1HexChi_flow_nominal, ets2.mEva_flow_nominal),
    lDis=datDes.lDis[2],
    lCon=datDes.lCon[2],
    dhDis=datDes.dhDis[2],
    dhCon=datDes.dhCon[2]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={84,-98})));
  Distribution.BaseClasses.ConnectionSeries junBui4(
    redeclare package Medium = MediumWater,
    havePum=false,
    mDis_flow_nominal=datDes.mDis_flow_nominal,
    mCon_flow_nominal=datDes.mPla_flow_nominal,
    lDis=datDes.lDis[1],
    lCon=datDes.lCon[1],
    dhDis=datDes.dhDis[1],
    dhCon=datDes.dhCon[1]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-84,-230})));
protected
  constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
equation
  connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
      Line(points={{-174.8,-230},{-204,-230},{-204,-210},{-208,-210}},
                                                                   color={0,
          0,127}));
  connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
        points={{-240,-260},{-232,-260},{-232,-250}},color={0,127,255}));
  connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
    annotation (Line(points={{-252,-260},{-260,-260},{-260,-238}},color={0,
          127,255}));
  connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
      Line(points={{-174.8,-230},{-200,-230},{-200,-210},{-272,-210}},
                       color={0,0,127}));
  connect(pumpPrimarySidePlant.port_a, plant.port_b1)
    annotation (Line(points={{-220,-220},{-220,-230}},
                                                     color={0,127,255}));
  connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
        points={{-260,-200},{-260,-180},{-232,-180},{-232,-230}},
                                                              color={0,127,
          255}));
  connect(pumpSecondarySidePlant.port_a, sewageSourceAtConstTemp.ports[2])
    annotation (Line(points={{-260,-220},{-260,-242}},
                                                     color={0,127,255}));
  connect(bou.ports[1], pumpMainRLTN.port_a) annotation (Line(points={{120,
          -340},{80,-340},{80,-350}},
                                color={0,127,255}));
  connect(borFie.port_a, pumpBHS.port_b)
    annotation (Line(points={{8,-440},{40,-440}}, color={0,127,255}));
  connect(splSup10.port_2, borFie.port_b) annotation (Line(points={{-80,
          -410},{-80,-440},{-12,-440}},
                                 color={0,127,255}));
  connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-440},
          {80,-440},{80,-410}},color={0,127,255}));
  connect(splSup9.port_1, pumpMainRLTN.port_b)
    annotation (Line(points={{80,-390},{80,-370}}, color={0,127,255}));
  connect(splSup10.port_3, splSup9.port_3)
    annotation (Line(points={{-70,-400},{70,-400}}, color={0,127,255}));
  connect(bui1.ports_b1[1], ets1.port_aHeaWat) annotation (Line(points={{-320,30},
          {-320,32},{-300,32},{-300,8},{-380,8},{-380,-28.5714},{-360,-28.5714}},
                      color={0,127,255}));
  connect(ets1.port_bHeaWat, bui1.ports_a1[1]) annotation (Line(points={{-320,
          -28.5714},{-312,-28.5714},{-312,-28},{-302,-28},{-302,-60},{-400,-60},
          {-400,36},{-380,36},{-380,30}}, color={0,127,255}));
  connect(bui1.ports_b1[2], ets1.port_aChi) annotation (Line(points={{-320,34},
          {-320,28},{-304,28},{-304,12},{-384,12},{-384,-37.1429},{-360,
          -37.1429}}, color={0,127,255}));
  connect(ets1.port_bChi, bui1.ports_a1[2]) annotation (Line(points={{-320,
          -37.2857},{-312,-37.2857},{-312,-36},{-306,-36},{-306,-56},{-396,-56},
          {-396,30},{-380,30},{-380,34}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, ets1.TSetHeaWat) annotation (Line(points={{-438,240},
          {-420,240},{-420,-2.85714},{-361.429,-2.85714}}, color={0,0,127}));
  connect(TSetChiWatSup.y, ets1.TSetChiWat) annotation (Line(points={{-438,200},
          {-420,200},{-420,-8.57143},{-361.429,-8.57143}}, color={0,0,127}));
  connect(bui2.ports_b1[1], ets2.port_aHeaWat) annotation (Line(points={{360,170},
          {400,170},{400,60},{300,60},{300,92},{320,92},{320,91.4286}},
        color={0,127,255}));
  connect(ets2.port_bHeaWat, bui2.ports_a1[1]) annotation (Line(points={{360,
          91.4286},{384,91.4286},{384,148},{292,148},{292,170},{300,170}},
        color={0,127,255}));
  connect(bui2.ports_b1[2], ets2.port_aChi) annotation (Line(points={{360,174},
          {366,174},{366,168},{394,168},{394,66},{306,66},{306,82.8571},{320,
          82.8571}}, color={0,127,255}));
  connect(ets2.port_bChi, bui2.ports_a1[2]) annotation (Line(points={{360,
          82.7143},{370,82.7143},{370,82},{388,82},{388,154},{296,154},{296,170},
          {300,170},{300,174}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, ets2.TSetHeaWat) annotation (Line(points={{-438,240},
          {288,240},{288,117.143},{318.571,117.143}}, color={0,0,127}));
  connect(TSetChiWatSup.y, ets2.TSetChiWat) annotation (Line(points={{-438,200},
          {284,200},{284,111.429},{318.571,111.429}}, color={0,0,127}));
  connect(bui3.ports_b1[1], ets3.port_aHeaWat) annotation (Line(points={{360,-30},
          {400,-30},{400,-140},{300,-140},{300,-108.571},{320,-108.571}},
        color={0,127,255}));
  connect(ets3.port_bHeaWat, bui3.ports_a1[1]) annotation (Line(points={{360,
          -108.571},{384,-108.571},{384,-54},{288,-54},{288,-30},{300,-30}},
        color={0,127,255}));
  connect(bui3.ports_b1[2], ets3.port_aChi) annotation (Line(points={{360,-26},
          {360,-34},{394,-34},{394,-134},{306,-134},{306,-117.143},{320,
          -117.143}}, color={0,127,255}));
  connect(ets3.port_bChi, bui3.ports_a1[2]) annotation (Line(points={{360,
          -117.286},{368,-117.286},{368,-118},{388,-118},{388,-50},{292,-50},{
          292,-30},{300,-30},{300,-26}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, ets3.TSetHeaWat) annotation (Line(points={{-438,240},
          {288,240},{288,-82.8571},{318.571,-82.8571}}, color={0,0,127}));
  connect(TSetChiWatSup.y, ets3.TSetChiWat) annotation (Line(points={{-438,200},
          {284,200},{284,-88},{302,-88},{302,-88.5714},{318.571,-88.5714}},
        color={0,0,127}));
  connect(junBui1.port_conSup, ets1.port_a) annotation (Line(points={{-94,-30},
          {-260,-30},{-260,-50},{-370,-50},{-370,-20},{-360,-20}},color={0,127,255}));
  connect(ets1.port_b,junBui1.port_conRet)  annotation (Line(points={{-320.143,
          -20},{-100,-20},{-100,-22},{-94,-22},{-94,-24}},
                                                      color={0,127,255}));
  connect(junBui4.port_conSup, plant.port_a1) annotation (Line(points={{-94,
          -230},{-100,-230},{-100,-260},{-220,-260},{-220,-250}}, color={0,127,
          255}));
  connect(pumpPrimarySidePlant.port_b, junBui4.port_conRet) annotation (Line(
        points={{-220,-200},{-220,-180},{-100,-180},{-100,-224},{-94,-224}},
        color={0,127,255}));
  connect(junBui1.port_disOut, junBui2.port_disInl) annotation (Line(points={{
          -84,-20},{-84,220},{84,220},{84,112}}, color={0,127,255}));
  connect(junBui2.port_disOut, junBui3.port_disInl) annotation (Line(points={{
          84,92},{84,48},{88,48},{88,2},{84,2},{84,-88}}, color={0,127,255}));
  connect(junBui4.port_disOut, junBui1.port_disInl) annotation (Line(points={{
          -84,-220},{-84,-176},{-88,-176},{-88,-130},{-84,-130},{-84,-40}},
        color={0,127,255}));
  connect(junBui3.port_disOut, pumpMainRLTN.port_a) annotation (Line(points={{
          84,-108},{84,-230},{80,-230},{80,-350}}, color={0,127,255}));
  connect(splSup10.port_1, junBui4.port_disInl) annotation (Line(points={{-80,
          -390},{-80,-316},{-80,-240},{-84,-240}}, color={0,127,255}));
  connect(junBui2.port_conSup, ets2.port_a) annotation (Line(points={{94,102},{
          208,102},{208,100},{320,100}}, color={0,127,255}));
  connect(ets2.port_b, junBui2.port_conRet) annotation (Line(points={{359.857,
          100},{380,100},{380,40},{100,40},{100,96},{94,96}}, color={0,127,255}));
  connect(junBui3.port_conSup, ets3.port_a) annotation (Line(points={{94,-98},{
          208,-98},{208,-100},{320,-100}}, color={0,127,255}));
  connect(ets3.port_b, junBui3.port_conRet) annotation (Line(points={{359.857,
          -100},{380,-100},{380,-130},{100,-130},{100,-104},{94,-104}}, color={
          0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-480,-500},{480,
            500}}), graphics={
            Text(
          extent={{-382,-332},{-250,-358}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Simulation requires (and is faster with)
Hidden.AvoidDoubleComputation=true;
Advanced.SparseActivate=true")}),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
    Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
end RN_BaseModel_bck;
