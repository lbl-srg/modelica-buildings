within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model PartialSimpleNetwork
  "Simple idealised network model with two flow or pressure sources"

  package Medium = Buildings.Media.Water "Medium model";

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    useReturnPump=true,
    allowRemoteCharging=true,
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Sources.TimeTable mTanSet_flow(table=[0,0; 600,0; 600,1; 1200,
        1; 1200,0; 1800,0; 1800,-1; 3600,-1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Fluid.Sensors.MassFlowRate mTanSup_flow(redeclare final package
      Medium = Medium)
    "Tank mass flow rate on the supply side" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,20})));
  Buildings.Fluid.Sensors.MassFlowRate mTanRet_flow(
    redeclare final package Medium = Medium)
    "Tank mass flow rate on the return side" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,-20})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idePreSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=false,
    final control_dp=true)
    "Ideal pressure source representing a remote chiller plant" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-10})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideFloSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source representing the primary pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-110,-10})));
  Buildings.Fluid.FixedResistances.PressureDrop  preDroNet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.6)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,-10})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroSup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.15)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,50})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroRet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.15)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-50})));
  Modelica.Blocks.Sources.Constant dp(final k=-nom.dp_nominal*0.6)
    "Constant differential pressure"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Fluid.FixedResistances.Junction junSup1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Fluid.FixedResistances.Junction junRet1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the return side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,-50})));

  Buildings.Fluid.FixedResistances.Junction junSup2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Buildings.Fluid.FixedResistances.Junction junRet2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the return side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-50})));

  Modelica.Blocks.Sources.TimeTable mChiSet_flow(table=[0,0; 600,0; 600,1; 1800,
        1; 1800,2; 2400,2; 2400,1; 3000,1; 3000,0; 3600,0])
    "Mass flow rate setpoint for the primary pump"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Fluid.Storage.Plant.IdealReversibleConnection ideRevConSup(
    redeclare final package Medium = Medium,
    final nom=nom) "Ideal reversable connection on supply side"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Add the setpoints of the chiller and the tank together"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
protected
  Buildings.Fluid.BaseClasses.ActuatorFilter fil(
    f=20/(2*Modelica.Constants.pi*60),
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final n=2,
    final normalized=true) "Second order filter to improve numerics"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-10})));
equation
  connect(dp.y,idePreSou. dp_in) annotation (Line(points={{61,-10},{74,-10},{74,
          -4},{82,-4}},
                      color={0,0,127}));
  connect(junSup2.port_2,preDroNet. port_a)
    annotation (Line(points={{100,50},{130,50},{130,0}},
                                                       color={0,127,255}));
  connect(preDroNet.port_b,junRet2. port_1)
    annotation (Line(points={{130,-20},{130,-50},{100,-50}},
                                                          color={0,127,255}));
  connect(junRet2.port_3,idePreSou. port_a)
    annotation (Line(points={{90,-40},{90,-20}}, color={0,127,255}));
  connect(idePreSou.port_b,junSup2. port_3)
    annotation (Line(points={{90,0},{90,40}},  color={0,127,255}));
  connect(mTanSup_flow.port_b,junSup1. port_3)
    annotation (Line(points={{-70,30},{-70,40}}, color={0,127,255}));
  connect(junSup1.port_1,ideFloSou. port_b)
    annotation (Line(points={{-80,50},{-110,50},{-110,0}},
                                                         color={0,127,255}));
  connect(ideFloSou.port_a,junRet1. port_2) annotation (Line(points={{-110,-20},
          {-110,-50},{-80,-50}},
                               color={0,127,255}));
  connect(preDroSup.port_b,junSup2. port_1)
    annotation (Line(points={{60,50},{80,50}}, color={0,127,255}));
  connect(junRet2.port_2,preDroRet. port_a)
    annotation (Line(points={{80,-50},{60,-50}}, color={0,127,255}));
  connect(junRet1.port_3,mTanRet_flow. port_a)
    annotation (Line(points={{-70,-40},{-70,-30}}, color={0,127,255}));
  connect(mTanRet_flow.port_b,mTanSup_flow. port_a)
    annotation (Line(points={{-70,-10},{-70,10}}, color={0,127,255}));
  connect(ideRevConSup.port_b, preDroSup.port_a)
    annotation (Line(points={{0,50},{40,50}}, color={0,127,255}));
  connect(ideRevConSup.port_a, junSup1.port_2)
    annotation (Line(points={{-20,50},{-60,50}}, color={0,127,255}));
  connect(mTanSet_flow.y, add2.u1) annotation (Line(points={{-139,90},{-134,90},
          {-134,96},{-122,96}}, color={0,0,127}));
  connect(mChiSet_flow.y, add2.u2) annotation (Line(points={{-139,50},{-130,50},
          {-130,84},{-122,84}}, color={0,0,127}));
  connect(add2.y, ideRevConSup.mSet_flow) annotation (Line(points={{-98,90},{-26,
          90},{-26,55},{-21,55}}, color={0,0,127}));
  connect(mChiSet_flow.y, fil.u) annotation (Line(points={{-139,50},{-130,50},{
          -130,20},{-170,20},{-170,-10},{-162,-10}}, color={0,0,127}));
  connect(fil.y, ideFloSou.m_flow_in) annotation (Line(points={{-139,-10},{-126,
          -10},{-126,-16},{-118,-16}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600),
  Diagram(coordinateSystem(extent={{-180,-120},{160,120}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
[fixme: documentation pending.]
</p>
</html>"));
end PartialSimpleNetwork;
