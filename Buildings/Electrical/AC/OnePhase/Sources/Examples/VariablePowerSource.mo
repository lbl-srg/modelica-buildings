within Buildings.Electrical.AC.OnePhase.Sources.Examples;
model VariablePowerSource
  "This example illustrates how using a variable power source"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.OnePhase.Sources.Generator generator(      Phi(displayUnit="deg") = 0.26179938779915)
    "AC generator model"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.Sine generation(
    offset=200,
    startTime=1,
    amplitude=100,
    freqHz=0.05) "Generated power"
    annotation (Placement(transformation(extent={{-92,-10},{-72,10}})));
  Buildings.Electrical.AC.OnePhase.Loads.Inductive RL(mode=Types.Assumption.VariableZ_y_input,
      P_nominal=-300) "Load model"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Electrical.AC.OnePhase.Sources.Grid grid
    "AC one phase electrical grid"
           annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Trapezoid load(
    rising=2,
    width=3,
    falling=3,
    period=10,
    startTime=1,
    amplitude=0.8,
    offset=0.2) "Power consumption profile"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
equation
  connect(generation.y, generator.P) annotation (Line(
      points={{-71,0},{-50,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(generator.terminal, RL.terminal)
                                          annotation (Line(
      points={{-30,0},{20,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(grid.terminal, RL.terminal)
                                     annotation (Line(
      points={{-10,40},{-10,0},{20,0},{20,5.55112e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.y, RL.y)
                       annotation (Line(
      points={{59,0},{40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=21, Tolerance=1e-05),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/OnePhase/Sources/Examples/VariablePowerSource.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
</html>"));
end VariablePowerSource;
