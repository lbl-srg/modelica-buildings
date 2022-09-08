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

  Buildings.Fluid.Storage.Ice.Tank iceTan(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dp_nominal=10000,
    SOC_start=3/4,
    per=perIceTan) "Ice tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-240,10})));

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
            {-10,10}},                                                                              rotation=90,origin={60,10})));


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
        origin={192,10})));

  Modelica.Blocks.Sources.Sine disCooLoad(
    amplitude=1,
    f=0.00001157,
    offset=1,
    startTime=1)
    annotation (Placement(transformation(extent={{280,30},{300,50}})));

  HeatExchangers.HeaterCooler_u disCooCoi(redeclare package Medium =
        MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=20000)
    "District cooling coil" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={320,10})));

  Actuators.Valves.TwoWayLinear valStoDis(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false) "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-240,-112})));

  Actuators.Valves.TwoWayLinear valStoCha(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false) "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-190,-92})));

  Movers.FlowControlled_m_flow pumHexPri(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={40,-50})));

  Movers.FlowControlled_m_flow pumHexSec(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={100,-50})));

  Movers.FlowControlled_m_flow pumChiWat(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={160,-50})));

  Movers.FlowControlled_m_flow pumLoa(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={320,-50})));

  Movers.FlowControlled_m_flow pumSto(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-240,-50})));

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
        origin={220,50})));

  Sources.Boundary_pT sin1(redeclare package Medium = MediumAir,
      nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={220,-50})));

  Sources.Boundary_pT preSou1(redeclare package Medium = MediumWater, nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{106,-230},{126,-210}})));

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
        origin={-50,-50})));

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
    annotation (Placement(transformation(extent={{250,-170},{270,-190}})));
  FixedResistances.Junction jun5(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{150,-170},{170,-190}})));
  FixedResistances.Junction jun6(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  FixedResistances.Junction jun7(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{250,90},{270,110}})));
  FixedResistances.Junction jun8(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal*{1,1,1},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-100,50})));
  Sensors.TemperatureTwoPort senTemHexWat(redeclare package Medium =
        MediumWater, m_flow_nominal=mWat_flow_nominal)
    "Heat exchanger outlet temperature on water side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,50})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToReaPum6(realTrue=
        mGly_flow_nominal, realFalse=0) "Pump 6 signal"
    annotation (Placement(transformation(extent={{-300,-20},{-280,0}})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToReaPum1(realTrue=
        mWat_flow_nominal, realFalse=0)                    "Pump 6 signal"
    annotation (Placement(transformation(extent={{40,158},{60,178}})));
  BaseClasses.ControlOpenLoop con "Controller"
    annotation (Placement(transformation(extent={{-386,218},{-370,246}})));
equation
  connect(pumSto.port_b, iceTan.port_a)
    annotation (Line(points={{-240,-40},{-240,0}}, color={0,127,255}));
  connect(pumChiGly.port_b, chiGly.port_a2) annotation (Line(points={{-100,-40},
          {-100,-6},{-76,-6},{-76,-1.77636e-15}},
                                color={0,127,255}));
  connect(pumSto.port_a, valStoCha.port_b) annotation (Line(points={{-240,-60},
          {-240,-92},{-200,-92}}, color={0,127,255}));
  connect(pumChiWat.port_b, chiWat.port_a2)
    annotation (Line(points={{160,-40},{160,-20},{186,-20},{186,-1.77636e-15}},
                                                 color={0,127,255}));
  connect(pumHexSec.port_b, hex.port_a2) annotation (Line(points={{100,-40},{100,
          -12},{66,-12},{66,0}},                    color={0,127,255}));
  connect(sou2.ports[1], chiGly.port_a1)
    annotation (Line(points={{-48,40},{-48,28},{-64,28},{-64,20}},
                                                         color={0,127,255}));
  connect(chiGly.port_b1, sin2.ports[1]) annotation (Line(points={{-64,-5.32907e-15},
          {-64,-50},{-60,-50}},color={0,127,255}));
  connect(sou1.ports[1], chiWat.port_a1)
    annotation (Line(points={{220,40},{220,24},{198,24},{198,20}},
                                                      color={0,127,255}));
  connect(chiWat.port_b1, sin1.ports[1])
    annotation (Line(points={{198,-5.32907e-15},{198,-50},{210,-50}},
                                                          color={0,127,255}));
  connect(weaDat.weaBus, sou2.weaBus) annotation (Line(
      points={{-120,150},{-48.2,150},{-48.2,60}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sou1.weaBus) annotation (Line(
      points={{-120,150},{219.8,150},{219.8,60}},
      color={255,204,51},
      thickness=0.5));
  connect(disCooCoi.u, disCooLoad.y)
    annotation (Line(points={{326,22},{326,40},{301,40}},   color={0,0,127}));
  connect(disCooCoi.port_b, pumLoa.port_a)
    annotation (Line(points={{320,0},{320,-40}},   color={0,127,255}));
  connect(pumHexPri.port_a, hex.port_b1) annotation (Line(points={{40,-40},{40,-12},
          {54,-12},{54,0}},      color={0,127,255}));
  connect(iceTan.port_b, jun.port_1) annotation (Line(points={{-240,20},{-240,100},
          {-110,100}}, color={0,127,255}));
  connect(valStoDis.port_b, pumSto.port_a)
    annotation (Line(points={{-240,-102},{-240,-60}}, color={0,127,255}));
  connect(jun8.port_2, chiGly.port_b2) annotation (Line(points={{-100,40},{-100,
          32},{-76,32},{-76,20}}, color={0,127,255}));
  connect(jun8.port_1, jun.port_3)
    annotation (Line(points={{-100,60},{-100,90}}, color={0,127,255}));
  connect(jun8.port_3, valStoCha.port_a) annotation (Line(points={{-110,50},{
          -160,50},{-160,-92},{-180,-92}}, color={0,127,255}));
  connect(valStoDis.port_a, jun3.port_1) annotation (Line(points={{-240,-122},{
          -240,-180},{-110,-180}}, color={0,127,255}));
  connect(jun3.port_3, pumChiGly.port_a)
    annotation (Line(points={{-100,-170},{-100,-60}}, color={0,127,255}));
  connect(jun3.port_2, jun2.port_1)
    annotation (Line(points={{-90,-180},{-30,-180}}, color={0,127,255}));
  connect(jun2.port_3, jun1.port_3)
    annotation (Line(points={{-20,-170},{-20,90}}, color={0,127,255}));
  connect(jun1.port_2, hex.port_a1)
    annotation (Line(points={{-10,100},{54,100},{54,20}}, color={0,127,255}));
  connect(jun.port_2, jun1.port_1)
    annotation (Line(points={{-90,100},{-30,100}}, color={0,127,255}));
  connect(pumHexPri.port_b, jun2.port_2) annotation (Line(points={{40,-60},{40,-180},
          {-10,-180}},       color={0,127,255}));
  connect(pumHexSec.port_a, jun5.port_1) annotation (Line(points={{100,-60},{100,
          -180},{150,-180}}, color={0,127,255}));
  connect(jun6.port_2, jun7.port_1)
    annotation (Line(points={{170,100},{250,100}}, color={0,127,255}));
  connect(jun6.port_3, chiWat.port_b2) annotation (Line(points={{160,90},{160,40},
          {186,40},{186,20}},     color={0,127,255}));
  connect(pumChiWat.port_a, jun5.port_3)
    annotation (Line(points={{160,-60},{160,-170}}, color={0,127,255}));
  connect(jun7.port_3, jun4.port_3)
    annotation (Line(points={{260,90},{260,-170}}, color={0,127,255}));
  connect(jun7.port_2, disCooCoi.port_a) annotation (Line(points={{270,100},{320,
          100},{320,20}},     color={0,127,255}));
  connect(pumLoa.port_b, jun4.port_2) annotation (Line(points={{320,-60},{320,-180},
          {270,-180}},       color={0,127,255}));
  connect(jun4.port_1, jun5.port_2)
    annotation (Line(points={{250,-180},{170,-180}}, color={0,127,255}));
  connect(preSou1.ports[1], jun5.port_1) annotation (Line(points={{126,-220},{140,
          -220},{140,-180},{150,-180}},     color={0,127,255}));
  connect(preSou2.ports[1], jun3.port_1) annotation (Line(points={{-138,-220},{
          -126,-220},{-126,-180},{-110,-180}}, color={0,127,255}));
  connect(hex.port_b2, senTemHexWat.port_a) annotation (Line(points={{66,20},{66,
          24},{100,24},{100,40}}, color={0,127,255}));
  connect(senTemHexWat.port_b, jun6.port_1) annotation (Line(points={{100,60},{100,
          100},{150,100}}, color={0,127,255}));
  connect(booToReaPum6.y, pumSto.m_flow_in) annotation (Line(points={{-278,-10},
          {-266,-10},{-266,-50},{-252,-50}}, color={0,0,127}));
  connect(booToReaPum6.y, pumChiGly.m_flow_in) annotation (Line(points={{-278,-10},
          {-128,-10},{-128,-50},{-112,-50}}, color={0,0,127}));
  connect(booToReaPum6.y, pumHexPri.m_flow_in) annotation (Line(points={{-278,-10},
          {10,-10},{10,-50},{28,-50},{28,-50}}, color={0,0,127}));
  connect(booToReaPum1.y, pumHexSec.m_flow_in) annotation (Line(points={{62,168},
          {132,168},{132,-50},{112,-50}}, color={0,0,127}));
  connect(booToReaPum1.y, pumChiWat.m_flow_in) annotation (Line(points={{62,168},
          {132,168},{132,-50},{148,-50}}, color={0,0,127}));
  connect(booToReaPum1.y, pumLoa.m_flow_in) annotation (Line(points={{62,168},{370,
          168},{370,-50},{332,-50}}, color={0,0,127}));
  connect(con.TChiWatSet, chiWat.TSet) annotation (Line(points={{-368.4,243.667},
          {189,243.667},{189,22}}, color={0,0,127}));
  connect(con.yTru, chiWat.on) annotation (Line(points={{-368.4,225},{195,225},
          {195,22}}, color={255,0,255}));
  connect(con.TChiGlySet, chiGly.TSet) annotation (Line(points={{-368.4,239},{
          -73,239},{-73,22}}, color={0,0,127}));
  connect(con.yTru, chiGly.on) annotation (Line(points={{-368.4,225},{-67,225},
          {-67,22}}, color={255,0,255}));
  connect(con.yTru, booToReaPum6.u) annotation (Line(points={{-368.4,225},{-308,
          225},{-308,-10},{-302,-10}}, color={255,0,255}));
  connect(con.yTru, booToReaPum1.u) annotation (Line(points={{-368.4,225},{20,
          225},{20,168},{38,168}}, color={255,0,255}));
  connect(con.yStoOn, valStoDis.y) annotation (Line(points={{-368.4,234.333},{
          -362,234.333},{-362,234},{-340,234},{-340,-112},{-252,-112}}, color={
          0,0,127}));
  connect(con.yStoByp, valStoCha.y) annotation (Line(points={{-368.4,229.667},{
          -364,229.667},{-364,230},{-346,230},{-346,-68},{-190,-68},{-190,-80}},
        color={0,0,127}));
  annotation (
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"modelica://Buildings.Fluid.Storage.Ice\">Buildings.Fluid.Storage.Ice</a> through its implementation in a simplified district cooling system.
</p>
</p>
<p align=\"center\">
<img alt=\"image of ice system\" width=\"750\" src=\"modelica://Buildings/Resources/Images/Fluid/Storage/IceSystem.png\"/>
</p>
<p>
</html>", revisions="<html>
<ul>
<li>
September 8, 2022, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
March 1, 2022, by Dre Helmns:<br/>
Implementation of ice tank in a simplified district cooling system.<br/>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-400,-300},{400,300}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end DistrictCoolingIceTank;
