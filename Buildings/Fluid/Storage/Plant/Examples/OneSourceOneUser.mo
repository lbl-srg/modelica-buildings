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

  package Medium1 = Buildings.Media.Water "Medium model for CDW";
  package Medium2 = Buildings.Media.Water "Medium model for CHW";

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
  parameter Modelica.Units.SI.Power QCooLoa_flow_nominal=5*4200*1.01
    "Nominal cooling load of one consumer";

  Buildings.Fluid.Storage.Plant.ChillerAndTank cat(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final allowRemoteCharging=false,
    final mChi_flow_nominal=m_flow_nominal/2,
    final mTan_flow_nominal=m_flow_nominal/2,
    final p_CHWS_nominal=p_CHWS_nominal,
    final p_CHWR_nominal=p_CHWR_nominal,
    final T_CHWS_nominal=T_CHWS_nominal,
    final T_CHWR_nominal=T_CHWR_nominal)
    "Chiller and tank"
    annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.DummyUser usr(
    redeclare package Medium = Medium2,
    m_flow_nominal=m_flow_nominal,
    p_a_nominal=p_CHWS_nominal - dp_nominal*0.35,
    p_b_nominal=p_CHWR_nominal + dp_nominal*0.35,
    T_a_nominal=T_CHWS_nominal,
    T_b_nominal=T_CHWR_nominal) "User"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Sources.Constant set_TRet(k=12 + 273.15)
    "CHW return setpoint"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Blocks.Sources.TimeTable preQCooLoa_flow(table=[0*3600,0; 1200,0;
        1200,QCooLoa_flow_nominal; 2400,QCooLoa_flow_nominal; 2400,0; 1*3600,0])
    "Placeholder, prescribed cooling load"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.Continuous.LimPID conPI_pum2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=1,
    Ti=100,
    reverseActing=true)
             "PI controller for pum2" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-50,40})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro1(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal*0.3,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal*0.3,
    final m_flow_nominal=m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Modelica.Blocks.Sources.Constant set_dpCon(k=1)
    "Normalised consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,70})));
  Buildings.Fluid.Sources.Boundary_pT sou_p(
    redeclare final package Medium = Medium2,
    final p=p_CHWR_nominal,
    final T=T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-20})));
  Modelica.Blocks.Math.Gain gaiPum2(k=1/usr.dp_nominal) "Gain" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,70})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysPum1(uLow=0.05, uHigh=0.5)
    "Primary pump shuts off at con.yVal = 0.05 and restarts at 0.5" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-70})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum1(realTrue=
        m_flow_nominal/2) "Primary pump signal" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-10,-70})));
  Buildings.Fluid.Sources.MassFlowSource_T souCDW(
    redeclare package Medium = Medium1,
    m_flow=1,
    T=305.15,
    nPorts=1) "Source representing CDW supply line"
    annotation (Placement(transformation(extent={{-10,10},{-30,30}})));
  Buildings.Fluid.Sources.Boundary_pT                 sinCDW(
    redeclare final package Medium = Medium1,
    final p=300000,
    final T=310.15,
    nPorts=1) "Sink representing CDW return line" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,20})));
equation
  connect(set_TRet.y,usr. TSet)
    annotation (Line(points={{21,30},{32,30},{32,-15},{39,-15}},
                                                            color={0,0,127}));
  connect(preQCooLoa_flow.y,usr. QCooLoa_flow)
    annotation (Line(points={{21,60},{34,60},{34,-11},{39,-11}},
                                                             color={0,0,127}));
  connect(preDro1.port_b,usr. port_a)
    annotation (Line(points={{10,-20},{40,-20}},
                                               color={0,127,255}));
  connect(usr.port_b, preDro2.port_a)
    annotation (Line(points={{60,-20},{60,-40},{10,-40}},
                                                        color={0,127,255}));
  connect(set_dpCon.y, conPI_pum2.u_s)
    annotation (Line(points={{-50,59},{-50,52}},             color={0,0,127}));
  connect(usr.dp, gaiPum2.u) annotation (Line(points={{47,-9},{46,-9},{46,88},{-20,
          88},{-20,82}},           color={0,0,127}));
  connect(conPI_pum2.y, cat.yPum2)
    annotation (Line(points={{-50,29},{-50,20},{-42,20},{-42,11}},
                                                         color={0,0,127}));
  connect(hysPum1.y, booToReaPum1.u)
    annotation (Line(points={{38,-70},{2,-70}},  color={255,0,255}));
  connect(booToReaPum1.y, cat.set_mPum1_flow)
    annotation (Line(points={{-22,-70},{-30,-70},{-30,9},{-39,9}},
                                                        color={0,0,127}));
  connect(hysPum1.u,usr. yVal_actual) annotation (Line(points={{62,-70},{68,-70},
          {68,-4},{43,-4},{43,-9}},
                            color={0,0,127}));
  connect(gaiPum2.y, conPI_pum2.u_m)
    annotation (Line(points={{-20,59},{-20,40},{-38,40}}, color={0,0,127}));
  connect(cat.port_b2, preDro1.port_a) annotation (Line(points={{-40,-6},{-16,
          -6},{-16,-20},{-10,-20}}, color={0,127,255}));
  connect(preDro2.port_b, cat.port_a2) annotation (Line(points={{-10,-40},{-66,
          -40},{-66,-6},{-60,-6}}, color={0,127,255}));
  connect(sou_p.ports[1], cat.port_a2) annotation (Line(points={{-80,-20},{-66,
          -20},{-66,-6},{-60,-6}}, color={0,127,255}));
  connect(cat.port_b1, sinCDW.ports[1]) annotation (Line(points={{-60,6},{-74,6},
          {-74,20},{-80,20}}, color={0,127,255}));
  connect(cat.port_a1, souCDW.ports[1]) annotation (Line(points={{-40,6},{-34,6},
          {-34,20},{-30,20}}, color={0,127,255}));
  annotation(experiment(Tolerance=1e-06, StopTime=3600));
end OneSourceOneUser;
