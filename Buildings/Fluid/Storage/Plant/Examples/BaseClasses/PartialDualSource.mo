within Buildings.Fluid.Storage.Plant.Examples.BaseClasses;
partial model PartialDualSource
  "Idealised district system model with two sources and three users"

  package Medium = Buildings.Media.Water "Medium model for CHW";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, slightly larger than needed by one user load";
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

// First source: chiller only
 Buildings.Fluid.Movers.SpeedControlled_y pumSup1(
    redeclare package Medium = Medium,
    per(pressure(dp=dp_nominal*{1.14,1,0.42}, V_flow=(m_flow_nominal)/1000*{0,1,
            2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWS_nominal) "CHW supply pump for chi1"
                                                 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,90})));
  Buildings.Controls.Continuous.LimPID conPI_pumChi1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.2,
    Ti=10,
    reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-92,170})));

// Second source: chiller and tank
  final parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    allowRemoteCharging=true,
    useReturnPump=false,
    m_flow_nominal=2*m_flow_nominal,
    mTan_flow_nominal=m_flow_nominal,
    mChi_flow_nominal=2*m_flow_nominal,
    dp_nominal=dp_nominal,
    T_CHWS_nominal=T_CHWS_nominal,
    T_CHWR_nominal=T_CHWS_nominal) "Nominal values for the second plant"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    redeclare final package Medium = Medium,
    final nom=nom,
    final TTan_start=nom.T_CHWR_nominal)
    "Tank branch, tank can be charged remotely" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-90})));

// Users
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse1(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,150})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse2(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-10})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse3(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-170})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin mulMin_dpUse(nin=3)
    "Min of pressure head measured from all users"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,130})));
  Modelica.Blocks.Sources.Constant set_dpUse(final k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,170})));
  Modelica.Blocks.Sources.TimeTable mLoa1_flow(table=[0,0; 360*2,0; 360*2,
        ideUse1.m_flow_nominal; 360*5,ideUse1.m_flow_nominal; 360*5,0; 3600,0])
    "Cooling load of user 1 represented by flow rate"
    annotation (Placement(transformation(extent={{140,160},{120,180}})));
  Modelica.Blocks.Sources.TimeTable mLoa2_flow(table=[0,0; 360*3,0; 360*3,
        ideUse2.m_flow_nominal; 360*6,ideUse2.m_flow_nominal; 360*6,0; 3600,0])
    "Cooling load of user 2 represented by flow rate"
    annotation (Placement(transformation(extent={{140,0},{120,20}})));
  Modelica.Blocks.Sources.TimeTable mLoa3_flow(table=[0,0; 360*4,0; 360*4,
        ideUse3.m_flow_nominal; 360*8,ideUse3.m_flow_nominal; 360*8,0; 3600,0])
    "Cooling load of user 3 represented by flow rate"
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
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions
    parJunUse1(
    redeclare final package Medium = Medium,
    T1_start=nom.T_CHWS_nominal,
    T2_start=nom.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,150})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions
    parJunPla1(
    redeclare final package Medium = Medium,
    T1_start=nom.T_CHWS_nominal,
    T2_start=nom.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,70})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions
    parJunUse2(
    redeclare final package Medium = Medium,
    T1_start=nom.T_CHWS_nominal,
    T2_start=nom.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,-10})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions
    parJunPla2(
    redeclare final package Medium = Medium,
    T1_start=nom.T_CHWS_nominal,
    T2_start=nom.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={50,-90})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelJunctions
    parJunUse3(
    redeclare final package Medium = Medium,
    T1_start=nom.T_CHWS_nominal,
    T2_start=nom.T_CHWS_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,-170})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelPipes parPipS1U1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.15*dp_nominal)
                               "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,110})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelPipes parPipS1U2(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    dp_nominal=0.15*dp_nominal)
                               "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,30})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelPipes parPipS2U2(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    dp_nominal=0.15*dp_nominal)
                               "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,-50})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ParallelPipes parPipS2U3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.15*dp_nominal)
                               "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={50,-130})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PipeEnd pipEnd1(
    redeclare final package Medium = Medium)
    "End of distribution pipe lines" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={50,190})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.PipeEnd pipEnd2(
    redeclare final package Medium = Medium)
    "End of distribution pipe lines" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-210})));
  Modelica.Blocks.Sources.TimeTable mTanSet_flow(table=[0,0; 360*1,0; 360*1,-
        nom.mTan_flow_nominal; 360*3,-nom.mTan_flow_nominal; 360*3,0; 360*4,0;
        360*4,nom.mTan_flow_nominal; 360*6,nom.mTan_flow_nominal; 360*6,0; 360*
        7,0; 360*7,-nom.mTan_flow_nominal; 360*9,-nom.mTan_flow_nominal; 360*9,
        0]) "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Sources.TimeTable mChi2Set_flow(table=[0,0; 360*1,0; 360*1,
        nom.mTan_flow_nominal; 360*3,nom.mTan_flow_nominal; 360*3,
        m_flow_nominal; 360*5,m_flow_nominal; 360*5,0])
    "Flow rate setpoint for the chiller in the storage plant"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

  Movers.FlowControlled_m_flow pumPri2(
    redeclare final package Medium = Medium,
    per(pressure(dp=chi2PreDro.dp_nominal*{1.14,1,0.42}, V_flow=nom.mChi_flow_nominal
            /1000*{0,1,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=nom.mChi_flow_nominal,
    allowFlowReversal=true,
    addPowerToMedium=false,
    m_flow_start=0,
    T_start=nom.T_CHWR_nominal) "Primary CHW pump of plant 2" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-70})));
  FixedResistances.PressureDrop chi2PreDro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.mChi_flow_nominal,
    dp_nominal=0.1*nom.dp_nominal)
    "Pressure drop of the chiller branch in plant 2"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-110,-110})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Add the setpoints of the chiller and the tank together"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  IdealReversibleConnection                               ideRevConSup(
      redeclare final package Medium = Medium, final nom=nom)
                   "Ideal reversable connection on supply side"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
