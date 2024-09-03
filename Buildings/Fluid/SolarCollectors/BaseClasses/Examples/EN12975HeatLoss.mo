within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model EN12975HeatLoss "Example showing the use of EN12975HeatLoss"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericEN12975 per=
    Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_VerificationModel()
    "Performance data"
    annotation (choicesAllMatching=true);
  Modelica.Blocks.Sources.Sine TEnv(
    f=0.01,
    offset=273.15 + 10,
    amplitude=15) "Temperature of the surrounding environment"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Blocks.Sources.Sine T1(
    amplitude=15,
    f=0.1,
    offset=273.15 + 10) "Temperature of the first segment"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Modelica.Blocks.Sources.Sine T2(
    f=0.1,
    amplitude=15,
    offset=273.15 + 15) "Temperature of the second segment"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.Sine T3(
    f=0.1,
    amplitude=15,
    offset=273.15 + 20) "Temperature of the third segment"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss heaLos(
    nSeg=3,
    redeclare package Medium = Buildings.Media.Water,
    a1=per.a1,
    a2=per.a2,
    A_c=per.A)       "Heat loss model using EN12975 calculations"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(TEnv.y, heaLos.TEnv) annotation (Line(
      points={{51,80},{60,80},{60,6},{68,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T3.y, heaLos.TFlu[3]) annotation (Line(
      points={{-29,-40},{-20,-40},{-20,-6},{68,-6},{68,-5.33333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, heaLos.TFlu[2]) annotation (Line(
      points={{11,-60},{20,-60},{20,-6},{68,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, heaLos.TFlu[1]) annotation (Line(
      points={{51,-80},{60,-80},{60,-6.66667},{68,-6.66667}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
This examples demonstrates the implementation of
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss\">
Buildings.Fluid.SolarCollectors.BaseClasses.EN12975HeatLoss</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
Mar 27, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
  </html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/EN12975HeatLoss.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=100));
end EN12975HeatLoss;
