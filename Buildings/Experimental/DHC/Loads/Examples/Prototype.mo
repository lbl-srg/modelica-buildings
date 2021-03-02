within Buildings.Experimental.DHC.Loads.Examples;
model Prototype
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water
    "Source side medium";
  constant Modelica.SIunits.SpecificHeatCapacity cpWatLiq=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity of liquid water";
  parameter String filNam=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos")
    "Path of the file with loads as time series";
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal=
    Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp_nominal = 3E4
    "Nominal pressure drop";
  parameter Real fra_m_flow_min = 0.1
    "Minimum flow rate (ratio to nominal)";
  parameter Modelica.SIunits.Temperature TSupSet_nominal = 60+273.15
    "Supply temperature set point at noinal conditions";
  parameter Modelica.SIunits.Temperature TSupSer_nominal = TSupSet_nominal + 10
    "Service supply temperature at noinal conditions";
  parameter Boolean have_reset = false
    "Set to true to reset the supply temperature (consider enumeration for open loop reset based on TOut or closed loop based on load signal (approximating T&R)";
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=filNam,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare package Medium1=Medium,
    redeclare package Medium2=Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=dp_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=Q_flow_nominal,
    T_a1_nominal=TSupSer_nominal,
    T_a2_nominal=TSupSet_nominal - dT1_nominal)
   annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-54,0})));
  Fluid.Sensors.TemperatureTwoPort senTSup(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Fluid.Sources.Boundary_pT bou(
    redeclare package Medium=Medium,
    p=Medium.p_default + 10E4,
    T=TSupSer_nominal,
    nPorts=1)
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    dpFixed_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Fluid.Sources.Boundary_pT bou1(redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPID(k=0.1, Ti=120)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant temSupSet(k=
        TSupSet_nominal)
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    per(pressure(V_flow=m_flow_nominal/1000*{0,1,2}, dp=dp_nominal*{2,1,0})),
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  BaseClasses.FlowCharacteristics flowCharacteristics(
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Fluid.Delays.DelayFirstOrder del(
    redeclare package Medium=Medium,
    T_start=TSupSet_nominal,
    tau=5*60,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal, nPorts=3)
    annotation (Placement(transformation(extent={{110,20},{130,40}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFlo "Heat flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={72,120})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=-1)
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Fluid.Sensors.TemperatureTwoPort senTRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-30},{-30,-10}})));
  Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium=Medium, nPorts=1)
              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={140,20})));
protected
  parameter Modelica.SIunits.TemperatureDifference dT1_nominal = 20
    "Nominal Delta-T: change default btw cooling and heating applications";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    abs(Q_flow_nominal / dT1_nominal / cpWatLiq)
    "Nominal mass flow rate";
equation
  connect(hex.port_b2, senTSup.port_a)
    annotation (Line(points={{-48,10},{-48,20},{-30,20}}, color={0,127,255}));
  connect(val.port_b, hex.port_a1)
    annotation (Line(points={{-70,20},{-60,20},{-60,10}}, color={0,127,255}));
  connect(bou.ports[1], val.port_a)
    annotation (Line(points={{-130,20},{-90,20}}, color={0,127,255}));
  connect(bou1.ports[1], hex.port_b1) annotation (Line(points={{-130,-20},{-60,-20},
          {-60,-10}}, color={0,127,255}));
  connect(senTSup.T, conPID.u_m) annotation (Line(points={{-20,31},{-20,60},{-100,
          60},{-100,68}}, color={0,0,127}));
  connect(conPID.y, val.y)
    annotation (Line(points={{-88,80},{-80,80},{-80,32}}, color={0,0,127}));
  connect(temSupSet.y, conPID.u_s)
    annotation (Line(points={{-128,80},{-112,80}}, color={0,0,127}));
  connect(loa.y[2], flowCharacteristics.Q_flow) annotation (Line(points={{11,120},
          {20,120},{20,80},{28,80}}, color={0,0,127}));
  connect(flowCharacteristics.m_flow,pum. m_flow_in) annotation (Line(points={{52,80},
          {60,80},{60,32}},                     color={0,0,127}));
  connect(pum.port_b, del.ports[1])
    annotation (Line(points={{70,20},{117.333,20}},
                                                color={0,127,255}));
  connect(gai.y, heaFlo.Q_flow)
    annotation (Line(points={{52,120},{62,120}}, color={0,0,127}));
  connect(loa.y[2], gai.u)
    annotation (Line(points={{11,120},{28,120}}, color={0,0,127}));
  connect(heaFlo.port, del.heatPort) annotation (Line(points={{82,120},{100,120},
          {100,30},{110,30}}, color={191,0,0}));
  connect(hex.port_a2, senTRet.port_b) annotation (Line(points={{-48,-10},{-48,-20},
          {-30,-20}}, color={0,127,255}));
  connect(bou2.ports[1], del.ports[2]) annotation (Line(points={{130,20},{120,
          20}},               color={0,127,255}));
  connect(senTSup.port_b, pum.port_a)
    annotation (Line(points={{-10,20},{50,20}}, color={0,127,255}));
  connect(senTRet.port_a, del.ports[3]) annotation (Line(points={{-10,-20},{120,
          -20},{120,20},{122.667,20}}, color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}})),
      experiment(StopTime=36000, __Dymola_Algorithm="Dassl"));
end Prototype;
