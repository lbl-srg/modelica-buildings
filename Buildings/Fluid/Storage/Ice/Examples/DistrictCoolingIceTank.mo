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
    dtDisCha=10) "Tank performance data" annotation (Placement(transformation(extent={{-114,-94},{-94,-74}})));

  parameter
    Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled
    perChi annotation (Placement(transformation(extent={{-80,-94},{-60,-74}})));

  Buildings.Fluid.Storage.Ice.Tank iceTanUnc1(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dp_nominal=10000,
    SOC_start=3/4,
    per=perIceTan) "Uncontrolled ice tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-100,0})));

  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSet(k=273.15 - 6.7)
    "Set point"
    annotation (Placement(transformation(extent={{-64,56},{-52,68}})));

  Controls.OBC.CDL.Logical.Sources.Constant chiGlyOn(k=true) "On signal"
    annotation (Placement(transformation(extent={{-64,74},{-52,86}})));

  Chillers.ElectricEIR chiGly(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumGlycol,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mGly_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=perChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-54,-9})));

  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumGlycol,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mGly_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    eps=0.8,
    dp2_nominal=0,
    dp1_nominal=0) "Heat exchanger" annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={10,1})));


  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k=273.15 + 15.2)
    "Set point"
    annotation (Placement(transformation(extent={{68,-92},{80,-80}})));

  Controls.OBC.CDL.Logical.Sources.Constant ChiWatOn(k=true) "On signal"
    annotation (Placement(transformation(extent={{68,-72},{80,-60}})));

  Chillers.ElectricEIR chiWat(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=perChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={66,-9})));

  Modelica.Blocks.Sources.Sine disCooLoad(
    amplitude=1,
    f=0.00001157,
    offset=1,
    startTime=1)
    annotation (Placement(transformation(extent={{130,64},{142,76}})));

  HeatExchangers.HeaterCooler_u disCooCoi(redeclare package Medium =
        MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=20000)
    "District cooling coil" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={140,0})));

  Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={20,40})));

  Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=90,
        origin={40,0})));

  Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={60,40})));

  Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-100,40})));

  Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={-80,0})));

  Actuators.Valves.TwoWayLinear val6(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={-60,40})));

  Actuators.Valves.TwoWayLinear val7(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={0,40})));

  Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=270,
        origin={0,-40})));

  Movers.FlowControlled_m_flow pum2(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={20,-30})));

  Movers.FlowControlled_m_flow pum3(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={60,-40})));

  Movers.FlowControlled_m_flow pum4(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={120,50})));

  Movers.FlowControlled_m_flow pum5(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-100,-30})));

  Movers.FlowControlled_m_flow pum6(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-60,-40})));

  Sensors.TemperatureTwoPort temSen1(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={20,20})));

  Sensors.TemperatureTwoPort temSen2(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={60,20})));

  Sensors.TemperatureTwoPort temSen3(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={140,-20})));

  Sensors.TemperatureTwoPort temSen4(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-100,20})));

  Sensors.TemperatureTwoPort temSen5(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-60,20})));

  Sensors.TemperatureTwoPort temSen6(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={0,-20})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("Buildings/modelica-buildings/Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Sources.MassFlowSource_WeatherData sou1(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={84,20})));

  Sources.Boundary_pT sin1(redeclare package Medium = MediumAir,
      nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={85,-31})));

  Sources.Boundary_pT preSou1(redeclare package Medium = MediumWater, nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{116,-6},{104,6}})));

  Sources.MassFlowSource_WeatherData sou2(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-36,20})));

  Sources.Boundary_pT sin2(redeclare package Medium = MediumAir,
      nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={-35,-31})));

  Sources.Boundary_pT preSou2(redeclare package Medium = MediumGlycol,nPorts=1)
    "Source for pressure and to account for thermal expansion of glycol"
    annotation (Placement(transformation(extent={{-36,-6},{-24,6}})));

