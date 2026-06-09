within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Examples;
model Chiller "Example showing how to use the motor coupled chiller model"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water "Water medium";

  parameter Modelica.Units.SI.Power P_nominal=2.5E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COP_nominal=3 "Chiller COP";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=
     -P_nominal*COP_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=
    m2_flow_nominal*(COP_nominal+1)/COP_nominal
    "Nominal mass flow rate at condenser water side";

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Buildings.Media.Water,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 1"
    annotation (Placement(transformation(extent={{-60,54},{-40,74}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Buildings.Media.Water,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{48,-10},{28,10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium =Buildings.Media.Water,
    m_flow_nominal=m2_flow_nominal,
    T_start(displayUnit="K") = 280.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-14,-10},{-34,10}})));
  Modelica.Blocks.Sources.Step TSet(
    height=-2,
    offset=273.15 + 7,
    startTime=300) "Evaporator side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-42,80},{-22,100}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Buildings.Media.Water,
    nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Buildings.Media.Water, nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{50,30},{30,50}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Chiller chi(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Water,
    P_nominal=P_nominal,
    Nrpm_nominal=1500,
    dp1_nominal=1000,
    dp2_nominal=1000,
    etaCarnot_nominal=0.5,
    loaIne=1,
    redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per,
    k=0.1,
    Ti=5)
    "Chiller with motor interface"
    annotation (Placement(transformation(extent={{-10,4},{10,24}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,58},{-80,78}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-6},{80,14}})));
  Modelica.Blocks.Sources.BooleanConstant EquipmentStatus(k=true)
    "true for \"On\", False for \"Off\""
    annotation (Placement(transformation(extent={{-60,24},{-40,44}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Chiller chi1(
    redeclare package Medium1 = Media.Water,
    redeclare package Medium2 = Media.Water,
    P_nominal=P_nominal,
    Nrpm_nominal=1500,
    dp1_nominal=1000,
    dp2_nominal=1000,
    etaCarnot_nominal=0.5,
    loaIne=1,
    redeclare InductionMotors.Data.Generic per,
    k=0.1,
    Ti=5)
    "Chiller with motor interface"
    annotation (Placement(transformation(extent={{-10,-76},{10,-56}})));
  Fluid.Sources.MassFlowSource_T           sou3(
    redeclare package Medium = Media.Water,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{46,-90},{26,-70}})));
  Fluid.Sources.Boundary_pT           sin3(redeclare package Medium =
        Media.Water, nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{46,-50},{26,-30}})));
  Fluid.Sensors.TemperatureTwoPort           senTem1(
    redeclare package Medium = Media.Water,
    m_flow_nominal=m2_flow_nominal,
    T_start(displayUnit="K") = 280.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-14,-90},{-34,-70}})));
  Fluid.Sources.Boundary_pT           sin4(redeclare package Medium =
        Media.Water, nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Fluid.Sources.MassFlowSource_T           sou4(
    redeclare package Medium = Media.Water,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 1"
    annotation (Placement(transformation(extent={{-62,-50},{-42,-30}})));
  Modelica.Blocks.Sources.BooleanConstant EquipmentStatus1(k=false)
    "true for \"On\", False for \"Off\""
    annotation (Placement(transformation(extent={{-94,-70},{-74,-50}})));
  Sources.Grid                                             Sou1(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,-38},{10,-18}})));
equation
  connect(Sou.terminal, chi.terminal)
    annotation (Line(points={{0,70},{0,24}},color={0,120,120}));
  connect(TCon_in.y, sou1.T_in)
    annotation (Line(points={{-79,68},{-62,68}}, color={0,0,127}));
  connect(chi.port_a1, sou1.ports[1]) annotation (Line(points={{-10,20},{-30,20},
          {-30,64},{-40,64}}, color={0,127,255}));
  connect(senTem.port_a, chi.port_b2) annotation (Line(points={{-14,0},{-14,8},
          {-10,8}},                  color={0,127,255}));
  connect(senTem.port_b, sin2.ports[1])
    annotation (Line(points={{-34,0},{-42,0}},     color={0,127,255}));
  connect(chi.port_a2, sou2.ports[1]) annotation (Line(points={{10,8},{20,8},{
          20,0},{28,0}},      color={0,127,255}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{10,20},{20,20},
          {20,40},{30,40}}, color={0,127,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{79,4},{50,4}},     color={0,0,127}));
  connect(TSet.y, chi.TSet) annotation (Line(points={{-21,90},{-20,90},{-20,23},
          {-12,23}}, color={0,0,127}));
  connect(senTem.T, chi.TMea)
    annotation (Line(points={{-24,11},{-24,17},{-12,17}},  color={0,0,127}));
  connect(EquipmentStatus.y, chi.on) annotation (Line(points={{-39,34},{-32,34},
          {-32,13},{-11,13}},  color={255,0,255}));
  connect(sou3.T_in, TEva_in.y) annotation (Line(points={{48,-76},{60,-76},{60,
          4},{79,4}}, color={0,0,127}));
  connect(sou3.ports[1], chi1.port_a2) annotation (Line(points={{26,-80},{20,
          -80},{20,-72},{10,-72}}, color={0,127,255}));
  connect(sin3.ports[1], chi1.port_b1) annotation (Line(points={{26,-40},{20,
          -40},{20,-60},{10,-60}}, color={0,127,255}));
  connect(senTem1.port_a, chi1.port_b2) annotation (Line(points={{-14,-80},{-14,
          -72},{-10,-72}}, color={0,127,255}));
  connect(sin4.ports[1], senTem1.port_b)
    annotation (Line(points={{-40,-80},{-34,-80}}, color={0,127,255}));
  connect(sou4.ports[1], chi1.port_a1) annotation (Line(points={{-42,-40},{-22,
          -40},{-22,-60},{-10,-60}}, color={0,127,255}));
  connect(chi1.TSet, TSet.y) annotation (Line(points={{-12,-57},{-20,-57},{-20,
          90},{-21,90}}, color={0,0,127}));
  connect(sou4.T_in, TCon_in.y) annotation (Line(points={{-64,-36},{-72,-36},{
          -72,68},{-79,68}}, color={0,0,127}));
  connect(EquipmentStatus1.y, chi1.on) annotation (Line(points={{-73,-60},{-40,
          -60},{-40,-66},{-11,-66},{-11,-67}}, color={255,0,255}));
  connect(chi1.TMea, senTem1.T) annotation (Line(points={{-12,-63},{-12,-64},{
          -24,-64},{-24,-69}}, color={0,0,127}));
  connect(Sou1.terminal, chi1.terminal)
    annotation (Line(points={{0,-38},{0,-56}}, color={0,120,120}));
  annotation (experiment(Tolerance=1e-6,StartTime=0,StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/Coupled/Examples/Chiller.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example simulates a motor coupled chiller.
</p>
<p>
To ensure that the chiller energy consumption is in accordance with the manufacture
records, we can compare <code>Sou.P.apparent</code> (energy consumption from
the grid) and <code>chi.P</code> (energy consumption according to
manufacture records).
</p>
</html>", revisions="<html>
<ul>
<li>
June 05, 2026, by Viswanathan Ganesh:<br/>
Updated example to have boolean feature.
</li>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
Debug and updated the model.
</li>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation. 
</li>
</ul>
</html>"));
end Chiller;
