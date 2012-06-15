within Buildings.Fluid.SolarCollector.BaseClasses.Examples;
model FlatPlateSolarGain "Test model for FlatPlateSolarGain"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  parameter Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.Generic per=
      Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.SRCC2001002B()
    "Performance data" annotation (choicesAllMatching=true);

  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.SolarCollector.BaseClasses.FlatPlateSolarGain solHeaGai(
    B0=per.B0,
    B1=per.B1,
    C0=per.C0,
    C1=per.C1,
    C2=per.C2,
    A=per.AGro,
    shaCoe=0,
    til=0.78539816339745)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Constant T(k=273.15 + 40)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Constant TEnv(k=273.15 + 40)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Sources.Sine incAng(freqHz=1/87600, amplitude=60/180*Modelica.Constants.pi)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Constant HDirTil(k=600)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Constant HGroDifTil(k=20)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Constant HSkyDifTil(k=400)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(T.y, solHeaGai.T) annotation (Line(
      points={{-59,-70},{0,-70},{0,-20},{18,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y, solHeaGai.incAng) annotation (Line(
      points={{-59,-10},{-18,-10},{-18,-14},{18,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEnv.y, solHeaGai.TEnv) annotation (Line(
      points={{-19,-40},{-8,-40},{-8,-17},{18,-17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.y, solHeaGai.HDirTil) annotation (Line(
      points={{-19,10},{-6,10},{-6,-8},{18,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HGroDifTil.y, solHeaGai.HGroDifTil) annotation (Line(
      points={{-59,30},{-2,30},{-2,-5.2},{18,-5.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HSkyDifTil.y, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-19,50},{8,50},{8,-2},{18,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This examples demonstrates the implementation of FlatPlateSolarGain.
</p>
</html>", revisions="<html>
<ul>
<li>
June 8, 2012, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/FlatPlateSolarGain.mos"
        "Simulate and plot"),
    Icon(graphics));
end FlatPlateSolarGain;
