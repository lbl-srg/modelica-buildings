within Buildings.Fluid.Storage.Plant.Examples;
model DualSource
  "A district system model with two sources and three users"

  extends Modelica.Icons.Example;

  package MediumCHW = Buildings.Media.Water "Medium model for CHW";
  package MediumCDW1 = Buildings.Media.Water "Medium model for CDW of chi1";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate to satisfy nominal load of one user";
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
        origin={-130,60})));
  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic perChi1(
    QEva_flow_nominal=-1E6,
    COP_nominal=3,
    PLRMax=1,
    PLRMinUnl=0.3,
    PLRMin=0.3,
    etaMotor=1,
    mEva_flow_nominal=m_flow_nominal,
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
      choicesAllMatching=true, Placement(transformation(extent={{-120,100},{-100,
            120}})));
 Buildings.Fluid.Movers.SpeedControlled_y pumSup1(
    redeclare package Medium = MediumCHW,
    per(pressure(dp=dp_nominal*{1.14, 1, 0.42},
                 V_flow=(chi1.m2_flow_nominal)/1000*{0, 1, 2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWS_nominal) "CHW supply pump for chi1"
                                                 annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,30})));
  Buildings.Fluid.FixedResistances.CheckValve cheValPumChi1(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=chi1.m2_flow_nominal,
    dpValve_nominal=0.1*dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,30})));
  Buildings.Controls.Continuous.LimPID conPI_pumChi1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.2,
    Ti=10,
    reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,230})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW1(
    redeclare package Medium = MediumCDW1,
    m_flow=1.2*chi1.m2_flow_nominal,
    T=305.15,
    nPorts=1) "Source representing CDW supply line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,80})));
  Buildings.Fluid.Sources.Boundary_pT sinCDW1(
    redeclare final package Medium = MediumCDW1,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-170,40})));
  Modelica.Blocks.Sources.Constant TEvaLvgSet(k=T_CHWS_nominal)
    "Evaporator leaving temperature setpoint" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,140})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant on(k=true)
    "Placeholder, chiller always on"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,110})));

// Second source: chiller and tank
  final parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nomPla2(
    allowRemoteCharging=true,
    m_flow_nominal=2*m_flow_nominal,
    mTan_flow_nominal=m_flow_nominal,
    mChi_flow_nominal=2*m_flow_nominal,
    dp_nominal=dp_nominal,
    T_CHWS_nominal=T_CHWS_nominal,
    T_CHWR_nominal=T_CHWS_nominal) "Nominal values for the second plant"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2,
    final TTan_start=nomPla2.T_CHWR_nominal)
                       "Tank branch, tank can be charged remotely" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-90})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch chiBra2(
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2) "Chiller branch"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = MediumCHW,
    final nom=nomPla2,
    final allowRemoteCharging=nomPla2.allowRemoteCharging,
    per(pressure(V_flow=nomPla2.m_flow_nominal/1000*{0, 1, 2},
                 dp=nomPla2.dp_nominal*{1.14, 1, 0.42})))
    "Supply pump and valves that connect the plant to the district network"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(table={360*7,360*9},
    startValue=false) "Tank is being charged remotely" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,-10})));
  Buildings.Fluid.Storage.Plant.Controls.RemoteCharging conRemCha
    "Control block for the secondary pump and valves"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-50})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Tank charging remotely OR there is load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-10})));

