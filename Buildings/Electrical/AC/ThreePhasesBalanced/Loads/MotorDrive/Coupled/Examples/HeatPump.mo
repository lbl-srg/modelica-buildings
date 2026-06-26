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
    annotation (Placement(transformation(extent={{-48,-4},{-28,16}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal,
    T_start=303.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{30,-4},{50,16}})));
  Modelica.Blocks.Sources.Step TSet(
    height=10,
    offset=273.15 + 30,
    startTime=200)
    "Condenser side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.HeatPump
    heaPum(
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
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{80,-4},{60,16}})));

  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaSta(
    width=0.75, period=400)
    "True for enabled device"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

equation
  connect(heaPum.port_a2, sou2.ports[1]) annotation (Line(points={{20,-6},{30,-6},
          {30,-40},{60,-40}}, color={0,127,255}));
  connect(sou1.ports[1], heaPum.port_a1)
    annotation (Line(points={{-28,6},{0,6}}, color={0,127,255}));
  connect(senTem.port_a, heaPum.port_b1)
    annotation (Line(points={{30,6},{20,6}}, color={0,127,255}));
  connect(Sou.terminal, heaPum.terminal)
    annotation (Line(points={{10,30},{10,10}}, color={0,120,120}));
  connect(TSet.y, heaPum.TSet) annotation (Line(points={{-59,60},{-20,60},{-20,9},
          {-2,9}}, color={0,0,127}));
  connect(senTem.T, heaPum.TMea) annotation (Line(points={{40,17},{40,60},{-10,60},
          {-10,3},{-2,3}}, color={0,0,127}));
  connect(heaPum.port_b2, sin2.ports[1]) annotation (Line(points={{0,-6},{-10,-6},
          {-10,-70},{-40,-70}}, color={0,127,255}));
  connect(senTem.port_b, sin1.ports[1]) annotation (Line(points={{50,6},{60,6}},
          color={0,127,255}));
  connect(TCon_in.y, sou1.T_in)
    annotation (Line(points={{-59,10},{-50,10}}, color={0,0,127}));
  connect(enaSta.y, heaPum.on) annotation (Line(points={{-58,-30},{-20,-30},{
          -20,-2},{-2,-2}},
                        color={255,0,255}));
  connect(TEva_in.y, sou2.T_in) annotation (Line(points={{61,-70},{90,-70},{90,-36},
          {82,-36}}, color={0,0,127}));
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
