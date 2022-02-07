within Buildings.Fluid.Storage.Plant.BaseClasses;
partial model ChillerAndTank
  "(Draft) A plant with a chiller and a stratified CHW tank"
  // Condenser loop not considered yet.

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=1
    "Nominal mass flow rate for the chiller branch";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=1
    "Nominal mass flow rate for the tank branch";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    p_CHWS_nominal-p_CHWR_nominal
    "Nominal pressure difference";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=800000
    "Nominal pressure of the CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure of the CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";
  parameter Boolean allowFlowReversal1=false
    "Flow reversal setting on chiller branch";

  Buildings.Fluid.MixingVolumes.MixingVolume chi(
    nPorts=2,
    final prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m1_flow_nominal,
    allowFlowReversal=allowFlowReversal1,
    V=1E-3,
    p_start=p_CHWS_nominal,
    T_start=T_CHWS_nominal) "Volume representing a chiller" annotation (
      Placement(transformation(
        origin={0,60},
        extent={{-10,10},{10,-10}},
        rotation=180)));
  Buildings.Fluid.FixedResistances.PressureDrop preDro1(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal1,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m1_flow_nominal) "Flow resistance on chiller branch"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiEnt(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    T_start=T_CHWR_nominal,
    tauHeaTra=1) "Chiller entering"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TChiLea(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    T_start=T_CHWS_nominal,
    tauHeaTra=1) "Chiller leaving"
    annotation (Placement(transformation(extent={{12,30},{32,50}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource pum1(
    redeclare package Medium = Medium,
    final dp_start=dp_nominal,
    final m_flow_start=m1_flow_nominal,
    final show_T=false,
    final show_V_flow=false,
    final control_m_flow=true,
    final control_dp=false,
    final allowFlowReversal=allowFlowReversal1,
    final m_flow_small=m1_flow_nominal*1E-5)
    "Primary CHW pump"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.MixingVolumes.MixingVolume tan(
    redeclare package Medium = Medium,
    nPorts=2,
    final prescribedHeatFlowRate=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m2_flow_nominal,
    final allowFlowReversal=true,
    V=1E-3,
    p_start=p_CHWS_nominal,
    T_start=T_CHWS_nominal) "Volume representing a tank" annotation (Placement(
        transformation(
        origin={0,-40},
        extent={{-10,10},{10,-10}},
        rotation=180)));
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={m1_flow_nominal+m2_flow_nominal,
                   -m1_flow_nominal,-m2_flow_nominal},
    dp_nominal={0,0,0},
    T_start=T_CHWR_nominal)
    "Junction near the return line" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,0})));
  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={m1_flow_nominal,m2_flow_nominal,
                   -m1_flow_nominal-m2_flow_nominal},
    dp_nominal={0,0,0},
    T_start=T_CHWS_nominal)
    "Junction near the supply line" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TTanHot(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    T_start=T_CHWR_nominal,
    tauHeaTra=1) "Tank hot side"
    annotation (Placement(transformation(extent={{-30,-70},{-10,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TTanCol(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    T_start=T_CHWS_nominal,
    tauHeaTra=1) "Tank cold side"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal,
    final m_flow_nominal=m2_flow_nominal) "Flow resistance on tank branch"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Fluid.Sensors.MassFlowRate floSenTan(
    redeclare package Medium=Medium,
    final allowFlowReversal=true)
    "Flow rate sensor on the tank branch"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaChi
    "Prescribed heat flow for chiller"
    annotation (Placement(transformation(extent={{2,78},{22,98}})));
  Modelica.Blocks.Sources.RealExpression QChi(
    y=pum1.m_flow*(
      Medium.specificEnthalpy(state=Medium.setState_pTX(
        p=p_CHWS_nominal, T=T_CHWS_nominal, X={1.}))
      - TChiEnt.port_b.h_outflow)) "Heat flow of the chiller"
    annotation (Placement(transformation(extent={{-30,78},{-10,98}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heaTan
    "Prescribed heat flow for tank"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.RealExpression QTan(
    y=if floSenTan.m_flow>0 then
        floSenTan.m_flow*(
        Medium.specificEnthalpy(state=Medium.setState_pTX(
          p=p_CHWS_nominal, T=T_CHWS_nominal, X={1.}))
        - TTanHot.port_b.h_outflow)
      else
        floSenTan.m_flow*(TTanCol.port_a.h_outflow
        - Medium.specificEnthalpy(state=Medium.setState_pTX(
          p=p_CHWR_nominal, T=T_CHWR_nominal, X={1.}))))
    "Heat flow of the tank"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    p(start=p_CHWR_nominal),
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-190,-10},{-170,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    p(start=p_CHWS_nominal),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{150,-10},{130,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealInput us_mChi_flow
    "Chiller mass flow rate setpoint"
                                   annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-50,120}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-30,110})));

equation

  connect(TChiEnt.port_b, chi.ports[1]) annotation (Line(points={{-10,40},{0,40},
          {0,50},{1,50}}, color={0,127,255}));
  connect(preDro1.port_a,TChiLea. port_b)
    annotation (Line(points={{40,40},{32,40}}, color={0,127,255}));
  connect(TChiLea.port_a, chi.ports[2])
    annotation (Line(points={{12,40},{-1,40},{-1,50}}, color={0,127,255}));
  connect(pum1.port_b,TChiEnt. port_a)
    annotation (Line(points={{-40,40},{-30,40}}, color={0,127,255}));
  connect(pum1.port_a, jun1.port_2) annotation (Line(points={{-60,40},{-66,40},{
          -66,0},{-70,0}},
                       color={0,127,255}));
  connect(TTanHot.port_b, tan.ports[1])
    annotation (Line(points={{-10,-60},{1,-60},{1,-50}}, color={0,127,255}));
  connect(tan.ports[2], TTanCol.port_a)
    annotation (Line(points={{-1,-50},{-1,-60},{10,-60}}, color={0,127,255}));
  connect(TTanCol.port_b, preDro2.port_a)
    annotation (Line(points={{30,-60},{40,-60}}, color={0,127,255}));
  connect(preDro2.port_b, jun2.port_3)
    annotation (Line(points={{60,-60},{100,-60},{100,-10}},
                                                 color={0,127,255}));
  connect(jun1.port_3, floSenTan.port_a)
    annotation (Line(points={{-80,-10},{-80,-60},{-60,-60}},
                                                   color={0,127,255}));
  connect(floSenTan.port_b, TTanHot.port_a)
    annotation (Line(points={{-40,-60},{-30,-60}}, color={0,127,255}));
  connect(preDro1.port_b, jun2.port_1)
    annotation (Line(points={{60,40},{84,40},{84,0},{90,0}},
                                                        color={0,127,255}));
  connect(heaChi.port, chi.heatPort)
    annotation (Line(points={{22,88},{28,88},{28,60},{10,60}},
                                                       color={191,0,0}));
  connect(QTan.y, heaTan.Q_flow)
    annotation (Line(points={{-9,-10},{0,-10}}, color={0,0,127}));
  connect(heaTan.port, tan.heatPort) annotation (Line(points={{20,-10},{28,-10},
          {28,-40},{10,-40}}, color={191,0,0}));
  connect(jun2.port_2, port_b)
    annotation (Line(points={{110,0},{140,0}}, color={0,127,255}));
  connect(pum1.m_flow_in, us_mChi_flow) annotation (Line(points={{-56,48},{-56,60},
          {-50,60},{-50,120}}, color={0,0,127}));
  connect(QChi.y, heaChi.Q_flow)
    annotation (Line(points={{-9,88},{2,88}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-180,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Line(points={{0,0},{0,-20},{30,-20},{30,-60},{60,-60},{60,0}}, color={0,
              0,0}),
        Line(points={{-90,0},{0,0},{0,60},{60,60},{60,0},{90,0}}, color={0,0,0}),
        Ellipse(
          extent={{10,82},{54,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,16},{-18,-16},{18,-16},{0,16}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={38,60},
          rotation=-90),
        Rectangle(
          extent={{10,-10},{50,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,20},{-20,20}}, color={28,108,200}),
        Polygon(
          points={{-20,20},{-40,26},{-40,14},{-20,20}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));
end ChillerAndTank;
