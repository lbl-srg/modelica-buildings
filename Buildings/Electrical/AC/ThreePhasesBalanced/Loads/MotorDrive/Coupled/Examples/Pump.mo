within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Examples;
model Pump "Example showing how to use the motor coupled pump model"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water "Water medium";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.Pressure dp_nominal=500
    "nominal pressure drop";

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumW,
    nPorts=2)
    "Boundary"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0,
      origin={-90,20})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.Coupled.Pump pum(
    addPowerToMedium=true,
    loaIne=1,
    Nrpm_nominal=1500,
    redeclare Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data.Generic motPer,
    r=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Medium = MediumW,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine50slash150dash4slash2 per,
    k=0.05,
    Ti=5)    "Pump"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid gri(f=50, V=400)
    "Voltage source"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = MediumW)
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
    height=10,
    offset=0,
    startTime=100)
    "Flow rate set point"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

equation
  connect(gri.terminal, pum.terminal) annotation (Line(points={{10,60},{10,30}},
          color={0,120,120}));
  connect(step.y, pum.m_flow_set) annotation (Line(points={{-59,70},{-10,70},{
          -10,28},{-2,28}},
                        color={0,0,127}));
  connect(dp1.port_b, pum.port_a) annotation (Line(points={{-20,20},{0,20}},
          color={0,127,255}));
  connect(dp1.port_a, sou.ports[1])
    annotation (Line(points={{-40,20},{-80,20},{-80,19}}, color={0,127,255}));
  connect(pum.port_b, dp2.port_a) annotation (Line(points={{20,20},{40,20}},
          color={0,127,255}));
  connect(dp2.port_b, senMasFlo.port_a) annotation (Line(points={{60,20},{64,20},
          {64,-40},{0,-40}}, color={0,127,255}));
  connect(senMasFlo.port_b, sou.ports[2]) annotation (Line(points={{-20,-40},{
          -50,-40},{-50,21},{-80,21}}, color={0,127,255}));
  connect(senMasFlo.m_flow,pum.m_flow)  annotation (Line(points={{-10,-29},{-10,
          24},{-2,24}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6,StartTime=0,StopTime=200),
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
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
Debug and updated the model
</li>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation. 
</li>
</ul>
</html>"));
end Pump;
