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
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{48,8},{28,28}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal,
    T_start=303.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{30,48},{50,68}})));
  Modelica.Blocks.Sources.Step TSet(
    height=10,
    offset=273.15 + 30,
    startTime=200)
    "Condenser side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
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
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-50,8},{-30,28}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumW,
    nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{80,48},{60,68}})));

  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,48},{-80,68}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));

  Modelica.Blocks.Sources.BooleanConstant EquipmentStatus(k=true)
    "true for \"On\", False for \"Off\""
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
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
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
  Sources.Grid                                             Sou1(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Fluid.Sources.MassFlowSource_T           sou3(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{46,-78},{26,-58}})));
  Modelica.Blocks.Sources.Ramp TEva_in1(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-74},{80,-54}})));
  Fluid.Sensors.TemperatureTwoPort           senTem1(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal,
    T_start=303.15)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{28,-48},{48,-28}})));
  Fluid.Sources.Boundary_pT           sin3(redeclare package Medium = MediumW,
      nPorts=1)
    "Water sink 1"
    annotation (Placement(transformation(extent={{82,-48},{62,-28}})));
  Modelica.Blocks.Sources.BooleanConstant EquipmentStatus1(k=false)
    "true for \"On\", False for \"Off\""
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Fluid.Sources.Boundary_pT           sin4(redeclare package Medium = MediumW,
      nPorts=1)
    "Water sink 2"
    annotation (Placement(transformation(extent={{-42,-78},{-22,-58}})));
  Fluid.Sources.MassFlowSource_T           sou4(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 1"
    annotation (Placement(transformation(extent={{-60,-48},{-40,-28}})));
  Modelica.Blocks.Sources.Ramp TCon_in1(
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,-58},{-80,-38}})));
  Modelica.Blocks.Sources.Step TSet1(
    height=10,
    offset=273.15 + 30,
    startTime=200)
    "Condenser side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-100,-28},{-80,-8}})));
equation
  connect(hea.port_a2, sou2.ports[1]) annotation (Line(points={{10,46},{20,46},
          {20,18},{28,18}},          color={0,127,255}));
  connect(sou1.ports[1], hea.port_a1) annotation (Line(points={{-40,60},{-26,60},
          {-26,58},{-10,58}},
                            color={0,127,255}));
  connect(senTem.port_a, hea.port_b1) annotation (Line(points={{30,58},{10,58}},
                          color={0,127,255}));
  connect(Sou.terminal, hea.terminal) annotation (Line(points={{0,70},{0,62}},
          color={0,120,120}));
  connect(TSet.y, hea.TSet) annotation (Line(points={{-79,88},{-20,88},{-20,61},
          {-12,61}},
                   color={0,0,127}));
  connect(senTem.T, hea.TMea) annotation (Line(points={{40,69},{40,92},{-18,92},
          {-18,55},{-12,55}},
                            color={0,0,127}));
  connect(hea.port_b2, sin2.ports[1]) annotation (Line(points={{-10,46},{-20,46},
          {-20,18},{-30,18}},   color={0,127,255}));
  connect(senTem.port_b, sin1.ports[1]) annotation (Line(points={{50,58},{60,58}},
          color={0,127,255}));
  connect(TCon_in.y, sou1.T_in)
    annotation (Line(points={{-79,58},{-70,58},{-70,64},{-62,64}},
                                                 color={0,0,127}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{79,20},{64,20},{64,22},{50,22}},
                                                 color={0,0,127}));

  connect(EquipmentStatus.y, hea.on) annotation (Line(points={{-79,28},{-60,28},
          {-60,51},{-11,51}},color={255,0,255}));
  connect(Sou1.terminal, hea1.terminal)
    annotation (Line(points={{0,-30},{0,-38}}, color={0,120,120}));
  connect(sou3.ports[1], hea1.port_a2) annotation (Line(points={{26,-68},{20,
          -68},{20,-54},{10,-54}}, color={0,127,255}));
  connect(sou3.T_in, TEva_in1.y)
    annotation (Line(points={{48,-64},{79,-64}}, color={0,0,127}));
  connect(senTem1.port_a, hea1.port_b1) annotation (Line(points={{28,-38},{20,
          -38},{20,-42},{10,-42}}, color={0,127,255}));
  connect(senTem1.port_b, sin3.ports[1])
    annotation (Line(points={{48,-38},{62,-38}}, color={0,127,255}));
  connect(senTem1.T, hea1.TMea) annotation (Line(points={{38,-27},{38,-2},{-22,
          -2},{-22,-45},{-12,-45}}, color={0,0,127}));
  connect(EquipmentStatus1.y, hea1.on) annotation (Line(points={{-79,-80},{-60,
          -80},{-60,-49},{-11,-49}}, color={255,0,255}));
  connect(sin4.ports[1], hea1.port_b2) annotation (Line(points={{-22,-68},{-16,
          -68},{-16,-54},{-10,-54}}, color={0,127,255}));
  connect(sou4.ports[1], hea1.port_a1) annotation (Line(points={{-40,-38},{-20,
          -38},{-20,-42},{-10,-42}}, color={0,127,255}));
  connect(TCon_in1.y, sou4.T_in) annotation (Line(points={{-79,-48},{-70,-48},{
          -70,-34},{-62,-34}}, color={0,0,127}));
  connect(TSet1.y, hea1.TSet) annotation (Line(points={{-79,-18},{-20,-18},{-20,
          -39},{-12,-39}}, color={0,0,127}));
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
