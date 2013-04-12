within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model EN12975HeatLoss "Example showing the use of EN12975HeatLoss"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.Concentrating.Generic per=
    Buildings.Fluid.SolarCollectors.Data.Concentrating.SRCC2011127A()
    "Performance data" annotation (choicesAllMatching=true);
  Modelica.Blocks.Sources.Sine     TEnv(
    freqHz=0.01,
    offset=273.15 + 10,
    amplitude=7.5)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Sine     T1(
    amplitude=5,
    freqHz=0.1,
    offset=273.15 + 20)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Sine     T2(
    amplitude=5,
    freqHz=0.1,
    offset=273.15 + 25)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Sine     T3(
    amplitude=5,
    freqHz=0.1,
    offset=273.15 + 30)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss  heaLos(
    nSeg=3,
    A_c=2.699,
    Cp=4186,
    y_intercept=0.718,
    C1=0.733,
    C2=0.0204,
    m_flow_nominal=0.04,
    I_nominal=800,
    TMean_nominal=298.15,
    TEnv_nominal=283.15)
    annotation (Placement(transformation(extent={{62,20},{82,40}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(TEnv.y, heaLos.TEnv) annotation (Line(
      points={{-59,70},{-20,70},{-20,36},{60,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T3.y, heaLos.TFlu[3]) annotation (Line(
      points={{-59,30},{-20,30},{-20,25.3333},{60,25.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, heaLos.TFlu[2]) annotation (Line(
      points={{-59,-10},{-20,-10},{-20,24},{60,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, heaLos.TFlu[1]) annotation (Line(
      points={{-59,-50},{-14,-50},{-14,22.6667},{60,22.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This examples demonstrates the implementation of EN12975HeatLoss. All of the inputs are constants resulting in a very simple model and a constant output.
</p>
</html>", revisions="<html>
<ul>
<li>
Mar 27, 2013 by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/EN12975HeatLoss.mos"
        "Simulate and Plot"),
    Icon(graphics));
end EN12975HeatLoss;
