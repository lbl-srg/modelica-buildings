within Buildings.HeatTransfer.Examples;
model ConductorInitialization "Test model for heat conductor initialization"
  extends Modelica.Icons.Example;
  Buildings.HeatTransfer.Sources.FixedTemperature TB(T=303.15)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TA
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  parameter Buildings.HeatTransfer.Data.Solids.Brick brick(x=0.18, nStaRef=3,
    nSta=5)
    annotation (Placement(transformation(extent={{18,72},{38,92}})));
  parameter Buildings.HeatTransfer.Data.Solids.InsulationBoard insulation(x=0.05, nStaRef=2,
    nSta=5)
    annotation (Placement(transformation(extent={{-20,72},{0,92}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic compositeWall(
      material={insulation,brick}, nLay=2)
    "Composite wall consisting of insulation and material"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));

  Buildings.HeatTransfer.Conduction.MultiLayer conS1(
    A=2,
    steadyStateInitial=true,
    layers=compositeWall,
    stateAtSurface_a=false,
    stateAtSurface_b=false)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-60,50},{58,58}},
          textColor={0,0,0},
          textString="Steady state initialization (dT(0)/dt=0)")}),
experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorInitialization.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example illustrates how to initialize heat conductors in steady state and with
predefined temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
September 9, 2014, by Michael Wetter:<br/>
Moved declaration of <code>compositeWall</code> due to a bug
in Dymola 2015 FD01 beta1.
</li>
<li>
March 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConductorInitialization;
