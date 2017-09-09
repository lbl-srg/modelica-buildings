within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model EN12975SolarGain "Example showing the use of EN12975SolarGain"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per=
    Buildings.Fluid.SolarCollectors.Data.Concentrating.C_VerificationModel()
    "Performance data"
    annotation (choicesAllMatching=true);
  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain solHeaGai(
    B0=per.B0,
    B1=per.B1,
    y_intercept=per.y_intercept,
    nSeg=3,
    A_c=per.A,
    iamDiff=per.IAMDiff,
    shaCoe=0,
    use_shaCoe_in=true,
    redeclare package Medium = Buildings.Media.Water)
    "Solar heat gain model using EN12975 calculations"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Sources.Ramp incAng(duration=86400,
    height=60*(2*Modelica.Constants.pi/360)) "Incidence angle"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Sine HDirTil(
    offset=400,
    amplitude=300,
    freqHz=2/86400) "Direct beam radiation, tilted surface"
    annotation (Placement(transformation(extent={{-40,44},{-20,64}})));
  Modelica.Blocks.Sources.Sine HDifTil(
    amplitude=200,
    freqHz=1/86400,
    offset=300) "Diffuse radiation, tilted surface"
    annotation (Placement(transformation(extent={{-40,74},{-20,94}})));
  Modelica.Blocks.Sources.Ramp shaCoe(
    duration=86400,
    offset=1,
    height=-1) "Shading coefficient"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Sine T3(
    freqHz=2/86400,
    amplitude=50,
    offset=273.15 + 110)
    annotation (Placement(transformation(extent={{-50,-38},{-30,-18}})));
  Modelica.Blocks.Sources.Sine T2(
    freqHz=2/86400,
    amplitude=50,
    offset=273.15 + 100)
    annotation (Placement(transformation(extent={{-26,-54},{-6,-34}})));
  Modelica.Blocks.Sources.Sine T1(
    freqHz=2/86400,
    amplitude=50,
    offset=273.15 + 90)
    annotation (Placement(transformation(extent={{-2,-70},{18,-50}})));
equation
  connect(incAng.y, solHeaGai.incAng) annotation (Line(
      points={{-59,30},{14,30},{14,10},{58,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe.y, solHeaGai.shaCoe_in) annotation (Line(
      points={{-59,-10},{14,-10},{14,6},{58,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.y, solHeaGai.HDirTil) annotation (Line(
      points={{-19,54},{18,54},{18,14},{58,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.y, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-19,84},{22,84},{22,18},{58,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T3.y, solHeaGai.TFlu[3]) annotation (Line(
      points={{-29,-28},{18,-28},{18,3.33333},{58,3.33333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, solHeaGai.TFlu[2]) annotation (Line(
      points={{-5,-44},{22,-44},{22,2},{58,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, solHeaGai.TFlu[1]) annotation (Line(
      points={{19,-60},{26,-60},{26,0.666667},{58,0.666667}},
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
          Mar 27, 2013 by Peter Grant:<br/>
          First implementation.
        </li>
      </ul>
    </html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/EN12975SolarGain.mos"
        "Simulate and plot"),
        experiment(Tolerance=1e-6, StopTime=86400));
end EN12975SolarGain;
