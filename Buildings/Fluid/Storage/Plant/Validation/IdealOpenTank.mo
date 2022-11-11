within Buildings.Fluid.Storage.Plant.Validation;
model IdealOpenTank "Idealised model with two pressurisation points"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    useReturnPump=true,
    allowRemoteCharging=true,
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Modelica.Blocks.Sources.TimeTable mTanSet_flow(table=[0,0; 600,0; 600,1; 1200,
        1; 1200,0; 1800,0; 1800,-1; 3600,-1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.BooleanTable uAva(final table={600,2400,3000}, final
      startValue=false)     "Plant availability"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
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
        origin={90,0})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource ideFloSou(
    redeclare final package Medium = Medium,
    final m_flow_small=1E-5,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source representing the primary pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-108,6})));
  Buildings.Fluid.FixedResistances.PressureDrop  preDroNet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal,
    final dp_nominal=nom.dp_nominal*0.6)
    "Flow resistance in the district network" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,0})));
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
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
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

  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 101325,
    nPorts=1)                                       "Pressure boundary"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={90,-90})));
  Modelica.Blocks.Sources.TimeTable mChiSet_flow(table=[0,0; 600,0; 600,1; 1800,
        1; 1800,2; 2400,2; 2400,1; 3000,1; 3000,0; 3600,0])
    "Mass flow rate setpoint for the primary pump"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(final table={3000}, final
      startValue=false) "Remote charging status"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 101325,
    nPorts=1) "Pressure boundary"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-90})));
  Buildings.Fluid.Storage.Plant.IdealConnection ideCon(
    redeclare final package Medium = Medium,
    final nom=nom)
    "Ideal connection between the storage plant and the network"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(dp.y,idePreSou. dp_in) annotation (Line(points={{61,-90},{68,-90},{68,
          6},{82,6}}, color={0,0,127}));
  connect(junSup2.port_2,preDroNet. port_a)
    annotation (Line(points={{100,50},{130,50},{130,10}},
                                                       color={0,127,255}));
  connect(preDroNet.port_b,junRet2. port_1)
    annotation (Line(points={{130,-10},{130,-50},{100,-50}},
                                                          color={0,127,255}));
  connect(junRet2.port_3,idePreSou. port_a)
    annotation (Line(points={{90,-40},{90,-10}}, color={0,127,255}));
  connect(idePreSou.port_b,junSup2. port_3)
    annotation (Line(points={{90,10},{90,40}}, color={0,127,255}));
  connect(mTanSup_flow.port_b,junSup1. port_3)
    annotation (Line(points={{-70,30},{-70,40}}, color={0,127,255}));
  connect(junSup1.port_1,ideFloSou. port_b)
    annotation (Line(points={{-80,50},{-108,50},{-108,16}},
                                                         color={0,127,255}));
  connect(ideFloSou.port_a,junRet1. port_2) annotation (Line(points={{-108,-4},{
          -108,-50},{-80,-50}},color={0,127,255}));
  connect(preDroSup.port_b,junSup2. port_1)
    annotation (Line(points={{60,50},{80,50}}, color={0,127,255}));
  connect(junRet2.port_2,preDroRet. port_a)
    annotation (Line(points={{80,-50},{60,-50}}, color={0,127,255}));
  connect(bou1.ports[1],preDroNet. port_b) annotation (Line(points={{100,-90},{130,
          -90},{130,-10}}, color={0,127,255}));
  connect(junRet1.port_3,mTanRet_flow. port_a)
    annotation (Line(points={{-70,-40},{-70,-30}}, color={0,127,255}));
  connect(mTanRet_flow.port_b,mTanSup_flow. port_a)
    annotation (Line(points={{-70,-10},{-70,10}}, color={0,127,255}));
  connect(bou2.ports[1],mTanSup_flow. port_a) annotation (Line(points={{-20,-90},
          {-12,-90},{-12,0},{-70,0},{-70,10}}, color={0,127,255}));
  connect(ideCon.port_bToNet, preDroSup.port_a) annotation (Line(points={{20,6},
          {34,6},{34,50},{40,50}}, color={0,127,255}));
  connect(ideCon.port_aFroNet, preDroRet.port_b) annotation (Line(points={{20,-6},
          {34,-6},{34,-50},{40,-50}}, color={0,127,255}));
  connect(ideCon.port_aFroChi, junSup1.port_2) annotation (Line(points={{0,6},{-8,
          6},{-8,50},{-60,50}}, color={0,127,255}));
  connect(junRet1.port_1, ideCon.port_bToChi) annotation (Line(points={{-60,-50},
          {-8,-50},{-8,-6},{0,-6}}, color={0,127,255}));
  connect(mChiSet_flow.y, ideCon.mChiSet_flow) annotation (Line(points={{-119,-90},
          {-48,-90},{-48,20},{4,20},{4,11}},                     color={0,0,127}));
  connect(mTanSet_flow.y, ideCon.mTanSet_flow)
    annotation (Line(points={{-79,70},{8,70},{8,11}}, color={0,0,127}));
  connect(mChiSet_flow.y, ideFloSou.m_flow_in) annotation (Line(points={{-119,-90},
          {-100,-90},{-100,-60},{-122,-60},{-122,6.66134e-16},{-116,6.66134e-16}},
        color={0,0,127}));
  annotation (experiment(Tolerance=1e-06, StopTime=3600),
  Diagram(coordinateSystem(extent={{-160,-120},{160,140}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/IdealOpenTank.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is a simplified duplicate of
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Validation.OpenTank\">
Buildings.Fluid.Storage.Plant.Validation.OpenTank</a>.
It is intended to simulate the pump power consumption at the connection
between the storage plant and the district CHW network without dealing with
the details and intricacies of controls and numerical challenges
for the connection pumps and valves.
</p>
</html>"));
end IdealOpenTank;
