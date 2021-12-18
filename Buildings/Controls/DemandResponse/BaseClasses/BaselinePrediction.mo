within Buildings.Controls.DemandResponse.BaseClasses;
block BaselinePrediction "Predicts the baseline consumption"
  extends Buildings.Controls.DemandResponse.BaseClasses.PartialDemandResponse(nIn=1,
      nOut=1);

  parameter Integer nHis(min=1) = 10 "Number of history terms to be stored";

  Modelica.Blocks.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
  if (predictionModel == Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.Interfaces.DayTypeInput typeOfDay[integer((nPre-1)/nSam)+2] "Type of day for the current and the future days for which a prediction is to be made.
    Typically, this has dimension 2 for predictions up to and including 24 hours, and 2+n for any additional day"
  annotation (
      Placement(transformation(extent={{-120,90},{-100,70}}),
        iconTransformation(extent={{-120,90},{-100,70}})));

  Modelica.Blocks.Interfaces.BooleanInput isEventDay
    "If true, this day remains an event day until midnight"
    annotation (Placement(transformation(extent={{-120,50},{-100,30}}),
        iconTransformation(extent={{-120,50},{-100,30}})));
protected
  Buildings.Controls.Predictors.ElectricalLoad basLin(
    final nSam=nSam,
    final nPre=nPre,
    final nHis=nHis,
    final predictionModel=predictionModel) "Model that computes the base line"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Logical.Not stoHis
    "Boolean signal to set whether history should be stored"
    annotation (Placement(transformation(extent={{-88,-4},{-68,16}})));
equation
  connect(basLin.ECon, ECon) annotation (Line(
      points={{-12,0},{-62,0},{-62,-30},{-120,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut, basLin.TOut) annotation (Line(
      points={{-120,-60},{-40,-60},{-40,-6},{-12,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(basLin.PPre, PPre) annotation (Line(
      points={{11,0},{40,0},{40,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(stoHis.u, isEventDay) annotation (Line(
      points={{-90,6},{-96,6},{-96,40},{-110,40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(stoHis.y, basLin.storeHistory) annotation (Line(
      points={{-67,6},{-40,6},{-40,5},{-12,5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(basLin.typeOfDay, typeOfDay) annotation (Line(
      points={{-12,10},{-60,10},{-60,80},{-110,80}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(basLin.TOutFut, TOutFut) annotation (Line(
      points={{-12,-10},{-36,-10},{-36,-90},{-120,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={Text(
          extent={{-70,64},{74,-54}},
          textColor={0,0,255},
          textString="BL")}),
    Documentation(info="<html>
<p>
Block that computes the baseline for a demand response client.
This implementation computes the 10/10 average baseline.
This baseline is the average of the consumed power of the previous
10 days for the same time interval. For example, if the base line is
computed every 1 hour, then there are 24 baseline values for each day.
Separate baselines are computed for any types of days.
The type of day is an input signal received from the connector
<code>typeOfDay</code>, and must be equal to any value defined
in
<a href=\"modelica://Buildings.Controls.Types.Day\">
Buildings.Controls.Types.Day</a>.
</p>
<p>
If a day is an event day, then any hour of this day after the event signal
is received is excluded from the baseline computation.
Storing history terms for the base line resumes at midnight.
</p>
<p>
If no history term is present for the current time interval and
the current type of day, then the predicted power consumption
<code>PPre</code> will be zero.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BaselinePrediction;
