within Buildings.Fluid.Storage.Plant.Examples.BaseClasses;
partial model PartialDualSource
  "Base model of a district system model with two sources and three users"

  package MediumCHW = Buildings.Media.Water "Medium model for CHW";
  package MediumCDW1 = Buildings.Media.Water "Medium model for CDW of chi1";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final displayUnit="Pa")=
     300000
    "Nominal pressure difference";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal(
    final displayUnit="degC")=
     12+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal(
    final displayUnit="degC")=
     7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Power QCooLoa_flow_nominal=5*4200*0.6
    "Nominal cooling load of one consumer";

// First source: chiller only
  Buildings.Fluid.Chillers.ElectricEIR chi1(
    redeclare final package Medium1 = MediumCDW1,
    redeclare final package Medium2 = MediumCHW,
    m1_flow_nominal=1.2*chi1.m2_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p2_start=500000,
    T2_start=T_CHWS_nominal,
    final per=perChi1)
    "Water cooled chiller (ports indexed 1 are on condenser side)"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-130,110})));
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi1(
    QEva_flow_nominal=-1E6,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=0.7*m_flow_nominal,
    mCon_flow_nominal=1.2*perChi1.mEva_flow_nominal,
    TEvaLvg_nominal=280.15,
    capFunT={1,0,0,0,0,0},
    EIRFunT={1,0,0,0,0,0},
    EIRFunPLR={1,0,0},
    TEvaLvgMin=276.15,
    TEvaLvgMax=288.15,
    TConEnt_nominal=310.15,
    TConEntMin=303.15,
    TConEntMax=333.15) "Performance data for the chiller in plant 1"
                                                  annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-180,160},{-160,
            180}})));
 Buildings.Fluid.Movers.SpeedControlled_y pumSup1(
    redeclare package Medium = MediumCHW,
    per(pressure(
          dp=dp_nominal*{2,1.2,0},
          V_flow=(1.5*m_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "CHW supply pump for chi1"
                                                 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,80})));
  Buildings.Fluid.FixedResistances.CheckValve cheValPumChi1(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=chi1.m2_flow_nominal,
    dpValve_nominal=0.1*dp_nominal,
    dpFixed_nominal=0.1*dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,80})));
  Buildings.Controls.Continuous.LimPID conPI_pumChi1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=100,
    reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-70,230})));
  Modelica.Blocks.Sources.Constant set_TRet(k=12 + 273.15)
    "CHW return setpoint"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW1(
    redeclare package Medium = MediumCDW1,
    m_flow=1.2*chi1.m2_flow_nominal,
    T=305.15,
    nPorts=1) "Source representing CDW supply line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,130})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW1(
    redeclare final package Medium = MediumCDW1,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-170,90})));
  Modelica.Blocks.Sources.Constant TEvaLvgSet(k=T_CHWS_nominal)
    "Evaporator leaving temperature setpoint" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,250})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant on(k=true)
    "Placeholder, chiller always on"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,210})));

// Second source: chiller and tank
  Buildings.Fluid.Storage.Plant.Data.NominalValues nomPla2(
    plaTyp=Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote,
    mTan_flow_nominal=0.75*m_flow_nominal,
    mChi_flow_nominal=0.75*m_flow_nominal,
    dp_nominal=dp_nominal,
    T_CHWS_nominal=T_CHWS_nominal,
    T_CHWR_nominal=T_CHWS_nominal) "Nominal values for the second plant"
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    tankIsOpen=false,
    preDroTanBot(final dp_nominal=nomPla2.dp_nominal*0.05),
    preDroTanTop(final dp_nominal=nomPla2.dp_nominal*0.05),
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2) "Tank branch, tank can be charged remotely" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-90})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch chiBra2(
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2)
    "Chiller branch"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2,
    plaTyp=nomPla2.plaTyp)
    "Supply pump and valves that connect the plant to the district network"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(table={3600/9*6,3600/9*8},
      startValue=false) "Tank is being charged remotely" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-170})));
  Modelica.Blocks.Sources.BooleanTable uTanDis(table={3600/9*1,3600/9*6,3600/9*
        8}, startValue=false)
    "True = discharging; false = charging (either local or remote)" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-50})));
  Buildings.Fluid.Storage.Plant.Controls.RemoteCharging conRemCha(final
      plaTyp=nomPla2.plaTyp) "Control block for the secondary pump and valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mTanSet_flow(
    realTrue=nomPla2.mTan_flow_nominal,
    realFalse=-nomPla2.mTan_flow_nominal)
    "Set a positive flow rate when tank discharging and negative when charging"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-50})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mChiBra2Set_flow(
    realTrue=0, realFalse=nomPla2.mChi_flow_nominal)
    "Set the flow rate to a constant value whenever the tank is not being charged remotely"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-130})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Tank charging remotely OR there is load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-130})));

