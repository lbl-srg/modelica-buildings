within Buildings.Controls.Predictors.BaseClasses;
partial function partialBaselinePrediction
  "Partial function for baseline load prediction"
  input Modelica.Units.SI.Power P[:]
    "Vector of power consumed in each interval of the current time of day";
    input Integer k "Number of history terms that have already been stored";
  output Modelica.Units.SI.Power y "Baseline power consumption";
  annotation (Documentation(info="<html>
<p>
Partial function that defines the input and output arguments
for the base load predictions.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialBaselinePrediction;
