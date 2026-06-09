within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Examples;
model HeatPump "Example showing how to use the motor coupled heat pump model"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water "Water medium";

  parameter Modelica.Units.SI.Power P_nominal=2.5E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COP_nominal=3 "Heat pump COP";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=
     -P_nominal*COP_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=
    m2_flow_nominal*(COP_nominal+1)/COP_nominal
    "Nominal mass flow rate at condenser water side";

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 1"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal,
    T_start=303.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Sources.Step TSet(
    height=10,
    offset=273.15 + 30,
    startTime=200)
    "Condenser side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.HeatPump hea(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    P_nominal=P_nominal,
    Nrpm_nominal=1500,
    etaCarnot_nominal=0.5,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic per,
    loaIne=1,
    k=0.1,
    Ti=10) "Heat pump"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{90,30},{70,50}})));

  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,34},{-80,54}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{94,-16},{74,4}})));

  Modelica.Blocks.Sources.BooleanConstant EquipmentStatus(k=true)
    "true for \"On\", False for \"Off\""
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.HeatPump hea1(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    P_nominal=P_nominal,
    Nrpm_nominal=1500,
    etaCarnot_nominal=0.5,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare InductionMotors.Data.Generic per,
    loaIne=1,
    k=0.1,
    Ti=10) "Heat pump"
    annotation (Placement(transformation(extent={{-10,-84},{10,-64}})));
  Sources.Grid                                             Sou1(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,-54},{10,-34}})));
  Fluid.Sources.MassFlowSource_T           sou3(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{60,-100},{40,-80}})));
  Fluid.Sources.Boundary_pT           sin3(redeclare package Medium = MediumW,
      nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Modelica.Blocks.Sources.BooleanConstant EquipmentStatus1(k=false)
    "true for \"On\", False for \"Off\""
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Fluid.Sources.Boundary_pT           sin4(redeclare package Medium = MediumW,
      nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{66,-50},{46,-30}})));
  Fluid.Sensors.TemperatureTwoPort           senTem1(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal,
    T_start=303.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Fluid.Sources.MassFlowSource_T           sou4(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 1"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
equation
  connect(hea.port_a2, sou2.ports[1]) annotation (Line(points={{10,4},{34,4},{
          34,-10},{40,-10}},         color={0,127,255}));
  connect(sou1.ports[1], hea.port_a1) annotation (Line(points={{-40,40},{-30,40},
          {-30,16},{-10,16}},
                            color={0,127,255}));
  connect(senTem.port_a, hea.port_b1) annotation (Line(points={{40,40},{20,40},
          {20,16},{10,16}},
                          color={0,127,255}));
  connect(Sou.terminal, hea.terminal) annotation (Line(points={{0,30},{0,20}},
          color={0,120,120}));
  connect(TSet.y, hea.TSet) annotation (Line(points={{-79,80},{-20,80},{-20,19},
          {-12,19}},
                   color={0,0,127}));
  connect(senTem.T, hea.TMea) annotation (Line(points={{50,51},{50,56},{-18,56},
          {-18,13},{-12,13}},
                            color={0,0,127}));
  connect(hea.port_b2, sin2.ports[1]) annotation (Line(points={{-10,4},{-30,4},
          {-30,-10},{-40,-10}}, color={0,127,255}));
  connect(senTem.port_b, sin1.ports[1]) annotation (Line(points={{60,40},{70,40}},
          color={0,127,255}));
  connect(TCon_in.y, sou1.T_in)
    annotation (Line(points={{-79,44},{-62,44}}, color={0,0,127}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{73,-6},{62,-6}},   color={0,0,127}));

  connect(EquipmentStatus.y, hea.on) annotation (Line(points={{-79,10},{-20,10},
          {-20,9},{-11,9}},  color={255,0,255}));
  connect(Sou1.terminal, hea1.terminal)
    annotation (Line(points={{0,-54},{0,-64}}, color={0,120,120}));
  connect(hea1.port_a2, sou3.ports[1]) annotation (Line(points={{10,-80},{26,
          -80},{26,-90},{40,-90}}, color={0,127,255}));
  connect(sou3.T_in, TEva_in.y) annotation (Line(points={{62,-86},{68,-86},{68,
          -6},{73,-6}}, color={0,0,127}));
  connect(sin3.ports[1], hea1.port_b2) annotation (Line(points={{-40,-90},{-14,
          -90},{-14,-80},{-10,-80}}, color={0,127,255}));
  connect(EquipmentStatus1.y, hea1.on) annotation (Line(points={{-79,-70},{-22,
          -70},{-22,-75},{-11,-75}}, color={255,0,255}));
  connect(sin4.ports[1], senTem1.port_b)
    annotation (Line(points={{46,-40},{40,-40}}, color={0,127,255}));
  connect(senTem1.port_a, hea1.port_b1)
    annotation (Line(points={{20,-40},{20,-68},{10,-68}}, color={0,127,255}));
  connect(senTem1.T, hea1.TMea) annotation (Line(points={{30,-29},{30,-26},{-16,
          -26},{-16,-71},{-12,-71}}, color={0,0,127}));
  connect(hea1.TSet, TSet.y) annotation (Line(points={{-12,-65},{-20,-65},{-20,
          80},{-79,80}}, color={0,0,127}));
  connect(sou4.T_in, TCon_in.y) annotation (Line(points={{-62,-36},{-70,-36},{
          -70,44},{-79,44}}, color={0,0,127}));
  connect(sou4.ports[1], hea1.port_a1) annotation (Line(points={{-40,-40},{-22,
          -40},{-22,-68},{-10,-68}}, color={0,127,255}));
annotation (experiment(Tolerance=1e-6,StartTime=0,StopTime=350),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/Coupled/Examples/HeatPump.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example simulates a motor coupled heat pump.
</p>
<p>
To ensure that the heat pump energy consumption is in accordance with the manufacture
records, we can compare <code>Sou.P.apparent</code> (energy consumption from the
grid) and <code>hea.P</code> (energy consumption according to manufacture records).
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
end HeatPump;