// Users
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse1(
    redeclare final package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,150})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse2(
    redeclare final package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-10})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse3(
    redeclare final package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-170})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin_dpUse(nin=3)
    "Min of pressure head measured from all users"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,210})));
  Modelica.Blocks.Sources.Constant set_dpUse(final k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,230})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysCat(uLow=0.05, uHigh=0.1)
    "Shut off at con.yVal = 0.05 and restarts at 0.1" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-250})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal(nin=3)
    "Max of valve positions"
    annotation (Placement(transformation(extent={{100,-260},{80,-240}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa1_flow(table=[0,0; 360*2,0; 360*2,
        QCooLoa_flow_nominal; 360*5,QCooLoa_flow_nominal; 360*5,0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{140,160},{120,180}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa2_flow(table=[0,0; 360*3,0; 360*3,
        QCooLoa_flow_nominal; 360*6,QCooLoa_flow_nominal; 360*6,0; 3600,0])
    "Cooling load"
    annotation (Placement(transformation(extent={{140,0},{120,20}})));
  Modelica.Blocks.Sources.TimeTable set_QCooLoa3_flow(table=[0,0; 360*4,0; 360*4,
        QCooLoa_flow_nominal; 360*8,QCooLoa_flow_nominal; 360*8,0; 3600,0])
                                                          "Cooling load"
    annotation (Placement(transformation(extent={{140,-160},{120,-140}})));
  Modelica.Blocks.Math.Gain gaiUse1(k=1/ideUse1.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,130})));
  Modelica.Blocks.Math.Gain gaiUse2(k=1/ideUse2.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-30})));
  Modelica.Blocks.Math.Gain gaiUse3(k=1/ideUse3.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={130,-190})));

// District pipe network
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions parJunUse1(
    redeclare final package Medium = MediumCHW,
    T1_start=nomPla2.T_CHWS_nominal,
    T2_start=nomPla2.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,150})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions parJunPla1(
    redeclare final package Medium = MediumCHW,
    T1_start=nomPla2.T_CHWS_nominal,
    T2_start=nomPla2.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,70})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions parJunUse2(
    redeclare final package Medium = MediumCHW,
    T1_start=nomPla2.T_CHWS_nominal,
    T2_start=nomPla2.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,-10})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions parJunPla2(
    redeclare final package Medium = MediumCHW,
    T1_start=nomPla2.T_CHWS_nominal,
    T2_start=nomPla2.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,-90})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions parJunUse3(
    redeclare final package Medium = MediumCHW,
    T1_start=nomPla2.T_CHWS_nominal,
    T2_start=nomPla2.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,-170})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelPipes parPipS1U1(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,110})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelPipes parPipS1U2(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,30})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelPipes parPipS2U2(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,-50})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelPipes parPipS2U3(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.3*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,-130})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PipeEnd pipEnd1(
    redeclare final package Medium = MediumCHW)
    "End of distribution pipe lines" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,190})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PipeEnd pipEnd2(
    redeclare final package Medium = MediumCHW)
    "End of distribution pipe lines" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-210})));

  Buildings.Fluid.FixedResistances.Junction junBou(
    redeclare final package Medium = MediumCHW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nomPla2.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nomPla2.m_flow_nominal,nomPla2.m_flow_nominal,1},
    final dp_nominal={0,0,0}) "Junction connected to the pressure boundary"
    annotation (Placement(transformation(extent={{-40,-106},{-20,-86}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    p(final displayUnit="Pa") = 101325 + dp_nominal,
    redeclare final package Medium = MediumCHW,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-130})));
  Modelica.Blocks.Sources.TimeTable mTanSet_flow(table=[0,0; 360*1,0;
    360*1,-nomPla2.mTan_flow_nominal; 360*3,-nomPla2.mTan_flow_nominal; 360*3,0;
    360*4,0; 360*4,nomPla2.mTan_flow_nominal; 360*6,nomPla2.mTan_flow_nominal;
    360*6,0; 360*7,0; 360*7,-nomPla2.mTan_flow_nominal;
    360*9,-nomPla2.mTan_flow_nominal;360*9,0]) "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Modelica.Blocks.Sources.TimeTable mChi2Set_flow(table=[0,0; 360*1,0;
    360*1,nomPla2.mTan_flow_nominal; 360*3,nomPla2.mTan_flow_nominal;
    360*3,m_flow_nominal; 360*5,m_flow_nominal; 360*5,0])
    "Flow rate setpoint for the chiller in the storage plant"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));

