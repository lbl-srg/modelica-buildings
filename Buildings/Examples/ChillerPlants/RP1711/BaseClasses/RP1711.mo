within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
partial model RP1711 "Chiller plant model with RP1711 controller"
  extends
    Buildings.Examples.ChillerPlants.RP1711.BaseClasses.PartialChillerPlant(
      mulSum(nin=2));

  Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon(
    chiDesCap={6000,6000},
    chiMinCap={1000,1000},
    have_WSE=false,
    nSenChiWatPum=1,
    have_fixSpeConWatPum=true,
    totSta=3,
    staVec={0,1,2},
    desConWatPumSpe={0,0.5,0.75},
    desConWatPumNum={0,2,2},
    towCelOnSet={0,2,2},
    nTowCel=2,
    dpChiWatPumMax={100000,100000})
    annotation (Placement(transformation(extent={{-260,240},{-220,360}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold chiWatIso[2](t=fill(0.025, 2), h=
       fill(0.005, 2)) "Chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-400,560},{-380,580}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold conWatIso[2](t=fill(0.025, 2), h=
       fill(0.005, 2)) "Condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-400,530},{-380,550}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold chiSta[2](t=fill(1, 2), h=fill(
        0.5, 2)) "Chiller status"
    annotation (Placement(transformation(extent={{-400,470},{-380,490}})));
  Controls.OBC.CDL.Logical.Sources.Constant con[2](k=fill(true, 2))
    "Constant true"
    annotation (Placement(transformation(extent={{-400,350},{-380,370}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold conWatPumSta[2](t=fill(0.01, 2),
      h=fill(0.005, 2)) "Condenser water pump status"
    annotation (Placement(transformation(extent={{-400,390},{-380,410}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-570,270},{-550,290}}),
        iconTransformation(extent={{-168,134},{-148,154}})));
  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-520,270},{-500,290}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[2] "Boolean to real"
    annotation (Placement(transformation(extent={{-40,430},{-20,450}})));
  Controls.OBC.CDL.Continuous.Product pro2[2]
    "Tower cells isolation valve position setpoint"
    annotation (Placement(transformation(extent={{20,450},{40,470}})));
  Controls.OBC.CDL.Continuous.Product pro3[2] "Tower fan speed setpoint"
    annotation (Placement(transformation(extent={{20,520},{40,540}})));
  Modelica.Blocks.Routing.RealPassThrough TWetBul(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0)) "Outdoor wet bulb temperature"
    annotation (Placement(transformation(extent={{-520,310},{-500,330}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold chiWatPumSta[2](t=fill(0.01, 2),
      h=fill(0.005, 2)) "Chilled water pump status"
    annotation (Placement(transformation(extent={{-400,130},{-380,150}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold towSta[2](t=fill(1, 2), h=fill(
        0.5, 2)) "Cooling tower status"
    annotation (Placement(transformation(extent={{-400,200},{-380,220}})));
  Controls.OBC.CDL.Continuous.Sources.Constant conWatLev(final k=0.9)
    "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-400,230},{-380,250}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2] "Boolean to real"
    annotation (Placement(transformation(extent={{-260,140},{-240,160}})));
  Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=2)
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar(p=1e-5, k=1)
    annotation (Placement(transformation(extent={{-180,140},{-160,160}})));
  Controls.OBC.CDL.Continuous.Division div2
    annotation (Placement(transformation(extent={{-110,150},{-90,170}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(nout=2)
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Controls.OBC.CDL.Continuous.Product pro1[2] "Current chiller load"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep2(final nout=2)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-40,350},{-20,370}})));
equation
  connect(chwIsoVal1.y_actual, chiWatIso[1].u) annotation (Line(points={{235,
          317},{100,317},{100,600},{-480,600},{-480,570},{-402,570}}, color={0,
          0,127}));
  connect(chwIsoVal2.y_actual, chiWatIso[2].u) annotation (Line(points={{235,227},
          {220,227},{220,236},{100,236},{100,600},{-480,600},{-480,570},{-402,
          570}},      color={0,0,127}));
  connect(chiWatIso.y, chiPlaCon.uChiWatReq) annotation (Line(points={{-378,570},
          {-280,570},{-280,352},{-264,352}}, color={255,0,255}));
  connect(chiWatIso.y, chiPlaCon.uConWatReq) annotation (Line(points={{-378,570},
          {-280,570},{-280,348},{-264,348}}, color={255,0,255}));
  connect(chiWatIso.y, chiPlaCon.uChiIsoVal) annotation (Line(points={{-378,570},
          {-280,570},{-280,340},{-264,340}}, color={255,0,255}));
  connect(cwIsoVal1.y_actual, conWatIso[1].u) annotation (Line(points={{385,347},
          {400,347},{400,370},{110,370},{110,610},{-500,610},{-500,540},{-402,
          540}}, color={0,0,127}));
  connect(cwIsoVal2.y_actual, conWatIso[2].u) annotation (Line(points={{385,257},
          {400,257},{400,280},{110,280},{110,610},{-500,610},{-500,540},{-402,
          540}}, color={0,0,127}));
  connect(conWatIso.y, chiPlaCon.uChiConIsoVal) annotation (Line(points={{-378,
          540},{-290,540},{-290,356},{-264,356}}, color={255,0,255}));
  connect(senRelPre.p_rel, chiPlaCon.dpChiWat_remote[1]) annotation (Line(
        points={{330,-89},{330,-100},{-480,-100},{-480,332},{-264,332}}, color=
          {0,0,127}));
  connect(senVolFlo.V_flow, chiPlaCon.VChiWat_flow) annotation (Line(points={{
          429,180},{-470,180},{-470,328},{-264,328}}, color={0,0,127}));
  connect(chi2.P, chiSta[2].u) annotation (Line(points={{341,253},{352,253},{
          352,270},{90,270},{90,508},{-480,508},{-480,480},{-402,480}}, color={
          0,0,127}));
  connect(chiSta.y, chiPlaCon.uChi) annotation (Line(points={{-378,480},{-300,
          480},{-300,324},{-264,324}}, color={255,0,255}));
  connect(chiWatRet.T, chiPlaCon.TChiWatRet) annotation (Line(points={{429,60},
          {400,60},{400,188},{-460,188},{-460,312},{-264,312}}, color={0,0,127}));
  connect(chiWatSupTem1.T, chiPlaCon.TChiWatSup) annotation (Line(points={{211,60},
          {300,60},{300,196},{-450,196},{-450,304},{-264,304}},     color={0,0,
          127}));
  connect(conWatRetTem.T, chiPlaCon.TConWatRet) annotation (Line(points={{409,
          520},{380,520},{380,386},{-440,386},{-440,308},{-264,308}}, color={0,
          0,127}));
  connect(con.y, chiPlaCon.uChiAva) annotation (Line(points={{-378,360},{-370,
          360},{-370,292},{-264,292}}, color={255,0,255}));
  connect(chwIsoVal1.y_actual, chiPlaCon.uChiWatIsoVal[1]) annotation (Line(
        points={{235,317},{100,317},{100,600},{-360,600},{-360,284},{-264,284}},
        color={0,0,127}));
  connect(chwIsoVal2.y_actual, chiPlaCon.uChiWatIsoVal[2]) annotation (Line(
        points={{235,227},{220,227},{220,236},{100,236},{100,600},{-360,600},{
          -360,284},{-264,284}}, color={0,0,127}));
  connect(conWatPum1.y_actual, chiPlaCon.uConWatPumSpe[1]) annotation (Line(
        points={{207,429},{207,420},{-350,420},{-350,276},{-264,276}}, color={0,
          0,127}));
  connect(conWatPum2.y_actual, chiPlaCon.uConWatPumSpe[2]) annotation (Line(
        points={{267,429},{267,420},{-350,420},{-350,276},{-264,276}}, color={0,
          0,127}));
  connect(conWatPum1.y_actual, conWatPumSta[1].u) annotation (Line(points={{207,
          429},{207,420},{-410,420},{-410,400},{-402,400}}, color={0,0,127}));
  connect(conWatPum2.y_actual, conWatPumSta[2].u) annotation (Line(points={{267,
          429},{267,420},{-410,420},{-410,400},{-402,400}}, color={0,0,127}));
  connect(conWatPumSta.y, chiPlaCon.uConWatPum) annotation (Line(points={{-378,
          400},{-340,400},{-340,272},{-264,272}}, color={255,0,255}));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-560,280},{-522,280}},
      color={255,204,51},
      thickness=0.5));
  connect(TOut.y, chiPlaCon.TOut) annotation (Line(points={{-499,280},{-360,280},
          {-360,268},{-264,268}}, color={0,0,127}));
  connect(conWatSupTem.T, chiPlaCon.TConWatSup) annotation (Line(points={{271,
          520},{300,520},{300,500},{-330,500},{-330,256},{-264,256}}, color={0,
          0,127}));
  connect(chiPlaCon.yChiWatIsoVal[1], chwIsoVal1.y) annotation (Line(points={{
          -216,286},{-140,286},{-140,390},{130,390},{130,340},{240,340},{240,
          322}}, color={0,0,127}));
  connect(chiPlaCon.yChiWatIsoVal[2], chwIsoVal2.y) annotation (Line(points={{
          -216,286},{-140,286},{-140,390},{130,390},{130,250},{240,250},{240,
          232}}, color={0,0,127}));
  connect(chiPlaCon.yMinValPosSet, valByp.y) annotation (Line(points={{-216,280},
          {-140,280},{-140,40},{330,40},{330,32}}, color={0,0,127}));
  connect(chiPlaCon.yTowCel, booToRea2.u) annotation (Line(points={{-216,258},{
          -150,258},{-150,440},{-42,440}}, color={255,0,255}));
  connect(booToRea2.y, pro2.u2) annotation (Line(points={{-18,440},{0,440},{0,
          454},{18,454}}, color={0,0,127}));
  connect(chiPlaCon.yTowCelIsoVal, pro2.u1) annotation (Line(points={{-216,264},
          {-160,264},{-160,466},{18,466}}, color={0,0,127}));
  connect(pro2[1].y, towIsoVal1.y) annotation (Line(points={{42,460},{80,460},{
          80,640},{380,640},{380,632}}, color={0,0,127}));
  connect(pro2[2].y, towIsoVal2.y) annotation (Line(points={{42,460},{80,460},{
          80,570},{380,570},{380,562}}, color={0,0,127}));
  connect(booToRea2.y, pro3.u2) annotation (Line(points={{-18,440},{0,440},{0,
          524},{18,524}}, color={0,0,127}));
  connect(chiPlaCon.yTowFanSpe, pro3.u1) annotation (Line(points={{-216,252},{
          -170,252},{-170,536},{18,536}}, color={0,0,127}));
  connect(pro3[1].y, cooTow1.y) annotation (Line(points={{42,530},{70,530},{70,
          650},{350,650},{350,628},{342,628}}, color={0,0,127}));
  connect(pro3[2].y, cooTow2.y) annotation (Line(points={{42,530},{70,530},{70,
          580},{350,580},{350,558},{342,558}}, color={0,0,127}));
  connect(weaBus.TWetBul, TWetBul.u) annotation (Line(
      points={{-560,280},{-540,280},{-540,320},{-522,320}},
      color={255,204,51},
      thickness=0.5));
  connect(TWetBul.y, cooTow1.TAir) annotation (Line(points={{-499,320},{-490,
          320},{-490,590},{360,590},{360,624},{342,624}}, color={0,0,127}));
  connect(TWetBul.y, cooTow2.TAir) annotation (Line(points={{-499,320},{-490,
          320},{-490,590},{360,590},{360,554},{342,554}}, color={0,0,127}));
  connect(chiWatPum1.y_actual, chiWatPumSta[1].u) annotation (Line(points={{207,117},
          {207,110},{-410,110},{-410,140},{-402,140}},      color={0,0,127}));
  connect(chiWatPum2.y_actual, chiWatPumSta[2].u) annotation (Line(points={{267,117},
          {267,110},{-410,110},{-410,140},{-402,140}},      color={0,0,127}));
  connect(chiWatPumSta.y, chiPlaCon.uChiWatPum) annotation (Line(points={{-378,
          140},{-290,140},{-290,344},{-264,344}}, color={255,0,255}));
  connect(towIsoVal1.y_actual, chiPlaCon.uIsoVal[1]) annotation (Line(points={{
          375,627},{366,627},{366,660},{-310,660},{-310,250},{-264,250}}, color=
         {0,0,127}));
  connect(towIsoVal2.y_actual, chiPlaCon.uIsoVal[2]) annotation (Line(points={{
          375,557},{366,557},{366,660},{-310,660},{-310,254},{-264,254}}, color=
         {0,0,127}));
  connect(cooTow1.PFan, towSta[1].u) annotation (Line(points={{319,628},{-430,
          628},{-430,210},{-402,210}}, color={0,0,127}));
  connect(cooTow2.PFan, towSta[2].u) annotation (Line(points={{319,558},{300,
          558},{300,628},{-430,628},{-430,210},{-402,210}}, color={0,0,127}));
  connect(towSta.y, chiPlaCon.uTowSta) annotation (Line(points={{-378,210},{
          -280,210},{-280,244},{-264,244}}, color={255,0,255}));
  connect(conWatLev.y, chiPlaCon.watLev) annotation (Line(points={{-378,240},{
          -330,240},{-330,248},{-264,248}}, color={0,0,127}));
  connect(chiPlaCon.yChiPumSpe[1], chiWatPum1.y) annotation (Line(points={{-216,
          344},{80,344},{80,146},{220,146},{220,128},{212,128}}, color={0,0,127}));
  connect(chiPlaCon.yChiPumSpe[2], chiWatPum2.y) annotation (Line(points={{-216,
          344},{80,344},{80,146},{280,146},{280,128},{272,128}}, color={0,0,127}));
  connect(chiPlaCon.yConWatPumSpe[1], conWatPum1.y) annotation (Line(points={{
          -216,312},{120,312},{120,460},{220,460},{220,440},{212,440}}, color={
          0,0,127}));
  connect(chiPlaCon.yConWatPumSpe[2], conWatPum2.y) annotation (Line(points={{
          -216,312},{120,312},{120,460},{280,460},{280,440},{272,440}}, color={
          0,0,127}));
  connect(chiPlaCon.yHeaPreConVal[1], cwIsoVal1.y) annotation (Line(points={{
          -216,318},{70,318},{70,380},{380,380},{380,352}}, color={0,0,127}));
  connect(chiPlaCon.yHeaPreConVal[2], cwIsoVal2.y) annotation (Line(points={{
          -216,318},{70,318},{70,290},{380,290},{380,262}}, color={0,0,127}));
  connect(chi1.P, chiSta[1].u) annotation (Line(points={{341,343},{350,343},{
          350,360},{90,360},{90,508},{-480,508},{-480,480},{-402,480}}, color={
          0,0,127}));
  connect(chiPlaCon.yChi[2], chi2.on) annotation (Line(points={{-216,332},{-130,
          332},{-130,260},{280,260},{280,247},{318,247}}, color={255,0,255}));
  connect(chiPlaCon.yChi[1], chi1.on) annotation (Line(points={{-216,332},{-130,
          332},{-130,260},{280,260},{280,337},{318,337}}, color={255,0,255}));
  connect(chiWatRet.T, demLimSupTem.u1) annotation (Line(points={{429,60},{400,
          60},{400,188},{-80,188},{-80,240},{-72,240}}, color={0,0,127}));
  connect(senMasFlo.m_flow, div1.u2) annotation (Line(points={{429,120},{420,
          120},{420,204},{-120,204},{-120,214},{-112,214}}, color={0,0,127}));
  connect(chiPlaCon.yChiDem, mulSum.u[1:2]) annotation (Line(points={{-216,338},
          {-200,338},{-200,220},{-182,220}}, color={0,0,127}));
  connect(chiPlaCon.yReaChiDemLim, reaChiDem.u) annotation (Line(points={{-216,
          292},{-120,292},{-120,280},{-42,280}}, color={255,0,255}));
  connect(chiSta.y, booToRea1.u) annotation (Line(points={{-378,480},{-300,480},
          {-300,150},{-262,150}}, color={255,0,255}));
  connect(booToRea1.y, mulSum1.u)
    annotation (Line(points={{-238,150},{-222,150}}, color={0,0,127}));
  connect(mulSum1.y, addPar.u)
    annotation (Line(points={{-198,150},{-182,150}}, color={0,0,127}));
  connect(addPar.y, div2.u2) annotation (Line(points={{-158,150},{-120,150},{
          -120,154},{-112,154}}, color={0,0,127}));
  connect(curChiLoa.y, div2.u1) annotation (Line(points={{532,120},{540,120},{
          540,0},{-130,0},{-130,166},{-112,166}}, color={0,0,127}));
  connect(div2.y, reaScaRep1.u)
    annotation (Line(points={{-88,160},{-62,160}}, color={0,0,127}));
  connect(reaScaRep1.y, pro1.u1) annotation (Line(points={{-38,160},{-20,160},{
          -20,136},{-2,136}}, color={0,0,127}));
  connect(booToRea1.y, pro1.u2) annotation (Line(points={{-238,150},{-230,150},
          {-230,124},{-2,124}}, color={0,0,127}));
  connect(pro1.y, chiPlaCon.uChiLoa) annotation (Line(points={{22,130},{40,130},
          {40,100},{-320,100},{-320,296},{-264,296}}, color={0,0,127}));
  connect(chiPlaCon.TChiWatSupSet, reaScaRep2.u) annotation (Line(points={{-216,
          356},{-120,356},{-120,360},{-42,360}}, color={0,0,127}));
  connect(reaScaRep2.y, chiWatSupTem.u1) annotation (Line(points={{-18,360},{0,
          360},{0,288},{18,288}}, color={0,0,127}));
  connect(chiWatSupTem[1].y, chi1.TSet) annotation (Line(points={{42,280},{60,
          280},{60,331},{318,331}}, color={0,0,127}));
  connect(chiWatSupTem[2].y, chi2.TSet) annotation (Line(points={{42,280},{60,
          280},{60,241},{318,241}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-580,-660},
            {580,660}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-580,-660},{580,660}})));
end RP1711;
