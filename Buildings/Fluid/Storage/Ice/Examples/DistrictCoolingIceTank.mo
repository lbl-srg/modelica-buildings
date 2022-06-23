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
    dtDisCha=10) "Tank performance data" annotation (Placement(transformation(extent={{-134,
            -94},{-114,-74}})));

  parameter
    Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled
    perChi annotation (Placement(transformation(extent={{-100,-94},{-80,-74}})));

  Buildings.Fluid.Storage.Ice.Tank iceTanUnc1(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dp_nominal=10000,
    SOC_start=3/4,
    per=perIceTan) "Uncontrolled ice tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-120,0})));

  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSet(k=273.15 - 6.7)
    "Set point"
    annotation (Placement(transformation(extent={{-84,56},{-72,68}})));

  Controls.OBC.CDL.Logical.Sources.Constant chiGlyOn(k=true) "On signal"
    annotation (Placement(transformation(extent={{-84,74},{-72,86}})));

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
        origin={-74,-9})));

  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumGlycol,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mGly_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    eps=0.8,
    dp2_nominal=0,
    dp1_nominal=0) "Heat exchanger" annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={-10,1})));


  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k=273.15 + 15.2)
    "Set point"
    annotation (Placement(transformation(extent={{48,-92},{60,-80}})));

  Controls.OBC.CDL.Logical.Sources.Constant ChiWatOn(k=true) "On signal"
    annotation (Placement(transformation(extent={{48,-72},{60,-60}})));

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
        origin={46,-9})));

  Modelica.Blocks.Sources.Sine disCooLoad(
    amplitude=1,
    f=0.00001157,
    offset=1,
    startTime=1)
    annotation (Placement(transformation(extent={{110,64},{122,76}})));

  HeatExchangers.HeaterCooler_u disCooCoi(redeclare package Medium =
        MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=20000)
    "District cooling coil" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={120,0})));

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
        origin={0,40})));

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
        origin={20,0})));

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
        origin={40,40})));

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
        origin={-120,40})));

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
        origin={-100,0})));

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
        origin={-80,40})));

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
        origin={-20,40})));

  Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=270,
        origin={-20,-40})));

  Movers.FlowControlled_m_flow pum2(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={0,-30})));

  Movers.FlowControlled_m_flow pum3(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={40,-40})));

  Movers.FlowControlled_m_flow pum4(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={100,50})));

  Movers.FlowControlled_m_flow pum5(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-120,-30})));

  Movers.FlowControlled_m_flow pum6(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-80,-40})));

  Sensors.TemperatureTwoPort temSen1(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={0,20})));

  Sensors.TemperatureTwoPort temSen2(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={40,20})));

  Sensors.TemperatureTwoPort temSen3(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={120,-20})));

  Sensors.TemperatureTwoPort temSen4(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-120,20})));

  Sensors.TemperatureTwoPort temSen5(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-80,20})));

  Sensors.TemperatureTwoPort temSen6(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-20,-20})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Sources.MassFlowSource_WeatherData sou1(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={64,20})));

  Sources.Boundary_pT sin1(redeclare package Medium = MediumAir,
      nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={65,-31})));

  Sources.Boundary_pT preSou1(redeclare package Medium = MediumWater, nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{96,-6},{84,6}})));

  Sources.MassFlowSource_WeatherData sou2(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-56,20})));

  Sources.Boundary_pT sin2(redeclare package Medium = MediumAir,
      nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={-55,-31})));

  Sources.Boundary_pT preSou2(redeclare package Medium = MediumGlycol,nPorts=1)
    "Source for pressure and to account for thermal expansion of glycol"
    annotation (Placement(transformation(extent={{-56,-6},{-44,6}})));

