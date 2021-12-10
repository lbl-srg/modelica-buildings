within Buildings.Controls.Predictors.Validation;
model LinearInput
  "Demand response client with actual power consumption being linear in the temperature"
  extends
    Buildings.Controls.Predictors.Validation.BaseClasses.PartialSimpleTestCase(
     baseLoad(predictionModel=Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression));
  Modelica.Blocks.Sources.Ramp   TOut(
    y(unit="K", displayUnit="degC"),
    offset=283.15,
    height=10,
    duration(displayUnit="h") = 61*24*3600) "Outside temperature"
    annotation (Placement(transformation(extent={{-92,-90},{-72,-70}})));
  Modelica.Blocks.Sources.Constant POffSet(k=1) "Offset for power"
    annotation (Placement(transformation(extent={{-90,-24},{-70,-4}})));
  Modelica.Blocks.Math.Add PCon(k2=0.2) "Consumed power"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Math.UnitConversions.To_degC to_degC
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Blocks.Math.Add err(k2=-1) "Prediction error"
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));
  Sampler TSam(samplePeriod=tSample)
    "Sampler to turn TOut into a piece-wise constant signal. This makes it easier to verify the results"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Blocks.Continuous.Integrator integrator
    "Integrator to compute energy from power"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Sources.RealExpression TOutFut[nPre - 1](each y=293.15)
    if nPre > 1 "Prediction of future outside temperatures"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
equation
  connect(POffSet.y, PCon.u1) annotation (Line(
      points={{-69,-14},{-62,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, TSam.u) annotation (Line(
      points={{-71,-80},{-62,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSam.y, baseLoad.TOut) annotation (Line(
      points={{-39,-80},{28,-80},{28,-6},{58,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCon.y, integrator.u) annotation (Line(
      points={{-39,-20},{-2,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, baseLoad.ECon) annotation (Line(
      points={{21,-20},{24,-20},{24,0},{58,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(err.u2, PCon.y) annotation (Line(
      points={{88,-36},{-28,-36},{-28,-20},{-39,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_degC.u, TSam.y) annotation (Line(
      points={{-22,-60},{-32,-60},{-32,-80},{-39,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_degC.y, PCon.u2) annotation (Line(
      points={{1,-60},{12,-60},{12,-40},{-70,-40},{-70,-26},{-62,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(baseLoad.PPre[1], err.u1) annotation (Line(
      points={{81,0},{84,0},{84,-24},{88,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(baseLoad.TOutFut, TOutFut.y) annotation (Line(
      points={{58,-10},{54,-10},{54,-20},{51,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  experiment(Tolerance=1e-6, StopTime=5270400),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Predictors/Validation/LinearInput.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Controls.Predictors.Validation.SineInput\">
Buildings.Controls.Predictors.Validation.SineInput</a>,
except that the input <code>client.PCon</code> is linear in the temperature.
</p>
<p>
This model has been added to the library to verify and demonstrate the correct implementation
of the baseline prediction model based on a simple input scenario.
Note that in the first day, no prediction is made as no historical data are available.
In the second day, the prediction differs from the actual (linearly increasing) consumption
because only one data point exists for the respective sampling interval, and hence the linear
regression is underdetermined.
In the third day, the prediction starts as correct because two data points exist for each
sampling interval. Later in the third day, there is again a prediction error as the second
day was an event day and hence no data was recorded once the event day signal has been
received and until midnight the same day.
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
March 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            120,100}}), graphics),
    Icon(coordinateSystem(extent={{-100,-100},{120,100}})));
end LinearInput;
