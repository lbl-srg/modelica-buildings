within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
partial model PartialChillerPlant "Chiller plant model for closed-loop test"

  package MediumW = Buildings.Media.Water;
  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal
    "Nominal mass flow rate in chilled water loop";
  final parameter Modelica.Units.SI.PressureDifference dpChi_nominal=80000+80000
    "Nominal pressure difference in chilled water loop";
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in condenser water loop";
  final parameter Modelica.Units.SI.PressureDifference dpCon_nominal=50000+15000+75000
    "Nominal pressure difference in condenser water loop";

  Buildings.Examples.ChillerPlants.RP1711.BaseClasses.YorkCalc cooTow1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mCon_flow_nominal,
    final show_T=true,
    final dp_nominal=15000 + 75000,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling tower"
    annotation (Placement(transformation(extent={{340,370},{320,390}})));
  Buildings.Examples.ChillerPlants.RP1711.BaseClasses.YorkCalc cooTow2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mCon_flow_nominal,
    final show_T=true,
    final dp_nominal=15000 + 75000,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling tower"
    annotation (Placement(transformation(extent={{340,300},{320,320}})));
  Buildings.Fluid.Movers.SpeedControlled_y conWatPum1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per(pressure(V_flow={0,mCon_flow_nominal,2*mCon_flow_nominal}/1.2,
                     dp={2*dpCon_nominal,dpCon_nominal,0})),
    final use_inputFilter=false)
    "Condenser water pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={200,210})));
  Buildings.Fluid.Movers.SpeedControlled_y conWatPum2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per(pressure(V_flow={0,mCon_flow_nominal,2*mCon_flow_nominal}/1.2,
                     dp={2*dpCon_nominal,dpCon_nominal,0})),
    final use_inputFilter=false)
    "Condenser water pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={260,210})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear cwIsoVal1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mCon_flow_nominal,
    final show_T=true,
    final dpValve_nominal=15000,
    final use_inputFilter=false,
    final dpFixed_nominal=0)
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{370,90},{390,110}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear cwIsoVal2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mCon_flow_nominal,
    final show_T=true,
    final dpValve_nominal=15000,
    final use_inputFilter=false,
    final dpFixed_nominal=0)
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{370,0},{390,20}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear chwIsoVal1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChi_flow_nominal,
    final show_T=true,
    final dpValve_nominal=15000,
    final use_inputFilter=false,
    final dpFixed_nominal=80000)
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{250,60},{230,80}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear chwIsoVal2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChi_flow_nominal,
    final show_T=true,
    final dpValve_nominal=15000,
    final use_inputFilter=false,
    final dpFixed_nominal=80000)
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{250,-30},{230,-10}})));
  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mCon_flow_nominal,mCon_flow_nominal,mCon_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,origin={260,100})));
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mCon_flow_nominal,mCon_flow_nominal,mCon_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={260,240})));
  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mCon_flow_nominal,mCon_flow_nominal,mCon_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={260,140})));
  Buildings.Fluid.FixedResistances.Junction jun3(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mCon_flow_nominal,mCon_flow_nominal,mCon_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,origin={260,310})));
  Buildings.Fluid.FixedResistances.Junction jun4(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mCon_flow_nominal,mCon_flow_nominal,mCon_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,origin={420,100})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear towIsoVal2(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mCon_flow_nominal,
    final show_T=true,
    final dpValve_nominal=15000,
    final use_inputFilter=false,
    final dpFixed_nominal=50000)
    "Cooling tower isolation valve"
    annotation (Placement(transformation(extent={{390,300},{370,320}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear towIsoVal1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mCon_flow_nominal,
    final show_T=true,
    final dpValve_nominal=15000,
    final use_inputFilter=false,
    final dpFixed_nominal=50000)
    "Cooling tower isolation valve"
    annotation (Placement(transformation(extent={{390,370},{370,390}})));
  Buildings.Fluid.FixedResistances.Junction jun5(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mCon_flow_nominal,mCon_flow_nominal,mCon_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,origin={420,310})));
  Buildings.Fluid.FixedResistances.Junction jun6(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mChi_flow_nominal,mChi_flow_nominal,mChi_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,origin={440,-20})));
  Buildings.Fluid.FixedResistances.Junction jun7(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mChi_flow_nominal,mChi_flow_nominal,mChi_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,origin={200,-20})));
  Buildings.Fluid.Movers.SpeedControlled_y chiWatPum1(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per(pressure(V_flow={0,mChi_flow_nominal,2*mChi_flow_nominal}/1.2,
                     dp={2*dpChi_nominal,dpChi_nominal,0})),
    use_inputFilter=false)
    "Chilled water pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={200,-96})));
  Buildings.Fluid.Movers.SpeedControlled_y chiWatPum2(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per(pressure(V_flow={0,mChi_flow_nominal,2*mChi_flow_nominal}/1.2,
                     dp={2*dpChi_nominal,dpChi_nominal,0})),
    final use_inputFilter=false)
    "Chilled water pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={260,-96})));
  Buildings.Fluid.FixedResistances.Junction jun8(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mChi_flow_nominal,mChi_flow_nominal,mChi_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,origin={200,-70})));
  Buildings.Fluid.FixedResistances.Junction jun9(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mChi_flow_nominal,mChi_flow_nominal,mChi_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,origin={200,-150})));
  Buildings.Fluid.FixedResistances.Junction jun10(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mChi_flow_nominal,mChi_flow_nominal,mChi_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,origin={200,-220})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChi_flow_nominal,
    final show_T=true,
    final dpValve_nominal=15000,
    final use_inputFilter=false,
    final dpFixed_nominal=8000)
    "Bypass valve for chiller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={330,-220})));
  Buildings.Fluid.FixedResistances.Junction jun11(
    redeclare package Medium = MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal={mChi_flow_nominal,mChi_flow_nominal,mChi_flow_nominal},
    final dp_nominal={0,0,0}) "Flow junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90, origin={440,-220})));
  Buildings.Fluid.Sensors.TemperatureTwoPort chiWatSupTem(redeclare package
      Medium = MediumW, final m_flow_nominal=mChi_flow_nominal)
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,-180})));
  Buildings.Fluid.Sensors.TemperatureTwoPort chiWatRet(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChi_flow_nominal)
    "Chilled water return temperature, after bypass"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,origin={440,-180})));
  Buildings.Fluid.Sensors.TemperatureTwoPort chiWatRet1(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChi_flow_nominal)
    "Chilled water return temperature, before bypass"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,origin={440,-260})));
  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChi_flow_nominal) "Chilled water mass flow sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,origin={440,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort conWatSupTem(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mCon_flow_nominal)
    "Condenser water supply temperature, to the chiller condenser"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,origin={260,280})));
  Buildings.Fluid.Sensors.TemperatureTwoPort conWatRetTem(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mCon_flow_nominal)
    "Condenser water supply temperature, from the chiller condenser"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,origin={420,280})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium = MediumW)
    annotation (Placement(transformation(extent={{320,-330},{340,-310}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mChi_flow_nominal,
    final dp_nominal=80000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90, origin={440,-300})));
  Buildings.Fluid.Chillers.ElectricEIR chi1(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mChi_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD())
    "Chiller one"
    annotation (Placement(transformation(extent={{320,84},{340,104}})));
  Buildings.Fluid.Chillers.ElectricEIR chi2(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mChi_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD())
    "Chiller two"
    annotation (Placement(transformation(extent={{320,-6},{340,14}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Reference pressure"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,origin={470,110})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCon_flow_nominal,
    dpValve_nominal=3400,
    l=1e-4)
    "Check valve to avoid reverse flow"
    annotation (Placement(transformation(extent={{-10,-11},{10,11}},
        rotation=-90, origin={200,169})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal1(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCon_flow_nominal,
    dpValve_nominal=3400,
    l=1e-4)
    "Check valve to avoid reverse flow"
    annotation (Placement(transformation(extent={{-10,-11},{10,11}},
        rotation=-90, origin={260,169})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal2(
    redeclare package Medium = MediumW,
    m_flow_nominal=mChi_flow_nominal,
    dpValve_nominal=3400,
    l=1e-4)
    "Check valve to avoid reverse flow"
    annotation (Placement(transformation(extent={{-10,-11},{10,11}},
        rotation=-90, origin={200,-123})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal3(
    redeclare package Medium = MediumW,
    m_flow_nominal=mChi_flow_nominal,
    dpValve_nominal=3400,
    l=1e-4)
    "Check valve to avoid reverse flow"
    annotation (Placement(transformation(extent={{-10,-11},{10,11}},
        rotation=-90, origin={260,-125})));
equation
  connect(jun3.port_1, cooTow1.port_b)
    annotation (Line(points={{260,320},{260,380},{320,380}}, color={238,46,47},
      thickness=1));
  connect(jun3.port_3, cooTow2.port_b)
    annotation (Line(points={{270,310},{320,310}}, color={238,46,47},
      thickness=1));
  connect(cooTow1.port_a, towIsoVal1.port_b)
    annotation (Line(points={{340,380},{370,380}}, color={238,46,47},
      thickness=1));
  connect(cooTow2.port_a, towIsoVal2.port_b)
    annotation (Line(points={{340,310},{370,310}}, color={238,46,47},
      thickness=1));
  connect(cwIsoVal2.port_b, jun4.port_1)
    annotation (Line(points={{390,10},{420,10},{420,90}}, color={238,46,47},
      thickness=1));
  connect(cwIsoVal1.port_b, jun4.port_3)
    annotation (Line(points={{390,100},{410,100}}, color={238,46,47},
      thickness=1));
  connect(jun5.port_2, towIsoVal1.port_a)
    annotation (Line(points={{420,320},{420,380},{390,380}}, color={238,46,47},
      thickness=1));
  connect(jun5.port_3, towIsoVal2.port_a)
    annotation (Line(points={{410,310},{390,310}}, color={238,46,47},
      thickness=1));
  connect(chwIsoVal1.port_b, jun7.port_1)
    annotation (Line(points={{230,70},{200,70},{200,-10}}, color={0,127,255},
      thickness=1));
  connect(jun7.port_3, chwIsoVal2.port_b)
    annotation (Line(points={{210,-20},{230,-20}}, color={0,127,255},
      thickness=1));
  connect(jun7.port_2, jun8.port_1)
    annotation (Line(points={{200,-30},{200,-60}}, color={0,127,255},
      thickness=1));
  connect(jun8.port_3,chiWatPum2. port_a)
    annotation (Line(points={{210,-70},{260,-70},{260,-86}},  color={0,127,255},
      thickness=1));
  connect(jun8.port_2,chiWatPum1. port_a)
    annotation (Line(points={{200,-80},{200,-86}},  color={0,127,255},
      thickness=1));
  connect(jun10.port_3, valByp.port_a)
    annotation (Line(points={{210,-220},{320,-220}}, color={0,127,255},
      thickness=1));
  connect(valByp.port_b, jun11.port_3)
    annotation (Line(points={{340,-220},{430,-220}}, color={0,127,255},
      thickness=1));
  connect(jun.port_1, jun2.port_2)
    annotation (Line(points={{260,110},{260,130}}, color={238,46,47},
      thickness=1));
  connect(conWatPum2.port_a, jun1.port_2)
    annotation (Line(points={{260,220},{260,230}}, color={238,46,47},
      thickness=1));
  connect(conWatPum1.port_a, jun1.port_3)
    annotation (Line(points={{200,220},{200,240},{250,240}}, color={238,46,47},
      thickness=1));
  connect(jun9.port_2, chiWatSupTem.port_a) annotation (Line(
      points={{200,-160},{200,-170}},
      color={0,127,255},
      thickness=1));
  connect(chiWatSupTem.port_b, jun10.port_1) annotation (Line(
      points={{200,-190},{200,-210}},
      color={0,127,255},
      thickness=1));
  connect(jun11.port_2, chiWatRet.port_a)
    annotation (Line(points={{440,-210},{440,-190}}, color={0,127,255},
      thickness=1));
  connect(chiWatRet1.port_b, jun11.port_1)
    annotation (Line(points={{440,-250},{440,-230}}, color={0,127,255},
      thickness=1));
  connect(senVolFlo.port_b, jun6.port_1)
    annotation (Line(points={{440,-50},{440,-30}}, color={0,127,255},
      thickness=1));
  connect(jun1.port_1, conWatSupTem.port_b)
    annotation (Line(points={{260,250},{260,270}}, color={238,46,47},
      thickness=1));
  connect(conWatSupTem.port_a, jun3.port_2)
    annotation (Line(points={{260,290},{260,300}}, color={238,46,47},
      thickness=1));
  connect(jun4.port_2, conWatRetTem.port_a)
    annotation (Line(points={{420,110},{420,270}}, color={238,46,47},
      thickness=1));
  connect(conWatRetTem.port_b, jun5.port_1)
    annotation (Line(points={{420,290},{420,300}}, color={238,46,47},
      thickness=1));
  connect(chiWatRet1.port_a, res.port_b)
    annotation (Line(points={{440,-270},{440,-290}}, color={0,127,255},
      thickness=1));
  connect(jun.port_3, chi1.port_a1)
    annotation (Line(points={{270,100},{320,100}}, color={238,46,47},
      thickness=1));
  connect(chi1.port_b1, cwIsoVal1.port_a)
    annotation (Line(points={{340,100},{370,100}}, color={238,46,47},
      thickness=1));
  connect(jun.port_2, chi2.port_a1)
    annotation (Line(points={{260,90},{260,10},{320,10}}, color={238,46,47},
      thickness=1));
  connect(chi2.port_b1, cwIsoVal2.port_a)
    annotation (Line(points={{340,10},{370,10}}, color={238,46,47},
      thickness=1));
  connect(chwIsoVal1.port_a, chi1.port_b2)
    annotation (Line(points={{250,70},{300,70},{300,88},{320,88}}, color={0,127,255},
      thickness=1));
  connect(chi1.port_a2, jun6.port_2)
    annotation (Line(points={{340,88},{360,88},{360,70},{440,70},{440,-10}}, color={0,127,255},
      thickness=1));
  connect(chwIsoVal2.port_a, chi2.port_b2)
    annotation (Line(points={{250,-20},{300,-20},{300,-2},{320,-2}}, color={0,127,255},
      thickness=1));
  connect(chi2.port_a2, jun6.port_3)
    annotation (Line(points={{340,-2},{360,-2},{360,-20},{430,-20}}, color={0,127,255},
      thickness=1));
  connect(chiWatRet.port_b, senVolFlo.port_a)
    annotation (Line(points={{440,-170},{440,-70}},color={0,127,255},
      thickness=1));
  connect(jun4.port_2, bou.ports[1])
    annotation (Line(points={{420,110},{460,110}}, color={238,46,47},
      thickness=1));
  connect(conWatPum1.port_b, cheVal.port_a) annotation (Line(
      points={{200,200},{200,179}},
      color={238,46,47},
      thickness=1));
  connect(cheVal.port_b, jun2.port_3) annotation (Line(
      points={{200,159},{200,140},{250,140}},
      color={238,46,47},
      thickness=1));
  connect(jun2.port_1, cheVal1.port_b) annotation (Line(
      points={{260,150},{260,159}},
      color={238,46,47},
      thickness=1));
  connect(cheVal1.port_a, conWatPum2.port_b) annotation (Line(
      points={{260,179},{260,200}},
      color={238,46,47},
      thickness=1));
  connect(chiWatPum1.port_b, cheVal2.port_a) annotation (Line(
      points={{200,-106},{200,-113}},
      color={0,127,255},
      thickness=1));
  connect(cheVal2.port_b, jun9.port_1) annotation (Line(
      points={{200,-133},{200,-140}},
      color={0,127,255},
      thickness=1));
  connect(chiWatPum2.port_b, cheVal3.port_a) annotation (Line(
      points={{260,-106},{260,-115}},
      color={0,127,255},
      thickness=1));
  connect(cheVal3.port_b, jun9.port_3) annotation (Line(
      points={{260,-135},{260,-150},{210,-150}},
      color={0,127,255},
      thickness=1));
 annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-580,-440},{580,440}})),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-580,-440},{580,440}}),
    graphics={Line(points={{290,46}},color={28,108,200})}));
end PartialChillerPlant;