equation
  connect(pum5.port_b, iceTanUnc1.port_a)
    annotation (Line(points={{-120,-24},{-120,-10}}, color={0,127,255}));
  connect(iceTanUnc1.port_b, temSen4.port_a)
    annotation (Line(points={{-120,10},{-120,14}}, color={0,127,255}));
  connect(temSen4.port_b, val4.port_a)
    annotation (Line(points={{-120,26},{-120,36}}, color={0,127,255}));
  connect(val4.port_b, val6.port_b) annotation (Line(points={{-120,44},{-120,50},
          {-80,50},{-80,44}}, color={0,127,255}));
  connect(val7.port_a, val6.port_b) annotation (Line(points={{-20,44},{-20,50},
          {-80,50},{-80,44}},
                         color={0,127,255}));
  connect(val7.port_b, hex.port_a1)
    annotation (Line(points={{-20,36},{-20,14},{-16,14},{-16,11}},
                                                           color={0,127,255}));
  connect(hex.port_b1, temSen6.port_a) annotation (Line(points={{-16,-9},{-16,
          -12},{-20,-12},{-20,-14}},
                            color={0,127,255}));
  connect(temSen6.port_b, pum1.port_a)
    annotation (Line(points={{-20,-26},{-20,-34}},
                                               color={0,127,255}));
  connect(pum6.port_b, chiGly.port_a2)
    annotation (Line(points={{-80,-34},{-80,-19}}, color={0,127,255}));
  connect(chiGly.port_b2, temSen5.port_a)
    annotation (Line(points={{-80,1},{-80,14}}, color={0,127,255}));
  connect(temSen5.port_b, val5.port_a) annotation (Line(points={{-80,26},{-80,
          30},{-100,30},{-100,4}},
                                 color={0,127,255}));
  connect(val6.port_a, temSen5.port_b)
    annotation (Line(points={{-80,36},{-80,26}}, color={0,127,255}));
  connect(pum1.port_b, pum6.port_a) annotation (Line(points={{-20,-46},{-20,-52},
          {-80,-52},{-80,-46}},color={0,127,255}));
  connect(pum5.port_a, val5.port_b) annotation (Line(points={{-120,-36},{-120,
          -44},{-100,-44},{-100,-4}},
                                    color={0,127,255}));
  connect(pum5.port_a, pum6.port_a) annotation (Line(points={{-120,-36},{-120,
          -52},{-80,-52},{-80,-46}}, color={0,127,255}));
  connect(val6.port_b, pum6.port_a) annotation (Line(points={{-80,44},{-80,50},
          {-40,50},{-40,-52},{-80,-52},{-80,-46}}, color={0,127,255}));
  connect(pum3.port_b, chiWat.port_a2)
    annotation (Line(points={{40,-34},{40,-19}}, color={0,127,255}));
  connect(chiWat.port_b2, temSen2.port_a)
    annotation (Line(points={{40,1},{40,14}}, color={0,127,255}));
  connect(temSen2.port_b, val2.port_a) annotation (Line(points={{40,26},{40,30},
          {20,30},{20,4}}, color={0,127,255}));
  connect(temSen2.port_b, val3.port_a)
    annotation (Line(points={{40,26},{40,36}}, color={0,127,255}));
  connect(pum2.port_b, hex.port_a2) annotation (Line(points={{0,-24},{0,-12},{
          -4,-12},{-4,-9}},  color={0,127,255}));
  connect(hex.port_b2, temSen1.port_a)
    annotation (Line(points={{-4,11},{-4,14},{0,14}},  color={0,127,255}));
  connect(temSen1.port_b, val1.port_a)
    annotation (Line(points={{0,26},{0,36}},   color={0,127,255}));
  connect(val1.port_b, val3.port_b) annotation (Line(points={{0,44},{0,50},{40,
          50},{40,44}},    color={0,127,255}));
  connect(pum4.port_a, val3.port_b)
    annotation (Line(points={{94,50},{40,50},{40,44}},  color={0,127,255}));
  connect(pum4.port_b, disCooCoi.port_a)
    annotation (Line(points={{106,50},{120,50},{120,10}}, color={0,127,255}));
  connect(disCooCoi.port_b, temSen3.port_a)
    annotation (Line(points={{120,-10},{120,-14}}, color={0,127,255}));
  connect(temSen3.port_b, pum3.port_a) annotation (Line(points={{120,-26},{120,
          -52},{40,-52},{40,-46}}, color={0,127,255}));
  connect(pum2.port_a, pum3.port_a) annotation (Line(points={{0,-36},{0,-52},{
          40,-52},{40,-46}},  color={0,127,255}));
  connect(val3.port_b, pum3.port_a) annotation (Line(points={{40,44},{40,50},{
          80,50},{80,-52},{40,-52},{40,-46}},   color={0,127,255}));
  connect(val2.port_b, pum2.port_a) annotation (Line(points={{20,-4},{20,-42},{
          0,-42},{0,-36}},   color={0,127,255}));
  connect(sou2.ports[1], chiGly.port_a1)
    annotation (Line(points={{-62,20},{-68,20},{-68,1}}, color={0,127,255}));
  connect(chiGly.port_b1, sin2.ports[1]) annotation (Line(points={{-68,-19},{
          -68,-31},{-60,-31}}, color={0,127,255}));
  connect(sou1.ports[1], chiWat.port_a1)
    annotation (Line(points={{58,20},{52,20},{52,1}}, color={0,127,255}));
  connect(chiWat.port_b1, sin1.ports[1])
    annotation (Line(points={{52,-19},{52,-31},{60,-31}}, color={0,127,255}));
  connect(preSou1.ports[1], pum3.port_a) annotation (Line(points={{84,0},{80,0},
          {80,-52},{40,-52},{40,-46}},     color={0,127,255}));
  connect(preSou2.ports[1], pum6.port_a) annotation (Line(points={{-44,0},{-40,
          0},{-40,-52},{-80,-52},{-80,-46}}, color={0,127,255}));
  connect(weaDat.weaBus, sou2.weaBus) annotation (Line(
      points={{-120,90},{-50,90},{-50,20.12}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sou1.weaBus) annotation (Line(
      points={{-120,90},{70,90},{70,20.12}},
      color={255,204,51},
      thickness=0.5));
  connect(chiGly.TSet, chiGlyTSet.y) annotation (Line(points={{-77,3},{-77,30},
          {-68,30},{-68,62},{-70.8,62}},color={0,0,127}));
  connect(chiWat.TSet, chiWatTSet.y) annotation (Line(points={{43,3},{43,14},{
          76,14},{76,-86},{61.2,-86}},
                                    color={0,0,127}));
  connect(chiGly.on, chiGlyOn.y) annotation (Line(points={{-71,3},{-71,26},{-62,
          26},{-62,80},{-70.8,80}}, color={255,0,255}));
  connect(chiWat.on, ChiWatOn.y) annotation (Line(points={{49,3},{49,10},{72,10},
          {72,-66},{61.2,-66}}, color={255,0,255}));
  connect(disCooCoi.u, disCooLoad.y)
    annotation (Line(points={{126,12},{126,70},{122.6,70}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-140,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-140,-100},{140,100}})));
end DistrictCoolingIceTank;
