within Buildings.Controls.DemandResponse.BaseClasses;
block BaselinePrediction "Predicts the baseline consumption"
  extends Buildings.Controls.DemandResponse.BaseClasses.PartialDemandResponse;

  parameter Buildings.Controls.DemandResponse.Types.PredictionModel
    predictionModel "Load prediction model";

  parameter Integer nHis(min=1) = 10 "Number of history terms to be stored";

  Modelica.Blocks.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
        iconTransformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.Interfaces.DayTypeInput typeOfDay
    "If true, this day remains an event day until midnight" annotation (
      Placement(transformation(extent={{-120,90},{-100,70}}),
        iconTransformation(extent={{-120,90},{-100,70}})));

  Modelica.Blocks.Interfaces.BooleanInput isEventDay
    "If true, this day remains an event day until midnight"
    annotation (Placement(transformation(extent={{-120,50},{-100,30}}),
        iconTransformation(extent={{-120,50},{-100,30}})));
protected
  Buildings.Controls.DemandResponse.BaselinePrediction basLin(
    final nSam=nSam,
    final nHis=nHis,
    final predictionModel=predictionModel) "Model that computes the base line"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
equation
  connect(basLin.typeOfDay, typeOfDay) annotation (Line(
      points={{-14,10},{-60,10},{-60,80},{-110,80}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(isEventDay, basLin.isEventDay) annotation (Line(
      points={{-110,40},{-64,40},{-64,5},{-14,5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(basLin.ECon, ECon) annotation (Line(
      points={{-14,6.66134e-16},{-62,6.66134e-16},{-62,-50},{-120,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut, basLin.TOut) annotation (Line(
      points={{-120,-90},{-40,-90},{-40,-6},{-14,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(basLin.PPre[1], PPre) annotation (Line(
      points={{9,0},{40,0},{40,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={Text(
          extent={{-70,64},{74,-54}},
          lineColor={0,0,255},
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
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end BaselinePrediction;