equation
  connect(ideUse3.yVal_actual, mulMax_yVal.u[1]) annotation (Line(points={{101,
          -162},{110,-162},{110,-250.667},{102,-250.667}},                color=
         {0,0,127}));
  connect(ideUse2.yVal_actual, mulMax_yVal.u[2]) annotation (Line(points={{101,-2},
          {110,-2},{110,-250},{102,-250}},color={0,0,127}));
  connect(mulMax_yVal.y, hysCat.u)
    annotation (Line(points={{78,-250},{62,-250}}, color={0,0,127}));
  connect(set_dpUse.y,conPI_pumChi1.u_s)
    annotation (Line(points={{-119,230},{-102,230}},
                                                   color={0,0,127}));
  connect(ideUse1.yVal_actual, mulMax_yVal.u[3]) annotation (Line(points={{101,158},
          {110,158},{110,-249.333},{102,-249.333}},       color={0,0,127}));
  connect(set_QCooLoa1_flow.y, ideUse1.QCooLoa_flow) annotation (Line(points={{119,170},
          {78,170},{78,158},{79,158}},     color={0,0,127}));
  connect(set_QCooLoa2_flow.y, ideUse2.QCooLoa_flow) annotation (Line(points={{119,10},
          {78,10},{78,-2},{79,-2}},         color={0,0,127}));
  connect(set_QCooLoa3_flow.y, ideUse3.QCooLoa_flow) annotation (Line(points={{119,
          -150},{78,-150},{78,-162},{79,-162}},color={0,0,127}));
  connect(ideUse1.dp, gaiUse1.u) annotation (Line(points={{101,154},{114,154},{
          114,130},{118,130}}, color={0,0,127}));
  connect(ideUse2.dp, gaiUse2.u) annotation (Line(points={{101,-6},{114,-6},{
          114,-30},{118,-30}}, color={0,0,127}));
  connect(ideUse3.dp, gaiUse3.u) annotation (Line(points={{101,-166},{114,-166},
          {114,-190},{118,-190}}, color={0,0,127}));
  connect(gaiUse1.y,mulMin_dpUse.u[1]) annotation (Line(points={{141,130},{146,
          130},{146,209.333},{-18,209.333}},
                                     color={0,0,127}));
  connect(gaiUse2.y,mulMin_dpUse.u[2]) annotation (Line(points={{141,-30},{150,-30},
          {150,210},{-18,210}},                    color={0,0,127}));
  connect(gaiUse3.y,mulMin_dpUse.u[3]) annotation (Line(points={{141,-190},{146,
          -190},{146,210.667},{-18,210.667}},
                                          color={0,0,127}));
  connect(mulMin_dpUse.y,conPI_pumChi1.u_m)
    annotation (Line(points={{-42,210},{-90,210},{-90,218}}, color={0,0,127}));
  connect(conPI_pumChi1.y,pumSup1. y) annotation (Line(points={{-79,230},{-70,230},
          {-70,42}},       color={0,0,127}));
  connect(pumSup1.port_b, cheValPumChi1.port_a)
    annotation (Line(points={{-80,30},{-100,30}}, color={0,127,255}));
  connect(cheValPumChi1.port_b, chi1.port_a2) annotation (Line(points={{-120,30},
          {-124,30},{-124,50}},           color={0,127,255}));
  connect(souCDW1.ports[1], chi1.port_a1) annotation (Line(points={{-160,80},{-136,
          80},{-136,70}},                       color={0,127,255}));
  connect(chi1.port_b1, sinCDW1.ports[1]) annotation (Line(points={{-136,50},{-136,
          40},{-160,40}},           color={0,127,255}));
  connect(TEvaLvgSet.y, chi1.TSet)
    annotation (Line(points={{-159,140},{-127,140},{-127,72}},
                                                           color={0,0,127}));
  connect(on.y, chi1.on) annotation (Line(points={{-158,110},{-133,110},{-133,72}},
                    color={255,0,255}));
  connect(uRemCha.y, or2.u1) annotation (Line(points={{-159,-10},{-142,-10}},
                                          color={255,0,255}));
  connect(hysCat.y, or2.u2) annotation (Line(points={{38,-250},{-148,-250},{-148,
          -18},{-142,-18}},
        color={255,0,255}));
  connect(conRemCha.uAva, or2.y) annotation (Line(points={{-42,-44},{-58,-44},{-58,
          -10},{-118,-10}},
                     color={255,0,255}));
  connect(uRemCha.y,conRemCha. uRemCha) annotation (Line(points={{-159,-10},{-152,
          -10},{-152,-24},{-62,-24},{-62,-48},{-42,-48}},
        color={255,0,255}));
  connect(conRemCha.yPum, netCon.yPum)
    annotation (Line(points={{-19,-56},{8,-56},{8,-79}}, color={0,0,127}));
  connect(conRemCha.yVal, netCon.yVal)
    annotation (Line(points={{-19,-52},{12,-52},{12,-79}}, color={0,0,127}));
  connect(chiBra2.port_b, tanBra.port_aFroChi)
    annotation (Line(points={{-100,-84},{-80,-84}},  color={0,127,255}));
  connect(chiBra2.port_a, tanBra.port_bToChi)
    annotation (Line(points={{-100,-96},{-80,-96}},  color={0,127,255}));
  connect(tanBra.mTan_flow, conRemCha.mTan_flow)
    annotation (Line(points={{-66,-79},{-66,-56},{-41,-56}}, color={0,0,127}));
  connect(junBou.port_3, bou.ports[1])
    annotation (Line(points={{-30,-106},{-30,-120}},
                                                   color={0,127,255}));
  connect(junBou.port_1, tanBra.port_aFroNet)
    annotation (Line(points={{-40,-96},{-60,-96}},  color={0,127,255}));
  connect(junBou.port_2, netCon.port_bToChi)
    annotation (Line(points={{-20,-96},{0,-96}},   color={0,127,255}));
  connect(netCon.port_aFroChi, tanBra.port_bToNet)
    annotation (Line(points={{0,-84},{-60,-84}},    color={0,127,255}));
  connect(mTanSet_flow.y, conRemCha.mTanSet_flow) annotation (Line(points={{-119,
          -50},{-66,-50},{-66,-52},{-41,-52}},   color={0,0,127}));
  connect(mChi2Set_flow.y, chiBra2.mPumSet_flow) annotation (Line(points={{-119,
          -130},{-106,-130},{-106,-101}}, color={0,0,127}));
  connect(parJunPla1.port_c1, chi1.port_b2) annotation (Line(points={{40,76},{-124,
          76},{-124,70}},                     color={0,127,255}));
  connect(pumSup1.port_a,parJunPla1.port_c2)  annotation (Line(points={{-60,30},
          {34,30},{34,64},{40,64}}, color={0,127,255}));
  connect(parJunPla2.port_c1, netCon.port_bToNet)
    annotation (Line(points={{40,-84},{20,-84}}, color={0,127,255}));
  connect(netCon.port_aFroNet,parJunPla2.port_c2)
    annotation (Line(points={{20,-96},{40,-96}}, color={0,127,255}));
  connect(parJunUse1.port_a2, pipEnd1.port_a)
    annotation (Line(points={{44,160},{44,180}}, color={0,127,255}));
  connect(pipEnd1.port_b, parJunUse1.port_b1)
    annotation (Line(points={{56,180},{56,160}}, color={0,127,255}));
  connect(parJunUse1.port_c2, ideUse1.port_a) annotation (Line(points={{60,156},
          {80,156}},                          color={0,127,255}));
  connect(parJunUse1.port_c1, ideUse1.port_b) annotation (Line(points={{60,144},
          {80,144}},                       color={0,127,255}));
  connect(parJunUse2.port_c2, ideUse2.port_a) annotation (Line(points={{60,-4},
          {80,-4}},                     color={0,127,255}));
  connect(ideUse2.port_b,parJunUse2.port_c1)  annotation (Line(points={{80,-16},
          {60,-16}},                            color={0,127,255}));
  connect(parJunUse3.port_a1, pipEnd2.port_a)
    annotation (Line(points={{56,-180},{56,-200}}, color={0,127,255}));
  connect(pipEnd2.port_b, parJunUse3.port_b2)
    annotation (Line(points={{44,-200},{44,-180}}, color={0,127,255}));
  connect(parJunUse3.port_c2, ideUse3.port_a) annotation (Line(points={{60,-164},
          {80,-164}},                               color={0,127,255}));
  connect(ideUse3.port_b,parJunUse3.port_c1)  annotation (Line(points={{80,-176},
          {60,-176}},                               color={0,127,255}));
  connect(parPipS1U1.port_a2, parJunUse1.port_b2)
    annotation (Line(points={{44,120},{44,140}}, color={0,127,255}));
  connect(parPipS1U1.port_b2, parJunPla1.port_a1)
    annotation (Line(points={{44,100},{44,80}}, color={0,127,255}));
  connect(parJunPla1.port_b2, parPipS1U1.port_a1)
    annotation (Line(points={{56,80},{56,100}}, color={0,127,255}));
  connect(parPipS1U1.port_b1, parJunUse1.port_a1)
    annotation (Line(points={{56,120},{56,140}}, color={0,127,255}));
  connect(parJunPla1.port_b1, parPipS1U2.port_a2)
    annotation (Line(points={{44,60},{44,40}}, color={0,127,255}));
  connect(parPipS1U2.port_b2, parJunUse2.port_a2)
    annotation (Line(points={{44,20},{44,0}}, color={0,127,255}));
  connect(parJunUse2.port_b1, parPipS1U2.port_a1)
    annotation (Line(points={{56,0},{56,20}}, color={0,127,255}));
  connect(parPipS1U2.port_b1, parJunPla1.port_a2)
    annotation (Line(points={{56,40},{56,60}}, color={0,127,255}));
  connect(parJunUse2.port_b2, parPipS2U2.port_a2)
    annotation (Line(points={{44,-20},{44,-40}}, color={0,127,255}));
  connect(parPipS2U2.port_b1, parJunUse2.port_a1)
    annotation (Line(points={{56,-40},{56,-20}}, color={0,127,255}));
  connect(parPipS2U2.port_a1, parJunPla2.port_b2)
    annotation (Line(points={{56,-60},{56,-80}}, color={0,127,255}));
  connect(parJunPla2.port_a1, parPipS2U2.port_b2)
    annotation (Line(points={{44,-80},{44,-60}}, color={0,127,255}));
  connect(parPipS2U3.port_a2, parJunPla2.port_b1)
    annotation (Line(points={{44,-120},{44,-100}}, color={0,127,255}));
  connect(parJunPla2.port_a2, parPipS2U3.port_b1)
    annotation (Line(points={{56,-100},{56,-120}}, color={0,127,255}));
  connect(parPipS2U3.port_a1, parJunUse3.port_b1)
    annotation (Line(points={{56,-140},{56,-160}}, color={0,127,255}));
  connect(parJunUse3.port_a2, parPipS2U3.port_b2)
    annotation (Line(points={{44,-160},{44,-140}}, color={0,127,255}));
    annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/DualSource.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600),
        Diagram(coordinateSystem(extent={{-200,-260},{160,260}})),
        Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This is a district system model with two CHW plants and three users
