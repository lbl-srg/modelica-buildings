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
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,24},{-70,44}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Buildings.Media.Water,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1) "Water source 2"
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid Sou(f=60, V=480)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water,
      m_flow_nominal=m2_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.Step TSet(
    height=0,
    offset=273.15 + 11,
    startTime=500) "Evaporator side leaving water temperature set point"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Trapezoid TEva_in(
    amplitude=5,
    rising=600,
    width=600,
    falling=600,
    period=2700,
    offset=273.15 + 15,
    startTime=900) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium =
        Buildings.Media.Water,
      nPorts=1) "Water sink 2" annotation (Placement(transformation(
      extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
                "Water sink 1" annotation (Placement(transformation(
      extent={{60,20},{40,40}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Chiller
    chi(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Water,
    P_nominal=P_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    etaCarnot_nominal=0.5)
    annotation (Placement(transformation(extent={{-6,-12},{14,8}})));
equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(points={{-69,34},{-62,34}},
                              color={0,0,127}, smooth=Smooth.None));
  connect(TEva_in.y, sou2.T_in) annotation (Line(points={{61,-50},{80,-50},{80,
          -2},{62,-2}},     color={0,0,127}));
  connect(senTem.port_a, sin2.ports[1]) annotation (Line(points={{-40,-30},
          {-60,-30}}, color={0,127,255}));
  connect(senTem.port_b, chi.port_b2) annotation (Line(points={{-20,-30},{-12,
          -30},{-12,-9.77778},{-6,-9.77778}},
                                  color={0,127,255}));
  connect(senTem.T, chi.meaPoi)
    annotation (Line(points={{-30,-19},{-30,0.222222},{-7,0.222222}},
                                                        color={0,0,127}));
  connect(sou1.ports[1], chi.port_a1) annotation (Line(points={{-40,30},{-12,30},
          {-12,3.55556},{-6,3.55556}},
                           color={0,127,255}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{14,3.55556},{32,
          3.55556},{32,30},{40,30}},
                           color={0,127,255}));
  connect(chi.port_a2, sou2.ports[1]) annotation (Line(points={{14,-9.77778},{
          16,-9.77778},{16,-6},{40,-6}},
                            color={0,127,255}));
  connect(TSet.y, chi.setPoi)
    annotation (Line(points={{-39,70},{-7,70},{-7,6.88889}},
                                                       color={0,0,127}));
  connect(Sou.terminal, chi.terminal)
    annotation (Line(points={{10,60},{8,60},{8,8},{4,8}}, color={0,120,120}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
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
October 15, 2021, by Mingzhe Liu:<br/>
First implementation. 
</li>
</ul>
</html>"));
end Chiller;
