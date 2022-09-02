within Buildings.Fluid.Storage.Ice.Examples;
model DistrictCoolingIceTank
  "Example that tests the ice tank model for a simplified district cooling application"
  extends Modelica.Icons.Example;

  package MediumGlycol = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15, X_a=0.30) "Fluid medium";
  package MediumWater = Buildings.Media.Water "Fluid medium";
  package MediumAir = Buildings.Media.Air "Fluid medium";

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=1
    "Nominal mass flow rate of air through the chiller condenser coil";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal=1
    "Nominal mass flow rate of water through the water circuit";
  parameter Modelica.Units.SI.MassFlowRate mGly_flow_nominal=1
    "Nominal mass flow rate of glycol through the glycol circuit";

  parameter Buildings.Fluid.Storage.Ice.Data.Tank.Generic perIceTan(
    mIce_max=1/4*2846.35,
    coeCha={1.76953858E-04,0,0,0,0,0},
    dtCha=10,
    coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,-1.1012E-03,3.00544E-04},
    dtDisCha=10) "Tank performance data" annotation (Placement(transformation(extent={{-226,
            140},{-206,160}})));

  parameter
    Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled
    perChi annotation (Placement(transformation(extent={{-192,140},{-172,160}})));

  Buildings.Fluid.Storage.Ice.Tank iceTanUnc1(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dp_nominal=10000,
    SOC_start=3/4,
    per=perIceTan) "Uncontrolled ice tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-220,10})));

  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSet(k=273.15 - 6.7)
    "Set point"
    annotation (Placement(transformation(extent={{-120,180},{-102,198}})));

  Controls.OBC.CDL.Logical.Sources.Constant chiGlyOn(k=true) "On signal"
    annotation (Placement(transformation(extent={{-80,180},{-62,198}})));

  Chillers.ElectricEIR chiGly(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumGlycol,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mGly_flow_nominal,
    dp2_nominal=16000,
    dp1_nominal=16000,
    per=perChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,10})));

  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumGlycol,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mGly_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    eps=0.8,
    dp2_nominal=16000,
    dp1_nominal=16000)
                   "Heat exchanger" annotation (Placement(transformation(extent={{10,-10},
            {-10,10}},                                                                              rotation=90,origin={30,10})));


  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k=273.15 + 15.2)
    "Set point"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));

  Controls.OBC.CDL.Logical.Sources.Constant ChiWatOn(k=true) "On signal"
    annotation (Placement(transformation(extent={{40,180},{60,200}})));

  Chillers.ElectricEIR chiWat(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    dp2_nominal=16000,
    dp1_nominal=16000,
    per=perChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={152,10})));

  Modelica.Blocks.Sources.Sine disCooLoad(
    amplitude=1,
    f=0.00001157,
    offset=1,
    startTime=1)
    annotation (Placement(transformation(extent={{318,20},{300,38}})));

  HeatExchangers.HeaterCooler_u disCooCoi(redeclare package Medium =
        MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=20000)
    "District cooling coil" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={280,10})));

  Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-220,-90})));

  Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-190,-70})));

  Movers.FlowControlled_m_flow pumHexPri(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={10,-50})));

  Movers.FlowControlled_m_flow pumHexSec(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,-50})));

  Movers.FlowControlled_m_flow pumChiWat(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={120,-50})));

  Movers.FlowControlled_m_flow pumLoa(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={280,-50})));

  Movers.FlowControlled_m_flow pumSto(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-220,-50})));

  Movers.FlowControlled_m_flow pumChiGly(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-100,-50})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Sources.MassFlowSource_WeatherData sou1(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={182,50})));

  Sources.Boundary_pT sin1(redeclare package Medium = MediumAir,
      nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={182,-20})));

  Sources.Boundary_pT preSou1(redeclare package Medium = MediumWater, nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{66,-230},{86,-210}})));

  Sources.MassFlowSource_WeatherData sou2(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-48,50})));

  Sources.Boundary_pT sin2(redeclare package Medium = MediumAir,
      nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={-50,-18})));

  Sources.Boundary_pT preSou2(redeclare package Medium = MediumGlycol, nPorts=1)
    "Source for pressure and to account for thermal expansion of glycol"
    annotation (Placement(transformation(extent={{-158,-230},{-138,-210}})));

  FixedResistances.Junction jun(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  FixedResistances.Junction jun1(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  FixedResistances.Junction jun2(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-30,-170},{-10,-190}})));
  FixedResistances.Junction jun3(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-110,-170},{-90,-190}})));
  FixedResistances.Junction jun4(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{210,-170},{230,-190}})));
  FixedResistances.Junction jun5(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{110,-170},{130,-190}})));
  FixedResistances.Junction jun6(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{110,90},{130,110}})));
  FixedResistances.Junction jun7(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{210,90},{230,110}})));
  FixedResistances.Junction jun8(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-100,50})));
  Sensors.TemperatureTwoPort senTem annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,50})));
