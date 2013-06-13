within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model ASHRAESolarGain "Example showing the use of ASHRAESolarGain"
  import Buildings;
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per=
      Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.ThermaLiteHS20()
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
    til=0.78539816339745) "Solar heat gain model using ASHRAE 93 calculations"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Sine     HGroDifTil(
    amplitude=50,
    freqHz=4/86400,
    offset=100) "Diffuse radiation from the ground, tilted surface"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp incAng(duration=86400, height=60*(2*Modelica.Constants.pi
        /360)) "Incidence angle"
    annotation (Placement(transformation(extent={{-78,-30},{-58,-10}})));
  Modelica.Blocks.Sources.Sine HDirTil(
    offset=400,
    amplitude=300,
    freqHz=2/86400) "Direct beam radiation, tilted surface"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Sine HSkyDifTil(
    freqHz=1/86400,
    amplitude=100,
    offset=100) "Diffuse radiation, tilted surface"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.Ramp shaCoe(
    height=-1,
    duration=86400,
    offset=1) "Shading coefficient"
    annotation (Placement(transformation(extent={{-40,-52},{-20,-32}})));
equation
  connect(HGroDifTil.y, solHeaGai.HGroDifTil) annotation (Line(
      points={{-59,30},{4,30},{4,-5.2},{18,-5.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe.y, solHeaGai.shaCoe_in) annotation (Line(
      points={{-19,-42},{6,-42},{6,-18},{18,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y, solHeaGai.incAng) annotation (Line(
      points={{-57,-20},{0,-20},{0,-14},{18,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.y, solHeaGai.HDirTil) annotation (Line(
      points={{-19,10},{0,10},{0,-8},{18,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HSkyDifTil.y, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-19,60},{8,60},{8,-2},{18,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This examples demonstrates the implementation of 
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain\">
Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain</a>.
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