// Users
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse1(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,190})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse2(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,0})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse3(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,-170})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin_dpUsr(nin=3)
    "Min of pressure head measured from all users"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,250})));
  Modelica.Blocks.Sources.Constant set_dpUsr(k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,250})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCat(uLow=0.05, uHigh=0.1)
    "Shut off at con.yVal = 0.05 and restarts at 0.1" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-210})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal(nin=3)
    "Max of valve positions"
    annotation (Placement(transformation(extent={{60,-220},{40,-200}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa1_flow(table=[0,0; 3600/9*1,0;
        3600/9*1,QCooLoa_flow_nominal; 3600/9*4,QCooLoa_flow_nominal; 3600/9*4,
        0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{140,200},{120,220}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa2_flow(table=[0,0; 3600/9*2,0;
        3600/9*2,QCooLoa_flow_nominal; 3600/9*5,QCooLoa_flow_nominal; 3600/9*5,
        0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{140,10},{120,30}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa3_flow(table=[0,0; 3600/9*3,0;
        3600/9*3,QCooLoa_flow_nominal; 3600/9*7,QCooLoa_flow_nominal; 3600/9*7,
        0; 3600,0])                                       "Cooling load"
    annotation (Placement(transformation(extent={{140,-160},{120,-140}})));
  Modelica.Blocks.Math.Gain gaiUsr1(k=1/ideUse1.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,170})));
  Modelica.Blocks.Math.Gain gaiUsr2(k=1/ideUse2.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-20})));
  Modelica.Blocks.Math.Gain gaiUsr3(k=1/ideUse3.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-190})));

// District pipe network
  Buildings.Experimental.DHC.Networks.Connection2Pipe con2PipPla2(
    redeclare package Medium = MediumCHW,
    final mDis_flow_nominal=m_flow_nominal,
    final mCon_flow_nominal=nomPla2.m_flow_nominal,
    final allowFlowReversal=true,
    final dpDis_nominal=0) "Two-pipe connection to the storage plant"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-90})));
  Buildings.Experimental.DHC.Networks.Connection2Pipe con2PipPla1(
    redeclare package Medium = MediumCHW,
    final mDis_flow_nominal=m_flow_nominal,
    final mCon_flow_nominal=chi1.m2_flow_nominal,
    final allowFlowReversal=true,
    final dpDis_nominal=0) "Two-pipe connection to the chiller-only plant"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,110})));
  Buildings.Experimental.DHC.Networks.Connection2Pipe con2PipUse2(
    redeclare package Medium = MediumCHW,
    final mDis_flow_nominal=m_flow_nominal,
    final mCon_flow_nominal=ideUse2.m_flow_nominal,
    final allowFlowReversal=true,
    final dpDis_nominal=0) "Two-pipe connection to the user(s)"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-10,0})));