equation
  connect(pum5.port_b, iceTanUnc1.port_a)
    annotation (Line(points={{-100,-24},{-100,-10}}, color={0,127,255}));
  connect(iceTanUnc1.port_b, temSen4.port_a)
    annotation (Line(points={{-100,10},{-100,14}}, color={0,127,255}));
  connect(temSen4.port_b, val4.port_a)
    annotation (Line(points={{-100,26},{-100,36}}, color={0,127,255}));
  connect(val4.port_b, val6.port_b) annotation (Line(points={{-100,44},{-100,50},
          {-60,50},{-60,44}}, color={0,127,255}));
  connect(val7.port_a, val6.port_b) annotation (Line(points={{0,44},{0,50},{-60,
          50},{-60,44}}, color={0,127,255}));
  connect(val7.port_b, hex.port_a1)
    annotation (Line(points={{0,36},{0,14},{4,14},{4,11}}, color={0,127,255}));
  connect(hex.port_b1, temSen6.port_a) annotation (Line(points={{4,-9},{4,-12},
          {0,-12},{0,-14}}, color={0,127,255}));
  connect(temSen6.port_b, pum1.port_a)
    annotation (Line(points={{0,-26},{0,-34}}, color={0,127,255}));
  connect(pum6.port_b, chiGly.port_a2)
    annotation (Line(points={{-60,-34},{-60,-19}}, color={0,127,255}));
  connect(chiGly.port_b2, temSen5.port_a)
    annotation (Line(points={{-60,1},{-60,14}}, color={0,127,255}));
  connect(temSen5.port_b, val5.port_a) annotation (Line(points={{-60,26},{-60,
          30},{-80,30},{-80,4}}, color={0,127,255}));
  connect(val6.port_a, temSen5.port_b)
    annotation (Line(points={{-60,36},{-60,26}}, color={0,127,255}));
  connect(pum1.port_b, pum6.port_a) annotation (Line(points={{0,-46},{0,-52},{
          -60,-52},{-60,-46}}, color={0,127,255}));
  connect(pum5.port_a, val5.port_b) annotation (Line(points={{-100,-36},{-100,
          -44},{-80,-44},{-80,-4}}, color={0,127,255}));
  connect(pum5.port_a, pum6.port_a) annotation (Line(points={{-100,-36},{-100,
          -52},{-60,-52},{-60,-46}}, color={0,127,255}));
  connect(val6.port_b, pum6.port_a) annotation (Line(points={{-60,44},{-60,50},
          {-20,50},{-20,-52},{-60,-52},{-60,-46}}, color={0,127,255}));
  connect(pum3.port_b, chiWat.port_a2)
    annotation (Line(points={{60,-34},{60,-19}}, color={0,127,255}));
  connect(chiWat.port_b2, temSen2.port_a)
    annotation (Line(points={{60,1},{60,14}}, color={0,127,255}));
  connect(temSen2.port_b, val2.port_a) annotation (Line(points={{60,26},{60,30},
          {40,30},{40,4}}, color={0,127,255}));
  connect(temSen2.port_b, val3.port_a)
    annotation (Line(points={{60,26},{60,36}}, color={0,127,255}));
  connect(pum2.port_b, hex.port_a2) annotation (Line(points={{20,-24},{20,-12},
          {16,-12},{16,-9}}, color={0,127,255}));
  connect(hex.port_b2, temSen1.port_a)
    annotation (Line(points={{16,11},{16,14},{20,14}}, color={0,127,255}));
  connect(temSen1.port_b, val1.port_a)
    annotation (Line(points={{20,26},{20,36}}, color={0,127,255}));
  connect(val1.port_b, val3.port_b) annotation (Line(points={{20,44},{20,50},{
          60,50},{60,44}}, color={0,127,255}));
  connect(pum4.port_a, val3.port_b)
    annotation (Line(points={{114,50},{60,50},{60,44}}, color={0,127,255}));
  connect(pum4.port_b, disCooCoi.port_a)
    annotation (Line(points={{126,50},{140,50},{140,10}}, color={0,127,255}));
  connect(disCooCoi.port_b, temSen3.port_a)
    annotation (Line(points={{140,-10},{140,-14}}, color={0,127,255}));
  connect(temSen3.port_b, pum3.port_a) annotation (Line(points={{140,-26},{140,
          -52},{60,-52},{60,-46}}, color={0,127,255}));
  connect(pum2.port_a, pum3.port_a) annotation (Line(points={{20,-36},{20,-52},
          {60,-52},{60,-46}}, color={0,127,255}));
  connect(val3.port_b, pum3.port_a) annotation (Line(points={{60,44},{60,50},{
          100,50},{100,-52},{60,-52},{60,-46}}, color={0,127,255}));
  connect(val2.port_b, pum2.port_a) annotation (Line(points={{40,-4},{40,-42},{
          20,-42},{20,-36}}, color={0,127,255}));
  connect(sou2.ports[1], chiGly.port_a1)
    annotation (Line(points={{-42,20},{-48,20},{-48,1}}, color={0,127,255}));
  connect(chiGly.port_b1, sin2.ports[1]) annotation (Line(points={{-48,-19},{
          -48,-31},{-40,-31}}, color={0,127,255}));
  connect(sou1.ports[1], chiWat.port_a1)
    annotation (Line(points={{78,20},{72,20},{72,1}}, color={0,127,255}));
  connect(chiWat.port_b1, sin1.ports[1])
    annotation (Line(points={{72,-19},{72,-31},{80,-31}}, color={0,127,255}));
  connect(preSou1.ports[1], pum3.port_a) annotation (Line(points={{104,0},{100,
          0},{100,-52},{60,-52},{60,-46}}, color={0,127,255}));
  connect(preSou2.ports[1], pum6.port_a) annotation (Line(points={{-24,0},{-20,
          0},{-20,-52},{-60,-52},{-60,-46}}, color={0,127,255}));
  connect(weaDat.weaBus, sou2.weaBus) annotation (Line(
      points={{-80,70},{-30,70},{-30,20.12}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sou1.weaBus) annotation (Line(
      points={{-80,70},{90,70},{90,20.12}},
      color={255,204,51},
      thickness=0.5));
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
    Diagram(coordinateSystem(extent={{-120,-100},{160,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{160,100}})));
end DistrictCoolingIceTank;