equation
  connect(pumSto.port_b, iceTanUnc1.port_a)
    annotation (Line(points={{-220,-40},{-220,0}},   color={0,127,255}));
  connect(pumChiGly.port_b, chiGly.port_a2) annotation (Line(points={{-100,-40},
          {-100,-6},{-76,-6},{-76,-1.77636e-15}},
                                color={0,127,255}));
  connect(pumSto.port_a, val5.port_b) annotation (Line(points={{-220,-60},{-220,
          -70},{-200,-70}}, color={0,127,255}));
  connect(pumChiWat.port_b, chiWat.port_a2)
    annotation (Line(points={{120,-40},{120,-20},{146,-20},{146,-1.77636e-15}},
                                                 color={0,127,255}));
  connect(pumHexSec.port_b, hex.port_a2) annotation (Line(points={{60,-40},{60,
          -12},{36,-12},{36,0}},                    color={0,127,255}));
  connect(sou2.ports[1], chiGly.port_a1)
    annotation (Line(points={{-48,40},{-48,28},{-64,28},{-64,20}},
                                                         color={0,127,255}));
  connect(chiGly.port_b1, sin2.ports[1]) annotation (Line(points={{-64,
          -5.32907e-15},{-64,-18},{-60,-18}},
                               color={0,127,255}));
  connect(sou1.ports[1], chiWat.port_a1)
    annotation (Line(points={{182,40},{182,24},{158,24},{158,20}},
                                                      color={0,127,255}));
  connect(chiWat.port_b1, sin1.ports[1])
    annotation (Line(points={{158,-5.32907e-15},{158,-20},{172,-20}},
                                                          color={0,127,255}));
  connect(weaDat.weaBus, sou2.weaBus) annotation (Line(
      points={{-120,150},{-48.2,150},{-48.2,60}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sou1.weaBus) annotation (Line(
      points={{-120,150},{-28,150},{-28,126},{181.8,126},{181.8,60}},
      color={255,204,51},
      thickness=0.5));
  connect(chiGly.TSet, chiGlyTSet.y) annotation (Line(points={{-73,22},{-73,178},
          {-100.2,178},{-100.2,189}},   color={0,0,127}));
  connect(chiGly.on, chiGlyOn.y) annotation (Line(points={{-67,22},{-60.2,22},{
          -60.2,189}},              color={255,0,255}));
  connect(disCooCoi.u, disCooLoad.y)
    annotation (Line(points={{286,22},{286,30},{288,30},{288,29},{299.1,29}},
                                                            color={0,0,127}));
  connect(disCooCoi.port_b, pumLoa.port_a)
    annotation (Line(points={{280,0},{280,-40}},   color={0,127,255}));
  connect(pumHexPri.port_a, hex.port_b1) annotation (Line(points={{10,-40},{10,
          -12},{24,-12},{24,0}}, color={0,127,255}));
  connect(iceTanUnc1.port_b, jun.port_1) annotation (Line(points={{-220,20},{
          -220,100},{-110,100}},
                               color={0,127,255}));
  connect(val4.port_b, pumSto.port_a)
    annotation (Line(points={{-220,-80},{-220,-60}}, color={0,127,255}));
  connect(jun8.port_2, chiGly.port_b2) annotation (Line(points={{-100,40},{-100,
          32},{-76,32},{-76,20}}, color={0,127,255}));
  connect(jun8.port_1, jun.port_3)
    annotation (Line(points={{-100,60},{-100,90}}, color={0,127,255}));
  connect(jun8.port_3, val5.port_a) annotation (Line(points={{-110,50},{-160,50},
          {-160,-70},{-180,-70}}, color={0,127,255}));
  connect(val4.port_a, jun3.port_1) annotation (Line(points={{-220,-100},{-220,
          -180},{-110,-180}}, color={0,127,255}));
  connect(jun3.port_3, pumChiGly.port_a)
    annotation (Line(points={{-100,-170},{-100,-60}}, color={0,127,255}));
  connect(jun3.port_2, jun2.port_1)
    annotation (Line(points={{-90,-180},{-30,-180}}, color={0,127,255}));
  connect(jun2.port_3, jun1.port_3)
    annotation (Line(points={{-20,-170},{-20,90}}, color={0,127,255}));
  connect(jun1.port_2, hex.port_a1)
    annotation (Line(points={{-10,100},{24,100},{24,20}}, color={0,127,255}));
  connect(jun.port_2, jun1.port_1)
    annotation (Line(points={{-90,100},{-30,100}}, color={0,127,255}));
  connect(pumHexPri.port_b, jun2.port_2) annotation (Line(points={{10,-60},{10,
          -180},{-10,-180}}, color={0,127,255}));
  connect(pumHexSec.port_a, jun5.port_1) annotation (Line(points={{60,-60},{60,
          -180},{110,-180}}, color={0,127,255}));
  connect(jun6.port_2, jun7.port_1)
    annotation (Line(points={{130,100},{210,100}}, color={0,127,255}));
  connect(jun6.port_3, chiWat.port_b2) annotation (Line(points={{120,90},{120,
          40},{146,40},{146,20}}, color={0,127,255}));
  connect(pumChiWat.port_a, jun5.port_3)
    annotation (Line(points={{120,-60},{120,-170}}, color={0,127,255}));
  connect(jun7.port_3, jun4.port_3)
    annotation (Line(points={{220,90},{220,-170}}, color={0,127,255}));
  connect(jun7.port_2, disCooCoi.port_a) annotation (Line(points={{230,100},{
          280,100},{280,20}}, color={0,127,255}));
  connect(pumLoa.port_b, jun4.port_2) annotation (Line(points={{280,-60},{280,
          -180},{230,-180}}, color={0,127,255}));
  connect(jun4.port_1, jun5.port_2)
    annotation (Line(points={{210,-180},{130,-180}}, color={0,127,255}));
  connect(preSou1.ports[1], jun5.port_1) annotation (Line(points={{86,-220},{
          100,-220},{100,-180},{110,-180}}, color={0,127,255}));
  connect(preSou2.ports[1], jun3.port_1) annotation (Line(points={{-138,-220},{
          -126,-220},{-126,-180},{-110,-180}}, color={0,127,255}));
  connect(hex.port_b2, senTem.port_a) annotation (Line(points={{36,20},{36,24},
          {60,24},{60,40}}, color={0,127,255}));
  connect(senTem.port_b, jun6.port_1)
    annotation (Line(points={{60,60},{60,100},{110,100}}, color={0,127,255}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"Buildings.Fluid.Storage.Ice\">Buildings.Fluid.Storage.Ice</a> through its implementation in a simplified district cooling system.
</p>
</p>
<p align=\"center\">
<img alt=\"image of ice system\" width=\"750\" src=\"modelica://Buildings/Resources/Images/Fluid/Storage/IceSystem.png\"/>
</p>
<p>
</html>", revisions="<html>
<ul>
<li>
March 1, 2022, by Dre Helmns:<br/>
Implementation of ice tank in a simplified district cooling system.<br/>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-300,-260},{300,260}})),
    Icon(coordinateSystem(extent={{-300,-260},{300,260}})));
end DistrictCoolingIceTank;
