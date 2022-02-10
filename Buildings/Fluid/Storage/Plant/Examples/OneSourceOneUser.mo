within Buildings.Fluid.Storage.Plant.Examples;
model OneSourceOneUser "District system with one source and one user"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    p_CHWS_nominal-p_CHWR_nominal
    "Nominal pressure difference";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=800000
    "Nominal pressure at CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure at CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Boolean allowFlowReversal=false
    "Flow reversal setting";

  Buildings.Fluid.Storage.Plant.ChillerAndTankNoRemoteCharging cat(
    redeclare final package Medium=Medium,
    final m1_flow_nominal=m_flow_nominal/2,
    final m2_flow_nominal=m_flow_nominal/2,
    final p_CHWS_nominal=p_CHWS_nominal,
    final p_CHWR_nominal=p_CHWR_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal)
    "Chiller and tank"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Storage.Plant.DummyConsumer con(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal*0.3,
    p_a_nominal=p_CHWS_nominal-dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal+dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal)
    "Consumer"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant set_TRet(k=12 + 273.15)
    "CHW return setpoint"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.TimeTable preQCooLoa_flow(table=[0*3600,0; 0.5*3600,0;
        0.5*3600,5*4200*1.01; 0.75*3600,5*4200*1.01; 0.75*3600,0; 1*3600,0])
    "Placeholder, prescribed cooling load"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.Constant set_mPum1_flow(k=m_flow_nominal/2)
    "Primary pump mass flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Controls.Continuous.LimPID conPI_pum2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=1,
    Ti=100,
    reverseActing=true)
             "PI controller for pum2" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-90,-60})));
  FixedResistances.PressureDrop preDro1(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal*0.3,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal*0.3,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Modelica.Blocks.Sources.Constant set_dpCon(k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-60,-100},{-80,-80}})));
  Buildings.Fluid.Sources.Boundary_pT sou_p(
    redeclare final package Medium = Medium,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,30})));
  Modelica.Blocks.Math.Gain gaiPum2(k=1/con.dp_nominal) "Gain" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,-60})));
equation
  connect(set_TRet.y, con.TSet)
    annotation (Line(points={{1,50},{32,50},{32,5},{39,5}}, color={0,0,127}));
  connect(preQCooLoa_flow.y, con.QCooLoa_flow)
    annotation (Line(points={{21,90},{34,90},{34,9},{39,9}}, color={0,0,127}));
  connect(set_mPum1_flow.y, cat.set_mPum1_flow)
    annotation (Line(points={{-79,90},{-61,90},{-61,9}},  color={0,0,127}));
  connect(cat.port_b, preDro1.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(preDro1.port_b, con.port_a)
    annotation (Line(points={{10,0},{39.8,0}}, color={0,127,255}));
  connect(con.port_b, preDro2.port_a)
    annotation (Line(points={{60,0},{60,-40},{10,-40}}, color={0,127,255}));
  connect(preDro2.port_b, cat.port_a)
    annotation (Line(points={{-10,-40},{-60,-40},{-60,0}}, color={0,127,255}));
  connect(set_dpCon.y, conPI_pum2.u_s)
    annotation (Line(points={{-81,-90},{-90,-90},{-90,-72}}, color={0,0,127}));
  connect(sou_p.ports[1], cat.port_a) annotation (Line(points={{-80,30},{-74,30},
          {-74,0},{-60,0}}, color={0,127,255}));
  connect(con.dp, gaiPum2.u) annotation (Line(points={{47,11},{46,11},{46,16},{64,
          16},{64,-60},{-38,-60}}, color={0,0,127}));
  connect(gaiPum2.y, conPI_pum2.u_m)
    annotation (Line(points={{-61,-60},{-78,-60}}, color={0,0,127}));
  connect(conPI_pum2.y, cat.yPum2)
    annotation (Line(points={{-90,-49},{-90,5},{-61,5}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-06, StopTime=3600));
end OneSourceOneUser;
