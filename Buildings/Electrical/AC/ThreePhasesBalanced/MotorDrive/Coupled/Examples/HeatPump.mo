within Buildings.Electrical.AC.ThreePhasesBalanced.MotorDrive.Coupled.Examples;
model HeatPump "Test model for motor coupled heat pump model"
 extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.Power P_nominal=10E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=-10
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COP_nominal = 3 "Chiller COP";

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=
     -P_nominal*COP_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=
    m2_flow_nominal*(COP_nominal+1)/COP_nominal
    "Nominal mass flow rate at condenser water wide";

  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=0,
    duration=60,
    offset=273.15 + 15,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Buildings.Electrical.AC.OnePhase.Sources.Grid Sou(f=60, V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium2,
      m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{26,30},{46,50}})));
  Modelica.Blocks.Sources.Step TSet(
    height=5,
    offset=273.15 + 20,
    startTime=500)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  MotorDrive.Coupled.HeatPump hea(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    P_nominal=P_nominal,
    Nrpm_nominal=1800,
    etaCarnot_nominal=0.5,
    dp1_nominal=1000,
    dp2_nominal=1000,
    f_base=60,
    pole=4,
    JMotor=5,
    R_s=0.641,
    R_r=0.332,
    X_s=1.106,
    X_r=0.464,
    X_m=26.3,
    JLoad=5) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=0,
    duration=60,
    offset=273.15 + 10,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{96,-50},{76,-30}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium = Medium2,
      nPorts=1)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium = Medium1,
      nPorts=1) annotation (Placement(transformation(extent={{80,60},{60,80}})));
equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(
      points={{-69,30},{-58,30},{-58,34},{-52,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea.port_a2, sou2.ports[1]) annotation (Line(points={{10,-6},{26,-6},
          {26,-10},{40,-10}}, color={0,127,255}));
  connect(sou1.ports[1], hea.port_a1) annotation (Line(points={{-30,30},{-20,30},
          {-20,6},{-10,6}}, color={0,127,255}));
  connect(senTem.port_a, hea.port_b1) annotation (Line(points={{26,40},{18,40},
          {18,6},{10,6}}, color={0,127,255}));
  connect(Sou.terminal, hea.terminal) annotation (Line(points={{10,70},{10,32},
          {0,32},{0,10}}, color={0,120,120}));
  connect(TSet.y, hea.setPoi) annotation (Line(points={{-39,70},{-24,70},{-24,9},
          {-11,9}}, color={0,0,127}));
  connect(senTem.T, hea.meaPoi) annotation (Line(points={{36,51},{36,60},{-16,
          60},{-16,3},{-11,3}}, color={0,0,127}));
  connect(sou2.T_in, TEva_in.y) annotation (Line(points={{62,-6},{70,-6},{
        70,-40},{75,-40}},color={0,0,127}));
  connect(hea.port_b2, sin2.ports[1]) annotation (Line(points={{-10,-6},{-26,-6},
          {-26,-30},{-40,-30}}, color={0,127,255}));
  connect(senTem.port_b, sin1.ports[1]) annotation (Line(points={{46,40},{54,40},
          {54,70},{60,70}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://MotorDrive/Resources/Scripts/Dymola/Coupled/Examples/HeatPump.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Example that simulates a motor coupled heat pump to track the set point signal as the condenser entering temperate changes. </p>
</html>",
revisions="<html>
<ul>
<li>October 15, 2021, by Mingzhe Liu:<br>First implementation. </li>
</ul>
</html>"));
end HeatPump;
