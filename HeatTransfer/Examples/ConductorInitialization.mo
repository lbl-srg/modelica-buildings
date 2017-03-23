within Buildings.HeatTransfer.Examples;
model ConductorInitialization "Test model for heat conductor initialization"
  extends Modelica.Icons.Example;
  Buildings.HeatTransfer.Sources.FixedTemperature TB(T=303.15)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic compositeWall(
      material={insulation,brick}, final nLay=2)
    "Composite wall consisting of insulation and material"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));
  parameter Buildings.HeatTransfer.Data.Solids.Brick brick(x=0.18, nStaRef=3)
    annotation (Placement(transformation(extent={{18,72},{38,92}})));
  parameter Buildings.HeatTransfer.Data.Solids.InsulationBoard insulation(x=0.05, nStaRef=2)
    annotation (Placement(transformation(extent={{-20,72},{0,92}})));

  Buildings.HeatTransfer.Conduction.MultiLayer conS1(
    A=2,
    steadyStateInitial=true,
    layers=compositeWall)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.HeatTransfer.Conduction.SingleLayer conS2(
    A=2,
    steadyStateInitial=true,
    material=brick)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.HeatTransfer.Conduction.MultiLayer conD1(
    A=2,
    steadyStateInitial=false,
    layers=compositeWall,
    T_a_start=288.15,
    T_b_start=298.15)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.HeatTransfer.Conduction.SingleLayer conD2(
    A=2,
    material=brick,
    steadyStateInitial=false,
    T_a_start=288.15,
    T_b_start=298.15)
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.HeatTransfer.Sources.FixedTemperature TB1(T=303.15)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA1
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.HeatTransfer.Sources.FixedTemperature TB2(T=303.15)
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA2
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.HeatTransfer.Sources.FixedTemperature TB3(T=303.15)
    annotation (Placement(transformation(extent={{80,-90},{60,-70}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA3
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=283.15,
    startTime=43200)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

equation
  connect(step.y, TA.T) annotation (Line(
      points={{-79,30},{-62,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conS1.port_b, TB.port)
                               annotation (Line(
      points={{20,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA.port, conS1.port_a)
                               annotation (Line(
      points={{-40,30},{-5.55112e-16,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conS2.port_b, TB1.port)
                               annotation (Line(
      points={{20,6.10623e-16},{30,6.10623e-16},{30,0},{40,0},{40,6.10623e-16},
          {60,6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA1.port, conS2.port_a)
                               annotation (Line(
      points={{-40,6.10623e-16},{-30,6.10623e-16},{-30,0},{-20,0},{-20,
          6.10623e-16},{-5.55112e-16,6.10623e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA1.T, step.y) annotation (Line(
      points={{-62,6.66134e-16},{-70,6.66134e-16},{-70,30},{-79,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conD1.port_b, TB2.port)
                               annotation (Line(
      points={{20,-50},{60,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA2.port, conD1.port_a)
                               annotation (Line(
      points={{-40,-50},{-5.55112e-16,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TA2.T, step.y) annotation (Line(
      points={{-62,-50},{-70,-50},{-70,30},{-79,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA3.T, step.y) annotation (Line(
      points={{-62,-80},{-70,-80},{-70,30},{-79,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TA3.port, conD2.port_a) annotation (Line(
      points={{-40,-80},{-5.55112e-16,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conD2.port_b, TB3.port) annotation (Line(
      points={{20,-80},{60,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-60,50},{58,58}},
          lineColor={0,0,0},
          textString="Steady state initialization (dT(0)/dt=0)"), Text(
          extent={{-86,-32},{32,-24}},
          lineColor={0,0,0},
          textString="Fixed initial state T(0)")}),
experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorInitialization.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example illustrates how to initialize heat conductors in steady state and with
predefined temperatures.
</html>", revisions="<html>
<ul>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConductorInitialization;
