within Buildings.Electrical.AC.ThreePhasesBalanced.MotorDrive.Coupled.Examples;
model Chiller "Test model for motor coupled chiller model"
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
    height=10,
    duration=60,
    offset=273.15 + 20,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  MotorDrive.Coupled.Chiller chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    show_T=true,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    P_nominal=P_nominal,
    Nrpm_nominal=1800,
    use_eta_Carnot_nominal=true,
    etaCarnot_nominal=0.3,
    COP_nominal=COP_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    pole=4,
    JMotor=5,
    R_s=0.641,
    R_r=0.332,
    X_s=1.106,
    X_r=0.464,
    X_m=26.3) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Electrical.AC.OnePhase.Sources.Grid Sou(f=60, V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium2,
      m_flow_nominal=m2_flow_nominal)
    annotation (Placement(transformation(extent={{-44,-40},{-24,-20}})));
  Modelica.Blocks.Sources.Step TSet(
    height=0,
    offset=273.15 + 11,
    startTime=500)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Trapezoid TEva_in(
    amplitude=5,
    rising=600,
    width=600,
    falling=600,
    period=2700,
    offset=273.15 + 15,
    startTime=900)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium = Medium2,
      nPorts=1)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium = Medium1,
      nPorts=1) annotation (Placement(transformation(extent={{60,40},{40,60}})));
equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(
      points={{-69,30},{-58,30},{-58,34},{-52,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou1.ports[1], chi.port_a1) annotation (Line(points={{-30,30},{-22,30},
          {-22,6},{-10,6}}, color={0,127,255}));
  connect(sou2.ports[1], chi.port_a2) annotation (Line(points={{40,-10},{16,-10},
          {16,-6},{10,-6}}, color={0,127,255}));
  connect(Sou.terminal, chi.terminal)
    annotation (Line(points={{10,60},{10,10},{0,10}}, color={0,120,120}));
  connect(senTem.port_b, chi.port_b2) annotation (Line(points={{-24,-30},{-16,
          -30},{-16,-6},{-10,-6}}, color={0,127,255}));
  connect(senTem.T, chi.meaPoi)
    annotation (Line(points={{-34,-19},{-34,3},{-11,3}}, color={0,0,127}));
  connect(TSet.y, chi.setPoi)
    annotation (Line(points={{-39,70},{-11,70},{-11,9}}, color={0,0,127}));
  connect(TEva_in.y, sou2.T_in) annotation (Line(points={{61,-50},{82,-50},{82,
          -6},{62,-6}}, color={0,0,127}));
  connect(senTem.port_a, sin2.ports[1])
    annotation (Line(points={{-44,-30},{-60,-30}}, color={0,127,255}));
  connect(chi.port_b1, sin1.ports[1]) annotation (Line(points={{10,6},{34,6},{
          34,50},{40,50}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/MotorDrive/Coupled/Examples/Chiller.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Example that simulates a motor coupled chiller to track the set point signal as the evaporator entering temperate changes.</p>
</html>",
revisions="<html>
<ul>
<li>October 15, 2021, by Mingzhe Liu:<br>First implementation. </li>
</ul>
</html>"));
end Chiller;
