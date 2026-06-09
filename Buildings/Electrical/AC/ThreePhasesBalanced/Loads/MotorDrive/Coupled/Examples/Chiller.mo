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
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Buildings.Media.Water,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium =Buildings.Media.Water,
    m_flow_nominal=m2_flow_nominal,
    T_start(displayUnit="K") = 280.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  Modelica.Blocks.Sources.Step TSet(
    height=-2,
    offset=273.15 + 7,
    startTime=300) "Evaporator side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Buildings.Media.Water,
    nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Buildings.Media.Water, nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{80,-4},{60,16}})));

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
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-80,14},{-60,34}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaSta(
    width=0.75,
    period=600)
    "True for enabled device"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(Sou.terminal, chi.terminal)
    annotation (Line(points={{30,50},{30,10}},
                                            color={0,120,120}));
  connect(TCon_in.y, sou1.T_in)
    annotation (Line(points={{-59,24},{-42,24}}, color={0,0,127}));
  connect(chi.port_a1, sou1.ports[1]) annotation (Line(points={{20,6},{-10,6},{-10,
          20},{-20,20}},      color={0,127,255}));
  connect(senTem.port_a, chi.port_b2) annotation (Line(points={{-20,-60},{0,-60},
          {0,-6},{20,-6}},           color={0,127,255}));
  connect(senTem.port_b, sin2.ports[1])
    annotation (Line(points={{-40,-60},{-60,-60}}, color={0,127,255}));
  connect(chi.port_a2, sou2.ports[1]) annotation (Line(points={{40,-6},{50,-6},{
          50,-40},{60,-40}},  color={0,127,255}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{40,6},{60,6}},
                            color={0,127,255}));
  connect(TSet.y, chi.TSet) annotation (Line(points={{-59,60},{0,60},{0,9},{18,9}},
                     color={0,0,127}));
  connect(senTem.T, chi.TMea)
    annotation (Line(points={{-30,-49},{-30,3},{18,3}},    color={0,0,127}));
  connect(enaSta.y, chi.on) annotation (Line(points={{-58,-20},{-10,-20},{-10,-1},
          {18,-1}}, color={255,0,255}));
  connect(TEva_in.y, sou2.T_in) annotation (Line(points={{61,-70},{90,-70},{90,-36},
          {82,-36}}, color={0,0,127}));
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
