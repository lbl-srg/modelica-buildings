within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Examples;
model Pump "This example shows how to use the motor coupled pump model"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1 "Nominal mass flow rate";
  parameter Modelica.Units.SI.Pressure dp_nominal=500   "nominal pressure drop";

  Buildings.Fluid.Sources.Boundary_pT sou(redeclare package Medium = MediumW,
    nPorts=1) "Boundary"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={-90,20})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Pump pum(
    R_s=0.641,
    R_r=0.332,
    X_s=1.106,
    X_r=0.464,
    X_m=26.3,
    pum(pum(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)),
    redeclare package Medium = MediumW,
    JMotor=5,
    JLoad=5,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine50slash150dash4slash2 per,
    simMot(VFD(
    k=0.1,
    Ti=60,
    reverseActing=true))) "Pump"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid gri(f=60, V=480)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumW)
    "Flow rate sensor"
    annotation (Placement(transformation(extent={{0,-50},{-20,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp1(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/2*dp_nominal) "Pressure loss"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp2(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1/2*dp_nominal) "Pressure loss"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.Step step(
    height=0,
    offset=10,
    startTime=1800) "Flow rate set point"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

equation
  connect(dp1.port_b, pum.port_a) annotation (Line(points={{-20,20},{0,20}},
          color={0,127,255}));
  connect(gri.terminal, pum.terminal) annotation (Line(points={{10,60},{10,30}},
          color={0,120,120}));
  connect(senMasFlo.m_flow, pum.meaPoi) annotation (Line(points={{-10,-29},{-10,24},
          {-1,24}}, color={0,0,127}));
  connect(dp1.port_a, senMasFlo.port_b) annotation (Line(points={{-40,20},{-60,20},
          {-60,-40},{-20,-40}}, color={0,127,255}));
  connect(pum.port_b, dp2.port_a) annotation (Line(points={{20,20},{40,20}},
          color={0,127,255}));
  connect(dp2.port_b, senMasFlo.port_a) annotation (Line(points={{60,20},{80,20},
          {80,-40},{0,-40}}, color={0,127,255}));
  connect(sou.ports[1], dp1.port_a) annotation (Line(points={{-80,20},{-40,20}},
          color={0,127,255}));
  connect(step.y, pum.setPoi) annotation (Line(points={{-59,70},{-20,70},
          {-20,28},{-1,28}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/Coupled/Examples/Pump.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates a motor coupled pump to track the set point signal as 
the load changes.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation. 
</li>
</ul>
</html>"));
end Pump;
