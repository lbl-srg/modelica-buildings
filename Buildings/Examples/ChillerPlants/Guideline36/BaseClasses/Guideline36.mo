within Buildings.Examples.ChillerPlants.Guideline36.BaseClasses;
model Guideline36 "Chiller plant model with Guideline36 controller"

  extends Buildings.Examples.ChillerPlants.Guideline36.BaseClasses.PartialChillerPlant(
    senVolFlo(tau=10),
    chi1(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    chi2(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    chwIsoVal1(y_start=0),
    chwIsoVal2(y_start=0),
    cwIsoVal1(y_start=0),
    cwIsoVal2(y_start=0));
//   parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal = 10
//     "Nominal mass flow rate in chilled water loop";
//   parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = 10
//     "Nominal mass flow rate in condenser water loop";
  parameter Modelica.Units.SI.TemperatureDifference dTChi = 7
    "Nominal chilled water supply and return temperature difference";
  parameter Real speChe=0.005
    "Lower threshold value to check fan or pump speed";
  parameter Real loaChe=0.1
    "Load threshold value to check if chiller or cooling tower is running";
  parameter Real posChe=0.001
    "Position threshold value to check if the valve is open";

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput chiPlaReq
    "Number of chiller plant cooling requests"
    annotation (Placement(transformation(extent={{-600,-210},{-560,-170}}),
        iconTransformation(extent={{-200,-190},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput TChiWatSupResReq
    "Chilled water supply temperature setpoint reset request"
    annotation (Placement(transformation(extent={{-600,-180},{-560,-140}}),
        iconTransformation(extent={{-200,-150},{-160,-110}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller chiPlaCon(
    nChi=2,
    chiTyp={Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.PositiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.ChillersAndStages.PositiveDisplacement},
    TChiWatSupMin={278.15,278.15},
    dTChiMinLif={12,12},
    dTChiMaxLif={18,18},
    nChiWatPum=2,
    nConWatPum=2,
    final plaStaMat=[0,0; 1,0; 1,1],
    final staMat=[1,0; 1,1],
    cooTowAppDes=2,
    nPum_nominal=2,
    final dpChiWatMax={160000},
    final chiDesCap={chiDesCap,chiDesCap},
    final chiMinCap={chiDesCap*0.1,chiDesCap*0.1},
    final have_WSE=false,
    final nSenChiWatPum=1,
    final have_fixSpeConWatPum=true,
    final totSta=3,
    final desConWatPumSpe={0,0.5,0.75},
    final desConWatPumNum={0,2,2},
    final towCelOnSet={0,2,2},
    final nTowCel=2,
    final TiHeaPreCon=100,
    final minFloSet={0.1*mChi_flow_nominal/1000,0.1*mChi_flow_nominal/1000},
    final maxFloSet={0.75*mChi_flow_nominal/1000,0.75*mChi_flow_nominal/1000},
    final TiMinFloBypCon=100,
    final VChiWat_flow_nominal=mChi_flow_nominal/1000,
    final TiChiWatPum=100,
    TConWatSup_nominal={293.15,293.15},
    TConWatRet_nominal={303.15,303.15},
    final TiSupCon=100,
    watLevMin=0.7,
    watLevMax=1,
    final speChe=speChe)
    "Chiller plant controller"
    annotation (Placement(transformation(extent={{-140,0},{-100,160}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold chiWatIso[2](
    final t=fill(posChe, 2),
    final h=fill(0.5*posChe, 2))
    "Chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-400,320},{-380,340}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold chiSta[2](
    final t=fill(loaChe, 2),
    final h=fill(0.5*loaChe, 2))
    "Chiller status, check if the chiller load is greater than zero "
    annotation (Placement(transformation(extent={{-400,220},{-380,240}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold conWatPumSta[2](
    final t=fill(speChe, 2),
    final h=fill(0.5*speChe, 2))
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{-400,140},{-380,160}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-570,30},{-550,50}}),
        iconTransformation(extent={{-120,160},{-100,180}})));
  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-520,30},{-500,50}})));
  Modelica.Blocks.Routing.RealPassThrough TWetBul(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0)) "Outdoor wet bulb temperature"
    annotation (Placement(transformation(extent={{-520,70},{-500,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold chiWatPumSta[2](
    final t=fill(speChe, 2),
    final h=fill(0.5*speChe, 2))
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-400,-110},{-380,-90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold towSta[2](
    final t=fill(loaChe, 2),
    final h=fill(0.5*loaChe, 2))
    "Cooling tower status"
    annotation (Placement(transformation(extent={{-360,-30},{-340,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conWatLev(
    final k=0.9) "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-520,-10},{-500,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b portCooCoiSup(
    redeclare package Medium =MediumW)
    "Cooling coil loop supply"
    annotation (Placement(transformation(extent={{190,-370},{210,-350}}),
        iconTransformation(extent={{-130,-210},{-110,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a portCooCoiRet(
    redeclare package Medium =MediumW)
    "Cooling coil loop return"
    annotation (Placement(transformation(extent={{430,-370},{450,-350}}),
        iconTransformation(extent={{110,-210},{130,-190}})));
  Buildings.Templates.Components.Controls.StatusEmulator pre2[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-280,320},{-260,340}})));
  Buildings.Templates.Components.Controls.StatusEmulator pre4[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-260,220},{-240,240}})));
  Buildings.Templates.Components.Controls.StatusEmulator pre5[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-260,-30},{-240,-10}})));
  Buildings.Templates.Components.Controls.StatusEmulator pre6[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-360,-110},{-340,-90}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(120, 2))
    "Sample value and break algebric loop"
    annotation (Placement(transformation(extent={{-460,300},{-440,320}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaEna(final k=true)
    "Plant enable"
    annotation (Placement(transformation(extent={{-280,150},{-260,170}})));

protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity Cp = 4198
    "Water specific heat capacity";
  final parameter Modelica.Units.SI.HeatFlowRate chiDesCap = mChi_flow_nominal*dTChi*Cp
    "Chiller design capacity";
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2](
    final realTrue=fill(0.9,2))
    "Fixed condenser water pump speed"
    annotation (Placement(transformation(extent={{40,150},{60,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[2](
    final realTrue=fill(1, 2))
    "Tower cell enabling status"
    annotation (Placement(transformation(extent={{20,300},{40,320}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul[2] "Cell Speed"
    annotation (Placement(transformation(extent={{140,280},{160,300}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator towSpe(nout=2)
    "Tower cell speed"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator chiPumSpe(nout=2)
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1[2] "Chilled water pump speed"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2[2]
    "Convert chilled water pump status"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

equation
  connect(chwIsoVal1.y_actual, chiWatIso[1].u) annotation (Line(points={{235,77},
          {100,77},{100,360},{-480,360},{-480,330},{-402,330}}, color={0,0,127}));
  connect(chwIsoVal2.y_actual, chiWatIso[2].u) annotation (Line(points={{235,-13},
          {220,-13},{220,-4},{100,-4},{100,360},{-480,360},{-480,330},{-402,330}},
          color={0,0,127}));
  connect(chi2.P, chiSta[2].u) annotation (Line(points={{341,13},{346,13},{346,
          30},{90,30},{90,268},{-480,268},{-480,230},{-402,230}}, color={0,0,127}));
  connect(chiWatSupTem.T, chiPlaCon.TChiWatSup) annotation (Line(points={{211,-180},
          {300,-180},{300,-44},{-450,-44},{-450,96},{-144,96}},       color={0,0,127}));
  connect(conWatPum1.y_actual, conWatPumSta[1].u) annotation (Line(points={{207,199},
          {207,186},{-410,186},{-410,150},{-402,150}}, color={0,0,127}));
  connect(conWatPum2.y_actual, conWatPumSta[2].u) annotation (Line(points={{267,199},
          {267,186},{-410,186},{-410,150},{-402,150}}, color={0,0,127}));
  connect(weaBus.TDryBul, TOut.u)
          annotation (Line(points={{-559.95,40.05},{-540,40.05},{-540,40},{-522,
          40}}, color={255,204,51}, thickness=0.5));
  connect(TOut.y, chiPlaCon.TOut) annotation (Line(points={{-499,40},{-440,40},{
          -440,32},{-144,32}},    color={0,0,127}));
  connect(weaBus.TWetBul, TWetBul.u) annotation (Line(points={{-559.95,40.05},{
          -540,40.05},{-540,80},{-522,80}}, color={255,204,51},thickness=0.5));
  connect(TWetBul.y, cooTow2.TAir) annotation (Line(points={{-499,80},{-490,80},
          {-490,350},{360,350},{360,314},{342,314}},      color={0,0,127}));
  connect(chiWatPum1.y_actual, chiWatPumSta[1].u) annotation (Line(points={{207,
          -107},{207,-164},{-410,-164},{-410,-100},{-402,-100}}, color={0,0,127}));
  connect(chiWatPum2.y_actual, chiWatPumSta[2].u) annotation (Line(points={{267,
          -107},{267,-164},{-410,-164},{-410,-100},{-402,-100}}, color={0,0,127}));
  connect(cooTow1.PFan, towSta[1].u) annotation (Line(points={{319,388},{-430,388},
          {-430,-20},{-362,-20}},      color={0,0,127}));
  connect(cooTow2.PFan, towSta[2].u) annotation (Line(points={{319,318},{300,318},
          {300,388},{-430,388},{-430,-20},{-362,-20}},      color={0,0,127}));
  connect(conWatLev.y, chiPlaCon.watLev) annotation (Line(points={{-498,0},{-380,
          0},{-380,8},{-144,8}},            color={0,0,127}));
  connect(chiPlaCon.yConWatIsoVal[1], cwIsoVal1.y) annotation (Line(points={{-96,89},
          {70,89},{70,118},{360,118},{360,112}},     color={0,0,127}));
  connect(chiPlaCon.yConWatIsoVal[2], cwIsoVal2.y) annotation (Line(points={{-96,91},
          {70,91},{70,50},{360,50},{360,22}},     color={0,0,127}));
  connect(chi1.P, chiSta[1].u) annotation (Line(points={{341,103},{346,103},{
          346,116},{90,116},{90,268},{-480,268},{-480,230},{-402,230}}, color={
          0,0,127}));
  connect(conWatSupTem.T, chiPlaCon.TConWatSup) annotation (Line(points={{271,280},
          {280,280},{280,260},{-330,260},{-330,18},{-144,18}}, color={0,0,127}));
  connect(TWetBul.y, cooTow1.TAir) annotation (Line(points={{-499,80},{-490,80},
          {-490,350},{360,350},{360,384},{342,384}}, color={0,0,127}));
  connect(chiPlaCon.yMinValPosSet, valByp.y) annotation (Line(points={{-96,54},
          {0,54},{0,-200},{330,-200},{330,-208}},       color={0,0,127}));
  connect(jun10.port_2, portCooCoiSup) annotation (Line(
      points={{200,-230},{200,-360}},
      color={0,127,255},
      thickness=1));
  connect(res.port_a, portCooCoiRet) annotation (Line(
      points={{440,-310},{440,-360}},
      color={0,127,255},
      thickness=1));
  connect(jun10.port_2, senRelPre.port_a) annotation (Line(
      points={{200,-230},{200,-320},{320,-320}},
      color={0,127,255},
      thickness=1));
  connect(senRelPre.port_b, res.port_a) annotation (Line(
      points={{340,-320},{440,-320},{440,-310}},
      color={0,127,255},
      thickness=1));
  connect(TChiWatSupResReq, chiPlaCon.TChiWatSupResReq) annotation (Line(points={{-580,
          -160},{-320,-160},{-320,52},{-144,52}}, color={255,127,0}));
  connect(chiPlaReq, chiPlaCon.chiPlaReq) annotation (Line(points={{-580,-190},{
          -300,-190},{-300,48},{-144,48}}, color={255,127,0}));
  connect(chiWatIso.y, pre2.y1)
    annotation (Line(points={{-378,330},{-282,330}}, color={255,0,255}));
  connect(chiSta.y, pre4.y1)
    annotation (Line(points={{-378,230},{-262,230}}, color={255,0,255}));
  connect(towSta.y, pre5.y1)
    annotation (Line(points={{-338,-20},{-262,-20}}, color={255,0,255}));
  connect(chiWatRet.T, chiPlaCon.TChiWatRet) annotation (Line(points={{429,-180},
          {400,-180},{400,-50},{-470,-50},{-470,104},{-144,104}}, color={0,0,127}));
  connect(towIsoVal1.y_actual, chiPlaCon.uIsoVal[1]) annotation (Line(points={{375,387},
          {366,387},{366,420},{-310,420},{-310,11},{-144,11}}, color={0,0,127}));
  connect(towIsoVal2.y_actual, chiPlaCon.uIsoVal[2]) annotation (Line(points={{375,317},
          {366,317},{366,420},{-310,420},{-310,13},{-144,13}}, color={0,0,127}));
  connect(pre5.y1_actual, chiPlaCon.uTowSta) annotation (Line(points={{-238,-20},{-190,-20},
          {-190,4},{-144,4}},      color={255,0,255}));
  connect(conWatPumSta.y, chiPlaCon.uConWatPum) annotation (Line(points={{-378,150},
          {-340,150},{-340,40},{-144,40}},      color={255,0,255}));
  connect(pre2.y1_actual, chiPlaCon.uChiWatReq) annotation (Line(points={{-258,330},{-160,
          330},{-160,152},{-144,152}},      color={255,0,255}));
  connect(pre2.y1_actual, chiPlaCon.uConWatReq) annotation (Line(points={{-258,330},{-160,
          330},{-160,148},{-144,148}},      color={255,0,255}));
  connect(pre4.y1_actual, chiPlaCon.uChi) annotation (Line(points={{-238,230},{-180,230},
          {-180,120},{-144,120}}, color={255,0,255}));
  connect(chiWatPumSta.y, pre6.y1)
    annotation (Line(points={{-378,-100},{-362,-100}}, color={255,0,255}));
  connect(pre6.y1_actual, chiPlaCon.uChiWatPum) annotation (Line(points={{-338,-100},{-210,
          -100},{-210,144},{-144,144}},      color={255,0,255}));
  connect(chiPlaCon.yChi[1], chi1.on) annotation (Line(points={{-96,101},{30,
          101},{30,20},{280,20},{280,97},{318,97}},   color={255,0,255}));
  connect(chiPlaCon.yChi[2], chi2.on) annotation (Line(points={{-96,103},{30,
          103},{30,20},{280,20},{280,7},{318,7}},   color={255,0,255}));
  connect(chwIsoVal1.y_actual, zerOrdHol1[1].u) annotation (Line(points={{235,77},
          {100,77},{100,360},{-480,360},{-480,310},{-462,310}}, color={0,0,127}));
  connect(chwIsoVal2.y_actual, zerOrdHol1[2].u) annotation (Line(points={{235,-13},
          {220,-13},{220,-4},{100,-4},{100,360},{-480,360},{-480,310},{-462,310}},
        color={0,0,127}));
  connect(zerOrdHol1.y, chiPlaCon.uChiWatIsoVal) annotation (Line(points={{-438,
          310},{-360,310},{-360,56},{-144,56}}, color={0,0,127}));
  connect(chiPlaCon.yTowCelIsoVal[1], towIsoVal1.y) annotation (Line(points={{-96,43},
          {-10,43},{-10,400},{380,400},{380,392}},                 color={0,0,127}));
  connect(chiPlaCon.yTowCelIsoVal[2], towIsoVal2.y) annotation (Line(points={{-96,45},
          {-10,45},{-10,332},{380,332},{380,322}},       color={0,0,127}));
  connect(chiPlaCon.yChiWatIsoVal[1], chwIsoVal1.y) annotation (Line(points={{-96,59},
          {40,59},{40,106},{240,106},{240,82}},              color={0,0,127}));
  connect(chiPlaCon.yChiWatIsoVal[2], chwIsoVal2.y) annotation (Line(points={{-96,61},
          {40,61},{40,12},{240,12},{240,-8}},              color={0,0,127}));
  connect(senRelPre.p_rel, chiPlaCon.dpChiWat_remote[1]) annotation (Line(
        points={{330,-329},{330,-380},{-480,-380},{-480,128},{-144,128}}, color
        ={0,0,127}));
  connect(senVolFlo.V_flow, chiPlaCon.VChiWat_flow) annotation (Line(points={{429,-60},
          {380,-60},{380,-280},{-460,-280},{-460,124},{-144,124}},
        color={0,0,127}));
  connect(chiPlaCon.TChiWatSupSet[1], chi1.TSet) annotation (Line(points={{-96,131},
          {138,131},{138,91},{318,91}},      color={0,0,127}));
  connect(chiPlaCon.TChiWatSupSet[2], chi2.TSet) annotation (Line(points={{-96,133},
          {138,133},{138,1},{318,1}},      color={0,0,127}));
  connect(plaEna.y, chiPlaCon.uPlaSchEna) annotation (Line(points={{-258,160},{-220,
          160},{-220,36},{-144,36}}, color={255,0,255}));
  connect(chiPlaCon.yConWatPum, booToRea.u) annotation (Line(points={{-96,72},{
          -40,72},{-40,160},{38,160}}, color={255,0,255}));
  connect(booToRea[1].y, conWatPum1.y) annotation (Line(points={{62,160},{140,
          160},{140,220},{220,220},{220,210},{212,210}}, color={0,0,127}));
  connect(booToRea[2].y, conWatPum2.y) annotation (Line(points={{62,160},{140,
          160},{140,220},{280,220},{280,210},{272,210}}, color={0,0,127}));
  connect(conWatRetTem.T, chiPlaCon.TConWatTowRet) annotation (Line(points={{
          409,280},{400,280},{400,254},{-290,254},{-290,22},{-144,22}}, color={
          0,0,127}));
  connect(chiConWatRetTem1.T, chiPlaCon.TConWatRet[1]) annotation (Line(points={{390,111},
          {390,226},{-190,226},{-190,99},{-144,99}},              color={0,0,
          127}));
  connect(chiConWatRetTem2.T, chiPlaCon.TConWatRet[2]) annotation (Line(points={{390,21},
          {390,40},{376,40},{376,226},{-190,226},{-190,101},{-144,101}},
        color={0,0,127}));
  connect(chiPlaCon.yTowCel, booToRea1.u) annotation (Line(points={{-96,38},{-30,
          38},{-30,310},{18,310}}, color={255,0,255}));
  connect(chiPlaCon.yTowFanSpe, towSpe.u) annotation (Line(points={{-96,32},{-20,
          32},{-20,210},{18,210}}, color={0,0,127}));
  connect(booToRea1.y, mul.u1) annotation (Line(points={{42,310},{120,310},{120,
          296},{138,296}}, color={0,0,127}));
  connect(towSpe.y, mul.u2) annotation (Line(points={{42,210},{120,210},{120,284},
          {138,284}}, color={0,0,127}));
  connect(mul[1].y, cooTow1.y) annotation (Line(points={{162,290},{180,290},{180,
          408},{352,408},{352,388},{342,388}}, color={0,0,127}));
  connect(mul[2].y, cooTow2.y) annotation (Line(points={{162,290},{180,290},{180,
          340},{352,340},{352,318},{342,318}}, color={0,0,127}));
  connect(chiPlaCon.yChiWatPum, booToRea2.u) annotation (Line(points={{-96,120},
          {-50,120},{-50,-80},{-42,-80}}, color={255,0,255}));
  connect(chiPlaCon.yChiPumSpe, chiPumSpe.u) annotation (Line(points={{-96,114},
          {-60,114},{-60,-120},{-42,-120}}, color={0,0,127}));
  connect(chiPumSpe.y, mul1.u2) annotation (Line(points={{-18,-120},{40,-120},{40,
          -106},{58,-106}}, color={0,0,127}));
  connect(booToRea2.y, mul1.u1) annotation (Line(points={{-18,-80},{40,-80},{40,
          -94},{58,-94}}, color={0,0,127}));
  connect(mul1[1].y, chiWatPum1.y) annotation (Line(points={{82,-100},{100,-100},
          {100,-56},{220,-56},{220,-96},{212,-96}}, color={0,0,127}));
  connect(mul1[2].y, chiWatPum2.y) annotation (Line(points={{82,-100},{100,-100},
          {100,-56},{280,-56},{280,-96},{272,-96}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,200},
            {160,-200}}), graphics={
        Rectangle(
          extent={{-160,200},{160,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-110,52},{-110,64},{-110,86},{-90,86},{-90,76}},
          color={238,46,47},
          thickness=0.5),
        Rectangle(extent={{-60,40},{60,0}},  lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{100,34},{60,34}},  color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={75,30}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={83,30}),
        Line(points={{-60,6},{-120,6}},  color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-83,2}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-75,2}),
        Rectangle(extent={{-60,-20},{60,-60}}, lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{100,-26},{60,-26}},color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={75,-30}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={83,-30}),
        Line(points={{-60,-54},{-120,-54}}, color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-83,-58}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-75,-58}),
        Rectangle(
          extent={{-48,178},{-16,120}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-35,178},{-30,171}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-32,172},{-48,168}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,172},{-32,168}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-48,130},{-16,130}},
          color={28,108,200},
          smooth=Smooth.Bezier,
          pattern=LinePattern.DashDot),
        Rectangle(
          extent={{16,178},{48,120}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{29,178},{34,171}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,172},{16,168}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{48,172},{32,168}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{16,130},{48,130}},
          color={28,108,200},
          smooth=Smooth.Bezier,
          pattern=LinePattern.DashDot),
        Line(
          points={{-48,164},{-58,164}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-58,164},{-58,112}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-60,34},{-100,34}},
          color={238,46,47},
          thickness=0.5),
        Ellipse(
          extent={{-116,76},{-104,64}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,-28},{-100,-28}},
          color={238,46,47},
          thickness=0.5),
        Polygon(
          points={{-116,70},{-104,70},{-110,64},{-116,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-96,76},{-84,64}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-96,70},{-84,70},{-90,64},{-96,70}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,102},{32,102}},
          color={238,46,47},
          thickness=0.5),
        Line(points={{32,120},{32,102}}, color={238,46,47},
          thickness=0.5),
        Line(
          points={{-32,120},{-32,102}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-90,64},{-90,52},{-110,52}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-100,86},{-100,102}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{-100,52},{-100,10}},
          color={238,46,47},
          thickness=0.5),
        Line(points={{-58,130}}, color={0,0,0}),
        Line(
          points={{100,-26},{100,2}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{120,6},{60,6}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{120,-54},{60,-54}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-130,-104},{-130,-92},{-130,-70},{-110,-70},{-110,-80}},
          color={28,108,200},
          thickness=0.5),
        Ellipse(
          extent={{-136,-80},{-124,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-136,-86},{-124,-86},{-130,-92},{-136,-86}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-116,-80},{-104,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-116,-86},{-104,-86},{-110,-92},{-116,-86}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-110,-92},{-110,-104},{-130,-104}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-120,-70},{-120,-54}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-120,-104},{-120,-200}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-120,6},{-120,-54}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{120,6},{120,-200}},
          color={28,108,200},
          thickness=0.5),
        Line(points={{120,-120},{-120,-120}}, color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{-4,7},{-4,1},{4,4},{-4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-3,-124}),
        Polygon(
          points={{4,7},{4,1},{-4,4},{4,7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={5,-124}),
        Text(
          extent={{-22,30},{24,12}},
          textColor={0,0,0},
          textString="CH1"),
        Text(
          extent={{-22,-28},{24,-46}},
          textColor={0,0,0},
          textString="CH2"),
        Line(
          points={{-100,-28},{-100,2}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{100,34},{100,10}},
          color={238,46,47},
          thickness=0.5),
        Text(
          extent={{-60,200},{52,264}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-58,112},{-34,112}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{6,112},{-30,112}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{6,112},{6,164},{16,164}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{6,112},{28,112}},
          color={238,46,47},
          thickness=0.5),
        Line(
          points={{100,34},{100,112},{34,112}},
          color={238,46,47},
          thickness=0.5)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-560,-440},{560,440}})),
Documentation(info="<HTML>
<p>
This model instantiates the chiller plant sequence
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Controller</a>
and connects it with the chiller plant system model 
<a href=\"modelica://Buildings.Examples.ChillerPlants.Guideline36.BaseClasses.PartialChillerPlant\">
Buildings.Examples.ChillerPlants.Guideline36.BaseClasses.PartialChillerPlant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2024, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Guideline36;
