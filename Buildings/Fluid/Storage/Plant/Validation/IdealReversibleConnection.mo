within Buildings.Fluid.Storage.Plant.Validation;
model IdealReversibleConnection "Simplified dual-source network with coupled pressure"
  extends Modelica.Icons.Example;

    package Medium = Buildings.Media.Water "Medium model";

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    mTan_flow_nominal=1,
    mChi_flow_nominal=1,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Sources.TimeTable mTanSet_flow(table=[0,0; 600,0; 600,1; 1200,
        1; 1200,0; 1800,0; 1800,-1; 3600,-1]) "Mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
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
        origin={-70,-10})));
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
        origin={50,30})));
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
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

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
        origin={-30,-50})));

  Buildings.Fluid.FixedResistances.Junction junSup2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    final m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.m_flow_nominal},
    final dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

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
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Fluid.Storage.Plant.IdealReversibleConnection ideRevConSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.m_flow_nominal)
                   "Ideal reversable connection on supply side"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Add the setpoints of the chiller and the tank together"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sensors.MassFlowRate mTan_flow(
    redeclare final package Medium = Medium)
    "Mass flow rate of the storage tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-10})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = Medium,
    p(final displayUnit="Pa") = 200000 + preDroRet.dp_nominal,
    nPorts=1) "Pressure boundary" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={110,-30})));

  Buildings.Fluid.BaseClasses.ActuatorFilter fil(
    f=20/(2*Modelica.Constants.pi*60),
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final n=2,
    final normalized=true) "Second order filter to improve numerics"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-10})));
equation
  connect(junRet1.port_1, preDroRet.port_b)
    annotation (Line(points={{-20,-50},{40,-50}}, color={0,127,255}));

  connect(bou.ports[1], idePreSou.port_a) annotation (Line(points={{100,-30},{90,
          -30},{90,-20}},                        color={0,127,255}));
  connect(dp.y,idePreSou. dp_in) annotation (Line(points={{61,-10},{74,-10},{74,
          -4},{82,-4}},
                      color={0,0,127}));
  connect(junSup2.port_2,preDroNet. port_a)
    annotation (Line(points={{100,30},{130,30},{130,0}},
                                                       color={0,127,255}));
  connect(preDroNet.port_b,junRet2. port_1)
    annotation (Line(points={{130,-20},{130,-50},{100,-50}},
                                                          color={0,127,255}));
  connect(junRet2.port_3,idePreSou. port_a)
    annotation (Line(points={{90,-40},{90,-20}}, color={0,127,255}));
  connect(idePreSou.port_b,junSup2. port_3)
    annotation (Line(points={{90,0},{90,20}},  color={0,127,255}));
  connect(junSup1.port_1,ideFloSou. port_b)
    annotation (Line(points={{-40,30},{-70,30},{-70,0}}, color={0,127,255}));
  connect(ideFloSou.port_a,junRet1. port_2) annotation (Line(points={{-70,-20},
          {-70,-50},{-40,-50}},color={0,127,255}));
  connect(preDroSup.port_b,junSup2. port_1)
    annotation (Line(points={{60,30},{80,30}}, color={0,127,255}));
  connect(junRet2.port_2,preDroRet. port_a)
    annotation (Line(points={{80,-50},{60,-50}}, color={0,127,255}));
  connect(ideRevConSup.port_b, preDroSup.port_a)
    annotation (Line(points={{20,30},{40,30}},color={0,127,255}));
  connect(ideRevConSup.port_a, junSup1.port_2)
    annotation (Line(points={{0,30},{-20,30}},   color={0,127,255}));
  connect(mTanSet_flow.y, add2.u1) annotation (Line(points={{-99,70},{-90,70},{
          -90,76},{-82,76}},    color={0,0,127}));
  connect(mChiSet_flow.y, add2.u2) annotation (Line(points={{-99,30},{-90,30},{
          -90,64},{-82,64}},    color={0,0,127}));
  connect(add2.y, ideRevConSup.mSet_flow) annotation (Line(points={{-58,70},{
          -10,70},{-10,35},{-1,35}},
                                  color={0,0,127}));
  connect(mChiSet_flow.y, fil.u) annotation (Line(points={{-99,30},{-90,30},{
          -90,10},{-130,10},{-130,-10},{-122,-10}},  color={0,0,127}));
  connect(fil.y, ideFloSou.m_flow_in) annotation (Line(points={{-99,-10},{-86,
          -10},{-86,-16},{-78,-16}},   color={0,0,127}));
  connect(junSup1.port_3, mTan_flow.port_b)
    annotation (Line(points={{-30,20},{-30,0}}, color={0,127,255}));
  connect(mTan_flow.port_a, junRet1.port_3)
    annotation (Line(points={{-30,-20},{-30,-40}}, color={0,127,255}));
    annotation(experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/IdealReversibleConnection.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This validation model models a simplified system with two pressure sources
representing two plants. One of the plants has a storage tank which can
be charged remotely by the other plant in the district network.
This 
</p>
</html>", revisions="<html>
<ul>
<li>
January 9, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end IdealReversibleConnection;
