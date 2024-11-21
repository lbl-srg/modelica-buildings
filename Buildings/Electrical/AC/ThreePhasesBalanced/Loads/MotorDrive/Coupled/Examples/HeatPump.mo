within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Examples;
model HeatPump "This example shows how to use the motor coupled heat pump model"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.Power P_nominal=10E3
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
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=0,
    duration=60,
    offset=273.15 + 20,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,24},{-70,44}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumW,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Modelica.Blocks.Sources.Step TSet(
    height=5,
    offset=273.15 + 20,
    startTime=500) "Condenser side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.HeatPump hea(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    P_nominal=P_nominal,
    Nrpm_nominal=1800,
    etaCarnot_nominal=0.5,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      per) "Heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=0,
    duration=60,
    offset=273.15 + 10,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{90,-16},{70,4}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium = MediumW,
    nPorts=1) "Water sink 2"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium = MediumW,
    nPorts=1) "Water sink 1"
    annotation (Placement(transformation(extent={{90,20},{70,40}})));

equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(points={{-69,34},{-62,34}},
                              color={0,0,127}, smooth=Smooth.None));
  connect(hea.port_a2, sou2.ports[1]) annotation (Line(points={{10,-7.77778},{
          20,-7.77778},{20,-10},{40,-10}},
                              color={0,127,255}));
  connect(sou1.ports[1], hea.port_a1) annotation (Line(points={{-40,30},{-30,30},
          {-30,5.55556},{-10,5.55556}},
                            color={0,127,255}));
  connect(senTem.port_a, hea.port_b1) annotation (Line(points={{40,30},{20,30},
          {20,5.55556},{10,5.55556}},
                          color={0,127,255}));
  connect(Sou.terminal, hea.terminal) annotation (Line(points={{10,60},{10,32},
          {0,32},{0,10}}, color={0,120,120}));
  connect(TSet.y, hea.setPoi) annotation (Line(points={{-39,70},{-24,70},{-24,
          8.88889},{-11,8.88889}},
                    color={0,0,127}));
  connect(senTem.T, hea.meaPoi) annotation (Line(points={{50,41},{50,96},{-18,
          96},{-18,2.22222},{-11,2.22222}},
                                     color={0,0,127}));
  connect(sou2.T_in, TEva_in.y) annotation (Line(points={{62,-6},{69,-6}},
                              color={0,0,127}));
  connect(hea.port_b2, sin2.ports[1]) annotation (Line(points={{-10,-7.77778},{
          -30,-7.77778},{-30,-30},{-40,-30}},
                                color={0,127,255}));
  connect(senTem.port_b, sin1.ports[1]) annotation (Line(points={{60,30},{70,30}},
                            color={0,127,255}));
  annotation (experiment(
      StartTime=450,
      StopTime=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/Coupled/Examples/HeatPump.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates a motor coupled heat pump to track the set point signal 
as the condenser entering temperate changes. 
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
