within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model EN12975SolarGain "Example showing the use of EN12975SolarGain"
  extends Modelica.Icons.Example;
  import Buildings;
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector               per=
      Buildings.Fluid.SolarCollectors.Data.Concentrating.VerificationModel()
    "Performance data" annotation (choicesAllMatching=true);
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain  solHeaGai(
    B0=per.B0,
    B1=per.B1,
    y_intercept=per.y_intercept,
    nSeg=3,
    A_c=per.A,
    iamDiff=per.IAMDiff,
    shaCoe=0,
    use_shaCoe_in=true,
    til=45)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Constant
                               incAng(k=45*(2*Modelica.Constants.pi/360))
    "Incidence angle"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Sine     HDirTil(
    freqHz=1/86400,
    offset=400,
    amplitude=300) "Direct beam radiation, tilted surface"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Sine HDifTil(
    amplitude=200,
    freqHz=1/86400,
    offset=300) "Diffuse radiation, tilted surface"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Constant shaCoe(k=0.25) "Shading coefficient"
    annotation (Placement(transformation(extent={{-26,-60},{-6,-40}})));
equation
  connect(incAng.y, solHeaGai.incAng) annotation (Line(
      points={{-59,-30},{-20,-30},{-20,-12.6},{18,-12.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.y, solHeaGai.HDirTil) annotation (Line(
      points={{-19,10},{-6,10},{-6,-7.4},{18,-7.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.y, solHeaGai.HSkyDifTil)    annotation (Line(
      points={{-19,50},{8,50},{8,-2},{18,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shaCoe.y, solHeaGai.shaCoe_in) annotation (Line(
      points={{-5,-50},{8,-50},{8,-18},{18,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This examples demonstrates the implementation of <a href=\"modelica://Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain\">
Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Mar 27, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollectors/BaseClasses/Examples/EN12975SolarGain.mos"
        "Simulate and Plot"),
    Icon(graphics));
end EN12975SolarGain;
