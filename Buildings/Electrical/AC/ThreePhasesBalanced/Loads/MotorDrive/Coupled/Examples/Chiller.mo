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
    annotation (Placement(transformation(extent={{-60,48},{-40,68}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Buildings.Media.Water,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{48,0},{28,20}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium =Buildings.Media.Water,
    m_flow_nominal=m2_flow_nominal,
    T_start(displayUnit="K") = 280.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,0},{-40,20}})));
  Modelica.Blocks.Sources.Step TSet(
    height=-2,
    offset=273.15 + 7,
    startTime=300) "Evaporator side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Buildings.Media.Water,
    nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Buildings.Media.Water, nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{60,46},{40,66}})));

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
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,52},{-80,72}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,0},{80,20}})));
  Modelica.Blocks.Sources.BooleanConstant EquipmentStatus(k=true)
    "true for \"On\", False for \"Off\""
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Sources.Grid                                             Sou1(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
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
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
  Fluid.Sources.MassFlowSource_T           sou3(
    redeclare package Medium = Media.Water,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{48,-98},{28,-78}})));
  Fluid.Sources.Boundary_pT           sin3(redeclare package Medium =
        Media.Water, nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{62,-50},{42,-30}})));
  Fluid.Sources.Boundary_pT           sin4(redeclare package Medium =
        Media.Water, nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));
  Fluid.Sensors.TemperatureTwoPort           senTem1(
    redeclare package Medium = Media.Water,
    m_flow_nominal=m2_flow_nominal,
    T_start(displayUnit="K") = 280.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,-100},{-40,-80}})));
  Modelica.Blocks.Sources.BooleanConstant EquipmentStatus1(k=false)
    "true for \"On\", False for \"Off\""
    annotation (Placement(transformation(extent={{-100,-82},{-80,-62}})));
  Fluid.Sources.MassFlowSource_T           sou4(
    redeclare package Medium = Media.Water,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 1"
    annotation (Placement(transformation(extent={{-52,-50},{-32,-30}})));
  Modelica.Blocks.Sources.Ramp TCon_in1(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Sources.Ramp TEva_in1(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-100},{80,-80}})));
  Modelica.Blocks.Sources.Step TSet1(
    height=-2,
    offset=273.15 + 7,
    startTime=300) "Evaporator side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(Sou.terminal, chi.terminal)
    annotation (Line(points={{0,70},{0,60}},color={0,120,120}));
  connect(TCon_in.y, sou1.T_in)
    annotation (Line(points={{-79,62},{-62,62}}, color={0,0,127}));
  connect(chi.port_a1, sou1.ports[1]) annotation (Line(points={{-10,56},{-30,56},
          {-30,58},{-40,58}}, color={0,127,255}));
  connect(senTem.port_a, chi.port_b2) annotation (Line(points={{-20,10},{-14,10},
          {-14,44},{-10,44}},        color={0,127,255}));
  connect(senTem.port_b, sin2.ports[1])
    annotation (Line(points={{-40,10},{-50,10}},   color={0,127,255}));
  connect(chi.port_a2, sou2.ports[1]) annotation (Line(points={{10,44},{10,10},
          {28,10}},           color={0,127,255}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{10,56},{40,56}},
                            color={0,127,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{79,10},{60,10},{60,14},{50,14}},
                                                 color={0,0,127}));
  connect(TSet.y, chi.TSet) annotation (Line(points={{-79,90},{-20,90},{-20,59},
          {-12,59}}, color={0,0,127}));
  connect(senTem.T, chi.TMea)
    annotation (Line(points={{-30,21},{-30,53},{-12,53}},  color={0,0,127}));
  connect(EquipmentStatus.y, chi.on) annotation (Line(points={{-79,30},{-32,30},
          {-32,49},{-11,49}},  color={255,0,255}));
  connect(Sou1.terminal, chi1.terminal)
    annotation (Line(points={{0,-30},{0,-38}}, color={0,120,120}));
  connect(chi1.port_a2, sou3.ports[1]) annotation (Line(points={{10,-54},{22,
          -54},{22,-88},{28,-88}}, color={0,127,255}));
  connect(chi1.port_b1, sin3.ports[1]) annotation (Line(points={{10,-42},{38,
          -42},{38,-40},{42,-40}}, color={0,127,255}));
  connect(senTem1.port_b, sin4.ports[1])
    annotation (Line(points={{-40,-90},{-50,-90}}, color={0,127,255}));
  connect(senTem1.port_a, chi1.port_b2) annotation (Line(points={{-20,-90},{-16,
          -90},{-16,-54},{-10,-54}}, color={0,127,255}));
  connect(EquipmentStatus1.y, chi1.on) annotation (Line(points={{-79,-72},{-60,
          -72},{-60,-49},{-11,-49}}, color={255,0,255}));
  connect(senTem1.T, chi1.TMea)
    annotation (Line(points={{-30,-79},{-30,-45},{-12,-45}}, color={0,0,127}));
  connect(sou4.ports[1], chi1.port_a1) annotation (Line(points={{-32,-40},{-22,
          -40},{-22,-42},{-10,-42}}, color={0,127,255}));
  connect(TEva_in1.y, sou3.T_in) annotation (Line(points={{79,-90},{60,-90},{60,
          -84},{50,-84}}, color={0,0,127}));
  connect(TCon_in1.y, sou4.T_in) annotation (Line(points={{-79,-40},{-66,-40},{
          -66,-36},{-54,-36}}, color={0,0,127}));
  connect(TSet1.y, chi1.TSet) annotation (Line(points={{-79,-10},{-20,-10},{-20,
          -39},{-12,-39}}, color={0,0,127}));
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
