within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model ASHRAESolarGain "Example showing the use of ASHRAESolarGain"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 per=
    Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_ThermaLiteHS20()
    "Performance data"
    annotation (choicesAllMatching=true);
  Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain solGai(
    nSeg=3,
    b0=per.b0,
    b1=per.b1,
    shaCoe=0,
    use_shaCoe_in=true,
    A_c=per.A,
    y_intercept=per.y_intercept,
    redeclare package Medium = Buildings.Media.Water,
    til=0.78539816339745) "Solar heat gain model using ASHRAE 93 calculations"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.Sine HGroDifTil(
    amplitude=50,
    f=4/86400,
    offset=100) "Diffuse radiation from the ground, tilted surface"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Sources.Ramp incAng(duration=86400, height=60*(2*Modelica.Constants.pi
        /360)) "Incidence angle"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Sine HDirTil(
    offset=400,
    amplitude=300,
    f=2/86400) "Direct beam radiation, tilted surface"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Sources.Sine HSkyDifTil(
    f=1/86400,
    amplitude=100,
    offset=100) "Diffuse radiation, tilted surface"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Blocks.Sources.Ramp shaCoe(
    height=-1,
    duration=86400,
    offset=1) "Shading coefficient"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Modelica.Blocks.Sources.Sine T3(
    f=2/86400,
    amplitude=50,
    offset=273.15 + 110)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Blocks.Sources.Sine T2(
    f=2/86400,
    amplitude=50,
    offset=273.15 + 100)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.Sine T1(
    f=2/86400,
    amplitude=50,
    offset=273.15 + 90)
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
equation
  connect(HGroDifTil.y,solGai. HGroDifTil) annotation (Line(
      points={{11,60},{20,60},{20,5},{68,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe.y,solGai. shaCoe_in) annotation (Line(
      points={{-69,-20},{-60,-20},{-60,-5},{68,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y,solGai. incAng) annotation (Line(
      points={{-69,20},{-60,20},{-60,-2},{68,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.y,solGai. HDirTil) annotation (Line(
      points={{-29,40},{-20,40},{-20,2},{68,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HSkyDifTil.y,solGai. HSkyDifTil) annotation (Line(
      points={{51,80},{60,80},{60,8},{68,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T3.y,solGai. TFlu[3]) annotation (Line(
      points={{-29,-40},{-20,-40},{-20,-8},{68,-8},{68,-7.33333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y,solGai. TFlu[2]) annotation (Line(
      points={{11,-60},{20,-60},{20,-8},{68,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y,solGai. TFlu[1]) annotation (Line(
      points={{51,-80},{60,-80},{60,-8.66667},{68,-8.66667}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
This examples demonstrates the implementation of
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain\">
Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain</a>.
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
<li>
Mar 27, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/ASHRAESolarGain.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=86400));
end ASHRAESolarGain;
