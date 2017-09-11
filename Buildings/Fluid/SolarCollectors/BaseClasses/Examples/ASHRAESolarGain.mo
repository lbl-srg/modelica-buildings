within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model ASHRAESolarGain "Example showing the use of ASHRAESolarGain"
  extends Modelica.Icons.Example;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per=
    Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_ThermaLiteHS20()
    "Performance data"
    annotation (choicesAllMatching=true);
  Buildings.Fluid.SolarCollectors.BaseClasses.ASHRAESolarGain   solHeaGai(
    nSeg=3,
    shaCoe=0,
    use_shaCoe_in=true,
    A_c=per.A,
    y_intercept=per.y_intercept,
    B0=per.B0,
    B1=per.B1,
    redeclare package Medium = Buildings.Media.Water,
    til=0.78539816339745) "Solar heat gain model using ASHRAE 93 calculations"
    annotation (Placement(transformation(extent={{72,0},{92,20}})));
  Modelica.Blocks.Sources.Sine     HGroDifTil(
    amplitude=50,
    freqHz=4/86400,
    offset=100) "Diffuse radiation from the ground, tilted surface"
    annotation (Placement(transformation(extent={{-64,44},{-44,64}})));
  Modelica.Blocks.Sources.Ramp incAng(duration=86400, height=60*(2*Modelica.Constants.pi
        /360)) "Incidence angle"
    annotation (Placement(transformation(extent={{-90,-16},{-70,4}})));
  Modelica.Blocks.Sources.Sine HDirTil(
    offset=400,
    amplitude=300,
    freqHz=2/86400) "Direct beam radiation, tilted surface"
    annotation (Placement(transformation(extent={{-90,18},{-70,38}})));
  Modelica.Blocks.Sources.Sine HSkyDifTil(
    freqHz=1/86400,
    amplitude=100,
    offset=100) "Diffuse radiation, tilted surface"
    annotation (Placement(transformation(extent={{-38,74},{-18,94}})));
  Modelica.Blocks.Sources.Ramp shaCoe(
    height=-1,
    duration=86400,
    offset=1) "Shading coefficient"
    annotation (Placement(transformation(extent={{-64,-42},{-44,-22}})));
  Modelica.Blocks.Sources.Sine T3(
    freqHz=2/86400,
    amplitude=50,
    offset=273.15 + 110)
    annotation (Placement(transformation(extent={{-38,-58},{-18,-38}})));
  Modelica.Blocks.Sources.Sine T2(
    freqHz=2/86400,
    amplitude=50,
    offset=273.15 + 100)
    annotation (Placement(transformation(extent={{-14,-74},{6,-54}})));
  Modelica.Blocks.Sources.Sine T1(
    freqHz=2/86400,
    amplitude=50,
    offset=273.15 + 90)
    annotation (Placement(transformation(extent={{10,-94},{30,-74}})));
equation
  connect(HGroDifTil.y, solHeaGai.HGroDifTil) annotation (Line(
      points={{-43,54},{32,54},{32,14.8},{70,14.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe.y, solHeaGai.shaCoe_in) annotation (Line(
      points={{-43,-32},{32,-32},{32,5},{70,5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y, solHeaGai.incAng) annotation (Line(
      points={{-69,-6},{28,-6},{28,8},{70,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.y, solHeaGai.HDirTil) annotation (Line(
      points={{-69,28},{28,28},{28,12},{70,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HSkyDifTil.y, solHeaGai.HSkyDifTil) annotation (Line(
      points={{-17,84},{36,84},{36,18},{70,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T3.y, solHeaGai.TFlu[3]) annotation (Line(
      points={{-17,-48},{36,-48},{36,3.33333},{70,3.33333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2.y, solHeaGai.TFlu[2]) annotation (Line(
      points={{7,-64},{40,-64},{40,2},{70,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T1.y, solHeaGai.TFlu[1]) annotation (Line(
      points={{31,-84},{44,-84},{44,0.666667},{70,0.666667}},
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
