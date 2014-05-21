within Buildings.Controls.DemandResponse.Examples;
model SineInput
  "Demand response client with sinusoidal input for actual power consumption"
  extends Modelica.Icons.Example;
  // fixme: scaling factor for easier debugging
  parameter Modelica.SIunits.Time tPeriod = 24*3600 "Period";
  parameter Modelica.SIunits.Time tSample = 3600 "Sampling period";
  BaselinePrediction baseLoad "Baseload prediction"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  replaceable Modelica.Blocks.Sources.Cosine PCon(
    amplitude=0.5,
    offset=0.5,
    freqHz=1/tPeriod,
    phase=3.1415926535898) constrainedby Modelica.Blocks.Interfaces.SO
    "Measured power consumption"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.BooleanPulse  tri(
    startTime=0.5*tPeriod,
    width=4/24*100/7,
    period=7*tPeriod) "Sample trigger"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Sources.DayType dayType "Outputs the type of the day"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Discrete.Sampler sampler(samplePeriod=tSample)
    "Sampler to turn PCon into a piece-wise constant signal. This makes it easier to verify the results"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(PCon.y, sampler.u) annotation (Line(
      points={{-59,-30},{-42,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler.y, baseLoad.PCon) annotation (Line(
      points={{-19,-30},{0,-30},{0,6.66134e-16},{18,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dayType.y, baseLoad.typeOfDay) annotation (Line(
      points={{-19,10},{18,10}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(baseLoad.isEventDay, tri.y) annotation (Line(
      points={{18,5},{0,5},{0,50},{-19,50}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                                                    graphics),
          __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/SineInput.mos"
        "Simulate and plot"),
            experiment(StopTime=1.8144e+06),
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
