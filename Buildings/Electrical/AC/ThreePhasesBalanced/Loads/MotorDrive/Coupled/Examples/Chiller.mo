within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Examples;
model Chiller "This example shows how to use the motor coupled chiller model"
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
    redeclare package Medium = Buildings.Media.Water,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 1"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=0,
    duration=0,
    offset=273.15 + 10,
    startTime=0)  "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,24},{-70,44}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Buildings.Media.Water,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=298.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{54,-30},{34,-10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{-10,22},{10,42}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water,
      m_flow_nominal=m2_flow_nominal,
    T_start(displayUnit="K") = 280.15)
                                      "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Step TSet(
    height=-2,
    offset=273.15 + 7,
    startTime=300) "Evaporator side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
                "Water sink 2" annotation (Placement(transformation(
      extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
                "Water sink 1" annotation (Placement(transformation(
      extent={{60,0},{40,20}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Chiller
    chi(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Water,
    P_nominal=P_nominal,
    Nrpm_nominal=1500,
    dp1_nominal=1000,
    dp2_nominal=1000,
    etaCarnot_nominal=0.5,
    redeclare
      Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic
      per,
    k=0.001,
    Ti=0.65)
    annotation (Placement(transformation(extent={{-10,-14},{10,6}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=0,
    duration=0,
    offset=273.15 + 15,
    startTime=600) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{94,-26},{74,-6}})));
equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(points={{-69,34},{-62,34}},
                              color={0,0,127}, smooth=Smooth.None));
  connect(senTem.T, chi.meaPoi)
    annotation (Line(points={{-30,-19},{-30,-1.77778},{-11,-1.77778}},
                                                        color={0,0,127}));
  connect(sou1.ports[1], chi.port_a1) annotation (Line(points={{-40,30},{-34,30},
          {-34,1.55556},{-10,1.55556}},
                           color={0,127,255}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{10,1.55556},{10,
          0},{34,0},{34,10},{40,10}},
                           color={0,127,255}));
  connect(chi.port_a2, sou2.ports[1]) annotation (Line(points={{10,-11.7778},{
          10,-12},{20,-12},{20,-20},{34,-20}},
                            color={0,127,255}));
  connect(TSet.y, chi.setPoi)
    annotation (Line(points={{-69,70},{-18,70},{-18,6},{-11,6},{-11,4.88889}},
                                                       color={0,0,127}));
  connect(Sou.terminal, chi.terminal)
    annotation (Line(points={{0,22},{0,6}},               color={0,120,120}));
  connect(sou2.T_in, TEva_in.y)
    annotation (Line(points={{56,-16},{73,-16}},
                                               color={0,0,127}));
  connect(senTem.port_a, chi.port_b2) annotation (Line(points={{-20,-30},{-10,
          -30},{-10,-11.7778}},               color={0,127,255}));
  connect(senTem.port_b, sin2.ports[1])
    annotation (Line(points={{-40,-30},{-60,-30}}, color={0,127,255}));
  annotation (experiment(
      StopTime=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/Coupled/Examples/Chiller.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates a motor coupled chiller to track the set point signal 
as the evaporator entering temperate changes.
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
end Chiller;