equation
  connect(set_dpUse.y,conPI_pumChi1.u_s)
    annotation (Line(points={{-119,170},{-104,170}},
                                                   color={0,0,127}));
  connect(mLoa1_flow.y, ideUse1.mPre_flow) annotation (Line(points={{119,170},{78,
          170},{78,158},{79,158}}, color={0,0,127}));
  connect(mLoa2_flow.y, ideUse2.mPre_flow) annotation (Line(points={{119,10},{78,
          10},{78,-2},{79,-2}}, color={0,0,127}));
  connect(mLoa3_flow.y, ideUse3.mPre_flow) annotation (Line(points={{119,-150},{
          78,-150},{78,-162},{79,-162}}, color={0,0,127}));
  connect(ideUse1.dp, gaiUse1.u) annotation (Line(points={{101,154},{114,154},{
          114,130},{118,130}}, color={0,0,127}));
  connect(ideUse2.dp, gaiUse2.u) annotation (Line(points={{101,-6},{114,-6},{
          114,-30},{118,-30}}, color={0,0,127}));
  connect(ideUse3.dp, gaiUse3.u) annotation (Line(points={{101,-166},{114,-166},
          {114,-190},{118,-190}}, color={0,0,127}));
  connect(gaiUse1.y,mulMin_dpUse.u[1]) annotation (Line(points={{141,130},{150,
          130},{150,-230},{-170,-230},{-170,129.333},{-142,129.333}},
                                     color={0,0,127}));
  connect(gaiUse2.y,mulMin_dpUse.u[2]) annotation (Line(points={{141,-30},{150,-30},
          {150,-230},{-170,-230},{-170,130},{-142,130}},
                                                   color={0,0,127}));
  connect(gaiUse3.y,mulMin_dpUse.u[3]) annotation (Line(points={{141,-190},{150,
          -190},{150,-230},{-170,-230},{-170,130.667},{-142,130.667}},
                                          color={0,0,127}));
  connect(mulMin_dpUse.y,conPI_pumChi1.u_m)
    annotation (Line(points={{-118,130},{-92,130},{-92,158}},color={0,0,127}));
  connect(conPI_pumChi1.y,pumSup1. y) annotation (Line(points={{-81,170},{-10,170},
          {-10,102}},      color={0,0,127}));
  connect(pumSup1.port_a,parJunPla1.port_c2)  annotation (Line(points={{-20,90},
          {-40,90},{-40,64},{40,64}},
                                    color={0,127,255}));
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
  connect(pumSup1.port_b, parJunPla1.port_c1) annotation (Line(points={{0,90},{20,
          90},{20,76},{40,76}},     color={0,127,255}));
  connect(pumPri2.port_b, tanBra.port_aFroChi) annotation (Line(points={{-100,-70},
          {-90,-70},{-90,-84},{-80,-84}}, color={0,127,255}));
  connect(tanBra.port_bToChi,chi2PreDro. port_a) annotation (Line(points={{-80,-96},
          {-90,-96},{-90,-110},{-100,-110}}, color={0,127,255}));
  connect(chi2PreDro.port_b, pumPri2.port_a) annotation (Line(points={{-120,-110},
          {-126,-110},{-126,-70},{-120,-70}}, color={0,127,255}));
  connect(mChi2Set_flow.y, pumPri2.m_flow_in) annotation (Line(points={{-139,-30},
          {-110,-30},{-110,-58}}, color={0,0,127}));
  connect(mTanSet_flow.y, add2.u1) annotation (Line(points={{-99,-10},{-92,-10},
          {-92,-24},{-82,-24}}, color={0,0,127}));
  connect(mChi2Set_flow.y, add2.u2) annotation (Line(points={{-139,-30},{-110,-30},
          {-110,-36},{-82,-36}}, color={0,0,127}));
  connect(tanBra.port_bToNet, ideRevConSup.port_a) annotation (Line(points={{-60,
          -84},{-40,-84},{-40,-70},{-20,-70}}, color={0,127,255}));
  connect(add2.y, ideRevConSup.mSet_flow) annotation (Line(points={{-58,-30},{-40,
          -30},{-40,-65},{-21,-65}}, color={0,0,127}));
  connect(ideRevConSup.port_b, parJunPla2.port_c1) annotation (Line(points={{0,-70},
          {20,-70},{20,-84},{40,-84}}, color={0,127,255}));
    annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/IdealDualSource.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-06, StopTime=3600),
        Diagram(coordinateSystem(extent={{-180,-240},{160,220}})),
        Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model is a simplified duplicate of
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Examples.DualSource\">
Buildings.Fluid.Storage.Plant.Examples.DualSource</a>.
It is intended to simulate the pump power consumption at the connection
between the storage plant and the district CHW network without dealing with
the details and intricacies of controls and numerical challenges
for the connection pumps and valves.
</p>
</html>", revisions="<html>
<ul>
<li>
November 11, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PartialDualSource;
