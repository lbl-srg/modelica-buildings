within Buildings.Controls.Predictors.Validation;
model SineInput
  "Demand response client with sinusoidal input for actual power consumption"
  extends
    Buildings.Controls.Predictors.Validation.BaseClasses.PartialSimpleTestCase;

  Modelica.Blocks.Sources.Cosine PBas(
    amplitude=0.5,
    offset=0.5,
    f=1/tPeriod,
    phase=3.1415926535898) "Measured power consumption"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Sampler P(samplePeriod=tSample)
    "Sampler to turn PCon into a piece-wise constant signal. This makes it easier to verify the results"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Continuous.Integrator integrator
    "Integrator to compute energy from power"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(
    y=if (dayType.y[1] == Buildings.Controls.Types.Day.WorkingDay) then 0 else 1)
    annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));
  Modelica.Blocks.Math.Add PCon "Consumed power"
    annotation (Placement(transformation(extent={{-68,-40},{-48,-20}})));
equation
  connect(P.y, integrator.u) annotation (Line(
      points={{-19,-30},{-12,-30},{-12,0},{-10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, baseLoad.ECon) annotation (Line(
      points={{13,0},{26,0},{26,8.88178e-16},{58,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCon.u2, PBas.y) annotation (Line(
      points={{-70,-36},{-74,-36},{-74,-30},{-79,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, PCon.u1) annotation (Line(
      points={{-79,-8},{-76,-8},{-76,-24},{-70,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCon.y, P.u) annotation (Line(
      points={{-47,-30},{-42,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Predictors/Validation/SineInput.mos"
        "Simulate and plot"),
            experiment(Tolerance=1e-6, StopTime=5270400),
    Documentation(info="<html>
<p>
Model that demonstrates and tests the demand response model.
Input to the model is a sinusoidal consumed electrical power
which has been discretized using a sampler.
Because of this discretization and because of the periodicity
of the input signal, the baseline prediction model will be able to
predict the load exactly.
The baseline prediction model also takes as an input signal
the day type, and a demand response signal.
Every seventh day, there is a demand response signal.
</p>
<p>
After at least one initial working day and non-working days at
which no demand response is requested, the predicted power
<code>client.PPre</code> exactly matches the consumed power
<code>client.PCon</code>.
</p>
<p>
This model has been added to the library to verify and demonstrate the correct implementation
of the baseline prediction model based on a simple input scenario.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2015 by Michael Wetter:<br/>
Implemented <code>Sampler</code> to avoid a translation warning
because <code>Sampler.firstTrigger</code> does not set the <code>fixed</code>
attribute in MSL 3.2.1.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SineInput;
