within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model ASHRAEHeatLoss "Example showing the use of ASHRAEHeatLoss"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 per=
    Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_SolahartKf()
    "Performance data"
    annotation (choicesAllMatching=true);
  Modelica.Blocks.Sources.Sine TEnv(
    f=0.01,
    offset=273.15 + 10,
    amplitude=15) "Temperature of the surrounding environment"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Blocks.Sources.Sine T1(
    amplitude=7.5,
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
  Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss  heaLos(
    nSeg=3,
    redeclare package Medium = Buildings.Media.Water,
    A_c=per.A,
    slope=per.slope) "Heat loss model using EN12975 calculations"
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
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss\">
Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAEHeatLoss</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
</ul>
  </html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/ASHRAEHeatLoss.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=100));
end ASHRAEHeatLoss;
