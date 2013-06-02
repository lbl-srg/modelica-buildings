within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model ASHRAESolarGain "Example showing the use of ASHRAESolarGain"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector               per=
      Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B()
    "Performance data" annotation (choicesAllMatching=true);
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain   solHeaGai(
    B0=per.B0,
    B1=per.B1,
    y_intercept=per.y_intercept,
    nSeg=3,
    A_c=per.A,
    shaCoe=0,
    use_shaCoe_in=true,
    til=0.78539816339745)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Constant
                               incAng(k=0.523) "Incidence angle"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Constant HDirTil(k=800)
    "Direct beam radiation, tilted surface"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Constant HGroDifTil(k=200)
    "Diffuse radiation from the ground, tilted surface"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Constant HSkyDifTil(k=400)
    "Diffuse radiation from the sky, tilted surface"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Constant shaCoe(k=0.25) "Shading coefficient"
    annotation (Placement(transformation(extent={{-40,-56},{-20,-36}})));
equation
  connect(incAng.y, solHeaGai.incAng) annotation (Line(
      points={{-59,-30},{-20,-30},{-20,-14},{18,-14}},
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
  connect(shaCoe.y, solHeaGai.shaCoe_in) annotation (Line(
      points={{-19,-46},{2,-46},{2,-18},{18,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This examples demonstrates the implementation of <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain\">
Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain</a>. All of the inputs are constant resulting in a very simple model and constants for the
 output.
</p>
</html>", revisions="<html>
<ul>
<li>
Mat 27, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/ASHRAESolarGain.mos"
        "Simulate and Plot"),
    Icon(graphics));
end ASHRAESolarGain;