equation
  connect(set_TRet.y, ideUse1.TSet) annotation (Line(points={{61,230},{80,230},{
          80,198},{61,198}},color={0,0,127}));
  connect(set_TRet.y, ideUse2.TSet) annotation (Line(points={{61,230},{80,230},
          {80,8},{61,8}}, color={0,0,127}));
  connect(set_TRet.y, ideUse3.TSet) annotation (Line(points={{61,230},{80,230},{
          80,-162},{61,-162}},color={0,0,127}));
  connect(ideUse3.yVal_actual, mulMax_yVal.u[1]) annotation (Line(points={{61,-174},
          {100,-174},{100,-210.667},{62,-210.667}},                       color=
         {0,0,127}));
  connect(ideUse2.yVal_actual, mulMax_yVal.u[2]) annotation (Line(points={{61,-4},
          {100,-4},{100,-210},{62,-210}}, color={0,0,127}));
  connect(mulMax_yVal.y, hysCat.u)
    annotation (Line(points={{38,-210},{-18,-210}},color={0,0,127}));
  connect(set_dpUsr.y,conPI_pumChi1. u_s)
    annotation (Line(points={{-99,250},{-70,250},{-70,242}},
                                                   color={0,0,127}));
  connect(ideUse1.yVal_actual, mulMax_yVal.u[3]) annotation (Line(points={{61,186},
          {100,186},{100,-209.333},{62,-209.333}},        color={0,0,127}));
  connect(set_QCooLoa1_flow.y, ideUse1.QCooLoa_flow) annotation (Line(points={{119,210},
          {110,210},{110,194},{61,194}},   color={0,0,127}));
  connect(set_QCooLoa2_flow.y, ideUse2.QCooLoa_flow) annotation (Line(points={{
          119,20},{110,20},{110,4},{61,4}}, color={0,0,127}));
  connect(set_QCooLoa3_flow.y, ideUse3.QCooLoa_flow) annotation (Line(points={{119,
          -150},{110,-150},{110,-166},{61,-166}},
                                               color={0,0,127}));
  connect(ideUse1.dpUsr, gaiUsr1.u)
    annotation (Line(points={{61,182},{110,182},{110,170},{118,170}},
                                                       color={0,0,127}));
  connect(ideUse2.dpUsr, gaiUsr2.u) annotation (Line(points={{61,-8},{110,-8},{
          110,-20},{118,-20}}, color={0,0,127}));
  connect(ideUse3.dpUsr, gaiUsr3.u)
    annotation (Line(points={{61,-178},{110,-178},{110,-190},{118,-190}},
                                                          color={0,0,127}));
  connect(gaiUsr1.y,mulMin_dpUsr. u[1]) annotation (Line(points={{141,170},{150,
          170},{150,249.333},{-18,249.333}},
                                     color={0,0,127}));
  connect(gaiUsr2.y,mulMin_dpUsr. u[2]) annotation (Line(points={{141,-20},{150,
          -20},{150,250},{-18,250}},               color={0,0,127}));
  connect(gaiUsr3.y,mulMin_dpUsr. u[3]) annotation (Line(points={{141,-190},{
          150,-190},{150,250.667},{-18,250.667}},
                                          color={0,0,127}));
  connect(mulMin_dpUsr.y,conPI_pumChi1. u_m)
    annotation (Line(points={{-42,250},{-52,250},{-52,230},{-58,230}},
                                                             color={0,0,127}));
  connect(uTanDis.y, mTanSet_flow.u) annotation (Line(points={{-159,-50},{-142,-50}},
                              color={255,0,255}));
  connect(mChiBra2Set_flow.u, uRemCha.y) annotation (Line(points={{-162,-130},{-170,
          -130},{-170,-150},{-150,-150},{-150,-170},{-159,-170}},
                            color={255,0,255}));
  connect(chiBra2.mPumSet_flow,mChiBra2Set_flow. y)
    annotation (Line(points={{-126,-101},{-126,-130},{-138,-130}},
                                                             color={0,0,127}));
  connect(conPI_pumChi1.y,pumSup1. y) annotation (Line(points={{-70,219},{-70,92}},
                           color={0,0,127}));
  connect(pumSup1.port_b, cheValPumChi1.port_a)
    annotation (Line(points={{-80,80},{-100,80}}, color={0,127,255}));
  connect(cheValPumChi1.port_b, chi1.port_a2) annotation (Line(points={{-120,80},
          {-124,80},{-124,100}},          color={0,127,255}));
  connect(souCDW1.ports[1], chi1.port_a1) annotation (Line(points={{-160,130},{-136,
          130},{-136,120}},                     color={0,127,255}));
  connect(chi1.port_b1, sinCDW1.ports[1]) annotation (Line(points={{-136,100},{-136,
          90},{-160,90}},           color={0,127,255}));
  connect(TEvaLvgSet.y, chi1.TSet)
    annotation (Line(points={{-159,250},{-127,250},{-127,122}},
                                                           color={0,0,127}));
  connect(on.y, chi1.on) annotation (Line(points={{-158,210},{-133,210},{-133,122}},
                    color={255,0,255}));
  connect(uRemCha.y, or2.u1) annotation (Line(points={{-159,-170},{-70,-170},{-70,
          -142}},                         color={255,0,255}));
  connect(hysCat.y, or2.u2) annotation (Line(points={{-42,-210},{-62,-210},{-62,
          -142}},
        color={255,0,255}));
  connect(conRemCha.uAva, or2.y) annotation (Line(points={{-58,-46},{-50,-46},{-50,
          -110},{-70,-110},{-70,-118}},
                     color={255,0,255}));
  connect(mTanSet_flow.y,conRemCha. mTanSet_flow) annotation (Line(points={{-118,
          -50},{-100,-50},{-100,-42},{-81,-42}},
                                               color={0,0,127}));
  connect(uRemCha.y,conRemCha. uRemCha) annotation (Line(points={{-159,-170},{-40,
          -170},{-40,-42},{-58,-42}},
        color={255,0,255}));
  connect(conRemCha.yPumSup,netCon. yPumSup)
    annotation (Line(points={{-72,-61},{-72,-79}}, color={0,0,127}));
  connect(conRemCha.yValSup,netCon. yValSup)
    annotation (Line(points={{-68,-61},{-68,-79}}, color={0,0,127}));
  connect(chiBra2.port_b, tanBra.port_aFroChi)
    annotation (Line(points={{-120,-84},{-110,-84}}, color={0,127,255}));
  connect(chiBra2.port_a, tanBra.port_bToChi)
    annotation (Line(points={{-120,-96},{-110,-96}}, color={0,127,255}));
  connect(tanBra.port_bToNet, netCon.port_aFroChi)
    annotation (Line(points={{-90,-84},{-80,-84}}, color={0,127,255}));
  connect(tanBra.port_aFroNet, netCon.port_bToChi)
    annotation (Line(points={{-90,-96},{-80,-96}}, color={0,127,255}));

  connect(tanBra.mTan_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-96,-79},{-96,-46},{-81,-46}}, color={0,0,127}));
  connect(netCon.port_bToNet, con2PipPla2.port_aCon)
    annotation (Line(points={{-60,-84},{-20,-84}}, color={0,127,255}));
  connect(con2PipPla2.port_bCon, netCon.port_aFroNet) annotation (Line(points={{
          -20,-90},{-52,-90},{-52,-96},{-60,-96}}, color={0,127,255}));
  connect(con2PipPla2.port_bDisRet, ideUse3.port_a) annotation (Line(points={{-4,
          -100},{-4,-154},{50,-154},{50,-160}}, color={0,127,255}));
  connect(ideUse3.port_b, con2PipPla2.port_aDisSup) annotation (Line(points={{50,
          -180},{50,-186},{-10,-186},{-10,-100}}, color={0,127,255}));
  connect(pumSup1.port_a, con2PipPla1.port_bCon) annotation (Line(points={{-60,80},
          {-26,80},{-26,110},{-20,110}}, color={0,127,255}));
  connect(chi1.port_b2, con2PipPla1.port_aCon) annotation (Line(points={{-124,120},
          {-124,128},{-28,128},{-28,116},{-20,116}}, color={0,127,255}));
  connect(con2PipPla1.port_aDisRet, ideUse1.port_a) annotation (Line(points={{-4,
          120},{-2,120},{-2,206},{50,206},{50,200}}, color={0,127,255}));
  connect(con2PipPla1.port_bDisSup, ideUse1.port_b) annotation (Line(points={{-10,
          120},{-10,174},{50,174},{50,180}}, color={0,127,255}));
  connect(con2PipPla2.port_bDisSup, con2PipUse2.port_bDisRet) annotation (Line(
        points={{-10,-80},{-10,-74},{-16,-74},{-16,-10}}, color={0,127,255}));
  connect(con2PipUse2.port_aDisSup, con2PipPla2.port_aDisRet) annotation (Line(
        points={{-10,-10},{-10,-16},{-4,-16},{-4,-80}}, color={0,127,255}));
  connect(con2PipUse2.port_aDisRet, con2PipPla1.port_aDisSup) annotation (Line(
        points={{-16,10},{-16,94},{-10,94},{-10,100}}, color={0,127,255}));
  connect(con2PipPla1.port_bDisRet, con2PipUse2.port_bDisSup) annotation (Line(
        points={{-4,100},{-4,18},{-10,18},{-10,10}}, color={0,127,255}));
  connect(con2PipUse2.port_bCon, ideUse2.port_a) annotation (Line(points={{0,-5.55112e-16},
          {34,-5.55112e-16},{34,16},{50,16},{50,10}}, color={0,127,255}));
  connect(con2PipUse2.port_aCon, ideUse2.port_b) annotation (Line(points={{0,6},
          {10,6},{10,-16},{50,-16},{50,-10}}, color={0,127,255}));
    annotation (
        Diagram(coordinateSystem(extent={{-180,-220},{160,280}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This is the base model of a district system model with
two CHW sources and three users with the following structure:
</p>
<p align=\"center\">
<img alt=\"DualSource\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/DualSource.png\"/>
</p>
<p>
The first source is a simplified CHW plant with only a chiller,
a single supply pump, and a check valve (with series resistance built in).
This supply pump is controlled to ensure that all users have enough pressure head.
</p>
<p>
The second source has a chiller and a stratified CHW tank. Its piping is arranged
in a way that allows the tank to be charged remotely by the other source.
Its supply pump is controlled to maintain the flow rate setpoint of the tank.
This plant is disconnected when the largest position of user control valves
less than 5% open and connected back when this value is higher than 10%.
</p>
<p>
The timetables give the system the following behaviour:
</p>
<table summary= \"system modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Time slots</th>
    <th>1</th>
    <th>2</th>
    <th>3</th>
    <th>4</th>
    <th>5</th>
    <th>6</th>
    <th>7</th>
    <th>8</th>
    <th>9</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>User 1</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>User 2</td>
    <td>-</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>User 3</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <td>Tank <br>(being charged)</td>
    <td>Local</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>-</td>
    <td>Remote</td>
    <td>Remote</td>
    <td>-</td>
  </tr>
</tbody>
</table>
</html>", revisions="<html>
<ul>
<li>
May 16, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PartialDualSource;
