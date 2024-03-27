within Buildings.DHC.Plants.Combined.Subsystems.Validation;
model ChillerHeatRecoveryGroup
  "Validation of heat recovery chiller group model"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  final parameter Integer nChiHea(final min=1, start=1)=2
    "Number of HRCs operating at design conditions"
    annotation(Evaluate=true);
  parameter
    Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Carrier_19XR_1403kW_7_09COP_VSD dat(
      EIRFunT={0.0101739374, 0.0607200115, 0.0003348647, 0.003162578, 0.0002388594, -0.0014121289},
      capFunT={0.0387084662, 0.2305017927, 0.0004779504, 0.0178244359, -8.48808e-05, -0.0032406711},
      EIRFunPLR={0.4304252832, -0.0144718912, 5.12039e-05, -0.7562386674, 0.5661683373,
        0.0406987748, 3.0278e-06, -0.3413411197, -0.000469572, 0.0055009208},
      QEva_flow_nominal=-1E6,
      COP_nominal=2.5,
      mEva_flow_nominal=20,
      mCon_flow_nominal=22,
      TEvaLvg_nominal=279.15,
      TEvaLvgMin=277.15,
      TEvaLvgMax=308.15,
      TConLvg_nominal=333.15,
      TConLvgMin=296.15,
      TConLvgMax=336.15)
    "Chiller parameters (each unit)"
    annotation (
      Dialog(group="CHW loop and cooling-only chillers"),
      Placement(transformation(extent={{140,200},{160,220}})));

  Buildings.DHC.Plants.Combined.Subsystems.ChillerHeatRecoveryGroup
    chi(
    redeclare final package Medium = Medium,
    show_T=true,
    final nUni=nChiHea,
    dpEva_nominal=3E5,
    dpCon_nominal=3E5,
    final dat=dat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Chiller group"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));

  Fluid.Sources.Boundary_pT bouChiWat(
    redeclare final package Medium = Medium,
    p=300000,
    nPorts=1) "Pressure boundary condition for CHW"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={120,-190})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,1,1; 0.8,1,1; 0.8,1,0; 0.9,1,0; 0.9,0,0; 1,0,0],
    timeScale=2000,
    period=2000) "Chiller On/Off command"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo(
    table=[0,0,0; 0.2,0,0; 0.2,0,1; 0.6,0,1; 0.6,1,1; 1,1,1],
    timeScale=2000,
    period=2000)
    "Cooling mode switchover command"
    annotation (Placement(transformation(extent={{-240,90},{-220,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1HeaCoo(
    table=[0,0,0; 0.4,0,0; 0.4,1,0; 0.6,1,0; 0.6,0,0; 1,0,0],
    timeScale=2000,
    period=2000)
    "Direct heat recovery switchover command"
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSet[nChiHea](
      each final k=chi.TChiWatSup_nominal, y(each final unit="K", each
        displayUnit="degC")) "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-190},{-220,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[chi.nUni]
    "Convert DO to AO" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,200})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package Medium =
               Medium, final m_flow_nominal=chi.mConWat_flow_nominal)
    "HW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,20})));
  Fluid.Sensors.MassFlowRate floHeaWat(redeclare final package Medium =
        Medium) "HW flow" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,80})));
  Fluid.Sensors.MassFlowRate floChiWat(redeclare final package Medium =
        Medium) "CHW flow" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-100})));
  Fluid.Sensors.TemperatureTwoPort TChiWatSup(redeclare final package Medium =
               Medium, final m_flow_nominal=chi.mChiWat_flow_nominal)
    "CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-80})));
  Buildings.Controls.OBC.CDL.Logical.Or cooOrDir[nChiHea]
    "Return true if cooling OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-160,-60})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValConSwi[nChiHea]
    "HRC condenser switchover valve commanded position"
                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-20})));
  Buildings.Controls.OBC.CDL.Logical.Not hea[nChiHea] "Return true if heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-160,20})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nChiHea]
    "Convert"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHea(nin=nChiHea)
    "Number of HRC connected to HW loop"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes[nChiHea]
    "Return true if switchover valve to be open"
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idx[nChiHea](final k={i
        for i in 1:nChiHea}) "HRC index"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-150,-50},{-130,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or mul[nChiHea]
    "Return true if cooling OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-20})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal yValEvaSwi[nChiHea]
    "HRC evaporator switchover valve commanded position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-60})));
  Buildings.Controls.OBC.CDL.Logical.Not heaAndCas[nChiHea]
    "Return true if cascading heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-160,-100})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1[nChiHea]
    "Convert"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum numHeaAndCas(nin=nChiHea)
    "Number of HRC in cascading heating"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep1(final nout=
        nChiHea) "Replicate"
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Less intLes1
                                                 [nChiHea]
    "Return true if switchover valve to be open"
    annotation (Placement(transformation(extent={{-110,-150},{-90,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or mul1
                                           [nChiHea]
    "Return true if cooling OR direct HR" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-60})));
  Buildings.Controls.OBC.CDL.Reals.Switch TChiHeaSupSet[nChiHea]
    "Switch supply temperature setpoint"
    annotation (Placement(transformation(extent={{-168,-210},{-148,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSet[nChiHea](
      each final k=chi.THeaWatSup_nominal, y(each final unit="K", each
        displayUnit="degC")) "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-230},{-220,-210}})));
  Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsSpeed pumChiWat(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPum=1,
    have_var=false,
    have_valve=true,
    final mPum_flow_nominal=chi.mChiWat_flow_nominal,
    final dpPum_nominal=chi.dpEva_nominal)
    "CHW pumps"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr y1PumConWatCon(nin=2)
    "Start pump if any HRC in cascading cooling" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,140})));
  Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsSpeed pumHeaWat(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPum=1,
    have_var=false,
    have_valve=true,
    final mPum_flow_nominal=chi.mConWat_flow_nominal,
    final dpPum_nominal=chi.dpCon_nominal)
    "HW pumps" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,20})));
  Buildings.Controls.OBC.CDL.Logical.And onAndHea[nChiHea]
    "Return true if On and heating" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,60})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr y1PumHeaWat(nin=2)
    "Start pump if any HRC On and in heating" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,60})));
  Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsSpeed pumConWatCon(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPum=1,
    have_var=false,
    have_valve=true,
    final mPum_flow_nominal=chi.mConWat_flow_nominal,
    final dpPum_nominal=chi.dpCon_nominal)
    "CW pumps serving condenser barrels" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,160})));
  Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsSpeed pumConWatEva(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPum=1,
    have_var=false,
    have_valve=true,
    final mPum_flow_nominal=chi.mChiWat_flow_nominal,
    final dpPum_nominal=chi.dpEva_nominal)
    "CW pumps serving evaporator barrels"
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold y1PumConWatEva(t=1)
    "Return true if CW to be operating"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr y1PumChiWat(nin=2)
    "Start pump if any HRC in cooling or direct HR mode" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-160})));
  Fluid.HeatExchangers.SensibleCooler_T disHeaWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=THeaWatRet.k,
    final dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=300,
    T_start=chi.THeaWatSup_nominal - 12)
    "Distribution system approximated by prescribed temperature"
    annotation (Placement(transformation(extent={{100,70},{80,90}})));
  Fluid.HeatExchangers.Heater_T disConWatEva(
    redeclare final package Medium = Medium,
    final m_flow_nominal=chi.mChiWat_flow_nominal,
    final dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=300,
    T_start=TConWatEvaSup.k)
    "Distribution system approximated by prescribed temperature"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Fluid.HeatExchangers.SensibleCooler_T disConWatCon(
    redeclare final package Medium = Medium,
    final m_flow_nominal=TConWatConSup.k,
    final dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=300,
    T_start=chi.TCasCooEnt_nominal)
    "Distribution system approximated by prescribed temperature"
    annotation (Placement(transformation(extent={{100,150},{80,170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatRet(
    final k=chi.THeaWatSup_nominal - 12,
    y(final unit="K", displayUnit="degC"))
    "Return temperature"
    annotation (Placement(transformation(extent={{220,90},{200,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConWatConSup(final k=
        chi.TCasCooEnt_nominal, y(final unit="K", displayUnit="degC"))
    "Supply temperature"
    annotation (Placement(transformation(extent={{220,170},{200,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TConWatEvaSup(final k=
        chi.TCasHeaEnt_nominal, y(final unit="K", displayUnit="degC"))
    "Supply temperature"
    annotation (Placement(transformation(extent={{220,-30},{200,-10}})));
  Fluid.HeatExchangers.Heater_T disChiWat(
    redeclare final package Medium = Medium,
    final m_flow_nominal=TChiWatRet.k,
    final dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=300,
    T_start=chi.TChiWatSup_nominal)
    "Distribution system approximated by prescribed temperature"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRet(
    final k=chi.TChiWatSup_nominal + 6, y(final unit="K", displayUnit="degC"))
    "Return temperature"
    annotation (Placement(transformation(extent={{220,-130},{200,-110}})));
  Fluid.Sources.Boundary_pT bouHeaWat(
    redeclare final package Medium = Medium,
    p=300000,
    nPorts=1) "Pressure boundary condition for HW" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={210,40})));
equation
  connect(y1.y, chi.y1)
    annotation (Line(points={{-218,180},{26,180},{26,6},{48,6}},
                                               color={255,0,255}));
  connect(y1Coo.y, chi.y1Coo)
    annotation (Line(points={{-218,100},{14,100},{14,0},{48,0}},
                                                        color={255,0,255}));
  connect(y1.y, booToRea.u) annotation (Line(points={{-218,180},{-160,180},{-160,
          200},{-142,200}},
                     color={255,0,255}));
  connect(booToRea.y, chi.yValEva) annotation (Line(points={{-118,200},{20,200},
          {20,-16},{52,-16},{52,-12}},
                       color={0,0,127}));
  connect(chi.port_b1, THeaWatSup.port_a)
    annotation (Line(points={{70,8},{80,8},{80,20},{90,20}},
                                             color={0,127,255}));
  connect(floChiWat.port_b, chi.port_a4)
    annotation (Line(points={{160,-90},{160,-8},{70,-8}},
                                                        color={0,127,255}));
  connect(TChiWatSup.port_a, chi.port_b4) annotation (Line(points={{40,-70},{40,
          -8.5},{50,-8.5}},  color={0,127,255}));
  connect(y1Coo.y, cooOrDir.u1) annotation (Line(points={{-218,100},{-180,100},{
          -180,-60},{-172,-60}},
                               color={255,0,255}));
  connect(y1HeaCoo.y, cooOrDir.u2) annotation (Line(points={{-218,60},{-190,60},
          {-190,-68},{-172,-68}},
                                color={255,0,255}));
  connect(y1Coo.y, hea.u) annotation (Line(points={{-218,100},{-180,100},{-180,20},
          {-172,20}}, color={255,0,255}));
  connect(hea.y, booToInt.u)
    annotation (Line(points={{-148,20},{-142,20}}, color={255,0,255}));
  connect(booToInt.y, numHea.u)
    annotation (Line(points={{-118,20},{-112,20}},
                                                 color={255,127,0}));
  connect(idx.y, intLes.u1)
    annotation (Line(points={{-218,-20},{-112,-20}},color={255,127,0}));
  connect(rep.y, intLes.u2) annotation (Line(points={{-128,-40},{-120,-40},{-120,
          -28},{-112,-28}},
                      color={255,127,0}));
  connect(intLes.y, mul.u2) annotation (Line(points={{-88,-20},{-80,-20},{-80,-28},
          {-42,-28}}, color={255,0,255}));
  connect(mul.y, yValConSwi.u)
    annotation (Line(points={{-18,-20},{-12,-20}},
                                                 color={255,0,255}));
  connect(yValConSwi.y, chi.yValConSwi) annotation (Line(points={{12,-20},{36,-20},
          {36,16},{54,16},{54,12}}, color={0,0,127}));
  connect(y1Coo.y[1:2], mul.u1) annotation (Line(points={{-218,100},{-60,100},{-60,
          -20},{-42,-20}}, color={255,0,255}));
  connect(yValEvaSwi.y, chi.yValEvaSwi) annotation (Line(points={{12,-60},{34,-60},
          {34,-40},{54,-40},{54,-26},{54,-26},{54,-12}},
                             color={0,0,127}));
  connect(numHea.y, rep.u) annotation (Line(points={{-88,20},{-80,20},{-80,0},{-160,
          0},{-160,-40},{-152,-40}}, color={255,127,0}));
  connect(cooOrDir.y, heaAndCas.u) annotation (Line(points={{-148,-60},{-140,
          -60},{-140,-80},{-176,-80},{-176,-100},{-172,-100}},
                                                            color={255,0,255}));
  connect(heaAndCas.y, booToInt1.u) annotation (Line(points={{-148,-100},{-142,-100}},
                                    color={255,0,255}));
  connect(booToInt1.y, numHeaAndCas.u)
    annotation (Line(points={{-118,-100},{-112,-100}},
                                                     color={255,127,0}));
  connect(numHeaAndCas.y, rep1.u) annotation (Line(points={{-88,-100},{-80,-100},
          {-80,-120},{-160,-120},{-160,-160},{-152,-160}},
                                  color={255,127,0}));
  connect(rep1.y, intLes1.u2) annotation (Line(points={{-128,-160},{-120,-160},
          {-120,-148},{-112,-148}},
                             color={255,127,0}));
  connect(idx.y, intLes1.u1) annotation (Line(points={{-218,-20},{-200,-20},{-200,
          -140},{-112,-140}},                  color={255,127,0}));
  connect(cooOrDir.y, mul1.u1) annotation (Line(points={{-148,-60},{-42,-60}},
                          color={255,0,255}));
  connect(intLes1.y, mul1.u2) annotation (Line(points={{-88,-140},{-56,-140},{
          -56,-68},{-42,-68}},
                          color={255,0,255}));
  connect(mul1.y, yValEvaSwi.u) annotation (Line(points={{-18,-60},{-12,-60}},
                     color={255,0,255}));
  connect(TChiWatSet.y, TChiHeaSupSet.u1) annotation (Line(points={{-218,-180},{
          -190,-180},{-190,-192},{-170,-192}}, color={0,0,127}));
  connect(THeaWatSet.y, TChiHeaSupSet.u3) annotation (Line(points={{-218,-220},{
          -190,-220},{-190,-208},{-170,-208}}, color={0,0,127}));
  connect(y1Coo.y, TChiHeaSupSet.u2) annotation (Line(points={{-218,100},{-180,100},
          {-180,-200},{-170,-200}}, color={255,0,255}));
  connect(TChiHeaSupSet.y, chi.TSet) annotation (Line(points={{-146,-200},{24,
          -200},{24,-6},{48,-6}},
                            color={0,0,127}));
  connect(pumChiWat.port_b, floChiWat.port_a) annotation (Line(points={{140,-140},
          {160,-140},{160,-110}},color={0,127,255}));
  connect(y1Coo.y[1:2], y1PumConWatCon.u[1:2]) annotation (Line(points={{-218,100},
          {-180,100},{-180,140},{-42,140},{-42,141.75}}, color={255,0,255}));
  connect(pumHeaWat.port_b, floHeaWat.port_a) annotation (Line(points={{140,20},
          {160,20},{160,80},{140,80}}, color={0,127,255}));
  connect(y1.y[1:2], onAndHea.u1) annotation (Line(points={{-218,180},{-160,180},
          {-160,60},{-112,60}}, color={255,0,255}));
  connect(hea.y, onAndHea.u2) annotation (Line(points={{-148,20},{-146,20},{-146,
          52},{-112,52}}, color={255,0,255}));
  connect(onAndHea.y, y1PumHeaWat.u[1:2]) annotation (Line(points={{-88,60},{-42,
          60},{-42,61.75}}, color={255,0,255}));
  connect(y1PumHeaWat.y, pumHeaWat.y1[1]) annotation (Line(points={{-18,60},{110,
          60},{110,28},{118,28}}, color={255,0,255}));
  connect(THeaWatSup.port_b, pumHeaWat.port_a)
    annotation (Line(points={{110,20},{120,20}}, color={0,127,255}));
  connect(pumConWatEva.port_b, chi.port_a2) annotation (Line(points={{140,-60},{
          150,-60},{150,3},{70,3}}, color={0,127,255}));
  connect(chi.port_b3, pumConWatCon.port_a) annotation (Line(points={{70,-3.1},{
          170,-3.1},{170,160},{140,160}}, color={0,127,255}));
  connect(numHeaAndCas.y, y1PumConWatEva.u)
    annotation (Line(points={{-88,-100},{-42,-100}}, color={255,127,0}));
  connect(y1PumConWatEva.y, pumConWatEva.y1[1]) annotation (Line(points={{-18,-100},
          {110,-100},{110,-52},{118,-52}}, color={255,0,255}));
  connect(y1PumConWatCon.y, pumConWatCon.y1[1]) annotation (Line(points={{-18,140},
          {160,140},{160,168},{142,168}}, color={255,0,255}));
  connect(y1PumChiWat.y, pumChiWat.y1[1]) annotation (Line(points={{-18,-160},{110,
          -160},{110,-132},{118,-132}}, color={255,0,255}));
  connect(cooOrDir.y, y1PumChiWat.u[1:2]) annotation (Line(points={{-148,-60},{-60,
          -60},{-60,-160},{-42,-160},{-42,-158.25}}, color={255,0,255}));
  connect(floHeaWat.port_b, disHeaWat.port_a)
    annotation (Line(points={{120,80},{100,80}}, color={0,127,255}));
  connect(disHeaWat.port_b, chi.port_a1) annotation (Line(points={{80,80},{44,80},
          {44,8},{50,8}},     color={0,127,255}));
  connect(chi.port_b2, disConWatEva.port_a) annotation (Line(points={{50,3},{44,
          3},{44,-60},{80,-60}}, color={0,127,255}));
  connect(disConWatEva.port_b, pumConWatEva.port_a)
    annotation (Line(points={{100,-60},{120,-60}}, color={0,127,255}));
  connect(pumConWatCon.port_b, disConWatCon.port_a)
    annotation (Line(points={{120,160},{100,160}}, color={0,127,255}));
  connect(disConWatCon.port_b, chi.port_a3) annotation (Line(points={{80,160},{40,
          160},{40,-3.2},{50,-3.2}},    color={0,127,255}));
  connect(THeaWatRet.y, disHeaWat.TSet) annotation (Line(points={{198,100},{110,
          100},{110,88},{102,88}},color={0,0,127}));
  connect(TConWatConSup.y, disConWatCon.TSet) annotation (Line(points={{198,180},
          {110,180},{110,168},{102,168}}, color={0,0,127}));
  connect(TConWatEvaSup.y, disConWatEva.TSet) annotation (Line(points={{198,-20},
          {70,-20},{70,-52},{78,-52}}, color={0,0,127}));
  connect(disChiWat.port_b, pumChiWat.port_a)
    annotation (Line(points={{100,-140},{120,-140}}, color={0,127,255}));
  connect(TChiWatSup.port_b, disChiWat.port_a) annotation (Line(points={{40,-90},
          {40,-140},{80,-140}}, color={0,127,255}));
  connect(TChiWatRet.y, disChiWat.TSet) annotation (Line(points={{198,-120},{68,
          -120},{68,-132},{78,-132}}, color={0,0,127}));
  connect(bouChiWat.ports[1], pumChiWat.port_a)
    annotation (Line(points={{120,-180},{120,-140}}, color={0,127,255}));
  connect(booToRea.y, chi.yValCon) annotation (Line(points={{-118,200},{52,200},
          {52,12}},                color={0,0,127}));
  connect(bouHeaWat.ports[1], pumHeaWat.port_a) annotation (Line(points={{200,40},
          {116,40},{116,20},{120,20}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Combined/Subsystems/Validation/ChillerHeatRecoveryGroup.mos"
      "Simulate and plot"),
    experiment(
      StopTime=2000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-260,-260},{260,260}})),
    Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.Plants.Combined.Subsystems.ChillerHeatRecoveryGroup\">
Buildings.DHC.Plants.Combined.Subsystems.ChillerHeatRecoveryGroup</a>
in a configuration with two HRCs.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end ChillerHeatRecoveryGroup;
