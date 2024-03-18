within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
model RP1711 "Chiller plant model with RP1711 controller"

  extends
    Buildings.Examples.ChillerPlants.RP1711.BaseClasses.PartialChillerPlant(
      senVolFlo(tau=10),
    chi1(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    chi2(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));
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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon(
    final desCap=2*chiDesCap,
    final chiDesCap={chiDesCap,chiDesCap},
    final chiMinCap={chiDesCap*0.1,chiDesCap*0.1},
    final have_WSE=false,
    final nSenChiWatPum=1,
    final have_fixSpeConWatPum=true,
    final totSta=3,
    final staVec={0,1,2},
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
    final dpChiWatPumMax={160000},
    final TiSupCon=100,
    final speChe=speChe)
    "Chiller plant controller"
    annotation (Placement(transformation(extent={{-260,0},{-220,160}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold chiWatIso[2](
    final t=fill(posChe, 2),
    final h=fill(0.5*posChe, 2))
    "Chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-400,320},{-380,340}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold conWatIso[2](
    final t=fill(posChe, 2),
    final h=fill(0.5*posChe, 2))
    "Condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-400,280},{-380,300}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold chiSta[2](
    final t=fill(loaChe, 2),
    final h=fill(0.5*loaChe, 2))
    "Chiller status, check if the chiller load is greater than zero "
    annotation (Placement(transformation(extent={{-400,230},{-380,250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva[2](
    final k=fill(true, 2))
    "Chiller availability"
    annotation (Placement(transformation(extent={{-400,40},{-380,60}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold conWatPumSta[2](
    final t=fill(speChe, 2),
    final h=fill(0.5*speChe, 2))
    "Condenser water pump status"
    annotation (Placement(transformation(extent={{-400,150},{-380,170}})));
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
    annotation (Placement(transformation(extent={{-400,-30},{-380,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conWatLev(
    final k=0.9) "Constant cooling tower water level"
    annotation (Placement(transformation(extent={{-520,-10},{-500,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax cooTowFan(
    final nin=2)
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{-400,200},{-380,220}})));
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
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-340,320},{-320,340}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre3[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-340,280},{-320,300}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre4[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-354,230},{-334,250}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre5[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-360,-30},{-340,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre6[2] "Break algebraic loop"
    annotation (Placement(transformation(extent={{-360,-110},{-340,-90}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=120)
    "Sample value and break algebric loop"
    annotation (Placement(transformation(extent={{360,-360},{380,-340}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1[2](
    final samplePeriod=fill(120, 2))
    "Sample value and break algebric loop"
    annotation (Placement(transformation(extent={{-460,300},{-440,320}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol2(
    final samplePeriod=120)
    "Sample value and break algebric loop"
    annotation (Placement(transformation(extent={{340,-110},{360,-90}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold cheChiIsoVal[2](
    t=fill(0.95,2),
    h=fill(0.025, 2))
    "Check if the chilled water isolation valve is open"
    annotation (Placement(transformation(extent={{-100,56},{-80,76}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2]
    "Convert boolean input to real output"
    annotation (Placement(transformation(extent={{-8,56},{12,76}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyChiIsoVal(
    nin=2)
    "Check if there is any open chilled water isolation valve"
    annotation (Placement(transformation(extent={{-70,56},{-50,76}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    nout=2) "Duplicate boolean input"
    annotation (Placement(transformation(extent={{-40,56},{-20,76}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul[2]
    "Ensure chilled water pump operates only when there is open isolation valve"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));

protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity Cp = 4198
    "Water specific heat capacity";
  final parameter Modelica.Units.SI.HeatFlowRate chiDesCap = mChi_flow_nominal*dTChi*Cp
    "Chiller design capacity";

equation
  connect(chwIsoVal1.y_actual, chiWatIso[1].u) annotation (Line(points={{235,77},
          {100,77},{100,360},{-480,360},{-480,330},{-402,330}}, color={0,0,127}));
  connect(chwIsoVal2.y_actual, chiWatIso[2].u) annotation (Line(points={{235,-13},
          {220,-13},{220,-4},{100,-4},{100,360},{-480,360},{-480,330},{-402,330}},
          color={0,0,127}));
  connect(cwIsoVal1.y_actual, conWatIso[1].u) annotation (Line(points={{385,107},
          {400,107},{400,120},{110,120},{110,370},{-500,370},{-500,290},{-402,
          290}}, color={0,0,127}));
  connect(cwIsoVal2.y_actual, conWatIso[2].u) annotation (Line(points={{385,17},
          {400,17},{400,40},{110,40},{110,370},{-500,370},{-500,290},{-402,290}},
          color={0,0,127}));
  connect(chi2.P, chiSta[2].u) annotation (Line(points={{341,13},{352,13},{352,30},
          {90,30},{90,268},{-480,268},{-480,240},{-402,240}}, color={0,0,127}));
  connect(chiWatSupTem.T, chiPlaCon.TChiWatSup) annotation (Line(points={{211,
          -180},{300,-180},{300,-44},{-450,-44},{-450,96},{-264,96}}, color={0,0,127}));
  connect(chiAva.y, chiPlaCon.uChiAva) annotation (Line(points={{-378,50},{-320,
          50},{-320,74},{-264,74}}, color={255,0,255}));
  connect(conWatPum1.y_actual, conWatPumSta[1].u) annotation (Line(points={{207,199},
          {207,192},{-410,192},{-410,160},{-402,160}}, color={0,0,127}));
  connect(conWatPum2.y_actual, conWatPumSta[2].u) annotation (Line(points={{267,199},
          {267,192},{-410,192},{-410,160},{-402,160}}, color={0,0,127}));
  connect(weaBus.TDryBul, TOut.u)
          annotation (Line(points={{-559.95,40.05},{-540,40.05},{-540,40},{-522,
          40}}, color={255,204,51}, thickness=0.5));
  connect(TOut.y, chiPlaCon.TOut) annotation (Line(points={{-499,40},{-440,40},
          {-440,32},{-264,32}},   color={0,0,127}));
  connect(weaBus.TWetBul, TWetBul.u) annotation (Line(points={{-559.95,40.05},{
          -540,40.05},{-540,80},{-522,80}}, color={255,204,51},thickness=0.5));
  connect(TWetBul.y, cooTow2.TAir) annotation (Line(points={{-499,80},{-490,80},
          {-490,350},{360,350},{360,314},{342,314}},      color={0,0,127}));
  connect(chiWatPum1.y_actual, chiWatPumSta[1].u) annotation (Line(points={{207,
          -107},{207,-164},{-410,-164},{-410,-100},{-402,-100}}, color={0,0,127}));
  connect(chiWatPum2.y_actual, chiWatPumSta[2].u) annotation (Line(points={{267,
          -107},{267,-164},{-410,-164},{-410,-100},{-402,-100}}, color={0,0,127}));
  connect(cooTow1.PFan, towSta[1].u) annotation (Line(points={{319,388},{-430,388},
          {-430,-20},{-402,-20}},      color={0,0,127}));
  connect(cooTow2.PFan, towSta[2].u) annotation (Line(points={{319,318},{300,318},
          {300,388},{-430,388},{-430,-20},{-402,-20}},      color={0,0,127}));
  connect(conWatLev.y, chiPlaCon.watLev) annotation (Line(points={{-498,0},{
          -380,0},{-380,8},{-264,8}},       color={0,0,127}));
  connect(chiPlaCon.yConWatPumSpe[1], conWatPum1.y) annotation (Line(points={{-216,92},
          {120,92},{120,224},{220,224},{220,210},{212,210}}, color={0,0,127}));
  connect(chiPlaCon.yConWatPumSpe[2], conWatPum2.y) annotation (Line(points={{-216,92},
          {120,92},{120,224},{280,224},{280,210},{272,210}}, color={0,0,127}));
  connect(chiPlaCon.yHeaPreConVal[1], cwIsoVal1.y) annotation (Line(points={{-216,98},
          {70,98},{70,118},{380,118},{380,112}}, color={0,0,127}));
  connect(chiPlaCon.yHeaPreConVal[2], cwIsoVal2.y) annotation (Line(points={{-216,98},
          {70,98},{70,50},{380,50},{380,22}}, color={0,0,127}));
  connect(chi1.P, chiSta[1].u) annotation (Line(points={{341,103},{350,103},{
          350,116},{90,116},{90,268},{-480,268},{-480,240},{-402,240}}, color={
          0,0,127}));
  connect(cooTow1.yFanSpe, cooTowFan.u[1]) annotation (Line(points={{318,384},{
          -420,384},{-420,209.5},{-402,209.5}}, color={0,0,127}));
  connect(conWatSupTem.T, chiPlaCon.TConWatSup) annotation (Line(points={{271,280},
          {280,280},{280,260},{-330,260},{-330,16},{-264,16}}, color={0,0,127}));
  connect(TWetBul.y, cooTow1.TAir) annotation (Line(points={{-499,80},{-490,80},
          {-490,350},{360,350},{360,384},{342,384}}, color={0,0,127}));
  connect(cooTow2.yFanSpe, cooTowFan.u[2]) annotation (Line(points={{318,314},{
          290,314},{290,384},{-420,384},{-420,210.5},{-402,210.5}}, color={0,0,
          127}));
  connect(chiPlaCon.TChiWatSupSet, chi2.TSet) annotation (Line(points={{-216,
          136},{60,136},{60,1},{318,1}}, color={0,0,127}));
  connect(chiPlaCon.TChiWatSupSet, chi1.TSet) annotation (Line(points={{-216,
          136},{140,136},{140,91},{318,91}}, color={0,0,127}));
  connect(chiPlaCon.yMinValPosSet, valByp.y) annotation (Line(points={{-216,60},
          {-140,60},{-140,-200},{330,-200},{330,-208}}, color={0,0,127}));
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
          -160},{-320,-160},{-320,52},{-264,52}}, color={255,127,0}));
  connect(chiPlaReq, chiPlaCon.chiPlaReq) annotation (Line(points={{-580,-190},
          {-300,-190},{-300,48},{-264,48}},color={255,127,0}));
  connect(chiWatIso.y, pre2.u)
    annotation (Line(points={{-378,330},{-342,330}}, color={255,0,255}));
  connect(conWatIso.y, pre3.u)
    annotation (Line(points={{-378,290},{-342,290}}, color={255,0,255}));
  connect(chiSta.y, pre4.u)
    annotation (Line(points={{-378,240},{-356,240}}, color={255,0,255}));
  connect(towSta.y, pre5.u)
    annotation (Line(points={{-378,-20},{-362,-20}}, color={255,0,255}));
  connect(chiWatRet.T, chiPlaCon.TChiWatRet) annotation (Line(points={{429,-180},
          {400,-180},{400,-50},{-470,-50},{-470,104},{-264,104}}, color={0,0,127}));
  connect(conWatRetTem.T, chiPlaCon.TConWatRet) annotation (Line(points={{409,280},
          {400,280},{400,254},{-320,254},{-320,100},{-264,100}}, color={0,0,127}));
  connect(towIsoVal1.y_actual, chiPlaCon.uIsoVal[1]) annotation (Line(points={{375,387},
          {366,387},{366,420},{-310,420},{-310,11},{-264,11}}, color={0,0,127}));
  connect(towIsoVal2.y_actual, chiPlaCon.uIsoVal[2]) annotation (Line(points={{375,317},
          {366,317},{366,420},{-310,420},{-310,13},{-264,13}}, color={0,0,127}));
  connect(cooTowFan.y, chiPlaCon.uFanSpe) annotation (Line(points={{-378,210},{
          -270,210},{-270,20},{-264,20}}, color={0,0,127}));
  connect(conWatPum1.y_actual, chiPlaCon.uConWatPumSpe[1]) annotation (Line(
        points={{207,199},{207,192},{-350,192},{-350,40},{-264,40}}, color={0,0,
          127}));
  connect(conWatPum2.y_actual, chiPlaCon.uConWatPumSpe[2]) annotation (Line(
        points={{267,199},{267,192},{-350,192},{-350,40},{-264,40}}, color={0,0,
          127}));
  connect(pre5.y, chiPlaCon.uTowSta) annotation (Line(points={{-338,-20},{-330,
          -20},{-330,4},{-264,4}}, color={255,0,255}));
  connect(conWatPumSta.y, chiPlaCon.uConWatPum) annotation (Line(points={{-378,
          160},{-340,160},{-340,36},{-264,36}}, color={255,0,255}));
  connect(pre3.y, chiPlaCon.uChiHeaCon) annotation (Line(points={{-318,290},{
          -292,290},{-292,60},{-264,60}}, color={255,0,255}));
  connect(pre3.y, chiPlaCon.uChiConIsoVal) annotation (Line(points={{-318,290},
          {-292,290},{-292,156},{-264,156}},color={255,0,255}));
  connect(pre2.y, chiPlaCon.uChiWatReq) annotation (Line(points={{-318,330},{
          -280,330},{-280,152},{-264,152}}, color={255,0,255}));
  connect(pre2.y, chiPlaCon.uConWatReq) annotation (Line(points={{-318,330},{
          -280,330},{-280,148},{-264,148}}, color={255,0,255}));
  connect(pre2.y, chiPlaCon.uChiIsoVal) annotation (Line(points={{-318,330},{
          -280,330},{-280,140},{-264,140}}, color={255,0,255}));
  connect(pre4.y, chiPlaCon.uChi) annotation (Line(points={{-332,240},{-300,240},
          {-300,120},{-264,120}}, color={255,0,255}));
  connect(chiWatPumSta.y, pre6.u)
    annotation (Line(points={{-378,-100},{-362,-100}}, color={255,0,255}));
  connect(pre6.y, chiPlaCon.uChiWatPum) annotation (Line(points={{-338,-100},{
          -286,-100},{-286,144},{-264,144}}, color={255,0,255}));
  connect(chiPlaCon.yChi[1], chi1.on) annotation (Line(points={{-216,112},{-130,
          112},{-130,20},{280,20},{280,97},{318,97}}, color={255,0,255}));
  connect(chiPlaCon.yChi[2], chi2.on) annotation (Line(points={{-216,112},{-130,
          112},{-130,20},{280,20},{280,7},{318,7}}, color={255,0,255}));
  connect(senRelPre.p_rel, zerOrdHol.u) annotation (Line(points={{330,-329},{330,
          -350},{358,-350}}, color={0,0,127}));
  connect(zerOrdHol.y, chiPlaCon.dpChiWat_remote[1]) annotation (Line(points={{382,
          -350},{400,-350},{400,-380},{-480,-380},{-480,128},{-264,128}}, color={0,
          0,127}));
  connect(chwIsoVal1.y_actual, zerOrdHol1[1].u) annotation (Line(points={{235,77},
          {100,77},{100,360},{-480,360},{-480,310},{-462,310}}, color={0,0,127}));
  connect(chwIsoVal2.y_actual, zerOrdHol1[2].u) annotation (Line(points={{235,-13},
          {220,-13},{220,-4},{100,-4},{100,360},{-480,360},{-480,310},{-462,310}},
        color={0,0,127}));
  connect(zerOrdHol1.y, chiPlaCon.uChiWatIsoVal) annotation (Line(points={{-438,
          310},{-360,310},{-360,56},{-264,56}}, color={0,0,127}));
  connect(senVolFlo.V_flow, zerOrdHol2.u) annotation (Line(points={{429,-60},{320,
          -60},{320,-100},{338,-100}}, color={0,0,127}));
  connect(zerOrdHol2.y, chiPlaCon.VChiWat_flow) annotation (Line(points={{362,
          -100},{380,-100},{380,-260},{-460,-260},{-460,124},{-264,124}}, color={0,0,127}));
  connect(chiPlaCon.yTowCelIsoVal[1], towIsoVal1.y) annotation (Line(points={{-216,
          43},{-160,43},{-160,400},{380,400},{380,392},{380,392}}, color={0,0,127}));
  connect(chiPlaCon.yTowCelIsoVal[2], towIsoVal2.y) annotation (Line(points={{-216,
          45},{-160,45},{-160,332},{380,332},{380,322}}, color={0,0,127}));
  connect(chiPlaCon.yTowFanSpe[1], cooTow1.y) annotation (Line(points={{-216,31},
          {-170,31},{-170,410},{350,410},{350,388},{342,388}}, color={0,0,127}));
  connect(chiPlaCon.yTowFanSpe[2], cooTow2.y) annotation (Line(points={{-216,33},
          {-170,33},{-170,340},{350,340},{350,318},{342,318}}, color={0,0,127}));
  connect(chiPlaCon.yChiWatIsoVal[1], chwIsoVal1.y) annotation (Line(points={{
          -216,66},{-120,66},{-120,106},{240,106},{240,82}}, color={0,0,127}));
  connect(chiPlaCon.yChiWatIsoVal[2], chwIsoVal2.y) annotation (Line(points={{
          -216,66},{-120,66},{-120,12},{240,12},{240,-8}}, color={0,0,127}));
  connect(chiPlaCon.yChiWatIsoVal, cheChiIsoVal.u)
    annotation (Line(points={{-216,66},{-102,66}}, color={0,0,127}));
  connect(cheChiIsoVal.y, anyChiIsoVal.u)
    annotation (Line(points={{-78,66},{-72,66}}, color={255,0,255}));
  connect(anyChiIsoVal.y, booScaRep.u)
    annotation (Line(points={{-48,66},{-42,66}}, color={255,0,255}));
  connect(booScaRep.y, booToRea.u)
    annotation (Line(points={{-18,66},{-10,66}}, color={255,0,255}));
  connect(booToRea.y, mul.u1) annotation (Line(points={{14,66},{20,66},{20,46},
          {28,46}}, color={0,0,127}));
  connect(chiPlaCon.yChiPumSpe, mul.u2) annotation (Line(points={{-216,124},{
          -180,124},{-180,34},{28,34}}, color={0,0,127}));
  connect(mul[2].y, chiWatPum2.y) annotation (Line(points={{52,40},{80,40},{80,
          -56},{280,-56},{280,-96},{272,-96}}, color={0,0,127}));
  connect(mul[1].y, chiWatPum1.y) annotation (Line(points={{52,40},{80,40},{80,
          -56},{220,-56},{220,-96},{212,-96}}, color={0,0,127}));
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
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller</a>
and connects it with the chiller plant system model 
<a href=\"modelica://Buildings.Examples.ChillerPlants.RP1711.BaseClasses.PartialChillerPlant\">
Buildings.Examples.ChillerPlants.RP1711.BaseClasses.PartialChillerPlant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2024, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end RP1711;
