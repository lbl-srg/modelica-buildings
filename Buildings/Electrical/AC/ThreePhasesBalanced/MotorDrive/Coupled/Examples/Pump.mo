within Buildings.Electrical.AC.ThreePhasesBalanced.MotorDrive.Coupled.Examples;
model Pump
  "Test model for motor coupled pump model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 0.06*1000;
  parameter Modelica.Units.SI.Pressure dp_nominal = 25*188.5/(m_flow_nominal/1000);
  parameter Modelica.Units.SI.Inertia JLoad=5 "Moment of inertia";
  parameter Modelica.Units.SI.Inertia JMotor=10 "Moment of inertia";

  //# ZIP
  parameter Real az=0.01175425
    "Fraction of constant impededance load in active power";
  parameter Real ai=0.00274616 "Fraction of constant current load in active power";
  parameter Real ap=0.9854996 "Fraction of constant power load in active power";
  parameter Real rz=1.05148009
    "Fraction of constant impededance load in reactive power";
  parameter Real ri=-0.16540235 "Fraction of constant current load in reactive power";
  parameter Real rp=0.11392224 "Fraction of constant power load in reactive power";
  Modelica.Blocks.Sources.Constant dpSet1(k=20000)
    annotation (Placement(transformation(extent={{-72,24},{-52,44}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/2*dp_nominal - 12000)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Sources.Boundary_pT expCol1(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,90})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=5000,
    dp2_nominal=1/4*dp_nominal)
    annotation (Placement(transformation(extent={{-10,-24},{10,-44}})));

  Buildings.Fluid.Sensors.RelativePressure senRelPre1(redeclare package Medium
      = Medium) annotation (Placement(transformation(extent={{20,10},{0,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium
      = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,-38},{-50,-18}})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/4*dp_nominal)
                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={66,30})));
  Modelica.Blocks.Sources.Constant temSet1(k=273.15 + 7)
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Blocks.Sources.Step TSou1(
    startTime=1000,
    height=4,
    offset=273.15 + 24)
    annotation (Placement(transformation(extent={{-90,-74},{-70,-54}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHot1(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-60})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpValve_nominal=6000)
    annotation (Placement(transformation(extent={{40,-38},{20,-18}})));
  Buildings.Controls.Continuous.LimPID conPID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=60,
    reverseActing=true,
    yMin=0.1)
    annotation (Placement(transformation(extent={{94,-40},{74,-20}})));
  Modelica.Blocks.Sources.Constant temSetHot1(k=273.15 + 16)
    annotation (Placement(transformation(extent={{74,-10},{94,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot1(
    redeclare package Medium = Medium,
    m_flow=m_flow_nominal,
    nPorts=1,
    use_T_in=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-60})));
  Buildings.Fluid.Sources.Boundary_pT sinHot1(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={80,-80})));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow=m_flow_nominal/1000*{0,0.41,0.54,0.66,0.77,0.89,1,1.12,1.19},
        dp=dp_nominal*{1.461,1.455,1.407,1.329,1.234,1.126,1.0,0.85,0.731}),
    motorEfficiency(V_flow={0}, eta={1}),
    speed_rpm_nominal=1800)
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{140,116},{160,136}})));
  parameter Integer pole=4 "Number of pole pairs";
  MotorDrive.Coupled.Pump simPum(
    redeclare package Medium = Medium,
    JMotor=5,
    per=per,
    simMot(VFD(
        k=0.1,
        Ti=60,
        reverseActing=false)))
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Electrical.AC.OnePhase.Sources.Grid Sou(f=60, V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
equation
  connect(hex1.port_b2,senTem1. port_a)
    annotation (Line(points={{-10,-28},{-30,-28}}, color={0,127,255}));
  connect(senTem1.port_b,res1. port_a) annotation (Line(points={{-50,-28},{
        -80,-28},{-80,70},{-60,70}},
                              color={0,127,255}));
  connect(temSet1.y, coo2.TSet)
    annotation (Line(points={{79,50},{58,50},{58,42}}, color={0,0,127}));
  connect(hex1.port_b1,senTemHot1. port_a)
    annotation (Line(points={{10,-40},{60,-40},{60,-50}}, color={0,127,255}));
  connect(coo2.port_b,val1. port_a)
    annotation (Line(points={{66,20},{66,-28},{40,-28}}, color={0,127,255}));
  connect(val1.port_b,hex1. port_a2)
    annotation (Line(points={{20,-28},{10,-28}}, color={0,127,255}));
  connect(senTemHot1.T,conPID1. u_m)
    annotation (Line(points={{71,-60},{84,-60},{84,-42}},   color={0,0,127}));
  connect(temSetHot1.y,conPID1. u_s)
    annotation (Line(points={{95,0},{100,0},{100,-30},{96,-30}},
                                                   color={0,0,127}));
  connect(conPID1.y,val1. y) annotation (Line(points={{73,-30},{60,-30},{60,
        -8},{30,-8},{30,-16}},
                             color={0,0,127}));
  connect(senTemHot1.port_b,sinHot1. ports[1])
    annotation (Line(points={{60,-70},{60,-80},{70,-80}}, color={0,127,255}));
  connect(souHot1.ports[1],hex1. port_a1) annotation (Line(points={{-40,-60},{-20,
          -60},{-20,-40},{-10,-40}}, color={0,127,255}));
  connect(TSou1.y,souHot1. T_in)
    annotation (Line(points={{-69,-64},{-62,-64}}, color={0,0,127}));
  connect(senRelPre1.port_b,hex1. port_b2) annotation (Line(points={{0,0},{-20,0},
          {-20,-28},{-10,-28}}, color={0,127,255}));
  connect(senRelPre1.port_a,val1. port_a) annotation (Line(points={{20,0},{50,0},
          {50,-28},{40,-28}}, color={0,127,255}));
  connect(res1.port_b, simPum.port_a) annotation (Line(points={{-40,70},{
        -10,70},{-10,50},{0,50}},
                            color={0,127,255}));
  connect(simPum.port_b, coo2.port_a) annotation (Line(points={{20,50},{44,50},
          {44,60},{66,60},{66,40}}, color={0,127,255}));
  connect(Sou.terminal, simPum.terminal) annotation (Line(points={{30,70},{30,
          62},{10,62},{10,60}}, color={0,120,120}));
  connect(dpSet1.y, simPum.setPoi) annotation (Line(points={{-51,34},{-40,
        34},{-40,58},{-1,58}},
                            color={0,0,127}));
  connect(expCol1.ports[1], simPum.port_a)
    annotation (Line(points={{-10,80},{-10,50},{0,50}},  color={0,127,255}));
  connect(senRelPre1.p_rel, simPum.meaPoi) annotation (Line(points={{10,9},{10,
          24},{-12,24},{-12,54},{-1,54}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://MotorDrive/Resources/Scripts/Dymola/Coupled/Examples/Pump.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Example that simulates a motor coupled pump to track the set point signal as the load changes.</p>
</html>"));
end Pump;
