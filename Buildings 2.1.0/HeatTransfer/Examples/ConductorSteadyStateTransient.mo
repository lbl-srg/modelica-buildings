within Buildings.HeatTransfer.Examples;
model ConductorSteadyStateTransient "Test model for heat conductor"
  extends Modelica.Icons.Example;

  parameter Buildings.HeatTransfer.Data.Solids.Brick brick(x=0.12, nStaRef=4)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  parameter Buildings.HeatTransfer.Data.Solids.InsulationBoard insul(
    x=0.05,
    c=0,
    nStaRef=3) "Insulation"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic composite(nLay=2, material=
       {insul,brick})
    annotation (Placement(transformation(extent={{80,60},{100,80}})));

  Buildings.HeatTransfer.Conduction.MultiLayer conMul(
    A=2, layers=composite)
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.HeatTransfer.Conduction.SingleLayer con(
    A=2, material=brick) annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.HeatTransfer.Sources.FixedTemperature TB(T=293.15)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=3600)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.HeatTransfer.Conduction.SingleLayer con1(
    A=2, material=insul)
         annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB1(T=293.15)
    annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA1
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.HeatTransfer.Conduction.SingleLayer con2(
    A=2, material=brick)
             annotation (Placement(transformation(extent={{50,-20},{70,0}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA2
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TB2(T=293.15)
    annotation (Placement(transformation(extent={{100,-60},{80,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo1
    annotation (Placement(transformation(extent={{0,-16},{12,-4}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo2
    annotation (Placement(transformation(extent={{14,-56},{26,-44}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(threShold=1E-4)
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.HeatTransfer.Convection.Interior conv1(A=2, til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-10,-20},{-30,0}})));
  Buildings.HeatTransfer.Convection.Interior conv2(A=2, til=Buildings.Types.Tilt.Wall)
    "Convective heat transfer"
    annotation (Placement(transformation(extent={{-10,-60},{-30,-40}})));
equation
  connect(con.port_b, TB.port) annotation (Line(
      points={{40,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, TA.T) annotation (Line(
      points={{-79,30},{-62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TA1.T) annotation (Line(
      points={{-79,30},{-72,30},{-72,-10},{-62,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con1.port_b, con2.port_a) annotation (Line(
      points={{40,-10},{50,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con2.port_b, TB1.port) annotation (Line(
      points={{70,-10},{80,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA2.T, step.y) annotation (Line(
      points={{-62,-50},{-72,-50},{-72,30},{-79,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaFlo1.port_b, con1.port_a) annotation (Line(
      points={{12,-10},{20,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(assertEquality.u1, heaFlo2.Q_flow) annotation (Line(
      points={{58,-84},{20,-84},{20,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assertEquality.u2, heaFlo1.Q_flow) annotation (Line(
      points={{58,-96},{6,-96},{6,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA.port, con.port_a) annotation (Line(
      points={{-40,30},{20,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conMul.port_b, TB2.port) annotation (Line(
      points={{60,-50},{80,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conMul.port_a, heaFlo2.port_b) annotation (Line(
      points={{40,-50},{26,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA1.port, conv1.fluid) annotation (Line(
      points={{-40,-10},{-30,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv1.solid, heaFlo1.port_a) annotation (Line(
      points={{-10,-10},{2.22045e-16,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA2.port, conv2.fluid) annotation (Line(
      points={{-40,-50},{-30,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conv2.solid, heaFlo2.port_a) annotation (Line(
      points={{-10,-50},{14,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorSteadyStateTransient.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example illustrates modeling of multi-layer materials. It also tests if the
multi-layer material computes the same heat transfer with its boundary condition
as two instances of a single layer material.
The insulation is computed in steady-state, whereas the brick is computed using transient
heat conduction.
The <code>assert</code> block will stop the simulation if the heat exchange with the boundary
condition differs.
</html>", revisions="<html>
<ul>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConductorSteadyStateTransient;
