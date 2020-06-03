within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.Validation;
model CollectorDistributor
  "Validation of collector distributor model"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water
    "Source side medium";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";
  Fluid.Movers.FlowControlled_m_flow sou1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15 + 40,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
    annotation (Placement(transformation(extent={{-170,10},{-150,30}})));
  Fluid.Movers.FlowControlled_m_flow sou2_1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15 + 30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
    annotation (Placement(transformation(extent={{190,-30},{170,-10}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Boundary pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-190,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m1(
    height=1.1,
    duration=1000,
    startTime=0)
    "Primary flow"
    annotation (Placement(transformation(extent={{-240,50},{-220,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T1(k=40 + 273.15)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{-240,-50},{-220,-30}})));
  Fluid.Sensors.TemperatureTwoPort senT2_1Sup(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,20})));
  Fluid.Sensors.TemperatureTwoPort senT1Sup(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Primary supply temperature (measured)" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,20})));
  Fluid.Sensors.TemperatureTwoPort senT1Ret(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Primary return temperature (measured)" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-100,-20})));
  Fluid.Sensors.TemperatureTwoPort senT2_1Ret(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,-20})));
  Fluid.Sensors.MassFlowRate senMasFlo1(redeclare final package Medium = Medium)
    "Primary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Fluid.Sensors.MassFlowRate senMasFlo2_1(redeclare final package Medium =
        Medium) "Secondary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{130,10},{150,30}})));
  Fluid.MixingVolumes.MixingVolume vol2_1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2) "Volume for fluid stream"
    annotation (Placement(transformation(extent={{209,-20},{229,-40}})));
  Fluid.HeatExchangers.HeaterCooler_u coo(
    redeclare final package Medium = Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1E5) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{100,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2_1Ret(k=30 + 273.15)
    "First secondary return temperature"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat1(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseAction=true)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m2_1(
    height=0.5,
    duration=1000,
    offset=0.5,
    startTime=2000) "First secondary flow signal"
    annotation (Placement(transformation(extent={{220,50},{200,70}})));
  Fluid.Movers.FlowControlled_m_flow sou3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15 + 30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
    annotation (Placement(transformation(extent={{190,-170},{170,-150}})));
  Fluid.Sensors.TemperatureTwoPort senT2_2Sup(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (measured)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,-120})));
  Fluid.Sensors.TemperatureTwoPort senT2_2Ret(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (measured)" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={60,-160})));
  Fluid.Sensors.MassFlowRate senMasFlo2_2(
    redeclare final package Medium = Medium)
    "Secondary mass flow rate (measured)"
    annotation (Placement(transformation(extent={{130,-130},{150,-110}})));
  Fluid.MixingVolumes.MixingVolume vol2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2) "Volume for fluid stream"
    annotation (Placement(transformation(extent={{209,-160},{229,-180}})));
  Fluid.HeatExchangers.HeaterCooler_u coo1(
    redeclare final package Medium = Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=-1E5) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{100,-170},{80,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2_2Ret(k=35 + 273.15)
    "Second secondary return temperature"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat2(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseAction=true)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant m2_2(k=0.5)
    "Second secondary mass flow rate signal"
    annotation (Placement(transformation(extent={{220,-90},{200,-70}})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor
    colDis(
    redeclare final package Medium = Medium,
    allowFlowReversal=true,
    mCon_flow_nominal=fill(m_flow_nominal/2, 2),
    nCon=2) "Collector/distributor"
    annotation (Placement(transformation(extent={{-60,-10},{-20,10}})));
equation
  connect(m1.y, sou1.m_flow_in) annotation (Line(points={{-218,60},{-160,60},{-160,
          32}},            color={0,0,127}));
  connect(senMasFlo1.port_b, senT1Sup.port_a)
    annotation (Line(points={{-120,20},{-110,20}},
                                                 color={0,127,255}));
  connect(senT2_1Sup.port_b, senMasFlo2_1.port_a)
    annotation (Line(points={{70,20},{130,20}}, color={0,127,255}));
  connect(sou1.port_b, senMasFlo1.port_a)
    annotation (Line(points={{-150,20},{-140,20}},
                                                 color={0,127,255}));
  connect(coo.port_b, senT2_1Ret.port_a)
    annotation (Line(points={{80,-20},{70,-20}}, color={0,127,255}));
  connect(T2_1Ret.y, conTChiWat1.u_s) annotation (Line(points={{82,60},{74,60},{
          74,64},{76,64},{76,60},{88,60}}, color={0,0,127}));
  connect(conTChiWat1.y, coo.u) annotation (Line(points={{112,60},{120,60},{120,
          -14},{102,-14}},color={0,0,127}));
  connect(senT2_1Ret.T, conTChiWat1.u_m)
    annotation (Line(points={{60,-9},{60,0},{100,0},{100,48}},
                                                             color={0,0,127}));
  connect(vol2_1.ports[1], sou2_1.port_a)
    annotation (Line(points={{217,-20},{190,-20}}, color={0,127,255}));
  connect(senMasFlo2_1.port_b, vol2_1.ports[2])
    annotation (Line(points={{150,20},{221,20},{221,-20}}, color={0,127,255}));
  connect(m2_1.y, sou2_1.m_flow_in)
    annotation (Line(points={{198,60},{180,60},{180,-8}}, color={0,0,127}));
  connect(bou1.ports[1], sou1.port_a) annotation (Line(points={{-180,2},{-180,20},
          {-170,20}},     color={0,127,255}));
  connect(T1.y, bou1.T_in) annotation (Line(points={{-218,-40},{-212,-40},{-212,
          4},{-202,4}}, color={0,0,127}));
  connect(senT2_2Sup.port_b, senMasFlo2_2.port_a)
    annotation (Line(points={{70,-120},{130,-120}}, color={0,127,255}));
  connect(coo1.port_b, senT2_2Ret.port_a)
    annotation (Line(points={{80,-160},{70,-160}}, color={0,127,255}));
  connect(T2_2Ret.y, conTChiWat2.u_s) annotation (Line(points={{82,-80},{78,-80},
          {78,-76},{80,-76},{80,-80},{88,-80}}, color={0,0,127}));
  connect(conTChiWat2.y, coo1.u) annotation (Line(points={{112,-80},{120,-80},{120,
          -154},{102,-154}},    color={0,0,127}));
  connect(senT2_2Ret.T, conTChiWat2.u_m) annotation (Line(points={{60,-149},{60,
          -140},{100,-140},{100,-92}},
                                     color={0,0,127}));
  connect(vol2.ports[1],sou3. port_a)
    annotation (Line(points={{217,-160},{190,-160}},
                                                   color={0,127,255}));
  connect(senMasFlo2_2.port_b, vol2.ports[2]) annotation (Line(points={{150,-120},
          {221,-120},{221,-160}}, color={0,127,255}));
  connect(sou3.port_b, coo1.port_a)
    annotation (Line(points={{170,-160},{100,-160}},color={0,127,255}));
  connect(senT1Ret.port_b, bou1.ports[2]) annotation (Line(points={{-110,-20},{-180,
          -20},{-180,-2}}, color={0,127,255}));
  connect(sou2_1.port_b, coo.port_a)
    annotation (Line(points={{170,-20},{100,-20}},color={0,127,255}));
  connect(m2_2.y, sou3.m_flow_in) annotation (Line(points={{198,-80},{180,-80},{
          180,-148}}, color={0,0,127}));
  connect(senT1Sup.port_b, colDis.port_aDisSup) annotation (Line(points={{-90,20},
          {-80,20},{-80,0},{-60,0}}, color={0,127,255}));
  connect(senT1Ret.port_a, colDis.port_bDisRet) annotation (Line(points={{-90,-20},
          {-80,-20},{-80,-6},{-60,-6}}, color={0,127,255}));
  connect(colDis.ports_bCon[1], senT2_1Sup.port_a) annotation (Line(points={{-48,10},
          {-40,10},{-40,40},{44,40},{44,20},{50,20}},     color={0,127,255}));
  connect(colDis.ports_bCon[2], senT2_2Sup.port_a) annotation (Line(points={{-56,10},
          {-56,36},{40,36},{40,-120},{50,-120}},     color={0,127,255}));
  connect(senT2_1Ret.port_b, colDis.ports_aCon[1]) annotation (Line(points={{50,-20},
          {24,-20},{24,20},{-14,20},{-14,10},{-24,10}},             color={0,127,
          255}));
  connect(senT2_2Ret.port_b, colDis.ports_aCon[2]) annotation (Line(points={{50,-160},
          {20,-160},{20,16},{-32,16},{-32,10}},     color={0,127,255}));
  connect(colDis.port_bDisSup, colDis.port_aDisRet) annotation (Line(points={{-20,
          0},{-10,0},{-10,-6},{-20,-6}}, color={0,127,255}));
  annotation (
  Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor\">
Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.CollectorDistributor</a>
in a configuration where the model is used to ensure hydronic decoupling between
</p>
<ol>
<li>
a primary circuit which mass flow rate varies from 0 to 1.1 times 
<code>m_flow_nominal</code>,
</li>
<li>
a first secondary circuit which mass flow rate varies from 0.5 to 1 times 
<code>m_flow_nominal</code>,
</li>
<li>
a second secondary circuit which flow rate is constant, equal to 0.5 times 
<code>m_flow_nominal</code>.
</li>
</ol>
</html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-200},{260,120}})),
  __Dymola_Commands(
  file="Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/FifthGeneration/Validation/CollectorDistributor.mos"
   "Simulate and plot"));
end CollectorDistributor;
