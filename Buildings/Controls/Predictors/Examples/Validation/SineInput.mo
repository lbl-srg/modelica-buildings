within Buildings.Controls.Predictors.Examples.Validation;
model SineInput
  "Demand response client with sinusoidal input for actual power consumption"
  extends
    Buildings.Controls.Predictors.Examples.Validation.BaseClasses.PartialSimpleTestCase;

  Modelica.Blocks.Sources.Cosine PBas(
    amplitude=0.5,
    offset=0.5,
    freqHz=1/tPeriod,
    phase=3.1415926535898) "Measured power consumption"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
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
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(
    y=if (dayType[1].y == Buildings.Controls.Types.Day.WorkingDay) then 0 else 1)
    annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));
  Modelica.Blocks.Math.Add PCon "Consumed power"
    annotation (Placement(transformation(extent={{-68,-40},{-48,-20}})));
  Modelica.Blocks.Sources.RealExpression TOutFut[nPre - 1](each y=293.15) if
       nPre > 1 "Prediction of future outside temperatures"
    annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
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
      points={{21,-80},{26,-80},{26,-6},{58,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P.y, integrator.u) annotation (Line(
      points={{-19,-30},{-12,-30},{-12,0},{-10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, baseLoad.ECon) annotation (Line(
      points={{13,0},{26,0},{26,8.88178e-16},{58,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u, P.y) annotation (Line(
      points={{-42,-60},{-50,-60},{-50,-44},{-12,-44},{-12,-30},{-19,-30}},
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
  connect(TOutFut.y, baseLoad.TOutFut) annotation (Line(
      points={{53,-20},{54,-20},{54,-10},{58,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                                                    graphics),
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Predictors/Examples/Validation/SineInput.mos"
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
