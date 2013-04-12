within Buildings.Fluid.SolarCollectors.BaseClasses.Examples;
model EN12975SolarGain "Example showing the use of EN12975SolarGain"
  extends Modelica.Icons.Example;
  import Buildings;
  parameter Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.Generic               per=
      Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B()
    "Performance data" annotation (choicesAllMatching=true);
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.SolarCollectors.BaseClasses.EN12975SolarGain  solHeaGai(
    B0=per.B0,
    B1=per.B1,
    y_intercept=per.y_intercept,
    nSeg=3,
    A_c=per.A,
    shaCoe=0.25,
    til=45,
    iamDiff=per.IAMDiff)
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.Constant
                               incAng(k=45*(2*Modelica.Constants.pi/360))
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Sine     HDirTil(
    freqHz=1/86400,
    offset=400,
    amplitude=300)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Sine     HSkyDifTil(
    amplitude=200,
    freqHz=1/86400,
    offset=300)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(incAng.y, solHeaGai.incAng) annotation (Line(
      points={{-59,-30},{-20,-30},{-20,-14},{18,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.y, solHeaGai.HDirTil) annotation (Line(
      points={{-19,10},{-6,10},{-6,-8},{18,-8}},
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
This examples demonstrates the implementation of EN12975SolarGain. All of the inputs are constants resulting in a very simple model and constant output.
</p>
</html>", revisions="<html>
<ul>
<li>
Mar 27, 2013 by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollector/BaseClasses/Examples/EN12975SolarGain.mos"
        "Simulate and Plot"),
    Icon(graphics));
end EN12975SolarGain;
