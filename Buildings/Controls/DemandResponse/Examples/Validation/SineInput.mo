within Buildings.Controls.DemandResponse.Examples.Validation;
model SineInput
  "Demand response client with sinusoidal input for actual power consumption"
  extends
    Buildings.Controls.DemandResponse.Examples.Validation.BaseClasses.PartialSimpleTestCase;
  // fixme: scaling factor for easier debugging
  Modelica.Blocks.Sources.Cosine PCon(
    amplitude=0.5,
    offset=0.5,
    freqHz=1/tPeriod,
    phase=3.1415926535898) "Measured power consumption"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Discrete.Sampler P(samplePeriod=tSample)
    "Sampler to turn PCon into a piece-wise constant signal. This makes it easier to verify the results"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.Constant TOffSet(k=293.15)
    "Offset for outside air temperature"
    annotation (Placement(transformation(extent={{-80,-96},{-60,-76}})));
  Modelica.Blocks.Math.Gain gain(k=10)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Blocks.Continuous.Integrator integrator
    "Integrator to compute energy from power"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(add.u2, TOffSet.y) annotation (Line(
      points={{-2,-86},{-59,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, add.u1) annotation (Line(
      points={{-19,-60},{-12,-60},{-12,-74},{-2,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, baseLoad.TOut) annotation (Line(
      points={{21,-80},{32,-80},{32,-6},{38,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCon.y, P.u) annotation (Line(
      points={{-59,-30},{-42,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P.y, integrator.u) annotation (Line(
      points={{-19,-30},{-2,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, baseLoad.ECon) annotation (Line(
      points={{21,-30},{26,-30},{26,8.88178e-16},{38,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, P.y) annotation (Line(
      points={{-42,-60},{-50,-60},{-50,-44},{-12,-44},{-12,-30},{-19,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                                                    graphics),
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/Validation/SineInput.mos"
        "Simulate and plot"),
            experiment(StopTime=5270400),
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
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SineInput;
