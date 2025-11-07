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
  parameter Real COP_nominal=3 "Chiller COP";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=
     -P_nominal*COP_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=
    m2_flow_nominal*(COP_nominal+1)/COP_nominal
    "Nominal mass flow rate at condenser water wide";

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 1"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal,
    T_start=303.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Sources.Step TSet(
    height=10,
    offset=273.15 + 30,
    startTime=200)
    "Condenser side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
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
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{90,20},{70,40}})));

  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-94,24},{-74,44}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{94,-26},{74,-6}})));

equation
  connect(hea.port_a2, sou2.ports[1]) annotation (Line(points={{10,-6},{10,-6},{
          34,-6},{34,-20},{40,-20}}, color={0,127,255}));
  connect(sou1.ports[1], hea.port_a1) annotation (Line(points={{-40,30},{-30,30},
          {-30,6},{-10,6}}, color={0,127,255}));
  connect(senTem.port_a, hea.port_b1) annotation (Line(points={{40,30},{20,30},{
          20,6},{10,6}},  color={0,127,255}));
  connect(Sou.terminal, hea.terminal) annotation (Line(points={{0,40},{0,10}},
          color={0,120,120}));
  connect(TSet.y, hea.TSet) annotation (Line(points={{-39,70},{-24,70},{-24,9},{
          -12,9}}, color={0,0,127}));
  connect(senTem.T, hea.TMea) annotation (Line(points={{50,41},{50,96},{-18,96},
          {-18,3},{-12,3}}, color={0,0,127}));
  connect(hea.port_b2, sin2.ports[1]) annotation (Line(points={{-10,-6},{-30,-6},
          {-30,-20},{-40,-20}}, color={0,127,255}));
  connect(senTem.port_b, sin1.ports[1]) annotation (Line(points={{60,30},{70,30}},
          color={0,127,255}));
  connect(TCon_in.y, sou1.T_in)
    annotation (Line(points={{-73,34},{-62,34}}, color={0,0,127}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{73,-16},{62,-16}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6,StartTime=0,StopTime=350),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/Coupled/Examples/HeatPump.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example sinmulates a motor coupled heat pump.
</p>
<p>
To ensure that the heat pump energy consumption is in accordance with the manufacture records, we can compare <code>Sou.P.apparent</code> (energy consumption from the grid) and <code>hea.P</code> (energy consumption according to manufacture records).
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
Debug and updated the model
</li>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation. 
</li>
</ul>
</html>"));
end HeatPump;
