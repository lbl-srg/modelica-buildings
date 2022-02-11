within Buildings.Fluid.Storage.Plant.Examples;
model OneSourceOneUser "(Draft) District system with one source and one user"
/*
- Controls -
  Primary pump:
    Tracks consumer control valve position con.yVal,
    closes at y.Val < 0.05,
    reopens at y.Val > 0.5.
  Secondary pump:
    Maintains constant consumer pressure head con.dp.
- Pressure -
  Assuming the plant takes 10% of total pressure head,
    supply and return pipes 30% each,
    consumer 30%.
*/
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
    p_a_nominal=p_CHWS_nominal-dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal+dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal)
    "Consumer"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant set_TRet(k=12 + 273.15)
    "CHW return setpoint"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.TimeTable preQCooLoa_flow(table=[0*3600,0; 0.5*3600,0;
        0.5*3600,5*4200*1.01; 0.75*3600,5*4200*1.01; 0.75*3600,0; 1*3600,0])
    "Placeholder, prescribed cooling load"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.Continuous.LimPID conPI_pum2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=1,
    Ti=100,
    reverseActing=true)
             "PI controller for pum2" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-70,-60})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro1(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal*0.3,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal*0.3,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Modelica.Blocks.Sources.Constant set_dpCon(k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,-90})));
  Buildings.Fluid.Sources.Boundary_pT sou_p(
    redeclare final package Medium = Medium,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,0})));
  Modelica.Blocks.Math.Gain gaiPum2(k=1/con.dp_nominal) "Gain" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-40,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysPum1(uLow=0.05, uHigh=0.5)
    "Primary pump shuts off at con.yVal = 0.05 and restarts at 0.5" annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-70,62})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum1(realTrue=
        m_flow_nominal/2) "Primary pump signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,30})));
equation
  connect(set_TRet.y, con.TSet)
    annotation (Line(points={{21,30},{32,30},{32,5},{39,5}},color={0,0,127}));
  connect(preQCooLoa_flow.y, con.QCooLoa_flow)
    annotation (Line(points={{21,60},{34,60},{34,9},{39,9}}, color={0,0,127}));
  connect(cat.port_b, preDro1.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(preDro1.port_b, con.port_a)
    annotation (Line(points={{10,0},{40,0}},   color={0,127,255}));
  connect(con.port_b, preDro2.port_a)
    annotation (Line(points={{60,0},{60,-40},{10,-40}}, color={0,127,255}));
  connect(preDro2.port_b, cat.port_a)
    annotation (Line(points={{-10,-40},{-60,-40},{-60,0}}, color={0,127,255}));
  connect(set_dpCon.y, conPI_pum2.u_s)
    annotation (Line(points={{-70,-79},{-70,-72}},           color={0,0,127}));
  connect(sou_p.ports[1], cat.port_a) annotation (Line(points={{-80,0},{-60,0}},
                            color={0,127,255}));
  connect(con.dp, gaiPum2.u) annotation (Line(points={{47,11},{46,11},{46,20},{70,
          20},{70,-60},{-28,-60}}, color={0,0,127}));
  connect(gaiPum2.y, conPI_pum2.u_m)
    annotation (Line(points={{-51,-60},{-58,-60}}, color={0,0,127}));
  connect(conPI_pum2.y, cat.yPum2)
    annotation (Line(points={{-70,-49},{-70,5},{-61,5}}, color={0,0,127}));
  connect(hysPum1.y, booToReaPum1.u)
    annotation (Line(points={{-70,50},{-70,42}}, color={255,0,255}));
  connect(booToReaPum1.y, cat.set_mPum1_flow)
    annotation (Line(points={{-70,18},{-70,9},{-61,9}}, color={0,0,127}));
  connect(hysPum1.u, con.yVal_actual) annotation (Line(points={{-70,74},{-70,80},
          {43,80},{43,11}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-06, StopTime=3600));
end OneSourceOneUser;
