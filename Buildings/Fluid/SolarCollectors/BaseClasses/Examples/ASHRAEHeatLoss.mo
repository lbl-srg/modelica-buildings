within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model ASHRAEHeatLoss "Example showing the use of ASHRAEHeatLoss"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic               per=
      Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B()
    "Performance data" annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Density rho = 1000 "Density of water";
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
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
  Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss   heaLos(
    nSeg=3,
    I_nominal=800,
    Cp=4186,
    A_c=per.A,
    y_intercept=per.y_intercept,
    slope=per.slope,
    TIn_nominal=293.15,
    TEnv_nominal=283.15,
    m_flow_nominal=rho*per.VperA_flow_nominal*per.A)
    annotation (Placement(transformation(extent={{62,20},{82,40}})));
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
This examples demonstrates the implementation of ASHRAEHeatLoss. All of the inputs are constants resulting in a very simple model and a constant output.
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
          "Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/ASHRAEHeatLoss.mos"
        "Simulate and Plot"),
    Icon(graphics));
end ASHRAEHeatLoss;
