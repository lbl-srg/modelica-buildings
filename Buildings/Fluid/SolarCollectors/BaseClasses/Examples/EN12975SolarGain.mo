within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model EN12975SolarGain "Example showing the use of EN12975SolarGain"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericEN12975 per=
    Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_VerificationModel()
    "Performance data"
    annotation (choicesAllMatching=true);
  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain solGai(
    eta0=per.eta0,
    incAngDat=per.incAngDat,
    incAngModDat=per.incAngModDat,
    nSeg=3,
    A_c=per.A,
    iamDiff=per.IAMDiff,
    shaCoe=0,
    use_shaCoe_in=true,
    redeclare package Medium = Buildings.Media.Water)
    "Solar heat gain model using EN12975 calculations"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.Ramp incAng(duration=86400,
    height=60*(2*Modelica.Constants.pi/360)) "Incidence angle"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Sine HDirTil(
    offset=400,
    amplitude=300,
    f=2/86400) "Direct beam radiation, tilted surface"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Sources.Sine HDifTil(
    amplitude=200,
    f=1/86400,
    offset=300) "Diffuse radiation, tilted surface"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Blocks.Sources.Ramp shaCoe(
    duration=86400,
    offset=1,
    height=-1) "Shading coefficient"
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
  connect(incAng.y, solGai.incAng) annotation (Line(
      points={{-69,20},{-60,20},{-60,-2},{68,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe.y, solGai.shaCoe_in) annotation (Line(
      points={{-69,-20},{-60,-20},{-60,-5},{68,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.y, solGai.HDirTil) annotation (Line(
      points={{-29,40},{-20,40},{-20,2},{68,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.y, solGai.HSkyDifTil) annotation (Line(
      points={{51,80},{60,80},{60,8},{68,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T3.y, solGai.TFlu[3]) annotation (Line(
      points={{-29,-40},{-20,-40},{-20,-7.33333},{68,-7.33333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, solGai.TFlu[2]) annotation (Line(
      points={{11,-60},{20,-60},{20,-8},{68,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, solGai.TFlu[1]) annotation (Line(
      points={{51,-80},{60,-80},{60,-8},{68,-8},{68,-8.66667}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
This examples demonstrates the implementation of
<a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain\">
Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain</a>.
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
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/EN12975SolarGain.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=86400));
end EN12975SolarGain;