with the following architecture:
</p>
<p align=\"center\">
<img alt=\"DualSource\"
src=\"modelica://Buildings/Resources/Images/Fluid/Storage/DualSource.png\"/>
</p>
<p>
The first CHW source is a simplified CHW plant with only a chiller and
a single supply pump.
This supply pump is controlled to ensure that all users have enough pressure head.
</p>
<p>
The second CHW source has a chiller and a stratified CHW tank. Its piping is
arranged in a way that allows the tank to be charged remotely by the other source.
The secondary pump is controlled to maintain the flow rate setpoint of the tank.
This plant is disconnected when the largest position of user control valves
less than 5% open and connected back when this value is higher than 10%.
</p>
<p>
The source blocks give the system the following operation schedule during
simulation:
</p>
<table summary= \"system modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Time Slot</th>
    <th>Plant 1 Flow</th>
    <th colspan=\"4\">Plant 2 Flows</th>
    <th colspan=\"3\">Users</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td></td>
    <td></td>
    <td>Chiller</td>
    <td>Tank*</td>
    <td>Charging</td>
    <td>Overall**</td>
    <td>1</td>
    <td>2</td>
    <td>3</td>
    <td></td>
  </tr>
  <tr>
    <td>1</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>N/A</td>
    <td>0</td>
    <td></td>
    <td></td>
    <td></td>
    <td>No load. No flow.</td>
  </tr>
  <tr>
    <td>2</td>
    <td>0</td>
    <td>+</td>
    <td>-</td>
    <td>Local</td>
    <td>0</td>
    <td></td>
    <td></td>
    <td></td>
    <td>No load. Tank is being charged locally.</td>
  </tr>
  <tr>
    <td>3</td>
    <td>+</td>
    <td>+</td>
    <td>-</td>
    <td>Local</td>
    <td>0</td>
    <td>Has load</td>
    <td></td>
    <td></td>
    <td>Plant 1 outputs CHW to satisfy load. Plant 2 still offline and in local charging.</td>
  </tr>
  <tr>
    <td>4</td>
    <td>+</td>
    <td>+</td>
    <td>0</td>
    <td>N/A</td>
    <td>+</td>
    <td>Has load</td>
    <td>Has load</td>
    <td></td>
    <td>Both plants output CHW. Tank holding.</td>
  </tr>
  <tr>
    <td>5</td>
    <td>+</td>
    <td>+</td>
    <td>+</td>
    <td>N/A</td>
    <td>+</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Both plants including tank output CHW.</td>
  </tr>
  <tr>
    <td>6</td>
    <td>+</td>
    <td>0</td>
    <td>+</td>
    <td>N/A</td>
    <td>+</td>
    <td></td>
    <td>Has load</td>
    <td>Has load</td>
    <td>Plant 1 and tank output CHW, chiller 2 off.</td>
  </tr>
  <tr>
    <td>7</td>
    <td>+</td>
    <td>0</td>
    <td>0</td>
    <td>N/A</td>
    <td>0</td>
    <td></td>
    <td></td>
    <td>Has load</td>
    <td>Plant 1 outputs CHW to satisfy load. Plant 2 off.</td>
  </tr>
  <tr>
    <td>8</td>
    <td>+</td>
    <td>0</td>
    <td>-</td>
    <td>Remote</td>
    <td>-</td>
    <td></td>
    <td></td>
    <td>Has load</td>
    <td>Plant 1 outputs CHW to satisfy load and remotely charge tank.</td>
  </tr>
  <tr>
    <td>9</td>
    <td>+</td>
    <td>0</td>
    <td>-</td>
    <td>Remote</td>
    <td>-</td>
    <td></td>
    <td></td>
    <td></td>
    <td>Plant 1 remotely charges tank.</td>
  </tr>
  <tr>
    <td>10</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>N/A</td>
    <td>0</td>
    <td></td>
    <td></td>
    <td></td>
    <td>No load. No flow.</td>
  </tr>
</tbody>
</table>
<p>
Notes:<br/>
*. A positive flow rate at the tank denotes that the tank is discharging
and a negative flow rate denotes that it is being charged.<br/>
**. A positive flow rate denotes that the flow direction of Plant 2 is the same
as the nominal flow direction (outputting CHW to the network).
A negative flow only occurs when its tank is being charged remotely.
</p>
</html>", revisions="<html>
<ul>
<li>
September 28, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end DualSource;
